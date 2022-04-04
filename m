Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C104F1B5F
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379626AbiDDVUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380058AbiDDSu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 14:50:56 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FBB3137D
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 11:48:58 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id w134so11479466ybe.10
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 11:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mlof2mo/IsXprTLefkwYprBhxqwI0ogiF81MON6t/AM=;
        b=cUR3KgLWE46Z5Jp+e2az1qQt7A6iKrk7gxEazRRyA4EJTd5De6j8jxj/IjDlMBgysa
         dgUzqBmn0cWXjzgetq0+aFjKXOXtNK4zTwTVGZokmByM+Fxvq77HI72g+VdiZj1MgLdZ
         1uaTXgzAQ43N+m0i3dsrp4iZ0Dd72qPEJim/+w+eo6T1u6+O4fcV/plexelO8jYoH5Wy
         AxyyEOkhJ256aQ83KMJfcd9Zi1I9JnArT7LtQlr/ILoniScAuejRLvG3mvdO5rkRZdAG
         RTSgSByyLQ25Jfduv4HJe9RaKRMRY7jt3tKIvPgmrJ9JZ7dpopLFglYmhOmbfJYyMVWc
         QR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mlof2mo/IsXprTLefkwYprBhxqwI0ogiF81MON6t/AM=;
        b=oALKUgQbCzHzBxAVtK0ddp8dMfIUVM1n6djnNkedeV4HTlFWR8pTixu4lmW5IaQ0rV
         CRxLraf1vi1LFIVLb+e1dryDVbIKQW9St30p+3aRqifPKLoTdru0HuSRVTLWDFKBLONj
         MOrZpxB5qv3TjJcDIz3dRZihtrz22WC3WZdJg5Hl9Vn8xVmX5vU5gwA9TtxOTHqyDjGK
         mQMpqNsAorGqot8XazYqLU7TAIDivtCIxO7SbOF5EOCtd+9Lo4uz/cKw4/4+nXYQAImR
         cNVnmwuDNqNQtQA+pP7uK4z3orbhrykR14xLGzgnt0WknSWPe7kaPJF2CyFHsudqCt3M
         h1iQ==
X-Gm-Message-State: AOAM531d+98Hf2OkMXdRO8eMQIDx/GDaRLHZwzjPImLFSzx+qnA0IRxO
        wdU8oOclp1dTrmUUVVVMVkFi6xJeFbLsmOXJ+ipogg==
X-Google-Smtp-Source: ABdhPJwNgpNwjrkUOnyBGvM8C802dCz4X9PoxyVsZmNUBU1HUBMxZxUTZoxnJrSY3GiKGrmClEmTPzQo7VUJRnARSKk=
X-Received: by 2002:a25:ab6b:0:b0:63d:a27b:8bcd with SMTP id
 u98-20020a25ab6b000000b0063da27b8bcdmr1016955ybi.391.1649098137756; Mon, 04
 Apr 2022 11:48:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220401233737.3021889-1-dmatlack@google.com> <20220401233737.3021889-4-dmatlack@google.com>
In-Reply-To: <20220401233737.3021889-4-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 4 Apr 2022 11:48:46 -0700
Message-ID: <CANgfPd-pt1K0D0TqX9qJpk0kMOszDeWxuScNeFHbVP01a8XJwQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: Split huge pages mapped by the TDP MMU
 on fault
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 1, 2022 at 4:37 PM David Matlack <dmatlack@google.com> wrote:
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
> eager_page_split=N for the same reasons as above but write faults.
> eager_page_split=N (abbreviated "eps=N" below) can be desirable for
> read-heavy workloads, as it avoids allocating memory to split huge pages
> that are never written and avoids increasing the TLB miss cost on reads
> of those pages.
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
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++++++++++++++++++++++------------
>  1 file changed, 25 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 9263765c8068..5a2120d85347 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1131,6 +1131,10 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>         return 0;
>  }
>
> +static int tdp_mmu_split_huge_page_atomic(struct kvm_vcpu *vcpu,
> +                                         struct tdp_iter *iter,
> +                                         bool account_nx);
> +
>  /*
>   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
>   * page tables and SPTEs to translate the faulting guest physical address.
> @@ -1140,6 +1144,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>         struct kvm_mmu *mmu = vcpu->arch.mmu;
>         struct tdp_iter iter;
>         struct kvm_mmu_page *sp;
> +       bool account_nx;
>         int ret;
>
>         kvm_mmu_hugepage_adjust(vcpu, fault);
> @@ -1155,28 +1160,22 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                 if (iter.level == fault->goal_level)
>                         break;
>
> +               account_nx = fault->huge_page_disallowed &&
> +                            fault->req_level >= iter.level;
> +
>                 /*
>                  * If there is an SPTE mapping a large page at a higher level
> -                * than the target, that SPTE must be cleared and replaced
> -                * with a non-leaf SPTE.
> +                * than the target, split it down one level.
>                  */
>                 if (is_shadow_present_pte(iter.old_spte) &&
>                     is_large_pte(iter.old_spte)) {
> -                       if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> +                       if (tdp_mmu_split_huge_page_atomic(vcpu, &iter, account_nx))
>                                 break;

I don't think we necessarily want to break here, as splitting a 1G
page would require two splits.

...

Oh tdp_mmu_split_huge_page_atomic returns non-zero to indicate an
error and if everything works we will split again. In the case of
failure, should we fall back to zapping?


>
> -                       /*
> -                        * The iter must explicitly re-read the spte here
> -                        * because the new value informs the !present
> -                        * path below.
> -                        */
> -                       iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
> +                       continue;
>                 }
>
>                 if (!is_shadow_present_pte(iter.old_spte)) {
> -                       bool account_nx = fault->huge_page_disallowed &&
> -                                         fault->req_level >= iter.level;
> -
>                         /*
>                          * If SPTE has been frozen by another thread, just
>                          * give up and retry, avoiding unnecessary page table
> @@ -1496,6 +1495,20 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>         return ret;
>  }
>
> +static int tdp_mmu_split_huge_page_atomic(struct kvm_vcpu *vcpu,
> +                                         struct tdp_iter *iter,
> +                                         bool account_nx)
> +{
> +       struct kvm_mmu_page *sp = tdp_mmu_alloc_sp(vcpu);
> +       int r;
> +
> +       r = tdp_mmu_split_huge_page(vcpu->kvm, iter, sp, true, account_nx);
> +       if (r)
> +               tdp_mmu_free_sp(sp);
> +
> +       return r;
> +}
> +
>  static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>                                          struct kvm_mmu_page *root,
>                                          gfn_t start, gfn_t end,
> --
> 2.35.1.1094.g7c7d902a7c-goog
>
