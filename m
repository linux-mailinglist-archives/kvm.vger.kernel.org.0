Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865F83FF7F6
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 01:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346196AbhIBXmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 19:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345950AbhIBXmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 19:42:02 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D43CC061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 16:41:03 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so2674617pjx.5
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 16:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aHNkMU3Lgh3YqYm+NxGw4DogXvl9lfcbMGURhJiEaf8=;
        b=AYfFPF8GQjWasA64TehGu+qOUAPvthVCPT17pkNAghrRA2e1uDdsDyF/0VAEPmX0+r
         wuBdeYOueheSMfNnMfLDyTRxnN0aj+eedUjNEPfL98+ZiD+V0kX5mowDhj1nziwiWcwk
         cJRVzg4mRlEpxNH5Lf1VbvKdSh5RAY+R/XiwnXbFNW4fC0DOp0sDmLjb7tjd5jzMuhkr
         ssYbxVZ9l7ty6nT9wW+ip/CTyoYHFiAebGP1qfNp9jR0XnA4GzK+MnEbuybs5BphnJqf
         P96B/in9xY64f8VDI7HrT48oIFXfCzzQydZnFTS/yebpWnV+obr5fcwy/kX+GFBmh5pv
         ZYQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aHNkMU3Lgh3YqYm+NxGw4DogXvl9lfcbMGURhJiEaf8=;
        b=DOwM1aW/7Vnh5lyjXYafU47VFkp2t7UpNZ4epnmtBpom4Ctvu9zDw0SI7O410wQRzb
         WT72/qQ//5asyo2ljJ1DXM3ZTCKPL4buoQMJGOWg18iVmGz/0jDTcNmLb1y6LE45Oa4W
         2F1FIhOk6IQJNKwKAcE2r8SSDfmnGDIPDkuBp7wVTZfCl7y6bz6AiPW6mbnc7ed/vbt0
         3nDOJLxyVkiXqoqLJ5FAs6j4RKNi103Ct+vpWN1aDtKXRJniGx5gUy2lM1P0coyEZA1x
         eZIaYSF7TNXhc5IAcweXxLHB3ywYYOUjkOQlTDklBERjqL8+fuNS3sPyjmJJXxW4WdM8
         eamw==
X-Gm-Message-State: AOAM532fjR+E/P29X2PWw5yup6yKjYo7Sx34nqj0m8OpWupP5Sn59ES/
        1gE5Zer5zhh76PZx8jOWUZ5ZLw==
X-Google-Smtp-Source: ABdhPJzibDpU2FtvnVhaQCCcVziwCRSEX5Cdkylu55to/zcmkF1DfGxIap8bL56BUib9qf/2BOFEZA==
X-Received: by 2002:a17:902:b713:b0:132:5a48:18cb with SMTP id d19-20020a170902b71300b001325a4818cbmr734256pls.50.1630626062486;
        Thu, 02 Sep 2021 16:41:02 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u21sm4186197pgk.57.2021.09.02.16.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 16:41:01 -0700 (PDT)
Date:   Thu, 2 Sep 2021 23:40:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: X86: Synchronize the shadow pagetable before
 link it
Message-ID: <YTFhCt87vzo4xDrc@google.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
 <20210824075524.3354-3-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824075524.3354-3-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> If gpte is changed from non-present to present, the guest doesn't need
> to flush tlb per SDM.  So the host must synchronze sp before
> link it.  Otherwise the guest might use a wrong mapping.
> 
> For example: the guest first changes a level-1 pagetable, and then
> links its parent to a new place where the original gpte is non-present.
> Finally the guest can access the remapped area without flushing
> the tlb.  The guest's behavior should be allowed per SDM, but the host
> kvm mmu makes it wrong.

Ah, are you saying, given:

VA_x = PML4_A -> PDP_B -> PD_C -> PT_D

the guest can modify PT_D, then link it with

VA_y = PML4_A -> PDP_B -> PD_E -> PT_D

and access it via VA_y without flushing, and so KVM must sync PT_D.  Is that
correct?

> Fixes: 4731d4c7a077 ("KVM: MMU: out of sync shadow core")
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---

...

> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 50ade6450ace..48c7fe1b2d50 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -664,7 +664,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
>   * emulate this operation, return 1 to indicate this case.
>   */
>  static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> -			 struct guest_walker *gw)
> +			 struct guest_walker *gw, unsigned long mmu_seq)
>  {
>  	struct kvm_mmu_page *sp = NULL;
>  	struct kvm_shadow_walk_iterator it;
> @@ -678,6 +678,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	top_level = vcpu->arch.mmu->root_level;
>  	if (top_level == PT32E_ROOT_LEVEL)
>  		top_level = PT32_ROOT_LEVEL;
> +
> +again:
>  	/*
>  	 * Verify that the top-level gpte is still there.  Since the page
>  	 * is a root page, it is either write protected (and cannot be
> @@ -713,8 +715,28 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
>  			goto out_gpte_changed;
>  
> -		if (sp)
> +		if (sp) {
> +			/*
> +			 * We must synchronize the pagetable before link it
> +			 * because the guest doens't need to flush tlb when
> +			 * gpte is changed from non-present to present.
> +			 * Otherwise, the guest may use the wrong mapping.
> +			 *
> +			 * For PG_LEVEL_4K, kvm_mmu_get_page() has already
> +			 * synchronized it transiently via kvm_sync_page().
> +			 *
> +			 * For higher level pagetable, we synchronize it
> +			 * via slower mmu_sync_children().  If it once
> +			 * released the mmu_lock, we need to restart from
> +			 * the root since we don't have reference to @sp.
> +			 */
> +			if (sp->unsync_children && !mmu_sync_children(vcpu, sp, false)) {

I don't like dropping mmu_lock in the page fault path.  I agree that it's not
all that different than grabbing various things in kvm_mmu_do_page_fault() long
before acquiring mmu_lock, but I'm not 100% convinced we don't have a latent
bug hiding somehwere in there :-), and (b) there's a possibility, however small,
that something in FNAME(fetch) that we're missing.  Case in point, this technically
needs to do make_mmu_pages_available().

And I believe kvm_mmu_get_page() already tries to handle this case by requesting
KVM_REQ_MMU_SYNC if it uses a sp with unsync_children, it just doesn't handle SMP
interaction, e.g. can link a sp that's immediately available to other vCPUs before
the sync.

Rather than force the sync here, what about kicking all vCPUs and retrying the
page fault?  The only gross part is that kvm_mmu_get_page() can now fail :-(

---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/mmu/mmu.c          | 9 +++++++--
 arch/x86/kvm/mmu/paging_tmpl.h  | 4 ++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09b256db394a..332b9fb3454c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -57,7 +57,8 @@
 #define KVM_REQ_MIGRATE_TIMER		KVM_ARCH_REQ(0)
 #define KVM_REQ_REPORT_TPR_ACCESS	KVM_ARCH_REQ(1)
 #define KVM_REQ_TRIPLE_FAULT		KVM_ARCH_REQ(2)
-#define KVM_REQ_MMU_SYNC		KVM_ARCH_REQ(3)
+#define KVM_REQ_MMU_SYNC \
+	KVM_ARCH_REQ_FLAGS(3, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_CLOCK_UPDATE		KVM_ARCH_REQ(4)
 #define KVM_REQ_LOAD_MMU_PGD		KVM_ARCH_REQ(5)
 #define KVM_REQ_EVENT			KVM_ARCH_REQ(6)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4853c033e6ce..03293cd3c7ae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2143,8 +2143,10 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 		}

-		if (sp->unsync_children)
-			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
+		if (sp->unsync_children) {
+			kvm_make_all_cpus_request(KVM_REQ_MMU_SYNC, vcpu);
+			return NULL;
+		}

 		__clear_sp_write_flooding_count(sp);

@@ -2999,6 +3001,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)

 		sp = kvm_mmu_get_page(vcpu, base_gfn, it.addr,
 				      it.level - 1, true, ACC_ALL);
+		BUG_ON(!sp);

 		link_shadow_page(vcpu, it.sptep, sp);
 		if (fault->is_tdp && fault->huge_page_disallowed &&
@@ -3383,6 +3386,8 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
 	struct kvm_mmu_page *sp;

 	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
+	BUG_ON(!sp);
+
 	++sp->root_count;

 	return __pa(sp->spt);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50ade6450ace..f573d45e2c6f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -704,6 +704,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			access = gw->pt_access[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, fault->addr,
 					      it.level-1, false, access);
+			if (!sp)
+				return RET_PF_RETRY;
 		}

 		/*
@@ -742,6 +744,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		if (!is_shadow_present_pte(*it.sptep)) {
 			sp = kvm_mmu_get_page(vcpu, base_gfn, fault->addr,
 					      it.level - 1, true, direct_access);
+			BUG_ON(!sp);
+
 			link_shadow_page(vcpu, it.sptep, sp);
 			if (fault->huge_page_disallowed &&
 			    fault->req_level >= it.level)
--
