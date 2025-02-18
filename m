Return-Path: <kvm+bounces-38512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9068DA3ACDD
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 00:52:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FA673A93C7
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 23:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C23C01DE889;
	Tue, 18 Feb 2025 23:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="gyCO2oxs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060501DE2CD
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 23:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739922671; cv=none; b=iNhs1EHB0SIXxBEHsARikmIzDRzNUACh4qFbv/M5N2buBM8mFnsVgoq4W3432+Ry4iFgoZ/V2Imrq3zg0gddNerNkk0dD4tSljs1wc4Of+CtFaLjQC94w6QUW/lPtuBo7XRYmhVszouB/m/FNo5zJNuh2X3V3mCrkL4Tk9tYXRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739922671; c=relaxed/simple;
	bh=iKT5gRHJFTk24cvpT8KmAyPqwcHjrkHc67AQuv3guHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cLTQ5qNqqHMo45mTzbVeL8/BxRlINiip1POb7OXV8Ggcxz4lXptRZxZsoYZ8UD8kJWH1XvfcLoAokkNOKpkX/rm6KTFkm28dbkmMhrsNzjc2OHWkgAhyMlPiDLRfQ6edqm2pAGACVF0k0J+dtA3hRHdmUkeGH5QyMi2VA+/qT8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=gyCO2oxs; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6e65baef2edso46680396d6.2
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 15:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1739922668; x=1740527468; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iKT5gRHJFTk24cvpT8KmAyPqwcHjrkHc67AQuv3guHc=;
        b=gyCO2oxspS7/wo6nKrTP+PvPC3WHPNTT6/JmRriOfZhLiACAnYCQEFSI25NC0zC/bF
         qsqrC37zkhXUI/9OmKKjpIkhjLKCHctLj335ADwtwMIBl1hIncXGBVtv5/nxRpL8ejbX
         LHz+b9Vz/nMApEUQDq9Lc5nBJyHsPBK7k1DyN33LgalFNLN0UL1+RbukmuC4ysEwj0qh
         wgCE/wPcuCDwaNsLdoAk7Eoi6GPSmFhhQDxSHDe5yQpmi9qqG1KNX8rJaDxWtRjwzTh3
         d0tAgD7OX+mSpXFQ6cw+c7BSzWiMhmu1TvZF45FwzBYu7VwPqmD7oEa3C2DbfCbikDIT
         6lug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739922668; x=1740527468;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iKT5gRHJFTk24cvpT8KmAyPqwcHjrkHc67AQuv3guHc=;
        b=MKTyr5adBP7f+LCIQFvYRMqhJmI3xSGm2dgozxHXNt4NhngPD0z0kcHtyI/MiGmylB
         lJikDkPehoFu4/wWeB4W3PVyjDeq/F8qjvPCKIlLZCx0tZL/X2/aPhoUSjRlLAqqPB/s
         H6ODODI9ohK5FlU6fwANsHFTd68FBxbhqCg4pP7FX9wjyRxtkCTapu+0s4bZUzRNJk02
         6xmZF7GJJuQuD37TwqPhhQsd73Mjv+6xAcLsWy7xDzi4EReTmYWeuKVdxyxWD2QT9D3H
         GLtvinZ9sjCz58oJwKEdzAyuBidoPhksWRJFQF7m0WK6bY/HqLX+8WessBGavRom61Wl
         s5hQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOtM6LSrdUAgbroD0unETDI1+L/bEqLld8m7DsJHwGXK7iZb3ZSemCxm8Qoe8Iz4RejYU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNVQ6iHfaQD5RtQByD87tilhCvNFwPn6cQb++QTvmToxUmhElI
	fhBx8gSWbK8nXOkUbpN5US7ZSChxwKELAZ0p60Jjj6f2WY+Lmj23dS07wCVKPBI=
X-Gm-Gg: ASbGnctMPtG31lJCVfcWGLUvuvuhujivsWOFr8YEx0s55w6oVSPldTT3DHA6fTgpalx
	uyWwiEvMi848DVy2ILHIuTCYfkBuJukTTORGVNo/lu/nTjFUmwv/S78eiJfrAF78A82KsASzXfk
	1IK5OwnlgYfkt2S8i0yAq90LsLEKuJ/RG0Y5BW5aUKrBIKN7P40pr/9BYLgo2oY+CepYjflgfll
	KyVYVvbBJDDLYm6SiAVfmgpfTOn/usDPrVTe539W0tvjTvHuKd6RjyANoAk/EiwtDLBA7XbKIEQ
	7owiI86oTH6TGYtFjRQJmA4F8JQk1abf5oV9BfqF9j1XD8kUPEPOINqst0GDnxxQ
X-Google-Smtp-Source: AGHT+IFO1/6l3OUxeVa8mqeoAIRJldW9bBpco9S18W39RUG+1rvPlDolxLvoJK10Ea2Dnll0//ehxQ==
X-Received: by 2002:a05:6214:1d09:b0:6d4:3593:2def with SMTP id 6a1803df08f44-6e66cc8aba1mr253639746d6.5.1739922667835;
        Tue, 18 Feb 2025 15:51:07 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e65d9f325fsm68981726d6.76.2025.02.18.15.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 15:51:06 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tkXMn-0000000020v-3I9I;
	Tue, 18 Feb 2025 19:51:05 -0400
Date: Tue, 18 Feb 2025 19:51:05 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Christoph Hellwig <hch@lst.de>, Nikunj A Dadhania <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Steve Sistare <steven.sistare@oracle.com>,
	Lukas Wunner <lukas@wunner.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Dionna Glaze <dionnaglaze@google.com>, Yi Liu <yi.l.liu@intel.com>,
	iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	Zhi Wang <zhiw@nvidia.com>, AXu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [RFC PATCH v2 12/22] iommufd: Allow mapping from guest_memfd
Message-ID: <20250218235105.GK3696814@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-13-aik@amd.com>
 <20250218141634.GI3696814@ziepe.ca>
 <340d8dba-1b09-4875-8604-cd9f66ca1407@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <340d8dba-1b09-4875-8604-cd9f66ca1407@amd.com>

On Wed, Feb 19, 2025 at 10:35:28AM +1100, Alexey Kardashevskiy wrote:

> With in-place conversion, we could map the entire guest once in the HV IOMMU
> and control the Cbit via the guest's IOMMU table (when available). Thanks,

Isn't it more complicated than that? I understood you need to have a
IOPTE boundary in the hypervisor at any point where the guest Cbit
changes - so you can't just dump 1G hypervisor pages to cover the
whole VM, you have to actively resize ioptes?

This was the whole motivation to adding the page size override kernel
command line.

Jason

