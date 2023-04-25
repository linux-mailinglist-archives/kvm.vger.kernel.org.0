Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13AC6EE439
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 16:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbjDYOs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 10:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbjDYOs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 10:48:28 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1DF87EE1
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 07:48:18 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9646A4B3;
        Tue, 25 Apr 2023 07:49:02 -0700 (PDT)
Received: from [10.1.39.54] (010265703453.arm.com [10.1.39.54])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B756F3F587;
        Tue, 25 Apr 2023 07:48:17 -0700 (PDT)
Message-ID: <a2616348-3517-27a7-17a0-6628b56f6fad@arm.com>
Date:   Tue, 25 Apr 2023 15:48:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Robin Murphy <robin.murphy@arm.com>
Subject: Re: RMRR device on non-Intel platform
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com> <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
 <ZEKFdJ6yXoyFiHY+@nvidia.com> <fe7e20e5-9729-248d-ee03-c8b444a1b7c0@arm.com>
 <ZELOqZliiwbG6l5K@nvidia.com>
Content-Language: en-GB
In-Reply-To: <ZELOqZliiwbG6l5K@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-04-21 18:58, Jason Gunthorpe wrote:
> On Fri, Apr 21, 2023 at 06:22:37PM +0100, Robin Murphy wrote:
> 
>> I think a slightly more considered and slightly less wrong version of that
>> idea is to mark it as IOMMU_RESV_MSI, and special-case direct-mapping those
>> on Arm (I believe it would technically be benign to do on x86 too, but might
>> annoy people with its pointlessness). However...
> 
> I'd rather have a IOMMU_RESV_MSI_DIRECT and put the ARM special case
> in ARM code..

Maybe, but it's still actually broken either way, because how do you get 
that type into the VM? Firmware can't encode that a particular RMR 
represents the special magic hack for IOMMUFD, so now the SMMU driver 
needs to somehow be aware when it's running in a VM offering nested 
translation and do some more magic to inject the appropriate region, and 
it's all just... no.

>>> On baremetal we have no idea what the platform put under that
>>> hardcoded address?
>>>
>>> On VM we don't use the iommu_get_msi_cookie() flow because the GIC in
>>> the VM pretends it doesn't have an ITS page?  (did I get that right?)
>>
>> No, that can't be right - PCIe devices have to support MSI or MSI-X, and
>> many of them won't support INTx at all, so if the guest wants to use
>> interrupts in general it must surely need to believe it has some kind of MSI
>> controller,
> 
> Yes..
> 
>> which for practical purposes in this context means an ITS.
> 
> I haven't delved into it super detail, but.. my impression was..
> 
> The ITS page only becomes relavent to the IOMMU layer if the actual
> IRQ driver calls iommu_dma_prepare_msi()
> 
> And we have only these drivers that do so:
> 
> drivers/irqchip/irq-gic-v2m.c:  err = iommu_dma_prepare_msi(info->desc,
> drivers/irqchip/irq-gic-v3-its.c:       err = iommu_dma_prepare_msi(info->desc, its->get_msi_base(its_dev));
> drivers/irqchip/irq-gic-v3-mbi.c:       err = iommu_dma_prepare_msi(info->desc,
> drivers/irqchip/irq-ls-scfg-msi.c:      err = iommu_dma_prepare_msi(info->desc, msi_data->msiir_addr);
> 
> While, I *thought* that the vGIC in ARM uses
> 
> drivers/irqchip/irq-gic-v4.c
> 
> Which doesn't obviously call iommu_dma_prepare_msi() ?
> 
> So while the SMMU driver will stick in a IOMMU_RESV_SW_MSI, and
> iommufd will call iommu_get_msi_cookie(), there is no matching call
> of iommu_dma_prepare_msi() - so it all effectively does nothing.
> 
> Instead, again from what I understood, is that the IOMMU layer is
> expected to install the ITS page, not knowing it is an ITS page,
> because the ACPI creates a IOMMU_RESV_DIRECT.
> 
> When the VM writes it totally-a-lie MSI address to the PCI MSI-X
> registers the hypervisor traps it and subsitutes, what it valiantly
> hopes, is the right address for the ITS in the VM's S1 IOMMU table
> based on the ACPI where it nicely asked the guest to keep this
> specific IOVA mapped.
> 
> I'm not sure how the data bit works on ARM..
> 
>> was the next thing I started wondering after the above - if the aim is to
>> direct-map the host's SW_MSI region to effectively pass through the S2 MSI
>> cookie, but you have the same Linux SMMU driver in the guest, isn't that
>> guest driver still going to add a conflicting SW_MSI region for the same
>> IOVA and confuse things?
> 
> Oh probably yes. At least from iommufd perspective, it can resolve
> overlapping regions just fine though.
> 
>> Ideally for nesting, the VMM would just tell us the IPA of where it's going
>> to claim the given device's associated MSI doorbell is, we map that to the
>> real underlying address at S2, then the guest can use its S1 cookie as
>> normal if it wants to, and the host doesn't have to rewrite addresses either
>> way.
> 
> Goodness yes, I'd love that.
> 
>> that the nesting usage model inherently constrains the VMM's options for
>> emulating the IOMMU, would it be unreasonable to make our lives a lot easier
>> with some similar constraints around interrupts, and just not attempt to
>> support the full gamut of "emulate any kind of IRQ with any other kind of
>> IRQ" irqfd hilarity?
> 
> Isn't that what GICv4 is?

That would fit *part* of the GICv4 usage model...

> Frankly, I think something whent wrong with the GICv4 design. A purely
> virtualization focused GIC should not have continued to rely on the
> hypervisor trapping of the MSI-X writes. The guest should have had a
> real data value and a real physical ITS page.

...I believe the remaining missing part is a UAPI for the VMM to ask the 
host kernel to configure a "physical" vLPI for a given device and 
EventID, at the point when its vITS emulation is handling the guest's 
configuration command. With that we would no longer have to rewrite the 
MSI payload either, so can avoid trapping the device's MSI-X capability 
at all, and the VM could actually have non-terrible interrupt performance.

> I can understand why we got here, because fixing *all* of that would
> be a big task and this is a small hack, but still... Yuk.
> 
> But that is a whole other journey. There is work afoot to standardize
> some things would make MSI-X trapping impossible and more solidly
> force this issue, so I'm just hoping to keep the current mess going
> as-is right now..

The thing is, though, this small hack is in fact just the tip of a large 
pile of small hacks across Linux and QEMU that probably add up to a 
similar amount of work overall as just implementing the interface that 
we'd ultimately want to have anyway.

>>>> MSI regions already represent "safe" direct mappings, either as an inherent
>>>> property of the hardware, or with an actual mapping maintained by software.
>>>> Also RELAXABLE is meant to imply that it is only needed until a driver takes
>>>> over the device, which at face value doesn't make much sense for interrupts.
>>>
>>> I used "relxable" to suggest it is safe for userspace.
>>
>> I know, but the subtlety is the reason *why* it's safe for userspace. Namely
>> that a VFIO driver has bound and reset (or at least taken control of) the
>> device, and thus it is assumed to no longer be doing whatever the boot
>> firmware left it doing, therefore the reserved region is assumed to no
>> longer be relevant, and from then on the requirement to preserve it can be
>> relaxed.
> 
> IOMMU_RESV_MSI_DIRECT is probably the better name
> 
>>>           unsigned long pg_size;
>>>           int ret = 0;
>>> -       if (!iommu_is_dma_domain(domain))
>>> -               return 0;
>>> -
>>>           BUG_ON(!domain->pgsize_bitmap);
>>>           pg_size = 1UL << __ffs(domain->pgsize_bitmap);
>>
>> But then you realise that you also need to juggle this around since identity
>> domains aren't required to have a valid pgsize_bitmap either, give up on the
>> idea and go straight to writing a dedicated loop as the clearer and tidier
>> option because hey this is hardly a fast path anyway. At least, you do if
>> you're me :)
> 
> domain->pgsize_bitmap is always valid memory, and __ffs() always
> returns [0:31], so this caclculation will be fine but garbage.
> 
>>> @@ -1052,13 +1049,18 @@ static int iommu_create_device_direct_mappings(struct i>
>>>                   dma_addr_t start, end, addr;
>>>                   size_t map_size = 0;
>>> -               start = ALIGN(entry->start, pg_size);
>>> -               end   = ALIGN(entry->start + entry->length, pg_size);
>>> -
>>>                   if (entry->type != IOMMU_RESV_DIRECT &&
>>>                       entry->type != IOMMU_RESV_DIRECT_RELAXABLE)
>>>                           continue;
>>> +               if (entry->type == IOMMU_RESV_DIRECT)
>>> +                       dev->iommu->requires_direct = 1;
>>> +
>>> +               if (!iommu_is_dma_domain(domain))
>>> +                       continue;
>>> +
>>> +               start = ALIGN(entry->start, pg_size);
>>> +               end   = ALIGN(entry->start + entry->length, pg_size);
> 
> Which is why I moved the only reader of pg_size after the check if it
> is valid..

Except GCC says __builtin_ctzl(0) is undefined, so although I'd concur 
that the chances of nasal demons at the point of invoking __ffs() are 
realistically quite low, I don't fancy arguing that with the static 
checker brigade. So by the time we've appeased them with additional 
checks, initialisations, etc., we'd have basically the same overhead as 
running 0 iterations of another for loop (the overwhelmingly common case 
anyway), but in more lines of code, with a more convoluted flow. All of 
which leads me to conclude that "number of times we walk a usually-empty 
list in a one-off slow path" is not in fact the most worthwhile thing to 
optimise for ;)

Cheers,
Robin.
