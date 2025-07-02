Return-Path: <kvm+bounces-51299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FEF3AF5AC1
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:14:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 952D23B8E47
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 14:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35EE72BEC52;
	Wed,  2 Jul 2025 14:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="b2PaRKIH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4E32882B2
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 14:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751465606; cv=none; b=kAHSZACktbhVwdCdlj62LSd+8bgAsp0iqSf2YZrQzsebFtJ57ZUo5I1TR0Lpaf2MlGRuCSMlRk9xo6qjJe59F8T1wobVg8kU8R0A1d4fcZTmDsT2+6vK0xdrhZlzasl7dvBtqVlB5+P8IK+gUd4tFgxtdAL9XirhbowXkGouFp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751465606; c=relaxed/simple;
	bh=T2cbnqQkqCu7yJ1ibRZfqew237LIDEtBM6zvXy3oISY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=euPvtPzZPLVU/O/icuFkyThurpCCFP1sXGeIOwnWAiOJhul2SD+FuelZsilOOqWXi2xtv2XixTI7KHpees8Gk0M0sr5S2I0fDXN6ZaHE/RQzy5yhyXEW+V32QCG283pnbWuXUVwitHxVW/cdrgenSBJCHjv4T+pOkXs8DhIWgjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=b2PaRKIH; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4a77ea7ed49so79138191cf.0
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 07:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1751465603; x=1752070403; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LI2D5V4EggMWsDP/C9ghbDqwYMTHQ8Upr7Uk1D8akao=;
        b=b2PaRKIHNS83igXP3/qMRz9J+6Llacyao2+jWyTXEBLy23E7u50tuB07aAONdHK9yL
         bX6+QsJpcwBlZLT2r8WVVztPiB+myLlg/aIdcKA/FYrZcjPkILIfLj8XW6Nf6G/5PEbw
         EzaantsYhzeHe8POJSFwxpkYtrUDw29BoFk2YFyWDT4hHvxBgb31szrd2dciGRriPgR7
         m5pyxwkgzLt5iYIUWEWHMbQum8TgivKQYkrO4Od5Kwk2igFFwXQk6eGAdtlCecUACW6i
         MAjXjqj2HpeTts1286h2hQSY0HmKB++2IOIgseGHYcqoCu2zokua7GnnucQQgnSanEsC
         5W5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751465603; x=1752070403;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LI2D5V4EggMWsDP/C9ghbDqwYMTHQ8Upr7Uk1D8akao=;
        b=Kc7F7HpRNgbYWQ3j98XuAE8Jzb0VvYSYNvlO3K8gVCcWyL2CvZwxQ1H+bTTQ0MKFX1
         jUhnUe/UQwORGcRh955s+fEi65JfdScHL3GvDkc98gH2bwM9eATsxkkTYcYTtYiDSuZR
         8+ajuoZ3dvJcXAcK9DD7Lrac9P+yLYMlk4RTutBNXf0hpBDHhll8/Cwbj/U/ZhUwUh+U
         0LRyZYn8wGk1mtkLUMYNODZhb2Dl1mR/TMh5Hni7CR0GuTSI9X8jXvNpYm00AY6q3w78
         HMAZD5gjN7LglGMvOaVY9Q9uGrtZoDyc7hbg9YSPJ7FHBch5LLgnQucYRMwA3z6Sn5LW
         hLhw==
X-Forwarded-Encrypted: i=1; AJvYcCXxnkmGKdZgFNInWwXkFLioZ0gNTYScxhNphK4kJTTS/vVRqSQLeAkW5cQ/XdLvTG6K2DU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzbAHT5ZaakT8NF7VdI41BRG6bh+TtnW1gQQAaQBka2KLWhXrZ
	J4qo5RQmnZvN8R6H/UEFFbpc5hqRYKeeGIwo/70Hv4Zl/fytqM4Rviaz7zo+6yMpNAo=
X-Gm-Gg: ASbGncu46GG+LmfN4A3Yrm7nqjs0spvRp2SpEpyKYuvCmM798s7sQ0rwXo9wWn8V08d
	9c/URUqhfZOe3B5LhvRPdVtDNGQsV5IEWi/lrp+wxEkCAHvZyA16QEk3pbTaxB4uypmMObel5XA
	IE8x3frDmHBL4DOlBHakJV7vTPjU/uIuxUBRYhcL8b14WwJQGxwWHpoBW84MR9r5SmIgpn+9U5k
	UgoOVpwMF1VZM702F4CRwQgKIzqfFvPqVBgwPRk9eLbphc4XVgyGvqtlJyz5tVX7jkRVIQDWUfi
	VSYRmKMSLEQ+3iI/mH/nRd8S4qEE3HWD1mho
X-Google-Smtp-Source: AGHT+IFGejWlBdta72VP8k4wECxNZ4C8RRbrgrTD+eMk+Zg9yBG/xm3+F7tKfuIfEoyh6KMev8oSSw==
X-Received: by 2002:a05:622a:1109:b0:4a7:81f6:331e with SMTP id d75a77b69052e-4a977bdec57mr34518361cf.6.1751465603229;
        Wed, 02 Jul 2025 07:13:23 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a7fc1061d3sm92215001cf.15.2025.07.02.07.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:13:22 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uWyDB-00000004jk4-3JNi;
	Wed, 02 Jul 2025 11:13:21 -0300
Date: Wed, 2 Jul 2025 11:13:21 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
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
Message-ID: <20250702141321.GC904431@ziepe.ca>
References: <d3832fd95a03aad562705872cbda5b3d248ca321.1747264138.git.ackerleytng@google.com>
 <CA+EHjTxtHOgichL=UvAzczoqS1608RSUNn5HbmBw2NceO941ng@mail.gmail.com>
 <CAGtprH8eR_S50xDnnMLHNCuXrN2Lv_0mBRzA_pcTtNbnVvdv2A@mail.gmail.com>
 <CA+EHjTwjKVkw2_AK0Y0-eth1dVW7ZW2Sk=73LL9NeQYAPpxPiw@mail.gmail.com>
 <CAGtprH_Evyc7tLhDB0t0fN+BUx5qeqWq8A2yZ5-ijbJ5UJ5f-g@mail.gmail.com>
 <9502503f-e0c2-489e-99b0-94146f9b6f85@amd.com>
 <20250624130811.GB72557@ziepe.ca>
 <CAGtprH_qh8sEY3s-JucW3n1Wvoq7jdVZDDokvG5HzPf0HV2=pg@mail.gmail.com>
 <aGTvTbPHuXbvj59t@yzhao56-desk.sh.intel.com>
 <CAGtprH9-njcgQjGZvGbbVX+i8D-qPUOkKFHbOWA20962niLTcw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9-njcgQjGZvGbbVX+i8D-qPUOkKFHbOWA20962niLTcw@mail.gmail.com>

On Wed, Jul 02, 2025 at 06:54:10AM -0700, Vishal Annapurve wrote:
> On Wed, Jul 2, 2025 at 1:38 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Tue, Jun 24, 2025 at 07:10:38AM -0700, Vishal Annapurve wrote:
> > > On Tue, Jun 24, 2025 at 6:08 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > >
> > > > On Tue, Jun 24, 2025 at 06:23:54PM +1000, Alexey Kardashevskiy wrote:
> > > >
> > > > > Now, I am rebasing my RFC on top of this patchset and it fails in
> > > > > kvm_gmem_has_safe_refcount() as IOMMU holds references to all these
> > > > > folios in my RFC.
> > > > >
> > > > > So what is the expected sequence here? The userspace unmaps a DMA
> > > > > page and maps it back right away, all from the userspace? The end
> > > > > result will be the exactly same which seems useless. And IOMMU TLB
> > >
> > >  As Jason described, ideally IOMMU just like KVM, should just:
> > > 1) Directly rely on guest_memfd for pinning -> no page refcounts taken
> > > by IOMMU stack
> > In TDX connect, TDX module and TDs do not trust VMM. So, it's the TDs to inform
> > TDX module about which pages are used by it for DMAs purposes.
> > So, if a page is regarded as pinned by TDs for DMA, the TDX module will fail the
> > unmap of the pages from S-EPT.

I don't see this as having much to do with iommufd.

iommufd will somehow support the T=1 iommu inside the TDX module but
it won't have an IOAS for it since the VMM does not control the
translation.

The discussion here is for the T=0 iommu which is controlled by
iommufd and does have an IOAS. It should be popoulated with all the
shared pages from the guestmemfd.

> > If IOMMU side does not increase refcount, IMHO, some way to indicate that
> > certain PFNs are used by TDs for DMA is still required, so guest_memfd can
> > reject the request before attempting the actual unmap.

This has to be delt with between the TDX module and KVM. When KVM
gives pages to become secure it may not be able to get them back..

This problem has nothing to do with iommufd.

But generally I expect that the T=1 iommu follows the S-EPT entirely
and there is no notion of pages "locked for dma". If DMA is ongoing
and a page is made non-secure then the DMA fails.

Obviously in a mode where there is a vPCI device we will need all the
pages to be pinned in the guestmemfd to prevent any kind of
migrations. Only shared/private conversions should change the page
around.

Maybe this needs to be an integral functionality in guestmemfd?

Jason

