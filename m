Return-Path: <kvm+bounces-71851-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UFWPB8Esn2lzZQQAu9opvQ
	(envelope-from <kvm+bounces-71851-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:09:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D4719B45A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:09:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 74B843033885
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AD0A3E958C;
	Wed, 25 Feb 2026 17:08:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE2F3E8C67;
	Wed, 25 Feb 2026 17:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772039331; cv=none; b=BGPBGvHcCFB9R+VpGWNzaQazo/vV31YltMIw4EdCAW+lKJ6pVa7+eaiEEgfOerntBzzNRofkfk+BbDQ7oh9XHzrLZcmZbVP8lcuoarTjGSblzdUPEOfI+aJUruH1Jaar+91DiX/A02x1Pa3eudCu/Y4Db4k6btqJs4qfvd7B7QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772039331; c=relaxed/simple;
	bh=e86dy79TKlUxU3xf80Vcy6z1TEZmqr9y+GYyp3xRW3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WU6dQZ7Kgb8TxIOWdJ8ENeTvs6Ca923kigX4AWDDhcq9ScuJPX+9pVS3pOPRR65qlmaFprsnEAYaezUNmZKtCIvYD3442CL+lOfeTn8c4KJ1ghWQYjdDEsXjvGzy074YlSMKYfZJxGnDWJviSV5ny5uBTJPRVeqLfrHWzWpYFHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AF5B165C;
	Wed, 25 Feb 2026 09:08:43 -0800 (PST)
Received: from [10.57.58.107] (unknown [10.57.58.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A8BC3F62B;
	Wed, 25 Feb 2026 09:08:40 -0800 (PST)
Message-ID: <d8102507-e537-4e7c-8137-082a43fd270d@arm.com>
Date: Wed, 25 Feb 2026 17:08:37 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kernel 6/9] x86/dma-direct: Stop changing encrypted page
 state for TDISP devices
To: Alexey Kardashevskiy <aik@amd.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Mike Rapoport <rppt@kernel.org>,
 Tom Lendacky <thomas.lendacky@amd.com>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Stefano Garzarella
 <sgarzare@redhat.com>, Melody Wang <huibo.wang@amd.com>,
 Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel <joerg.roedel@amd.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Andi Kleen <ak@linux.intel.com>,
 Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
 Tony Luck <tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Denis Efremov <efremov@linux.com>, Geliang Tang <geliang@kernel.org>,
 Piotr Gregor <piotrgregor@rsyncme.org>, "Michael S. Tsirkin"
 <mst@redhat.com>, Alex Williamson <alex@shazbot.org>,
 Arnd Bergmann <arnd@arndb.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>,
 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Claire Chang <tientzu@chromium.org>, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-7-aik@amd.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20260225053806.3311234-7-aik@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71851-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[robin.murphy@arm.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_GT_50(0.00)[57];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:email,arm.com:mid]
X-Rspamd-Queue-Id: D8D4719B45A
X-Rspamd-Action: no action

On 2026-02-25 5:37 am, Alexey Kardashevskiy wrote:
> TDISP devices operate in CoCo VMs only and capable of accessing
> encrypted guest memory.
> 
> Currently when SME is on, the DMA subsystem forces the SME mask in
> DMA handles in phys_to_dma() which assumes IOMMU pass through
> which is never the case with CoCoVM running with a TDISP device.
> 
> Define X86's version of phys_to_dma() to skip leaking SME mask to
> the device.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
> 
> Doing this in the generic version breaks ARM which uses
> the SME mask in DMA handles, hence ARCH_HAS_PHYS_TO_DMA.

That smells a bit off... In CCA we should be in the same boat, wherein a 
trusted device can access memory at a DMA address based on its "normal" 
(private) GPA, rather than having to be redirected to the shared alias 
(it's really not an "SME mask" in that sense at all).

I guess this comes back to the point I just raised on the previous patch 
- the current assumption is that devices cannot access private memory at 
all, and thus phys_to_dma() is implicitly only dealing with the 
mechanics of how the given device accesses shared memory. Once that no 
longer holds, I don't see how we can find the right answer without also 
consulting the relevant state of paddr itself, and that really *should* 
be able to be commonly abstracted across CoCo environments. And if in 
the process of that we could untangle the "implicit vs. explicit SME 
mask for shared memory or non-CoCo SME" case from common code and punt 
*that* into an x86-specific special case, all the better :)

Thanks,
Robin.

> pci_device_add() enforces the FFFF_FFFF coherent DMA mask so
> dma_alloc_coherent() fails when SME=on, this is how I ended up fixing
> phys_to_dma() and not quite sure it is the right fix.
> ---
>   arch/x86/Kconfig                  |  1 +
>   arch/x86/include/asm/dma-direct.h | 39 ++++++++++++++++++++
>   2 files changed, 40 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index fa3b616af03a..c46283064518 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -112,6 +112,7 @@ config X86
>   	select ARCH_HAS_UBSAN
>   	select ARCH_HAS_DEBUG_WX
>   	select ARCH_HAS_ZONE_DMA_SET if EXPERT
> +	select ARCH_HAS_PHYS_TO_DMA
>   	select ARCH_HAVE_NMI_SAFE_CMPXCHG
>   	select ARCH_HAVE_EXTRA_ELF_NOTES
>   	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
> diff --git a/arch/x86/include/asm/dma-direct.h b/arch/x86/include/asm/dma-direct.h
> new file mode 100644
> index 000000000000..f50e03d643c1
> --- /dev/null
> +++ b/arch/x86/include/asm/dma-direct.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef ASM_X86_DMA_DIRECT_H
> +#define ASM_X86_DMA_DIRECT_H 1
> +
> +static inline dma_addr_t __phys_to_dma(struct device *dev, phys_addr_t paddr)
> +{
> +	if (dev->dma_range_map)
> +		return translate_phys_to_dma(dev, paddr);
> +	return paddr;
> +}
> +
> +static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
> +{
> +	/*
> +	 * TDISP devices only work in CoCoVMs and rely on IOMMU to
> +	 * decide on the memory encryption.
> +	 * Stop leaking the SME mask in DMA handles and return
> +	 * the real address.
> +	 */
> +	if (device_cc_accepted(dev))
> +		return dma_addr_unencrypted(__phys_to_dma(dev, paddr));
> +
> +	return dma_addr_encrypted(__phys_to_dma(dev, paddr));
> +}
> +
> +static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
> +{
> +	return daddr;
> +}
> +
> +static inline dma_addr_t phys_to_dma_unencrypted(struct device *dev,
> +						 phys_addr_t paddr)
> +{
> +	return dma_addr_unencrypted(__phys_to_dma(dev, paddr));
> +}
> +
> +#define phys_to_dma_unencrypted phys_to_dma_unencrypted
> +
> +#endif /* ASM_X86_DMA_DIRECT_H */


