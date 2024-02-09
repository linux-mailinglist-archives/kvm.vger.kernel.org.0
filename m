Return-Path: <kvm+bounces-8459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF95C84FB5B
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 19:01:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9EFF51F21BAC
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 437BC80BE9;
	Fri,  9 Feb 2024 18:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fQe0EU8X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFD47E770
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 18:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707501654; cv=none; b=RiISYkjiw4i4fj71NPScQeewXtjNFSXlsS8Shd2vwm5DKeCgwBDJA7xSX8c3VvRJ29uRDIz9D0U86QwtFZos2IqASS3l1K2sdyt0UOWk4ArLkX5WZuREIa2/VppZcdpKT1A5VSzWnRWBYOP9ZYj22nqcDkj5oFhum9Sektr4buI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707501654; c=relaxed/simple;
	bh=QRdZxK7Tu+cNFBLPSs5931EMt7+QiU8yFs+2dn34QJw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HL0t+oXjhwyz5Wpt8rp5n6I0sSWlc/O2H4R5GOOA+1S8o0dKB27AmK8e4tZBNeXaR5gQJC1fpZW0RX9+fCjI7w70DjiRM9vo9coQKguFHu5qh/J4QSlnVIKldy/bYZ/NmxUS+LdvpEJ3G6AQj2PktVmOaEPiddoAZD6+Gini4kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fQe0EU8X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707501651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ylu12OBeg+Qpx23OaATwkmagVevzhUpZSCqsCihw3M=;
	b=fQe0EU8XAtwnpth/wEkKuSDOgwFlftdKDtm5W3znydJfOo6Q2YDoJniy2XZYQZGK4XS/te
	LKZKC0EXe2CIBhmdTwY0OvHL/xAAb5G6VrbHl3uF0JAM8JJOtk98B3tG4FiFgLv2yVO6kY
	SOpWyPoaxPCw+9RixMfmX9frAzJiggE=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-8_cnnmAKOsGAoeWhPyxCuQ-1; Fri, 09 Feb 2024 13:00:50 -0500
X-MC-Unique: 8_cnnmAKOsGAoeWhPyxCuQ-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-363befae30fso9786405ab.1
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 10:00:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707501649; x=1708106449;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ylu12OBeg+Qpx23OaATwkmagVevzhUpZSCqsCihw3M=;
        b=upGfdp9XcXlRKcDFBGr1rRxQarhub2BMM2Qq94gD60yorIF/ysNBunYZ85b5rLR43A
         mc4K4P5TIJ4ci5THnGBE4fmX3dRtJHykHbASw5YtcLphNaXZ1Bc8SvSvKvhejAAi2K3A
         B1UuCY2XM15wabtU0a4JKc9ngjiw5/FWAPAfB5gvb0iSP4NCUziYD7SlTkEOlkT6uyAd
         HlOf9Jqqr4hpggt6hyN4BFpkUDAzwtnsZCyI230Odz07Lr0Io8uZx+dez6Vs1V8GmgMJ
         1T0jWh69fJaVqCJGYsxWAyZ4Mq5jWIY68N+LQ9o+9v1wdCvCSIQO6/jRq8vqzcmcpdWb
         yVeg==
X-Gm-Message-State: AOJu0Yy/q6VrHBkQp1g2Wf5o6l2dx+fiNVR8B/9jU9xuPrzuTpK4GCDl
	lC/zalcxUlySXmqHv3GqAgpy8ozcv+jeyIjTunxuPB0Q6c3fFB7VXg1Xz7/CxJD2It7yA1xme16
	kfEyY9eGcf08KHYN5rlzWqZLEMPy/pDWuCrTIgg+hVbF8SDUQXg==
X-Received: by 2002:a92:d6c9:0:b0:363:dec8:fedd with SMTP id z9-20020a92d6c9000000b00363dec8feddmr2458790ilp.12.1707501649241;
        Fri, 09 Feb 2024 10:00:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEDO1vhR55/MuZNOdx0iksnkDWQ4ps5M/OOsVIbd4hXwhhNB2M2/k1IJDQuW5bFi6ICBG0vJg==
X-Received: by 2002:a92:d6c9:0:b0:363:dec8:fedd with SMTP id z9-20020a92d6c9000000b00363dec8feddmr2458749ilp.12.1707501648980;
        Fri, 09 Feb 2024 10:00:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUqTJ/AvYob1YGJIkPFFnbJSol62E5jK8DLlHBvkHgShAo6XP0ctsRuUoesVlHBjb6e4e0aleLFOqwvNApbP7bEkl55EiBjbpWCd+hpcV9lQoQnJ84HC9cx74g/N0/GjpjaNjz3uNAGUHah07yVF3y5X9//E65OBmk0/fTxkznB9KJC8x0A4z/XArB1QQvXa2r0QnAWci5TI3lS3Etr+3VRzwBNL8bNUbhX2l2vd5CHFykn+xLxcYY3srpcvzslAjWTfa/1R0jhGdGZfKOFp/cZku8AijaF+QWImVPUnlqkFT0ZvTa7YqV3xJmeR/n5z1SUBuPdiPPyI1Q6dqRjfkqQg2vAPURr+mKZvlbjAXD0r1rwntYjy+RZOh8cpcI5o0gH3Gpo6aT8J8P6WmIpmBJSE2iRxWHiQGIg9+V6QALh9JiT726dFcVG2t/S06EL/l8bP67i6WRGXZQGrFnp6CIbi64bgeyVkq4Go+U9pi6WEpQD9lLaGugXmvrjT1ndcwWM3UEhrw7TU6VCWJythFdKMhxVomh/tPHyeOn/1EdyKqnXInkRYsv8MlI77/qpepBaEMwDAHA8C288wh6wIi6aAlDaosIBqSfmo97WvVKfrmgLFShUYpqsjWM9NovkKVKW+kHVRLGZ7Shvlv6duNG0fpOpnmTuv3Gat/fFDmzfg6IvCAHESrzoJWxUecrejb0J58G15ceEp2mP9nTyvI2j711FTLKYdLyYWjRB33Fv77lPo6u56A45ZtK4QrFKCIYWXZJfzyKDqhzjoeevuoVYrZQTVCGMYJlxAVGQGpOiUdTGEjKMFEAs
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id z9-20020a023449000000b00473535d00absm108437jaz.16.2024.02.09.10.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 10:00:47 -0800 (PST)
Date: Fri, 9 Feb 2024 11:00:44 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 Yishai Hadas <yishaih@nvidia.com>, "mst@redhat.com" <mst@redhat.com>,
 "shameerali.kolothum.thodi@huawei.com"
 <shameerali.kolothum.thodi@huawei.com>, "clg@redhat.com" <clg@redhat.com>,
 "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "K V P,
 Satyanarayana" <satyanarayana.k.v.p@intel.com>, "eric.auger@redhat.com"
 <eric.auger@redhat.com>, "brett.creeley@amd.com" <brett.creeley@amd.com>,
 "horms@kernel.org" <horms@kernel.org>, Rahul Rameshbabu
 <rrameshbabu@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
 <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj
 Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v17 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Message-ID: <20240209110044.0cb6707d.alex.williamson@redhat.com>
In-Reply-To: <20240209171903.GQ10476@nvidia.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
	<20240205230123.18981-4-ankita@nvidia.com>
	<BN9PR11MB527666B48A975B7F4304837C8C442@BN9PR11MB5276.namprd11.prod.outlook.com>
	<SA1PR12MB71996EBCA4142458E8BEE367B04B2@SA1PR12MB7199.namprd12.prod.outlook.com>
	<20240209085531.73f25a98.alex.williamson@redhat.com>
	<20240209171903.GQ10476@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 Feb 2024 13:19:03 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Feb 09, 2024 at 08:55:31AM -0700, Alex Williamson wrote:
> > I think Kevin's point is also relative to this latter scenario, in the
> > L1 instance of the nvgrace-gpu driver the mmap of the usemem BAR is
> > cachable, but in the L2 instance of the driver where we only use the
> > vfio-pci-core ops nothing maintains that cachable mapping.  Is that a
> > problem?  An uncached mapping on top of a cachable mapping is often
> > prone to problems.    
> 
> On these CPUs the ARM architecture won't permit it, the L0 level
> blocks uncachable using FWB and page table attributes. The VM, no
> matter what it does, cannot make the cachable memory uncachable.

Great, thanks,

Alex


