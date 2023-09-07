Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE858797941
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 19:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbjIGRJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 13:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240512AbjIGRJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 13:09:07 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866C51BF;
        Thu,  7 Sep 2023 10:08:39 -0700 (PDT)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by gandalf.ozlabs.org (Postfix) with ESMTP id 4RhF4X59Sdz4x5x;
        Thu,  7 Sep 2023 19:56:12 +1000 (AEST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RhF4S0FX0z4x5n;
        Thu,  7 Sep 2023 19:56:07 +1000 (AEST)
Message-ID: <97d88872-e3c8-74f8-d93c-4368393ad0a5@kaod.org>
Date:   Thu, 7 Sep 2023 11:56:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH V7 vfio 07/10] vfio/mlx5: Create and destroy page tracker
 object
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, joao.m.martins@oracle.com,
        leonro@nvidia.com, maorg@nvidia.com, cohuck@redhat.com,
        'Avihai Horon' <avihaih@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
 <20220908183448.195262-8-yishaih@nvidia.com>
 <9a4ddb8c-a48a-67b0-b8ad-428ee936454e@kaod.org> <ZPhnvqmvdeBMzafd@nvidia.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <ZPhnvqmvdeBMzafd@nvidia.com>
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

On 9/6/23 13:51, Jason Gunthorpe wrote:
> On Wed, Sep 06, 2023 at 10:55:26AM +0200, Cédric Le Goater wrote:
> 
>>> +	WARN_ON(node);
>>> +	log_addr_space_size = ilog2(total_ranges_len);
>>> +	if (log_addr_space_size <
>>> +	    (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_min_addr_space)) ||
>>> +	    log_addr_space_size >
>>> +	    (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_addr_space))) {
>>> +		err = -EOPNOTSUPP;
>>> +		goto out;
>>> +	}
>>
>>
>> We are seeing an issue with dirty page tracking when doing migration
>> of an OVMF VM guest. The vfio-pci variant driver for the MLX5 VF
>> device complains when dirty page tracking is initialized from QEMU :
>>
>>    qemu-kvm: 0000:b1:00.2: Failed to start DMA logging, err -95 (Operation not supported)
>>
>> The 64-bit computed range is  :
>>
>>    vfio_device_dirty_tracking_start nr_ranges 2 32:[0x0 - 0x807fffff], 64:[0x100000000 - 0x3838000fffff]
>>
>> which seems to be too large for the HW. AFAICT, the MLX5 HW has a 42
>> bits address space limitation for dirty tracking (min is 12). Is it a
>> FW tunable or a strict limitation ?
> 
> It would be good to explain where this is coming from, all devices
> need to make some decision on what address space ranges to track and I
> would say 2^42 is already pretty generous limit..


QEMU computes the DMA logging ranges for two predefined ranges: 32-bit
and 64-bit. In the OVMF case, QEMU includes in the 64-bit range, RAM
(at the lower part) and device RAM regions (at the top of the address
space). The size of that range can be bigger than the 2^42 limit of
the MLX5 HW for dirty tracking. QEMU is not making much effort to be
smart. There is room for improvement.


> Can we go the other direction and reduce the ranges qemu is interested
> in?


We can not exclude the device RAM regions since we don't know what
the HW could do with them. Correct me here. But we can certainly
avoid the huge gap in the 64-bit range by adding support for more
than 2 ranges in QEMU.

Then, if the overall size exceeds what HW supports, the vfio-pci
variant driver will report an error, as of today.

Thanks,

C.
