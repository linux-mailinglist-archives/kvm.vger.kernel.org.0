Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F43779793F
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 19:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240517AbjIGRJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 13:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240554AbjIGRJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 13:09:06 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2721705;
        Thu,  7 Sep 2023 10:08:36 -0700 (PDT)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by gandalf.ozlabs.org (Postfix) with ESMTP id 4RhJB63ZKBz4x80;
        Thu,  7 Sep 2023 22:16:14 +1000 (AEST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RhJB21ZGXz4x5t;
        Thu,  7 Sep 2023 22:16:09 +1000 (AEST)
Message-ID: <c62b99f8-39d2-0479-34a8-c87ed8fc9b22@kaod.org>
Date:   Thu, 7 Sep 2023 14:16:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH V7 vfio 07/10] vfio/mlx5: Create and destroy page tracker
 object
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com,
        'Avihai Horon' <avihaih@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
 <20220908183448.195262-8-yishaih@nvidia.com>
 <9a4ddb8c-a48a-67b0-b8ad-428ee936454e@kaod.org> <ZPhnvqmvdeBMzafd@nvidia.com>
 <97d88872-e3c8-74f8-d93c-4368393ad0a5@kaod.org>
 <a8eceae4-84a5-06c4-29c3-5769d6f122ce@oracle.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <a8eceae4-84a5-06c4-29c3-5769d6f122ce@oracle.com>
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

On 9/7/23 12:51, Joao Martins wrote:
> On 07/09/2023 10:56, Cédric Le Goater wrote:
>> On 9/6/23 13:51, Jason Gunthorpe wrote:
>>> On Wed, Sep 06, 2023 at 10:55:26AM +0200, Cédric Le Goater wrote:
>>>
>>>>> +    WARN_ON(node);
>>>>> +    log_addr_space_size = ilog2(total_ranges_len);
>>>>> +    if (log_addr_space_size <
>>>>> +        (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_min_addr_space)) ||
>>>>> +        log_addr_space_size >
>>>>> +        (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_addr_space))) {
>>>>> +        err = -EOPNOTSUPP;
>>>>> +        goto out;
>>>>> +    }
>>>>
>>>>
>>>> We are seeing an issue with dirty page tracking when doing migration
>>>> of an OVMF VM guest. The vfio-pci variant driver for the MLX5 VF
>>>> device complains when dirty page tracking is initialized from QEMU :
>>>>
>>>>     qemu-kvm: 0000:b1:00.2: Failed to start DMA logging, err -95 (Operation
>>>> not supported)
>>>>
>>>> The 64-bit computed range is  :
>>>>
>>>>     vfio_device_dirty_tracking_start nr_ranges 2 32:[0x0 - 0x807fffff],
>>>> 64:[0x100000000 - 0x3838000fffff]
>>>>
>>>> which seems to be too large for the HW. AFAICT, the MLX5 HW has a 42
>>>> bits address space limitation for dirty tracking (min is 12). Is it a
>>>> FW tunable or a strict limitation ?
>>>
>>> It would be good to explain where this is coming from, all devices
>>> need to make some decision on what address space ranges to track and I
>>> would say 2^42 is already pretty generous limit..
>>
>>
>> QEMU computes the DMA logging ranges for two predefined ranges: 32-bit
>> and 64-bit. In the OVMF case, QEMU includes in the 64-bit range, RAM
>> (at the lower part) and device RAM regions (at the top of the address
>> space). The size of that range can be bigger than the 2^42 limit of
>> the MLX5 HW for dirty tracking. QEMU is not making much effort to be
>> smart. There is room for improvement.
>>
> 
> Interesting, we haven't reproduced this in our testing with OVMF multi-TB
> configs with these VFs. Could you share the OVMF base version you were using? 

edk2-ovmf-20230524-3.el9.noarch

host is a :
     
     Architecture:            x86_64
       CPU op-mode(s):        32-bit, 64-bit
       Address sizes:         46 bits physical, 57 bits virtual
       Byte Order:            Little Endian
     CPU(s):                  48
       On-line CPU(s) list:   0-47
     Vendor ID:               GenuineIntel
       Model name:            Intel(R) Xeon(R) Silver 4310 CPU @ 2.10GHz


> or
> maybe we didn't triggered it considering the total device RAM regions would be
> small enough to fit the 32G PCI hole64 that is advertised that avoids a
> hypothetical relocation.

You need RAM above 4G in the guest :
     
     100000000-27fffffff : System RAM
       237800000-2387fffff : Kernel code
       238800000-23932cfff : Kernel rodata
       239400000-239977cff : Kernel data
       23a202000-23b3fffff : Kernel bss
     380000000000-3807ffffffff : PCI Bus 0000:00
       380000000000-3800000fffff : 0000:00:03.0
         380000000000-3800000fffff : mlx5_core

Activating the QEMU trace events shows quickly the issue :

     vfio_device_dirty_tracking_update section 0x0 - 0x9ffff -> update [0x0 - 0x9ffff]
     vfio_device_dirty_tracking_update section 0xa0000 - 0xaffff -> update [0x0 - 0xaffff]
     vfio_device_dirty_tracking_update section 0xc0000 - 0xc3fff -> update [0x0 - 0xc3fff]
     vfio_device_dirty_tracking_update section 0xc4000 - 0xdffff -> update [0x0 - 0xdffff]
     vfio_device_dirty_tracking_update section 0xe0000 - 0xfffff -> update [0x0 - 0xfffff]
     vfio_device_dirty_tracking_update section 0x100000 - 0x7fffffff -> update [0x0 - 0x7fffffff]
     vfio_device_dirty_tracking_update section 0x80000000 - 0x807fffff -> update [0x0 - 0x807fffff]
     vfio_device_dirty_tracking_update section 0x100000000 - 0x27fffffff -> update [0x100000000 - 0x27fffffff]
     vfio_device_dirty_tracking_update section 0x383800000000 - 0x383800001fff -> update [0x100000000 - 0x383800001fff]
     vfio_device_dirty_tracking_update section 0x383800003000 - 0x3838000fffff -> update [0x100000000 - 0x3838000fffff]

So that's nice. And with less RAM in the VM, 2G, migration should work though.

> We could use do more than 2 ranges (or going back to sharing all ranges), or add
> a set of ranges that represents the device RAM without computing a min/max there
> (not sure we can figure that out from within the memory listener does all this
> logic); 

The listener is container based. May we could add one range per device
if we can identify a different owner per memory section.


C.

> it would perhaps a bit too BIOS specific if we start looking at specific
> parts of the address space (e.g. phys-bits-1) to compute these ranges.
> 
> 	Joao

