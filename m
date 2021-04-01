Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8145F351F7E
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 21:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhDATT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 15:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbhDATTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 15:19:50 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EE6C048493
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 11:09:58 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id h3so2000914pfr.12
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 11:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XcArkM/Mu7LyKJ0IOrO318ummSUe3+qjqzdC9zEjewY=;
        b=GOxDAlhjargq+ZxjTtj/VsIcyxNU94N7bkQa3a0P4GAZ6OwyuZtoDDx7K3lkj1FHVb
         BkolFXkgSJ2XCAq0bd3V3CRiTWZXO8vD+2DAvNV1o+PHzVZkoOeChi3yg7gP2MWrJPvb
         pRqRN7Z+vTO26V6yUXoFvRGQD2KTCr0txnRn7VkQJarybHB+t2a/aBvXW3SkGHXMHcbO
         lUZ63TVfhi2aBUUW6Sy8tGnGfPaexT/3tF0ilR5yIn241nmkXsMbdNPpwBJCdhh3r4kY
         6NkLbL9x4LIQacaKfyv7jtOukaYyMjjHRz5T8s1gBb+Cu63nZujqINijdhmUpoOTZ9Re
         yeBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XcArkM/Mu7LyKJ0IOrO318ummSUe3+qjqzdC9zEjewY=;
        b=lJ14womAnIxgqVFF503cW6C8akqmYxKlFnz8nfCTyivb5Po82fVYgXH1T/GS5RQHPU
         9xRsc5wrsZmPf4l0E7Qqo3P9GX+6SlTfUNGwDvxp/uxKKca0LfxWXUUyCMxy71KEKfTi
         WYBm2Ze0tPM6Guuaahz26YzCJgpC9nTDjlvx0xs2jcf/gmbrdKe59K4px9/Pf5e5Y2IM
         q/oCST+Y4uL+ytRpZm/ZCAwbJqK4tSg14ZtlWk9IhGzhtB7mz2cTnrR3wzjx2VsKen2B
         EzJKnEsJpMdE5JdTJdekB8zAoMGb8NVE4cxOOw5xum6R0JNk1IQGSOUjCsU8EqlJmhxO
         h+2w==
X-Gm-Message-State: AOAM533PIbiIbdUeBT97P24xZer742aagyFSb3WHqyoVy7lvZ4ek05+u
        +SebVzlwfH49YvEu+aK6ssn+Ag==
X-Google-Smtp-Source: ABdhPJxfAARHqH5Crs1x2KN2QAQ3dtSanaIsTMsmUkk1nC6e4lwkcEaypHC/DpRbt1cfTjn09xRE9g==
X-Received: by 2002:a65:6a0e:: with SMTP id m14mr8616024pgu.448.1617300597911;
        Thu, 01 Apr 2021 11:09:57 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id l2sm6073911pji.45.2021.04.01.11.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 11:09:57 -0700 (PDT)
Date:   Thu, 1 Apr 2021 18:09:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH v2 20/28] KVM: x86/mmu: Use atomic ops to set SPTEs in
 TDP MMU map
Message-ID: <YGYMcdRuWOHBer24@google.com>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-21-bgardon@google.com>
 <f4fca4d7-8795-533e-d2d9-89a73e1a9004@redhat.com>
 <CANgfPd85U_YwDdXc1Dkn-UzKpae5FRzYshLFABAU_xHTs0i3Hg@mail.gmail.com>
 <e94bc2f3-b948-0176-0253-b487bf2aa787@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e94bc2f3-b948-0176-0253-b487bf2aa787@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021, Paolo Bonzini wrote:
> On 01/04/21 18:50, Ben Gardon wrote:
> > > retry:
> > >                   if (is_shadow_present_pte(iter.old_spte)) {
> > >                          if (is_large_pte(iter.old_spte)) {
> > >                                  if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> > >                                          break;
> > > 
> > >                                  /*
> > >                                   * The iter must explicitly re-read the SPTE because
> > >                                   * the atomic cmpxchg failed.
> > >                                   */
> > >                                  iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> > >                                  goto retry;
> > >                          }
> > >                   } else {
> > >                          ...
> > >                  }
> > > 
> > > ?
> > To be honest, that feels less readable to me. For me retry implies
> > that we failed to make progress and need to repeat an operation, but
> > the reality is that we did make progress and there are just multiple
> > steps to replace the large SPTE with a child PT.
> 
> You're right, it's makes no sense---I misremembered the direction of
> tdp_mmu_zap_spte_atomic's return value.  I was actually thinking of this:
> 
> > Another option which could improve readability and performance would
> > be to use the retry to repeat failed cmpxchgs instead of breaking out
> > of the loop. Then we could avoid retrying the page fault each time a
> > cmpxchg failed, which may happen a lot as vCPUs allocate intermediate
> > page tables on boot. (Probably less common for leaf entries, but
> > possibly useful there too.)
> 
> which would be
> 
> retry:
>                  if (is_shadow_present_pte(iter.old_spte)) {
>                        if (is_large_pte(iter.old_spte) &&
>                            !tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter)) {
>                                 /*
>                                  * The iter must explicitly re-read the SPTE because
>                                  * the atomic cmpxchg failed.
>                                  */
>                                 iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
>                                 goto retry;
>                             }
>                             /* XXX move this to tdp_mmu_zap_spte_atomic? */
>                             iter.old_spte = 0;
>                        } else {
>                             continue;

This is wrong.  If a large PTE is successfully zapped, it will leave a !PRESENT
intermediate entry.  It's probably not fatal; I'm guessing it would lead to
RET_PF_RETRY and cleaned up on the subsequent re-fault.

>                        }
>                  }
>                  sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
>                  child_pt = sp->spt;
> 
>                  new_spte = make_nonleaf_spte(child_pt,
>                                               !shadow_accessed_mask);
> 
>                  if (!tdp_mmu_set_spte_atomic(vcpu->kvm, &iter,
>                                              new_spte)) {
>                       tdp_mmu_free_sp(sp);
>                       /*
>                        * The iter must explicitly re-read the SPTE because
>                        * the atomic cmpxchg failed.
>                        */
>                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
>                       goto retry;

I'm not sure that _always_ retrying is correct.  The conflict means something
else is writing the same SPTE.  That could be a different vCPU handling an
identical fault, but it could also be something else blasting away the SPTE.  If
an upper level SPTE was zapped, e.g. the entire MMU instance is zapped,
installing a new SPE would be wrong.

AFAICT, the only motivation for retrying in this loop is to handle the case
where a different vCPU is handling an identical fault.  It should be safe to
handler that, but if the conflicting SPTE is not-present, I believe this needs
to break to handle any pending updates.

			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
			if (!is_shadow_present_pte(iter.old_spte))
				break;
			goto retry;

>                  }
>                  tdp_mmu_link_page(vcpu->kvm, sp, true,
>                                    huge_page_disallowed &&
>                                    req_level >= iter.level);
> 
>                  trace_kvm_mmu_get_page(sp, true);
> 
> which survives at least a quick smoke test of booting a 20-vCPU Windows
> guest.  If you agree I'll turn this into an actual patch.
> 
