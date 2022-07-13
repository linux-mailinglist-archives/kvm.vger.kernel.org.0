Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FAE572DD2
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 08:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiGMGCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 02:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiGMGCR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 02:02:17 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D114F6AC;
        Tue, 12 Jul 2022 23:02:16 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LjRkY2gqlzVfp7;
        Wed, 13 Jul 2022 13:58:29 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Jul 2022 14:02:10 +0800
Subject: Re: [QUESTION] Exception print when enabling GICv4
To:     Marc Zyngier <maz@kernel.org>
References: <6d6d61fb-6241-4e1e-ddff-8ae8be96f9ff@hisilicon.com>
 <87bktu1hfj.wl-maz@kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        chenxiang via <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <13e4fde9-05e9-f492-a2b6-20d567eb2920@hisilicon.com>
Date:   Wed, 13 Jul 2022 14:02:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <87bktu1hfj.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Thank you for your reply.

在 2022/7/12 23:25, Marc Zyngier 写道:
> Hi Xiang,
>
> On Tue, 12 Jul 2022 13:55:16 +0100,
> "chenxiang (M)" <chenxiang66@hisilicon.com> wrote:
>> Hi,
>> I encounter a issue related to GICv4 enable on ARM64 platform (kernel
>> 5.19-rc4, qemu 6.2.0):
>> We have a accelaration module whose VF has 3 MSI interrupts, and we
>> passthrough it to virtual machine with following steps:
>>
>> echo 0000:79:00.1 > /sys/bus/pci/drivers/hisi_hpre/unbind
>> echo vfio-pci >
>> /sys/devices/pci0000\:78/0000\:78\:00.0/0000\:79\:00.1/driver_override
>> echo 0000:79:00.1 > /sys/bus/pci/drivers_probe
>>
>> Then we boot VM with "-device vfio-pci,host=79:00.1,id=net0 \".
>> When insmod the driver which registers 3 PCI MSI interrupts in VM,
>> some exception print occur as following:
>>
>> vfio-pci 0000:3a:00.1: irq bypass producer (token 000000008f08224d)
>> registration fails: 66311
>>
>> I find that bit[6:4] of register PCI_MSI_FLAGS is 2 (4 MSI interrupts)
>> though we only register 3 PCI MSI interrupt,
>>
>> and only 3 MSI interrupt is activated at last.
>> It allocates 4 vectors in function vfio_msi_enable() (qemu)  as it
>> reads the register PCI_MSI_FLAGS.
>> Later it will  call system call VFIO_DEVICE_SET_IRQS to set forwarding
>> for those interrupts
>> using function kvm_vgic_v4_set_forrwarding() as GICv4 is enabled. For
>> interrupt 0~2, it success to set forwarding as they are already
>> activated,
>> but for the 4th interrupt, it is not activated, so ite is not found in
>> function vgic_its_resolve_lpi(), so above printk occurs.
>>
>> It seems that we only allocate and activate 3 MSI interrupts in guest
>> while it tried to set forwarding for 4 MSI interrupts in host.
>> Do you have any idea about this issue?
> I have a hunch: QEMU cannot know that the guest is only using 3 MSIs
> out of the 4 that the device can use, and PCI/Multi-MSI only has a
> single enable bit for all MSIs. So it probably iterates over all
> possible MSIs and enable the forwarding. Since the guest has only
> created 3 mappings in the virtual ITS, the last call fails. I would
> expect the guest to still work properly though.

Yes, that's the reason of exception print.
Is it possible for QEMU to get the exact number of interrupts guest is 
using? It seems not.

>
> Thanks,
>
> 	M.
>

