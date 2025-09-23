Return-Path: <kvm+bounces-58442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A2ECB94091
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 04:42:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB1D318A717A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 02:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D88A5273D8A;
	Tue, 23 Sep 2025 02:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IjLsk/tI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB8526E6F3
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 02:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758595365; cv=none; b=MBULVYBy3k0Sl3q8GiB7r2JG8+Y+LdTnN25Ln7iUCqWAVzgZkv2k27SG4+gzX3BTltF5IcnwhA7mYcAn5xOtWbHlSAMsotl959SxBE6KPsSkTECyI0/MunIMwTGLTXobKMNNNo3XzbaDqhT6tmUqMq1qVcoLhzM9mY57t5RK9Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758595365; c=relaxed/simple;
	bh=U8BfRIfWRxGPkTZ8ZlsPBJ0ty1yw0P2zFNdvUm5eF80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G3v63nVSoDt7+ziwh2YHV+pGBtaJ2u+HVT+Ifh/11B7NFq4azJDILGCmlvMJy/PRhlIwxnvex5tgsC5mPQ9S0bCs+3YmF33V9roi70hHpyGjnDUoRyw00h81Wsl81NkzDuO78ET0+4AUnyPqXxGjkWQTLEsaplBsNU0BgVOfim8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IjLsk/tI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758595362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ovRbpMfovzcRmf0L4bDDYQZTgg4Svx+RqRpiV3ItuuI=;
	b=IjLsk/tI6cAqcKH4E4HECvlScD9Y3y6zR7kONlVcrh6BoFikfekF/WwKpLVkZitOAUn5cS
	QY52KKAoGTi7snDGpbP2e2k4fj/uUqx67ZBGuES+kGaYX2D7RQ8lfWpZlXa1Vq8/05dmXt
	pf+bhzaS7TkXIH/ATAk4IAH52NUqW3A=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-x5VkiKLbNUWNQX2x8-ibIg-1; Mon, 22 Sep 2025 22:42:40 -0400
X-MC-Unique: x5VkiKLbNUWNQX2x8-ibIg-1
X-Mimecast-MFC-AGG-ID: x5VkiKLbNUWNQX2x8-ibIg_1758595360
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-828bd08624aso1048592885a.1
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 19:42:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758595360; x=1759200160;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ovRbpMfovzcRmf0L4bDDYQZTgg4Svx+RqRpiV3ItuuI=;
        b=sjzdNjcHIdtwS8/YuMTpIt+jSWiv8K+3VxpLlqZ1PcRt5Lb8SgVkiHp1C0HntOmiA9
         E5hI8nm372KFUyjkaSfPFqbPpD7VFPuVjJ8fj7SkfJNCb9Ve83rfzEVQq+uI4AS4+ZLq
         Wz0yvq2ncpK0rar8+Lrn4AdkovY2ZtJws9nq1XsQnnL1Uot+/2+GtEgbiPOW7wnpfjyV
         IKkn8VV6m04CGh8RnZKd+9/0CWOnh0UjUFb64KtJ2+dt0YJ/bc+74GVlysLdWpV0kwBZ
         S8gkFmKF83YUHxu9ORpgkPkqw0ejtamsQvg+7zBCXuKTvHyCRpdeLPAPakYQ/X4cixZ1
         Dgvg==
X-Forwarded-Encrypted: i=1; AJvYcCXhrcgphDpPs5Qkp1FATVy/iMbEaDUI5Fq+1o8zpn+eS1ZLXJ9QcCIr1ysz3P6kAZkareM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6TSmrLaiNccp3zPvtiaVe60sj0xogJmFGLerZ9WqoTvnmWQBO
	2SOEZxR/75k8lnAt3QU7LA0EDe/PG5+q+TXOD5yMQyzXP7XCmK6WWk6P0adu0+pEAVu9sZQCphm
	KkQJrpGBJarZWgxa3HdCxcn5GzqJrQnwz732i8SxVKa8slJ4O+FxPMw==
X-Gm-Gg: ASbGncuG6J/tYvvZXPwVL+gQ8631NRIawnRlJp2f0t/OU+lzPGjNuvsBs6aAtZsq3ar
	G+Pjvq0Wtc3h1stCOVcLUW3ZZC0k5dWqPjJ2FX6NDSl+C/mUlZIOhZpMnWkAPd3qjXzJabp4h1/
	Y2Y4iCTOYjxwgZJdYSg4IndXoL+lpnTnvNG6g/rd32aV11LR5YKrWEepnL1isgupZ/yetUj1cqY
	kEdT5s54Zlh3rHz58GGRqbiBCjqxkxoBGhaMTS45kdAwz5J+T07Uvc9MAe0Jqbcx+tOIPHj0qOL
	wcjmZEfPU7URJiWqHmtIooxRaiemXDpdA0hHRS9Y
X-Received: by 2002:a05:620a:1912:b0:811:33d6:1aca with SMTP id af79cd13be357-851691163acmr151324785a.1.1758595360127;
        Mon, 22 Sep 2025 19:42:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHx86NaRHJS5fRx0oc5vlKW3pGIJTq3UlFlPY31i7XkkxTNEwNFeSs9bG+4eASgNFJ24f848A==
X-Received: by 2002:a05:620a:1912:b0:811:33d6:1aca with SMTP id af79cd13be357-851691163acmr151323285a.1.1758595359707;
        Mon, 22 Sep 2025 19:42:39 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-852847b70f4sm19413785a.15.2025.09.22.19.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 19:42:39 -0700 (PDT)
Message-ID: <0eb2e721-8b9c-40d0-afe7-c81c6b765f49@redhat.com>
Date: Mon, 22 Sep 2025 22:42:37 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/11] Fix incorrect iommu_groups with PCIe ACS
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 galshalom@nvidia.com, Joerg Roedel <jroedel@suse.de>,
 Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, maorg@nvidia.com,
 patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <20250922163947.5a8304d4.alex.williamson@redhat.com>
 <e9d4f76a-5355-4068-a322-a6d5c081e406@redhat.com>
 <20250922200654.1d4ff8b8.alex.williamson@redhat.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250922200654.1d4ff8b8.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/22/25 10:06 PM, Alex Williamson wrote:
> On Mon, 22 Sep 2025 21:44:27 -0400
> Donald Dutile <ddutile@redhat.com> wrote:
> 
>> On 9/22/25 6:39 PM, Alex Williamson wrote:
>>> On Fri,  5 Sep 2025 15:06:15 -0300
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>    
>>>> The series patches have extensive descriptions as to the problem and
>>>> solution, but in short the ACS flags are not analyzed according to the
>>>> spec to form the iommu_groups that VFIO is expecting for security.
>>>>
>>>> ACS is an egress control only. For a path the ACS flags on each hop only
>>>> effect what other devices the TLP is allowed to reach. It does not prevent
>>>> other devices from reaching into this path.
>>>>
>>>> For VFIO if device A is permitted to access device B's MMIO then A and B
>>>> must be grouped together. This says that even if a path has isolating ACS
>>>> flags on each hop, off-path devices with non-isolating ACS can still reach
>>>> into that path and must be grouped gother.
>>>>
>>>> For switches, a PCIe topology like:
>>>>
>>>>                                  -- DSP 02:00.0 -> End Point A
>>>>    Root 00:00.0 -> USP 01:00.0 --|
>>>>                                  -- DSP 02:03.0 -> End Point B
>>>>
>>>> Will generate unique single device groups for every device even if ACS is
>>>> not enabled on the two DSP ports. It should at least group A/B together
>>>> because no ACS means A can reach the MMIO of B. This is a serious failure
>>>> for the VFIO security model.
>>>>
>>>> For multi-function-devices, a PCIe topology like:
>>>>
>>>>                     -- MFD 00:1f.0 ACS not supported
>>>>     Root 00:00.00 --|- MFD 00:1f.2 ACS not supported
>>>>                     |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS
>>>>
>>>> Will group [1f.0, 1f.2] and 1f.6 gets a single device group. However from
>>>> a spec perspective each device should get its own group, because ACS not
>>>> supported can assume no loopback is possible by spec.
>>>
>>> I just dug through the thread with Don that I think tries to justify
>>> this, but I have a lot of concerns about this.  I think the "must be
>>> implemented by Functions that support peer-to-peer traffic with other
>>> Functions" language is specifying that IF the device implements an ACS
>>> capability AND does not implement the specific ACS P2P flag being
>>> described, then and only then can we assume that form of P2P is not
>>> supported.  OTOH, we cannot assume anything regarding internal P2P of an
>>> MFD that does not implement an ACS capability at all.
>>>    
>> The first, non-IF'd, non-AND'd req in PCIe spec 7.0, section 6.12.1.2 is:
>> "ACS P2P Request Redirect: must be implemented by Functions that
>> support peer-to-peer traffic with other Functions. This includes
>> SR-IOV Virtual Functions (VFs)." There is not further statement about
>> control of peer-to-peer traffic, just the ability to do so, or not.
>>
>> Note: ACS P2P Request Redirect.
>>
>> Later in that section it says:
>> ACS P2P Completion Redirect: must be implemented by Functions that
>> implement ACS P2P Request Redirect.
>>
>> That can be read as an 'IF Request-Redirect is implemented, than ACS
>> Completion Request must be implemented. IOW, the Completion Direct
>> control is required if Request Redirect is implemented, and not
>> necessary if Request Redirect is omitted.
>>
>> If ACS P2P Require Redirect isn't implemented, than per the first
>> requirement for MFDs, the PCIe device does not support peer-to-peer
>> traffic amongst its function or virtual functions.
>>
>> It goes on...
>> ACS Direct Translated P2P: must be implemented if the Function
>> supports Address Translation Services (ATS) and also peer-to-peer
>> traffic with other Functions.
>>
>> If an MFD does not do peer-to-peer, and P2P Request Redirect would be
>> implemented if it did, than this ACS control does not have to be
>> implemented either.
>>
>> Egress control structures are either optional or dependent on Request
>> Redirect &/or Direct Translated P2P control, which have been
>> addressed above as not needed if on peer-to-peer btwn functions in an
>> MFD (and their VFs).
>>
>>
>> Now, if previous PCIe spec versions (which I didn't read & re-read &
>> re-read like the 6.12 section of PCIe spec 7.0) had more IF and ANDs,
>> than that could be cause for less than clear specmanship enabling
>> vendors of MFDs to yield a non-PCIe-7.0 conformant MFD wrt ACS
>> structures. I searched section 6.12.1.2 for if/IF and AND/and, and
>> did not yield any conditions not stated above.
> 
> Back up to 6.12.1:
> 
>    ACS functionality is reported and managed via ACS Extended Capability
>    structures. PCI Express components are permitted to implement ACS
>    Extended Capability structures in some, none, or all of their
>    applicable Functions. The extent of what is implemented is
>    communicated through capability bits in each ACS Extended Capability
>    structure. A given Function with an ACS Extended Capability structure
>    may be required or forbidden to implement certain capabilities,
>    depending upon the specific type of the Function and whether it is
>    part of a Multi-Function Device.
> 
Right, depending on type of function or part of MFD.
Maybe I mis-understood your point, or vice-versa:
section 6.12.1.2 is for MFDs, and I was only discussing MFD ACS structs.
I did not mean to imply the sections I was quoting was for anything but an MFD.

> What you're quoting are the requirements for the individual p2p
> capabilities IF the ACS extended capability is implemented.
> 
No, I'm not.  I'm quoting 6.12.1.2, which is MFD-specific.

> Section 6.12.1.1 describing ACS for downstream ports begins:
> 
>    This section applies to Root Ports and Switch Downstream Ports that
>    implement an ACS Extended Capability structure.
> 
> Section 6.12.1.2 for SR-IOV, SIOV and MFDs begins:
> 
>    This section applies to Multi-Function Device ACS Functions, with the
>    exception of Downstream Port Functions, which are covered in the
>    preceding section.
> 
Right.  I wasn't discussing Downstream port functions.

> While not as explicit, what is a Multi-Function Device ACS Function if
> not a function of a MFD that implements ACS?
> 
I think you are inferring too much into that less-than-optimally worded section.

>>> I believe we even reached agreement with some NIC vendors in the
>>> early days of IOMMU groups that they needed to implement an "empty"
>>> ACS capability on their multifunction NICs such that they could
>>> describe in this way that internal P2P is not supported by the
>>> device.  Thanks,
>> In the early days -- gen1->gen3 (2009->2015) I could see that
>> happening. I think time (a decade) has closed those defaults to
>> less-common quirks. If 'empty ACS' is how they liked to do it back
>> than, sure. [A definition of empty ACS may be needed to fully
>> appreciate that statement, though.] If this patch series needs to
>> support an 'empty ACS' for this older case, let's add it now, or
>> follow-up with another fix.
> 
> An "empty" ACS capability is an ACS extended capability where the ACS
> capability register reads as zero, precisely to match the spec in
> indicating that the device does not support p2p.  Again, I don't see
> how time passing plays a role here.  A MFD must implement ACS to infer
> anything about internal p2p behavior.
>   
Again, I don't read the 'must' in the spec.
Although I'll agree that your definition of an empty ACS makes it unambiguous.

>> In summary, I still haven't found the IF and AND you refer to in
>> section 6.12.1.2 for MFDs, so if you want to quote those sections I
>> mis-read, or mis-interpreted their (subtle?) existence, than I'm not
>> immovable on the spec interpretation.
> 
> As above, I think it's covered by 6.12.1 and the introductory sentence
> of 6.12.1.2 defining the requirements for ACS functions.  Thanks,
> 
6.12.1 is not specific enough about what MFDs must or must not support;
it's a broad description of ACS in different PCIe functions.
As for 6.12.1.2, I stand by the statement that ACS P2P Request Redirect
must be implemented if peer-to-peer is implemented in an MFD.
It's not inferred, it's not unambiguous.
You are intepreting the first sentence in 6.12.1.2 as indirectly saying
that the reqs only apply to an MFD with ACS.  The title of the section is:
"ACS Functions in SR-IOV, SIOV, and Multi-Function Devices"  not
ACS requirements for ACS-controlled SR-IOV, SIOV, and Multi-Function Devices",
in which case, I could agree with the interpretation you gave of that first sentence.

I think it's time to reach out to the PCI-SIG, and the authors of this section
to dissect these interpretations and get some clarity.

- Don

> Alex
> 


