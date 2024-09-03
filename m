Return-Path: <kvm+bounces-25728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3452D96981F
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 11:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67F2AB260B9
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 09:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCDD1C768B;
	Tue,  3 Sep 2024 09:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CSyh2But"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976091C7676
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 09:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725354041; cv=none; b=AWMLrj5DXHLnSqapkZocU51n5AcWIEP1zagCre41rb921vN6PiFQs0jmpp8C02gySWoV52Hjkb9bSqLsimeaeoMc4xSyJzynrsRZMpeVmEzuCcOD4zGgfg2dCHzp0NSPjqU+WRWZgDBGVbMzRhw3Zsyg63OY606vrRj8oIIJen8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725354041; c=relaxed/simple;
	bh=1L04pRJHwpqlONziVoFoJ3562XOYBoFFgUHaSW/QS5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fqNsnt/BfGz0/8JEKN9dJWY31mttni0QDFpJUHg9duhf5EWUxNpuae3m2jSsqzxWwGsYYxOMPvwDAj1zhrPM4BgxmJOrWFvfxA/H7hkGesJzAU4WjOCyTeWz1zkgQLhlJl/kKwl70DomUNXyZ8wplioMCtvbO/tSg9+pqBdA43g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CSyh2But; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-429d1a9363aso108175e9.1
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 02:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725354038; x=1725958838; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mcAweApl0SMnSEwpMO3VeLlceofmGojlXD55ghcyISI=;
        b=CSyh2But8I7HoheQN/a1dXoSfTIeM5mdGpE8LUYIJ1EmIOflz1ellUlIkJi+XJVvno
         FO35y05Yxi3BvFoJwy1bysP1XaoyrLJr9VSrnYCa8J3dNQOckVp2uWWAdDlsc4TRZfo8
         GpjWNYKbDoF6skFqciC4wbyjBLklrKsYLcHwp7+/JzKBv1a23Zs0E9Te8pZx/D2fhxLJ
         ZpG8UVYDovQWoeKHojO1Nf1nkA+uUX2b70wb870YA+dvFzoldPcso0gsLAuMbxIAQWtz
         7vPVlj4Qe3dw+/bLgLXM6qNJE85A3HGj6sQUrUKkUpDC6ge8r99xTAE/DFAUZC6S8wct
         5LHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725354038; x=1725958838;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mcAweApl0SMnSEwpMO3VeLlceofmGojlXD55ghcyISI=;
        b=mdqEn+m30S7Hc87XfoFMpKhFa1V+Bn9HuQlyudic22EmZWcFJoJoCRyBS6kVVciH3P
         //e2ZTlU/+3lrzllBbbLvRyZZewv0BbGwoX/37s/kaOOe5lYV0JBWoljmsytkcJZ1Ur0
         L3mYHwcROE8sagfEUsIPS1mlh0uY6CmdA+upa87AhX+5LleUEWn8UdoDrIJBemx6+/E5
         rH7dj5zdAB6yrY5TMGOC4CP56IujKAgup98zU9on/aUAdOFomf88q76Yqy8MOzEoQVXn
         6uDTl0L0S3ICZhGaC1fcXw8HhSP/BTRuu9uFaxbHr02NhN0ou6T3ym8C3Mt59ioyNUSX
         xtTA==
X-Forwarded-Encrypted: i=1; AJvYcCWDzUGhpNJaWL4MvfuCcl+p+7ccdcTWStN03wKuXetyOTdsMcY3Mx3zXy5N0kJBh9bmWqU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqqhXlRDDLB/ipmXyNgboY7WVGSq/nEY1458pRQUwNtngGPPzy
	TQb0I1WYDkNNIXsTi3IHdxCxxMfxge2qtEr71S06eMGDSsq64Kq1N5hheFTi9A==
X-Google-Smtp-Source: AGHT+IE6lmyFVDIzRDjMNMDJr7ziWFO9lcVLRUhmriJlMF/fW0JeEBIeoIvfxe2utlR5wgFziPhLlg==
X-Received: by 2002:a05:600c:3485:b0:426:66a0:6df6 with SMTP id 5b1f17b1804b1-42c29f25f8bmr3176475e9.0.1725354037545;
        Tue, 03 Sep 2024 02:00:37 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb6df84b9sm163907905e9.24.2024.09.03.02.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 02:00:37 -0700 (PDT)
Date: Tue, 3 Sep 2024 09:00:32 +0000
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
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <ZtbQMDxKZUZCGfrR@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
 <20240830170426.GV3773488@nvidia.com>
 <ZtWMGQAdR6sjBmer@google.com>
 <20240903003022.GF3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240903003022.GF3773488@nvidia.com>

On Mon, Sep 02, 2024 at 09:30:22PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 02, 2024 at 09:57:45AM +0000, Mostafa Saleh wrote:
> > > > 2) Is there a reason the UAPI is designed this way?
> > > > The way I imagined this, is that userspace will pass the pointer to the CD
> > > > (+ format) not the STE (or part of it).
> > > 
> > > Yes, we need more information from the STE than just that. EATS and
> > > STALL for instance. And the cachability below. Who knows what else in
> > > the future.
> > 
> > But for example if that was extended later, how can user space know
> > which fields are allowed and which are not?
> 
> Changes the vSTE rules that require userspace being aware would have
> to be signaled in the GET_INFO answer. This is the same process no
> matter how you encode the STE bits in the structure.
> 
How? And why changing that in the future is not a problem as sanitising IDRs?

> This confirmation of kernel support would then be reflected in the
> vIDRs to the VM and the VM could know to set the extended bits.
> 
> Otherwise setting an invalidate vSTE will fail the ioctl, the VMM can
> log the event, generate an event and install an abort vSTE.
> 
> > > Overall this sort of direct transparency is how I prefer to see these
> > > kinds of iommufd HW specific interfaces designed. From a lot of
> > > experience here, arbitary marshall/unmarshall is often an
> > > antipattern :)
> > 
> > Is there any documentation for the (proposed) SMMUv3 UAPI for IOMMUFD?
> 
> Just the comments in this series?

But this is a UAPI. How can userspace implement that if it has no
documentation, and how can it be maintained if there is no clear
interface with userspace with what is expected/returned...

> 
> > I can understand reading IDRs from userspace (with some sanitation),
> > but adding some more logic to map vSTE to STE needs more care of what
> > kind of semantics are provided.
> 
> We can enhance the comment if you think it is not clear enough. It
> lists the fields the userspace should pass through.
> 
> > Also, I am working on similar interface for pKVM where we “paravirtualize”
> > the SMMU access for guests, it’s different semantics, but I hope we can
> > align that with IOMMUFD (but it’s nowhere near upstream now)
> 
> Well, if you do paravirt where you just do map/unmap calls to the
> hypervisor (ie classic virtio-iommu) then you don't need to do very
> much.

But we have a different model, with virtio-iommu, it typically presents
the device to the VM and on the backend it calls VFIO MAP/UNMAP.
Although technically we can have virtio-iommu in the hypervisor (EL2),
that is a lot of complexit and increase in the TCB of pKVM.

For pKVM, the VMM is not trusted and the hypervisor would do the map/unmap...,
but the VMM will have to configure the virtual view of the device (Mapping of
endpoints to virtual endpoints, vIRQs…), this requires a userspace interface
to query some HW info (similar to VFIO VFIO_DEVICE_GET_IRQ_INFO and then mapping
it to a GSI through KVM, but for IOMMUs)
Though, this design is very early and in progress.

> 
> If you want to do nesting, then IMHO, just present a real vSMMU. It is
> already intended to be paravirtualized and this is what the
> confidential compute people are going to be doing as well.
> 
> Otherwise I'd expect you'd get more value to align with the
> virtio-iommu nesting stuff, where they have layed out what information
> the VM needs. iommufd is not intended to be just jammed directly into
> a VM. There is an expectation that a VMM will sit there on top and
> massage things.

I haven’t been keeping up with iommufd lately, I will try to spend more
time on that in the future.
But my idea is that we would create an IOMMUFD, attach it to a device and then
through some extra IOCTLs, we can configure some “virtual” topology for it which
then relies on KVM, again this is very early, and we need to support pKVM IOMMUs
in the host first (I plan to send v2 RFC soon for that)

> 
> > I see you are talking in LPC about IOMMUFD:
> > https://lore.kernel.org/linux-iommu/0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com/T/#m2dbb08f3bf8506a492bc7dda2de662e42371e683
> > 
> > Do you have any plans to talk about this also?
> 
> Nothing specific, this is LPC so if people in the room would like to
> use the session for that then we can talk about it. Last year the room
> wanted to talk about PASID mostly.
> 
> I haven't heard if someone is going to KVM forum to talk about
> vSMMUv3? Eric? Nicolin do you know?

I see, I won’t be in KVM forum, but I plan to attend LPC, we can discuss
further there if people are interested.

Thanks,
Mostafa

> 
> Jason

