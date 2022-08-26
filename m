Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFDC5A326A
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 01:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345472AbiHZXM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 19:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345462AbiHZXMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 19:12:54 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783E8EA15E
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:49 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33dce8cae71so47462897b3.8
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=AVYzpP9SQOKhSSSBUzsWiGl4yuBhwPekHC7JWeKXREI=;
        b=Yrf8rRq/eon11p5t9Ulb1jGGrlSx+nSm3Du8oXVtXZsBtxduOh2OJGWi8rZlRhfDDb
         L/N2mtfyulOhx9n77fKS+dzTMa/JvGmPnAKj/0SJCPUydtxopeTUzKYqM/iYFGwcYcBp
         sHC77T0dBO8U1sMjeggPsA8GNd83QNKl0mS85YXLTTu06CsqtLRTPGJ0WSwMz4i+DgMn
         wAWAkXcUaQ92moBON8/yPzMAtZ/c/b7Zp4xIO2tBHikbd+APLPOxdK7aB2o0+8kB7DDw
         9kn3iKz2H7YmTrejvCXb40IBpY4H+o60IO0hOclechx4j/x8E4/ZfOlwgAFicmWVtT/6
         nffA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=AVYzpP9SQOKhSSSBUzsWiGl4yuBhwPekHC7JWeKXREI=;
        b=ApmPcvYwk1BX4qlEcxz9V2t50CUkUFWQ42GVnLi1I1OdIeEnI+C1Y1jtSo7JvBtpGL
         8ZAkBuxnVVBuJAclfoulqQ1KlG8oP1HIGMcZFEY/okJqvAy0WuZ8WNF4szCUmDLNJi2+
         7t6laodHM/Js9zTnn0jkC9aFFdXe2E/orad7xAWnQVjRRR/Ax/f8d0PKB+MPMequ/ta0
         yN+W1n3fdsXZV9GZWGl+v3ioHlZSy/uCoxWcINDMJM0Is45uiUf0v+emYx/rzfQTvsuv
         IIhwI7RrTgYI4vfdLicB96DMBvYipbimgpQ6oNYs5RYGqIyFTxm4XeaaznGNUFxmvNyz
         SVQw==
X-Gm-Message-State: ACgBeo0XtspjS0d5QRwFf0/tnIxUShIs4qtBAqbf4bO9GYf22lf6/27w
        34tyybtsGGFHvOqt1R/qKHZGqm9dRP+rNA==
X-Google-Smtp-Source: AA6agR7m34Rtgwk6vDLmffsUvRs5l3AjI7VFVCYydONJ0pF3u6CoQhT/AjGiSrZINtuXbEA7ihEMcyZ4CIHS5w==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:5c43:0:b0:328:b796:654f with SMTP id
 q64-20020a815c43000000b00328b796654fmr2016573ywb.18.1661555567710; Fri, 26
 Aug 2022 16:12:47 -0700 (PDT)
Date:   Fri, 26 Aug 2022 16:12:25 -0700
In-Reply-To: <20220826231227.4096391-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826231227.4096391-9-dmatlack@google.com>
Subject: [PATCH v2 08/10] KVM: x86/mmu: Split out TDP MMU page fault handling
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
index a185599f4d1d..8f124a23ab4c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4242,7 +4242,6 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 	int r;
 
 	if (page_fault_handle_page_track(vcpu, fault))
@@ -4261,11 +4260,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
@@ -4274,16 +4269,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
@@ -4331,6 +4320,46 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 }
 EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
+#ifdef CONFIG_X86_64
+int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
+			   struct kvm_page_fault *fault)
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
@@ -4355,6 +4384,11 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
2.37.2.672.g94769d06f0-goog

