Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1463D797A49
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 19:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjIGRfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 13:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237629AbjIGRfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 13:35:45 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7451BF3;
        Thu,  7 Sep 2023 10:35:21 -0700 (PDT)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by gandalf.ozlabs.org (Postfix) with ESMTP id 4RhRFc35kGz4wb5;
        Fri,  8 Sep 2023 03:34:44 +1000 (AEST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RhRFX1FY6z4wZp;
        Fri,  8 Sep 2023 03:34:39 +1000 (AEST)
Message-ID: <010263ba-9740-4bcf-7af6-37e33e4612c0@kaod.org>
Date:   Thu, 7 Sep 2023 19:34:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH V7 vfio 07/10] vfio/mlx5: Create and destroy page tracker
 object
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com,
        'Avihai Horon' <avihaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
 <20220908183448.195262-8-yishaih@nvidia.com>
 <9a4ddb8c-a48a-67b0-b8ad-428ee936454e@kaod.org> <ZPhnvqmvdeBMzafd@nvidia.com>
 <97d88872-e3c8-74f8-d93c-4368393ad0a5@kaod.org>
 <a8eceae4-84a5-06c4-29c3-5769d6f122ce@oracle.com>
 <c62b99f8-39d2-0479-34a8-c87ed8fc9b22@kaod.org>
 <6959f434-65bf-8363-a353-2637a561d35c@oracle.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <6959f434-65bf-8363-a353-2637a561d35c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/7/23 18:33, Joao Martins wrote:
> On 07/09/2023 13:16, Cédric Le Goater wrote:
>> On 9/7/23 12:51, Joao Martins wrote:
>>> On 07/09/2023 10:56, Cédric Le Goater wrote:
>>>> On 9/6/23 13:51, Jason Gunthorpe wrote:
>>>>> On Wed, Sep 06, 2023 at 10:55:26AM +0200, Cédric Le Goater wrote:
>>>>>
>>>>>>> +    WARN_ON(node);
>>>>>>> +    log_addr_space_size = ilog2(total_ranges_len);
>>>>>>> +    if (log_addr_space_size <
>>>>>>> +        (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_min_addr_space)) ||
>>>>>>> +        log_addr_space_size >
>>>>>>> +        (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_addr_space))) {
>>>>>>> +        err = -EOPNOTSUPP;
>>>>>>> +        goto out;
>>>>>>> +    }
>>>>>>
>>>>>>
>>>>>> We are seeing an issue with dirty page tracking when doing migration
>>>>>> of an OVMF VM guest. The vfio-pci variant driver for the MLX5 VF
>>>>>> device complains when dirty page tracking is initialized from QEMU :
>>>>>>
>>>>>>      qemu-kvm: 0000:b1:00.2: Failed to start DMA logging, err -95 (Operation
>>>>>> not supported)
>>>>>>
>>>>>> The 64-bit computed range is  :
>>>>>>
>>>>>>      vfio_device_dirty_tracking_start nr_ranges 2 32:[0x0 - 0x807fffff],
>>>>>> 64:[0x100000000 - 0x3838000fffff]
>>>>>>
>>>>>> which seems to be too large for the HW. AFAICT, the MLX5 HW has a 42
>>>>>> bits address space limitation for dirty tracking (min is 12). Is it a
>>>>>> FW tunable or a strict limitation ?
>>>>>
>>>>> It would be good to explain where this is coming from, all devices
>>>>> need to make some decision on what address space ranges to track and I
>>>>> would say 2^42 is already pretty generous limit..
>>>>
>>>>
>>>> QEMU computes the DMA logging ranges for two predefined ranges: 32-bit
>>>> and 64-bit. In the OVMF case, QEMU includes in the 64-bit range, RAM
>>>> (at the lower part) and device RAM regions (at the top of the address
>>>> space). The size of that range can be bigger than the 2^42 limit of
>>>> the MLX5 HW for dirty tracking. QEMU is not making much effort to be
>>>> smart. There is room for improvement.
>>>>
>>>
>>> Interesting, we haven't reproduced this in our testing with OVMF multi-TB
>>> configs with these VFs. Could you share the OVMF base version you were using?
>>
>> edk2-ovmf-20230524-3.el9.noarch
>>
>> host is a :
>>          Architecture:            x86_64
>>        CPU op-mode(s):        32-bit, 64-bit
>>        Address sizes:         46 bits physical, 57 bits virtual
>>        Byte Order:            Little Endian
>>      CPU(s):                  48
>>        On-line CPU(s) list:   0-47
>>      Vendor ID:               GenuineIntel
>>        Model name:            Intel(R) Xeon(R) Silver 4310 CPU @ 2.10GHz
>>
>>
>>> or
>>> maybe we didn't triggered it considering the total device RAM regions would be
>>> small enough to fit the 32G PCI hole64 that is advertised that avoids a
>>> hypothetical relocation.
>>
>> You need RAM above 4G in the guest :
>>          100000000-27fffffff : System RAM
>>        237800000-2387fffff : Kernel code
>>        238800000-23932cfff : Kernel rodata
>>        239400000-239977cff : Kernel data
>>        23a202000-23b3fffff : Kernel bss
>>      380000000000-3807ffffffff : PCI Bus 0000:00
>>        380000000000-3800000fffff : 0000:00:03.0
>>          380000000000-3800000fffff : mlx5_core
> 
> Similar machine to yours, but in my 32G guests with older OVMF it's putting the
> PCI area after max-ram:
> 
> vfio_device_dirty_tracking_update section 0x0 - 0x9ffff -> update [0x0 - 0x9ffff]
> vfio_device_dirty_tracking_update section 0xc0000 - 0xcafff -> update [0x0 -
> 0xcafff]
> vfio_device_dirty_tracking_update section 0xcb000 - 0xcdfff -> update [0x0 -
> 0xcdfff]
> vfio_device_dirty_tracking_update section 0xce000 - 0xe7fff -> update [0x0 -
> 0xe7fff]
> vfio_device_dirty_tracking_update section 0xe8000 - 0xeffff -> update [0x0 -
> 0xeffff]
> vfio_device_dirty_tracking_update section 0xf0000 - 0xfffff -> update [0x0 -
> 0xfffff]
> vfio_device_dirty_tracking_update section 0x100000 - 0x7fffffff -> update [0x0 -
> 0x7fffffff]
> vfio_device_dirty_tracking_update section 0xfd000000 - 0xfdffffff -> update [0x0
> - 0xfdffffff]
> vfio_device_dirty_tracking_update section 0xfffc0000 - 0xffffffff -> update [0x0
> - 0xffffffff]
> vfio_device_dirty_tracking_update section 0x100000000 - 0x87fffffff -> update
> [0x100000000 - 0x87fffffff]
> vfio_device_dirty_tracking_update section 0x880000000 - 0x880001fff -> update
> [0x100000000 - 0x880001fff]
> vfio_device_dirty_tracking_update section 0x880003000 - 0x8ffffffff -> update
> [0x100000000 - 0x8ffffffff]
> 

and so the range is smaller.

The latest version of OVMF enables the dynamic mmio window which causes the issue.

>>
>> Activating the QEMU trace events shows quickly the issue :
>>
>>      vfio_device_dirty_tracking_update section 0x0 - 0x9ffff -> update [0x0 -
>> 0x9ffff]
>>      vfio_device_dirty_tracking_update section 0xa0000 - 0xaffff -> update [0x0 -
>> 0xaffff]
>>      vfio_device_dirty_tracking_update section 0xc0000 - 0xc3fff -> update [0x0 -
>> 0xc3fff]
>>      vfio_device_dirty_tracking_update section 0xc4000 - 0xdffff -> update [0x0 -
>> 0xdffff]
>>      vfio_device_dirty_tracking_update section 0xe0000 - 0xfffff -> update [0x0 -
>> 0xfffff]
>>      vfio_device_dirty_tracking_update section 0x100000 - 0x7fffffff -> update
>> [0x0 - 0x7fffffff]
>>      vfio_device_dirty_tracking_update section 0x80000000 - 0x807fffff -> update
>> [0x0 - 0x807fffff]
>>      vfio_device_dirty_tracking_update section 0x100000000 - 0x27fffffff ->
>> update [0x100000000 - 0x27fffffff]
>>      vfio_device_dirty_tracking_update section 0x383800000000 - 0x383800001fff ->
>> update [0x100000000 - 0x383800001fff]
>>      vfio_device_dirty_tracking_update section 0x383800003000 - 0x3838000fffff ->
>> update [0x100000000 - 0x3838000fffff]
>>
>> So that's nice. And with less RAM in the VM, 2G, migration should work though.
>>
>>> We could use do more than 2 ranges (or going back to sharing all ranges), or add
>>> a set of ranges that represents the device RAM without computing a min/max there
>>> (not sure we can figure that out from within the memory listener does all this
>>> logic);
>>
>> The listener is container based. May we could add one range per device
>> if we can identify a different owner per memory section.
>>
> 
> For brainstorm purposes ... Maybe something like this below. Should make your
> case work. As mentioned earlier in my case it's placed always at maxram+1, so
> makes no difference in having the "pci" range

yes.

That said, it looks good and it does handle the useless gap in the 64-bit range.
Thanks for doing it. We should explore the non OVMF case with this patch also.

C.


> 
> ------>8-------
> From: Joao Martins <joao.m.martins@oracle.com>
> Date: Thu, 7 Sep 2023 09:23:38 -0700
> Subject: [PATCH] vfio/common: Separate vfio-pci ranges
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   hw/vfio/common.c     | 48 ++++++++++++++++++++++++++++++++++++++++----
>   hw/vfio/trace-events |  2 +-
>   2 files changed, 45 insertions(+), 5 deletions(-)
> 
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index f8b20aacc07c..f0b36a98c89a 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -27,6 +27,7 @@
> 
>   #include "hw/vfio/vfio-common.h"
>   #include "hw/vfio/vfio.h"
> +#include "hw/vfio/pci.h"
>   #include "exec/address-spaces.h"
>   #include "exec/memory.h"
>   #include "exec/ram_addr.h"
> @@ -1424,6 +1425,8 @@ typedef struct VFIODirtyRanges {
>       hwaddr max32;
>       hwaddr min64;
>       hwaddr max64;
> +    hwaddr minpci;
> +    hwaddr maxpci;
>   } VFIODirtyRanges;
> 
>   typedef struct VFIODirtyRangesListener {
> @@ -1432,6 +1435,31 @@ typedef struct VFIODirtyRangesListener {
>       MemoryListener listener;
>   } VFIODirtyRangesListener;
> 
> +static bool vfio_section_is_vfio_pci(MemoryRegionSection *section,
> +                                     VFIOContainer *container)
> +{
> +    VFIOPCIDevice *pcidev;
> +    VFIODevice *vbasedev;
> +    VFIOGroup *group;
> +    Object *owner;
> +
> +    owner = memory_region_owner(section->mr);
> +
> +    QLIST_FOREACH(group, &container->group_list, container_next) {
> +        QLIST_FOREACH(vbasedev, &group->device_list, next) {
> +            if (vbasedev->type != VFIO_DEVICE_TYPE_PCI) {
> +                continue;
> +            }
> +            pcidev = container_of(vbasedev, VFIOPCIDevice, vbasedev);
> +            if (OBJECT(pcidev) == owner) {
> +                return true;
> +            }
> +        }
> +    }
> +
> +    return false;
> +}
> +
>   static void vfio_dirty_tracking_update(MemoryListener *listener,
>                                          MemoryRegionSection *section)
>   {
> @@ -1458,8 +1486,13 @@ static void vfio_dirty_tracking_update(MemoryListener
> *listener,
>        * would be an IOVATree but that has a much bigger runtime overhead and
>        * unnecessary complexity.
>        */
> -    min = (end <= UINT32_MAX) ? &range->min32 : &range->min64;
> -    max = (end <= UINT32_MAX) ? &range->max32 : &range->max64;
> +    if (!vfio_section_is_vfio_pci(section, dirty->container)) {
> +        min = (end <= UINT32_MAX) ? &range->min32 : &range->min64;
> +        max = (end <= UINT32_MAX) ? &range->max32 : &range->max64;
> +    } else {
> +        min = &range->minpci;
> +        max = &range->maxpci;
> +    }
> 
>       if (*min > iova) {
>           *min = iova;
> @@ -1485,6 +1518,7 @@ static void vfio_dirty_tracking_init(VFIOContainer *container,
>       memset(&dirty, 0, sizeof(dirty));
>       dirty.ranges.min32 = UINT32_MAX;
>       dirty.ranges.min64 = UINT64_MAX;
> +    dirty.ranges.minpci = UINT64_MAX;
>       dirty.listener = vfio_dirty_tracking_listener;
>       dirty.container = container;
> 
> @@ -1555,7 +1589,7 @@ vfio_device_feature_dma_logging_start_create(VFIOContainer
> *container,
>        * DMA logging uAPI guarantees to support at least a number of ranges that
>        * fits into a single host kernel base page.
>        */
> -    control->num_ranges = !!tracking->max32 + !!tracking->max64;
> +    control->num_ranges = !!tracking->max32 + !!tracking->max64 +
> !!tracking->maxpci;
>       ranges = g_try_new0(struct vfio_device_feature_dma_logging_range,
>                           control->num_ranges);
>       if (!ranges) {
> @@ -1574,11 +1608,17 @@
> vfio_device_feature_dma_logging_start_create(VFIOContainer *container,
>       if (tracking->max64) {
>           ranges->iova = tracking->min64;
>           ranges->length = (tracking->max64 - tracking->min64) + 1;
> +        ranges++;
> +    }
> +    if (tracking->maxpci) {
> +        ranges->iova = tracking->minpci;
> +        ranges->length = (tracking->maxpci - tracking->minpci) + 1;
>       }
> 
>       trace_vfio_device_dirty_tracking_start(control->num_ranges,
>                                              tracking->min32, tracking->max32,
> -                                           tracking->min64, tracking->max64);
> +                                           tracking->min64, tracking->max64,
> +                                           tracking->minpci, tracking->maxpci);
> 
>       return feature;
>   }
> diff --git a/hw/vfio/trace-events b/hw/vfio/trace-events
> index 444c15be47ee..ee5a44893334 100644
> --- a/hw/vfio/trace-events
> +++ b/hw/vfio/trace-events
> @@ -104,7 +104,7 @@ vfio_known_safe_misalignment(const char *name, uint64_t
> iova, uint64_t offset_wi
>   vfio_listener_region_add_no_dma_map(const char *name, uint64_t iova, uint64_t
> size, uint64_t page_size) "Region \"%s\" 0x%"PRIx64" size=0x%"PRIx64" is not
> aligned to 0x%"PRIx64" and cannot be mapped for DMA"
>   vfio_listener_region_del(uint64_t start, uint64_t end) "region_del 0x%"PRIx64"
> - 0x%"PRIx64
>   vfio_device_dirty_tracking_update(uint64_t start, uint64_t end, uint64_t min,
> uint64_t max) "section 0x%"PRIx64" - 0x%"PRIx64" -> update [0x%"PRIx64" -
> 0x%"PRIx64"]"
> -vfio_device_dirty_tracking_start(int nr_ranges, uint64_t min32, uint64_t max32,
> uint64_t min64, uint64_t max64) "nr_ranges %d 32:[0x%"PRIx64" - 0x%"PRIx64"],
> 64:[0x%"PRIx64" - 0x%"PRIx64"]"
> +vfio_device_dirty_tracking_start(int nr_ranges, uint64_t min32, uint64_t max32,
> uint64_t min64, uint64_t max64, uint64_t minpci, uint64_t maxpci) "nr_ranges %d
> 32:[0x%"PRIx64" - 0x%"PRIx64"], 64:[0x%"PRIx64" - 0x%"PRIx64"], pci:[0x%"PRIx64"
> - 0x%"PRIx64"]"
>   vfio_disconnect_container(int fd) "close container->fd=%d"
>   vfio_put_group(int fd) "close group->fd=%d"
>   vfio_get_device(const char * name, unsigned int flags, unsigned int
> num_regions, unsigned int num_irqs) "Device %s flags: %u, regions: %u, irqs: %u"
> --
> 2.39.3
> 

