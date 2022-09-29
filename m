Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49725EFBCB
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 19:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbiI2RUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 13:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236062AbiI2RUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 13:20:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66016106A03
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 10:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664472022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KFAVXrLN49dGEBr0YRB0q2JyXeS3lFNZZHCKn5oH+nw=;
        b=YbLAr0Y3i6s9ZMV0W3elWimhwcAfU958lC53pISVOro+9ijAxHRGS4hDNpvsgROIhfX7TZ
        w8BEVZAP53ZBvDWnPk5Sbvx5R3jxigAE9nJ9P2iRW46s+/EJUEOCeQygZm0Fey9OqgBQIP
        4l5q9wlmkpJMSIewSahZO+Jy6gQQRC0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-f8ITBusQOhKh44YuS7MHYg-1; Thu, 29 Sep 2022 13:20:18 -0400
X-MC-Unique: f8ITBusQOhKh44YuS7MHYg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F7D5811E87;
        Thu, 29 Sep 2022 17:20:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C7BE42222;
        Thu, 29 Sep 2022 17:20:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, maciej.szmigiero@oracle.com
Subject: [PATCH v2 8/8] KVM: x86: do not define KVM_REQ_SMI if SMM disabled
Date:   Thu, 29 Sep 2022 13:20:16 -0400
Message-Id: <20220929172016.319443-9-pbonzini@redhat.com>
In-Reply-To: <20220929172016.319443-1-pbonzini@redhat.com>
References: <20220929172016.319443-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This ensures that all the relevant code is compiled out, in fact
the process_smi stub can be removed too.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/smm.h              | 1 -
 arch/x86/kvm/x86.c              | 6 ++++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d11697504471..d58d4a62b227 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -81,7 +81,9 @@
 #define KVM_REQ_NMI			KVM_ARCH_REQ(9)
 #define KVM_REQ_PMU			KVM_ARCH_REQ(10)
 #define KVM_REQ_PMI			KVM_ARCH_REQ(11)
+#ifdef CONFIG_KVM_SMM
 #define KVM_REQ_SMI			KVM_ARCH_REQ(12)
+#endif
 #define KVM_REQ_MASTERCLOCK_UPDATE	KVM_ARCH_REQ(13)
 #define KVM_REQ_MCLOCK_INPROGRESS \
 	KVM_ARCH_REQ_FLAGS(14, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index 7ccce6b655ca..a6795b93ba30 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -28,7 +28,6 @@ void process_smi(struct kvm_vcpu *vcpu);
 static inline int kvm_inject_smi(struct kvm_vcpu *vcpu) { return -ENOTTY; }
 static inline bool is_smm(struct kvm_vcpu *vcpu) { return false; }
 static inline void kvm_smm_changed(struct kvm_vcpu *vcpu, bool in_smm) { WARN_ON_ONCE(1); }
-static inline void process_smi(struct kvm_vcpu *vcpu) { WARN_ON_ONCE(1); }
 
 /*
  * emulator_leave_smm is used as a function pointer, so the
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e22184bad92b..ba5661ee3fd7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5020,8 +5020,10 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 
 	process_nmi(vcpu);
 
+#ifdef CONFIG_KVM_SMM
 	if (kvm_check_request(KVM_REQ_SMI, vcpu))
 		process_smi(vcpu);
+#endif
 
 	/*
 	 * KVM's ABI only allows for one exception to be migrated.  Luckily,
@@ -10194,8 +10196,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 		if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
 			record_steal_time(vcpu);
+#ifdef CONFIG_KVM_SMM
 		if (kvm_check_request(KVM_REQ_SMI, vcpu))
 			process_smi(vcpu);
+#endif
 		if (kvm_check_request(KVM_REQ_NMI, vcpu))
 			process_nmi(vcpu);
 		if (kvm_check_request(KVM_REQ_PMU, vcpu))
@@ -12539,7 +12543,9 @@ bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
 		return true;
 
 	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
+#ifdef CONFIG_KVM_SMM
 		kvm_test_request(KVM_REQ_SMI, vcpu) ||
+#endif
 		 kvm_test_request(KVM_REQ_EVENT, vcpu))
 		return true;
 
-- 
2.31.1

