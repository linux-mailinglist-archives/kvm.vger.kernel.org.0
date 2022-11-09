Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E647462374D
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 00:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbiKIXLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 18:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiKIXK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 18:10:58 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159BC2C653
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 15:10:47 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id z17so172139qki.11
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 15:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hRjFkFpQEAlWbmW6ZzoH9mgUCJRJS9MGOK7XTirdLmU=;
        b=I/Fg0ubP4DVB8hNVZynJK7xbdNgxcuj9ETjS1ETNibUuxo2U76UxZe6WzDfSQzQvE/
         l+qe9g1XHvRqgcVx43EV4q84HjuAuPlRdLIIdlnfJ3uB09n8D54+ZDP1mYZOvXUKXRwW
         Dni0aGsgsDndrt16nsNwjYqBd/cnqpi6c+PIj1WIwfFZ7NhVJXrUMkXmiHf71yL13vcz
         l0z5oKLoQefZIsy0OMpNtIos/c2TyFenppFjxY8nNdnr92iJWjDCRP7ZMMUnl7OEiqlg
         IhQQ1+y+tr5O5tnTjgY554W/VETBluFaKZDk27ZJkEVbsbOqkaZXI47EEwvbllJdeWn3
         Jq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hRjFkFpQEAlWbmW6ZzoH9mgUCJRJS9MGOK7XTirdLmU=;
        b=jCVcPEqzOeawyZTCsVHM/Y7WUOecKsuXhBkLBcfGXN3dcXIuECPbd0UW8sc4s9V0Zi
         ZWdb0pbl0+ONb/nULydSz6ImZ2CYHJZGEzXpqNkSR1Nm890AH92k1OymL+bOBezcLxvx
         fEUvdFfeEMRBPaiA4rsqTffB5NRb0IpDGnueXkYBIOcFFMeO3wVH2TuzbgaiO+/EHQX7
         FkVOe3w6MG/XNRNJJEhz6BgCEI6bEnFhdyPYPydAs29OIGywFNmtQvlNQW/QmKKL4DXi
         /0c0hu/iW3/vGTg2/7Cd52pX6TqXaqswJbIlgDz2EoSTyuWrFQpLwnlH4749QMadY7ae
         PO9A==
X-Gm-Message-State: ACrzQf30L22dpoFRtg9hGmtnJ5eosyHlzKpyBp6EZgnJKjOcTOif7zi0
        aE6hpxq22d8bBAs1ze3o8NO5eXkIyjJJPqAldlZFiQBNJWU=
X-Google-Smtp-Source: AMsMyM7AGKnWa6sRcjc0skASa2rLnLGS1LLikRrsCYDrtVmHqFT4F3azHYCRIqhrIPOibp10IyPM7WErVxnG7Cvxd6I=
X-Received: by 2002:a37:ad18:0:b0:6fa:b07:9e8d with SMTP id
 f24-20020a37ad18000000b006fa0b079e8dmr43975863qkm.670.1668035445904; Wed, 09
 Nov 2022 15:10:45 -0800 (PST)
MIME-Version: 1.0
References: <20221109185905.486172-1-dmatlack@google.com> <20221109185905.486172-3-dmatlack@google.com>
In-Reply-To: <20221109185905.486172-3-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 9 Nov 2022 15:10:34 -0800
Message-ID: <CANgfPd-URR79UT1==ctEfCUoZxYmGnNnn8n59WfreK_Moshk_w@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] KVM: x86/mmu: Split huge pages mapped by the TDP
 MMU on fault
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 9, 2022 at 10:59 AM David Matlack <dmatlack@google.com> wrote:
>
> Now that the TDP MMU has a mechanism to split huge pages, use it in the
> fault path when a huge page needs to be replaced with a mapping at a
> lower level.
>
> This change reduces the negative performance impact of NX HugePages.
> Prior to this change if a vCPU executed from a huge page and NX
> HugePages was enabled, the vCPU would take a fault, zap the huge page,
> and mapping the faulting address at 4KiB with execute permissions
> enabled. The rest of the memory would be left *unmapped* and have to be
> faulted back in by the guest upon access (read, write, or execute). If
> guest is backed by 1GiB, a single execute instruction can zap an entire
> GiB of its physical address space.
>
> For example, it can take a VM longer to execute from its memory than to
> populate that memory in the first place:
>
> $ ./execute_perf_test -s anonymous_hugetlb_1gb -v96
>
> Populating memory             : 2.748378795s
> Executing from memory         : 2.899670885s
>
> With this change, such faults split the huge page instead of zapping it,
> which avoids the non-present faults on the rest of the huge page:
>
> $ ./execute_perf_test -s anonymous_hugetlb_1gb -v96
>
> Populating memory             : 2.729544474s
> Executing from memory         : 0.111965688s   <---
>
> This change also reduces the performance impact of dirty logging when
> eager_page_split=N. eager_page_split=N (abbreviated "eps=N" below) can
> be desirable for read-heavy workloads, as it avoids allocating memory to
> split huge pages that are never written and avoids increasing the TLB
> miss cost on reads of those pages.
>
>              | Config: ept=Y, tdp_mmu=Y, 5% writes           |
>              | Iteration 1 dirty memory time                 |
>              | --------------------------------------------- |
> vCPU Count   | eps=N (Before) | eps=N (After) | eps=Y        |
> ------------ | -------------- | ------------- | ------------ |
> 2            | 0.332305091s   | 0.019615027s  | 0.006108211s |
> 4            | 0.353096020s   | 0.019452131s  | 0.006214670s |
> 8            | 0.453938562s   | 0.019748246s  | 0.006610997s |
> 16           | 0.719095024s   | 0.019972171s  | 0.007757889s |
> 32           | 1.698727124s   | 0.021361615s  | 0.012274432s |
> 64           | 2.630673582s   | 0.031122014s  | 0.016994683s |
> 96           | 3.016535213s   | 0.062608739s  | 0.044760838s |
>
> Eager page splitting remains beneficial for write-heavy workloads, but
> the gap is now reduced.
>
>              | Config: ept=Y, tdp_mmu=Y, 100% writes         |
>              | Iteration 1 dirty memory time                 |
>              | --------------------------------------------- |
> vCPU Count   | eps=N (Before) | eps=N (After) | eps=Y        |
> ------------ | -------------- | ------------- | ------------ |
> 2            | 0.317710329s   | 0.296204596s  | 0.058689782s |
> 4            | 0.337102375s   | 0.299841017s  | 0.060343076s |
> 8            | 0.386025681s   | 0.297274460s  | 0.060399702s |
> 16           | 0.791462524s   | 0.298942578s  | 0.062508699s |
> 32           | 1.719646014s   | 0.313101996s  | 0.075984855s |
> 64           | 2.527973150s   | 0.455779206s  | 0.079789363s |
> 96           | 2.681123208s   | 0.673778787s  | 0.165386739s |
>
> Further study is needed to determine if the remaining gap is acceptable
> for customer workloads or if eager_page_split=N still requires a-priori
> knowledge of the VM workload, especially when considering these costs
> extrapolated out to large VMs with e.g. 416 vCPUs and 12TB RAM.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Mingwei Zhang <mizhang@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 73 ++++++++++++++++++--------------------
>  1 file changed, 35 insertions(+), 38 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4e5b3ae824c1..e08596775427 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1146,6 +1146,9 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>         return 0;
>  }
>
> +static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
> +                                  struct kvm_mmu_page *sp, bool shared);
> +
>  /*
>   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
>   * page tables and SPTEs to translate the faulting guest physical address.
> @@ -1171,49 +1174,42 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                 if (iter.level == fault->goal_level)
>                         break;
>
> -               /*
> -                * If there is an SPTE mapping a large page at a higher level
> -                * than the target, that SPTE must be cleared and replaced
> -                * with a non-leaf SPTE.
> -                */
> +               /* Step down into the lower level page table if it exists. */
>                 if (is_shadow_present_pte(iter.old_spte) &&
> -                   is_large_pte(iter.old_spte)) {
> -                       if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> -                               break;
> +                   !is_large_pte(iter.old_spte))
> +                       continue;
>
> -                       /*
> -                        * The iter must explicitly re-read the spte here
> -                        * because the new value informs the !present
> -                        * path below.
> -                        */
> -                       iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
> -               }
> +               /*
> +                * If SPTE has been frozen by another thread, just give up and
> +                * retry, avoiding unnecessary page table allocation and free.
> +                */
> +               if (is_removed_spte(iter.old_spte))
> +                       break;
>
> -               if (!is_shadow_present_pte(iter.old_spte)) {
> -                       /*
> -                        * If SPTE has been frozen by another thread, just
> -                        * give up and retry, avoiding unnecessary page table
> -                        * allocation and free.
> -                        */
> -                       if (is_removed_spte(iter.old_spte))
> -                               break;
> +               /*
> +                * The SPTE is either non-present or points to a huge page that
> +                * needs to be split.
> +                */
> +               sp = tdp_mmu_alloc_sp(vcpu);
> +               tdp_mmu_init_child_sp(sp, &iter);
>
> -                       sp = tdp_mmu_alloc_sp(vcpu);
> -                       tdp_mmu_init_child_sp(sp, &iter);
> +               sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
>
> -                       sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
> +               if (is_shadow_present_pte(iter.old_spte))
> +                       ret = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
> +               else
> +                       ret = tdp_mmu_link_sp(kvm, &iter, sp, true);
>
> -                       if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
> -                               tdp_mmu_free_sp(sp);
> -                               break;
> -                       }
> +               if (ret) {
> +                       tdp_mmu_free_sp(sp);
> +                       break;
> +               }
>
> -                       if (fault->huge_page_disallowed &&
> -                           fault->req_level >= iter.level) {
> -                               spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -                               track_possible_nx_huge_page(kvm, sp);
> -                               spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> -                       }
> +               if (fault->huge_page_disallowed &&
> +                   fault->req_level >= iter.level) {
> +                       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> +                       track_possible_nx_huge_page(kvm, sp);
> +                       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>                 }
>         }
>
> @@ -1477,6 +1473,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>         return sp;
>  }
>
> +/* Note, the caller is responsible for initializing @sp. */
>  static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>                                    struct kvm_mmu_page *sp, bool shared)
>  {
> @@ -1484,8 +1481,6 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>         const int level = iter->level;
>         int ret, i;
>
> -       tdp_mmu_init_child_sp(sp, iter);
> -
>         /*
>          * No need for atomics when writing to sp->spt since the page table has
>          * not been linked in yet and thus is not reachable from any other CPU.
> @@ -1561,6 +1556,8 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>                                 continue;
>                 }
>
> +               tdp_mmu_init_child_sp(sp, &iter);
> +
>                 if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
>                         goto retry;
>
> --
> 2.38.1.431.g37b22c650d-goog
>
