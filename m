Return-Path: <kvm+bounces-46849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D6CBABA307
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 20:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D7DDA27E10
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 18:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E48B27D776;
	Fri, 16 May 2025 18:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="PsIeL1TE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD722701A7
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 18:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747420520; cv=none; b=oE9/mHE8ePUpIdz5tPuhM/coBRCU6vwmMHimMmkZA6WyOWJuti66zsZsbUPxzYj7q5YdRmvy+j7MFldnce23ViQzkvn00kNZl+Mmeenyx0Wq4AqgAQ8V2qQerEqy8Kdf8Rr3O13zSVFIUTQTmIQ0ZdK7TpI94hreYloyPOrmoxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747420520; c=relaxed/simple;
	bh=/NlBqMOy3OEkgCo+YWYlCYiH+NIpaT+BAv6J6HbLuGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JH00yLb//8aD+HRrWUpmwrYhtZTuOaekdPf7Hq/ckIhVDpQeUIEE1ob5kBLIm4FNcB2QbYv+/f4ehbWQLyNLlWVF0/GDC3qWC+yqtvA6dvnfC2eRT+oc2vNPxiCnFvW/zyCBX2T3OqXa4V4yZsxU4dFTyJzAt9jxipQQM4lo09c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=PsIeL1TE; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-47691d82bfbso42295061cf.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 11:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1747420517; x=1748025317; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1BXn+vfm77+VTgYfWSD052O3sih3pqOBHF3asuJA1BI=;
        b=PsIeL1TEcrC89ToAXFivYCsA6aRbflHAzB0Z4H7A5iGBAQLSNWm3iBdktnmZ4Qwegn
         /RkqGiHR94Gg3WwgpaXjHcrbd0gGsVw4efyCzU03ezZxiPTEqk2ExyvX3wJonMpGsayf
         8cZynTkRnNNqGh8TLi2MhLDuhDgs5enJ/WkjWab1OCCT/3cSckCqfpGLr3PG8HDOxESY
         zSErgRo2WRc9g6s4osmO2VQylzKC8tGWUAgl7Xar+nA0Fp1lElPkFhhOVsBTovBNbsy4
         eI5jtu09d7ZqMVYRO0UNwCZyvphf3qsAYv5uvCMr+8MhdpQFU0cGCHksk/i4gLdw1DHz
         +HfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747420517; x=1748025317;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1BXn+vfm77+VTgYfWSD052O3sih3pqOBHF3asuJA1BI=;
        b=cpGU0Qq2/sk4kqZ8pPwsdDtN/6JQH3EeHX907/0du7rSkkvfSRbU1aNYWBTRiH36qi
         jvp7D/CmPcmkrRv4Ro6TplCVBLp98myFrmqYTV1+ma0PYrbzllnEmDawiWZrQIKr8Zst
         H2Hy2YoUI4UYNoD504/mWZuHpEDZr5QpB/apfNZPiV6jT7H8hxGjnDtnN8/ILidQ2q2L
         LbwQPJTC3gmH55gfiJXHCUQiEQtTTekbmR7QQQcNVp32hZNoDFy50s0ehv+GThVaQ6EE
         UKMfGa0tzgj4onlI3PdSublA78wC5Trm0WLFrC4vWbecmCKMe5I/7fgC2r+b9ITCipFp
         67pw==
X-Forwarded-Encrypted: i=1; AJvYcCUW9XZGu4EnMcmnyLTA8qNFCsuHtpnMrcL0SWsGMqPimTaeU53u9/tCfvqEfgH/UfhaMw8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoVDE3+Hi3UaaeKtgR/78dH5gs+JE55Phg+Q4iU8dyRlHgKQrs
	QvdsSFGzU0pq93ikCJmzacyNvmEuYMin5ngWDtRCQHSwwh8z30k+eQxX1mxsA3YgLrA=
X-Gm-Gg: ASbGnctqtIvmIV9E/ZRiNky7yolLEF+zlbP1Py6moT9uQWeI3RgkXM0k2YCAKsIV90L
	PnffPrsFcNbiiLsGgb2eAG7+mbL5bTk5vlTJV/3owK+wVvcOMHKmBNJIY743juBhvykAImnJ5jt
	2mUKm2BaETaVbzZPsbjBwy1BBiaRW3Ou4mS3/64FQTo/qiqpn3YwiK+KKaiPhRb/86JmkPuvPoV
	lZ7YBumjRKPbiKHVxyODNyl2eYkY1OG9GHWpP1IgbOWza8Shjg3KJxfbC5N4TBekZbIFgI6+A/e
	/NEROW5nYng7uFjcjMJyicf8TRQ6aHWrEblvZhwqdsb52jFak/1Ptmj5rPhjn6xBTqteSGK3LD+
	eB6RdHL+G3muxGBQR+31QJzQAHr0=
X-Google-Smtp-Source: AGHT+IGpq5KJYj/l1wOATwpZyhjeFxOQMatSSzVckaT9OfEIElh7VK70Bh6VZHAPSqyTk3x1rBi/hQ==
X-Received: by 2002:a05:622a:2292:b0:494:7837:90d0 with SMTP id d75a77b69052e-494b098b2ccmr52651911cf.51.1747420517420;
        Fri, 16 May 2025 11:35:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd467ef2fbsm149338685a.59.2025.05.16.11.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 11:35:16 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uFzts-00000002iAn-15rd;
	Fri, 16 May 2025 15:35:16 -0300
Date: Fri, 16 May 2025 15:35:16 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>
Cc: Yunxiang.Li@amd.com, alex.williamson@redhat.com, audit@vger.kernel.org,
	avihaih@nvidia.com, bhelgaas@google.com, chath@bu.edu,
	eparis@redhat.com, giovanni.cabiddu@intel.com, kevin.tian@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	paul@paul-moore.com, schnelle@linux.ibm.com, xin.zeng@intel.com,
	yahui.cao@intel.com, zhangdongdong@eswincomputing.com
Subject: Re: [RFC PATCH 0/2] vfio/pci: Block and audit accesses to unassigned
 config regions
Message-ID: <20250516183516.GA643473@ziepe.ca>
References: <20250429134408.GC2260621@ziepe.ca>
 <20250516181754.7283-1-chath@bu.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250516181754.7283-1-chath@bu.edu>

On Fri, May 16, 2025 at 06:17:54PM +0000, Chathura Rajapaksha wrote:
> Hi Jason and Alex,
> 
> Thank you for the comments, and apologies for the delayed response.
> 
> On Mon, Apr 28, 2025 at 9:24 AM
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > Some PCIe devices trigger PCI bus errors when accesses are made to
> > > unassigned regions within their PCI configuration space. On certain
> > > platforms, this can lead to host system hangs or reboots.
> >
> > Do you have an example of this? What do you mean by bus error?
> 
> By PCI bus error, I was referring to AER-reported uncorrectable errors.
> For example:
> pcieport 0000:c0:01.1: PCIe Bus Error: severity=Uncorrected (Fatal), type=Transaction Layer, (Requester ID)
> pcieport 0000:c0:01.1:   device [1022:1483] error status/mask=00004000/07a10000
> pcieport 0000:c0:01.1:    [14] CmpltTO                (First)

That's sure looks like a device bug. You should not ever get time out
for a config space read.

> In another case, with a different device on a separate system, we
> observed an uncorrectable machine check exception:
> mce: [Hardware Error]: CPU 10: Machine Check Exception: 5 Bank 6: fb80000000000e0b

FW turning AER into a MCE is not suitable to use as a virtualization
host, IMHO. It is not possible to contain PCIe errors when they are
turned into MCE.

> Is it feasible to support such use cases using a quirk-based mechanism?
> For example, could we implement a quirk table that’s updateable via
> sysfs, as you suggested?

Dynamically updateable might be overkill, I think you have one
defective device. Have you talked to the supplier to see if it can be
corrected?

I think Alex is right to worry, if the device got this wrong, what
other mistakes have been made? Supporting virtualization is more than
just making a PCI device and using VFIO. You need to robustly design
HW to have full containment as well, including managing errors.

Alternatively you could handle this in qemu by sanitizing the config
space..

Jason

