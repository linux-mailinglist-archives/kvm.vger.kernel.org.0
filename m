Return-Path: <kvm+bounces-58427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ADA3B937F4
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BE7A2E1283
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56F823019AB;
	Mon, 22 Sep 2025 22:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RM861iy7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB7D28A73A
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 22:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758580795; cv=none; b=abOXearv9Gu4XfgL1Y0JNj1ZVOp4wXhBHRqEU2p0SbLmrenEoA5jJggRM3lnVZtTh232Br8msfJCDUj9x7gOC6OxeJNJKHZWOcPPATFiGMZCIFh07NXGUPTwUHZtw6v1N0KA7yccLxJi6eBtqKMwCZg6gI7war1rLnJOXGtzc5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758580795; c=relaxed/simple;
	bh=xxzc2/gsSbiwET7MEYllT68rGvqkghrFsdTf5eYlnns=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RO+bf3GQme1o3SmrirjOv0DtiR/aa6EQZa/ITjus7k5ZpAVSQrT7PLeCTbF02Uv1cDpP1mxvqibVXYuRq8kS4UNCehXtXBcsxhGotzx0+yeZC2imNbT8bKoJlhcJZ+Kj8lt1pPSy3qTHbLtXcEd+QA7GeTDFxzAlBZEgrYyIW60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RM861iy7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758580792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hua1YNDvrnVTXTDaulH5D0zPjatQnVFqU+8AkiHzeM0=;
	b=RM861iy7r0WGsxCtpNXyEICTKXixmRqBAFeIiYIWUj+x8of8ULIdwF0vRR90uHh0+oKTzs
	NFISD9jlWmmxQnV159CV0HfdCfxYoNWR5o0ZNkdyLCIjZmxFsoV9xcSGa+CuWi4nB32rrw
	A1hKIKZbv5WIZ4yqRZriGYdZnQmg5oI=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-So1TrOqyOL-bangvyoGIQw-1; Mon, 22 Sep 2025 18:39:51 -0400
X-MC-Unique: So1TrOqyOL-bangvyoGIQw-1
X-Mimecast-MFC-AGG-ID: So1TrOqyOL-bangvyoGIQw_1758580790
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-42499166998so4877765ab.3
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 15:39:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758580790; x=1759185590;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hua1YNDvrnVTXTDaulH5D0zPjatQnVFqU+8AkiHzeM0=;
        b=uA8w7hBVXu5pVkvdWe9dVMXWSRkArMgDHBJ08WbQI2QT1q0escbuOK21JPnDZK5rN1
         Jg8Ab7bi1KUm3joshApdPaLkqt8aOgdocXjwPSR19PqvwQNsCQ8r9i+7Gl8oPARQXg5W
         uJcF2ZV7GkQYwxhYwnXO7eQpzFP/CoIQlBq4bxscWMSRZBaljJIB/vGgu1NUP6sHIJHk
         MigoDKdPJBlU5PjAe01cp0ho/Njv+y0ndWheCPgrObsu1kY1tbPvKeFoIYlGg3JjvVhi
         PembkRJZj5je8+Xat1dK9s6yNyScvBJoC+h0OFW9idXnH46LpvJ+mYRtociVCGl/HQgm
         +odQ==
X-Forwarded-Encrypted: i=1; AJvYcCXogcyyWC1eP8MjPU09z/hZqxFiEmQr+ISr9H2XlZmNj4fLOORZ2EGAEEK/MGTKbjVfRso=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6DmkzcLWRiggsSB0rYX5KnlDAahnmdWInnA+zYFj4LJJHsY4l
	FOL5/c/mNRbABFc8tSJp+yWgo5YOs9Ar22OHxTCrqsKlRcSbqkhrardvpdW0d8TRexNed+GOQwQ
	EB1JnX0ilh17dOOVKYZlGrM9ZsvemSbcBEJIDw1PcfaWv1gLv4+dl+g==
X-Gm-Gg: ASbGncvU5SgE4VgqNrpzEFVEfYr0h0fkW576WXmYzYiDKUyW/eKG3lw3MY+V6gxepLV
	pdrNBvl06bgI317V1GyjVzgBVk0EjRVR3QpOUgy1G1VGHt808Gs2OX0usqFAMYYViJluETUgwP/
	ILI2+2jUBVRhv7zxLF09ZP4kNlBjIe4/1tC+t6vuOngWDFUUDP+KTWvBj27jLueNz9wkYBeERW6
	+lcoztbnVEci5Czw7mhq8qbHGAsCn2qPIgmFJJKU48bnhOV1Tll+6j/gdbRTZugGS6L1oJS5NVL
	YL3begKrrS3ahH0FG4ESBK1yGCiiBKhAkq1Y7cqh84o=
X-Received: by 2002:a05:6602:168e:b0:896:fcb5:4bb3 with SMTP id ca18e2360f4ac-8e216156f1emr42492039f.4.1758580790047;
        Mon, 22 Sep 2025 15:39:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6RnVqdk31F1uAF17Tm38XXvYq834lf3FKKUs0gGagizXj54kUsRUd21kDpI5BwyMPzZ14Xw==
X-Received: by 2002:a05:6602:168e:b0:896:fcb5:4bb3 with SMTP id ca18e2360f4ac-8e216156f1emr42490639f.4.1758580789544;
        Mon, 22 Sep 2025 15:39:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d55460864sm6214071173.66.2025.09.22.15.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 15:39:48 -0700 (PDT)
Date: Mon, 22 Sep 2025 16:39:47 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev, Joerg Roedel
 <joro@8bytes.org>, linux-pci@vger.kernel.org, Robin Murphy
 <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, Donald Dutile <ddutile@redhat.com>,
 galshalom@nvidia.com, Joerg Roedel <jroedel@suse.de>, Kevin Tian
 <kevin.tian@intel.com>, kvm@vger.kernel.org, maorg@nvidia.com,
 patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 00/11] Fix incorrect iommu_groups with PCIe ACS
Message-ID: <20250922163947.5a8304d4.alex.williamson@redhat.com>
In-Reply-To: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
References: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  5 Sep 2025 15:06:15 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The series patches have extensive descriptions as to the problem and
> solution, but in short the ACS flags are not analyzed according to the
> spec to form the iommu_groups that VFIO is expecting for security.
> 
> ACS is an egress control only. For a path the ACS flags on each hop only
> effect what other devices the TLP is allowed to reach. It does not prevent
> other devices from reaching into this path.
> 
> For VFIO if device A is permitted to access device B's MMIO then A and B
> must be grouped together. This says that even if a path has isolating ACS
> flags on each hop, off-path devices with non-isolating ACS can still reach
> into that path and must be grouped gother.
> 
> For switches, a PCIe topology like:
> 
>                                -- DSP 02:00.0 -> End Point A
>  Root 00:00.0 -> USP 01:00.0 --|
>                                -- DSP 02:03.0 -> End Point B
> 
> Will generate unique single device groups for every device even if ACS is
> not enabled on the two DSP ports. It should at least group A/B together
> because no ACS means A can reach the MMIO of B. This is a serious failure
> for the VFIO security model.
> 
> For multi-function-devices, a PCIe topology like:
> 
>                   -- MFD 00:1f.0 ACS not supported
>   Root 00:00.00 --|- MFD 00:1f.2 ACS not supported
>                   |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS
> 
> Will group [1f.0, 1f.2] and 1f.6 gets a single device group. However from
> a spec perspective each device should get its own group, because ACS not
> supported can assume no loopback is possible by spec.

I just dug through the thread with Don that I think tries to justify
this, but I have a lot of concerns about this.  I think the "must be
implemented by Functions that support peer-to-peer traffic with other
Functions" language is specifying that IF the device implements an ACS
capability AND does not implement the specific ACS P2P flag being
described, then and only then can we assume that form of P2P is not
supported.  OTOH, we cannot assume anything regarding internal P2P of an
MFD that does not implement an ACS capability at all.

I believe we even reached agreement with some NIC vendors in the early
days of IOMMU groups that they needed to implement an "empty" ACS
capability on their multifunction NICs such that they could describe in
this way that internal P2P is not supported by the device.  Thanks,

Alex

> 
> For root-ports a PCIe topology like:
>                                          -- Dev 01:00.0
>   Root  00:00.00 --- Root Port 00:01.0 --|
>                   |                      -- Dev 01:00.1
> 		  |- Dev 00:17.0
> 
> Previously would group [00:01.0, 01:00.0, 01:00.1] together if there is no
> ACS capability in the root port.
> 
> While ACS on root ports is underspecified in the spec, it should still
> function as an egress control and limit access to either the MMIO of the
> root port itself, or perhaps some other devices upstream of the root
> complex - 00:17.0 perhaps in this example.
> 
> Historically the grouping in Linux has assumed the root port routes all
> traffic into the TA/IOMMU and never bypasses the TA to go to other
> functions in the root complex. Following the new understanding that ACS is
> required for internal loopback also treat root ports with no ACS
> capability as lacking internal loopback as well.
> 
> There is also some confusing spec language about how ACS and SRIOV works
> which this series does not address.
> 
> 
> This entire series goes further and makes some additional improvements to
> the ACS validation found while studying this problem. The groups around a
> PCIe to PCI bridge are shrunk to not include the PCIe bridge.
> 
> The last patches implement "ACS Enhanced" on top of it. Due to how ACS
> Enhanced was defined as a non-backward compatible feature it is important
> to get SW support out there.
> 
> Due to the potential of iommu_groups becoming wider and thus non-usable
> for VFIO this should go to a linux-next tree to give it some more
> exposure.
> 
> I have now tested this a few systems I could get:
> 
>  - Various Intel client systems:
>    * Raptor Lake, with VMD enabled and using the real_dev mechanism
>    * 6/7th generation 100 Series/C320
>    * 5/6th generation 100 Series/C320 with a NIC MFD quirk
>    * Tiger Lake
>    * 5/6th generation Sunrise Point
> 
>   The 6/7th gen system has a root port without an ACS capability and it
>   becomes ungrouped as described above.
> 
>   All systems have changes, the MFDs in the root complex all become ungrouped.
> 
>  - NVIDIA Grace system with 5 different PCI switches from two vendors
>    Bug fix widening the iommu_groups works as expected here
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/pcie_switch_groups
> 
> v3:
>  - Rebase to v6.17-rc4
>  - Drop the quirks related patches
>  - Change the MFD logic to process no ACS cap as meaning no internal
>    loopback. This avoids creating non-isolated groups for MFD root ports in
>    common AMD and Intel systems
>  - Fix matching MFDs to ignore SRIOV VFs
>  - Fix some kbuild splats
> v2: https://patch.msgid.link/r/0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com
>  - Revise comments and commit messages
>  - Rename struct pci_alias_set to pci_reachable_set
>  - Make more sense of the special bus->self = NULL case for SRIOV
>  - Add pci_group_alloc_non_isolated() for readability
>  - Rename BUS_DATA_PCI_UNISOLATED to BUS_DATA_PCI_NON_ISOLATED
>  - Propogate BUS_DATA_PCI_NON_ISOLATED downstream from a MFD in case a MFD
>    function is a bridge
>  - New patches to add pci_mfd_isolation() to retain more cases of narrow
>    groups on MFDs with missing ACS.
>  - Redescribe the MFD related change as a bug fix. For a MFD to be
>    isolated all functions must have egress control on their P2P.
> v1: https://patch.msgid.link/r/0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com
> 
> Cc: galshalom@nvidia.com
> Cc: tdave@nvidia.com
> Cc: maorg@nvidia.com
> Cc: kvm@vger.kernel.org
> Cc: Ceric Le Goater" <clg@redhat.com>
> Cc: Donald Dutile <ddutile@redhat.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason Gunthorpe (11):
>   PCI: Move REQ_ACS_FLAGS into pci_regs.h as PCI_ACS_ISOLATED
>   PCI: Add pci_bus_isolated()
>   iommu: Compute iommu_groups properly for PCIe switches
>   iommu: Organize iommu_group by member size
>   PCI: Add pci_reachable_set()
>   iommu: Compute iommu_groups properly for PCIe MFDs
>   iommu: Validate that pci_for_each_dma_alias() matches the groups
>   PCI: Add the ACS Enhanced Capability definitions
>   PCI: Enable ACS Enhanced bits for enable_acs and config_acs
>   PCI: Check ACS DSP/USP redirect bits in pci_enable_pasid()
>   PCI: Check ACS Extended flags for pci_bus_isolated()
> 
>  drivers/iommu/iommu.c         | 510 +++++++++++++++++++++++-----------
>  drivers/pci/ats.c             |   4 +-
>  drivers/pci/pci.c             |  73 ++++-
>  drivers/pci/search.c          | 274 ++++++++++++++++++
>  include/linux/pci.h           |  46 +++
>  include/uapi/linux/pci_regs.h |  18 ++
>  6 files changed, 759 insertions(+), 166 deletions(-)
> 
> 
> base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0


