Return-Path: <kvm+bounces-25145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39BEF960A82
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 14:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99B41B20A1D
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 12:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED0521BCA04;
	Tue, 27 Aug 2024 12:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="eltcPPAs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809651BC090
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 12:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761966; cv=none; b=Dga/4P6IDlXjtz/I+2WKhG7s43aYsrM3wRFZ9UV4eT7FYuAMOCjdGHhk+j+EhF5dmXTWE2xXa5oPVwOK9DMatojABA9gdJ4YhZZo6Zdr6QzRdh2sb79UhIo430B6hB6B8YH0LSdaBVqZmlBT1HlQfsEUzFiRDqXuPqi+xIi1rrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761966; c=relaxed/simple;
	bh=jhywql0i1Igm4tZ6CC7w55Fwugmoo13oCgW+x0dMPQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n95GA0QmwI/SwoRhY+ApPV3h9E+7l12sf3I3CIHCsISLtzIV9fSkLIKOxTubZZ/aWElF+Q6Z04swt3lGpyQ3qXgXGFj62Zfi5nYqTcu4X9XaabWpzKCdKmHJBIb/0oqv5zGxWEjIMIjlQ8YyuaQiK7lYCsZ4wrWKqJLSr+jl22c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=eltcPPAs; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6bf999ac52bso27074386d6.2
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 05:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1724761963; x=1725366763; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L5jbjcbxUPPj9zYNKoE0eIYQhFCqfcFcc1QbGEVtWHE=;
        b=eltcPPAstBJtZH8QFntLp0I/pWn4YHqczytIEQkcPd7iiEItdv3j/3XpqWwPlItvFL
         7/hHVFecyCwYbBVrYqdlkz//9cpvlFlNi/IAKnq2QFml4PWKxQrfTrPKGzuJATygeCwh
         zE7NUOSz2v59vJ0Oa1ahgEUL75DT6EEtPBzUtaQrh12O7vYDLAkyRuBFTWGghT3Gks2L
         9Z/SH91xHU3DnMlmM17SAM84YLRihiwl42aMac+oVBuwoKwEBwmawI9qogYHyHU616+j
         VGnqbW0MsHXPuv5UZLCvLf7zVoytsUX6evHriaE0F/Y2O9RG3NyHIkPzAQ4ionOOHizM
         Kmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724761963; x=1725366763;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L5jbjcbxUPPj9zYNKoE0eIYQhFCqfcFcc1QbGEVtWHE=;
        b=rZzEEyD9+dprVzthD0vjZRHs9ht1QtYB0USfu1XS7gTwfphwOCPk142VoJmFyq6STn
         zIRXmoHQkqNrwyIswS1m7rI0AOmSD4M1St5j7gP9yYweu/tHXCIw7KrLorDtVMmQeUZh
         tFncrK3HyDEqSF+NOTUOGGOcneeN9yowZjtHAJZxNVSRoF/DoMWVvaduXhut4ssxhxzG
         6fyRmKmI7Wj2U9xj7Xw8imTPeHyVYoC5Dppt6G6OyMM4fw9SLLqVc/SwTj9Ch+VaKbFd
         MCmLW1CJPxf/rG5I/NVPEynKdQxDlCf6DleJj1kqZijciV+PsV1pcNVJyd3yijJlYuBp
         udFQ==
X-Gm-Message-State: AOJu0YzEMUJG3BgdoqR1n+o5+6hk+bw4T8m+HlgatHyfAG7SpDhxPuAI
	dnRzg9B8VEdTnAZ9Tze28f6u0MFGVgFBm92Q2Hfhk29mfvpvL2QdqFqUki+gqc8=
X-Google-Smtp-Source: AGHT+IFgABoyQ7opyAvWPQnFZTXKyke+4HJ1twIgh/+mRitM/qVkX72/Bi45aDM2XOpCwlcFx8pYwA==
X-Received: by 2002:a05:6214:4381:b0:6c1:6a2e:afc6 with SMTP id 6a1803df08f44-6c16dc36d53mr159756336d6.15.1724761963298;
        Tue, 27 Aug 2024 05:32:43 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c162dd1cfdsm55802226d6.129.2024.08.27.05.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 05:32:42 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sivNK-000dsU-Aq;
	Tue, 27 Aug 2024 09:32:42 -0300
Date: Tue, 27 Aug 2024 09:32:42 -0300
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
Message-ID: <20240827123242.GM3468552@ziepe.ca>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-8-aik@amd.com>

On Fri, Aug 23, 2024 at 11:21:21PM +1000, Alexey Kardashevskiy wrote:
> The module responsibilities are:
> 1. detect TEE support in a device and create nodes in the device's sysfs
> entry;
> 2. allow binding a PCI device to a VM for passing it through in a trusted
> manner;

Binding devices to VMs and managing their lifecycle is the purvue of
VFIO and iommufd, it should not be exposed via weird sysfs calls like
this. You can't build the right security model without being inside
the VFIO context.

As I said in the other email, it seems like the PSP and the iommu
driver need to coordinate to ensure the two DTEs are consistent, and
solve the other sequencing problems you seem to have.

I'm not convinced this should be in some side module - it seems like
this is possibly more logically integrated as part of the iommu..

> +static ssize_t tsm_dev_connect_store(struct device *dev, struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct tsm_dev *tdev = tsm_dev_get(dev);
> +	unsigned long val;
> +	ssize_t ret = -EIO;
> +
> +	if (kstrtoul(buf, 0, &val) < 0)
> +		ret = -EINVAL;
> +	else if (val && !tdev->connected)
> +		ret = tsm_dev_connect(tdev, tsm.private_data, val);
> +	else if (!val && tdev->connected)
> +		ret = tsm_dev_reclaim(tdev, tsm.private_data);
> +
> +	if (!ret)
> +		ret = count;
> +
> +	tsm_dev_put(tdev);
> +
> +	return ret;
> +}
> +
> +static ssize_t tsm_dev_connect_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct tsm_dev *tdev = tsm_dev_get(dev);
> +	ssize_t ret = sysfs_emit(buf, "%u\n", tdev->connected);
> +
> +	tsm_dev_put(tdev);
> +	return ret;
> +}
> +
> +static DEVICE_ATTR_RW(tsm_dev_connect);

Please do a much better job explaining the uAPIS you are trying to
build in all the commit messages and how you expect them to be used.

Picking this stuff out of a 6k loc series is a bit tricky

Jason

