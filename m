Return-Path: <kvm+bounces-58438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CBCADB93E59
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 03:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C40C14E06A8
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 01:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F00226A0C5;
	Tue, 23 Sep 2025 01:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EHmdqUQ7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F702257842
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 01:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758591875; cv=none; b=uw19VoifRWxNXRGdNFKqu6uXkvN5mAG+JyPvcWFQ+Jy7dssij1zHAP/WZpBGkLg6pw51/udqV945Qu7IEFn3lZmWS5/LxIOX6Jvu+oJNljMxA98O2tiykYH/H/MaZscntUIFSZ+IZbtF/xr+nVkut0QBa36kYGpz+8AP2Uu5wiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758591875; c=relaxed/simple;
	bh=REeKONxzHrKHqwLFoWoVGsJJiR0Ao7sF4r5sCYsb6DI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ewuleC/ft1nsljd+ZErihQ9ixeFY9ZaoJjpkmCMVn7RTdQrMG3J1bS7SBYHqnkoCT8UrklA46Be+RiXkfCEtHQyDrXbLdzWdq1nWkm9X5p0fIoC0Dec45b5CfTAcdDNKRcwOU3hzvEQieVsstLFWjkTbq3isXRz9s+imjhGiuWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EHmdqUQ7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758591872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j5kMPJaEnWeByXWtxUQ7jMf0TquG1zkt+HOk0PWkdrU=;
	b=EHmdqUQ7StMO3wrADNsS/sma9iN8ggLmqyQYz3nLdEpTkM3He8ZSctUNN6JdU6SQR2+gWv
	hER8jVqIPHB8eMMa9Ss3tIbJJj9fCAnIyRCDhaJzNTsvOjzaxObspecTJzYansJRs+jaCX
	GCegne+z3T69REKxwNphD2wtDE53lFs=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-OabrFlXUM_KQ0camKpGLmA-1; Mon, 22 Sep 2025 21:44:30 -0400
X-MC-Unique: OabrFlXUM_KQ0camKpGLmA-1
X-Mimecast-MFC-AGG-ID: OabrFlXUM_KQ0camKpGLmA_1758591870
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4b345aff439so103244391cf.0
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 18:44:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758591870; x=1759196670;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j5kMPJaEnWeByXWtxUQ7jMf0TquG1zkt+HOk0PWkdrU=;
        b=C2YJ2J+s0sOuubLvW7gZFNTDoCbOcBXaPVTDUX1fgxAQRwtjrrfwG1s1gs2+EC0/ZF
         z8JTGLBeFnnStTDh4llG0Hjyw8uNjh2sHS5BLPdSunWeBK1e6Mp5blUpRDOeJmjO5oCR
         Enn2D46ihgqlZN+5AxL7Y5ziNkx7JjQXxbBKSfYkZGX2zo1Kep7ap3vxW7i4VHS24Uda
         RpZTHVQ264Ayo4koRX4GQiFDAc/aM6/7Kd844jtJBtpqB7S9CokKLENJB62CTaz0X78Z
         bJMG/ZTtGDl/y+HOF3ybTxV1TtA/g6DoCQZqa4DTnn4c+ppPktTVL4wGt6hlUKz9tA4n
         oGxg==
X-Forwarded-Encrypted: i=1; AJvYcCUzR3qGT8JvZdOpA/rPjMcMbH+dEmByPmnJriZlEWGpFdVek9R88MdnA5Gtt9Te+2L531k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTvyIxnSMzAhiOGOpI7Wl9Orco9N7Ychmn8up5oaoAQ4CBiFK1
	Gqr/+30dxkgBmECfmSf9HF1jiQLy+oYPbDPkWKo7Wv4iYxGfBmfqmGN+TqjKlf9St/2gEcSJYzT
	RehRKuRQtI/je/q0UiTOsLbyWUbff1mA5K3VYVv7Kf0YtNy+Yb6KoaQ==
X-Gm-Gg: ASbGncvhpelPtxALuiA014uQ736U7KpCThoq4b5aNwlHY59/cUrCMUPjO+CRAprkpy1
	naxpKo12ogqKL4w2HQiqm0B5bvCGBHuZBZS+q6PfMMtfQN8LohVB9Nmct3zvKIaWcDY6+TvFutD
	oVAkFZKF4y4SyQBDLiVtf88fprMllEDFdQZElVTeGZsNRamHvw9R/jzsB78tJ1BaYR+4ryvaTud
	z1aZ3vUn3nSzMwioPIylJ4sp7fzYovAbW3vthtEGCZ1VayozRoO7Vd164yUT5ka0CcR5qsTA3Lp
	tYx9PUHeg0+i/eFjTBkdeT2jOFfcpjOmGGC35GIf
X-Received: by 2002:a05:622a:5913:b0:4b5:d639:e111 with SMTP id d75a77b69052e-4d37265f9b0mr8460531cf.72.1758591869958;
        Mon, 22 Sep 2025 18:44:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQzA6rlo56VmUSUVIORuHzSbBuxKSgkECj4TN2He1ZYfzf9PR3v9AhQsYohVi34Jw7kJBJ8w==
X-Received: by 2002:a05:622a:5913:b0:4b5:d639:e111 with SMTP id d75a77b69052e-4d37265f9b0mr8460411cf.72.1758591869433;
        Mon, 22 Sep 2025 18:44:29 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-836317a1ba7sm916557185a.47.2025.09.22.18.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 18:44:28 -0700 (PDT)
Message-ID: <e9d4f76a-5355-4068-a322-a6d5c081e406@redhat.com>
Date: Mon, 22 Sep 2025 21:44:27 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/11] Fix incorrect iommu_groups with PCIe ACS
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <20250922163947.5a8304d4.alex.williamson@redhat.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250922163947.5a8304d4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/22/25 6:39 PM, Alex Williamson wrote:
> On Fri,  5 Sep 2025 15:06:15 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
>> The series patches have extensive descriptions as to the problem and
>> solution, but in short the ACS flags are not analyzed according to the
>> spec to form the iommu_groups that VFIO is expecting for security.
>>
>> ACS is an egress control only. For a path the ACS flags on each hop only
>> effect what other devices the TLP is allowed to reach. It does not prevent
>> other devices from reaching into this path.
>>
>> For VFIO if device A is permitted to access device B's MMIO then A and B
>> must be grouped together. This says that even if a path has isolating ACS
>> flags on each hop, off-path devices with non-isolating ACS can still reach
>> into that path and must be grouped gother.
>>
>> For switches, a PCIe topology like:
>>
>>                                 -- DSP 02:00.0 -> End Point A
>>   Root 00:00.0 -> USP 01:00.0 --|
>>                                 -- DSP 02:03.0 -> End Point B
>>
>> Will generate unique single device groups for every device even if ACS is
>> not enabled on the two DSP ports. It should at least group A/B together
>> because no ACS means A can reach the MMIO of B. This is a serious failure
>> for the VFIO security model.
>>
>> For multi-function-devices, a PCIe topology like:
>>
>>                    -- MFD 00:1f.0 ACS not supported
>>    Root 00:00.00 --|- MFD 00:1f.2 ACS not supported
>>                    |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS
>>
>> Will group [1f.0, 1f.2] and 1f.6 gets a single device group. However from
>> a spec perspective each device should get its own group, because ACS not
>> supported can assume no loopback is possible by spec.
> 
> I just dug through the thread with Don that I think tries to justify
> this, but I have a lot of concerns about this.  I think the "must be
> implemented by Functions that support peer-to-peer traffic with other
> Functions" language is specifying that IF the device implements an ACS
> capability AND does not implement the specific ACS P2P flag being
> described, then and only then can we assume that form of P2P is not
> supported.  OTOH, we cannot assume anything regarding internal P2P of an
> MFD that does not implement an ACS capability at all.
> 
The first, non-IF'd, non-AND'd req in PCIe spec 7.0, section 6.12.1.2 is:
"ACS P2P Request Redirect: must be implemented by Functions that support peer-to-peer traffic with other
Functions. This includes SR-IOV Virtual Functions (VFs)."
There is not further statement about control of peer-to-peer traffic, just the ability to do so, or not.

Note: ACS P2P Request Redirect.

Later in that section it says:
ACS P2P Completion Redirect: must be implemented by Functions that implement ACS P2P Request Redirect.

That can be read as an 'IF Request-Redirect is implemented, than ACS Completion Request must be implemented.
IOW, the Completion Direct control is required if Request Redirect is implemented, and not necessary if
Request Redirect is omitted.

If ACS P2P Require Redirect isn't implemented, than per the first requirement for MFDs,
the PCIe device does not support peer-to-peer traffic amongst its function or virtual functions.

It goes on...
ACS Direct Translated P2P: must be implemented if the Function supports Address Translation Services (ATS)
and also peer-to-peer traffic with other Functions.

If an MFD does not do peer-to-peer, and P2P Request Redirect would be implemented if it did,
than this ACS control does not have to be implemented either.

Egress control structures are either optional or dependent on Request Redirect &/or Direct Translated P2P control,
which have been addressed above as not needed if on peer-to-peer btwn functions in an MFD (and their VFs).


Now, if previous PCIe spec versions (which I didn't read & re-read & re-read like the 6.12 section of PCIe spec 7.0)
had more IF and ANDs, than that could be cause for less than clear specmanship enabling vendors of MFDs
to yield a non-PCIe-7.0 conformant MFD wrt ACS structures.
I searched section 6.12.1.2 for if/IF and AND/and, and did not yield any conditions not stated above.

> I believe we even reached agreement with some NIC vendors in the early
> days of IOMMU groups that they needed to implement an "empty" ACS
> capability on their multifunction NICs such that they could describe in
> this way that internal P2P is not supported by the device.  Thanks,
> 
In the early days -- gen1->gen3 (2009->2015) I could see that happening.
I think time (a decade) has closed those defaults to less-common quirks.
If 'empty ACS' is how they liked to do it back than, sure.
[A definition of empty ACS may be needed to fully appreciate that statement, though.]
If this patch series needs to support an 'empty ACS' for this older case, let's add it now,
or follow-up with another fix.

In summary, I still haven't found the IF and AND you refer to in section 6.12.1.2 for MFDs,
so if you want to quote those sections I mis-read, or mis-interpreted their (subtle?) existence,
than I'm not immovable on the spec interpretation.

- Don

> Alex
> 
>>
>> For root-ports a PCIe topology like:
>>                                           -- Dev 01:00.0
>>    Root  00:00.00 --- Root Port 00:01.0 --|
>>                    |                      -- Dev 01:00.1
>> 		  |- Dev 00:17.0
>>
>> Previously would group [00:01.0, 01:00.0, 01:00.1] together if there is no
>> ACS capability in the root port.
>>
>> While ACS on root ports is underspecified in the spec, it should still
>> function as an egress control and limit access to either the MMIO of the
>> root port itself, or perhaps some other devices upstream of the root
>> complex - 00:17.0 perhaps in this example.
>>
>> Historically the grouping in Linux has assumed the root port routes all
>> traffic into the TA/IOMMU and never bypasses the TA to go to other
>> functions in the root complex. Following the new understanding that ACS is
>> required for internal loopback also treat root ports with no ACS
>> capability as lacking internal loopback as well.
>>
>> There is also some confusing spec language about how ACS and SRIOV works
>> which this series does not address.
>>
>>
>> This entire series goes further and makes some additional improvements to
>> the ACS validation found while studying this problem. The groups around a
>> PCIe to PCI bridge are shrunk to not include the PCIe bridge.
>>
>> The last patches implement "ACS Enhanced" on top of it. Due to how ACS
>> Enhanced was defined as a non-backward compatible feature it is important
>> to get SW support out there.
>>
>> Due to the potential of iommu_groups becoming wider and thus non-usable
>> for VFIO this should go to a linux-next tree to give it some more
>> exposure.
>>
>> I have now tested this a few systems I could get:
>>
>>   - Various Intel client systems:
>>     * Raptor Lake, with VMD enabled and using the real_dev mechanism
>>     * 6/7th generation 100 Series/C320
>>     * 5/6th generation 100 Series/C320 with a NIC MFD quirk
>>     * Tiger Lake
>>     * 5/6th generation Sunrise Point
>>
>>    The 6/7th gen system has a root port without an ACS capability and it
>>    becomes ungrouped as described above.
>>
>>    All systems have changes, the MFDs in the root complex all become ungrouped.
>>
>>   - NVIDIA Grace system with 5 different PCI switches from two vendors
>>     Bug fix widening the iommu_groups works as expected here
>>
>> This is on github: https://github.com/jgunthorpe/linux/commits/pcie_switch_groups
>>
>> v3:
>>   - Rebase to v6.17-rc4
>>   - Drop the quirks related patches
>>   - Change the MFD logic to process no ACS cap as meaning no internal
>>     loopback. This avoids creating non-isolated groups for MFD root ports in
>>     common AMD and Intel systems
>>   - Fix matching MFDs to ignore SRIOV VFs
>>   - Fix some kbuild splats
>> v2: https://patch.msgid.link/r/0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com
>>   - Revise comments and commit messages
>>   - Rename struct pci_alias_set to pci_reachable_set
>>   - Make more sense of the special bus->self = NULL case for SRIOV
>>   - Add pci_group_alloc_non_isolated() for readability
>>   - Rename BUS_DATA_PCI_UNISOLATED to BUS_DATA_PCI_NON_ISOLATED
>>   - Propogate BUS_DATA_PCI_NON_ISOLATED downstream from a MFD in case a MFD
>>     function is a bridge
>>   - New patches to add pci_mfd_isolation() to retain more cases of narrow
>>     groups on MFDs with missing ACS.
>>   - Redescribe the MFD related change as a bug fix. For a MFD to be
>>     isolated all functions must have egress control on their P2P.
>> v1: https://patch.msgid.link/r/0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com
>>
>> Cc: galshalom@nvidia.com
>> Cc: tdave@nvidia.com
>> Cc: maorg@nvidia.com
>> Cc: kvm@vger.kernel.org
>> Cc: Ceric Le Goater" <clg@redhat.com>
>> Cc: Donald Dutile <ddutile@redhat.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>
>> Jason Gunthorpe (11):
>>    PCI: Move REQ_ACS_FLAGS into pci_regs.h as PCI_ACS_ISOLATED
>>    PCI: Add pci_bus_isolated()
>>    iommu: Compute iommu_groups properly for PCIe switches
>>    iommu: Organize iommu_group by member size
>>    PCI: Add pci_reachable_set()
>>    iommu: Compute iommu_groups properly for PCIe MFDs
>>    iommu: Validate that pci_for_each_dma_alias() matches the groups
>>    PCI: Add the ACS Enhanced Capability definitions
>>    PCI: Enable ACS Enhanced bits for enable_acs and config_acs
>>    PCI: Check ACS DSP/USP redirect bits in pci_enable_pasid()
>>    PCI: Check ACS Extended flags for pci_bus_isolated()
>>
>>   drivers/iommu/iommu.c         | 510 +++++++++++++++++++++++-----------
>>   drivers/pci/ats.c             |   4 +-
>>   drivers/pci/pci.c             |  73 ++++-
>>   drivers/pci/search.c          | 274 ++++++++++++++++++
>>   include/linux/pci.h           |  46 +++
>>   include/uapi/linux/pci_regs.h |  18 ++
>>   6 files changed, 759 insertions(+), 166 deletions(-)
>>
>>
>> base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
> 


