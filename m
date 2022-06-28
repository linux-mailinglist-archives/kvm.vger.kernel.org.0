Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DEC55EE1F
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 21:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiF1TuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 15:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiF1TuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 15:50:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BED538BE4
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 12:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656445620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qQJqzWxMD2wYGMO4NMh8exaYIYOycnFf9yiMWqcQgzM=;
        b=Mr3jUlP046l0dtKzQ0pjf3rsT8HF5g6YVmtLqkKQrLb1QgBvqOoVfzmwHwlfXkP5u4Oxl2
        JLGrSeeh/wYapRTCzo2+KlT3Mt4SjmOvWTabmsNXuHaJKUhJS1iTsp1hew35/OF3RC8ZOF
        nElS00BQT0T9NrQyI2z09wptDtlVJhw=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-jWVHyz9pNOeY9r_OZP1SOw-1; Tue, 28 Jun 2022 15:46:59 -0400
X-MC-Unique: jWVHyz9pNOeY9r_OZP1SOw-1
Received: by mail-io1-f70.google.com with SMTP id c8-20020a056602334800b0067500ca88aaso7243421ioz.0
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 12:46:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qQJqzWxMD2wYGMO4NMh8exaYIYOycnFf9yiMWqcQgzM=;
        b=WsJjGKVmxV9nnJ6pS/MrzOwtLy+9uzG6hRfpAMoPU1UJ5uWpGTygScGKfGUN+0ewtX
         q/gGEEk1Xq28MzlfLpIqFh1cZ5ml3ZBs87XKOwg5zjaun/k9ecHvqmygIGm7xFOxq4NJ
         KTky1aKmyYQLPbi+788B5Ho5ca+gO/CumPnRolv6u/eBBr9NELdOqjuBxAChjbL47dbS
         Tx20le+IIIdsj2e5cM6Eh5l4WV260lwpt2x88pwb4YGcMpfz5qmU10yrQkvMqw64H0B4
         Az3BQQAVWjeL8BZeaBqf2rylnjsqinyw+x7/gn40Oxid0Ew0QIK/hor9htmxHRMOcx77
         laBg==
X-Gm-Message-State: AJIora+grRNDPUKAOl1CiipYB9ACROJn0cGdx6XnNNgC0gQHHYDne220
        Be6fm/oAlYY7qaSZ0f3RN+PVH8wvwVTJzyEeDtRw6+UZwbIaFv+Ki0kChrO/Fr3UYN2WbgRJxuk
        ogjJRcujyfffv
X-Received: by 2002:a05:6e02:1749:b0:2da:9a89:3961 with SMTP id y9-20020a056e02174900b002da9a893961mr5843180ill.258.1656445618262;
        Tue, 28 Jun 2022 12:46:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v2hBFdLGw2ehMsPWTL/s3RLgYsTwLehZi2x21Zstq8Dxrz20PQ+CSwQBynhMOdy324UJkxFQ==
X-Received: by 2002:a05:6e02:1749:b0:2da:9a89:3961 with SMTP id y9-20020a056e02174900b002da9a893961mr5843158ill.258.1656445617974;
        Tue, 28 Jun 2022 12:46:57 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id s9-20020a92cc09000000b002d1c94b7143sm5993039ilp.39.2022.06.28.12.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:46:57 -0700 (PDT)
Date:   Tue, 28 Jun 2022 15:46:55 -0400
From:   Peter Xu <peterx@redhat.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/4] kvm: Merge "atomic" and "write" in
 __gfn_to_pfn_memslot()
Message-ID: <Yrtar+i2X0YjmD/F@xz-m1.local>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-3-peterx@redhat.com>
 <c047c213-252b-4a0b-9720-070307962d23@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c047c213-252b-4a0b-9720-070307962d23@nvidia.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 07:17:09PM -0700, John Hubbard wrote:
> On 6/22/22 14:36, Peter Xu wrote:
> > Merge two boolean parameters into a bitmask flag called kvm_gtp_flag_t for
> > __gfn_to_pfn_memslot().  This cleans the parameter lists, and also prepare
> > for new boolean to be added to __gfn_to_pfn_memslot().
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >   arch/arm64/kvm/mmu.c                   |  5 ++--
> >   arch/powerpc/kvm/book3s_64_mmu_hv.c    |  5 ++--
> >   arch/powerpc/kvm/book3s_64_mmu_radix.c |  5 ++--
> >   arch/x86/kvm/mmu/mmu.c                 | 10 +++----
> >   include/linux/kvm_host.h               |  9 ++++++-
> >   virt/kvm/kvm_main.c                    | 37 +++++++++++++++-----------
> >   virt/kvm/kvm_mm.h                      |  6 +++--
> >   virt/kvm/pfncache.c                    |  2 +-
> >   8 files changed, 49 insertions(+), 30 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index f5651a05b6a8..ce1edb512b4e 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1204,8 +1204,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >   	 */
> >   	smp_rmb();
> > -	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
> > -				   write_fault, &writable, NULL);
> > +	pfn = __gfn_to_pfn_memslot(memslot, gfn,
> > +				   write_fault ? KVM_GTP_WRITE : 0,
> > +				   NULL, &writable, NULL);
> >   	if (pfn == KVM_PFN_ERR_HWPOISON) {
> >   		kvm_send_hwpoison_signal(hva, vma_shift);
> >   		return 0;
> > diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> > index 514fd45c1994..e2769d58dd87 100644
> > --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> > +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> > @@ -598,8 +598,9 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
> >   		write_ok = true;
> >   	} else {
> >   		/* Call KVM generic code to do the slow-path check */
> > -		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
> > -					   writing, &write_ok, NULL);
> > +		pfn = __gfn_to_pfn_memslot(memslot, gfn,
> > +					   writing ? KVM_GTP_WRITE : 0,
> > +					   NULL, &write_ok, NULL);
> >   		if (is_error_noslot_pfn(pfn))
> >   			return -EFAULT;
> >   		page = NULL;
> > diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > index 42851c32ff3b..232b17c75b83 100644
> > --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > @@ -845,8 +845,9 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
> >   		unsigned long pfn;
> >   		/* Call KVM generic code to do the slow-path check */
> > -		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
> > -					   writing, upgrade_p, NULL);
> > +		pfn = __gfn_to_pfn_memslot(memslot, gfn,
> > +					   writing ? KVM_GTP_WRITE : 0,
> > +					   NULL, upgrade_p, NULL);
> >   		if (is_error_noslot_pfn(pfn))
> >   			return -EFAULT;
> >   		page = NULL;
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index f4653688fa6d..e92f1ab63d6a 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3968,6 +3968,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
> >   static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >   {
> > +	kvm_gtp_flag_t flags = fault->write ? KVM_GTP_WRITE : 0;
> >   	struct kvm_memory_slot *slot = fault->slot;
> >   	bool async;
> > @@ -3999,8 +4000,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >   	}
> >   	async = false;
> > -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, &async,
> > -					  fault->write, &fault->map_writable,
> > +	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, flags,
> > +					  &async, &fault->map_writable,
> >   					  &fault->hva);
> >   	if (!async)
> >   		return RET_PF_CONTINUE; /* *pfn has correct page already */
> > @@ -4016,9 +4017,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >   		}
> >   	}
> > -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, NULL,
> > -					  fault->write, &fault->map_writable,
> > -					  &fault->hva);
> > +	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, flags, NULL,
> > +					  &fault->map_writable, &fault->hva);
> 
> The flags arg does improve the situation, yes.

Thanks for supporting a flag's existance. :)

I'd say ultimately it could be a personal preference thing when the struct
comes.

> 
> >   	return RET_PF_CONTINUE;
> >   }
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index c20f2d55840c..b646b6fcaec6 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1146,8 +1146,15 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
> >   		      bool *writable);
> >   kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
> >   kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn);
> > +
> > +/* gfn_to_pfn (gtp) flags */
> > +typedef unsigned int __bitwise kvm_gtp_flag_t;
> 
> A minor naming problem: GTP and especially gtp_flags is way too close
> to gfp_flags. It will make people either wonder if it's a typo, or
> worse, *assume* that it's a typo. :)

I'd try to argu with "I prefixed it with kvm_", but oh well.. yes they're a
bit close :)

> 
> Yes, "read the code", but if you can come up with a better TLA than GTP
> here, let's consider using it.

Could I ask what's TLA?  Any suggestions on the abbrev, btw?

> 
> Overall, the change looks like an improvement, even though
> 
>     write_fault ? KVM_GTP_WRITE : 0
> 
> is not wonderful. But improving *that* leads to a a big pile of diffs
> that are rather beyond the scope here.

Thanks,

-- 
Peter Xu

