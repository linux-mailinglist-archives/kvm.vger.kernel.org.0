Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC754AF76F
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbiBIRBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237674AbiBIRAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:00:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE300C05CB8A
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1FNh7pkHY41jFWmZFdVN600EQqaJlF1A+HaHz0XISvI=;
        b=g69tFctEqKOBTb+dhc3dxSdte1herpcLLpe/t2UWB3wBQP5/eQDNqULiF2N4IltTSp/CTe
        24rvCffgC0sK/V5QjJddFzV/DC1ynZsQW9hcnLxLFL2GvpLAbFucuta+pqjLxBafF1qGu4
        mtMCNVjGAAHk7HUdBR4GEsfve+pt5e0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-bhh_Xgj_PXqfi1V8wlP2YA-1; Wed, 09 Feb 2022 12:00:54 -0500
X-MC-Unique: bhh_Xgj_PXqfi1V8wlP2YA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7C2718397A7;
        Wed,  9 Feb 2022 17:00:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B8BD7CD66;
        Wed,  9 Feb 2022 17:00:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com,
        seanjc@google.com
Subject: [PATCH 06/12] KVM: MMU: rename kvm_mmu_reload
Date:   Wed,  9 Feb 2022 12:00:14 -0500
Message-Id: <20220209170020.1775368-7-pbonzini@redhat.com>
In-Reply-To: <20220209170020.1775368-1-pbonzini@redhat.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The name of kvm_mmu_reload is very confusing for two reasons:
first, KVM_REQ_MMU_RELOAD actually does not call it; second,
it only does anything if there is no valid root.

Rename it to kvm_mmu_ensure_valid_root, which matches the actual
behavior better.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h | 2 +-
 arch/x86/kvm/x86.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index b9d06a218b2c..c9f1c2162ade 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -104,7 +104,7 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
 
-static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
+static inline int kvm_mmu_ensure_valid_root(struct kvm_vcpu *vcpu)
 {
 	if (likely(vcpu->arch.mmu->root_hpa != INVALID_PAGE))
 		return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 98aca0f2af12..2685fb62807e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9976,7 +9976,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	r = kvm_mmu_reload(vcpu);
+	r = kvm_mmu_ensure_valid_root(vcpu);
 	if (unlikely(r)) {
 		goto cancel_injection;
 	}
@@ -12164,7 +12164,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	      work->wakeup_all)
 		return;
 
-	r = kvm_mmu_reload(vcpu);
+	r = kvm_mmu_ensure_valid_root(vcpu);
 	if (unlikely(r))
 		return;
 
-- 
2.31.1


