Return-Path: <kvm+bounces-26094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CB46970CA3
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 06:13:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 28A71B21B73
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 04:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C24D01ACE0F;
	Mon,  9 Sep 2024 04:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="coV+awG6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2D91DA26
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 04:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725855203; cv=none; b=LUHzuD2ftAardX5AVXaiz5Li9aF4TaO+F7LuokXZOro0xikrHRvn6lS5NMrks4LSuSId+XLKlkOAmTYD5j6DpURwcz+/thrJsMh7SvGjOXkDtuuZ1c+mTO30qjDg6oTrVaDQ7sm6P+ysnHoWX/RAvkfKl2oOk6HN5P1OywhVq3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725855203; c=relaxed/simple;
	bh=8LirZ0HmrIsAJ3anUuOVRBCsmWxH2T4HZt4fknhF9Ic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lGvq3ffefe1i6j4RbyI5y0WSgyq2JCPP7jWsAIJnmPez8jD2lYXVbF4U/f3/RWPX/GVgAFfVSki+rxI135L4Ju6NM6d+gCeBF8z1vzvyYJhTYI9O3l/EZmLn3Bt3yzYyD3nYGaIM93SKtqOVphFYG50+tG+6XRYI4PUNX2jf0kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=coV+awG6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725855201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qWJH4JtiF+rIHPnRLC4WN/TNvZ/uRdMkrGB+YOGo0Hs=;
	b=coV+awG6bEEE/VyNqYoBjwEPyibButpiC2E4vv4CoZPiAQFhTDwU6eIq0YlCa7NYJ4saUu
	yLcCgE3IB6r2yIz+5CuceqIFd8IAOT9mcsaibHbxgUvnTHKyDHIuFShbAIPUoX6RHjWNFr
	w/EaZ+TiF+NnEnwK8KVec337gpQhVnM=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-kwqUIlyANLuvNjHLByjwYQ-1; Mon, 09 Sep 2024 00:13:18 -0400
X-MC-Unique: kwqUIlyANLuvNjHLByjwYQ-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-718f200ae10so1643393b3a.2
        for <kvm@vger.kernel.org>; Sun, 08 Sep 2024 21:13:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725855198; x=1726459998;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qWJH4JtiF+rIHPnRLC4WN/TNvZ/uRdMkrGB+YOGo0Hs=;
        b=oX37w1fiPET28yHIC/0atU4u+Wml8YSRrHlIBG+X5OI4Ra10nKLBQrE/RpACud8Mtn
         l9O+HF15NCcKVhaUVzP7lCzJFrppeHULfIkyvHJSiK9R6OMt8KUGxiBQovOFjGJmgjP7
         IfSNgBuS9yslAFmqm3hJsG64UGMTRSTT+4Y7WPCGt9oCNe6yg6GXFbAkOo1U88XsYKIs
         p28YhE4ck3SmArQW0ZhRwqT2jTr/dTj0kK4XFc1Knsxiwu8r40Vdntysvp64lsT0/6/C
         Mzc9LF4YdW+t32fITUuTMfuKbzlh/k4wVLpcpK3r/8e8gtdNFr6nmpVspXbq4CCeodOt
         Fx9A==
X-Forwarded-Encrypted: i=1; AJvYcCUHVXNpz3QprAgw/6Wej+gFELo/n3PxnzxX3s/AcVOc+RTI4+88QGDlum0pDmzBxnxPmdg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBDjQBaL7zoLLfywedVJrSdm+cY4WNe90AS7ntALejuc1KNCoG
	feCvAC/Ewu7OJW8kioYUjtrF5u4drcClUmEeok0WFHetksGqq5l106CcOsn3N+BgnowlqZGoEz/
	uk/CRnd9SNhQxPWT65pVZK7oodV6wE4JKVsGgqADXJAKUvqJMRA==
X-Received: by 2002:a05:6a20:d49b:b0:1cf:3b22:feca with SMTP id adf61e73a8af0-1cf3b230136mr3918244637.15.1725855197881;
        Sun, 08 Sep 2024 21:13:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnUKDaM2E6KNKbxP6Avir+4/JCbohvZZf9a+5rUYwTHzqD3kkO8haVPQRh64vM65/fXpKKbA==
X-Received: by 2002:a05:6a20:d49b:b0:1cf:3b22:feca with SMTP id adf61e73a8af0-1cf3b230136mr3918188637.15.1725855197215;
        Sun, 08 Sep 2024 21:13:17 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d823cf3b1fsm2543061a12.33.2024.09.08.21.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Sep 2024 21:13:16 -0700 (PDT)
Message-ID: <3aea7984-6e84-4bc5-9cd6-55b2a45d71c0@redhat.com>
Date: Mon, 9 Sep 2024 14:13:06 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 19/19] virt: arm-cca-guest: TSM_REPORT support for
 realms
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, Sami Mujawar <sami.mujawar@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-20-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240819131924.372366-20-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 11:19 PM, Steven Price wrote:
> From: Sami Mujawar <sami.mujawar@arm.com>
> 
> Introduce an arm-cca-guest driver that registers with
> the configfs-tsm module to provide user interfaces for
> retrieving an attestation token.
> 
> When a new report is requested the arm-cca-guest driver
> invokes the appropriate RSI interfaces to query an
> attestation token.
> 
> The steps to retrieve an attestation token are as follows:
>    1. Mount the configfs filesystem if not already mounted
>       mount -t configfs none /sys/kernel/config
>    2. Generate an attestation token
>       report=/sys/kernel/config/tsm/report/report0
>       mkdir $report
>       dd if=/dev/urandom bs=64 count=1 > $report/inblob
>       hexdump -C $report/outblob
>       rmdir $report
> 
> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v3: Minor improvements to comments and adapt to the renaming of
> GRANULE_SIZE to RSI_GRANULE_SIZE.
> ---
>   drivers/virt/coco/Kconfig                     |   2 +
>   drivers/virt/coco/Makefile                    |   1 +
>   drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>   drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>   .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211 ++++++++++++++++++
>   5 files changed, 227 insertions(+)
>   create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>   create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>   create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
> 

[...]

> +
> +/**
> + * arm_cca_report_new - Generate a new attestation token.
> + *
> + * @report: pointer to the TSM report context information.
> + * @data:  pointer to the context specific data for this module.
> + *
> + * Initialise the attestation token generation using the challenge data
> + * passed in the TSM decriptor. Allocate memory for the attestation token
                         ^^^^^^^^^

Typo. s/decriptor/descriptor as reported by './scripts/checkpatch.pl --codespell'


> + * and schedule calls to retrieve the attestation token on the same CPU
> + * on which the attestation token generation was initialised.
> + *
> + * The challenge data must be at least 32 bytes and no more than 64 bytes. If
> + * less than 64 bytes are provided it will be zero padded to 64 bytes.
> + *
> + * Return:
> + * * %0        - Attestation token generated successfully.
> + * * %-EINVAL  - A parameter was not valid.
> + * * %-ENOMEM  - Out of memory.
> + * * %-EFAULT  - Failed to get IPA for memory page(s).
> + * * A negative status code as returned by smp_call_function_single().
> + */

Thanks,
Gavin


