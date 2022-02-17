Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F6A4BAB83
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 22:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbiBQVE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 16:04:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244224AbiBQVEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 16:04:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E64615DDE6
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 13:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645131833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81CUj4DjODMnVGrRe0STdd54o6R4Y7aXMKzbSnkZtJE=;
        b=Swl7IyhU0ERxkZ8tp5usoCgWX2ozeeiDrZiLi9CmOTNVW6TKo+LiunIhTVGbdFysJR+nOd
        5xf+9BgIraYKCdvm/NvmBXvpyP012HkvjyB8SExrAOZlCSUHpK/9hX8S5B3yCM/mjvZ4br
        gUj6n2T+0Mk1O8/Lfg2I2EiVIcQ4gLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-XlrGCRQfPPKL-v2OHu4MxA-1; Thu, 17 Feb 2022 16:03:50 -0500
X-MC-Unique: XlrGCRQfPPKL-v2OHu4MxA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12240801ADB;
        Thu, 17 Feb 2022 21:03:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6F4C6ABA4;
        Thu, 17 Feb 2022 21:03:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 16/18] KVM: x86: introduce KVM_REQ_MMU_UPDATE_ROOT
Date:   Thu, 17 Feb 2022 16:03:38 -0500
Message-Id: <20220217210340.312449-17-pbonzini@redhat.com>
In-Reply-To: <20220217210340.312449-1-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Whenever KVM knows the page role flags have changed, it needs to drop
the current MMU root and possibly load one from the prev_roots cache.
Currently it is papering over some overly simplistic code by just
dropping _all_ roots, so that the root will be reloaded by
kvm_mmu_reload, but this has bad performance for the TDP MMU
(which drops the whole of the page tables when freeing a root,
without the performance safety net of a hash table).

To do this, KVM needs to do a more kvm_mmu_update_root call from
kvm_mmu_reset_context.  Introduce a new request bit so that the call
can be delayed until after a possible KVM_REQ_MMU_RELOAD, which would
kill all hopes of finding a cached PGD.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/nested.c       |  2 +-
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/x86.c              | 13 +++++++++++--
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 319ac0918aa2..532cda546eb9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -102,6 +102,7 @@
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
 #define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_MMU_UPDATE_ROOT		KVM_ARCH_REQ(31)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2386fadae9ed..8e6e62d8df36 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -498,7 +498,7 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	kvm_init_mmu(vcpu);
 
 	if (!nested_npt)
-		kvm_mmu_update_root(vcpu);
+		kvm_make_request(KVM_REQ_MMU_UPDATE_ROOT, vcpu);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2dbd7a9ada84..c3595bc0a02d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1133,7 +1133,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	kvm_init_mmu(vcpu);
 
 	if (!nested_ept)
-		kvm_mmu_update_root(vcpu);
+		kvm_make_request(KVM_REQ_MMU_UPDATE_ROOT, vcpu);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9800c8883a48..9043548e6baf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1189,7 +1189,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		return 1;
 
 	if (cr3 != kvm_read_cr3(vcpu))
-		kvm_mmu_update_root(vcpu);
+		kvm_make_request(KVM_REQ_MMU_UPDATE_ROOT, vcpu);
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
@@ -9835,8 +9835,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 				goto out;
 			}
 		}
-		if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
+		if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu)) {
 			kvm_mmu_unload(vcpu);
+
+			/*
+			 * Dropping all roots leaves no hope for loading a cached
+			 * one.  Let kvm_mmu_reload build a new one.
+			 */
+			kvm_clear_request(KVM_REQ_MMU_UPDATE_ROOT, vcpu);
+		}
 		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
 			__kvm_migrate_timers(vcpu);
 		if (kvm_check_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu))
@@ -9848,6 +9855,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			if (unlikely(r))
 				goto out;
 		}
+		if (kvm_check_request(KVM_REQ_MMU_UPDATE_ROOT, vcpu))
+			kvm_mmu_update_root(vcpu);
 		if (kvm_check_request(KVM_REQ_MMU_SYNC, vcpu))
 			kvm_mmu_sync_roots(vcpu);
 		if (kvm_check_request(KVM_REQ_LOAD_MMU_PGD, vcpu))
-- 
2.31.1


