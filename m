Return-Path: <kvm+bounces-25662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5A4F968339
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 11:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E9C32825ED
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 09:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B63D71C3300;
	Mon,  2 Sep 2024 09:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1ICVgLgw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3505A1C32F2
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 09:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725269401; cv=none; b=pIEr3iqfOEcCPj1sENOVq3PfWEdPYk7vagBMNghbC2fFCQfYj5gOzFYZ5OiFWxR/mOvG+zoI0DXyij00yyu8qhJFbpOBIEDFJ06GgOntinYp3LQPDCzk3mYmH/h5MD6nm1HpCpSW6b0jKu7nF42zMZNob/L58+McJXx/tGXoi6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725269401; c=relaxed/simple;
	bh=B1qmeunmzRW7j1S/b5dM9pv6wNVyxv2E53BOHoVet/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJ1K84BZK8ARSVoLqxFCk3PqgVIWlrLTrhtwU9iqzvvGWChb2HmDbWxi+sX2KusmHSJiH2WAZZuayBRT3toPVzjtpiTeXcoCLmgLPRCrNgwEasY0U0GCq60zM6MG250YhsD7Uif4RP55fBmiEXZGDo9vGlPFZ+K6HYB2+oKKxbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1ICVgLgw; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c247dd0899so9293a12.1
        for <kvm@vger.kernel.org>; Mon, 02 Sep 2024 02:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725269398; x=1725874198; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VJE54eIljBo+04QQocBk6CxFcwFwa7n+6hpWhqzR/Xc=;
        b=1ICVgLgwB79+g8ZU8p4vyVpp7IPlZr5BO0Tcy5t2HbaAUpCww2UoAVgFlT0UFeACoB
         /CeRMc+6vYVA3p6hSkFn+R0aSQMzxnUzzSqzJAi2sCB/OjyTGiuZqVbH1nqIifwVqafK
         T891u1WKUA4xWX5sxk3Vglc8AObZHVbUBi5kLgyF3Wd2AEOj7BHo961GyJbi1vR3XH40
         ekA45rUqDR/YDmlSXbDLht5mJVhuXodOWWT1ovqqyvjJe+ix/D00x9k2dyWe9qW7W95/
         cEpLYhsuhdkDeWg2tpGRw5PyQubTbrX5NO6QE/j1oMTjEuIT5dkemOjojDBKDy1OILMt
         C++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725269398; x=1725874198;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VJE54eIljBo+04QQocBk6CxFcwFwa7n+6hpWhqzR/Xc=;
        b=GeleynVPiryJ4z+nqtWyS+a2zMgMZgpDFHfFaLBi3gNEhcstH3L4JUZ9pGaxUtPv0x
         2VYPfl50iGwXCKkj9ag2zPqGqAInaa7nlMLth+eHoMR4MGcaIPW7Y9Seca0dNJmj7KE9
         Ln3JXSARdZ34Sfac6FYNk9XbSmKGK37UA10BO1Xpv7Cz/70fMyzsfPnDJs5I0xtUceMe
         fh2u9IFU3ZLYIRrINvaychS0DAGjszAq/Pp+6V4eUhgCgZHDOYlwU6N7j7vndaojfmWC
         24cLlXEc0b/0QhtNQoPaeb2WDuzEmkT0xM8roEtEpB86ipiGTGG3YirVRqGmlecrH4RR
         7G8g==
X-Forwarded-Encrypted: i=1; AJvYcCVjT3qDtr/qay4lv5wyGNGIHSGnMXClor0+JXr6kavz0j14R3Fb89VAamEBnYMTIURiPeI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqNfAcJIHTXbra043AYVynOXzuADu4OGHhUFuaAqxUWG6HKjB7
	BXf7etVvKp11UEHcj3d5gbfSSKTp6WjM6DgHepI6CtdoVLqDSlQ2EboFs36Jfw==
X-Google-Smtp-Source: AGHT+IHjBDWncMa0JFzAVRBZvunVV3/xf27Bk1UBfEqTh/oBWIS4ZrnlqS4ID0HplL23Cxhn09935A==
X-Received: by 2002:a05:6402:51c8:b0:5c2:62c8:30a with SMTP id 4fb4d7f45d1cf-5c262c80401mr55276a12.1.1725269398075;
        Mon, 02 Sep 2024 02:29:58 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989021960sm532554566b.79.2024.09.02.02.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 02:29:57 -0700 (PDT)
Date: Mon, 2 Sep 2024 09:29:53 +0000
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
Message-ID: <ZtWFkR0eSRM4ogJL@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHhdj6RAKACBCUG@google.com>
 <20240830164019.GU3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240830164019.GU3773488@nvidia.com>

On Fri, Aug 30, 2024 at 01:40:19PM -0300, Jason Gunthorpe wrote:
> On Fri, Aug 30, 2024 at 03:12:54PM +0000, Mostafa Saleh wrote:
> > > +	/*
> > > +	 * If for some reason the HW does not support DMA coherency then using
> > > +	 * S2FWB won't work. This will also disable nesting support.
> > > +	 */
> > > +	if (FIELD_GET(IDR3_FWB, reg) &&
> > > +	    (smmu->features & ARM_SMMU_FEAT_COHERENCY))
> > > +		smmu->features |= ARM_SMMU_FEAT_S2FWB;
> > I think that’s for the SMMU coherency which in theory is not related to the
> > master which FWB overrides, so this check is not correct.
> 
> Yes, I agree, in theory.
> 
> However the driver today already links them together:
> 
> 	case IOMMU_CAP_CACHE_COHERENCY:
> 		/* Assume that a coherent TCU implies coherent TBUs */
> 		return master->smmu->features & ARM_SMMU_FEAT_COHERENCY;
> 
> So this hunk was a continuation of that design.
> 
> > What I meant in the previous thread that we should set FWB only for coherent
> > masters as (in attach s2):
> > 	if (smmu->features & ARM_SMMU_FEAT_S2FWB && dev_is_dma_coherent(master->dev)
> > 		// set S2FWB in STE
> 
> I think as I explained in that thread, it is not really correct
> either. There is no reason to block using S2FWB for non-coherent
> masters that are not used with VFIO. The page table will still place
> the correct memattr according to the IOMMU_CACHE flag, S2FWB just
> slightly changes the encoding.

It’s not just the encoding that changes, as
- Without FWB, stage-2 combine attributes
- While with FWB, it overrides them.

So a cacheable mapping in stage-2 can lead to a non-cacheable
(or with different cachableitiy attributes) transaction based on the
input. I am not sure though if there is such case in the kernel.

Also, that logic doesn't only apply to VFIO, but also for stage-2
only SMMUs that use stage-2 for kernel DMA.

> 
> For VFIO, non-coherent masters need to be blocked from VFIO entirely
> and should never get even be allowed to get here.
> 
> If anything should be changed then it would be the above
> IOMMU_CAP_CACHE_COHERENCY test, and I don't know if
> dev_is_dma_coherent() would be correct there, or if it should do some
> ACPI inspection or what.

I agree, I believe that this assumption is not accurate, I am not sure
what is the right approach here, but in concept I think we shouldn’t
enable FWB for non-coherent devices (using dev_is_dma_coherent() or
other check)

Thanks,
Mostafa
> 
> So let's drop the above hunk, it already happens implicitly because
> VFIO checks it via IOMMU_CAP_CACHE_COHERENCY and it makes more sense
> to put the assumption in one place.
> 
> Thanks,
> Jason

