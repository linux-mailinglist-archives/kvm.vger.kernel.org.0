Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1704936C801
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 16:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbhD0Ow5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 10:52:57 -0400
Received: from foss.arm.com ([217.140.110.172]:53668 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238446AbhD0Ow4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 10:52:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94A2231B;
        Tue, 27 Apr 2021 07:52:12 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D95303F73B;
        Tue, 27 Apr 2021 07:52:09 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Skip CMOs when updating a PTE pointing to
 non-memory
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Sumit Gupta <sumitg@nvidia.com>
References: <20210426103605.616908-1-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e6d955f1-f2a4-9505-19ab-5a770f821386@arm.com>
Date:   Tue, 27 Apr 2021 15:52:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210426103605.616908-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I've been trying to reproduce the panic, but I haven't had any success.

With a known working PCI passtrough device, this is how I changed kvmtool:

diff --git a/vfio/core.c b/vfio/core.c
index 3ff2c0b..b4ee7e9 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -261,6 +261,9 @@ int vfio_map_region(struct kvm *kvm, struct vfio_device *vdev,
                return ret;
        }
 
+       char c = *(char *)base;
+       fprintf(stderr, "c = %c\n", c);
+
        return 0;
 }
 
What the change is doing is reading from the BAR region after it's has been
mmap'ed into userspace. I can see that the read hits vfio_pci_mmap_fault(), which
calls io_remap_pfn_range(), but I can't figure out how I can trigger the MMU
notifiers. Any suggestions?

The comment [1] suggested that the panic is triggered during page aging.
vfio_pci_mmap() sets the VM_PFNMAP for the VMA and I see in the Documentation that
pages with VM_PFNMAP are added to the unevictable LRU list, doesn't that mean it's
not subject the page aging? I feel like there's something I'm missing.

[1]
https://lore.kernel.org/kvm/BY5PR12MB37642B9AC7E5D907F5A664F6B3459@BY5PR12MB3764.namprd12.prod.outlook.com/

Thanks,

Alex

On 4/26/21 11:36 AM, Marc Zyngier wrote:
> Sumit Gupta and Krishna Reddy both reported that for MMIO regions
> mapped into userspace using VFIO, a PTE update can trigger a MMU
> notifier reaching kvm_set_spte_hva().
>
> There is an assumption baked in kvm_set_spte_hva() that it only
> deals with memory pages, and not MMIO. For this purpose, it
> performs a cache cleaning of the potentially newly mapped page.
> However, for a MMIO range, this explodes as there is no linear
> mapping for this range (and doing cache maintenance on it would
> make little sense anyway).
>
> Check for the validity of the page before performing the CMO
> addresses the problem.
>
> Reported-by: Krishna Reddy <vdumpa@nvidia.com>
> Reported-by: Sumit Gupta <sumitg@nvidia.com>,
> Tested-by: Sumit Gupta <sumitg@nvidia.com>,
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/5a8825bc-286e-b316-515f-3bd3c9c70a80@nvidia.com
> ---
>  arch/arm64/kvm/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index cd4d51ae3d4a..564a0f7fcd05 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1236,7 +1236,8 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>  	 * We've moved a page around, probably through CoW, so let's treat it
>  	 * just like a translation fault and clean the cache to the PoC.
>  	 */
> -	clean_dcache_guest_page(pfn, PAGE_SIZE);
> +	if (!kvm_is_device_pfn(pfn))
> +		clean_dcache_guest_page(pfn, PAGE_SIZE);
>  	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pfn);
>  	return 0;
>  }
