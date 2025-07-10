Return-Path: <kvm+bounces-52053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BD7CB00AE3
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 19:56:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC9071889E79
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 17:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62696266F0D;
	Thu, 10 Jul 2025 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="gJA3G+kJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67292F2361
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752170094; cv=none; b=D7Ng7iQeXJZbEaUvFCxN9FuRBIvhASLg3sfBj2gw5FQGne8Gj+QK4HLsJGLJfJOD2bCL/LTaumh2DWH36wWzXPIqLQgDAvG/6jTFd5cUXTHDRZ+M5E96iRNLzW3NZhA0+ksiRi0CYo4Q4xEvBtjPwEr4MXEskq8Js2h5rkQMXFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752170094; c=relaxed/simple;
	bh=dN2wSaYlh8IL928VSQxwiE6INT6UZzYtJixOMZvv0BQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hpmV8oayqK+rbFMsrFFP76Gmy97i+YV8g6weKoyfjjRDf9dBY4TvP41DAXR27DfkPAMCYEToRgvU8iVyySqkyLdhod9rctQEO00cuDnjBf28B983axMTNCfgdsQVzCJneFOx+J+CM3UAeGIhC54cc2LvaIjih9NX/dgp4dtOMGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=gJA3G+kJ; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b1fd59851baso1031787a12.0
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 10:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1752170092; x=1752774892; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HlXUsgYpVWPkbX8oMthsLhbtJUL7p0PJ63EhWSwPiGE=;
        b=gJA3G+kJfq/yKFIIMY+E0i9BJVuXVbMLQdSFfA9MAOMN97OpCIeotqovX5QoFWCw/U
         LOZZPyK25K3niAF0UREPbzxIoDr/vp/L+NZilRozSvmx8MLOFQTm5UKYiB87qiatEqdf
         3B3PZ0c8XB35xYJd37TTkBSgHqdS6krQi3DP6CivDonyvmZIoV7bFu82oP6NIwMRjvBe
         F4Kx3xP3jOjidGq8X76OHcwkOok5HSO9W30H8RbuqUThyYTTMSqknBFRjrY8kKWPonNN
         6TKNsl6jYSuNLnD2krf2PpqlWQcBGS5jrUbo/SqLyG00lkzXCmAKR+AJ53De+Xc+8a4d
         ODHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752170092; x=1752774892;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HlXUsgYpVWPkbX8oMthsLhbtJUL7p0PJ63EhWSwPiGE=;
        b=xQJmMBAmeY8eOjzXQhH91XV6N35/ZxrsS0mDmK88828uZXKeFgPP5TxeFX7yDt8ghP
         YfDZ52kcXDOaLfSIEZr4tm8/wD7be5P5nXxTikVdORpMkfuy3zS28dopmRdElnN94un1
         rfjIpEOhO9fDRo4JMqApe3DHsZC2xP14SYOEgL1mzzLFhl+Rb6C/v503m9YiBS6X6Lsd
         o9tn6RqNr0RT4dxGnJeqqLfwa/fkANq42GgE0JEdpwmiJVILh5tTAuZ+RZJT1EtkkMCI
         NwnltnrZIYnPIoECb0HCGgLddATbjt4QqUu0Z1ewPrxjPYnm8MWwFuVz83rxKv3rYe82
         J6Tg==
X-Forwarded-Encrypted: i=1; AJvYcCUPmbL2VRFtihCO1Pwq0yjJgnI4TWKfeVEUqcLzDMXdfzvJ3vJR5Fcj3IzNpFHa8GmbvCk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMy6QRK8bTeHgxPPAt2yNv5FLKLX95VczVp1jqr7Y6SjkoOk3U
	VWtgItjd7u3eVYw70Tdrjc0tP0kneLp/Af4OL4NMwv9gKRx3Be/hJ2THvwxUTGHcRxw=
X-Gm-Gg: ASbGncudi/tTT41f1CL+KplWzWhOCByCfasB28YwEg25mH0O22dNdX72bE1WKVF1HgW
	0DBS/q/aIqvCEmNWNyuowNHz+U2jMRzXq3e4d+Zr8zXZrSt1DJoFFF5IZhgkzp+bYUYBr5j8wzx
	oUEjLobLcF8VNxQN3TU8jzoT77FFF0LYtaVXrKmgvYQYQlDTp/RrPFzw+69IRpoAM2OQmyM+C0+
	qOKsJtM2Bvn/hLC02mnShLGKmAIS8I08tVs5XAl9+YInzi5KrBsdqvnWSK2CXEFdAt0hResef8N
	D/0PKfy/WJa+cdmGei4VYOqcFGiCkMLDQeD0OTdul4CpovA=
X-Google-Smtp-Source: AGHT+IHQpQYpeOko+u1PyjuO7tF8TrxEDaL8lMOxVpnSl269LjT/LT0TmNeqUnE/EZcU54Mh/IefEA==
X-Received: by 2002:a05:6a20:e198:b0:220:764c:9edf with SMTP id adf61e73a8af0-23121109719mr453532637.40.1752170091929;
        Thu, 10 Jul 2025 10:54:51 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3bbe6c5f29sm2773180a12.46.2025.07.10.10.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jul 2025 10:54:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uZvTt-00000007x4Z-1rxa;
	Thu, 10 Jul 2025 14:54:49 -0300
Date: Thu, 10 Jul 2025 14:54:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Vishal Annapurve <vannapurve@google.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
	Fuad Tabba <tabba@google.com>,
	Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	linux-fsdevel@vger.kernel.org, ajones@ventanamicro.com,
	akpm@linux-foundation.org, amoorthy@google.com,
	anthony.yznaga@oracle.com, anup@brainfault.org,
	aou@eecs.berkeley.edu, bfoster@redhat.com,
	binbin.wu@linux.intel.com, brauner@kernel.org,
	catalin.marinas@arm.com, chao.p.peng@intel.com,
	chenhuacai@kernel.org, dave.hansen@intel.com, david@redhat.com,
	dmatlack@google.com, dwmw@amazon.co.uk, erdemaktas@google.com,
	fan.du@intel.com, fvdl@google.com, graf@amazon.com,
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com,
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz,
	james.morse@arm.com, jarkko@kernel.org, jgowans@amazon.com,
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com,
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com,
	kent.overstreet@linux.dev, kirill.shutemov@intel.com,
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com,
	mail@maciej.szmigiero.name, maz@kernel.org, mic@digikod.net,
	michael.roth@amd.com, mpe@ellerman.id.au, muchun.song@linux.dev,
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev,
	palmer@dabbelt.com, pankaj.gupta@amd.com, paul.walmsley@sifive.com,
	pbonzini@redhat.com, pdurrant@amazon.co.uk, peterx@redhat.com,
	pgonda@google.com, pvorel@suse.cz, qperret@google.com,
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com,
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, quic_svaddagi@quicinc.com,
	quic_tsoni@quicinc.com, richard.weiyang@gmail.com,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com,
	shuah@kernel.org, steven.price@arm.com, steven.sistare@oracle.com,
	suzuki.poulose@arm.com, thomas.lendacky@amd.com,
	usama.arif@bytedance.com, vbabka@suse.cz, viro@zeniv.linux.org.uk,
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org,
	willy@infradead.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Subject: Re: [RFC PATCH v2 04/51] KVM: guest_memfd: Introduce
 KVM_GMEM_CONVERT_SHARED/PRIVATE ioctls
Message-ID: <20250710175449.GA1870174@ziepe.ca>
References: <CA+EHjTwjKVkw2_AK0Y0-eth1dVW7ZW2Sk=73LL9NeQYAPpxPiw@mail.gmail.com>
 <CAGtprH_Evyc7tLhDB0t0fN+BUx5qeqWq8A2yZ5-ijbJ5UJ5f-g@mail.gmail.com>
 <9502503f-e0c2-489e-99b0-94146f9b6f85@amd.com>
 <20250624130811.GB72557@ziepe.ca>
 <CAGtprH_qh8sEY3s-JucW3n1Wvoq7jdVZDDokvG5HzPf0HV2=pg@mail.gmail.com>
 <aGTvTbPHuXbvj59t@yzhao56-desk.sh.intel.com>
 <CAGtprH9-njcgQjGZvGbbVX+i8D-qPUOkKFHbOWA20962niLTcw@mail.gmail.com>
 <20250702141321.GC904431@ziepe.ca>
 <CAGtprH948W=5fHSB1UnE_DbB0L=C7LTC+a7P=g-uP0nZwY6fxg@mail.gmail.com>
 <aG+a4XRRc2fMrEZc@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aG+a4XRRc2fMrEZc@yilunxu-OptiPlex-7050>

On Thu, Jul 10, 2025 at 06:50:09PM +0800, Xu Yilun wrote:
> On Wed, Jul 02, 2025 at 07:32:36AM -0700, Vishal Annapurve wrote:
> > On Wed, Jul 2, 2025 at 7:13 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > On Wed, Jul 02, 2025 at 06:54:10AM -0700, Vishal Annapurve wrote:
> > > > On Wed, Jul 2, 2025 at 1:38 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > >
> > > > > On Tue, Jun 24, 2025 at 07:10:38AM -0700, Vishal Annapurve wrote:
> > > > > > On Tue, Jun 24, 2025 at 6:08 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > > > > >
> > > > > > > On Tue, Jun 24, 2025 at 06:23:54PM +1000, Alexey Kardashevskiy wrote:
> > > > > > >
> > > > > > > > Now, I am rebasing my RFC on top of this patchset and it fails in
> > > > > > > > kvm_gmem_has_safe_refcount() as IOMMU holds references to all these
> > > > > > > > folios in my RFC.
> > > > > > > >
> > > > > > > > So what is the expected sequence here? The userspace unmaps a DMA
> > > > > > > > page and maps it back right away, all from the userspace? The end
> > > > > > > > result will be the exactly same which seems useless. And IOMMU TLB
> > > > > >
> > > > > >  As Jason described, ideally IOMMU just like KVM, should just:
> > > > > > 1) Directly rely on guest_memfd for pinning -> no page refcounts taken
> > > > > > by IOMMU stack
> > > > > In TDX connect, TDX module and TDs do not trust VMM. So, it's the TDs to inform
> > > > > TDX module about which pages are used by it for DMAs purposes.
> > > > > So, if a page is regarded as pinned by TDs for DMA, the TDX module will fail the
> > > > > unmap of the pages from S-EPT.
> > >
> > > I don't see this as having much to do with iommufd.
> > >
> > > iommufd will somehow support the T=1 iommu inside the TDX module but
> > > it won't have an IOAS for it since the VMM does not control the
> > > translation.
> 
> I partially agree with this.
> 
> This is still the DMA Silent drop issue for security.  The HW (Also
> applicable to AMD/ARM) screams out if the trusted DMA path (IOMMU
> mapping, or access control table like RMP) is changed out of TD's
> expectation. So from HW POV, it is the iommu problem.

I thought the basic idea was that the secure world would sanity check
what the insecure is doing and if it is not OK then it blows up. So if
the DMA fails because the untrusted world revoked sharability when it
should not have then this is correct and expected?

> For SW, if we don't blame iommu, maybe we rephrase as gmemfd can't
> invalidate private pages unless TD agrees.

I think you mean guestmemfd in the kernel cannot autonomously change
'something' unless instructed to explicitly by userspace.

The expectation is the userspace will only give such instructions
based on the VM telling it to do a shared/private change.

If userspace gives an instruction that was not agreed with the guest
then the secure world can police the error and blow up.
 
> Just to be clear. With In-place conversion, it is not KVM gives pages
> to become secure, it is gmemfd. Or maybe you mean gmemfd is part of KVM.

Yeah, I mean part of.

> > > Obviously in a mode where there is a vPCI device we will need all the
> > > pages to be pinned in the guestmemfd to prevent any kind of
> > > migrations. Only shared/private conversions should change the page
> > > around.
> 
> Only *guest permitted* conversion should change the page. I.e only when
> VMM is dealing with the KVM_HC_MAP_GPA_RANGE hypercall. Not sure if we
> could just let QEMU ensure this or KVM/guestmemfd should ensure this.

I think it should not be part of the kernel, no need. From a kernel
perspective userspace has requested a shared/private conversion and if
it wasn't agreed with the VM then it will explode.

Jason

