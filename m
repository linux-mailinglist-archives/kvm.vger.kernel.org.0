Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A41C6F8517
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 16:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbjEEOyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 10:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbjEEOyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 10:54:03 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 108A615EE8;
        Fri,  5 May 2023 07:54:01 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E628C1FB;
        Fri,  5 May 2023 07:54:45 -0700 (PDT)
Received: from [10.57.81.246] (unknown [10.57.81.246])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 055803F5A1;
        Fri,  5 May 2023 07:53:58 -0700 (PDT)
Message-ID: <8eab6d63-1fa1-704f-279b-83b2df7fa808@arm.com>
Date:   Fri, 5 May 2023 15:53:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 1/3] iommu/dma: Clean up Kconfig
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     joro@8bytes.org, will@kernel.org, catalin.marinas@arm.com,
        jean-philippe@linaro.org, inki.dae@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        tglx@linutronix.de, maz@kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, iommu@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <cover.1660668998.git.robin.murphy@arm.com>
 <2e33c8bc2b1bb478157b7964bfed976cb7466139.1660668998.git.robin.murphy@arm.com>
 <ZFUXmH9vndGZFuPr@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <ZFUXmH9vndGZFuPr@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-05-05 15:50, Jason Gunthorpe wrote:
> On Tue, Aug 16, 2022 at 06:28:03PM +0100, Robin Murphy wrote:
>> Although iommu-dma is a per-architecture chonce, that is currently
>> implemented in a rather haphazard way. Selecting from the arch Kconfig
>> was the original logical approach, but is complicated by having to
>> manage dependencies; conversely, selecting from drivers ends up hiding
>> the architecture dependency *too* well. Instead, let's just have it
>> enable itself automatically when IOMMU API support is enabled for the
>> relevant architectures. It can't get much clearer than that.
>>
>> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
>> ---
>>   arch/arm64/Kconfig          | 1 -
>>   drivers/iommu/Kconfig       | 3 +--
>>   drivers/iommu/amd/Kconfig   | 1 -
>>   drivers/iommu/intel/Kconfig | 1 -
>>   4 files changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 571cc234d0b3..59af600445c2 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -209,7 +209,6 @@ config ARM64
>>   	select HAVE_KPROBES
>>   	select HAVE_KRETPROBES
>>   	select HAVE_GENERIC_VDSO
>> -	select IOMMU_DMA if IOMMU_SUPPORT
>>   	select IRQ_DOMAIN
>>   	select IRQ_FORCED_THREADING
>>   	select KASAN_VMALLOC if KASAN
>> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
>> index 5c5cb5bee8b6..1d99c2d984fb 100644
>> --- a/drivers/iommu/Kconfig
>> +++ b/drivers/iommu/Kconfig
>> @@ -137,7 +137,7 @@ config OF_IOMMU
>>   
>>   # IOMMU-agnostic DMA-mapping layer
>>   config IOMMU_DMA
>> -	bool
>> +	def_bool ARM64 || IA64 || X86
> 
> Robin, do you remember why you added IA64 here? What is the Itanimum
> IOMMU driver?

config INTEL_IOMMU
	bool "Support for Intel IOMMU using DMA Remapping Devices"
	depends on PCI_MSI && ACPI && (X86 || IA64)

Yes, really :)

Robin.
