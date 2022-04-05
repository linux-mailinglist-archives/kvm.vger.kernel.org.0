Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E024F49B3
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444269AbiDEWVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573388AbiDETEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 15:04:13 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CE3DA6F0
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 12:02:14 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id kw18so341742pjb.5
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 12:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KzoM3KzDv92AOke2J0hqhfs+nD24w5LEsSlzvXoVp/s=;
        b=TT4EffOmtyJiefPIvDgO7D57JVm8Qr5k4ODuII/n0vFE4+TLyWWF1QsMbtrd1BNaTD
         BLd9iR7SHtwRcU/82AAUlMYvtZqRbWmRgfRwmq5nWYqYs4jIr5bcNVTMA3PwRJP5NAD6
         Id5T+FIcvjChZZlEjwBSzPGCR/s8Ri4XU2Z+W2Bn5ZzSF/BnNGcCvueSQQQK7Z4r9g8e
         HC7BU8UoUIdDecbDgbps0E15iZven4NZGaq+OrwRl6yeUVH5mPRCbm7ziFTa7SGfbLCS
         9JfsVNACKHWlqu3dJ3CMtJjiqD231StnVbqcTTAZDAS6ukqLM+Q2AmNAb/yDgHbXuIQ6
         KRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KzoM3KzDv92AOke2J0hqhfs+nD24w5LEsSlzvXoVp/s=;
        b=Ufvscr/0IyAMNRodQqEvRekVX1TwteZ91gH65KpQtbyx1uOQj3pMfEDhUy8FAPuJJP
         jz9+xSwha1KqMtmSKaiHUjxTrOhsnUEl8LE8TanSiMHLvlKWgI3iqx3JVfwcfaoothe7
         kPOGX9skodcYptB1Q4B5eVqQNgBqqoiAHNwWdCdv9f1Gpy00U2T98rIYf0bOiqjZnZob
         Hk1RUkeCqH4wA0Hw/+SqSswyP2s716dTq/WyU7CBPNnYjv0u78oDHjc7oBnYuN5OMfcc
         +HrD+c57i2FCIbWtUGLnxSBV/akUjovW1u7i8m18TidgEs5jRL3tqRuDD7F9oQOBmQRW
         ULUw==
X-Gm-Message-State: AOAM531ingpXDtgkHby+Pne14gDDdWQApc3rywYOCYU5OkmnfF9FIOgl
        FoCYSsoDrGIxP4HfPb8jbMpjAw==
X-Google-Smtp-Source: ABdhPJzzS9AqHD6POqN7jDCMWA+tyNwi0VJtz1EYS/YqCq91X+6GdAw2LSo2ugZavE260/1dHTfmmg==
X-Received: by 2002:a17:902:f70c:b0:14e:f1a4:d894 with SMTP id h12-20020a170902f70c00b0014ef1a4d894mr5151744plo.65.1649185333239;
        Tue, 05 Apr 2022 12:02:13 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id n52-20020a056a000d7400b004fad9132d73sm15771613pfv.129.2022.04.05.12.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 12:02:12 -0700 (PDT)
Date:   Tue, 5 Apr 2022 19:02:08 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: Split huge pages mapped by the TDP MMU
 on fault
Message-ID: <YkySMOyOK+25UAd9@google.com>
References: <20220401233737.3021889-1-dmatlack@google.com>
 <20220401233737.3021889-4-dmatlack@google.com>
 <CANgfPd-pt1K0D0TqX9qJpk0kMOszDeWxuScNeFHbVP01a8XJwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-pt1K0D0TqX9qJpk0kMOszDeWxuScNeFHbVP01a8XJwQ@mail.gmail.com>
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

On Mon, Apr 04, 2022 at 11:48:46AM -0700, Ben Gardon wrote:
> On Fri, Apr 1, 2022 at 4:37 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Now that the TDP MMU has a mechanism to split huge pages, use it in the
> > fault path when a huge page needs to be replaced with a mapping at a
> > lower level.
> >
> > This change reduces the negative performance impact of NX HugePages.
> > Prior to this change if a vCPU executed from a huge page and NX
> > HugePages was enabled, the vCPU would take a fault, zap the huge page,
> > and mapping the faulting address at 4KiB with execute permissions
> > enabled. The rest of the memory would be left *unmapped* and have to be
> > faulted back in by the guest upon access (read, write, or execute). If
> > guest is backed by 1GiB, a single execute instruction can zap an entire
> > GiB of its physical address space.
> >
> > For example, it can take a VM longer to execute from its memory than to
> > populate that memory in the first place:
> >
> > $ ./execute_perf_test -s anonymous_hugetlb_1gb -v96
> >
> > Populating memory             : 2.748378795s
> > Executing from memory         : 2.899670885s
> >
> > With this change, such faults split the huge page instead of zapping it,
> > which avoids the non-present faults on the rest of the huge page:
> >
> > $ ./execute_perf_test -s anonymous_hugetlb_1gb -v96
> >
> > Populating memory             : 2.729544474s
> > Executing from memory         : 0.111965688s   <---
> >
> > This change also reduces the performance impact of dirty logging when
> > eager_page_split=N for the same reasons as above but write faults.
> > eager_page_split=N (abbreviated "eps=N" below) can be desirable for
> > read-heavy workloads, as it avoids allocating memory to split huge pages
> > that are never written and avoids increasing the TLB miss cost on reads
> > of those pages.
> >
> >              | Config: ept=Y, tdp_mmu=Y, 5% writes           |
> >              | Iteration 1 dirty memory time                 |
> >              | --------------------------------------------- |
> > vCPU Count   | eps=N (Before) | eps=N (After) | eps=Y        |
> > ------------ | -------------- | ------------- | ------------ |
> > 2            | 0.332305091s   | 0.019615027s  | 0.006108211s |
> > 4            | 0.353096020s   | 0.019452131s  | 0.006214670s |
> > 8            | 0.453938562s   | 0.019748246s  | 0.006610997s |
> > 16           | 0.719095024s   | 0.019972171s  | 0.007757889s |
> > 32           | 1.698727124s   | 0.021361615s  | 0.012274432s |
> > 64           | 2.630673582s   | 0.031122014s  | 0.016994683s |
> > 96           | 3.016535213s   | 0.062608739s  | 0.044760838s |
> >
> > Eager page splitting remains beneficial for write-heavy workloads, but
> > the gap is now reduced.
> >
> >              | Config: ept=Y, tdp_mmu=Y, 100% writes         |
> >              | Iteration 1 dirty memory time                 |
> >              | --------------------------------------------- |
> > vCPU Count   | eps=N (Before) | eps=N (After) | eps=Y        |
> > ------------ | -------------- | ------------- | ------------ |
> > 2            | 0.317710329s   | 0.296204596s  | 0.058689782s |
> > 4            | 0.337102375s   | 0.299841017s  | 0.060343076s |
> > 8            | 0.386025681s   | 0.297274460s  | 0.060399702s |
> > 16           | 0.791462524s   | 0.298942578s  | 0.062508699s |
> > 32           | 1.719646014s   | 0.313101996s  | 0.075984855s |
> > 64           | 2.527973150s   | 0.455779206s  | 0.079789363s |
> > 96           | 2.681123208s   | 0.673778787s  | 0.165386739s |
> >
> > Further study is needed to determine if the remaining gap is acceptable
> > for customer workloads or if eager_page_split=N still requires a-priori
> > knowledge of the VM workload, especially when considering these costs
> > extrapolated out to large VMs with e.g. 416 vCPUs and 12TB RAM.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++++++++++++++++++++++------------
> >  1 file changed, 25 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 9263765c8068..5a2120d85347 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1131,6 +1131,10 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
> >         return 0;
> >  }
> >
> > +static int tdp_mmu_split_huge_page_atomic(struct kvm_vcpu *vcpu,
> > +                                         struct tdp_iter *iter,
> > +                                         bool account_nx);
> > +
> >  /*
> >   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
> >   * page tables and SPTEs to translate the faulting guest physical address.
> > @@ -1140,6 +1144,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >         struct kvm_mmu *mmu = vcpu->arch.mmu;
> >         struct tdp_iter iter;
> >         struct kvm_mmu_page *sp;
> > +       bool account_nx;
> >         int ret;
> >
> >         kvm_mmu_hugepage_adjust(vcpu, fault);
> > @@ -1155,28 +1160,22 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                 if (iter.level == fault->goal_level)
> >                         break;
> >
> > +               account_nx = fault->huge_page_disallowed &&
> > +                            fault->req_level >= iter.level;
> > +
> >                 /*
> >                  * If there is an SPTE mapping a large page at a higher level
> > -                * than the target, that SPTE must be cleared and replaced
> > -                * with a non-leaf SPTE.
> > +                * than the target, split it down one level.
> >                  */
> >                 if (is_shadow_present_pte(iter.old_spte) &&
> >                     is_large_pte(iter.old_spte)) {
> > -                       if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> > +                       if (tdp_mmu_split_huge_page_atomic(vcpu, &iter, account_nx))
> >                                 break;
> 
> I don't think we necessarily want to break here, as splitting a 1G
> page would require two splits.
> 
> ...
> 
> Oh tdp_mmu_split_huge_page_atomic returns non-zero to indicate an
> error and if everything works we will split again. In the case of
> failure, should we fall back to zapping?

The only way for tdp_mmu_split_huge_page_atomic() to fail is if
tdp_mmu_set_spte_atomic() fails (i.e. the huge page SPTE is frozen or
being concurrently modified). Breaking here means we go back into the
guest and retry the access.

I don't think we should fall back to zapping:

 - If the SPTE is frozen, zapping will also fail.
 - Otherwise, the SPTE is being modified by another CPU. It'd be a waste
   to immediately zap that CPU's work. e.g. Maybe another CPU just split
   this huge page for us :).

> 
> 
> >
> > -                       /*
> > -                        * The iter must explicitly re-read the spte here
> > -                        * because the new value informs the !present
> > -                        * path below.
> > -                        */
> > -                       iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
> > +                       continue;
> >                 }
> >
> >                 if (!is_shadow_present_pte(iter.old_spte)) {
> > -                       bool account_nx = fault->huge_page_disallowed &&
> > -                                         fault->req_level >= iter.level;
> > -
> >                         /*
> >                          * If SPTE has been frozen by another thread, just
> >                          * give up and retry, avoiding unnecessary page table
> > @@ -1496,6 +1495,20 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
> >         return ret;
> >  }
> >
> > +static int tdp_mmu_split_huge_page_atomic(struct kvm_vcpu *vcpu,
> > +                                         struct tdp_iter *iter,
> > +                                         bool account_nx)
> > +{
> > +       struct kvm_mmu_page *sp = tdp_mmu_alloc_sp(vcpu);
> > +       int r;
> > +
> > +       r = tdp_mmu_split_huge_page(vcpu->kvm, iter, sp, true, account_nx);
> > +       if (r)
> > +               tdp_mmu_free_sp(sp);
> > +
> > +       return r;
> > +}
> > +
> >  static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> >                                          struct kvm_mmu_page *root,
> >                                          gfn_t start, gfn_t end,
> > --
> > 2.35.1.1094.g7c7d902a7c-goog
> >
