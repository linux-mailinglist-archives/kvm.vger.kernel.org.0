Return-Path: <kvm+bounces-39284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AFD0EA4603E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 14:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1BB216806B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 13:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F79D219304;
	Wed, 26 Feb 2025 13:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="T/QbiIKv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F0A13EFE3
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 13:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740575288; cv=none; b=pxblraaWaiKR0ImUyuvDmbV6W84Vg+vNFZPjlbdIelpl+E/lQ2v0nG/60NCZWQL7hpmwSwG2hxa5LWDZsvu8cgUB07R9fZEIkOQa7ccWwZgyyJUQYF9RtEbB7a7EmDw7yn4EMxxOJ0NgkYd21SMHtFCL2o1gunXTbiTi67Riwqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740575288; c=relaxed/simple;
	bh=gZlf2V4DZl06PCel9kKPigzKNxKnfgpO2YLnb7fz6Tg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mgLrExG4RD7ZeWH3HZ4cQoAraeHGTNgDXw1pSMqb6EvkObw0viDx6HOw2WETfmqNaJGkiPD1z+kdXEG3GH+p0iJLgbUefebGjoCtnBW9n9gYG3TS3rPdsSp6iIO8d432CzkRDP18mGsAWZxodCdhfDDCZgiQldgRw2Ofj3tpwYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=T/QbiIKv; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7c0a4b030f2so873260885a.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 05:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1740575285; x=1741180085; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ECSFx2fiYRGYbPUPOKEj5uQjkNpa71sMCoCExCmYew=;
        b=T/QbiIKvtcqcqQSWAzZogMWpsvqW+MI/HTEr2rnGR+RwQZ9gmuTns4FjikIKYrcMze
         4FJMlwQCBDA+2A++4l1iyFsZYKWksJ55MgCltjETpB4KXpMP2UB+UUdUr4JoNrxVpNt/
         ELA1o4PGTsQmKZgR77zNp8cVXLbpRGexH2ALUw/bkZ+arvQw+JoETdEeUG2bLQ/wIITc
         fiLAcA65IEtHSJ/NA0jKRPWwTHgQyPhNVJ9V1BZTXxvoMn2S6pN4DaauGRgO8LlqJGVm
         a77QBoeHa0ihVuzWgR0h+w8mUy7w83ixeRqFPZaVUu8Oe4/BkxuzBv2ZajAEDbYKcmzo
         OBUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740575285; x=1741180085;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ECSFx2fiYRGYbPUPOKEj5uQjkNpa71sMCoCExCmYew=;
        b=kqrMl8i+zv1wXFiBzJPNMG5KI7ooGWy3Q7KwiGrg/JTVDGc0PNTpnpy70Wh+Nwo3z2
         wUXjy5pXrSJijw+eeMox/sYw2Iu0Bqdgxqx/Wl6VwOPgn9q2OlAh9ZqQhs1VUgDiYL1H
         w3S9sCqW76nXil1w3n2Q+vjpccWlNL+oFIG8Wb800qcSuEGPC+vLQXTXjRvgS6wJAD4r
         U6f7VEOcVJ4YCkS6Lh15lwNmc5E2VhTxcHi8+BeswlpwwWMgnJH5UGVUza4idwPQSgGh
         I850QIwoSLWeAcHWedvr6pvbknxUxww6eqWcmTzvS5J0luhgQcy5h90yKy6dWvwoOd/m
         6VVA==
X-Forwarded-Encrypted: i=1; AJvYcCU+JjOt4YvUyqSzASbNtobtPVTzLcB3DHwlztwBeGAVr6SOh4DsuPJ6Tg1uk4ecE3mGnk4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwceJFQXXYnrd9l3BGjkm1U4HynJsbiEeIOc0vtvCUbljD2wgFu
	2cuj+wozfE2wJ5U3XtqnPW9eIql9WWZg6TCpvmio9rMch8cGqoVjaU+n/fKznA4=
X-Gm-Gg: ASbGncsooYVhs2QCHyjyPz7IkME0vMLekkodzTYaB13ysp4DbTlquWVIVSfXPu0S95u
	gp+DyKWc4tl+rrQ5tgotsjT0ttyemNQ2mKUHJ7zhGXqs4wnr38LPOrN1T0j284pbpXU9vSc1IQ2
	tjidT+Eu2q+OeRFhOQnntmHeftZBceumtr4Q3LblKgqLlGFR3bxlOUe+zRd46RLcbsbhGg8q9DO
	kZZNK+InyuMBJa0ljgjK9vcW8MWCW/70K+r2PzK47O/GaPtgZ0zKooz7hzNX3jYKQ5hF79NB7Ba
	ZhTQp5mUW5HZOwCKMYxFfz1cxGeX5jPeln0t/ELeGP4+U42NbiTyBb65cq37uojrxx5eZq/2no0
	=
X-Google-Smtp-Source: AGHT+IHSaPI2di23wd/r7DmUcJvEuSIfSDJiLalxe/seFWwJNz69RZ6l150d7LgWyVVQcH9URorRQA==
X-Received: by 2002:a05:620a:44c1:b0:7c0:c650:e243 with SMTP id af79cd13be357-7c0cf8ea459mr3058987685a.30.1740575285615;
        Wed, 26 Feb 2025 05:08:05 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c23c2c0fb4sm237968885a.56.2025.02.26.05.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 05:08:04 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tnH8u-000000007Mk-0RRT;
	Wed, 26 Feb 2025 09:08:04 -0400
Date: Wed, 26 Feb 2025 09:08:04 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
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
	Zhi Wang <zhiw@nvidia.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [RFC PATCH v2 14/22] iommufd: Add TIO calls
Message-ID: <20250226130804.GG5011@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-15-aik@amd.com>
 <Z72GmixR6NkzXAl7@yilunxu-OptiPlex-7050>
 <2fe6b3c6-3eed-424d-87f0-34c4e7e1c906@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fe6b3c6-3eed-424d-87f0-34c4e7e1c906@amd.com>

On Wed, Feb 26, 2025 at 11:12:32AM +1100, Alexey Kardashevskiy wrote:
> > I still have concern about the vdevice interface for bind. Bind put the
> > device to LOCKED state, so is more of a device configuration rather
> > than an iommu configuration. So seems more reasonable put the API in VFIO?
> 
> IOMMUFD means pretty much VFIO (in the same way "VFIO means KVM" as 95+% of
> VFIO users use it from KVM, although VFIO works fine without KVM) so not
> much difference where to put this API and can be done either way. VFIO is
> reasonable, the immediate problem is that IOMMUFD's vIOMMU knows the guest
> BDFn (well, for AMD) and VFIO PCI does not.

I would re-enforce what I said before, VFIO & iommufd alone should be
able to operate a TDISP device and get device encrpytion without
requiring KVM.

It makes sense that if the secure firmware object handles (like the
viommu, vdevice, vBDF) are accessed through iommufd then iommufd will
relay operations against those handles.

Jason

