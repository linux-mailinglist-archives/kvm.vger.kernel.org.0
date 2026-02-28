Return-Path: <kvm+bounces-72253-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAVsMsw2omnR0wQAu9opvQ
	(envelope-from <kvm+bounces-72253-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:29:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C70C1BF6E4
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7AB633118199
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B08248883;
	Sat, 28 Feb 2026 00:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Fjwi6nkk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEB2221F15
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 00:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772238492; cv=none; b=k7HI2Yb1YDFwDKk4lkXlhEuikpULSEjtyyiHT+YLg8Rbv5CIetPLo9gl0wyrixLa6xuVGBwH2prhjYKpUVw808ij5jhsxSmKaoE4PLu9rdIkGC4abTq2VthdfXd5iyqOexWK4Wgp6lc9JvuKWwIJpYbhIb+UMoZYUUZGqVgqcH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772238492; c=relaxed/simple;
	bh=YGNKoZbd9ItV0tpLlMFHS8bKihozZyqN701JI8Fx9wU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6bao6MWIrXZMMyeSaHhxRXcXhwX/XHOIfeE4l7WTAIgHM26Vj6uPkQEsrQhdrIH88A4iJWj6yRQZOymTOdnE5WzM6CVahH7Q/1ft3oRqyROQILGNOVwAyr+xHgZzJggUiBWUwQ4GfwksQQRhlmz6TIXWibpbXGd9NC/y+azZvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Fjwi6nkk; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-899a917a4feso44119596d6.1
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1772238490; x=1772843290; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KAMLfTB0VdCLmRuczMOUd+4kmAfCR9U6SjigH585Y48=;
        b=Fjwi6nkkLd2pShMhW0y/Rqwi+rnlcCHd51/o549qw65rRK3iTQANqTmQmzNTfBHHTS
         L9/tjwH8Ehzd++W/jqfmkLdZ88Gwfe2wsCgpHGEdh/mCl1mivQ9sPua8mZsrVxzTdkY/
         LHf3BI5WdM9WAVTnqCAbxToH9d2y8LCIUiFlicQsbd2rsYuMsnqjYd9PQoYxf0B/eaMh
         6tO5JKHtwZyrBELyJN77izqMauDnTdiXOJqEBQBSNlyQSrYeIAdRPxXjzOyg8ZL7tECC
         kQi1sbYm0YfLVz/lGV4luxnNOk3abuZG4aqaCOAxD/P/TcDAzmbzCzkj0AwllrGLVRyk
         5cUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772238490; x=1772843290;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KAMLfTB0VdCLmRuczMOUd+4kmAfCR9U6SjigH585Y48=;
        b=IGnSHGuMqkg/8rf3ROHR3hQ23J2pqukdRnb+XlBAlf2uYdOXPMB1hs+IhiK1+H6G2g
         PrcG3FJ7hQdtn0nu4B2dOv+IkFjo22JJuvf5xzPxkQV8aBfiC92yMf1bAXeJhUlvOdMN
         +a55RrfhrPzb7CeV60skKkFWaFWn9sGyLJCa1QJqETnZvahLnEFaGc6Zp4SrgS+/g+12
         O/2bxVybNrtzHld+IlWcDZBD/HnE526RMBlAdvsD5LfbXjihPnGccYFfpgU38B7uMPxF
         pAHuPMajaMlf1Lyjo5p3EW77vTP5sRKWn9ZzMTOjBPBvgkbcFjWnZA/hWOjloEypcib1
         YwlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnlan/HzzLjrv5wmCzbMtDYAQfvQOmrHRFiUAwKcOMVFH1gv39h3ifRtUCAnVkMgCyABs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFHsJHb2b1nHpOdgB5UvkHvtO5iNUWovus3LR0s3XgCJ8slZdW
	R4ou++nF3Qgli+2uPGIIQSSycs5kxTNNKlYpgwmRL2V5jzLiFshj/4fd6sFFC/2fHBE=
X-Gm-Gg: ATEYQzxQ/MYjOg0LrZnLgHLYd8K5LajLGDF3HVKnDGgvqVcRVXeCcFv27vtJPcoemPx
	nfAaATYExvB937Pxx1J6ScHKGByVcKPq75SA91CgFBNd+IhApGo9V/O/BWRDgT7IltjVgmIaPvR
	TPkw3lyAdnCl5VL9tzrsK5apMDdjtX46NwiIe/l6/ZDQh55lt9O0oRVlj+/v44y0Flq3DGcH+it
	BD1ot/jL/l96OPjKbg3Z8PsERSmwGT1YlELPB7+p2E5ls/vIzLB7RQFhQ84sca/k6kXs1ub+f8n
	r6hg0SIoMnaTisMFXd0aNaMOD2tetMQhwRIlb3cEGaH/juXXdYma60O9dz8qNrAzp/sh4tPgfbD
	ITiIptmHIWQZd5gdGrIM9IgidKPMU8ZWGtXJ00fjiBU1TsTQxu4patWzuTuGe7UJzFye3sQApOr
	JnfShVDiLACvW6yxIzCwoYlMIY55Yxsr7Xt2w31zTdnGcH4r/x94BGTt9h7qd/DTWEU4BuYyuEk
	DZYQg52
X-Received: by 2002:ad4:5dc2:0:b0:896:f8dc:f6d4 with SMTP id 6a1803df08f44-899d1d6ca54mr69417576d6.5.1772238489925;
        Fri, 27 Feb 2026 16:28:09 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c7376847sm55825926d6.28.2026.02.27.16.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 16:28:09 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vw8Bk-00000001WwN-1wgX;
	Fri, 27 Feb 2026 20:28:08 -0400
Date: Fri, 27 Feb 2026 20:28:08 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: dan.j.williams@intel.com
Cc: Robin Murphy <robin.murphy@arm.com>, Alexey Kardashevskiy <aik@amd.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Melody Wang <huibo.wang@amd.com>,
	Seongman Lee <augustus92@kaist.ac.kr>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Denis Efremov <efremov@linux.com>,
	Geliang Tang <geliang@kernel.org>,
	Piotr Gregor <piotrgregor@rsyncme.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kim Phillips <kim.phillips@amd.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Claire Chang <tientzu@chromium.org>, linux-coco@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [PATCH kernel 4/9] dma/swiotlb: Stop forcing SWIOTLB for TDISP
 devices
Message-ID: <20260228002808.GO44359@ziepe.ca>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-5-aik@amd.com>
 <699f238873ae7_1cc5100b6@dwillia2-mobl4.notmuch>
 <04b06a53-769c-44f1-a157-34591b9f8439@arm.com>
 <699f621daab02_2f4a1008f@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <699f621daab02_2f4a1008f@dwillia2-mobl4.notmuch>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	TAGGED_FROM(0.00)[bounces-72253-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[ziepe.ca];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_GT_50(0.00)[58];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,ziepe.ca:mid,ziepe.ca:dkim,intel.com:email]
X-Rspamd-Queue-Id: 6C70C1BF6E4
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 12:57:01PM -0800, dan.j.williams@intel.com wrote:
> > (since a device that's trusted to access private memory
> > isn't necessarily prohibited from still also accessing shared memory as
> > well), hmmm...
> 
> The specification allows it, but Linux DMA mapping core is not yet ready
> for it. So the expectation to start is that the device loses access to
> its original shared IOMMU mappings when converted to private operation.

Yes, the underlying translation changes, but no, it doesn't loose DMA
access to any shared pages, it just goes through the T=1 IOMMU now.

The T=1 IOMMU will still have them mapped on all three platforms
AFAIK. On TDX/CCA the CPU and IOMMU S2 tables are identical, so of
course the shared pages are mapped. On AMD there is only one IOMMU so
the page must also be mapped or non-TDISP is broken.

When this TDISP awareness is put in the DMA API it needs to be done in
a way that allows DMA_ATTR_CC_DECRYPTED to keep working for TDISP
devices.

This is important because we are expecting these sorts of things to
work as part of integrating non-TDISP RDMA devices into CC guests. We
can't loose access to the shared pages that are shared with the
non-TDISP devices...

> So on ARM where shared addresses are high, it is future work to figure
> out how an accepted device might also access shared mappings outside the
> device's dma_mask.

ARM has a "solution" right now. The location of the high bit is
controlled by the VMM and the VMM cannot create a CC VM where the IPA
space exceeds the dma_mask of any assigned device.

Thus the VMM must limit the total available DRAM to fit within the HW
restrictions.

Hopefully TDX can do the same.

Jason

