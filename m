Return-Path: <kvm+bounces-3558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC1780535F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:49:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 078BC281571
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C135459B43;
	Tue,  5 Dec 2023 11:49:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1413CD302;
	Tue,  5 Dec 2023 11:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6136C433C7;
	Tue,  5 Dec 2023 11:48:59 +0000 (UTC)
Date: Tue, 5 Dec 2023 11:48:57 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org,
	ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	mochs@nvidia.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZW8OKZHpXeVjoNo6@arm.com>
References: <20231205033015.10044-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205033015.10044-1-ankita@nvidia.com>

On Tue, Dec 05, 2023 at 09:00:15AM +0530, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Currently, KVM for ARM64 maps at stage 2 memory that is considered device
> (i.e. it is not RAM) with DEVICE_nGnRE memory attributes; this setting
> overrides (as per the ARM architecture [1]) any device MMIO mapping
> present at stage 1, resulting in a set-up whereby a guest operating
> system cannot determine device MMIO mapping memory attributes on its
> own but it is always overridden by the KVM stage 2 default.
> 
> This set-up does not allow guest operating systems to select device
> memory attributes independently from KVM stage-2 mappings
> (refer to [1], "Combining stage 1 and stage 2 memory type attributes"),
> which turns out to be an issue in that guest operating systems
> (e.g. Linux) may request to map devices MMIO regions with memory
> attributes that guarantee better performance (e.g. gathering
> attribute - that for some devices can generate larger PCIe memory
> writes TLPs) and specific operations (e.g. unaligned transactions)
> such as the NormalNC memory type.
> 
> The default device stage 2 mapping was chosen in KVM for ARM64 since
> it was considered safer (i.e. it would not allow guests to trigger
> uncontained failures ultimately crashing the machine) but this
> turned out to be asynchronous (SError) defeating the purpose.
> 
> Failures containability is a property of the platform and is independent
> from the memory type used for MMIO device memory mappings.
> 
> Actually, DEVICE_nGnRE memory type is even more problematic than
> Normal-NC memory type in terms of faults containability in that e.g.
> aborts triggered on DEVICE_nGnRE loads cannot be made, architecturally,
> synchronous (i.e. that would imply that the processor should issue at
> most 1 load transaction at a time - it cannot pipeline them - otherwise
> the synchronous abort semantics would break the no-speculation attribute
> attached to DEVICE_XXX memory).
> 
> This means that regardless of the combined stage1+stage2 mappings a
> platform is safe if and only if device transactions cannot trigger
> uncontained failures and that in turn relies on platform capabilities
> and the device type being assigned (i.e. PCIe AER/DPC error containment
> and RAS architecture[3]); therefore the default KVM device stage 2
> memory attributes play no role in making device assignment safer
> for a given platform (if the platform design adheres to design
> guidelines outlined in [3]) and therefore can be relaxed.
> 
> For all these reasons, relax the KVM stage 2 device memory attributes
> from DEVICE_nGnRE to Normal-NC. Add a new kvm_pgtable_prot flag for
> Normal-NC.
> 
> The Normal-NC was chosen over a different Normal memory type default
> at stage-2 (e.g. Normal Write-through) to avoid cache allocation/snooping.
> 
> Relaxing S2 KVM device MMIO mappings to Normal-NC is not expected to
> trigger any issue on guest device reclaim use cases either (i.e. device
> MMIO unmap followed by a device reset) at least for PCIe devices, in that
> in PCIe a device reset is architected and carried out through PCI config
> space transactions that are naturally ordered with respect to MMIO
> transactions according to the PCI ordering rules.
> 
> Having Normal-NC S2 default puts guests in control (thanks to
> stage1+stage2 combined memory attributes rules [1]) of device MMIO
> regions memory mappings, according to the rules described in [1]
> and summarized here ([(S1) - stage1], [(S2) - stage 2]):
> 
> S1           |  S2           | Result
> NORMAL-WB    |  NORMAL-NC    | NORMAL-NC
> NORMAL-WT    |  NORMAL-NC    | NORMAL-NC
> NORMAL-NC    |  NORMAL-NC    | NORMAL-NC
> DEVICE<attr> |  NORMAL-NC    | DEVICE<attr>
> 
> It is worth noting that currently, to map devices MMIO space to user
> space in a device pass-through use case the VFIO framework applies memory
> attributes derived from pgprot_noncached() settings applied to VMAs, which
> result in device-nGnRnE memory attributes for the stage-1 VMM mappings.
> 
> This means that a userspace mapping for device MMIO space carried
> out with the current VFIO framework and a guest OS mapping for the same
> MMIO space may result in a mismatched alias as described in [2].
> 
> Defaulting KVM device stage-2 mappings to Normal-NC attributes does not
> change anything in this respect, in that the mismatched aliases would
> only affect (refer to [2] for a detailed explanation) ordering between
> the userspace and GuestOS mappings resulting stream of transactions
> (i.e. it does not cause loss of property for either stream of
> transactions on its own), which is harmless given that the userspace
> and GuestOS access to the device is carried out through independent
> transactions streams.
> 
> [1] section D8.5 - DDI0487_I_a_a-profile_architecture_reference_manual.pdf
> [2] section B2.8 - DDI0487_I_a_a-profile_architecture_reference_manual.pdf
> [3] sections 1.7.7.3/1.8.5.2/appendix C - DEN0029H_SBSA_7.1.pdf
> 
> Applied over next-20231201
> 
> History
> =======
> v1 -> v2
> - Updated commit log to the one posted by
>   Lorenzo Pieralisi <lpieralisi@kernel.org> (Thanks!)
> - Added new flag to represent the NORMAL_NC setting. Updated
>   stage2_set_prot_attr() to handle new flag.
> 
> v1 Link:
> https://lore.kernel.org/all/20230907181459.18145-3-ankita@nvidia.com/
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

In the light of having to keep this relaxation only for PCIe devices, I
will withdraw my Ack until we come to a conclusion.

Thanks.

-- 
Catalin

