Return-Path: <kvm+bounces-52929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95326B0AA8E
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 21:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3004A1AA5090
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 19:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35EC02E88AB;
	Fri, 18 Jul 2025 19:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U4OPixDo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8A62E7BB5
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 19:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752865853; cv=none; b=omP5bt2N9Kv7y5ikaGQ9t///6Dnp0DFG+0H8zD67jc4b3Cgi8G+/TC+1rOVU9gk6+xVod7GwWhl7lZ9cQaHvoH60Yr2lO9lAXS8rj9qrNf7wphzgundTmIKmJFPoyjdFSM1/hAAon/0H6FUd4iGLXESNjGICZCl8RLh3v/lMfn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752865853; c=relaxed/simple;
	bh=12HnDqMeVgttmuY8covfcXjk4vazl0YNAz1/AvqhAPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fj7lO+cdUQTelqTE0Y1XtkOIqCaMNVIS29Lm+4Upd6xPdIw3FDHoRMK3R6JWKalrlti3zEFUVHoA50W8OngThOGEHbFDmRWOBblYXC6FTq3rSLsI3XbQQCkgryfLtTaZJyGMKrmGn2iOMaoxlgWw3VyBINWE7iX9McO4yEspdr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U4OPixDo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752865850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V8D+e9uBJDRczJqfQeOvVP8ReNAlQCGSx/AVjBJK5K4=;
	b=U4OPixDo99XEoKetVRKVG2YJam5jUsmiV4prbphLgxV1pRllsMd+TNXxPM5BBiQ9T1o9mX
	jKvKvq5DYc9H4o7N/NMc6/fgYn3PWhwUihypOv2qdbFkoCcr/mQkt7w7yCXVaeeZmjMCYC
	7/W0PK1O3SJGFGlJAadqnrMvj92OqN4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-CZl-Mn3RPUazgXhPmQfxZg-1; Fri, 18 Jul 2025 15:10:49 -0400
X-MC-Unique: CZl-Mn3RPUazgXhPmQfxZg-1
X-Mimecast-MFC-AGG-ID: CZl-Mn3RPUazgXhPmQfxZg_1752865848
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-313fb0ec33bso2520189a91.2
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 12:10:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752865848; x=1753470648;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V8D+e9uBJDRczJqfQeOvVP8ReNAlQCGSx/AVjBJK5K4=;
        b=uTkGvPo3JxT/+Hf1kTyaTiJeGmVaD2RiyCkz069QIW+eQrKrju3HFP9SfXW8DAay6T
         PZe+Hr6Gc0thhRQ90YXD4KM38QkTX/47D+8qfRcb1Gbtgbc61VmJsOoSPqmuLvAzbrTs
         bTsfPMXQMLFmFMdFrNoX1dHj5/Ba4SB4GkmuLIoPo/3uxHdtq7rYwO7qwImJYr+Lt0I4
         GBH1uIiOx48dIhtRT8YHgUI8btygBG+1cQbNc+++Ngg+q5OyGDj8XxGHc/C8hUMa0eSE
         AZf3pcDcJUAMOR97OLfRlVag/dU0nFOeyAsfyvRXBg/8OI6jQGRQ/OxTXwvQQ7dRv+Qi
         IoFA==
X-Forwarded-Encrypted: i=1; AJvYcCUcV9dYffXS5AjvFl2853iGTkRWn+Nw2AddS+m3WVsNISxPZX3W9jpVEOKhFSAU2mqnJ8c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoyXPt2AbSNr5NVh0SKfTqC7X6YqPCLu5W0m8L189XkLGJy6MC
	9wanYEA+ETxRvi0RpdLzq0SO1ncuEhl2HmhyZmX6zZILbZPsTXBweMZ1nf4mrCm3VUjLwnCKgIq
	RNm59kwrMQ+Vl9IoCmmrvFia09Tvapbe9X8MmdtvoP2xCwI0WgCgBNQ==
X-Gm-Gg: ASbGncu2T+k4xRiyCWu3bg8kuZ0RUj5pxpuKoFYLRdspY722uNRAoO/Tqv/UjPheaeW
	u8wR3qeaUC4CkGbu6Z8fHgiai8im3MvouddsBKu07rml+Pcq3WSsmAh4f/7vG4ONf2iUhuEKvxu
	s9+6+L5LL5xU+n2mRoeWIVEyGT4bWEuTIrGvizzvJv8KAayWjcniP9aL3Y9SFFv798pTj9txUmq
	PCx5vQrIa++oSkUPDQptd3JewVeIIXqov5b7SFJZn7/QlmIYhcI5bhUVdKC+Tzphe3CcxAacgSz
	Pyv8KOEu1fPs89IlrV14lFMUjsFvTzjf5ftpNKq5
X-Received: by 2002:a17:90b:6ce:b0:311:b5ac:6f6b with SMTP id 98e67ed59e1d1-31cc253d5c7mr6000473a91.9.1752865848244;
        Fri, 18 Jul 2025 12:10:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIqj9LP2vHBGP1tqCvOrWc8j8Q/BDtDPfNNbouKYvr5XMtLMkhhPcn26wkmN3ctBxthZr59g==
X-Received: by 2002:a17:90b:6ce:b0:311:b5ac:6f6b with SMTP id 98e67ed59e1d1-31cc253d5c7mr6000449a91.9.1752865847822;
        Fri, 18 Jul 2025 12:10:47 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c9f1e6a68sm5667046a91.19.2025.07.18.12.10.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 12:10:47 -0700 (PDT)
Message-ID: <519d8178-4cec-44c2-8b24-cc9ae9dbd221@redhat.com>
Date: Fri, 18 Jul 2025 15:10:42 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/16] PCI: Add pci_reachable_set()
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
References: <5-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <3bf0f555-535d-4e47-8ff1-f31b561a188c@redhat.com>
 <20250718174921.GA2393667@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250718174921.GA2393667@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/18/25 1:49 PM, Jason Gunthorpe wrote:
> On Thu, Jul 17, 2025 at 06:04:04PM -0400, Donald Dutile wrote:
>>> Implement pci_reachable_set() to efficiently compute a set of devices on
>>> the same bus that are "reachable" from a starting device. The meaning of
>>> reachability is defined by the caller through a callback function.
>>>
>> This comment made me review get_pci_alias_group(), which states in its description:
>> * Look for aliases to or from the given device for existing groups. DMA
>>   * aliases are only supported on the same bus, therefore the search
>>   * space is quite small
>>
>> So why does it do the for loop:
>>    for_each_pci_dev(tmp) {
>>
>> vs getting the pdev->bus->devices -- list of devices on that bus, and only
>> scan that smaller list, vs all pci devices on the system?
> 
> Because it can't access the required lock pci_bus_sem to use that
> list.
ah, i see; it's only declared in drivers/pci/search.c, and it isn't
a semaphone in a per-bus struct. :-/
... so move the function to search.c ? /me runs...
I know, not worth the churn; already have 'polluted' iommu w/pci, but not vice-versa.
(although iommu-groups is really a bus-op (would be a different op, for say, platform devices going through another iommu).

> 
> The lock is only available within the PCI core itself which is why I
> moved a few functions over there so they can use the lock.
> 
>> Could we move this to just before patch 11 where it is used?
> 
> Yes
> 
>> or could this be used to improve get_pci_alias_group() and get_pci_function_alias_group() ?
> 
> IMHO it is not really worth the churn
> 
Hey, your churning at the moment, so I figured you may want to churn some more! ;-)
just a comment/suggestion; not required.

> Jason
> 


