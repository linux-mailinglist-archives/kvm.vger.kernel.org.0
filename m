Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688FB36E8C7
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 12:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbhD2Kcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 06:32:46 -0400
Received: from foss.arm.com ([217.140.110.172]:46416 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232629AbhD2Kcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 06:32:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA2911FB;
        Thu, 29 Apr 2021 03:31:59 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67D8F3F70D;
        Thu, 29 Apr 2021 03:31:58 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Skip CMOs when updating a PTE pointing to
 non-memory
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, Krishna Reddy <vdumpa@nvidia.com>,
        Sumit Gupta <sumitg@nvidia.com>
References: <20210426103605.616908-1-maz@kernel.org>
 <e6d955f1-f2a4-9505-19ab-5a770f821386@arm.com> <YIgsbp/hRxM9U+ZN@myrica>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <35d5f174-3814-a019-a6e3-14cffad69763@arm.com>
Date:   Thu, 29 Apr 2021 11:32:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YIgsbp/hRxM9U+ZN@myrica>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

On 4/27/21 4:23 PM, Jean-Philippe Brucker wrote:
> On Tue, Apr 27, 2021 at 03:52:46PM +0100, Alexandru Elisei wrote:
>> The comment [1] suggested that the panic is triggered during page aging.
> I think only with an out-of-tree patch applied
> https://jpbrucker.net/git/linux/commit/?h=sva/2021-03-01&id=d32d8baaf293aaefef8a1c9b8a4508ab2ec46c61
> which probably is not going upstream.

Thanks for that, that explains why I wasn't able to trigger the notification.

I did a grep for all the places where mmu_notifier_change_pte() and
set_pte_at_notify() are used in the kernel, and from what I can tell they are only
called for a new pte which has a struct page. From my investigation, the notifiers
are called from ksm (which deals with physical memory), swap migration (so still
pages in memory) and on copy-on-write.

On Linux v5.12, I tried to trigger the copy-on-write notification by forking
kvmtool right after the BAR region is mapped and then reading from the userspace
BAR address, but the new pte (for which the notifier is called) is valid.

I also looked at what x86 does, but I couldn't find where cache maintenance is
performed (wouldn't surprise me if it's not necessary at all).

So I guess my question is what kind of pfns the MMU notifiers for the secondary
MMUs are required to handle. If the requirement is that they should handle both
device and struct page backed pfns, then the patch looks correct to me
(user_mem_abort() also uses kvm_is_device_pfn() to decide if dcache maintenance is
needed).

Thanks,

Alex

> Thanks,
> Jean
>
>> vfio_pci_mmap() sets the VM_PFNMAP for the VMA and I see in the Documentation that
>> pages with VM_PFNMAP are added to the unevictable LRU list, doesn't that mean it's
>> not subject the page aging? I feel like there's something I'm missing.
>>
>> [1]
>> https://lore.kernel.org/kvm/BY5PR12MB37642B9AC7E5D907F5A664F6B3459@BY5PR12MB3764.namprd12.prod.outlook.com/
>>
>> Thanks,
>>
>> Alex
