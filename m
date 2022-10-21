Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE92607BB6
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 18:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJUQFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 12:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJUQFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 12:05:32 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C57515203F
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 09:05:31 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s196so2930646pgs.3
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 09:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xahBuRnoLPS6xXm4/pNsk2n041fH2rhoxEc7df44/Hs=;
        b=ovZCgFiWlnNqjK4HXIfX19MZtRdnNipsOsIuSJOhYhumwgFBOR8A55DWqBT3+Cautw
         lD6pZz915Rh/Z/x7YgXfo10lauDWm8/XQT/IkOacscKD4coZndakis4ZBrvukctVltrE
         1CYxVRi9L8Kh+YChmDM5riMmgJzs3dO20/o6Rb1aGcl/r62ZQxSgoF7xe7UWixjorT9b
         c9SSKIlp9q29qstQVa5P9qHRbw2lBmIjavL/x9IF6w0A8FyfpkS61XfdEdNsg+T3mo/9
         viRLDf1nwq0/gHXxkKSb7x066cf1BOhnl6lNDldYhw2k0B9qWdxeLcJZfM45I1e7jjlY
         aujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xahBuRnoLPS6xXm4/pNsk2n041fH2rhoxEc7df44/Hs=;
        b=tecIfdCE79dNX3DUX5nx3ZOatdahmS0kHdx4PXA168I31tiRvQ0hJBk00ikT9Qv9e7
         ZicyZI1rD2igX5eJTvgLNwE+Tlta2i5CBRbe2h6P1N9vxYJLn8Kk+w6Cahhiugw7eT5y
         NLD6k5dt/UK+mdSzwYE42Fo3zoLgNUsU85Rw9L8Ugz4x0Tmx4kf7s/P+LPPnwdYz5Z/C
         icfeeslKh/futcaf7yAGNfHTEgs6p3LrGbQlgyy7hBbMXt2gMhFvAQlx5H/LDpuPPwFU
         Z/pWr8TJ935D4KqjQYzHiuGj2PH7T25+qii8bz9hqZfkjCQQMdzWEPILxzCfTQo2Zubn
         6Ahg==
X-Gm-Message-State: ACrzQf0g9bixsuLwk7L0kam5XOvzpr0i0RKH+VQ/AFAkcDpVLaL7Vn7f
        ESNqKEhf4posil4w0NxIXjogkg==
X-Google-Smtp-Source: AMsMyM7VFpMgC7BigQ9gRFIXC+MdUD+v4XILkfgBtEipiyJt0relfKKGslFbu+TVkRCL7mDHLdOFiA==
X-Received: by 2002:a65:5b47:0:b0:46b:1a7d:7106 with SMTP id y7-20020a655b47000000b0046b1a7d7106mr16735869pgr.513.1666368330363;
        Fri, 21 Oct 2022 09:05:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i13-20020a170902c94d00b001754064ac31sm14990958pla.280.2022.10.21.09.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 09:05:29 -0700 (PDT)
Date:   Fri, 21 Oct 2022 16:05:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        peterx@redhat.com, will@kernel.org, catalin.marinas@arm.com,
        bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        shan.gavin@gmail.com
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1LDRkrzPeQXUHTR@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com>
 <Y1Hdc/UVta3A5kHM@google.com>
 <8635bhfvnh.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8635bhfvnh.wl-maz@kernel.org>
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

On Fri, Oct 21, 2022, Marc Zyngier wrote:
> On Fri, 21 Oct 2022 00:44:51 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Tue, Oct 11, 2022, Gavin Shan wrote:
> > > Some architectures (such as arm64) need to dirty memory outside of the
> > > context of a vCPU. Of course, this simply doesn't fit with the UAPI of
> > > KVM's per-vCPU dirty ring.
> > 
> > What is the point of using the dirty ring in this case?  KVM still
> > burns a pile of memory for the bitmap.  Is the benefit that
> > userspace can get away with scanning the bitmap fewer times,
> > e.g. scan it once just before blackout under the assumption that
> > very few pages will dirty the bitmap?
> 
> Apparently, the throttling effect of the ring makes it easier to
> converge. Someone who actually uses the feature should be able to
> tell you. But that's a policy decision, and I don't see why we should
> be prescriptive.

I wasn't suggesting we be prescriptive, it was an honest question.

> > Why not add a global ring to @kvm?  I assume thread safety is a
> > problem, but the memory overhead of the dirty_bitmap also seems like
> > a fairly big problem.
> 
> Because we already have a stupidly bloated API surface, and that we
> could do without yet another one based on a sample of *one*?

But we're adding a new API regardless.  A per-VM ring would definitely be a bigger
addition, but if using the dirty_bitmap won't actually meet the needs of userspace,
then we'll have added a new API and still not have solved the problem.  That's why
I was asking why/when userspace would want to use dirty_ring+dirty_bitmap.

> Because dirtying memory outside of a vcpu context makes it incredibly awkward
> to handle a "ring full" condition?

Kicking all vCPUs with the soft-full request isn't _that_ awkward.  It's certainly
sub-optimal, but if inserting into the per-VM ring is relatively rare, then in
practice it's unlikely to impact guest performance.

> > > Introduce a new flavor of dirty ring that requires the use of both vCPU
> > > dirty rings and a dirty bitmap. The expectation is that for non-vCPU
> > > sources of dirty memory (such as the GIC ITS on arm64), KVM writes to
> > > the dirty bitmap. Userspace should scan the dirty bitmap before
> > > migrating the VM to the target.
> > > 
> > > Use an additional capability to advertize this behavior and require
> > > explicit opt-in to avoid breaking the existing dirty ring ABI. And yes,
> > > you can use this with your preferred flavor of DIRTY_RING[_ACQ_REL]. Do
> > > not allow userspace to enable dirty ring if it hasn't also enabled the
> > > ring && bitmap capability, as a VM is likely DOA without the pages
> > > marked in the bitmap.
> 
> This is wrong. The *only* case this is useful is when there is an
> in-kernel producer of data outside of the context of a vcpu, which is
> so far only the ITS save mechanism. No ITS? No need for this.

How large is the ITS?  If it's a fixed, small size, could we treat the ITS as a
one-off case for now?  E.g. do something gross like shove entries into vcpu0's
dirty ring?

> Userspace knows what it has created the first place, and should be in
> charge of it (i.e. I want to be able to migrate my GICv2 and
> GICv3-without-ITS VMs with the rings only).

Ah, so enabling the dirty bitmap isn't strictly required.  That means this patch
is wrong, and it also means that we need to figure out how we want to handle the
case where mark_page_dirty_in_slot() is invoked without a running vCPU on a memslot
without a dirty_bitmap.

I.e. what's an appropriate action in the below sequence:

void mark_page_dirty_in_slot(struct kvm *kvm,
			     const struct kvm_memory_slot *memslot,
		 	     gfn_t gfn)
{
	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();

#ifdef CONFIG_HAVE_KVM_DIRTY_RING
	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
		return;

#ifndef CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP
	if (WARN_ON_ONCE(!vcpu))
		return;
#endif
#endif

	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
		unsigned long rel_gfn = gfn - memslot->base_gfn;
		u32 slot = (memslot->as_id << 16) | memslot->id;

		if (vcpu && kvm->dirty_ring_size)
			kvm_dirty_ring_push(&vcpu->dirty_ring,
					    slot, rel_gfn);
		else if (memslot->dirty_bitmap)
			set_bit_le(rel_gfn, memslot->dirty_bitmap);
		else
			???? <=================================================
	}
}


Would it be possible to require a dirty bitmap when an ITS is created?  That would
allow treating the above condition as a KVM bug.

> > > @@ -4499,6 +4507,11 @@ static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
> > >  {
> > >  	int r;
> > >  
> > > +#ifdef CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP
> > > +	if (!kvm->dirty_ring_with_bitmap)
> > > +		return -EINVAL;
> > > +#endif
> > 
> > This one at least is prettier with IS_ENABLED
> > 
> > 	if (IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) &&
> > 	    !kvm->dirty_ring_with_bitmap)
> > 		return -EINVAL;
> > 
> > But dirty_ring_with_bitmap really shouldn't need to exist.  It's
> > mandatory for architectures that have
> > HAVE_KVM_DIRTY_RING_WITH_BITMAP, and unsupported for architectures
> > that don't.  In other words, the API for enabling the dirty ring is
> > a bit ugly.
> > 
> > Rather than add KVM_CAP_DIRTY_LOG_RING_ACQ_REL, which hasn't been
> > officially released yet, and then KVM_CAP_DIRTY_LOG_ING_WITH_BITMAP
> > on top, what about usurping bits 63:32 of cap->args[0] for flags?
> > E.g.

For posterity, filling in my missing idea...

Since the size is restricted to be well below a 32-bit value, and it's unlikely
that KVM will ever support 4GiB per-vCPU rings, we could usurp the upper bits for
flags:

  static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u64 arg0)
  {
	u32 flags = arg0 >> 32;
	u32 size = arg0;

However, since it sounds like enabling dirty_bitmap isn't strictly required, I
have no objection to enabling KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP, my objection
was purely that KVM was adding a per-VM flag just to sanity check the configuration.

> > Ideally we'd use cap->flags directly, but we screwed up with
> > KVM_CAP_DIRTY_LOG_RING and didn't require flags to be zero :-(
> >
> > Actually, what's the point of allowing
> > KVM_CAP_DIRTY_LOG_RING_ACQ_REL to be enabled?  I get why KVM would
> > enumerate this info, i.e. allowing checking, but I don't seen any
> > value in supporting a second method for enabling the dirty ring.
> > 
> > The acquire-release thing is irrelevant for x86, and no other
> > architecture supports the dirty ring until this series, i.e. there's
> > no need for KVM to detect that userspace has been updated to gain
> > acquire-release semantics, because the fact that userspace is
> > enabling the dirty ring on arm64 means userspace has been updated.
> 
> Do we really need to make the API more awkward? There is an
> established pattern of "enable what is advertised". Some level of
> uniformity wouldn't hurt, really.

I agree that uniformity would be nice, but for capabilities I don't think that's
ever going to happen.  I'm pretty sure supporting enabling is actually in the
minority.  E.g. of the 20 capabilities handled in kvm_vm_ioctl_check_extension_generic(),
I believe only 3 support enabling (KVM_CAP_HALT_POLL, KVM_CAP_DIRTY_LOG_RING, and
KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2).
