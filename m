Return-Path: <kvm+bounces-25668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6200B968447
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 12:13:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D65E11F23D96
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 10:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967F11C3F2B;
	Mon,  2 Sep 2024 10:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bL441e1s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB4013D8A0
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 10:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725271884; cv=none; b=rFCng1ce6UJPUI4VH4uiFvRbo8y/0WBcitH/b9TGx/k6UTsWLvOIhNL7YV+LtHThJXwbaUsyAAfdGyb/P3xEYirmW6KjdRVj0/K0E9H/FDtM+5gV1uuQAipNfGQ7QD6PGIv/R0H4L12CtGmseF6HXUBNDT2PDFSRTy5I/F1JvLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725271884; c=relaxed/simple;
	bh=qNGXWzNFmm5xDRCpulne9Ld0dJBH7APDO2VH8uDcPos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ux3bREJ6hwM7k2U0LE/O9ZSeuWfunD/H4r+VXEY1SlRLCMoaHtGoXjalQ6wc6WcH4hHhh5zE5lxVlCcIUsTlwvXQTB1iWRN4lUfNAzzsJhW68bTCaS+ey/AjcMKdInlYMx7I2cVDckF9BiYKjMT6gPy5etmV2vh+AQ0jaDupZKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bL441e1s; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42bba6a003bso65945e9.0
        for <kvm@vger.kernel.org>; Mon, 02 Sep 2024 03:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725271881; x=1725876681; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uv5FZr6rZ6VqzNNSiX6mzSa07qcjEjBpw1DOUryq6jM=;
        b=bL441e1sr4Hx5plPaYFEN3McvESnvE6/VFyfYD6OpKKNBLLsOrD5oqxHW/X63lt3w5
         0g6ATAGpYSVm19Ttlh6if+xE0wf+VHhtkwx01SH9q7FxSZNMSGKzeLJ9po1ArL6NPCva
         PsQ+98x0dAxsPvr4lriwWUOml2TxqUtItoZ5Q+QO54d5HrcxAI/DCXEX/tJHLBHsznGr
         ae/SP5Dw+kK/gxBLOnJIo1wC0bvRM9ib7B6tv3q3ak30XAPUY2LDKQdUZoLsUmpJ4yT3
         Cv2Wrj29qrtv1ucwLwKXGnQb01qEF62lDoIT5u7yemZ3m9CbsjtnRNYudNRCds2L3J64
         3ZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725271881; x=1725876681;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uv5FZr6rZ6VqzNNSiX6mzSa07qcjEjBpw1DOUryq6jM=;
        b=JeqEdToEaA5+kbyiOEtu5wq3c/I3DQyFPYD6ynuQM4GEVL/rmS99NAOhBpcEit4VBO
         l2k77GPGYpul4m5js7I14wTZtl3Jf0kt+Ahpu16CCb/HN4RzC7pESAIgOYRWv81LaJ2b
         wnzpLE3vyUdf17ZnVQusFeRmRX5UyE7H7ybHFNklMCO2JBu61TrFiS2KL4UB65/beXEr
         GbYB81pZZO/cG9RoxBNTvAAryVjeBO8KPmTSmunxIa+lCscHji3bF8UMV10QOOuJsrfx
         jTgDQpqGKHOqK8ZEaY1iPayMCd1D0/72Z6ZaxEEFwNbNdNDrwZ/8l8mMvB8CsEMubC51
         RlqA==
X-Forwarded-Encrypted: i=1; AJvYcCV7o+N0Xif7gQ6a+dCJysU0XRb/+XKSEM8JxfsriKedIekZ2WZX2apYB7m+DVADfa/NXbg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwkyPos188kfHSbZ0vGDDAZg90YWEkpQZSuGfz7fuPx87f5eds
	hipXEdW/5tYrQ3mSO54yBtw7q5MZ1CgD8jhbMKgZLlbbNm4QO6c76j1M+GELxw==
X-Google-Smtp-Source: AGHT+IEUVqSYP8vAntRCNYY+qDlbdxLNJoRSmxfSPQkZYaqM46by3fcwoSLExd+dVfdZhFC6FNtXRg==
X-Received: by 2002:a05:600c:c15:b0:42b:8ff7:9cfe with SMTP id 5b1f17b1804b1-42c787683a2mr2004925e9.1.1725271880837;
        Mon, 02 Sep 2024 03:11:20 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bba3f2875sm111687515e9.41.2024.09.02.03.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 03:11:20 -0700 (PDT)
Date: Mon, 2 Sep 2024 10:11:16 +0000
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
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Message-ID: <ZtWPRDsQ-VV-6juL@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHj_X6Gt91TlUZG@google.com>
 <20240830171602.GX3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240830171602.GX3773488@nvidia.com>

On Fri, Aug 30, 2024 at 02:16:02PM -0300, Jason Gunthorpe wrote:
> On Fri, Aug 30, 2024 at 03:23:41PM +0000, Mostafa Saleh wrote:
> > > +/**
> > > + * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
> > > + *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
> > > + *
> > > + * @flags: Must be set to 0
> > > + * @__reserved: Must be 0
> > > + * @idr: Implemented features for ARM SMMU Non-secure programming interface
> > > + * @iidr: Information about the implementation and implementer of ARM SMMU,
> > > + *        and architecture version supported
> > > + * @aidr: ARM SMMU architecture version
> > > + *
> > > + * For the details of @idr, @iidr and @aidr, please refer to the chapters
> > > + * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
> > > + *
> > > + * User space should read the underlying ARM SMMUv3 hardware information for
> > > + * the list of supported features.
> > > + *
> > > + * Note that these values reflect the raw HW capability, without any insight if
> > > + * any required kernel driver support is present. Bits may be set indicating the
> > > + * HW has functionality that is lacking kernel software support, such as BTM. If
> > > + * a VMM is using this information to construct emulated copies of these
> > > + * registers it should only forward bits that it knows it can support.
> > > + *
> > > + * In future, presence of required kernel support will be indicated in flags.
> > > + */
> > > +struct iommu_hw_info_arm_smmuv3 {
> > > +	__u32 flags;
> > > +	__u32 __reserved;
> > > +	__u32 idr[6];
> > > +	__u32 iidr;
> > > +	__u32 aidr;
> > > +};
> > There is a ton of information here, I think we might need to santitze the
> > values for what user space needs to know (that's why I was asking about qemu)
> > also SMMU_IDR4 is implementation define, not sure if we can unconditionally
> > expose it to userspace.
> 
> What is the harm? Does exposing IDR data to userspace in any way
> compromise the security or integrity of the system?
> 
> I think no - how could it?

I don’t see a clear harm or exploit with exposing IDRs, but IMHO we
should deal with userspace with the least privilege principle and
only expose what user space cares about (with sanitised IDRs or
through another mechanism)

For example, KVM doesn’t allow reading reading the CPU system
registers to know if SVE(or other features) is supported but hides
that by a CAP in KVM_CHECK_EXTENSION

> 
> As the comments says, the VMM should not just blindly forward this to
> a guest!

I don't think the kernel should trust userspace.

> 
> The VMM needs to make its own IDR to reflect its own vSMMU
> capabilities. It can refer to the kernel IDR if it needs to.
> 
> So, if the kernel is going to limit it, what criteria would you
> propose the kernel use?

I agree that the VMM would create a virtual IDR for guest, but that
doesn't have to be directly based on the physical one (same as CPU).

Thanks,
Mostafa

> 
> Jason

