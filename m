Return-Path: <kvm+bounces-26003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBA1B96F263
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 13:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36A981F253F8
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 11:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB9C1CB150;
	Fri,  6 Sep 2024 11:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ALrZP1mo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693501CB134
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 11:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725620877; cv=none; b=KBXHTdpLKYUKDluacrgXTejdx9B3JZwTHZalI6FJExi5gfAzRpsK+IfHiv5w+Zz+5drD7LzRpbaE4K0ZOK/Z4iZo997GZBzpg7QCYU/FicvmCkuNV3iSWmLYQsiZLbNa0HJifRZDbLDyAslvzp7t0TQuID9GY+Hnl3Iv8E72/JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725620877; c=relaxed/simple;
	bh=ttK9YiDCtOuh+peKXiWIt9Alg2m1IOKcYSf0Jb/ZpLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hUM9VQgTmaIr2spawPceeSUw5ggK52td3T/kmTMce1vHJbLFy8C1hhMvYnqx76o1YzMYZK30dC9kxJ41X+RTAD9w2tZScsPan0ngJw1Zd9ajeKrk8Pjq2c9DslJIaWLefmgbiv8BL80AXcF5rWwY7izG2MyP1VLFw2fX0JK451Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ALrZP1mo; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-427fc9834deso36145e9.0
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 04:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725620873; x=1726225673; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1kfdlvi3htUX5t/uzYteyfrsdGm7wcbhZeedCN8JXH8=;
        b=ALrZP1moNvoysfHT0YPQtablc+zKWyipDFWy6NFZdBqKZd8iEr1w5qTrjQ2Xp48I7u
         eWlzQzxPZz3pGqJG4aKkGep7GOlhwnrP62yNnRP6Jl5OGYofDe0CSlwXGU8RZGK+eaht
         mifjv8n8S1QpagRdJbAy+CLH2mBsIPUtGZ+NZviaOKvF8H9uRuGyPRZIUlJ5z7EHEfy6
         RQzvknfD5PLkDFMFaL94ysN1X/lFYmHr4xL7JnhT0Aadu1O6L13RSgVkopYeWwX+Ixb1
         AtIZvc+Sc0dCS3fcvIfrdw7mG2ehVrANH/4XzFUa3uIqVJ4VNhyPzO6mTOwaH0yNwVXT
         sP8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725620873; x=1726225673;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1kfdlvi3htUX5t/uzYteyfrsdGm7wcbhZeedCN8JXH8=;
        b=JX7EaA7YQ+iI3RJAnHGTv9hMPoNR5PtbRAkbblgkFB5L9zKCegjETm83jQ/tG5+A3A
         zB/n3IejhzaeZfu/PqiHymjYN4tsDbzgp82znnMcbMC70SR4RRI+h770HY2Xf3EOUATU
         8MnTDDKjOAvP1Q0PKgDPFu3oYuUUuT3JxkNkS+wjaO6stEIOLQ2mMgSpXaQjKUDT3N1a
         +PUWL5mThYcAKCSInzzky6ubWcoesRbPA8KD24zp6AJQY9oSGROPWlAYdBWYqWy68Kib
         Z8o4STqKW5ZKuJalOGzqoeRSf+yhd9s68EmqEXGxzHybbtG8xeTWadK7hKYc1RbKfdaf
         GUqw==
X-Forwarded-Encrypted: i=1; AJvYcCW9dIaSRPWDRSBgMqqXaZ69kzZps6qDk7QMWHKYusxNG6tto7aJBmoO7TyAzcRafJ7WqAM=@vger.kernel.org
X-Gm-Message-State: AOJu0YykFUWFuwH+LeNimFhM+poVc+amTRrFPho2+qwcopgmbjUwQkva
	d7iyqjNaxRi9kmBSiFjbRVmSeNS0Mu4phl+75N9hWYtKDDaxbw0jkaqDH3MjsQ==
X-Google-Smtp-Source: AGHT+IErQWOce1aTO7QUQS6iDDj2x0dGhvkowMBDS1btzgPV98ts3aP/uP28acSxLiOr1pFciOVHDg==
X-Received: by 2002:a05:600c:b93:b0:42b:8ff7:bee2 with SMTP id 5b1f17b1804b1-42ca05fbaccmr693485e9.5.1725620872291;
        Fri, 06 Sep 2024 04:07:52 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-374c2ffe062sm15554875f8f.29.2024.09.06.04.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 04:07:51 -0700 (PDT)
Date: Fri, 6 Sep 2024 11:07:47 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <Ztrigx4LmpbFiMba@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
 <20240830170426.GV3773488@nvidia.com>
 <ZtWMGQAdR6sjBmer@google.com>
 <20240903003022.GF3773488@nvidia.com>
 <ZtbQMDxKZUZCGfrR@google.com>
 <20240903235532.GJ3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240903235532.GJ3773488@nvidia.com>

On Tue, Sep 03, 2024 at 08:55:32PM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 03, 2024 at 09:00:32AM +0000, Mostafa Saleh wrote:
> > On Mon, Sep 02, 2024 at 09:30:22PM -0300, Jason Gunthorpe wrote:
> > > On Mon, Sep 02, 2024 at 09:57:45AM +0000, Mostafa Saleh wrote:
> > > > > > 2) Is there a reason the UAPI is designed this way?
> > > > > > The way I imagined this, is that userspace will pass the pointer to the CD
> > > > > > (+ format) not the STE (or part of it).
> > > > > 
> > > > > Yes, we need more information from the STE than just that. EATS and
> > > > > STALL for instance. And the cachability below. Who knows what else in
> > > > > the future.
> > > > 
> > > > But for example if that was extended later, how can user space know
> > > > which fields are allowed and which are not?
> > > 
> > > Changes the vSTE rules that require userspace being aware would have
> > > to be signaled in the GET_INFO answer. This is the same process no
> > > matter how you encode the STE bits in the structure.
> >
> > How? 
> 
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -504,6 +504,11 @@ struct iommu_hw_info_vtd {
>         __aligned_u64 ecap_reg;
>  };
>  
> +enum {
> +       /* The kernel understand field NEW in the STE */
> +       IOMMU_HW_INFO_ARM_SMMUV3_VSTE_NEW = 1 << 0,
> +};
> +
>  /**
>   * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
>   *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
> @@ -514,6 +519,7 @@ struct iommu_hw_info_vtd {
>   * @iidr: Information about the implementation and implementer of ARM SMMU,
>   *        and architecture version supported
>   * @aidr: ARM SMMU architecture version
> + * @kernel_capabilities: Bitmask of IOMMU_HW_INFO_ARM_SMMUV3_*
>   *
>   * For the details of @idr, @iidr and @aidr, please refer to the chapters
>   * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
> @@ -535,6 +541,7 @@ struct iommu_hw_info_arm_smmuv3 {
>         __u32 idr[6];
>         __u32 iidr;
>         __u32 aidr;
> +       __u32 kernel_capabilities;
>  };
>  
>  /**
> 
> For example. There are all sorts of rules about 0 filling and things
> that make this work trivially for the userspace.

I see, that makes sense to have.
However, I believe the UAPI can be more clear and solid in terms of
what is supported (maybe a typical struct with the CD, and some
extra configs?) I will give it a think.

> 
> > And why changing that in the future is not a problem as
> > sanitising IDRs?
> 
> Reporting a static kernel capability through GET_INFO output is
> easier/saner than providing some kind of policy flags in the GET_INFO
> input to specify how the sanitization should work.

I don’t think it’s “policy”, it’s just giving userspace the minimum
knowledge it needs to create the vSMMU, but again no really strong
opinion about that.

> 
> > > This confirmation of kernel support would then be reflected in the
> > > vIDRs to the VM and the VM could know to set the extended bits.
> > > 
> > > Otherwise setting an invalidate vSTE will fail the ioctl, the VMM can
> > > log the event, generate an event and install an abort vSTE.
> > > 
> > > > > Overall this sort of direct transparency is how I prefer to see these
> > > > > kinds of iommufd HW specific interfaces designed. From a lot of
> > > > > experience here, arbitary marshall/unmarshall is often an
> > > > > antipattern :)
> > > > 
> > > > Is there any documentation for the (proposed) SMMUv3 UAPI for IOMMUFD?
> > > 
> > > Just the comments in this series?
> > 
> > But this is a UAPI. How can userspace implement that if it has no
> > documentation, and how can it be maintained if there is no clear
> > interface with userspace with what is expected/returned...
> 
> I'm not sure what you are looking for here? I don't think an entire
> tutorial on how to build a paravirtualized vSMMU is appropriate to
> put in comments?

Sorry, I don’t think I was clear, I meant actual documentation for
the UAPI, as in RST files for example. If I want to support that
in kvmtool how can I implement it? I think we should have clear
docs for the UAPI with what is exposed from the driver, what are the
possible returns, expected behaviour of abort, bypass in the vSTE...,
it also makes it easier to reason about some of the choices.

> 
> The behavior of the vSTE processing as a single feature should be
> understandable, and I think it is from the comments and code. If it
> isn't, lets improve that.
> 
> There is definitely a jump from knowing how these point items work to
> knowing how to build a para virtualized vSMMU in your VMM. This is
> likely a gap of thousands of lines of code in userspace :\
> 
> > But we have a different model, with virtio-iommu, it typically presents
> > the device to the VM and on the backend it calls VFIO MAP/UNMAP.
> 
> I thought pkvm's model was also map/unmap - so it could suppor HW
> without nesting?
> 

Yes, it’s map/unmap based, but it has to be implemented in the
hypervisor, it doesn’t rely on VFIO.

Also, I have been looking at nesting recently (but for the host).

>
> > Although technically we can have virtio-iommu in the hypervisor (EL2),
> > that is a lot of complexit and increase in the TCB of pKVM.
> 
> That is too bad, it would be nice to not have to do everything new
> from scratch to just get to the same outcome. :(
> 

Yeah, I agree, yet a new pv interface :/
Although, it’s quite simple as it follows Linux IOMMU semantics with
HVC as transport and no in-memory data structures, queues...

Not implementing virtio in the hypervisor was an initial design choice
as it would be very challenging in terms of reasoning about the TCB.

> > I haven’t been keeping up with iommufd lately, I will try to spend more
> > time on that in the future.
> > But my idea is that we would create an IOMMUFD, attach it to a device and then
> > through some extra IOCTLs, we can configure some “virtual” topology for it which
> > then relies on KVM, again this is very early, and we need to support pKVM IOMMUs
> > in the host first (I plan to send v2 RFC soon for that)
> 
> Most likely your needs here will match the needs of the confidential
> compute people which are basically doing that same stuf. The way pKVM
> wants to operate looks really similar to me to how the confidential
> compute stuff wants to work where the VMM is untrusted and operations
> are delegated to some kind of secure world.
> 

Exactly.

> So, for instance, AMD recently posted patches about how they would
> create vPCI devices in their secure world, and there are various
> things in the works for secure IOMMUs and so forth all with the
> intention of not trusting the VMM, or permitting the VMM to compromise
> the VM.
> 

I have seen those, but didn't get the time to read them

> I would *really* like everyone to sit down and figure out how to
> manage virtual device lifecycle in a single language!

Yes, just like the guest_memfd work. There has been also
some work to unify some of the guest HVC bits:
https://lore.kernel.org/all/20240830130150.8568-1-will@kernel.org/

We should do the same for IOMMUs and IO.

> 
> > > I haven't heard if someone is going to KVM forum to talk about
> > > vSMMUv3? Eric? Nicolin do you know?
> > 
> > I see, I won’t be in KVM forum, but I plan to attend LPC, we can discuss
> > further there if people are interested.
> 
> Sure, definately, look forward to meeting you!

Great, me too!

Thanks,
Mostafa

> 
> Jason

