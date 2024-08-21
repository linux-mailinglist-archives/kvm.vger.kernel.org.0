Return-Path: <kvm+bounces-24704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A6A0E95996E
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 13:19:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02F48B2470D
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 11:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BB8209FF6;
	Wed, 21 Aug 2024 09:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kdPmpc8F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A322209FE8
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 09:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724234022; cv=none; b=cnilKz7ww28vnR/0vaHDVuYBRZd/yy5eiAdcf5JKyVcCnjgthdofsenvBNK6+BsOFNyl0lZpQN6+19VNw+rTX49w7zOw8TK9YIP8ezICQui0LgzhDxVGC+uVUc9b+dfxkBrOpZNOhbWzseoZ7Kl1oexDGvz8DjfjCYNux8w5J1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724234022; c=relaxed/simple;
	bh=4jQk83b9P8NGlcRViTcEt37cvEix9cl6+yXwsGxW3nI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8PytjW+uqTn+J3jI1nQHftFJRMpzH/rl7ZWC+2pTqI+d4ryjaXsZrbx/S0BBBAbIMA4QN6u2g0nqoB9/OrUjox6vR7HZyz+ci5J0AUqqwj54tpcC/exV9QzkTMJ9N3K9BsRHbkXnExxjuPoTDfpolFmWEuCHltHdWY8DKJ3RLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kdPmpc8F; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-428e12f6e56so51945e9.0
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 02:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724234019; x=1724838819; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=shPtI4yPMxhwNt4uha1HbLqCMGDAgRxC+dkJsclhuHA=;
        b=kdPmpc8FoXvoQo4bnaf4cdMw8AE2MZj7LVTVmrq4SMfFNktMQmtn60naWWrskOW5bk
         GPy0xbwY5XzJNQwku22Ehx7oQBiOxzdi/MVnd0MXmCx/B943SXRNwZ6xioM2WYqxUpSk
         jB0KhmGpaV4+UBSd0pD+OIntW3so1ddwy/2/5viM+3NEKXOXHtVFWBUoccq6CEndBlfl
         y3KsDSQbMhiypsbGUcu9xwrUm+r40WiiYxzpsAIROg3TBdIlIL3cMO5fNehFwFPt84Ot
         NP4zGXh096q0dyZ/Qiy5Psi+i+9Cv97MYVOR4OMoX7kuCt64HtTLOtEq5mO6ECg/m2rP
         C+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724234019; x=1724838819;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=shPtI4yPMxhwNt4uha1HbLqCMGDAgRxC+dkJsclhuHA=;
        b=q1bu5Fzo2rEALHN5ZMlDMD3aamw6h3r+2X+YEAI+2YunqnDZcBPv8FBmtuT7fYlx1X
         xpImtGrDkepBfReRxrulI9BbhAcy8bmqgCyNLjxq8JPV8BzE5U9BOBjbQkiBWr3Ac+jE
         DfsutiIxjFdNR/4hpEaQ005DuqZMlzdz6+5B0JjuM3DsRPmAabRkgN7PdbG6UEpxsTnc
         3uWuW6vJw0ycfADs5Pu7NZ4wEprsN9Jo4azZDcvUTMtJU1LveSLzucwkK1jHbUB8dItg
         vrJhbECIpub7GfzzWv0BkPoUR7yZNQIHcsrRAxTMDEA2GvH4mNKLaxeAiyUxXxd/tS+s
         VlCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqRXgieCyT5CCcOJA0NVEgCtTbOiUv8Cu8KJso6vg6ywdmTUl47wr/4pp5GELcNHzls9w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm7EcR+1WmdJB3VE1pJhvCwyjxoa+mH7GS2Cey/m1/4rOB+rFT
	3NG0/yOG+uZusG/ya9hBf4w/7VIh63Eqj7ydy7aM6Oj4PCPyoqqfNlrEt4xuFw==
X-Google-Smtp-Source: AGHT+IHUAEyavgkTbRh5dHjOmtVDPm5Mvfn00nNuswalwfrfossBr6xCiGgGPEQlL0lIyjnw6dvHOA==
X-Received: by 2002:a05:600c:1d9a:b0:426:6413:b681 with SMTP id 5b1f17b1804b1-42ab615a8acmr2142795e9.6.1724234018435;
        Wed, 21 Aug 2024 02:53:38 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-371a937a5f4sm10928107f8f.51.2024.08.21.02.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 02:53:37 -0700 (PDT)
Date: Wed, 21 Aug 2024 09:53:33 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <ZsW5HRZj2O2hGQYc@google.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <ZsRUDaFLd85O8u4Z@google.com>
 <20240820120102.GB3773488@nvidia.com>
 <ZsT0Fd5FHS47gm0-@google.com>
 <20240820202138.GH3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240820202138.GH3773488@nvidia.com>

On Tue, Aug 20, 2024 at 05:21:38PM -0300, Jason Gunthorpe wrote:
> On Tue, Aug 20, 2024 at 07:52:53PM +0000, Mostafa Saleh wrote:
> > On Tue, Aug 20, 2024 at 09:01:02AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Aug 20, 2024 at 08:30:05AM +0000, Mostafa Saleh wrote:
> > > > Hi Jason,
> > > > 
> > > > On Tue, Aug 06, 2024 at 08:41:15PM -0300, Jason Gunthorpe wrote:
> > > > > Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
> > > > > works. When S2FWB is supported and enabled the IOPTE will force cachable
> > > > > access to IOMMU_CACHE memory and deny cachable access otherwise.
> > > > > 
> > > > > This is not especially meaningful for simple S2 domains, it apparently
> > > > > doesn't even force PCI no-snoop access to be coherent.
> > > > > 
> > > > > However, when used with a nested S1, FWB has the effect of preventing the
> > > > > guest from choosing a MemAttr that would cause ordinary DMA to bypass the
> > > > > cache. Consistent with KVM we wish to deny the guest the ability to become
> > > > > incoherent with cached memory the hypervisor believes is cachable so we
> > > > > don't have to flush it.
> > > > > 
> > > > > Turn on S2FWB whenever the SMMU supports it and use it for all S2
> > > > > mappings.
> > > > 
> > > > I have been looking into this recently from the KVM side as it will
> > > > use FWB for the CPU stage-2 unconditionally for guests(if supported),
> > > > however that breaks for non-coherent devices when assigned, and
> > > > limiting assigned devices to be coherent seems too restrictive.
> > > 
> > > kvm's CPU S2 doesn't care about non-DMA-coherent devices though? That
> > > concept is only relevant to the SMMU.
> >
> > Why not? That would be a problem if a device is not dma coherent,
> > and the VM knows that and maps it’s DMA memory as non cacheable.
> > But it would be overridden by FWB in stage-2 to be cacheable,
> > it would lead to coherency issues.
> 
> Oh, from that perspective yes, but the entire point of S2FWB is that
> VM's can not create non-coherent access so it is a bit nonsense to ask
> for both S2FWB and try to assign a non-DMA coherent device.

Yes, but KVM sets FWB unconditionally and would use cacheable mapping
for stage-2, and I expect the same for the nested SMMU.

> 
> > Yes, that also breaks (although I think this is an easier problem to
> > solve)
> 
> Well, it is easy to solve, just don't use S2FWB and manually flush the
> caches before the hypervisor touches any memory. :)

Yes, although that means virtualized devices would have worse
performance :/ but I guess there is nothing more to do here.

I have some ideas about that, I can send patches to the kvm list
as an RFC.

> 
> > What I mean is the master itself not the SMMU (the SID basically),
> > so in that case the STE shouldn’t have FWB enabled.
> 
> That doesn't matter, those cases will not pass in IOMMU_CACHE and they
> will work fine with S2FWB turned on.
> 

But that won’t be the case in nested? Otherwise why we use FWB in the
first place.

> > > Also bear in mind VFIO won't run unless ARM_SMMU_FEAT_COHERENCY is set
> > > so we won't even get a chance to ask for a S2 domain.
> > 
> > Oh, I think that is only for the SMMU, not for the master, the
> > SMMU can be coherent (for pte, ste …) but the master can still be
> > non coherent. Looking at how VFIO uses it, that seems to be a bug?
> 
> If there are mixes of SMMU feature and dev_is_dma_coherent() then it
> would be a bug yes..
> 

I think there is a bug, I was able to assign a “non-coherent” device with
VFIO with no issues, and it allows it as long as the SMMU is coherent.

> I recall we started out trying to use dev_is_dma_coherent() but
> Christoph explained it doesn't work that generally:
> 
> https://lore.kernel.org/kvm/20220406135150.GA21532@lst.de/
> 
> Seems we sort of gave up on it, too complicated. Robin had a nice
> observation of the complexity:
> 
>     Disregarding the complete disaster of PCIe No Snoop on Arm-Based 
>     systems, there's the more interesting effectively-opposite scenario 
>     where an SMMU bridges non-coherent devices to a coherent interconnect. 
>     It's not something we take advantage of yet in Linux, and it can only be 
>     properly described in ACPI, but there do exist situations where 
>     IOMMU_CACHE is capable of making the device's traffic snoop, but 
>     dev_is_dma_coherent() - and device_get_dma_attr() for external users - 
>     would still say non-coherent because they can't assume that the SMMU is 
>     enabled and programmed in just the right way.
> 
> Anyhow, for the purposes of KVM and VFIO, devices that don't work with
> IOMMU_CACHE are not allowed. From an API perspective
> IOMMU_CAP_CACHE_COHERENCY is supposed to return if the struct device
> can use IOMMU_CACHE.
> 
> The corner case where we have a ARM_SMMU_FEAT_COHERENCY SMMU but
> somehow specific devices don't support IOMMU_CACHE is not properly
> reflected in IOMMU_CAP_CACHE_COHERENCY. I don't know how to fix that,
> and we've been ignoring it for a long time now :)

Thanks a lot for the extra context!

Maybe the SMMUv3 .capable, should be changed to check if the device is
coherent (instead of using dev_is_dma_coherent, it can use lower level
functions from the supported buses)

Also, I think supporting IOMMU_CACHE is not enough, as the SMMU can
support it but the device is still not coherent.

Thanks,
Mostafa

> 
> Jason

