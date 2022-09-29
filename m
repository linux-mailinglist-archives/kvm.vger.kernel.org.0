Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BFA5EF78F
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 16:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbiI2OcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 10:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbiI2OcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 10:32:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181781BB6C8
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 07:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664461928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+H4R/xKgJJ99s3E7Bn7ZhS8YfpjV3c66RDQ04tH27q0=;
        b=ihJNB/NH4Ckp1D+pKtv6C9swCyD1ONhhWfjmIe4rBdt2MKPwcvtNQFAuHQrRbksHPP1eRQ
        KCXfbD09/amN0y6D/c4LeURYioXGBezn48QDjC7og0109IzOCqyzJTBwoLZE1JhN1f9Yjj
        ykjbvfmb6Q2wodmuhmZqDjwkMMI8rqg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-217-5AG8jVZ8Pwql68VeWtm51A-1; Thu, 29 Sep 2022 10:32:06 -0400
X-MC-Unique: 5AG8jVZ8Pwql68VeWtm51A-1
Received: by mail-qk1-f199.google.com with SMTP id r14-20020a05620a298e00b006be796b6164so1239635qkp.19
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 07:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=+H4R/xKgJJ99s3E7Bn7ZhS8YfpjV3c66RDQ04tH27q0=;
        b=H+1qPlRJhjpJOO/dQyHYhCBjf1KdYseol9z2d61XJp/H6xkAaxHb14G6JJYGtaZhY+
         hqtxdV/B0cDj1qXTfu07aEIkMHmInS7vzIrnt+T2t9q33TufqWECzDKmu2GvDw/pJqI3
         XFMo/04U+FlrK96zaM+WPbkUp0btl0LLUrSZQWXNTlOqVLUvdafXkIPICR30Xa8UOnlH
         KCgyN7CMnOVjUtcD8qgy/5YtFiPfZ0cvQmuqXVjPFRg6dBagd74V5gm8vBVeLkrwNSQY
         QEaXDF8rBotLIGzqJ1UkYkZmsA2eaopdzJmnsYZlm4D+LNmlkN5q+L5VrmdNJiCRtSja
         2wRg==
X-Gm-Message-State: ACrzQf3sPzoNh7ZXE+BMXfxDe9mvSoUA+hxqvE3hWWlVPc5qaeVLXa8w
        hw7iNV+/DFZ3KvzUCRZ4rgefBrzbW+Hom9/au0fUY/4YTsK6JaZWetUkR9jU/mnYRFwBt3VEH06
        eGQjQEfG6GAHa
X-Received: by 2002:a37:9a84:0:b0:6cd:dbad:a207 with SMTP id c126-20020a379a84000000b006cddbada207mr2430516qke.169.1664461925782;
        Thu, 29 Sep 2022 07:32:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6C6+8JAjtQMkFHOxTsFmH+ij92rd5imyJ4QKkyttoxgJDHx/FCbw5WsmCWhPHxs5s4mPUevQ==
X-Received: by 2002:a37:9a84:0:b0:6cd:dbad:a207 with SMTP id c126-20020a379a84000000b006cddbada207mr2430463qke.169.1664461925364;
        Thu, 29 Sep 2022 07:32:05 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id h11-20020a05620a284b00b006ced5d3f921sm6267042qkp.52.2022.09.29.07.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 07:32:04 -0700 (PDT)
Date:   Thu, 29 Sep 2022 10:32:03 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com, james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory
 tracking
Message-ID: <YzWsY3WtmP5fS9TJ@x1n>
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-4-gshan@redhat.com>
 <YzMerD8ZvhvnprEN@x1n>
 <86sfkc7mg8.wl-maz@kernel.org>
 <YzM/DFV1TgtyRfCA@x1n>
 <320005d1-fe88-fd6a-be91-ddb56f1aa80f@redhat.com>
 <87y1u3hpmp.wl-maz@kernel.org>
 <YzRfkBWepX2CD88h@x1n>
 <d0beb9bd-5295-adb6-a473-c131d6102947@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d0beb9bd-5295-adb6-a473-c131d6102947@redhat.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 29, 2022 at 07:50:12PM +1000, Gavin Shan wrote:
> Hi Marc and Peter,
> 
> On 9/29/22 12:52 AM, Peter Xu wrote:
> > On Wed, Sep 28, 2022 at 09:25:34AM +0100, Marc Zyngier wrote:
> > > On Wed, 28 Sep 2022 00:47:43 +0100,
> > > Gavin Shan <gshan@redhat.com> wrote:
> > > 
> > > > I have rough idea as below. It's appreciated if you can comment before I'm
> > > > going a head for the prototype. The overall idea is to introduce another
> > > > dirty ring for KVM (kvm-dirty-ring). It's updated and visited separately
> > > > to dirty ring for vcpu (vcpu-dirty-ring).
> > > > 
> > > >     - When the various VGIC/ITS table base addresses are specified, kvm-dirty-ring
> > > >       entries are added to mark those pages as 'always-dirty'. In mark_page_dirty_in_slot(),
> > > >       those 'always-dirty' pages will be skipped, no entries pushed to vcpu-dirty-ring.
> > > > 
> > > >     - Similar to vcpu-dirty-ring, kvm-dirty-ring is accessed from userspace through
> > > >       mmap(kvm->fd). However, there won't have similar reset interface. It means
> > > >       'struct kvm_dirty_gfn::flags' won't track any information as we do for
> > > >       vcpu-dirty-ring. In this regard, kvm-dirty-ring is purely shared buffer to
> > > >       advertise 'always-dirty' pages from host to userspace.
> > > >          - For QEMU, shutdown/suspend/resume cases won't be concerning
> > > > us any more. The
> > > >       only concerned case is migration. When the migration is about to complete,
> > > >       kvm-dirty-ring entries are fetched and the dirty bits are updated to global
> > > >       dirty page bitmap and RAMBlock's dirty page bitmap. For this, I'm still reading
> > > >       the code to find the best spot to do it.
> > > 
> > > I think it makes a lot of sense to have a way to log writes that are
> > > not generated by a vpcu, such as the GIC and maybe other things in the
> > > future, such as DMA traffic (some SMMUs are able to track dirty pages
> > > as well).
> > > 
> > > However, I don't really see the point in inventing a new mechanism for
> > > that. Why don't we simply allow non-vpcu dirty pages to be tracked in
> > > the dirty *bitmap*?
> > > 
> > >  From a kernel perspective, this is dead easy:
> > > 
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 5b064dbadaf4..ae9138f29d51 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -3305,7 +3305,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> > >   	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> > >   #ifdef CONFIG_HAVE_KVM_DIRTY_RING
> > > -	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
> > > +	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
> > >   		return;
> > >   #endif
> > > @@ -3313,10 +3313,11 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> > >   		unsigned long rel_gfn = gfn - memslot->base_gfn;
> > >   		u32 slot = (memslot->as_id << 16) | memslot->id;
> > > -		if (kvm->dirty_ring_size)
> > > +		if (vpcu && kvm->dirty_ring_size)
> > >   			kvm_dirty_ring_push(&vcpu->dirty_ring,
> > >   					    slot, rel_gfn);
> > > -		else
> > > +		/* non-vpcu dirtying ends up in the global bitmap */
> > > +		if (!vcpu && memslot->dirty_bitmap)
> > >   			set_bit_le(rel_gfn, memslot->dirty_bitmap);
> > >   	}
> > >   }
> > > 
> > > though I'm sure there is a few more things to it.
> > 
> > Yes, currently the bitmaps are not created when rings are enabled.
> > kvm_prepare_memory_region() has:
> > 
> > 		else if (!kvm->dirty_ring_size) {
> > 			r = kvm_alloc_dirty_bitmap(new);
> > 
> > But I think maybe that's a solution worth considering.  Using the rings
> > have a major challenge on the limitation of ring size, so that for e.g. an
> > ioctl we need to make sure the pages to dirty within an ioctl procedure
> > will not be more than the ring can take.  Using dirty bitmap for a last
> > phase sync of constant (but still very small amount of) dirty pages does
> > sound reasonable and can avoid that complexity.  The payoff is we'll need
> > to allocate both the rings and the bitmaps.
> > 
> 
> Ok. I was thinking of using the bitmap to convey the dirty pages for
> this particular case, where we don't have running vcpu. The concern I had
> is the natural difference between a ring and bitmap. The ring-buffer is
> discrete, comparing to bitmap. Besides, it sounds a little strange to
> have two different sets of meta-data to track the data (dirty pages).

IMHO it's still important to investigate all potential users of the dirty
bitmap, like the GIC case.  Because we still want to know how many pages
can be dirtied in maximum that is to be dirtied (even without being able to
know which pages are dirtied from QEMU - or we don't need the bitmap but we
can set them in QEMU dirty bitmaps directly).

The thing is if we will only sync the dirty bitmap during the downtime, it
means there cannot have a large chunk of pages or the downtime is
unpredictable - QEMU will have its own way to calculate the downtime and
predict the best timing to stop the VM on src, however that's happened
before generating these dirty pages on the bitmap at least for GIC case..
So they need to be in small amount.

> 
> However, bitmap is easier way than per-vm ring. The constrains with
> per-vm ring is just as Peter pointed. So lets reuse the bitmap to
> convey the dirty pages for this particular case. I think the payoff,
> extra bitmap, is acceptable. For this, we need another capability
> (KVM_CAP_DIRTY_LOG_RING_BITMAP?) so that QEMU can collects the dirty
> bitmap in the last phase of migration.

Sounds reasonable.  We need to make sure that cap:

  - Be enabled before any vcpu creation (just like the ring cap)
  - Can be optional for ring, so e.g. x86 can skip both the last phase sync
    and also creation of the dirty bmap in kernel

> 
> If all of us agree on this, I can send another kernel patch to address
> this. QEMU still need more patches so that the feature can be supported.

Sure.  We can also wait for a few days to see whether Paolo has any input.

> 
> > > 
> > > To me, this is just a relaxation of an arbitrary limitation, as the
> > > current assumption that only vcpus can dirty memory doesn't hold at
> > > all.
> > 
> > The initial dirty ring proposal has a per-vm ring, but after we
> > investigated x86 we found that all legal dirty paths are with a vcpu
> > context (except one outlier on kvmgt which fixed within itself), so we
> > dropped the per-vm ring.
> > 
> > One thing to mention is that DMAs should not count in this case because
> > that's from device perspective, IOW either IOMMU or SMMU dirty tracking
> > should be reported to the device driver that interacts with the userspace
> > not from KVM interfaces (e.g. vfio with VFIO_IOMMU_DIRTY_PAGES).  That even
> > includes emulated DMA like vhost (VHOST_SET_LOG_BASE).
> > 
> 
> Thanks to Peter for mentioning the per-vm ring's history. As I said above,
> lets use bitmap instead if all of us agree.
> 
> If I'm correct, Marc may be talking about SMMU, which is emulated in host
> instead of QEMU. In this case, the DMA target pages are similar to those
> pages for vgic/its tables. Both sets of pages are invisible from QEMU.

OK, I'm not aware the SMMU can also be emulated in the host kernel, thanks
Gavin.  If so then we really need to think as I mentioned above since we
will only sync this when switchover, and if the DMA range can cover a large
portion of guest mem (assuming the physical pages to DMA can be randomly
allocated by guest device drivers) then it may be another problem to cause
drastic downtime.

-- 
Peter Xu

