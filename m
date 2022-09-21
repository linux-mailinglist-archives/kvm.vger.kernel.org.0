Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEE65C0559
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiIURgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiIURgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:36:01 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC2AA284E
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:35:59 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-34d2a92912dso51660247b3.14
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=u9Vd7tEftAXGnn44yUXAC5/iP4NUEzzbRwz1C9sd3AM=;
        b=Dq0oBkbV0SXCGqzsyxWdldJ7YHX5uJaKIjTNpE0p5AL79Lw7oi1OVU5qi7ftVs1xlI
         wVxpyBHimWgbY6934ayFcoKOmgbzmGoXQ0TG1pXAziPIm/PCstD20Xh3grqKMa6YU92G
         6j2TxXfOHT+/bOcpymSF9IZg4vpcXd/dl/u3Xcizf7gEHpiqvAiCX1NjVTnBSYvfzFFw
         b53fSf7Kd0B38dB+Y1trsRHOwL5CJSfJ8rQgy1d/wDd6b1FxIHYbSGLPv30zxqaFVV47
         eAjS/H81p/lyYsY2DIsl6GmoQGV6aZ/vRe6Re1Xl8dwU39IYhW9Lb6Nh6mL3+ev78FXU
         ygkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=u9Vd7tEftAXGnn44yUXAC5/iP4NUEzzbRwz1C9sd3AM=;
        b=36yHKzQBWO12T8nxCYerMaXfVPsOx9yTM7TVpPP04n2TlT4ZZ8IFAOzYzbQscJmibi
         /KzdMT7PI4pmRfxJiUFeV4AGyFLYlfxkYWCCOql7Zv82HXnDo6598uXBoCbXurZqDyUC
         w+jkJLONTDm7IQqLwrk8NVB8IzKx0fY8KAOh5YcCOjBdgHr361Wi7fXFo0Xa0gSzmi4D
         btEC5LSIcAsoLBPyYCaAsdJrkcQYVS+PASkmNpoDZVbEDnCPXzGDkXH0mqY8vjPmIOsk
         AK0AICFV3z5jcRFOb1IEj01+3RTeapf27SPoxmcNFT2Sgos8Bh6L8whXjEccKdMXy97N
         y9eA==
X-Gm-Message-State: ACrzQf3AVLDfvfy998VZWm3cOvZBNCbA3d3YhAxZsdXjHTN4dgitT/FU
        o/7b5J4QzJpKe/Y5E5nFy9+p04PHbNiuXg==
X-Google-Smtp-Source: AMsMyM7oLccIpi/v9qxwUmkDHcoe7hvxKAxsSIsxf98wh7AFTsFgbj85fMjja/3DvqPY106yVhT6ms4qRN+50A==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:c6c7:0:b0:33d:c81b:fd14 with SMTP id
 i190-20020a0dc6c7000000b0033dc81bfd14mr24325445ywd.286.1663781758584; Wed, 21
 Sep 2022 10:35:58 -0700 (PDT)
Date:   Wed, 21 Sep 2022 10:35:40 -0700
In-Reply-To: <20220921173546.2674386-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220921173546.2674386-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220921173546.2674386-5-dmatlack@google.com>
Subject: [PATCH v3 04/10] KVM: x86/mmu: Handle error PFNs in kvm_faultin_pfn()
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

Handle error PFNs in kvm_faultin_pfn() rather than relying on the caller
to invoke handle_abnormal_pfn() after kvm_faultin_pfn().
Opportunistically rename kvm_handle_bad_page() to kvm_handle_error_pfn()
to make it more consistent with is_error_pfn().

This commit moves KVM closer to being able to drop
handle_abnormal_pfn(), which will reduce the amount of duplicate code in
the various page fault handlers.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 31b835d20762..49a5e38ecc5c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3141,7 +3141,7 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, PAGE_SHIFT, tsk);
 }
 
-static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
+static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 {
 	/*
 	 * Do not cache the mmio info caused by writing the readonly gfn
@@ -3162,10 +3162,6 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			       unsigned int access)
 {
-	/* The pfn is invalid, report the error! */
-	if (unlikely(is_error_pfn(fault->pfn)))
-		return kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
-
 	if (unlikely(!fault->slot)) {
 		gva_t gva = fault->is_tdp ? 0 : fault->addr;
 
@@ -4187,10 +4183,19 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+	int ret;
+
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	return __kvm_faultin_pfn(vcpu, fault);
+	ret = __kvm_faultin_pfn(vcpu, fault);
+	if (ret != RET_PF_CONTINUE)
+		return ret;
+
+	if (unlikely(is_error_pfn(fault->pfn)))
+		return kvm_handle_error_pfn(vcpu, fault->gfn, fault->pfn);
+
+	return RET_PF_CONTINUE;
 }
 
 /*
-- 
2.37.3.998.g577e59143f-goog

