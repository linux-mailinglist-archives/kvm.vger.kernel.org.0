Return-Path: <kvm+bounces-26233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34DF49735AE
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:56:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACA461F255F1
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C0C189BBA;
	Tue, 10 Sep 2024 10:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cD16+RVy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0437E5674D
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965762; cv=none; b=jBZQCFHE8Src6SLzRBuJ3TGEK2MH1c3emdiLvVC0EwZtDK3L0Vmr/8lkdiG/mL4l2DE6rxipmQbBSfhu6/vZBzV4B3qoCEgvECKwa3Z9DIs0wMbZQLnSM7fSP4H3xCKukuXaG7Uq1yGcvIMVPXgip4s75WOtHklNwB2Vn5eR/AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965762; c=relaxed/simple;
	bh=E0rU2Bx/jS99DDu2M3sefvBWt8JU8LAOi0vcShQGr6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QoYkpOxm1LHCLaySLumnTmLBmHbaJG8lRKDoa/r8TruMyKm5RbRr1BWj/qUsHdGL4mFuAonhdDvzZU3baPkBrZRXGBwMuxCnQUcqTbV06alsgJqAJBObwuB6NF0BJrLS+SzlHZSSrq4dZElYGP4Y2d3Tv+uHT9d9EoyuOgOYJMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cD16+RVy; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c2460e885dso11596a12.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 03:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725965759; x=1726570559; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vHmk114QIZCjlFSKd2nx+MtW7wZ0G3Zn0tQIsPkVXhc=;
        b=cD16+RVy8eM9jzRWyDKago4J3Vok7SDzOz/X9qurVGKw8twoB/6rG3ms34NoVyqr6q
         znpfcu/k3LJ3AyxmM0lIricHTYiXyd337F6eA1Hq81gaTBWC2j7ZhqhSpuu053307toG
         VxTzGlg1Jz5Vg+AdcLvjNvrJxCu2uawlazXas6aSkSjMUHUZPooaNzzYdf36nCFcTOeV
         Ra+Qlh5VeD+GCIMak4NEM8hyEPtitzWU11I7n4q7ZlF/DQ6zYcn53QSk77+LNiUFCmdW
         A8gVyqpNGaed+OEHlUahmKFvl2Z4YElWGW36ytFGjTEPJvYUGjNhNCEdRLwNofISZl0J
         p7gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725965759; x=1726570559;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vHmk114QIZCjlFSKd2nx+MtW7wZ0G3Zn0tQIsPkVXhc=;
        b=uyz2FhTJk52qgN/RLCRCRyZWrSo1XkGc1cwXPObHWpIgAs86oFZFNe2KoqazlbOzTg
         PksDIDUdvlk12uV/pMQvtxt6KVst2eqahlH3lIogpkkQ5GR+VTKHVcB5L15yEfSEI1vC
         l+AnyZmUGOxJOrpgY5gyLOQBu8DfwMt0A8JO10r1XgSGutxtZXP19fZCZzT6c8Jy8xrk
         si0zp54NXn0xZu79xUwg2Ig9Z0cpGckuaop7G+NKRY+2jP3pHJs+PBs5PWUlGe/5bGBU
         ICkkyLqhyXF4RerGUvtOFlqgTwjlXvenNpJwzMIOShGDl5wC++SiGLrQra7tWFR7L+Pz
         wOgg==
X-Forwarded-Encrypted: i=1; AJvYcCWDyuAr3v9gPCy/loLcPnSOQm4Xwu9CRwJNTqS6/zl7IiInYGGqmlTA6XLWgKL5DbpcQ+8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIe/lcKfNCOw8wuazkZEUF16px+Kda+6NR4bs/YltamWY3Honm
	bj4pXxYjQIcHA2G3Tg3MN6zaEWPJ4BgenF0NgT/rdfciQXUeImcxBHSvkhZWgw==
X-Google-Smtp-Source: AGHT+IH5Z6CO+MKfDYUG1iOU31Fa2e8Ac+77rN2VKHvSd6OZvtfGFA8hOAHmo3xhEkofbaoqsCkAhQ==
X-Received: by 2002:a05:6402:34d5:b0:58b:15e4:d786 with SMTP id 4fb4d7f45d1cf-5c4040d9d24mr152948a12.5.1725965758834;
        Tue, 10 Sep 2024 03:55:58 -0700 (PDT)
Received: from google.com (205.215.190.35.bc.googleusercontent.com. [35.190.215.205])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb8afc9sm108460105e9.44.2024.09.10.03.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 03:55:58 -0700 (PDT)
Date: Tue, 10 Sep 2024 10:55:51 +0000
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
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <ZuAlt9SsijRxuGLk@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHhdj6RAKACBCUG@google.com>
 <20240830164019.GU3773488@nvidia.com>
 <ZtWFkR0eSRM4ogJL@google.com>
 <20240903000546.GD3773488@nvidia.com>
 <ZtbBTX96OWdONhaQ@google.com>
 <20240903233340.GH3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240903233340.GH3773488@nvidia.com>

On Tue, Sep 03, 2024 at 08:33:40PM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 03, 2024 at 07:57:01AM +0000, Mostafa Saleh wrote:
> 
> > Basically, I believe we shouldn’t set FWB blindly just because it’s supported,
> > I don’t see how it’s useful for stage-2 only domains.
> 
> And the only problem we can see is some niche scenario where incoming
> memory attributes that are already requesting cachable combine to a
> different kind of cachable?

No, it’s not about the niche scenario, as I mentioned I don’t think
we should enable FWB because it just exists. One can argue the opposite,
if S2FWB is no different why enable it?

AFAIU, FWB would be useful in cases where the hypervisor(or VMM) knows
better than the VM, for example some devices MMIO space are emulated so
they are normal memory and it’s more efficient to use memory attributes.

Taking into consideration all the hassle that can happen if non-coherent
devices use the wrong attribute, I’d suggest either set FWB only for
coherent devices (I know it’s not easy to define, but maybe be should?)
or we have a new CAP where the caller is aware of that. But I don’t think
the driver should decide that on behalf of the caller.

> 
> > And I believe making assumptions about VFIO (which actually is not correctly
> > enforced at the moment) is fragile.
> 
> VFIO requiring cachable is definately not fragile, and it also sets
> the IOMMU_CACHE flag to indicate this. Revising VFIO to allow
> non-cachable would be a signficant change and would also change what
> IOMMU_CACHE flag it sets.
> 

I meant the driver shouldn't assume the caller behaviour, if it's VFIO
or something new.

> > and we should only set FWB for coherent
> > devices in nested setup only where the VMM(or hypervisor) knows better than
> > the VM.
> 
> I don't want to touch the 'only coherent devices' question. Last time
> I tried to do that I got told every option was wrong.
> 
> I would be fine to only enable for nesting parent domains. It is
> mandatory here and we definitely don't support non-cachable nesting
> today.  Can we agree on that?
> 
Why is it mandatory?

I think a supporting point for this, is that KVM does the same for
the CPU, where it enables FWB for VMs if supported. I have this on
my list to study if that can be improved. But may be if we are out
of options that would be a start.

> Keep in mind SMMU S2FWB is really new and probably very little HW
> supports it right now. So we are not breaking anything existing
> here. IMHO it is better to always enable the stricter features going
> forward, and then evaluate an in-kernel opt-out if someone comes with
> a concrete use case.
> 

I agree, it’s unlikely that this breaks existing hardware, but I’d
be concerned if FWB is enabled unconditionally it breaks devices in
the future and we end up restricting it more.

Thanks,
Mostafa
> Jason

