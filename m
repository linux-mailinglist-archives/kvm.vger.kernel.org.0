Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BC56223F1
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 07:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiKIGV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 01:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiKIGVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 01:21:22 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8DB1A05C
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 22:21:20 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N6Zbk07srzmVnW;
        Wed,  9 Nov 2022 14:21:05 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 14:21:18 +0800
Subject: Re: [PATCH] KVM: Add system call KVM_VERIFY_MSI to verify MSI vector
To:     Marc Zyngier <maz@kernel.org>
References: <1667894937-175291-1-git-send-email-chenxiang66@hisilicon.com>
 <86wn85pq8f.wl-maz@kernel.org>
CC:     <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <a55310da-2ed3-f837-71c2-d09764f83538@hisilicon.com>
Date:   Wed, 9 Nov 2022 14:21:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <86wn85pq8f.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,


在 2022/11/8 20:47, Marc Zyngier 写道:
> On Tue, 08 Nov 2022 08:08:57 +0000,
> chenxiang <chenxiang66@hisilicon.com> wrote:
>> From: Xiang Chen <chenxiang66@hisilicon.com>
>>
>> Currently the numbers of MSI vectors come from register PCI_MSI_FLAGS
>> which should be power-of-2, but in some scenaries it is not the same as
>> the number that driver requires in guest, for example, a PCI driver wants
>> to allocate 6 MSI vecotrs in guest, but as the limitation, it will allocate
>> 8 MSI vectors. So it requires 8 MSI vectors in qemu while the driver in
>> guest only wants to allocate 6 MSI vectors.
>>
>> When GICv4.1 is enabled, we can see some exception print as following for
>> above scenaro:
>> vfio-pci 0000:3a:00.1: irq bypass producer (token 000000008f08224d) registration fails:66311
>>
>> In order to verify whether a MSI vector is valid, add KVM_VERIFY_MSI to do
>> that. If there is a mapping, return 0, otherwise return negative value.
>>
>> This is the kernel part of adding system call KVM_VERIFY_MSI.
> Exposing something that is an internal implementation detail to
> userspace feels like the absolute wrong way to solve this issue.
>
> Can you please characterise the issue you're having? Is it that vfio
> tries to enable an interrupt for which there is no virtual ITS
> mapping? Shouldn't we instead try and manage this in the kernel?

Before i reported the issue to community, you gave a suggestion about 
the issue, but not sure whether i misundertood your meaning.
You can refer to the link for more details about the issue.
https://lkml.kernel.org/lkml/87cze9lcut.wl-maz@kernel.org/T/

Best regards,
Xiang
