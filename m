Return-Path: <kvm+bounces-27571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A8ACF9877DA
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 18:53:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96B93B20DBB
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 16:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE8A158DCC;
	Thu, 26 Sep 2024 16:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AOdRbXhQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF8F3F9D5
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727369577; cv=none; b=Fd+nyA8jnsYbW2YNqHW4dsIlLtuIUpWA/tnW9YilfBj1Z6fHk95TH+9R+1pr89Zy57SGpAmFzeRghMG2W17CnThob9VFavNGm7r2ZkDyTR7Qo8B6WOp74ImeR57EAcNfTH5GeTgDNHUVqBmMYJ99Nzk2cklv41dp4W6n9vDtT9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727369577; c=relaxed/simple;
	bh=J1OH4P2HGJb32Si+0OTL/MFTqDk02Yeh0y6VNt4C7to=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MORtxW2GAzHnbD5v3H3lY3M+CI0QzAn2VDcSgXJt27lFYHGTlC58DZi+p6BMjjl9eI1JJWSVNpSZLQRPxwN6LTDnJ42WorMIqfEgxxPNAx29efg/oyXXZyZjaogfw/KM2rx+sOR3jI58rPPNXxRurtTUxLiEOqBoJ7FaaCKhKSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AOdRbXhQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727369573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zj9vLyVeTUrkXFtErPVwTTDYQdcUkLzh1lKD/qYC/0s=;
	b=AOdRbXhQVx45k80zWPRPfhWMvvfZdljeRG0xCbSwHALxB1rjLIykVdhgLS/hbDaJj03aO3
	L6YB2EBRR7cLCpfi5OTYR9x44ySjVrWVaLhhYlXde6ChaXuh56FqAZQDHiGvf5K5GhNKKF
	6eJdcM7s6K6dMe7tR8iLfpg2yZEV+wk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-W1WLAXHbN5q564E23SXjTQ-1; Thu, 26 Sep 2024 12:52:52 -0400
X-MC-Unique: W1WLAXHbN5q564E23SXjTQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7a7fa073718so222397185a.3
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 09:52:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727369572; x=1727974372;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zj9vLyVeTUrkXFtErPVwTTDYQdcUkLzh1lKD/qYC/0s=;
        b=Hg/YH728IQaK3JsteDcp5hjXGRBTVPedJ1jcWXR0U5EZR6oawMqdDz182DveIUghKE
         qkmnmaUBxJ+nL6hV/LJXKM/gLUeCN541ZKk+rUP093D/Mubj3i/8HjTqPgiEWnXEL0lz
         KYE3StV197xAP/NuuFBsobtf/Bta2JwNnnz8adHCAl3gbgskeutKY2W45a9DaohcxDkk
         DRsgEV73iwshLYP4dmtbXZpJoI8bvYw3Auo+s2Q0mRf/cvzux2XXRGjLZ+qqgGd45zfa
         6g3N79TQPV/Goe6dWaIuK+vBpMD48WcLv+PnRROsNH2h1e1FcWA5MVaM91T7lonpTWIb
         V6Lw==
X-Forwarded-Encrypted: i=1; AJvYcCVMW2gwcW+XtHtVBxiNCIfHxk5USuNAi/Xkb8zzJGtoVIxxV/IiPsUjLLtjqIbM9ZMo6GA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNFjly0VjMRwMAvHPl3IEYMDdqi26f920HvtMk/2TX+ehysAd4
	zyJ2a2P9Vg7nOWze2v+uOZDbcLviOPzNJwHmMltX70T7p7GXa2olfjiCDsOkqKmtYAldcBAxff7
	ckfwP3aKgyJ8POp8Jp2oNlnLezZ2ibYM2JMtXnsviJGDyU2jD/w==
X-Received: by 2002:a05:620a:4305:b0:7ab:3511:4eda with SMTP id af79cd13be357-7ae37859606mr28692885a.34.1727369572046;
        Thu, 26 Sep 2024 09:52:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEc18+Y15wl3KbfQPxhfJugWm0iv4GLJ2pqlzsLF1lv3cavBK20N0dqbclFhcsiP8FYcVCfA==
X-Received: by 2002:a05:620a:4305:b0:7ab:3511:4eda with SMTP id af79cd13be357-7ae37859606mr28688285a.34.1727369571647;
        Thu, 26 Sep 2024 09:52:51 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae3782c5f1sm6537285a.74.2024.09.26.09.52.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2024 09:52:51 -0700 (PDT)
Message-ID: <104676c7-9732-4972-b00e-8f65ce9eb259@redhat.com>
Date: Thu, 26 Sep 2024 18:52:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/1] Introduce vfio-cxl to support CXL type-2 device
 passthrough
To: Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org, linux-cxl@vger.kernel.org
Cc: alex.williamson@redhat.com, kevin.tian@intel.com, jgg@nvidia.com,
 alison.schofield@intel.com, dan.j.williams@intel.com, dave.jiang@intel.com,
 dave@stgolabs.net, jonathan.cameron@huawei.com, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alucerop@amd.com, qemu-devel@nongnu.org,
 acurrid@nvidia.com, cjia@nvidia.com, smitra@nvidia.com, ankita@nvidia.com,
 aniketa@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
 zhiwang@kernel.org
References: <20240921071440.1915876-1-zhiw@nvidia.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20240921071440.1915876-1-zhiw@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Zhi,

On 9/21/24 09:14, Zhi Wang wrote:
> Compute Express Link (CXL) is an open standard interconnect built upon
> industrial PCI layers to enhance the performance and efficiency of data
> centers by enabling high-speed, low-latency communication between CPUs
> and various types of devices such as accelerators, memory.
> 
> Although CXL is built upon the PCI layers, passing a CXL type-2 device can
> be different than PCI devices according to CXL specification. Thus,
> addtional changes on are required.
> 
> vfio-cxl is introduced to support the CXL type-2 device passthrough.
> This is the QEMU VFIOStub draft changes to support it.
> 
> More details (patches, repos, kernel config) all what you need to test
> and hack around, plus a demo video shows the kernel/QEMU command line
> can be found at:
> https://lore.kernel.org/kvm/20240920223446.1908673-7-zhiw@nvidia.com/T/


I have started looking at the software stack and the QEMU trees
are quite old. Could you please rebase the branches on the latest ?

Also, I think having a single branch per project would be easier.

For linux :
   [v2] cxl: add Type2 device support
   [RFC] vfio: introduce vfio-cxl to support CXL type-2
   [RFC] samples: introduce QEMU CXL accel driver

Same for QEMU.

Thanks,

C.



> 
> Zhi Wang (1):
>    vfio: support CXL device in VFIO stub
> 
>   hw/vfio/common.c              |   3 +
>   hw/vfio/pci.c                 | 134 ++++++++++++++++++++++++++++++++++
>   hw/vfio/pci.h                 |  10 +++
>   include/hw/pci/pci.h          |   2 +
>   include/hw/vfio/vfio-common.h |   1 +
>   linux-headers/linux/vfio.h    |  14 ++++
>   6 files changed, 164 insertions(+)
> 


