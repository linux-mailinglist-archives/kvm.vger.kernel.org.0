Return-Path: <kvm+bounces-17858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52AFA8CB36E
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 20:20:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 116722831A4
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 18:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD5A14830C;
	Tue, 21 May 2024 18:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hmtmV7Sz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B94921105
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 18:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716315594; cv=none; b=IxTD/lRsIVavWEr0TPed5/tNaPF5xf1/FdHz47Ms2mqNAJauH38WhXtHCKr2umQqiRKx2Qz/N4q29Wb97FT0AjuBJyg8hsApPLg93682vY8od8RQvNnglgqEkUqXYoW9+PA6+4LDjbplvjVGY9C3em8IaMeLE6teYlEBoLHZheM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716315594; c=relaxed/simple;
	bh=0dqwcK/XPOcEv1mTsxYC7i1Y/75vW0HO1WRQSYOUEbI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q40RcZfqPRCNrIcRmVX4wJq3VAeZYZuHBfIdthtz/HfYqMC57I0LDCEonf9chU6t1HqTCBJbW3lI/qRFb1ujK6sr+93cibLb0qRNlT++SWxUYk2OGGy46bRVEF2AtGcmowbtB6s1+isIAQlOmBos23l8zWkiCoBLM4KnZcjcD7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hmtmV7Sz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716315592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Isde2dh7/647rfx8u6foFeQh7vHwio2r62p6n+pus0=;
	b=hmtmV7SzpuyJ8YU0hz/Hv8fUCLH/FMReUonj2oErAXbGez2HCzD7FV2AIODnsQBoPH1DAy
	hZjPPkC4bn5Sp/1js8bjQuoxVK4wVkcglKBZqyKTtVtyvITAigOdFjLTVk37kTQjun6+O+
	5dQCCxOtK7mehfqRtHarNwCtxUA/m78=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-tqbHmUesO0OHKQB4iQ3_sg-1; Tue, 21 May 2024 14:19:50 -0400
X-MC-Unique: tqbHmUesO0OHKQB4iQ3_sg-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7e255f62e6cso101068339f.0
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 11:19:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716315590; x=1716920390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Isde2dh7/647rfx8u6foFeQh7vHwio2r62p6n+pus0=;
        b=uLXBDRD4mB5TRw7hRf2j6ia5K2ZX9FdH3Qs7Io1iCECl66E+JN3ko4HFN6sGnXIcfi
         g9VZIPlYTZwGpUYU46sGXrEKLBh3Z6fV9FWQxzGzNihu0G/QqAw6wRtL69teVrCaA7r8
         Ci3kFxuoAJSvNM1XBk3gVGVD3M52wXjuqIWwnpmdJ/s7GME61JVdbenjHYCukBeu+ZdN
         hWltHuRpjO4myvLPhkaYjvmqynNyND/HFc77H0LAox5mnIT+oK9v8y4UUSI2BjX2QHbt
         jCvpFR5f4lss726av3Vnsl37BUwCypkgvU1tqnm2OUtNeePn0Bo5lRtl+SzVINzGRmCG
         z6xg==
X-Forwarded-Encrypted: i=1; AJvYcCVCkIQpmetyPZUf3zhIpStSrsZ8XVcOWOvs9+s4Ig3gANG8S/a7hdfG96Dhs/Anau1Ak069x7e+oLCIUjxMdTFSWuMf
X-Gm-Message-State: AOJu0YxKkLCVgjnsTInz8440Ln2GJZKUs/pwiQ8w13Q/Ctxg0jhgjswJ
	7HEI0uQQVcUPyghTIEvVzGCAU3wEOAjBQo5yjQPmh4gmSSUJgdSrke5Pfdy0pjDeDo8KPOAX3ZC
	aJIjmlMQKJl/rLts1/uOD+HVPipw9Z1g4J9veSFTuPF1HHfIrHA==
X-Received: by 2002:a5d:9553:0:b0:7e1:973b:fbfc with SMTP id ca18e2360f4ac-7e1b520c7b7mr3444747039f.15.1716315589657;
        Tue, 21 May 2024 11:19:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4dEPJMmyq53uNgsrumO7N0Qr7jKz/Z8GDsO+x2zbKwDnCjIJWu7WA5azwt4gAJaAXiGpCZA==
X-Received: by 2002:a5d:9553:0:b0:7e1:973b:fbfc with SMTP id ca18e2360f4ac-7e1b520c7b7mr3444744239f.15.1716315589310;
        Tue, 21 May 2024 11:19:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-489376de0e3sm7019591173.146.2024.05.21.11.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 May 2024 11:19:48 -0700 (PDT)
Date: Tue, 21 May 2024 12:19:45 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "Vetter, Daniel"
 <daniel.vetter@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
 <peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
 "joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240521121945.7f144230.alex.williamson@redhat.com>
In-Reply-To: <20240521163400.GK20229@nvidia.com>
References: <20240509121049.58238a6f.alex.williamson@redhat.com>
	<Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
	<20240510105728.76d97bbb.alex.williamson@redhat.com>
	<ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
	<BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240516143159.0416d6c7.alex.williamson@redhat.com>
	<20240517171117.GB20229@nvidia.com>
	<BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240521160714.GJ20229@nvidia.com>
	<20240521102123.7baaf85a.alex.williamson@redhat.com>
	<20240521163400.GK20229@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 21 May 2024 13:34:00 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, May 21, 2024 at 10:21:23AM -0600, Alex Williamson wrote:
> 
> > > Intel GPU weirdness should not leak into making other devices
> > > insecure/slow. If necessary Intel GPU only should get some variant
> > > override to keep no snoop working.
> > > 
> > > It would make alot of good sense if VFIO made the default to disable
> > > no-snoop via the config space.  
> > 
> > We can certainly virtualize the config space no-snoop enable bit, but
> > I'm not sure what it actually accomplishes.  We'd then be relying on
> > the device to honor the bit and not have any backdoors to twiddle the
> > bit otherwise (where we know that GPUs often have multiple paths to get
> > to config space).  
> 
> I'm OK with this. If devices are insecure then they need quirks in
> vfio to disclose their problems, we shouldn't punish everyone who
> followed the spec because of some bad actors.
> 
> But more broadly in a security engineered environment we can trust the
> no-snoop bit to work properly.

 The spec has an interesting requirement on devices sending no-snoop
 transactions anyway (regarding PCI_EXP_DEVCTL_NOSNOOP_EN):

 "Even when this bit is Set, a Function is only permitted to Set the No
  Snoop attribute on a transaction when it can guarantee that the
  address of the transaction is not stored in any cache in the system."

I wouldn't think the function itself has such visibility and it would
leave the problem of reestablishing coherency to the driver, but am I
overlooking something that implicitly makes this safe?  ie. if the
function isn't permitted to perform no-snoop to an address stored in
cache, there's nothing we need to do here.

> > We also then have the question of does the device function
> > correctly if we disable no-snoop.  
> 
> Other than the GPU BW issue the no-snoop is not a functional behavior.

As with some other config space bits though, I think we're kind of
hoping for sloppy driver behavior to virtualize this.  The spec does
allow the bit to be hardwired to zero:

 "This bit is permitted to be hardwired to 0b if a Function would never
  Set the No Snoop attribute in transactions it initiates."

But there's no capability bit that allows us to report whether the
device supports no-snoop, we're just hoping that a driver writing to
the bit doesn't generate a fault if the bit doesn't stick.  For example
the no-snoop bit in the TLP itself may only be a bandwidth issue, but
if the driver thinks no-snoop support is enabled it may request the
device use the attribute for a specific transaction and the device
could fault if it cannot comply.

> > The more secure approach might be that we need to do these cache
> > flushes for any IOMMU that doesn't maintain coherency, even for
> > no-snoop transactions.  Thanks,  
> 
> Did you mean 'even for snoop transactions'?

I was referring to IOMMUs that maintain coherency regardless of
no-snoop transactions, ie domain->enforce_cache_coherency (ex. snoop
control/SNP on Intel), so I meant as typed, the IOMMU maintaining
coherency even for no-snoop transactions.

That's essentially the case we expect and we don't need to virtualize
no-snoop enable on the device.

> That is where this series is, it assumes a no-snoop transaction took
> place even if that is impossible, because of config space, and then
> does pessimistic flushes.

So are you proposing that we can trust devices to honor the
PCI_EXP_DEVCTL_NOSNOOP_EN bit and virtualize it to be hardwired to zero
on IOMMUs that do not enforce coherency as the entire solution?

Or maybe we trap on setting the bit to make the flushing less
pessimistic?

Intel folks might be able to comment on the performance hit relative to
iGPU assignment of denying the device the ability to use no-snoop
transactions (assuming the device control bit is actually honored).
The latency of flushing caches on touching no-snoop enable might be
prohibitive in the latter case.  Thanks,

Alex


