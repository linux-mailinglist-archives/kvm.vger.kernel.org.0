Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08555C055D
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiIURgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiIURgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:36:08 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07761A2A8E
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:36:06 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w14-20020a170902e88e00b00177ab7a12f6so4222338plg.16
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=NbdSnnVdKrecJYzgj3EcDEMjA4TBlJiInTSVtVLHPsA=;
        b=FzuUCcZ+EeNxo/gJXH++HMOi9qXMoCPN4pHXp74cexRNGqmYhXEHX+8M675UP8wTX/
         b3aDUGxg61F/QDNMD9Oe9YPUKtRhtST/VlW49w+HQAPKVf71VXQ2RBZzrkrSSJKyHfMT
         By6BhtsODCDPfLi9Fm/SMec6U6agy0Su9oET/fa/7x4+8m1xkVhfM2lxz3J2NqC6VJn/
         0PFJymuVygGq6Dizo1YHVopWBj9Z6Q+iULIPVPTGLGdOQNYZK7/hVMORqSX6cqDp6jIY
         HF2dGs07N6H6671O4ywjjLF8q6y1TktFw3pxsIbWl4ilh+xf+ahKxNnZE6pfRVPtrrVq
         kebg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=NbdSnnVdKrecJYzgj3EcDEMjA4TBlJiInTSVtVLHPsA=;
        b=YJJM0ERuJP0kkJnGA/Gvkg8qVAEYWZ9DYm8uGJLFii6d4Hz61sY7hJR8sU2TEUFBFs
         lJ3deVPB5qdhcaNegYghapeiLlgy5/zHv7MgPGMDxA94hM+v5pkfJiYBo2cAjGcNn6d7
         ntmHiLgpOHUz3klFZ++iqrtzzipBJTy0fIZbmfKlHfv+/A1XMII4lIO1f2KbAyTN3K8l
         MM6QvkU0qDrwVJviUYV2ZRXAGuUCT+yEz5y9lSObw9uBoN/+yH2y0y5sIh+H3950+OyL
         8OOdWpapVci756yVmBCKHmL0CL3qLweAbAKXB9ZHylTE3jbUJ33+Ib1saQ3/9xC8Z8RC
         NEFw==
X-Gm-Message-State: ACrzQf1qj7M/VGROxZFi0dmudIWRFOmU2yTshKeWabQBPM7Np+soG+N4
        KVwLaaL1TTUn9XjA2UJvFMe9Gy2eh8yZ6A==
X-Google-Smtp-Source: AMsMyM4mV+g/KY/H/1REw+zg+zdOi360aTtZ7ro7oqdrh+AZca6wmtXF4m/MtEVn+ZPxHvr3RSXMjB8xQnYuWA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:21c2:b0:52b:ff44:6680 with SMTP
 id t2-20020a056a0021c200b0052bff446680mr30194202pfj.57.1663781765255; Wed, 21
 Sep 2022 10:36:05 -0700 (PDT)
Date:   Wed, 21 Sep 2022 10:35:44 -0700
In-Reply-To: <20220921173546.2674386-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220921173546.2674386-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220921173546.2674386-9-dmatlack@google.com>
Subject: [PATCH v3 08/10] KVM: x86/mmu: Split out TDP MMU page fault handling
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split out the page fault handling for the TDP MMU to a separate
function.  This creates some duplicate code, but makes the TDP MMU fault
handler simpler to read by eliminating branches and will enable future
cleanups by allowing the TDP MMU and non-TDP MMU fault paths to diverge.

Only compile in the TDP MMU fault handler for 64-bit builds since
kvm_tdp_mmu_map() does not exist in 32-bit builds.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 62 ++++++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dc203973de83..b36f351138f7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4238,7 +4238,6 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 	int r;
 
 	if (page_fault_handle_page_track(vcpu, fault))
@@ -4257,11 +4256,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return r;
 
 	r = RET_PF_RETRY;
-
-	if (is_tdp_mmu_fault)
-		read_lock(&vcpu->kvm->mmu_lock);
-	else
-		write_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 
 	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
@@ -4270,16 +4265,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		goto out_unlock;
 
-	if (is_tdp_mmu_fault)
-		r = kvm_tdp_mmu_map(vcpu, fault);
-	else
-		r = __direct_map(vcpu, fault);
+	r = __direct_map(vcpu, fault);
 
 out_unlock:
-	if (is_tdp_mmu_fault)
-		read_unlock(&vcpu->kvm->mmu_lock);
-	else
-		write_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
@@ -4327,6 +4316,46 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 }
 EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
+#ifdef CONFIG_X86_64
+static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
+				  struct kvm_page_fault *fault)
+{
+	int r;
+
+	if (page_fault_handle_page_track(vcpu, fault))
+		return RET_PF_EMULATE;
+
+	r = fast_page_fault(vcpu, fault);
+	if (r != RET_PF_INVALID)
+		return r;
+
+	r = mmu_topup_memory_caches(vcpu, false);
+	if (r)
+		return r;
+
+	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
+	if (r != RET_PF_CONTINUE)
+		return r;
+
+	r = RET_PF_RETRY;
+	read_lock(&vcpu->kvm->mmu_lock);
+
+	if (is_page_fault_stale(vcpu, fault))
+		goto out_unlock;
+
+	r = make_mmu_pages_available(vcpu);
+	if (r)
+		goto out_unlock;
+
+	r = kvm_tdp_mmu_map(vcpu, fault);
+
+out_unlock:
+	read_unlock(&vcpu->kvm->mmu_lock);
+	kvm_release_pfn_clean(fault->pfn);
+	return r;
+}
+#endif
+
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	/*
@@ -4351,6 +4380,11 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 	}
 
+#ifdef CONFIG_X86_64
+	if (tdp_mmu_enabled)
+		return kvm_tdp_mmu_page_fault(vcpu, fault);
+#endif
+
 	return direct_page_fault(vcpu, fault);
 }
 
-- 
2.37.3.998.g577e59143f-goog

