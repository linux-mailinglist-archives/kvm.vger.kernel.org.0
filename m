Return-Path: <kvm+bounces-25664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 342789683E2
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 11:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 566E71C225F5
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 09:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 981581D3643;
	Mon,  2 Sep 2024 09:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bQW16Fqr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E8B1D2F6A
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 09:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725271073; cv=none; b=PIWCIqV/or35GgELr4xfolHlYseJkpigWiK3utgEw8FjLNmLxRnzhy9npBdta1AFBlYykX52XWVzY4TiPZDaeeBiMZEB0f1VdLDnnpvzHw69IRHb8KUb43wOob6nrbXX+6BrfPlDNSfvYiqFy7cpmw3jY1fDd3tTbv/AqnHCMxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725271073; c=relaxed/simple;
	bh=AebbeBylEZc6YvUUKEOp3IYHZ5WtMcK0qrIBOuhdE/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rEXNKIyYhLClhxm0SvnmOLrH8WA9DE2wwot8MuCp4E86fTll1m89yEdtx+BxUimB41Tfbz/aeOJBhC/X1OM1pEE2SKVl+veBKN4W0Ym6pu4ZxfFmtn3ERrziZOgZIZWwDpkRSQEm4Q1ig7iW3XzOS1aqWxKJ/0Wi1kmUmxzPgVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bQW16Fqr; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-427fc9834deso67565e9.0
        for <kvm@vger.kernel.org>; Mon, 02 Sep 2024 02:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725271070; x=1725875870; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lZQX/cMZETZqukPtivvikiv242o9q96eLnQhbaJJJkM=;
        b=bQW16FqryhnUyLrpsgxzMPXSaWoDDZg7m1dvmvTFcfxg07lFPfn80OSCSa9lIbX52a
         sl2a+FRg1b+0ZXN9JsiTUp0tF3PSG6lGf2Wyu8hVz1yQF+LzDVpk6+FIZfmY0DKRSSP1
         SH7JZs+Xi3TRyZJF53511ex/EX1+/BOYz4qparBYsUJNec5iX11nHEoWOHPK95+kRUv9
         geUv7uEozoGlotu3VwLnqYQZTsP3fdEmxe4JZqCl7gA+b9dJiW3qcTaCul05Oo+hcbjX
         rW55biPwVjavXaTrbIFqtFcv0s8219THiAe9nqosMsJoVVfQeL4nH+Edd+imPlqioAfP
         F8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725271070; x=1725875870;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lZQX/cMZETZqukPtivvikiv242o9q96eLnQhbaJJJkM=;
        b=Uejx2ou+kDj/lUGMcehBjmRb5GpdMjQw3Hz39NLRJkIYXMWHGZOGSCM1M75LVoI9Zn
         hWzU7QiwGdYzby7Lr8fJSFegpSLXl5qke6iRZqchk9gfgS5oIsIUdYs2w2yZQvO3lRCD
         XPh6dx497Qz0lPj50qSIjbfTd9H9KcdhOOZjOT/H27PKfEbnf0J+Ci5/giTMxPdpQ54a
         nJ3P1s4tWBdN2PXuI5ZzcP/nqgBkR7AGHk3yZacdMYPDoqcp/uuD6YzzP08qeRWfDszE
         HtQpHVuwbOI0vjdFaMPkuzUIYc/5kd/nTdP5VkEFUMz22RKIw0a4OLTVC7vRJCqiM0Ve
         SlOg==
X-Forwarded-Encrypted: i=1; AJvYcCVVY6us63kUPlFogCO7kAxtglfk1AQSqzD30fLp4yaPc6IKR338ERCaUXLKT5axCOfuzhI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2Xw6VNS+7ON4YVXL7JaMzASwFPKo5N40PtZ2wyiw4cJCEMKhi
	Gp04bDXcqBeaaFyDzQwSyxf3QLZT1veNawSKJNlS7XGxPPU6ne20hAjRL6Mf+g==
X-Google-Smtp-Source: AGHT+IFSZcv0nult7Zja5pAokUpRh3eCHY8+dggfufZa4QfUGMc7wSMOSbQ5AYJaIDsiCUY7g7vMyA==
X-Received: by 2002:a05:600c:500f:b0:426:5d89:896d with SMTP id 5b1f17b1804b1-42c78767f7amr1965085e9.1.1725271069765;
        Mon, 02 Sep 2024 02:57:49 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749ee4d391sm11015220f8f.3.2024.09.02.02.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 02:57:49 -0700 (PDT)
Date: Mon, 2 Sep 2024 09:57:45 +0000
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
Message-ID: <ZtWMGQAdR6sjBmer@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
 <20240830170426.GV3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240830170426.GV3773488@nvidia.com>

On Fri, Aug 30, 2024 at 02:04:26PM -0300, Jason Gunthorpe wrote:
> On Fri, Aug 30, 2024 at 04:09:04PM +0000, Mostafa Saleh wrote:
> > Hi Jason,
> > 
> > On Tue, Aug 27, 2024 at 12:51:38PM -0300, Jason Gunthorpe wrote:
> > > For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
> > > as the parent and a user provided STE fragment that defines the CD table
> > > and related data with addresses translated by the S2 iommu_domain.
> > > 
> > > The kernel only permits userspace to control certain allowed bits of the
> > > STE that are safe for user/guest control.
> > > 
> > > IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
> > > translation, but there is no way of knowing which S1 entries refer to a
> > > range of S2.
> > > 
> > > For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
> > > flush all ASIDs from the VMID after flushing the S2 on any change to the
> > > S2.
> > > 
> > > Similarly we have to flush the entire ATC if the S2 is changed.
> > > 
> > 
> > I am still reviewing this patch, but just some quick questions.
> > 
> > 1) How does userspace do IOTLB maintenance for S1 in that case?
> 
> See
> 
> https://lore.kernel.org/linux-iommu/cover.1724776335.git.nicolinc@nvidia.com
> 
> Patch 17

Thanks, I had this series on my radar, I will check it by this week.

>
> Really, this series and that series must be together. We have a patch
> planning issue to sort out here as well, all 27 should go together
> into the same merge window.
> 
> > 2) Is there a reason the UAPI is designed this way?
> > The way I imagined this, is that userspace will pass the pointer to the CD
> > (+ format) not the STE (or part of it).
> 
> Yes, we need more information from the STE than just that. EATS and
> STALL for instance. And the cachability below. Who knows what else in
> the future.

But for example if that was extended later, how can user space know
which fields are allowed and which are not?

> 
> We also want to support the V=0, Bypass and Abort STE configurations
> under the nesting domain (V, CFG required) so that the VIOMMU can
> remain affiliated with the STE in all cases. This is necessary to
> allow VIOMMU event reporting to always work.
> 
> Looking at the masks:
> 
> STRTAB_STE_0_NESTING_ALLOWED = 0xf80fffffffffffff
> STRTAB_STE_1_NESTING_ALLOWED = 0x380000ff
> 
> So we do use alot of the bits. Reformatting from the native HW format
> into something else doesn't seem better for VMM or kernel..
> 
> This is similar to the invalidation design where we also just forward
> the invalidation command as is in native HW format, and how IDR is
> done the same.
> 
> Overall this sort of direct transparency is how I prefer to see these
> kinds of iommufd HW specific interfaces designed. From a lot of
> experience here, arbitary marshall/unmarshall is often an
> antipattern :)

Is there any documentation for the (proposed) SMMUv3 UAPI for IOMMUFD?
I can understand reading IDRs from userspace (with some sanitation),
but adding some more logic to map vSTE to STE needs more care of what
kind of semantics are provided.

Also, I am working on similar interface for pKVM where we “paravirtualize”
the SMMU access for guests, it’s different semantics, but I hope we can
align that with IOMMUFD (but it’s nowhere near upstream now)

I see you are talking in LPC about IOMMUFD:
https://lore.kernel.org/linux-iommu/0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com/T/#m2dbb08f3bf8506a492bc7dda2de662e42371e683

Do you have any plans to talk about this also?

Thanks,
Mostafa
> 
> > Making user space messing with shareability and cacheability of S1 CD access
> > feels odd. (Although CD configure page table access which is similar).
> 
> As I understand it, the walk of the CD table will be constrained by
> the S2FWB, just like all the other accesses by the guest.
> 
> So we just take a consistent approach of allowing the guest to provide
> memattrs in the vSTE, CD, and S1 page table and rely on the HW's S2FWB
> to police it.
> 
> As you say there are lots of memattr type bits under direct guest
> control, it doesn't necessarily make alot of sense to permit
> everything in those contexts and then add extra code to do something
> different here.
> 
> Though I agree it looks odd, it is self-consistent.
> 
> Jason

