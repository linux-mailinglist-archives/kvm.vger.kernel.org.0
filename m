Return-Path: <kvm+bounces-57134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 178E4B506A4
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 21:58:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A66B0547530
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 19:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A163B352FD0;
	Tue,  9 Sep 2025 19:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SHnwjKiq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E610225415
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 19:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757447902; cv=none; b=IpjixGyPxFJrIaFba068fWQwK4d1gfRhI5JoW9Ic8XaQUXfmQ3y2giL+G3go5OJqpHlwAPYuk6YOxCjAy/v/lqWZ1C/gPksZ7jV2aHOLvbA86A33yzYW9DienNnER+uUFr+qCK++/p+OWGwmIH+VXRh8W9clz0QifO47/djPsAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757447902; c=relaxed/simple;
	bh=9kyPH/7+wdW7kBbHqGG+Ud1ODCMJF98xQA/Qhwi4KzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h1/LGjx6jqEJY7hm4UHx/ifpHNf7K1KkDxGTbr1Al0Sf9mofseNQnlN70m2vZLaGcMsWZYJY++uzn7k6oo7+k61Il1cgknTz8xCl9YQlY/l+YxkAVEzZnU6wRv+MZybS68hlnvnvuhlj3SxjVQzqK7eXulX4ZIIGTeEngITj8nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SHnwjKiq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757447900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LgCo6nYdRNSIrE5RFL1DFAnJKWKeGruM3UAqjFfXFW8=;
	b=SHnwjKiq84apbNKgH0ANyzPMVsORQMCt//AiXMFh6bhq5SUrLLBv/cf4s6eBihbA1lGu1g
	r3uros7D2NTd5ymffSQTsMgE8kFKYXN4TX0W7gt4YLSFeuzvkVCgAbZXwQyFDrQrMaJ0QI
	vjzmkZ1TNFaEXHPfyx4kjbL0ntZQllM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-aQjo8FfNOKiv4umGZZrneQ-1; Tue, 09 Sep 2025 15:58:18 -0400
X-MC-Unique: aQjo8FfNOKiv4umGZZrneQ-1
X-Mimecast-MFC-AGG-ID: aQjo8FfNOKiv4umGZZrneQ_1757447898
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-81312a26ea3so1072453885a.0
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 12:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757447898; x=1758052698;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LgCo6nYdRNSIrE5RFL1DFAnJKWKeGruM3UAqjFfXFW8=;
        b=JQS92GL/4Qs+3dBlzfwcsqgX3xM+jj+YjDcwBWQcPtQTHWP+OEqxDgcNJl0c3nFXZe
         XLz2q8UvmAQQoWhVw28cVnBk/COvFdhPNmXXMfqn4EyGw3jqrsRoZJLoA8VEPIQXaLCB
         cdVyMGgHaYKJ2+gLUc3sBm1c1pMXP512ka1GbmfzDx4rFZqCdWgAOxhyT+2sO58FtsHM
         V7elbYnyLwUaX71uQ+WpBPCQB8EZ8C3b1c35gSVXYkKv1zXk3k3Ak5vq2g+xohFNGMn4
         Dpk3JbXgphOf0GBM+AJoI707Bg035p17TK6su40a7tIwlhX5H2LuxklZR2NOUQDvv9JU
         R/Ag==
X-Forwarded-Encrypted: i=1; AJvYcCXtYJ5TTiYswufjUiBbB3KfqRnrzLLUoYCVjdlYC2wtyDT7uXA7bpGkrjXj9/PZ5VKVutU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyqwtFXUJwkJee15yqViKyowi/d8/AeMKLMuuzFhn4ydgx9X+z
	rWfg4RXOYE4dEAnOCnpuAGVNz+4rfM96lHhtr2GafGb8/17iH2EGRjXIjeaP4JYdEA08C/7VpoD
	ydYSw9/ezZCbYB9BWTJQBQePHoxwTdUKF8lvXclkoqsgxNGjOtfu77w==
X-Gm-Gg: ASbGncvAyJbWy55opEsM/6izm70PGgwKosNW8Mg73cd+Pxl/HcmUhOwykfE85lIk5FE
	KMgvi1PNrZF4um7p7q3pTkd+exvjRffLUtHK1wcLhkEzStQdpBJj4eCarkFxL473AckBFKizp0Z
	5sgaQtRmiBVyGaCFKLixUpn0lw9/wUJiF5yhffQLy5I2JgzFOrFcC0k4G2gAxSSQw4l0mVH0WPI
	c0Dvhi37093BNzk/PtlEOSxIYZzgt+6se9ZbUO3Tmim1WRGhBm3/fYFqyFC0C8PEzEhZc8UJjlC
	5VHlKqD414yYZwf6r64vHiZ7P/AlhM4m7Dj4M13k
X-Received: by 2002:a05:620a:29d0:b0:813:8842:93c3 with SMTP id af79cd13be357-813c568dadamr1292511185a.81.1757447898341;
        Tue, 09 Sep 2025 12:58:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDoXxrFaCmJ/Gj+lCNKoCToXRUvhVa9mV8loJbiqez27cqgvzNF+qndJRohMfDl/gHnjbl+w==
X-Received: by 2002:a05:620a:29d0:b0:813:8842:93c3 with SMTP id af79cd13be357-813c568dadamr1292508485a.81.1757447897982;
        Tue, 09 Sep 2025 12:58:17 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-81b58c54d9asm170295485a.1.2025.09.09.12.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 12:58:17 -0700 (PDT)
Message-ID: <819b6482-eb2c-4e2e-bf74-3396326aef5c@redhat.com>
Date: Tue, 9 Sep 2025 15:58:15 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/11] iommu: Validate that pci_for_each_dma_alias()
 matches the groups
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <7-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <9487fde9-ec40-4383-aafe-7ae0811830f5@redhat.com>
 <20250909153511.GM789684@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250909153511.GM789684@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/9/25 11:35 AM, Jason Gunthorpe wrote:
> On Tue, Sep 09, 2025 at 01:00:08AM -0400, Donald Dutile wrote:
>>
>>
>> On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
>>> Directly check that the devices touched by pci_for_each_dma_alias() match
>>> the groups that were built by pci_device_group(). This helps validate that
>> Do they have to match, as in equal, or be included ?
> 
> All aliases have to be in the same group, or have no group discovered yet.
> 
I guess I'm not asking correctly, as I think you agreed, but I'm looking for a clearer statement.
You said 'in' the same group; that's not 'equal', or what I think of as a 'match' of the pci_device_group() & dma-alias.

So, is it in equality/match, or inclusion/inclusive check; if the later, just tweak the verbage.

> Jason
> 


