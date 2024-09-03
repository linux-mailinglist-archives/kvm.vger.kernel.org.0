Return-Path: <kvm+bounces-25718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6510C969645
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 09:57:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D942285B12
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FBF71DAC7D;
	Tue,  3 Sep 2024 07:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sUIERxrd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EB31CE6E9
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 07:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725350229; cv=none; b=n3XYLi42DTC5CRBPXgyTw0ELhhwakns1i3bpM7wGqT78TjjAY7WOzVZS+eqW/U3y5va480oCkzw4yIrQk6DImlGVUlxQuCI8GM+r5F2WkvroD2jDs7mwAzL085UCRUYaTb1e4fykvgl1m5ud+ulo9mX9l+iwpK2HIxP/HCd0m68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725350229; c=relaxed/simple;
	bh=bLFrm8+W36cFU2HdRdXUPsjNB7gq91ms8m5UZQZPs/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kwLB7ljMkvSmWBn7ObIZ204cCQ4EPhzhTD0dDHlHTdf6nG/EvARa6TMzYNk9DQluFg9Zq5Ib4Yn72Ms6XduPeEo0XpYTdfib1SuZglC/ZSOaH9CRilVZhgev6zI0W1KLONFrlv13lqsDZW42pRJDXHK9CspZwChCvWt3r7NOAP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sUIERxrd; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-42ba8928f1dso111315e9.1
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 00:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725350226; x=1725955026; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EpqgvHYsrTqtiBbD2gubTtjEbMzyUsaQNI2kDwROGw4=;
        b=sUIERxrdziVbJN/kLzKKsm7V+lUrKiVu8EtUePN+WWhHCYVfFUOpIBcMhI0o3QdDCk
         Cr1VAgcuiUNroaLvjMrLMXvzvJ0Mz5BuyQtNF2ur1iQz3Cs1HXopYJ5nfDLUvsr06GxX
         4h1fjT53u13KxTkEP7A6gy6ipR5UyTCEV+8txfirXJ6N4eaRz+ufheGgWbVI+Qfozgu1
         tIgGc4dwm1WRv1YEvvRXLJxulepCyV7kRj1GOE71SapGxNI1xObA/uLHIN+Z0AsAz84m
         2fZ/g81E5feDe3pNpy+B3cBSK3gIMDH/UlK5KjACCrgMkF65Ghldz3lbjw6WNNBuJXa4
         J6xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725350226; x=1725955026;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EpqgvHYsrTqtiBbD2gubTtjEbMzyUsaQNI2kDwROGw4=;
        b=D8dKKBoaZcqIrhVb7NIvCrzRmudh2etoCWCvRRSjqWCouCyH6UWKW5UcHVG1tchRcR
         9QLx5KN/7wGLu/90eclYp7IGUz3/8Am8UMlvEdEmM+H2puGxboIqi8Y9JUKUEln4Rq+0
         r1b1wcSee4r5p8j+ek7gTu55/I2faps7QKwTbE695yFR3hCsg9Xylk+cFZrVbkY6HFX0
         mh6jM8JGp+DxkHlwdbVMv1LIj0GqETUJnSg2ze/IWBcdSu7gbnkYohmwhIbV3fzRVixa
         6d8Lq3JE+9UpzXZGr5GPIO2++0Y9HocodgCx3QnJRVTqPt5kwKLU+aeaANxfHSiKDl2I
         EA/w==
X-Forwarded-Encrypted: i=1; AJvYcCX8ApTwK7JGLmEJr+AWkwJCHslwvabpVibIhWhnBQKXsnbmTELL+RF1J+8t7xjdqe9cSss=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3TSB4753gQiJANAs2lrEHIvJe9c+o9wEBCB1T/uGPrk9wZrrN
	3Pin6YbC6jDO7urZnSvN6pFl8B9FwBJPWk/H+tEQ3gIKZzaOHTbOoUNbXPliGA==
X-Google-Smtp-Source: AGHT+IHgA6nmHG1PnRdTR7J4T9ZeBV+88BPig2e5l9HlhMUvcfgRj5uIoCkj4peI2Tcgr2az2ArssQ==
X-Received: by 2002:a05:600c:1d9f:b0:428:e6eb:1340 with SMTP id 5b1f17b1804b1-42c33a5fb71mr3188345e9.4.1725350225593;
        Tue, 03 Sep 2024 00:57:05 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb5969234sm165927345e9.17.2024.09.03.00.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 00:57:05 -0700 (PDT)
Date: Tue, 3 Sep 2024 07:57:01 +0000
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
Message-ID: <ZtbBTX96OWdONhaQ@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHhdj6RAKACBCUG@google.com>
 <20240830164019.GU3773488@nvidia.com>
 <ZtWFkR0eSRM4ogJL@google.com>
 <20240903000546.GD3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240903000546.GD3773488@nvidia.com>

On Mon, Sep 02, 2024 at 09:05:46PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 02, 2024 at 09:29:53AM +0000, Mostafa Saleh wrote:
> > On Fri, Aug 30, 2024 at 01:40:19PM -0300, Jason Gunthorpe wrote:
> > > On Fri, Aug 30, 2024 at 03:12:54PM +0000, Mostafa Saleh wrote:
> > > > > +	/*
> > > > > +	 * If for some reason the HW does not support DMA coherency then using
> > > > > +	 * S2FWB won't work. This will also disable nesting support.
> > > > > +	 */
> > > > > +	if (FIELD_GET(IDR3_FWB, reg) &&
> > > > > +	    (smmu->features & ARM_SMMU_FEAT_COHERENCY))
> > > > > +		smmu->features |= ARM_SMMU_FEAT_S2FWB;
> > > > I think that’s for the SMMU coherency which in theory is not related to the
> > > > master which FWB overrides, so this check is not correct.
> > > 
> > > Yes, I agree, in theory.
> > > 
> > > However the driver today already links them together:
> > > 
> > > 	case IOMMU_CAP_CACHE_COHERENCY:
> > > 		/* Assume that a coherent TCU implies coherent TBUs */
> > > 		return master->smmu->features & ARM_SMMU_FEAT_COHERENCY;
> > > 
> > > So this hunk was a continuation of that design.
> > > 
> > > > What I meant in the previous thread that we should set FWB only for coherent
> > > > masters as (in attach s2):
> > > > 	if (smmu->features & ARM_SMMU_FEAT_S2FWB && dev_is_dma_coherent(master->dev)
> > > > 		// set S2FWB in STE
> > > 
> > > I think as I explained in that thread, it is not really correct
> > > either. There is no reason to block using S2FWB for non-coherent
> > > masters that are not used with VFIO. The page table will still place
> > > the correct memattr according to the IOMMU_CACHE flag, S2FWB just
> > > slightly changes the encoding.
> > 
> > It’s not just the encoding that changes, as
> > - Without FWB, stage-2 combine attributes
> > - While with FWB, it overrides them.
> 
> You mean there is some incomming attribute in the transaction
> (obviously not talking PCI here) and S2FWB combines with that?

Yes, stuff as cacheability (as defined by Arm spec)
I am not sure about PCI, but according to the spec:
	“PCIe does not contain memory type attributes, and each transaction
	takes a system-defined memory type when it progresses into the system”

> 
> > So a cacheable mapping in stage-2 can lead to a non-cacheable
> > (or with different cachableitiy attributes) transaction based on the
> > input. I am not sure though if there is such case in the kernel.
> 
> If the kernel supplies IOMMU_CACHE then the kernel also skips all the
> cache flushing. So it would be a functional problem if combining was
> causing a non-cachable access through a IOMMU_CACHE S2 already. The
> DMA API would fail if that was the case.

Correct, but it’s not just about cacheable/non-cacheable, as I mentioned
it’s about other attributes also, this is a very niche case, and again I
am not sure if there are devices affected in the kernel, but I just
wanted to highlight it’s not just a different encoding for stage-2.

> 
> > > If anything should be changed then it would be the above
> > > IOMMU_CAP_CACHE_COHERENCY test, and I don't know if
> > > dev_is_dma_coherent() would be correct there, or if it should do some
> > > ACPI inspection or what.
> > 
> > I agree, I believe that this assumption is not accurate, I am not sure
> > what is the right approach here, but in concept I think we shouldn’t
> > enable FWB for non-coherent devices (using dev_is_dma_coherent() or
> > other check)
> 
> The DMA API requires that the cachability rules it sets via
> IOMMU_CACHE are followed. In this way the stricter behavior of S2FWB
> is a benefit, not a draw back.
> 
> I'm still not seeing a problm here??

Basically, I believe we shouldn’t set FWB blindly just because it’s supported,
I don’t see how it’s useful for stage-2 only domains.

And I believe making assumptions about VFIO (which actually is not correctly
enforced at the moment) is fragile, and we should only set FWB for coherent
devices in nested setup only where the VMM(or hypervisor) knows better than
the VM.

Thanks,
Mostafa

> 
> Jason

