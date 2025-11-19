Return-Path: <kvm+bounces-63749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EFE6C70E28
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 20:48:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 94EA54E3E6F
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 19:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 736BE315767;
	Wed, 19 Nov 2025 19:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="L4UMvPAP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45F8328604
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 19:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763581514; cv=none; b=AcCkY0U+ufd60p02UJuCqjZDp2TLIww5pKA7e3p1Sg8nElPd+erykmOKpJhYwoBHVaTSq2mcsOQd3sNE53qe/sH169a1/6o6rYCcEMxe6PGVV669Vcup3/JRhnS6+Y85o02CsxcN+rF2DZirdGUPPofJB3ogVfcOwANMQUF8UrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763581514; c=relaxed/simple;
	bh=ez/Kk64Qkn4faxtP6x8udD23BDfPOJ9+UM/Y/c2urgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nO3udr41vnR2tYjwy97IlGFq5k2ns41+/7vOBOVn0llikLujlMce0LhVEa3e2w/txi15fFcmO6/fBD+JXHmggEVPD+RrFMzF0puwQ8GYrDoD06SEd1R5qk6RZ5wt7gUyJtElV7ZC2cL2yg/RuxYrdj+CEIop48rUo95CVL+NXdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=L4UMvPAP; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8b2ea5a44a9so13057385a.0
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 11:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763581508; x=1764186308; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ngigizqFoW1/n7l/UtYTJcb/TxX1OBEkHcoOUDKA/VA=;
        b=L4UMvPAPhzDYWioXgmQd8KhZiNE1H6762XCtFNAqx3wKKkmE3xDSf3bYqxSobinIuO
         ffuwmZf4NzL4SQmiwAjzsu/ZOlG/SbwHH1tHGDRnLj1H1TlRcyZMIZC/BRgq4dfjlO3U
         ESSlmjSDSIMhj9vvFDraaZfgHrBPSBuhAP5sEf0rU9NEWTaa/MMIeM9OGXcBCaJR6aCu
         5/d2TA8eKJeVFBWRihAEOITWaxSWulToVPH//ismSQUnwpXZ6weHPTMfogbiigG9Rd9l
         3feBMqmQlMibdreY9QRmN8pwc1fk5yAOrG6R8cYPL9V3odhMjgag3rVKkdIy2DY7Ob+f
         Ki9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763581508; x=1764186308;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ngigizqFoW1/n7l/UtYTJcb/TxX1OBEkHcoOUDKA/VA=;
        b=RTRevXmMRBW5kD+4rrz5Z8FOc9o6+mRf7D82NZ23lFO4fUsmGIaXBAyOQcmn1p3Btg
         nOS9u7Pr5JdgAjQUq6k6tmr/bZpkDeUp+NpvPefq2cSkTLLuFc/IoB4X7HnJCxRxZAZi
         kgw/BrBiO6hWakZN6UxtNZKLAkT4CunXYzvwAElrI1fTuO8fyaH3IXJqBNNIwNr+KzGi
         nMfDB6/OF6c8+zXWwh4kHWgYYVzTKlZV8ejUQ233EZtc2Zx8TEaWziWIeffxvHdhbRmF
         iE+F+GqagzjaCDI2tY6lv61drO9iXh+SBNzxltzl77g21xf2O8ZXmuksyP1gjbyGMo5b
         d95Q==
X-Forwarded-Encrypted: i=1; AJvYcCXNDgWZFlz23OFhoEe6rTXdtFFTxBZKdsEngHubXQKLAB8DKP+B8WEsPwdQM2B+mTe3NIs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDj0mbYyR6hpDF7KOc99V/Tj4pDNiG2TqzhoGUg/afr6oR4OAB
	RLwp0MhKXFIWU3CwCUC9PTa6jDKtC2hsgSbBQJb2xAcnW5TiaVPWfcgtWaWiaFiJXZA=
X-Gm-Gg: ASbGncu2xS6Tx2YnbI/SqNIFjrE5QcE/SWvhnOmdEd3dbsGOXadpfQYG80oH7l2pv8T
	6GXcr8LGy2jcMNXYKb0MHJc638hOW1I2vUE77Ds1T83ll58r3NItMx2dQD7a+UEpV0cvqGPpyf1
	aHew1v6TLOLPYcOaxwjE4yrCAmd70+SxPzrd4wNd5mKtat/+cLRnv/GT+yNlZxMVJjg9FqHO9Ab
	suAghJ1hKGpO30t422gaxCAqQTYYRCBkiNSGI74UZWZve+gYIvNu/XBQIzCKgxGSAGUXRu8avKk
	ylSF4XHs1DaBw5Sz3s/snAECnNg3da5E+hKOozqQoxfvD+T/1Lo2CdD8/dxK+UErCrNDcD5083h
	qJDKYmcN6woyoUaYWdVLi9vu8yj5yZOAAkUK1zLNPmR3Dtnm73/iC8Lel38l3OYGfh2DKuLNw2K
	Wgh7OMlBT6MCss7VDylvVKZLmoZf3FNh4gIMvqd4HX7X5TQEGxIDffCNOJ
X-Google-Smtp-Source: AGHT+IHM2All3T5KCtKB0YCjHC7VAw8938Pjcsqc0YyXScERh5oSqA8kZNdUfx1RTYUHZ+fIhtYAoA==
X-Received: by 2002:a05:620a:44d4:b0:893:31da:1028 with SMTP id af79cd13be357-8b3274b5313mr86654885a.90.1763581507903;
        Wed, 19 Nov 2025 11:45:07 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e447272sm1944186d6.5.2025.11.19.11.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 11:45:07 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLo70-00000000bcb-3TE0;
	Wed, 19 Nov 2025 15:45:06 -0400
Date: Wed, 19 Nov 2025 15:45:06 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v8 05/11] PCI/P2PDMA: Document DMABUF model
Message-ID: <20251119194506.GS17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-5-fd9aa5df478f@nvidia.com>
 <9798b34c-618b-4e89-82b0-803bc655c82b@amd.com>
 <20251119133529.GL17968@ziepe.ca>
 <ad36ef4e-a485-4bbf-aaa9-67cd517ca018@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad36ef4e-a485-4bbf-aaa9-67cd517ca018@amd.com>

On Wed, Nov 19, 2025 at 03:06:18PM +0100, Christian König wrote:
> On 11/19/25 14:35, Jason Gunthorpe wrote:
> > On Wed, Nov 19, 2025 at 10:18:08AM +0100, Christian König wrote:
> >>> +As this is not well-defined or well-supported in real HW the kernel defaults to
> >>> +blocking such routing. There is an allow list to allow detecting known-good HW,
> >>> +in which case P2P between any two PCIe devices will be permitted.
> >>
> >> That section sounds not correct to me. 
> > 
> > It is correct in that it describes what the kernel does right now.
> > 
> > See calc_map_type_and_dist(), host_bridge_whitelist(), cpu_supports_p2pdma().
> 
> Well I'm the one who originally suggested that whitelist and the description still doesn't sound correct to me.
> 
> I would write something like "The PCIe specification doesn't define the forwarding of transactions between hierarchy domains...."

Ok

> The previous text was actually much better than this summary since
> now it leaves out the important information where all of this is
> comes from.

Well, IMHO, it doesn't "come from" anywhere, this is all
implementation specific behaviors..

> > ARM SOCs are frequently not supporting even on server CPUs.
>
> IIRC ARM actually has a validation program for this, but I've forgotten the name of it again.

I suspect you mean SBSA, and I know at least one new SBSA approved
chip that doesn't have working P2P through the host bridge.. :(
 
> Randy should know the name of it and I think mentioning the status
> of the vendors here would be a good idea.

I think refer to the kernel code is best for what is currently permitted..

> The documentation makes it sound like DMA-buf is limited to not
> using struct pages and direct I/O, but that is not true.

Okay, I see what you mean, the intention was to be very strong and say
if you are not using struct pages then you must using DMABUF or
something like it to control lifetime. Not to say that was the only
way how DMABUF can be used.

Leon let's try to clarify that a bit more

Jason

