Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1078B4F8863
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 22:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiDGUaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 16:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiDGUaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 16:30:08 -0400
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4E0488BD9
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 13:14:22 -0700 (PDT)
Received: by mail-qv1-f47.google.com with SMTP id i15so5934566qvh.0
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 13:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ijbi9VLmxIpB3rDVypqUB1Rsyu6CIGhk9jX/3jBpdZI=;
        b=VbADzZBB+6dO4EkfHMhze1kQ0m7b4tD/4UpjT45k+gqoxgs/cjbqw8rCAf+rB9Fpwl
         uPqo++cRXpCJ1GvS6oKGoqbCYI/JnUKkEndVahVINmo/78Ri0CfxBFxI57WvcIhapeh5
         Tz5w54RjTWd7UgGJ3cRehnTw/uXdFgnS3VmCIWSbFjOOc5oN8aCDQy51IKgr+jiSWO0L
         v0ervjhTKmfp0ZCpCBdRSZNz2jOmXDhM9FiYh+NwKz356Ja99eXeF97GQrsgQYf+wElh
         ogjdozOZljev16l579df7j0Gwxph9yrS27N6MgmBKw+q4CDRBPVfemHtJjLik4RRaLKq
         c3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ijbi9VLmxIpB3rDVypqUB1Rsyu6CIGhk9jX/3jBpdZI=;
        b=rzqrmkMQnC4NqmvmxffqaiC8dqBnFLf32DV+lvnxolDOB6G5mEMCfVPL/l+qUkTcuY
         bCLQNJ5/dT3C28ANs2QwjyTrxLcA5Tb/lJ4wiPkwphhCPvaXIgOYXn7CYtBw2xyeUuez
         QPj8kkLkQH2d3M/HzENjmEv1456IeCQVM55wM0hUbctuhfMGsklZsUI8S4ePojRdiiDR
         qlW1Cuz+uBe0dQewTmdUlkQfq1wKkyUTQsTg8xghQofpOeV8bOtMLkEjTvjzjqUVixde
         xf06sAtLPMlOqCf8BvTq+AOLqKzPy95a0mzrst5yjm7a/mzGpjHzV5oS3gyU5Lgk4TOk
         9Y+w==
X-Gm-Message-State: AOAM531qNAVmVlY222iO7GnnNxke1gQsR2SUsABp1fQD7mZAj2WkUKKF
        zusquPIdoULJbivo5+ECF4D62NM0GlDCQA==
X-Google-Smtp-Source: ABdhPJz/wJXGaUdKOa0hNzK5nsDU1fSoTxGYr45gS1KnlmX6qxqewFFsOQ43o1kSr83mpLRckKEdxg==
X-Received: by 2002:a17:902:8e82:b0:151:777b:6d7 with SMTP id bg2-20020a1709028e8200b00151777b06d7mr15547065plb.172.1649360386550;
        Thu, 07 Apr 2022 12:39:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d23-20020a17090a02d700b001bf6ef9daafsm9790282pjd.38.2022.04.07.12.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 12:39:45 -0700 (PDT)
Date:   Thu, 7 Apr 2022 19:39:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: Split huge pages mapped by the TDP MMU
 on fault
Message-ID: <Yk89/g2Unn2exRfz@google.com>
References: <20220401233737.3021889-1-dmatlack@google.com>
 <20220401233737.3021889-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401233737.3021889-4-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 01, 2022, David Matlack wrote:
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++++++++++++++++++++++------------
>  1 file changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 9263765c8068..5a2120d85347 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1131,6 +1131,10 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  	return 0;
>  }
>  
> +static int tdp_mmu_split_huge_page_atomic(struct kvm_vcpu *vcpu,
> +					  struct tdp_iter *iter,
> +					  bool account_nx);
> +
>  /*
>   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
>   * page tables and SPTEs to translate the faulting guest physical address.
> @@ -1140,6 +1144,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
>  	struct tdp_iter iter;
>  	struct kvm_mmu_page *sp;
> +	bool account_nx;
>  	int ret;
>  
>  	kvm_mmu_hugepage_adjust(vcpu, fault);
> @@ -1155,28 +1160,22 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		if (iter.level == fault->goal_level)
>  			break;
>  
> +		account_nx = fault->huge_page_disallowed &&
> +			     fault->req_level >= iter.level;
> +
>  		/*
>  		 * If there is an SPTE mapping a large page at a higher level
> -		 * than the target, that SPTE must be cleared and replaced
> -		 * with a non-leaf SPTE.
> +		 * than the target, split it down one level.
>  		 */
>  		if (is_shadow_present_pte(iter.old_spte) &&
>  		    is_large_pte(iter.old_spte)) {
> -			if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> +			if (tdp_mmu_split_huge_page_atomic(vcpu, &iter, account_nx))

As Ben brought up in patch 2, this conflicts in nasty ways with Mingwei's series
to more preciesly check sp->lpage_disallowed.  There's apparently a bug in that
code when using shadow paging, but assuming said bug isn't a blocking issue, I'd
prefer to land this on top of Mingwei's series.

With a bit of massaging, I think we can make the whole thing a bit more
straightforward.  This is what I ended up with (compile tested only, your patch 2
dropped, might split moving the "init" to a prep patch).   I'll give it a spin,
and assuming it works and Mingwei's bug is resolved, I'll post this and Mingwei's
series as a single thing.

---
 arch/x86/kvm/mmu/tdp_mmu.c | 99 ++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f046af20f3d6..b0abf14570ea 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1126,6 +1126,9 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	return 0;
 }

+static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
+				   struct kvm_mmu_page *sp, bool shared);
+
 /*
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
@@ -1136,7 +1139,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
-	int ret;
+	bool account_nx;
+	int ret, r;

 	kvm_mmu_hugepage_adjust(vcpu, fault);

@@ -1151,57 +1155,50 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (iter.level == fault->goal_level)
 			break;

-		/*
-		 * If there is an SPTE mapping a large page at a higher level
-		 * than the target, that SPTE must be cleared and replaced
-		 * with a non-leaf SPTE.
-		 */
+		/* Nothing to do if there's already a shadow page installed. */
 		if (is_shadow_present_pte(iter.old_spte) &&
-		    is_large_pte(iter.old_spte)) {
-			if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
-				break;
-
-			/*
-			 * The iter must explicitly re-read the spte here
-			 * because the new value informs the !present
-			 * path below.
-			 */
-			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
+		    !is_large_pte(iter.old_spte))
+			continue;
+
+		/*
+		 * If the SPTE has been frozen by another thread, just give up
+		 * and retry to avoid unnecessary page table alloc and free.
+		 */
+		if (is_removed_spte(iter.old_spte))
+			break;
+
+		/*
+		 * The SPTE is either invalid or points at a huge page that
+		 * needs to be split.
+		 */
+		sp = tdp_mmu_alloc_sp(vcpu);
+		tdp_mmu_init_child_sp(sp, &iter);
+
+		account_nx = fault->huge_page_disallowed &&
+			     fault->req_level >= iter.level;
+
+		sp->lpage_disallowed = account_nx;
+		/*
+		 * Ensure lpage_disallowed is visible before the SP is marked
+		 * present (or not-huge), as mmu_lock is held for read.  Pairs
+		 * with the smp_rmb() in disallowed_hugepage_adjust().
+		 */
+		smp_wmb();
+
+		if (!is_shadow_present_pte(iter.old_spte))
+			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
+		else
+			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
+
+		if (r) {
+			tdp_mmu_free_sp(sp);
+			break;
 		}

-		if (!is_shadow_present_pte(iter.old_spte)) {
-			bool account_nx = fault->huge_page_disallowed &&
-					  fault->req_level >= iter.level;
-
-			/*
-			 * If SPTE has been frozen by another thread, just
-			 * give up and retry, avoiding unnecessary page table
-			 * allocation and free.
-			 */
-			if (is_removed_spte(iter.old_spte))
-				break;
-
-			sp = tdp_mmu_alloc_sp(vcpu);
-			tdp_mmu_init_child_sp(sp, &iter);
-
-			sp->lpage_disallowed = account_nx;
-			/*
-			 * Ensure lpage_disallowed is visible before the SP is
-			 * marked present, as mmu_lock is held for read.  Pairs
-			 * with the smp_rmb() in disallowed_hugepage_adjust().
-			 */
-			smp_wmb();
-
-			if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
-				tdp_mmu_free_sp(sp);
-				break;
-			}
-
-			if (account_nx) {
-				spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-				__account_huge_nx_page(kvm, sp);
-				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
-			}
+		if (account_nx) {
+			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+			__account_huge_nx_page(kvm, sp);
+			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 		}
 	}

@@ -1472,8 +1469,6 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	const int level = iter->level;
 	int ret, i;

-	tdp_mmu_init_child_sp(sp, iter);
-
 	/*
 	 * No need for atomics when writing to sp->spt since the page table has
 	 * not been linked in yet and thus is not reachable from any other CPU.
@@ -1549,6 +1544,8 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 				continue;
 		}

+		tdp_mmu_init_child_sp(sp, &iter);
+
 		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
 			goto retry;


base-commit: f06d9d4f3d89912c40c57da45d64b9827d8580ac
--

