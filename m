Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC8A607B13
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiJUPh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiJUPgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:36:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5028926D92A
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666366595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NTZgRl5rgACD9+VWGUisahxCG4LNBN8j1dAJ4aXMwc=;
        b=WvZWrTAF21HkdY8yXWz7JLeb+w9IWxHO2gYmD36t/B8c9BHra57SA5zvQYEr0Yh6brhlNW
        PR0A+ybfc9JmXdBbMerahivS+CJWGs/wNcfavwi2bTs0JX+9+5YkJiUp1wEInevD0cL/Jh
        n/5XwyrnGZ87p8TIWOe5gN3zRpZmPvo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-c6s2Fb-tMfSIOkXTs2JMWQ-1; Fri, 21 Oct 2022 11:36:32 -0400
X-MC-Unique: c6s2Fb-tMfSIOkXTs2JMWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B38AF3C1E721;
        Fri, 21 Oct 2022 15:36:31 +0000 (UTC)
Received: from ovpn-192-65.brq.redhat.com (ovpn-192-65.brq.redhat.com [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7EEA40CA41F;
        Fri, 21 Oct 2022 15:36:29 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 27/46] KVM: x86: Make kvm_hv_get_assist_page() return 0/-errno
Date:   Fri, 21 Oct 2022 17:35:02 +0200
Message-Id: <20221021153521.1216911-28-vkuznets@redhat.com>
In-Reply-To: <20221021153521.1216911-1-vkuznets@redhat.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert kvm_hv_get_assist_page() to return 'int' and propagate possible
errors from kvm_read_guest_cached().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c     | 8 ++++----
 arch/x86/kvm/hyperv.h     | 2 +-
 arch/x86/kvm/vmx/hyperv.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 90f37e58a9ed..404e1a968b02 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -900,15 +900,15 @@ bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_hv_assist_page_enabled);
 
-bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu)
+int kvm_hv_get_assist_page(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
 	if (!hv_vcpu || !kvm_hv_assist_page_enabled(vcpu))
-		return false;
+		return -EFAULT;
 
-	return !kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_eoi.data,
-				      &hv_vcpu->vp_assist_page, sizeof(struct hv_vp_assist_page));
+	return kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_eoi.data,
+				     &hv_vcpu->vp_assist_page, sizeof(struct hv_vp_assist_page));
 }
 EXPORT_SYMBOL_GPL(kvm_hv_get_assist_page);
 
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 81313e418b80..5157622c2fb3 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -108,7 +108,7 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
 void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu);
 
 bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu);
-bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu);
+int kvm_hv_get_assist_page(struct kvm_vcpu *vcpu);
 
 static inline struct kvm_vcpu_hv_stimer *to_hv_stimer(struct kvm_vcpu *vcpu,
 						      int timer_index)
diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
index 04a0bba58c7d..ae03d1fe0355 100644
--- a/arch/x86/kvm/vmx/hyperv.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -326,7 +326,7 @@ u64 nested_get_evmptr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
-	if (unlikely(!kvm_hv_get_assist_page(vcpu)))
+	if (unlikely(kvm_hv_get_assist_page(vcpu)))
 		return EVMPTR_INVALID;
 
 	if (unlikely(!hv_vcpu->vp_assist_page.enlighten_vmentry))
-- 
2.37.3

