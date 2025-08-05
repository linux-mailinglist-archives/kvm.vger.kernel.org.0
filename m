Return-Path: <kvm+bounces-53956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F38FBB1ACDA
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 05:43:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D4B86207D8
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 03:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6E641E834E;
	Tue,  5 Aug 2025 03:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhFoVy1Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483481DD525;
	Tue,  5 Aug 2025 03:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754365418; cv=none; b=Mj8bIDqsGsXynxklj/QrPsFN7117mAe92/B3SPTqWlKBeXoxxA3Zy0/cLWAvS1p/YX8/CSv9T20mhU4azVy4cy5SAfJ7FOM//9FyRFQ1vDxZFK2vspw1EdozubMQSd4gMUs46fE4IlR7RYnVXcgYokSaRCPrKZV+clKTNMCJ4xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754365418; c=relaxed/simple;
	bh=ZniYHKY8QuSd7kXt4f9NMukHnaBfrOkk5MNpA7EfaWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kSCmo8qd5G9VKfHgr+bwHTR9Ayvha7g+SkjZzqhEkO5otn/64WSXVvBVkpCYSRP751JdqqseE8weTL6YRAGh+3u3q+tN8aMEszaav4TQQHrj2851aNACkdOuuwEElPko1as6uaq2FrgzfaDIURmOnXNKAbe2jyvKbrWuvi7x/Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fhFoVy1Q; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-af967835d0aso278938766b.0;
        Mon, 04 Aug 2025 20:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754365416; x=1754970216; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8WbAm5nExTQIfe1sqlUAgj5NdK4GQb4TTe8phjhgS70=;
        b=fhFoVy1QCqYbF30A0gmnkPPxzB/F/lQCOjIy91Dv+QhZAtnVsHMR2WETvdDRBFooVm
         GRa/jfexETV2wqh1cuOAhKdHe/CauSi308778Y6TBtu3mraVzdZtux6yRjXv6IVBAruZ
         NOez25bUSw5p+NhuoetTV+J+MRxaPf8bgUGYLKy19LJycRDH8Q0MevPxvCjxRUmOJizB
         ygwI2WmLrnIVsHy+JVZbueR+mhKAQiVPwNGBhM5CsFuOXpdwWAvNGJJPrJoO+eVzssmK
         9IpihGQ+r1uL6KsIhOJAigIvZs+To2wWcOsO6ZquGYGLNiYyWVnWUBFfNmTFl1j9tHXG
         9/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754365416; x=1754970216;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8WbAm5nExTQIfe1sqlUAgj5NdK4GQb4TTe8phjhgS70=;
        b=hDgp0f1D4nHYapAEBpcTqvYHMJ8HlQgUSfXmFfJyyr7cDpT/IdzSuteLxVl8cTu2UW
         wes3nilh8i5YiyXxQ/MIJe24n5HtbgeHVcEii52x/guUGR/AXebNWqvT4w+va8XpzxRD
         QTAp3k9uQfAXwBblP/LXUT7hzuVNiqUnCQVS0kosJdnF86/+YUNoORffb5oQq59jVaez
         3EC9qKw/NCzcEMSFZmI3wsf00ICGFzanQfbjgsRTSftIYdn6TooIUQlItQZHqYQD3OyZ
         cBMKJbvkSMnnSXyKTpjobW9HWP+E/hRSnKbmpV9yw9eCAAM4k3HEm/vA5eu1tRtawUd+
         mKKg==
X-Forwarded-Encrypted: i=1; AJvYcCU6ep5lN6y9eTNTPo8P9z+ZzCNYSvFv1z65coFkxR0Aanfr1otwe/W/AVj81yYA2Kd3cAk=@vger.kernel.org, AJvYcCXEQ4eEmAS5FT371QWYeuLpeo2UzxM7QkSYDvn3AFnvlc8fe2u/O/Eq6pEswFHAV0nIPMWS7E3Pj9x2@vger.kernel.org
X-Gm-Message-State: AOJu0YzeHbecpwKl1og/GAImilECmq6h3HheY5k1RGSwoF9ukOcagPJt
	RUVPnz9SDi2UV8ZVG7+KylUDrrwBSPz7HIi0Yyh5KYNcfYIDMi6260IB
X-Gm-Gg: ASbGncuAq9y1yUtj2VT9za4l9bxu0NWzRviDTPiOp9s8FIGVmgcl8jdTpwoCx3010oI
	H7qa0+Wi6JVSLD1uA82R7LoZ1alZ19zqCLTWOdTpyZZpeG/hijMdn13PVWD9dkfusYGHEg88u5a
	18EOOCiQKvv4Ik/Lc8jUu4ncJQ6T3KoLKu7vop1skcu09xDRT3aU3/SywkeqJ8K5F1my9lPWAVf
	3duk9U7RoDI+W22DpkheUuwJ/3oRlNmbiYICl4S79KMr1+hE1GNecel44fL/oA46XMkaXYQQRE1
	qGl1xyzHuDfXrLLorNBB5Qdl4EtlK/ljPhAvUuF2l1WuasEa0aM5qNxAtGFfZMyOOzCPJ57dQmc
	dUAs45+iomHacAPLQEBt4LD74TntVDiggo3zskhA5obLRHVU6Jz+wriQFJhbZ5Qkzz54iLKxYFh
	/jLjs7UlgepzuGbxwXEub1C8FXgLRbe02oaRg=
X-Google-Smtp-Source: AGHT+IEjmKLsdjb2ZjdT33M1Kp092lXe481aQZe89Govc26G8aNvSHe8HQJ6UUJmTxXI+6BFVbhvGw==
X-Received: by 2002:a17:907:6d04:b0:ae0:d804:236a with SMTP id a640c23a62f3a-af93ffcaddemr1330563966b.3.1754365415456;
        Mon, 04 Aug 2025 20:43:35 -0700 (PDT)
Received: from [26.26.26.1] (ec2-3-126-215-244.eu-central-1.compute.amazonaws.com. [3.126.215.244])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91ee3c1f7sm772698966b.68.2025.08.04.20.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 20:43:34 -0700 (PDT)
Message-ID: <1684792a-97d6-4383-a0d2-f342e69c91ff@gmail.com>
Date: Tue, 5 Aug 2025 11:43:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <a692448d-48b8-4af3-bf88-2cc913a145ca@gmail.com>
 <20250802151816.GC184255@nvidia.com>
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <20250802151816.GC184255@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/2/2025 11:18 PM, Jason Gunthorpe wrote:
> On Sat, Aug 02, 2025 at 09:45:08AM +0800, Ethan Zhao wrote:
>>
>>
>> On 7/9/2025 10:52 PM, Jason Gunthorpe wrote:
>>> The series patches have extensive descriptions as to the problem and
>>> solution, but in short the ACS flags are not analyzed according to the
>>> spec to form the iommu_groups that VFIO is expecting for security.
>>>
>>> ACS is an egress control only. For a path the ACS flags on each hop only
>>> effect what other devices the TLP is allowed to reach. It does not prevent
>>> other devices from reaching into this path.
> 
>> Perhaps I was a little confused here, the egress control vector on the
> 
> Linux does not support egress control vector. Enabling that is a
> different project and we would indeed need to introduce different
> logic.
My understanding, iommu has no logic yet to handle the egress control
vector configuration case, the static groups were created according to
FW DRDB tables, also not the case handled by notifiers for Hot-plug
events (BUS_NOTIFY_ADD_DEVICE etc). iommu groups need some kind of {
add, remove etc } per egress control vector configuration operation.

Thanks,
Ethan>
> Jason


