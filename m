Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739DE4CFEFD
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 13:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241381AbiCGMnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 07:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiCGMnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 07:43:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A47B84A90F
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 04:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646656938;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6eeNwR4loaBjjEP8RdScYzxO+RCd7H+nxGYKGNuzU6E=;
        b=dw84ZFNb5tcV1SoliwpyUPglSXvvdH1og+rRCgdVow+6jPbfU+PF0kzFUn96o/zL329fv+
        eCGQpWF39dD0qtIBos8xABj5AgMYi2cq65+B7uby44XS0fk2vRalRdlc7d60onLiZh57Mr
        TkNFiTJ4LH/HDWoQ4j92JMI1hhcWZzA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-Klx7oE8wMBKQl9JLVFj1jQ-1; Mon, 07 Mar 2022 07:42:16 -0500
X-MC-Unique: Klx7oE8wMBKQl9JLVFj1jQ-1
Received: by mail-wr1-f71.google.com with SMTP id a16-20020adff7d0000000b001f0473a6b25so4226947wrq.1
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 04:42:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=6eeNwR4loaBjjEP8RdScYzxO+RCd7H+nxGYKGNuzU6E=;
        b=2n+4/4K8+xBxetqTiXjjUvxY+5/0k+5XuWHSjiHNduWTy44PVjwLcTh57zMurF215t
         P52dgPZppqfjtv1nL9Bh5XZZPmSOnklZfZOn0yHI3E4qCdXPcvfmQg4P/8CdyYxZsyXJ
         X9M3BDYM7IfLV6RWw9Sf2QQAyMKLNa+nhwb2HzscpLk0YGrP9Kjb9KyOa9aP2hUSQ5QX
         eK/mgdt/L1gA0bMW9Eehd525moCKsuwag0Qgt5sy4EKCujxQmN4/A5NG76homfQ1+V4f
         0VF+BoH2kcidAamGtbZ5/Z9TABeDSAIP86qg3L1RfzKFlA3NLmKspv3loQ7jD/9scVPx
         q6Wg==
X-Gm-Message-State: AOAM531+v6UQmsivQk6IffdUrHTpV1oFkF8U9q/qypGBcM3eHsNfFi3f
        tUZvRpa1+stC8nmq2kkqHmdVbb3hzTcy3/EK2Dffsp3dkIV14TSTAUGF7Dcm1ceRKay2mOOfLqM
        BV0RUKOIONVt/
X-Received: by 2002:adf:dcc2:0:b0:1f0:4c38:d6be with SMTP id x2-20020adfdcc2000000b001f04c38d6bemr8115731wrm.79.1646656935523;
        Mon, 07 Mar 2022 04:42:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJypym0PVHFx9W4v/f24ImuL8HFKfTAheoICss9sCuocVDFJFJoyHsNopW+2XcaueuxzLmWzTA==
X-Received: by 2002:adf:dcc2:0:b0:1f0:4c38:d6be with SMTP id x2-20020adfdcc2000000b001f04c38d6bemr8115695wrm.79.1646656935224;
        Mon, 07 Mar 2022 04:42:15 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id v124-20020a1cac82000000b0037c3d08e0e7sm19689931wme.29.2022.03.07.04.42.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 04:42:14 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v7 01/11] iommu: Add DMA ownership management interfaces
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Chaitanya Kulkarni <kch@nvidia.com>, kvm@vger.kernel.org,
        Stuart Yoder <stuyoder@gmail.com>, rafael@kernel.org,
        David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org,
        Jonathan Hunter <jonathanh@nvidia.com>,
        iommu@lists.linux-foundation.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Li Yang <leoyang.li@nxp.com>, Will Deacon <will@kernel.org>,
        Dmitry Osipenko <digetx@gmail.com>
References: <20220228005056.599595-1-baolu.lu@linux.intel.com>
 <20220228005056.599595-2-baolu.lu@linux.intel.com>
 <c75b6e04-bc1b-b9f6-1a44-bf1567a8c19d@redhat.com>
 <7a3dc977-0c5f-6d88-6d3a-8e49bc717690@linux.intel.com>
 <1648bc97-a0d3-4051-58d0-e24fa9e9d183@arm.com>
 <350a8e09-08a9-082b-3ad1-b711c7d98d73@redhat.com>
 <e2698dbe-18e2-1a82-8a12-fe45bc9be534@arm.com>
 <b1a5db0a-0373-5ca0-6256-85a96d029ec9@linux.intel.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <ac75c521-fb13-8414-a81b-9178cbed3471@redhat.com>
Date:   Mon, 7 Mar 2022 13:42:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b1a5db0a-0373-5ca0-6256-85a96d029ec9@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Lu,

On 3/7/22 4:27 AM, Lu Baolu wrote:
> Hi Robin,
>
> On 3/4/22 10:10 PM, Robin Murphy wrote:
>> On 2022-03-04 13:55, Eric Auger wrote:
>>> Hi Robin,
>>>
>>> On 3/4/22 1:22 PM, Robin Murphy wrote:
>>>> On 2022-03-04 10:43, Lu Baolu wrote:
>>>>> Hi Eric,
>>>>>
>>>>> On 2022/3/4 18:34, Eric Auger wrote:
>>>>>> I hit a WARN_ON() when unbinding an e1000e driver just after boot:
>>>>>>
>>>>>> sudo modprobe -v vfio-pci
>>>>>> echo vfio-pci | sudo tee -a
>>>>>> /sys/bus/pci/devices/0004:01:00.0/driver_override
>>>>>> vfio-pci
>>>>>> echo 0004:01:00.0 | sudo tee -a  /sys/bus/pci/drivers/e1000e/unbind
>>>>>>
>>>>>>
>>>>>> [  390.042811] ------------[ cut here ]------------
>>>>>> [  390.046468] WARNING: CPU: 42 PID: 5589 at
>>>>>> drivers/iommu/iommu.c:3123
>>>>>> iommu_device_unuse_default_domain+0x68/0x100
>>>>>> [  390.056710] Modules linked in: vfio_pci vfio_pci_core vfio_virqfd
>>>>>> vfio_iommu_type1 vfio xt_CHECKSUM xt_MASQUERADE xt_conntrack
>>>>>> ipt_REJECT
>>>>>> nf_reject_ipv4 nft_compat nft_chain_nat nf_nat nf_conntrack
>>>>>> nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink bridge stp llc
>>>>>> rfkill
>>>>>> sunrpc vfat fat mlx5_ib ib_uverbs ib_core acpi_ipmi ipmi_ssif
>>>>>> ipmi_devintf ipmi_msghandler cppc_cpufreq drm xfs libcrc32c
>>>>>> mlx5_core sg
>>>>>> mlxfw crct10dif_ce tls ghash_ce sha2_ce sha256_arm64 sha1_ce
>>>>>> sbsa_gwdt
>>>>>> e1000e psample sdhci_acpi ahci_platform sdhci libahci_platform
>>>>>> qcom_emac
>>>>>> mmc_core hdma hdma_mgmt dm_mirror dm_region_hash dm_log dm_mod fuse
>>>>>> [  390.110618] CPU: 42 PID: 5589 Comm: tee Kdump: loaded Not tainted
>>>>>> 5.17.0-rc4-lu-v7-official+ #24
>>>>>> [  390.119384] Hardware name: WIWYNN QDF2400 Reference Evaluation
>>>>>> Platform CV90-LA115-P120/QDF2400 Customer Reference Board, BIOS
>>>>>> 0ACJA570
>>>>>> 11/05/2018
>>>>>> [  390.132492] pstate: a0400005 (NzCv daif +PAN -UAO -TCO -DIT -SSBS
>>>>>> BTYPE=--)
>>>>>> [  390.139436] pc : iommu_device_unuse_default_domain+0x68/0x100
>>>>>> [  390.145165] lr : iommu_device_unuse_default_domain+0x38/0x100
>>>>>> [  390.150894] sp : ffff80000fbb3bc0
>>>>>> [  390.154193] x29: ffff80000fbb3bc0 x28: ffff03c0cf6b2400 x27:
>>>>>> 0000000000000000
>>>>>> [  390.161311] x26: 0000000000000000 x25: 0000000000000000 x24:
>>>>>> ffff03c0c7cc5720
>>>>>> [  390.168429] x23: ffff03c0c2b9d150 x22: ffffb4e61df223f8 x21:
>>>>>> ffffb4e61df223f8
>>>>>> [  390.175547] x20: ffff03c7c03c3758 x19: ffff03c7c03c3700 x18:
>>>>>> 0000000000000000
>>>>>> [  390.182665] x17: 0000000000000000 x16: 0000000000000000 x15:
>>>>>> 0000000000000000
>>>>>> [  390.189783] x14: 0000000000000000 x13: 0000000000000030 x12:
>>>>>> ffff03c0d519cd80
>>>>>> [  390.196901] x11: 7f7f7f7f7f7f7f7f x10: 0000000000000dc0 x9 :
>>>>>> ffffb4e620b54f8c
>>>>>> [  390.204019] x8 : ffff03c0cf6b3220 x7 : ffff4ef132bba000 x6 :
>>>>>> 00000000000000ff
>>>>>> [  390.211137] x5 : ffff03c0c2b9f108 x4 : ffff03c0d51f6438 x3 :
>>>>>> 0000000000000000
>>>>>> [  390.218255] x2 : ffff03c0cf6b2400 x1 : 0000000000000000 x0 :
>>>>>> 0000000000000000
>>>>>> [  390.225374] Call trace:
>>>>>> [  390.227804]  iommu_device_unuse_default_domain+0x68/0x100
>>>>>> [  390.233187]  pci_dma_cleanup+0x38/0x44
>>>>>> [  390.236919]  __device_release_driver+0x1a8/0x260
>>>>>> [  390.241519]  device_driver_detach+0x50/0xd0
>>>>>> [  390.245686]  unbind_store+0xf8/0x120
>>>>>> [  390.249245]  drv_attr_store+0x30/0x44
>>>>>> [  390.252891]  sysfs_kf_write+0x50/0x60
>>>>>> [  390.256537]  kernfs_fop_write_iter+0x134/0x1cc
>>>>>> [  390.260964]  new_sync_write+0xf0/0x18c
>>>>>> [  390.264696]  vfs_write+0x230/0x2d0
>>>>>> [  390.268082]  ksys_write+0x74/0x100
>>>>>> [  390.271467]  __arm64_sys_write+0x28/0x3c
>>>>>> [  390.275373]  invoke_syscall.constprop.0+0x58/0xf0
>>>>>> [  390.280061]  el0_svc_common.constprop.0+0x160/0x164
>>>>>> [  390.284922]  do_el0_svc+0x34/0xcc
>>>>>> [  390.288221]  el0_svc+0x30/0x140
>>>>>> [  390.291346]  el0t_64_sync_handler+0xa4/0x130
>>>>>> [  390.295599]  el0t_64_sync+0x1a0/0x1a4
>>>>>> [  390.299245] ---[ end trace 0000000000000000 ]---
>>>>>>
>>>>>>
>>>>>> I put some traces in the code and I can see that
>>>>>> iommu_device_use_default_domain() effectively is called on
>>>>>> 0004:01:00.0 e1000e device on pci_dma_configure() but at that time
>>>>>> the iommu group is NULL:
>>>>>> [   10.569427] e1000e 0004:01:00.0: ------ ENTRY pci_dma_configure
>>>>>> driver_managed_area=0
>>>>>> [   10.569431] e1000e 0004:01:00.0: ****
>>>>>> iommu_device_use_default_domain ENTRY
>>>>>> [   10.569433] e1000e 0004:01:00.0: ****
>>>>>> iommu_device_use_default_domain no group
>>>>>> [   10.569435] e1000e 0004:01:00.0: pci_dma_configure
>>>>>> iommu_device_use_default_domain returned 0
>>>>>> [   10.569492] e1000e 0004:01:00.0: Adding to iommu group 3
>>>>>>
>>>>>> ^^^the group is added after the
>>>>>> iommu_device_use_default_domain() call
>>>>>> So the group->owner_cnt is not incremented as expected.
>>>>>
>>>>> Thank you for reporting this. Do you have any idea why the driver is
>>>>> loaded before iommu_probe_device()?
>>>>
>>>> Urgh, this is the horrible firmware-data-ordering thing again. The
>>>> stuff I've been saying about having to rework the whole .dma_configure
>>>> mechanism in the near future is to fix this properly.
>>>>
>>>> The summary is that in patch #4, calling
>>>> iommu_device_use_default_domain() *before* {of,acpi}_dma_configure is
>>>> currently a problem. As things stand, the IOMMU driver ignored the
>>>> initial iommu_probe_device() call when the device was added, since at
>>>> that point it had no fwspec yet. In this situation,
>>>> {of,acpi}_iommu_configure() are retriggering iommu_probe_device()
>>>> after the IOMMU driver has seen the firmware data via .of_xlate to
>>>> learn that it it actually responsible for the given device.
>>>
>>> thank you for providing the info. Hope this is something Lu can work
>>> around.
>>
>> Hopefully it's just a case of flipping the calls around, so that
>> iommu_use_default_domain() goes at the end, and calls
>> arch_teardown_dma_ops() if it fails. From a quick skim I *think* that
>> should still work out to the desired behaviour (or at least close
>> enough that we can move forward without a circular dependency between
>> fixes...)
>
> This is a reasonable solution to me. Thank you for the information and
> suggestion.
>
> Eric, I have updated the patch #4 and uploaded a new version here:
>
> https://github.com/LuBaolu/intel-iommu/commits/iommu-dma-ownership-v8

with v8 I do not hit the warning anymore and the owner accounting seems
to work as expected.

Thanks

Eric
>
> Can you please give it a try?
>
> Best regards,
> baolu
>

