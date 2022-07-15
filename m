Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BE3576A4B
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 01:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiGOXAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 19:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiGOXA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 19:00:28 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFF44E858
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:00:27 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id i15-20020a17090a2a0f00b001ef826b921dso3604339pjd.5
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qyJeBdXwF5dNNWMBDELyZ0rPk0zOo8cNBsAR84NI3Pc=;
        b=s9nFvsxyVGJKS1GkkPlQocaGQPmzqZ8uonf6tpQY6iPa8ARVd585TI3w+2MAYJChA6
         RL8d3MEoa4I/hstCMnfcU73XTiSG9gtZ4upagsnWDVM6B5KevwWwwSPCGqYRrtcSdRnw
         Foh0IHfWfS2P5NERSQOrvWXjXllKqbvD5mjBoawU6eGxdc194RqjecJKFmBAl8JQuMmA
         uj6mJb3MhGsGETgB2WJn5DSmZkZv1p8LRakMXhYPd6QzzyvZOyQts7GIuwB6/jKgCdtI
         JcTfbAOBThkzGrTnkEaSsVcPmzYsTXvyNEvGauh13geubQFqttp8ZimYmHjPdSvIDVDZ
         x6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qyJeBdXwF5dNNWMBDELyZ0rPk0zOo8cNBsAR84NI3Pc=;
        b=q4ASv5dSaOpdxXWcQ5TEt4LpzgDiVw9XEMv7YpYSy+m0u6XQond+WnFCo6T2asPyAl
         JckwyjwJuw5MNIwM7PEjuKDaTgFcWBA3o1chQBjQZga94b8ZHRWfGm7LQr2M3dx9vi9l
         svpzZOnm1pxOpx2SQv7bOS6UT6l4rvf9HxfhMR+I60kCNaJIV38qPw5bvh2lvo+M2oK6
         03+WDCgJxBcyFnCbR7qPhu22yp1EQNU9cqYZj7YZ3H9vWx8tXDNKKL2W9OyEneKhUuNp
         oEYEE2PgGC+LMXdFtV+IzORC5Rb5lRTTK3jet0R5POGDg2L64JWBJxmPZFIvO6YPZsXb
         jE+Q==
X-Gm-Message-State: AJIora/3GvzSiKOLP7YUvIy99TjXymA7jzAFJ7MQ3J4cnd3n5CwTWzvR
        c7zhssNnRMRn6SC4LXzvMdgP9P55dwU=
X-Google-Smtp-Source: AGRyM1sOQH8hQ8hf4xM2w/u1OrR0ibxbHFPEKSoDDrbPxn2n+mONs5jxdLyEZrumJUwzh4RWPB/CyyZIFsk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:181:b0:1ef:c348:6835 with SMTP id
 t1-20020a17090b018100b001efc3486835mr913262pjs.1.1657926026078; Fri, 15 Jul
 2022 16:00:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 23:00:16 +0000
In-Reply-To: <20220715230016.3762909-1-seanjc@google.com>
Message-Id: <20220715230016.3762909-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220715230016.3762909-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH 4/4] KVM: x86/mmu: Restrict mapping level based on guest MTRR
 iff they're used
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restrict the mapping level for SPTEs based on the guest MTRRs if and only
if KVM may actually use the guest MTRRs to compute the "real" memtype.
For all forms of paging, guest MTRRs are purely virtual in the sense that
they are completely ignored by hardware, i.e. they affect the memtype
only if software manually consumes them.  The only scenario where KVM
consumes the guest MTRRs is when shadow_memtype_mask is non-zero and the
guest has non-coherent DMA, in all other cases KVM simply leaves the PAT
field in SPTEs as '0' to encode WB memtype.

Note, KVM may still ultimately ignore guest MTRRs, e.g. if the backing
pfn is host MMIO, but false positives are ok as they only cause a slight
performance blip (unless the guest is doing weird things with its MTRRs,
which is extremely unlikely).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 52664c3caaab..82f38af06f5c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4295,14 +4295,26 @@ EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	while (fault->max_level > PG_LEVEL_4K) {
-		int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
-		gfn_t base = (fault->addr >> PAGE_SHIFT) & ~(page_num - 1);
+	/*
+	 * If the guest's MTRRs may be used to compute the "real" memtype,
+	 * restrict the mapping level to ensure KVM uses a consistent memtype
+	 * across the entire mapping.  If the host MTRRs are ignored by TDP
+	 * (shadow_memtype_mask is non-zero), and the VM has non-coherent DMA
+	 * (DMA doesn't snoop CPU caches), KVM's ABI is to honor the memtype
+	 * from the guest's MTRRs so that guest accesses to memory that is
+	 * DMA'd aren't cached against the guest's wishes.
+	 *
+	 * Note, KVM may still ultimately ignore guest MTRRs for certain PFNs,
+	 * e.g. KVM will force UC memtype for host MMIO.
+	 */
+	if (shadow_memtype_mask && kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
+		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
+			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
+			gfn_t base = (fault->addr >> PAGE_SHIFT) & ~(page_num - 1);
 
-		if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
-			break;
-
-		--fault->max_level;
+			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
+				break;
+		}
 	}
 
 	return direct_page_fault(vcpu, fault);
-- 
2.37.0.170.g444d1eabd0-goog

