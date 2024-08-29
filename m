Return-Path: <kvm+bounces-25344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E749643ED
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C37A1C24815
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 12:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19D21194137;
	Thu, 29 Aug 2024 12:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="QxoEX4PN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA14218EFC0
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724933278; cv=none; b=MkJly7dSifm9I2G2SNDGZFXJNEw5u3zCoYdKcVd7NzBUNSlwl1Wc1Zezx8Ye1/F7JJcNOD7CrM2c8MZjFYEgSZRmpVlGFB0XMhiLOvywJpH3Nv152WPQ3iHHsOKDTwWozMOihwFmVVoP3thneM0TdDjA3QF/xtlP7zfLDgODRdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724933278; c=relaxed/simple;
	bh=Nf3CAxLtlz8uAbGAT+7taAPjope5qXY1PBkjsxs7vdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=URiENSpa7Oga8BQvVNBJAshsZeEkQsRBQgB1WdryI+/NJJSDkJWKn4aMZDvD/czsXlSnw8I5q0A6ZDkeWcjCPm32Fc4z1Hwme2rhdIUc3C+qrwidPoH8JFL33pXqHgHyO/HwLG4tdIImI8ZRECt05qPWdLsZzf8s9n2dmzwxKtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=QxoEX4PN; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-456825b4314so4791961cf.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 05:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1724933276; x=1725538076; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xb3+07iy9NTaVPK92198+wLvvVC/Nq0ZQtaVfVkE/gM=;
        b=QxoEX4PNUEZxOp2MDr5MoxMkO/XF/AyTfqX6osDEVTWpZYlhvFAAAglI/+P2b0UUR/
         puaI2DKhIkUV3ZHlz4S5VWNAxiIXhhaOPxIpMFUQWKHPAeI70FB5mUcOtRsfShfDsTJ0
         UGVkq9vPu/iqSwLAcfHyQEbm8cybl27VXtXkcKdbnk52PuXyHhlzHgwf6TOLd4Fo+QIW
         T1YrB2zNoeiUtmQum+tIWhibq9NsgxaaY86Ln+1xreEmgtvzfq7HaPJ1JyJ0jC2F5fzf
         LMdKCSMXQC4cvj0UFqGz4uKMz3kI2606KikGiYHHEUh60Pl4JrinI7ZIQPibXViD0DY9
         GcYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724933276; x=1725538076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xb3+07iy9NTaVPK92198+wLvvVC/Nq0ZQtaVfVkE/gM=;
        b=W2PE1TPYubJLUaYL3qqG96jY5yFT0147hTpHSCo7dDZIMD5UHRps0mEqM8FIjDj9vm
         G1YOH4PXS6bkreelOloJJzbfiHCrazsQ6LesAXVk/6QJn2Bko564VdDduV08PRK9yYYi
         puqVmi9ZhQvxXmjn/sY1rxMzz25yD1Qs1kwBioyoJpP5vivcCIOnRkW+SndoF/zHpLby
         fC3HXtTWPKMh0XyVaBaX6Q5dxwv4y1mitMHx4w7GGZP7IVMhBAQlN3qiBhh1YlobebdX
         vrEg8c/4ewdY5S+FzR6TJw8ZQT7sCrm3GewdQQTYvmNcFIt+NAXOuZII7xsGzIx7ll14
         2uIA==
X-Gm-Message-State: AOJu0Yw+ezTdvvnBdfj7bjh8De2errHPzb/vKLTHFy1Fxumom9A/03A7
	AFQI2VsfKtC4/mL3/8q9kns++60SBJWqb5EqRAVBV6gdZvrIki0ORvrtLkZ+PE0=
X-Google-Smtp-Source: AGHT+IH/5FQ+vPJhqbN9c15Uc86CJ39bOFxfZbCDjJIWH/ya9lQDuX9DcvEIhSSVh+BpE3Fy6Cl/pQ==
X-Received: by 2002:ac8:7dc6:0:b0:456:4736:7dc1 with SMTP id d75a77b69052e-45680320e35mr32266511cf.29.1724933275823;
        Thu, 29 Aug 2024 05:07:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45682c82882sm4308951cf.13.2024.08.29.05.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 05:07:54 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sjdwP-007TcX-Ew;
	Thu, 29 Aug 2024 09:07:53 -0300
Date: Thu, 29 Aug 2024 09:07:53 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	pratikrajesh.sampat@amd.com, michael.day@amd.com,
	david.kaplan@amd.com, dhaval.giani@amd.com,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Message-ID: <20240829120753.GU3468552@ziepe.ca>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com>
 <20240827123242.GM3468552@ziepe.ca>
 <6e9e4945-8508-4f48-874e-9150fd2e38f3@amd.com>
 <20240828234240.GR3468552@ziepe.ca>
 <d9bd104b-e1a0-4619-977c-02a27fc2e5b0@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9bd104b-e1a0-4619-977c-02a27fc2e5b0@amd.com>

On Thu, Aug 29, 2024 at 02:57:34PM +1000, Alexey Kardashevskiy wrote:

> > > Is "extend the MAP_DMA uAPI to accept {gmemfd, offset}" enough for the VFIO
> > > context, or there is more and I am missing it?
> > 
> > No, you need to have all the virtual PCI device creation stuff linked
> > to a VFIO cdev to prove you have rights to do things to the physical
> > device.
> 
> The VM-to-VFIOdevice binding is already in the KVM VFIO device, the rest is
> the same old VFIO.

Frankly, I'd rather not add any more VFIO stuff to KVM. Today KVM has
no idea of a VFIO on most platforms.

Given you already have an issue with iommu driver synchronization this
looks like it might be a poor choice anyhow..

> I wonder if there is enough value to try keeping the TIO_DEV_* and TIO_TDI_*
> API together or having TIO_DEV_* in some PCI module and TIO_TDI_* in KVM is
> a non-confusing way to proceed with this. Adding things to the PCI's sysfs
> from more places bothers me more than this frankenmodule. Thanks,

I wouldn't mix them up, they are very different. Just because they are
RPCs to the same bit of FW doesn't really mean they should be together
in the same interfaces or ops structures.

Jason

