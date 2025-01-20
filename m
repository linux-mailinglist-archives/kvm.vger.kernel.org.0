Return-Path: <kvm+bounces-36074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C49FA173C2
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 21:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A90C3A2927
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 20:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F4E81EEA56;
	Mon, 20 Jan 2025 20:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h/+BUBzj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512DB14D711
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 20:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737405982; cv=none; b=aaxzDWGMUdeij2uG4jrpx6E/KjKU4J4EGZ1T2sgvQfviUrBNsCz8P75J3c2OZJK3J40MkcLOGGGERfIrG4OLnTWGiCORZzsza/VVYzYbuNBi95hIKsF+Izuld5aSp9Kc6fCmY5/tV2ldVBh1tAT8iOXrxVTgczEa5CvH/n1ojo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737405982; c=relaxed/simple;
	bh=DJY/B8rpanlZkMFzGpECysweyTLfUs5/1oFemTBK34A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rtaGoWARQS8haitSjoOY5JRLpBMB+rJAGZggNkWWoHc6LYWYswWig1+6Lgsc+Mi71S/Lk2Gzx+B57kyv+9OxOenAGjlqSSfxj+9tMZuWarW3zScnKQbMU4/qhxjY83RCmv+wYEeckgVmECxEAJQCOVJyNGQUu0nGbaEfHUm535g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h/+BUBzj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737405980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e3TVfm1hWW+SQ2qvpmt/ExAOGENiWUkkTKRie7+29lk=;
	b=h/+BUBzjXN6oPFao8cm+feW8QS40TvnMAlims9yr/N8hgzTrkQPYqUgemvaChSgkppzlE0
	4DLKDNho6fYPjSyAq1UcDUlf64dxXAXKax7fHYZy5PKZAB1CUSRAeJghPF7L2OLTtUG9Dz
	BCaqO0V/IfBtTJLa//dWO3NO9Va43+U=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-_tH6AqAdPOaN5uB5JlgssA-1; Mon, 20 Jan 2025 15:46:19 -0500
X-MC-Unique: _tH6AqAdPOaN5uB5JlgssA-1
X-Mimecast-MFC-AGG-ID: _tH6AqAdPOaN5uB5JlgssA
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7b6f3b93f5cso1107295085a.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 12:46:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737405978; x=1738010778;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e3TVfm1hWW+SQ2qvpmt/ExAOGENiWUkkTKRie7+29lk=;
        b=UyoJUbgq4v8V28QqRZfdlv+teqHCv/pROdXl3d2agpepyLSJU6Fs+JnfuRpo12p15q
         lMY6SHAIRbo0MJsw8CC4n6CLzFwuq/iIKnqo95qOpsok9+bniMv+KYyTYcijrIM+L67h
         vErGxrhLI7nfL8cYGxklxNPCsLzKvIgFBTeGTqF2UQlHe/E9sPK2C337qvoBpLJ+VFd5
         97h0QSpnd8tXRk9E8b5iGw0KcnLPx6DgO9ITTmgLcKGpMGkuJJIbpAohdxG4Ntpr/iqx
         8VPRH1wC9ON0XX1q6EvTz31chiSTJHLE1VbqzWSJH+ZeQB3ykNT2CG08iGETpeyDCQj7
         C2Hw==
X-Forwarded-Encrypted: i=1; AJvYcCVTABQhNFNdutVAt/A+1mpOr2ow/1fBAb/KUz3QkhHOPa81c2iFZuqVNtglvPy6hOEIYkc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxC25Tb26zUGJ1+UrxNaoxtKcAgPVAPnUo2nXrJ2Wxu4MsufV/R
	kpO60sBf52jdqbo/UvhjOt9AfaN1PKQ205DDg+BJBQY1T3DapSk9xW0rb1OqKqWhi0Qd0O8eq/K
	TOsmDNdyMziNFezOKPyWm+Ll6JlZwcWuBQM+o+gvEQYmEmao51A==
X-Gm-Gg: ASbGncvhVrs2ycmQyipWgl3zircSIoW+4+uwa6TtcRgeBkD8J5eLxZP/8vLrtdmrb7J
	RtVJylfKOcc/aZpxwny4Xd0lycTINEP/ksDNmDB96UgBH+L65DrEHPX5IHLVcG4h7CSMJ5dfT/z
	5kbrr/cRvKH8nO4EbY6nyzTA76ZOCVbEqh5cBApbaQXnGKbPQwet3iv4siHsO13oOi9kIa0rfLL
	NHaDlHodX0GgLWeuVZBYeDhLDqRqvoKbF59QE5jPZyaPNvUAnLq3UkmMjgiHVBSDDolOMxyzZy8
	8J6Lfo27zPkffmG5ozIATVxannHrBVY=
X-Received: by 2002:a05:620a:410e:b0:7b8:5511:f72d with SMTP id af79cd13be357-7be523e28e0mr3531522985a.17.1737405978534;
        Mon, 20 Jan 2025 12:46:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGDCqhLZKUng+MCpmPy4o7DYVS+UaJHWrKhBKL4yg61rr9grwttwSS0WeRORTYCHwN3m8s3MA==
X-Received: by 2002:a05:620a:410e:b0:7b8:5511:f72d with SMTP id af79cd13be357-7be523e28e0mr3531520385a.17.1737405978257;
        Mon, 20 Jan 2025 12:46:18 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be614d9af2sm482989285a.77.2025.01.20.12.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 12:46:17 -0800 (PST)
Date: Mon, 20 Jan 2025 15:46:15 -0500
From: Peter Xu <peterx@redhat.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z462F1Dwm6cUdCcy@x1n>
References: <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
 <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
 <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
 <2400268e-d26a-4933-80df-cfe44b38ae40@amd.com>
 <590432e1-4a26-4ae8-822f-ccfbac352e6b@intel.com>
 <2b2730f3-6e1a-4def-b126-078cf6249759@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2b2730f3-6e1a-4def-b126-078cf6249759@amd.com>

On Mon, Jan 20, 2025 at 09:22:50PM +1100, Alexey Kardashevskiy wrote:
> > It is still uncertain how to implement the private MMIO. Our assumption
> > is the private MMIO would also create a memory region with
> > guest_memfd-like backend. Its mr->ram is true and should be managed by
> > RamdDiscardManager which can skip doing DMA_MAP in VFIO's region_add
> > listener.
> 
> My current working approach is to leave it as is in QEMU and VFIO.

Agreed.  Setting ram=true to even private MMIO sounds hackish, at least
currently QEMU heavily rely on that flag for any possible direct accesses.
E.g., in memory_access_is_direct().

-- 
Peter Xu


