Return-Path: <kvm+bounces-57579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FA3AB57F08
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:32:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E4C3206BCD
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 14:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C59313276;
	Mon, 15 Sep 2025 14:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQE8u7WY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F851EC01B
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757946735; cv=none; b=mxdbGdEUMXZ1wx1WDCWe4LLRlIxW1tR8aNV6oNQUadhpDYYAQeBip4fyIQFUSNSniOQI2DBKsoJZyWs9qtCgdraYEQLtfHOeUDGp/QzbaBeDtkZ3o1mTRC+2wxCiA+RPjMEU/sjLpLsp0VxYUX0OJwKXD4lBR+e2XDspo81It7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757946735; c=relaxed/simple;
	bh=jkhBmwEWgExuz1omsIkqNe0kpbi2sCvXXyGnjOfUSxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rpsViv1m8uzq75hLxiKY1y0EcRfVOUVAGD8VGQ6l/ldxmpnzIgetOZZ/OqGfCd7n0HEGLVM5nrqv/+Q91NKLDX47PhaueVl0bPI0MLFASIfI4etaTSpzcJHFyWsMPgpbQi6mw0v0vaR6upmgz3FJib1LdJj9Zb4Qu8q89VmTgH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HQE8u7WY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757946733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aMcQQL6ctMeg3ZJ3cGBnYeUoh99uDNZTCO2BZOovfjI=;
	b=HQE8u7WYVsJXWwocQGOcT+xGM4+iLjl7Ip77W2pL3c8EEJ6ycw+wDN4zz4YpjfNd+3vYMB
	KYErRKFu33gD54zwvI1+GiqSjdfJJKlx3CnqMy1WpWgj/deYjlbVVWV0CelJCFxb89mymk
	BNHRRD7Olm/p54px5Jj77yISpm1sYB4=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-kUXKvgHbP3Sz6cjKc9_Gqg-1; Mon, 15 Sep 2025 10:32:12 -0400
X-MC-Unique: kUXKvgHbP3Sz6cjKc9_Gqg-1
X-Mimecast-MFC-AGG-ID: kUXKvgHbP3Sz6cjKc9_Gqg_1757946731
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-62ee449104bso1209921d50.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 07:32:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757946731; x=1758551531;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aMcQQL6ctMeg3ZJ3cGBnYeUoh99uDNZTCO2BZOovfjI=;
        b=s6nG+dhMgMus50BK7d1OPIPv/1k1kDa29R/uLZkm4R4U5uQDA9gYkO/QTDdBQ9mOKw
         NSRjlNdYYGP7EG8driQVfmWBVzeMJXo/WI9u+S+c0KtC1eMqJk6lsjMPjmXOgL9QNP0s
         s7yAsSvshlK1pqYx06qpXKJoWFaZ4aMsyEEClGXRSpm79u+osTjn6dmemPC6A3iovKpd
         Rnqu0GMLcnCj2HuyOtxVnquJjYb1b/WYEMlqJ3IqUuaBTGVIE0wVbwFBhtLz1Fswv5bS
         6KD463PtpiGP90z7noYl9H63Ca+zUv85B/btADLCJVN2wYf4UgBAFdDIitLn5bq7ek1l
         MCPw==
X-Forwarded-Encrypted: i=1; AJvYcCW54FZ5d3L0y0tOvvWxhL9b2xWpGiWTcqqbOPOLq2Ec0AE6K7c1nZJ9HTIcB3ItgT7p2Io=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfUNetqJu4C+J6MM+p8g/S5A+mONG4ZBnz3nqfs0HE7TRoPDnB
	Kff/1bDqQ2xFrklvz1bGQuazI913dRVB6SAiAvPTI4dRWAVhHE5FesH7ZzccclHesPyolYyJZri
	aRuycnV2HHBi3xS8OJ0I1NE0Zuz28XQ1reymuMQO+n5YbmLKX4WvDPg==
X-Gm-Gg: ASbGncuNmF4Sx5JIbuvws98HlE91eJyBN90yKdIQrchh/IDXb7OmmmPaq769raMods1
	6SrZxcI/SkkHavXMsX3u8a4tB8vr1RhuwIMjy3QfDqDBzb5WS4PrCRJWCiXfhM55eHySc6sjGyk
	Y6u05nz+mHjRQclYI5QOD9rXpWm0Yhz1T4wsWuIlz5RYkvaW/wmZl1+7ZF2UfRVNVM1F3QU3KvY
	o4mpVo19dCMrBUsVHQJUI4V9NmHPAGiAdPUDSheylmmeilltzmKix+ClCbP1IDsNd8dVGDgo8qu
	hNNBMK/Lns2qL006hgBV7puH0NxWKZtbGvGoMZwt
X-Received: by 2002:a53:aa05:0:b0:615:7d8f:66ed with SMTP id 956f58d0204a3-627243538cdmr8359770d50.17.1757946731306;
        Mon, 15 Sep 2025 07:32:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/V0+bL/bskp22k8XnWmcAyP2OD4HiXiRPvDyo43+eFheTBQzEtJAc9iSkcCrfBIyEROc9CA==
X-Received: by 2002:a53:aa05:0:b0:615:7d8f:66ed with SMTP id 956f58d0204a3-627243538cdmr8359725d50.17.1757946730666;
        Mon, 15 Sep 2025 07:32:10 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-78ab368dce4sm4620586d6.38.2025.09.15.07.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 07:32:09 -0700 (PDT)
Message-ID: <f870603f-490e-46a6-8618-201c9550e5e2@redhat.com>
Date: Mon, 15 Sep 2025 10:32:08 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/11] PCI: Add pci_reachable_set()
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>, Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <20250909210336.GA1507895@bhelgaas>
 <3d3f7b6c-5068-4bbc-afdb-13c5ceee1927@redhat.com>
 <20250915133832.GE922134@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250915133832.GE922134@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/15/25 9:38 AM, Jason Gunthorpe wrote:
> On Thu, Sep 11, 2025 at 03:56:50PM -0400, Donald Dutile wrote:
> 
>> Yes, and for clarify, I'd prefer the fcn name to be 'pci_reachable_bus_set()' so
>> it's clear it (or its callers) are performing an intra-bus reachable result,
>> and not doing inter-bus reachability checking, although returning a 256-bit
>> devfns without a domain prefix indirectly indicates it.
> 
> Sure:
> 
> /**
>   * pci_reachable_bus_set - Generate a bitmap of devices within a reachability set
>   * @start: First device in the set
>   * @devfns: Output set of devices on the bus reachable from start
>   * @reachable: Callback to tell if two devices can reach each other
>   *
>   * Compute a bitmap @defvfns where every set bit is a device on the bus of
>   * @start that is reachable from the @start device, including the start device.
>   * Reachability between two devices is determined by a callback function.
>   *
>   * This is a non-recursive implementation that invokes the callback once per
>   * pair. The callback must be commutative::
>   *
>   *    reachable(a, b) == reachable(b, a)
>   *
>   * reachable() can form a cyclic graph::
>   *
>   *    reachable(a,b) == reachable(b,c) == reachable(c,a) == true
>   *
>   * Since this function is limited to a single bus the largest set can be 256
>   * devices large.
>   */
> void pci_reachable_bus_set(struct pci_dev *start,
> 			   struct pci_reachable_set *devfns,
> 			   bool (*reachable)(struct pci_dev *deva,
> 					     struct pci_dev *devb))
> 
> Thanks,
> Jason
> 
Thanks... Don


