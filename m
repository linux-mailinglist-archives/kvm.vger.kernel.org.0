Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6B059523F
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 07:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiHPFyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 01:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiHPFxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 01:53:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E831F857C5
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:33 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-32e6a92567bso80299487b3.10
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=dbEjZYNN1KQEmwyUXUywUn8T3TVLon0A4zT83JcFFGQ=;
        b=iTa2SBI4jqIaJzb1IVwW5rpp0RYxXUeqdh/3doABJThVgktMEZz4r4zk87GdMrzS/e
         omR31um4/6YOAIgLXa5sdKcgp/Mgac3hkFlAHGeCMI1LH81+b5WwXvM/H/OtM3ppYJBn
         7H+SlLCsKqVjMVYgqYZjHYSKFf/Bj6Cg2M0396ldSlJJJdUUnEKAD+qvbI4eeaky60vh
         PpdOTbwltpVR+PreJ1bkl4twWpV2GYKWjj9xsveRFYO+xpkQ5X9Hqusog81bD39+ZMIy
         g8QwCLLC3wo12f0ZPTIc4ETKOE36PyhImKaEUABBf3/XMhnfV5OIKU7iiYJY0dPoGF5B
         P5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=dbEjZYNN1KQEmwyUXUywUn8T3TVLon0A4zT83JcFFGQ=;
        b=PV9OvEDrULsSN75brfeAiYa/7layejSMuoBy1s+BcxaJuc7cSqIzxXlu8prCYNSk6K
         e3WEf/wqutDaNNy1GgeZsWTJ0pat+rUbg7FPLmEjV1ol0wVqQq35ONQBY6W5rZJYihvF
         IvNeHbIjFpeypyDLf6+0ey34/X5/58DM+hHz0AbHk9F8SaWWH0wefwUVtsoanALTI5y2
         orl0CoQx0r4xZYdTUUfHIMV2wngpt4CpAl8qQCZpl2Sh4A20zPDNRvff94b+OtQdJE3S
         FDhbmLrjKm/JSKqJbfMR3YGXWati5OOlGCRLd1V3IA6YgHdbwmAaiBNyK3PF/Pl0GphL
         TgSg==
X-Gm-Message-State: ACgBeo37doT8+OuW9z4MtUtZZETN1HzUj8t87cS61SlCRy32zu1R6iwz
        5nTeQLA5JSvAT+ZanSaItfde3hfuxasiGA==
X-Google-Smtp-Source: AA6agR4bkKLylt1V24e8eZ7xq6k7O9vt2/T7GuahR5Vw5x4165J0dgka54N8iVU81xZc8OpCV/1kCJWXn9sUhA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:5288:0:b0:332:a114:faa1 with SMTP id
 g130-20020a815288000000b00332a114faa1mr2685541ywb.26.1660604493247; Mon, 15
 Aug 2022 16:01:33 -0700 (PDT)
Date:   Mon, 15 Aug 2022 16:01:10 -0700
In-Reply-To: <20220815230110.2266741-1-dmatlack@google.com>
Message-Id: <20220815230110.2266741-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 9/9] KVM: x86/mmu: Try to handle no-slot faults during kvm_faultin_pfn()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Try to handle faults on GFNs that do not have a backing memslot during
kvm_faultin_pfn(), rather than relying on the caller to call
handle_abnormal_pfn() right after kvm_faultin_pfn(). This reduces all of
the page fault paths by eliminating duplicate code.

Opportunistically tweak the comment about handling gfn > host.MAXPHYADDR
to reflect that the effect of returning RET_PF_EMULATE at that point is
to avoid creating an MMIO SPTE for such GFNs.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 55 +++++++++++++++++-----------------
 arch/x86/kvm/mmu/paging_tmpl.h |  4 ---
 2 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 47f4d1e81db1..741b92b1f004 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3154,28 +3154,32 @@ static int kvm_handle_error_pfn(struct kvm_page_fault *fault)
 	return -EFAULT;
 }
 
-static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
-			       unsigned int access)
+static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
+				   struct kvm_page_fault *fault,
+				   unsigned int access)
 {
-	if (unlikely(!fault->slot)) {
-		gva_t gva = fault->is_tdp ? 0 : fault->addr;
+	gva_t gva = fault->is_tdp ? 0 : fault->addr;
 
-		vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
-				     access & shadow_mmio_access_mask);
-		/*
-		 * If MMIO caching is disabled, emulate immediately without
-		 * touching the shadow page tables as attempting to install an
-		 * MMIO SPTE will just be an expensive nop.  Do not cache MMIO
-		 * whose gfn is greater than host.MAXPHYADDR, any guest that
-		 * generates such gfns is running nested and is being tricked
-		 * by L0 userspace (you can observe gfn > L1.MAXPHYADDR if
-		 * and only if L1's MAXPHYADDR is inaccurate with respect to
-		 * the hardware's).
-		 */
-		if (unlikely(!enable_mmio_caching) ||
-		    unlikely(fault->gfn > kvm_mmu_max_gfn()))
-			return RET_PF_EMULATE;
-	}
+	vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
+			     access & shadow_mmio_access_mask);
+
+	/*
+	 * If MMIO caching is disabled, emulate immediately without
+	 * touching the shadow page tables as attempting to install an
+	 * MMIO SPTE will just be an expensive nop.
+	 */
+	if (unlikely(!enable_mmio_caching))
+		return RET_PF_EMULATE;
+
+	/*
+	 * Do not create an MMIO SPTE for a gfn greater than host.MAXPHYADDR,
+	 * any guest that generates such gfns is running nested and is being
+	 * tricked by L0 userspace (you can observe gfn > L1.MAXPHYADDR if and
+	 * only if L1's MAXPHYADDR is inaccurate with respect to the
+	 * hardware's).
+	 */
+	if (unlikely(fault->gfn > kvm_mmu_max_gfn()))
+		return RET_PF_EMULATE;
 
 	return RET_PF_CONTINUE;
 }
@@ -4181,6 +4185,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (unlikely(is_error_pfn(fault->pfn)))
 		return kvm_handle_error_pfn(fault);
 
+	if (unlikely(!fault->slot))
+		return kvm_handle_noslot_fault(vcpu, fault, ACC_ALL);
+
 	return RET_PF_CONTINUE;
 }
 
@@ -4239,10 +4246,6 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu,
 	if (r != RET_PF_CONTINUE)
 		return r;
 
-	r = handle_abnormal_pfn(vcpu, fault, ACC_ALL);
-	if (r != RET_PF_CONTINUE)
-		return r;
-
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
@@ -4338,10 +4341,6 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (r != RET_PF_CONTINUE)
 		return r;
 
-	r = handle_abnormal_pfn(vcpu, fault, ACC_ALL);
-	if (r != RET_PF_CONTINUE)
-		return r;
-
 	r = RET_PF_RETRY;
 	read_lock(&vcpu->kvm->mmu_lock);
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index a199db4acecc..cf19227e842c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -841,10 +841,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r != RET_PF_CONTINUE)
 		return r;
 
-	r = handle_abnormal_pfn(vcpu, fault, walker.pte_access);
-	if (r != RET_PF_CONTINUE)
-		return r;
-
 	/*
 	 * Do not change pte_access if the pfn is a mmio page, otherwise
 	 * we will cache the incorrect access into mmio spte.
-- 
2.37.1.595.g718a3a8f04-goog

