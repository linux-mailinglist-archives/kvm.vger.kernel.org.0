Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DCD5EDF3B
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 16:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbiI1Owb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 10:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234539AbiI1OwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 10:52:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D3BB2D9F
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 07:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664376725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V1rmv91tUUvou9BEXUYCuE3RXDIyugyqH/Zsh1iT0d8=;
        b=KJmI7d9XAQoqGUgQITy/Lhmh029ux8PZ31sMV/6M082YolQpB2htKT3EerYM9ev4RS3+E+
        s7paUSuqImPmbtZgChFa35IPip44n8mu1zAx95+eU9pLe+znDbr1NLLU3Ra53vm3dQZy+G
        H2HUK5HaQ0zdRQVtMKr1XGr2jsavRsc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-567-QxXVcAnGNNi-uFeOUIUMPw-1; Wed, 28 Sep 2022 10:52:03 -0400
X-MC-Unique: QxXVcAnGNNi-uFeOUIUMPw-1
Received: by mail-qk1-f198.google.com with SMTP id j13-20020a05620a288d00b006be7b2a758fso9606695qkp.1
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 07:52:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=V1rmv91tUUvou9BEXUYCuE3RXDIyugyqH/Zsh1iT0d8=;
        b=OctTpElXDdLG+yraQBL/2QXvOuVf2MIRlnN56AneE4i0+IdK4O2Cr5FXV/OLNU6Wur
         09O3CBP3+IvAoIYzI7mpdzw5LUimU1enkq0H30YNLVbCmGKGHVm3Q2nIb5zBsaPZyMiJ
         svVjTgfCH46AqptBZg9ymo9ahV8tW7RjuIm4pSh5wjNtdW4kXHjS8rXZKX6PojxeNKin
         14rqKu/uIxwlIz1mNOerDNk/ULJdbdYZU0bPh6kDb90kmoCETLkjTxWA2zLoNcwm3iK/
         34q4LTeHodcUXsleexKb8GhSUbw2A3+SWD7USqe11ozMKelCLMbE7ye5xKg5jaQdA5sW
         cpzQ==
X-Gm-Message-State: ACrzQf1F7Xtw6wYJyOFR+6e2T0UkkOB9OcXaneW0c0hClzEhlZpUFS+l
        xsfQKlAS8k8uYgAbI77IxaeLtBve4sMTqLjU5HCezBbm+qktPOj2HblxKeAe6DefCHfRPHaHKDN
        k74ssppXu6LG4
X-Received: by 2002:a05:6214:1d0a:b0:4ad:82d6:d56a with SMTP id e10-20020a0562141d0a00b004ad82d6d56amr25211046qvd.27.1664376723335;
        Wed, 28 Sep 2022 07:52:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4d39+PB3ET3P/HdsjCQUYySCT8M0b2TxU1Q2Q+6jDnC9y8I5qSD+pY6EASfBqTQCOapekEUA==
X-Received: by 2002:a05:6214:1d0a:b0:4ad:82d6:d56a with SMTP id e10-20020a0562141d0a00b004ad82d6d56amr25211026qvd.27.1664376723070;
        Wed, 28 Sep 2022 07:52:03 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id k21-20020ac81415000000b003436103df40sm3034126qtj.8.2022.09.28.07.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:52:02 -0700 (PDT)
Date:   Wed, 28 Sep 2022 10:52:00 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com, james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory
 tracking
Message-ID: <YzRfkBWepX2CD88h@x1n>
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-4-gshan@redhat.com>
 <YzMerD8ZvhvnprEN@x1n>
 <86sfkc7mg8.wl-maz@kernel.org>
 <YzM/DFV1TgtyRfCA@x1n>
 <320005d1-fe88-fd6a-be91-ddb56f1aa80f@redhat.com>
 <87y1u3hpmp.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87y1u3hpmp.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 28, 2022 at 09:25:34AM +0100, Marc Zyngier wrote:
> Hi Gavin,
> 
> On Wed, 28 Sep 2022 00:47:43 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
> 
> > I have rough idea as below. It's appreciated if you can comment before I'm
> > going a head for the prototype. The overall idea is to introduce another
> > dirty ring for KVM (kvm-dirty-ring). It's updated and visited separately
> > to dirty ring for vcpu (vcpu-dirty-ring).
> > 
> >    - When the various VGIC/ITS table base addresses are specified, kvm-dirty-ring
> >      entries are added to mark those pages as 'always-dirty'. In mark_page_dirty_in_slot(),
> >      those 'always-dirty' pages will be skipped, no entries pushed to vcpu-dirty-ring.
> > 
> >    - Similar to vcpu-dirty-ring, kvm-dirty-ring is accessed from userspace through
> >      mmap(kvm->fd). However, there won't have similar reset interface. It means
> >      'struct kvm_dirty_gfn::flags' won't track any information as we do for
> >      vcpu-dirty-ring. In this regard, kvm-dirty-ring is purely shared buffer to
> >      advertise 'always-dirty' pages from host to userspace.
> >         - For QEMU, shutdown/suspend/resume cases won't be concerning
> > us any more. The
> >      only concerned case is migration. When the migration is about to complete,
> >      kvm-dirty-ring entries are fetched and the dirty bits are updated to global
> >      dirty page bitmap and RAMBlock's dirty page bitmap. For this, I'm still reading
> >      the code to find the best spot to do it.
> 
> I think it makes a lot of sense to have a way to log writes that are
> not generated by a vpcu, such as the GIC and maybe other things in the
> future, such as DMA traffic (some SMMUs are able to track dirty pages
> as well).
> 
> However, I don't really see the point in inventing a new mechanism for
> that. Why don't we simply allow non-vpcu dirty pages to be tracked in
> the dirty *bitmap*?
> 
> From a kernel perspective, this is dead easy:
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5b064dbadaf4..ae9138f29d51 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3305,7 +3305,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>  	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>  
>  #ifdef CONFIG_HAVE_KVM_DIRTY_RING
> -	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
> +	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
>  		return;
>  #endif
>  
> @@ -3313,10 +3313,11 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>  		unsigned long rel_gfn = gfn - memslot->base_gfn;
>  		u32 slot = (memslot->as_id << 16) | memslot->id;
>  
> -		if (kvm->dirty_ring_size)
> +		if (vpcu && kvm->dirty_ring_size)
>  			kvm_dirty_ring_push(&vcpu->dirty_ring,
>  					    slot, rel_gfn);
> -		else
> +		/* non-vpcu dirtying ends up in the global bitmap */
> +		if (!vcpu && memslot->dirty_bitmap)
>  			set_bit_le(rel_gfn, memslot->dirty_bitmap);
>  	}
>  }
> 
> though I'm sure there is a few more things to it.

Yes, currently the bitmaps are not created when rings are enabled.
kvm_prepare_memory_region() has:

		else if (!kvm->dirty_ring_size) {
			r = kvm_alloc_dirty_bitmap(new);

But I think maybe that's a solution worth considering.  Using the rings
have a major challenge on the limitation of ring size, so that for e.g. an
ioctl we need to make sure the pages to dirty within an ioctl procedure
will not be more than the ring can take.  Using dirty bitmap for a last
phase sync of constant (but still very small amount of) dirty pages does
sound reasonable and can avoid that complexity.  The payoff is we'll need
to allocate both the rings and the bitmaps.

> 
> To me, this is just a relaxation of an arbitrary limitation, as the
> current assumption that only vcpus can dirty memory doesn't hold at
> all.

The initial dirty ring proposal has a per-vm ring, but after we
investigated x86 we found that all legal dirty paths are with a vcpu
context (except one outlier on kvmgt which fixed within itself), so we
dropped the per-vm ring.

One thing to mention is that DMAs should not count in this case because
that's from device perspective, IOW either IOMMU or SMMU dirty tracking
should be reported to the device driver that interacts with the userspace
not from KVM interfaces (e.g. vfio with VFIO_IOMMU_DIRTY_PAGES).  That even
includes emulated DMA like vhost (VHOST_SET_LOG_BASE).

Thanks,

-- 
Peter Xu

