Return-Path: <kvm+bounces-29100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72DD89A2A56
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 19:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0878F1F28509
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 17:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 647371E0B70;
	Thu, 17 Oct 2024 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PfzY6Kqi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118621E0B67
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 17:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729184757; cv=none; b=YjoBejVs5cG7h4cW2BnoIl1kpbQ+rnuqR+GdjPfe0mhivhB16naofpuNcI3UxL7mvYQ30QMBhQcUgDYO05fAuCQLJj7IourD6briXDCT3sAvBimEhvgSYsciAJO50iRmHsbM3cyTJQRXvqQEsMgd4a7yMtp4eA0jpmF51VbWnbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729184757; c=relaxed/simple;
	bh=nwUmW3HwWk2L8wzAarlBvpMicClGRl1zSOHwmH7o7OM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fa5hzhaSP3CODNj41dn9nG3jHVDavu3AeGBd0h1Vg7sSmei6Gs33q1KFYtN3rWSPKzJc29rVO+c2XF/VFW1vY7J4N/CP6MXAu6tllcYoIfXXO0ujCVQB9GPg5hvtMqMxtWa8oIW1+vlBq65vAUdeit6EG7RfqmfQmp1Ig1nVCMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PfzY6Kqi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729184755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pTxdalYG31XpePFBi14kwyLsxFtz4ngJLPKLlOmswew=;
	b=PfzY6KqiKPiFyvF0qNrKWt8hVKUDJ55D7Q6OWmFLJlMBomZ98jjZ9YNUjPc1nsjHIintwE
	OHcH8y9u0dDlErAH67lSn6+5IqniKcRJBw5hcdCGNMkvKBQhhVgoEU300829ZsBiOPMleg
	FfmCMLRLTBcoYLuwjBJ34pfvBGSdovg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-uVXzrEYgP0CX2EdBPbwqMg-1; Thu, 17 Oct 2024 13:05:54 -0400
X-MC-Unique: uVXzrEYgP0CX2EdBPbwqMg-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7aed2d01616so183238085a.1
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 10:05:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729184753; x=1729789553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pTxdalYG31XpePFBi14kwyLsxFtz4ngJLPKLlOmswew=;
        b=XS+B1HQrxfnAOR2QozIakeiAM9tpcqBid/P29gIoV9Tw9TPx9H2GaFfjEc2LGlpcFp
         Y1oiojdEYRByhTWCqzwNp2DsOgTApQfRjHXiU8/HYjlZPzzb6LaVNDEHyYwGyDp1V0rX
         KA1osuwwFM7sJhT3Hk/CBRsQT2HHbb/RlGiccq4Nd10qzqUwQsfhHZqMfRERBTDzaihj
         Hp4y5X3EvouW+++nsohkEEB0DiC01PqSdYORgzCVgPKkHe/qrArHAlOcBppH26YVgR9A
         ZVbiu8Ry8kjhOJSRRCIe3iW46EzGqSzfd4thY0G0/ml9qmDpu/kPZ0jL/prwV2FhcHaK
         xIuQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1F7qK68El7DWmXLWjTS6o4JVtjVTfHjmYwbpewLANHSPaCo7E1lO7UWGfGCwJ5ZWIt9I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRA3tpNcbMVrQRPH2SJt2SwNmoCBPT5E0iz1dfoap89SyOYCbj
	Ar1mUXsM2vVQFt3sW0mP3Eq67n3I6M1Swuj/eZSWRj336WoKV7fbRu9lk2JUzPX5JeYddibv88U
	7+wsSo6dncYocJl18KrW7NbcuEacWQ5Nc0IEEH34z9osyLVhl0g==
X-Received: by 2002:a05:620a:372c:b0:7a9:aba6:d037 with SMTP id af79cd13be357-7b1417b3191mr1094413985a.13.1729184753037;
        Thu, 17 Oct 2024 10:05:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHD0En3wQDJBS0nydKh7vHrLHOJlIadS3w4LKE69c5NsvIujdsOvlVIWDnzPR18WON37rexWg==
X-Received: by 2002:a05:620a:372c:b0:7a9:aba6:d037 with SMTP id af79cd13be357-7b1417b3191mr1094408885a.13.1729184752627;
        Thu, 17 Oct 2024 10:05:52 -0700 (PDT)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b136170dd7sm308639185a.53.2024.10.17.10.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 10:05:51 -0700 (PDT)
Date: Thu, 17 Oct 2024 13:05:34 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>,
	Ackerley Tng <ackerleytng@google.com>, tabba@google.com,
	quic_eberman@quicinc.com, roypat@amazon.co.uk, rientjes@google.com,
	fvdl@google.com, jthoughton@google.com, seanjc@google.com,
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com,
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev,
	erdemaktas@google.com, vannapurve@google.com, qperret@google.com,
	jhubbard@nvidia.com, willy@infradead.org, shuah@kernel.org,
	brauner@kernel.org, bfoster@redhat.com, kent.overstreet@linux.dev,
	pvorel@suse.cz, rppt@kernel.org, richard.weiyang@gmail.com,
	anup@brainfault.org, haibo1.xu@intel.com, ajones@ventanamicro.com,
	vkuznets@redhat.com, maciej.wieczor-retman@intel.com,
	pgonda@google.com, oliver.upton@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 26/39] KVM: guest_memfd: Track faultability within a
 struct kvm_gmem_private
Message-ID: <ZxFD3kYfKY0b-qFz@x1n>
References: <diqz8quunrlw.fsf@ackerleytng-ctop.c.googlers.com>
 <Zw7f3YrzqnH-iWwf@x1n>
 <diqz1q0hndb3.fsf@ackerleytng-ctop.c.googlers.com>
 <1d243dde-2ddf-4875-890d-e6bb47931e40@redhat.com>
 <ZxAfET87vwVwuUfJ@x1n>
 <20241016225157.GQ3559746@nvidia.com>
 <ZxBRC-v9w7xS0xgk@x1n>
 <20241016235424.GU3559746@nvidia.com>
 <ZxEmFY1FcrRtylJW@x1n>
 <20241017164713.GF3559746@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241017164713.GF3559746@nvidia.com>

On Thu, Oct 17, 2024 at 01:47:13PM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 17, 2024 at 10:58:29AM -0400, Peter Xu wrote:
> 
> > My question was more torwards whether gmemfd could still expose the
> > possibility to be used in VA forms to other modules that may not support
> > fd+offsets yet.
> 
> I keep hearing they don't want to support page pinning on a guestmemfd
> mapping, so VA based paths could not work.

Do you remember the reasoning of it?  Is it because CoCo still needs to
have a bounded time window to convert from shared back to private?  If so,
maybe that's a non-issue for non-CoCo, where the VM object / gmemfd object
(when created) can have a flag marking that it's always shared and can
never be converted to private for any page within.

So how would VFIO's DMA work even with iommufd if pages cannot be pinned?
Is some form of bounce buffering required, then?

It sounds like if so there'll be a lot of use cases that won't work with
current infrastructure..

> 
> > I think as long as we can provide gmemfd VMAs like what this series
> > provides, it sounds possible to reuse the old VA interfaces before the CoCo
> > interfaces are ready, so that people can already start leveraging gmemfd
> > backing pages.
> 
> And you definitely can't get the private pages out of the VA interface
> because all the VMA PTEs of private pages are non-present by definition.

It's the same as "not present" if the fault() gets a SIGBUS always for
private pages, IIUC.

My prior references to "VA ranges" are mostly only for shared / faultable
pages. And they'll get zapped too when requested to be converted from
shared -> private, aka, always not present for private.

> 
> Hence, you must use the FD for a lot of use cases here.

Thanks,

-- 
Peter Xu


