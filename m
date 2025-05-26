Return-Path: <kvm+bounces-47711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53005AC3EAE
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 13:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E5A118955F7
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 694411FBE87;
	Mon, 26 May 2025 11:37:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63F31F8733
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 11:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748259444; cv=none; b=QwzOfkyjPIuFMHf0meYrORJ23sGSpDpNiswneEAOXSxeAGQ21yxUoOEijdn2MkW2wxEZGPcFBvID0r8pBYALrRFCq0wWgS5OR4fTUsZjr1ryV6Tn3al6f+9kYf/7BUafnvhYnwEn2VeLyu0FmjsYa3vYr39ld4u8FiB6pwr8GtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748259444; c=relaxed/simple;
	bh=obRg6c6rgwjNugCShzmr6USx/1tP0y45/5Dn4om2wHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uxB2yWBl9EWegIAZhirDNhMlBjSeIiTsaGwx28zdoTfWLvKTWRpVV+3UT6K8U2w/VxZmTm1EXjLT6Q38BxkvZVRNnP7t2jl8Hm+p+XYOWg4KusYhffjmWCTBhqEk3ghw/GKfakAhlqNvMDTSTfL+FiT+ARQ+6Ua0LmNWFfsepfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaod.org; spf=pass smtp.mailfrom=ozlabs.org; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaod.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ozlabs.org
Received: from mail.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by gandalf.ozlabs.org (Postfix) with ESMTP id 4b5Ydp4Q66z4wd0;
	Mon, 26 May 2025 21:37:18 +1000 (AEST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4b5Ydh3xJJz4wy6;
	Mon, 26 May 2025 21:37:11 +1000 (AEST)
Message-ID: <7283f8f2-a9d9-4e7d-bfbd-3854b3d1736e@kaod.org>
Date: Mon, 26 May 2025 13:37:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/10] Enable shared device assignment
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 'Alex Williamson' <alex.williamson@redhat.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>
Autocrypt: addr=clg@kaod.org; keydata=
 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
In-Reply-To: <20250520102856.132417-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/25 12:28, Chenyi Qiang wrote:
> This is the v5 series of the shared device assignment support.
> 
> As discussed in the v4 series [1], the GenericStateManager parent class
> and PrivateSharedManager child interface were deemed to be in the wrong
> direction. This series reverts back to the original single
> RamDiscardManager interface and puts it as future work to allow the
> co-existence of multiple pairs of state management. For example, if we
> want to have virtio-mem co-exist with guest_memfd, it will need a new
> framework to combine the private/shared/discard states [2].
> 
> Another change since the last version is the error handling of memory
> conversion. Currently, the failure of kvm_convert_memory() causes QEMU
> to quit instead of resuming the guest. The complex rollback operation
> doesn't add value and merely adds code that is difficult to test.
> Although in the future, it is more likely to encounter more errors on
> conversion paths like unmap failure on shared to private in-place
> conversion. This series keeps complex error handling out of the picture
> for now and attaches related handling at the end of the series for
> future extension.
> 
> Apart from the above two parts with future work, there's some
> optimization work in the future, i.e., using other more memory-efficient
> mechanism to track ranges of contiguous states instead of a bitmap [3].
> This series still uses a bitmap for simplicity.
>   
> The overview of this series:
> - Patch 1-3: Preparation patches. These include function exposure and
>    some definition changes to return values.
> - Patch 4-5: Introduce a new object to implement RamDiscardManager
>    interface and a helper to notify the shared/private state change.
> - Patch 6: Store the new object including guest_memfd information in
>    RAMBlock. Register the RamDiscardManager instance to the target
>    RAMBlock's MemoryRegion so that the RamDiscardManager users can run in
>    the specific path.
> - Patch 7: Unlock the coordinate discard so that the shared device
>    assignment (VFIO) can work with guest_memfd. After this patch, the
>    basic device assignement functionality can work properly.
> - Patch 8-9: Some cleanup work. Move the state change handling into a
>    RamDiscardListener so that it can be invoked together with the VFIO
>    listener by the state_change() call. This series dropped the priority
>    support in v4 which is required by in-place conversions, because the
>    conversion path will likely change.
> - Patch 10: More complex error handing including rollback and mixture
>    states conversion case.
> 
> More small changes or details can be found in the individual patches.
> 
> ---
> Original cover letter:
> 
> Background
> ==========
> Confidential VMs have two classes of memory: shared and private memory.
> Shared memory is accessible from the host/VMM while private memory is
> not. Confidential VMs can decide which memory is shared/private and
> convert memory between shared/private at runtime.
> 
> "guest_memfd" is a new kind of fd whose primary goal is to serve guest
> private memory. In current implementation, shared memory is allocated
> with normal methods (e.g. mmap or fallocate) while private memory is
> allocated from guest_memfd. When a VM performs memory conversions, QEMU
> frees pages via madvise or via PUNCH_HOLE on memfd or guest_memfd from
> one side, and allocates new pages from the other side. This will cause a
> stale IOMMU mapping issue mentioned in [4] when we try to enable shared
> device assignment in confidential VMs.
> 
> Solution
> ========
> The key to enable shared device assignment is to update the IOMMU mappings
> on page conversion. RamDiscardManager, an existing interface currently
> utilized by virtio-mem, offers a means to modify IOMMU mappings in
> accordance with VM page assignment. Although the required operations in
> VFIO for page conversion are similar to memory plug/unplug, the states of
> private/shared are different from discard/populated. We want a similar
> mechanism with RamDiscardManager but used to manage the state of private
> and shared.
> 
> This series introduce a new parent abstract class to manage a pair of
> opposite states with RamDiscardManager as its child to manage
> populate/discard states, and introduce a new child class,
> PrivateSharedManager, which can also utilize the same infrastructure to
> notify VFIO of page conversions.
> 
> Relationship with in-place page conversion
> ==========================================
> To support 1G page support for guest_memfd [5], the current direction is to
> allow mmap() of guest_memfd to userspace so that both private and shared
> memory can use the same physical pages as the backend. This in-place page
> conversion design eliminates the need to discard pages during shared/private
> conversions. However, device assignment will still be blocked because the
> in-place page conversion will reject the conversion when the page is pinned
> by VFIO.
> 
> To address this, the key difference lies in the sequence of VFIO map/unmap
> operations and the page conversion. It can be adjusted to achieve
> unmap-before-conversion-to-private and map-after-conversion-to-shared,
> ensuring compatibility with guest_memfd.
> 
> Limitation
> ==========
> One limitation is that VFIO expects the DMA mapping for a specific IOVA
> to be mapped and unmapped with the same granularity. The guest may
> perform partial conversions, such as converting a small region within a
> larger region. To prevent such invalid cases, all operations are
> performed with 4K granularity. This could be optimized after the
> cut_mapping operation[6] is introduced in future. We can alway perform a
> split-before-unmap if partial conversions happen. If the split succeeds,
> the unmap will succeed and be atomic. If the split fails, the unmap
> process fails.
> 
> Testing
> =======
> This patch series is tested based on TDX patches available at:
> KVM: https://github.com/intel/tdx/tree/kvm-coco-queue-snapshot/kvm-coco-queue-snapshot-20250408
> QEMU: https://github.com/intel-staging/qemu-tdx/tree/tdx-upstream-snapshot-2025-05-20
> 
> Because the new features like cut_mapping operation will only be support in iommufd.
> It is recommended to use the iommufd-backed VFIO with the qemu command:

Is it recommended or required ? If the VFIO IOMMU type1 backend is not
supported for confidential VMs, QEMU should fail to start.

Please add Alex Williamson and I to the Cc: list.

Thanks,

C.

> qemu-system-x86_64 [...]
>      -object iommufd,id=iommufd0 \
>      -device vfio-pci,host=XX:XX.X,iommufd=iommufd0
> 
> Following the bootup of the TD guest, the guest's IP address becomes
> visible, and iperf is able to successfully send and receive data.
> 
> Related link
> ============
> [1] https://lore.kernel.org/qemu-devel/20250407074939.18657-1-chenyi.qiang@intel.com/
> [2] https://lore.kernel.org/qemu-devel/d1a71e00-243b-4751-ab73-c05a4e090d58@redhat.com/
> [3] https://lore.kernel.org/qemu-devel/96ab7fa9-bd7a-444d-aef8-8c9c30439044@redhat.com/
> [4] https://lore.kernel.org/qemu-devel/20240423150951.41600-54-pbonzini@redhat.com/
> [5] https://lore.kernel.org/kvm/cover.1747264138.git.ackerleytng@google.com/
> [6] https://lore.kernel.org/linux-iommu/0-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com/
> 
> 
> Chenyi Qiang (10):
>    memory: Export a helper to get intersection of a MemoryRegionSection
>      with a given range
>    memory: Change memory_region_set_ram_discard_manager() to return the
>      result
>    memory: Unify the definiton of ReplayRamPopulate() and
>      ReplayRamDiscard()
>    ram-block-attribute: Introduce RamBlockAttribute to manage RAMBlock
>      with guest_memfd
>    ram-block-attribute: Introduce a helper to notify shared/private state
>      changes
>    memory: Attach RamBlockAttribute to guest_memfd-backed RAMBlocks
>    RAMBlock: Make guest_memfd require coordinate discard
>    memory: Change NotifyRamDiscard() definition to return the result
>    KVM: Introduce RamDiscardListener for attribute changes during memory
>      conversions
>    ram-block-attribute: Add more error handling during state changes
> 
>   MAINTAINERS                                 |   1 +
>   accel/kvm/kvm-all.c                         |  79 ++-
>   hw/vfio/listener.c                          |   6 +-
>   hw/virtio/virtio-mem.c                      |  83 ++--
>   include/system/confidential-guest-support.h |   9 +
>   include/system/memory.h                     |  76 ++-
>   include/system/ramblock.h                   |  22 +
>   migration/ram.c                             |  33 +-
>   system/memory.c                             |  22 +-
>   system/meson.build                          |   1 +
>   system/physmem.c                            |  18 +-
>   system/ram-block-attribute.c                | 514 ++++++++++++++++++++
>   target/i386/kvm/tdx.c                       |   1 +
>   target/i386/sev.c                           |   1 +
>   14 files changed, 770 insertions(+), 96 deletions(-)
>   create mode 100644 system/ram-block-attribute.c
> 


