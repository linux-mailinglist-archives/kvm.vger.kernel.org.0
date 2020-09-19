Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD11270D8B
	for <lists+kvm@lfdr.de>; Sat, 19 Sep 2020 13:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgISLPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Sep 2020 07:15:50 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13731 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgISLPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Sep 2020 07:15:50 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0BAC450C2E2CAE8B0AC4;
        Sat, 19 Sep 2020 19:15:49 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 19:15:38 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
Subject: KVM_SET_DEVICE_ATTR failed
To:     <qemu-arm@nongnu.org>, <kvmarm@lists.cs.columbia.edu>,
        <kvm@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>, Eric Auger <eric.auger@redhat.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        <wanghaibin.wang@huawei.com>
Message-ID: <1f70926e-27dd-9e30-3d0f-770130112777@huawei.com>
Date:   Sat, 19 Sep 2020 19:15:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

I had booted a guest with an assigned virtual function, with GICv4
(direct MSI injection) enabled on my arm64 server. I got the following
QEMU error message on its shutdown:

"qemu-system-aarch64: KVM_SET_DEVICE_ATTR failed: Group 4 attr 
0x0000000000000001: Permission denied"

The problem is that the KVM_DEV_ARM_ITS_SAVE_TABLES ioctl failed while
stopping the VM.

As for the kernel side, it turned out that an LPI with irq->hw=true was
observed while saving ITT for the device. KVM simply failed the save
operation by returning -EACCES to user-space. The reason is explained in
the comment block of vgic_its_save_itt(), though I think the HW bit
should actually be checked in the KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
ioctl rather than in the ITT saving, well, it isn't much related to this
problem...

I had noticed that some vectors had been masked by guest VF-driver on
shutdown, the correspond VLPIs had therefore been unmapped and irq->hw
was cleared. But some other vectors were un-handled. I *guess* that VFIO
released these vectors *after* the KVM_DEV_ARM_ITS_SAVE_TABLES ioctl so
that we end-up trying to save the VLPI's state.

It may not be a big problem as the guest is going to shutdown anyway and
the whole guest save/restore on the GICv4.x system is not supported for
the time being... I'll look at how VFIO would release these vectors but
post it early in case this is an already known issue (and this might be
one thing need to be considered if one wants to implement migration on
the GICv4.x system).


Thanks,
Zenghui
