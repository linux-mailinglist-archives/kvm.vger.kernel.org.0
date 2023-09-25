Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDCA7AD5D5
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 12:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjIYK0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 06:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjIYK0e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 06:26:34 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2431E8E
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 03:26:27 -0700 (PDT)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RvJqV5zw4zVlHf;
        Mon, 25 Sep 2023 18:23:18 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 25 Sep 2023 18:26:23 +0800
From:   Kunkun Jiang <jiangkunkun@huawei.com>
Subject: Question: In a certain scenario, enabling GICv4/v4.1 may cause Guest
 hang when restarting the Guest
To:     Marc Zyngier <maz@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
CC:     <kvm@vger.kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        <chenxiang66@hisilicon.com>, <jiangkunkun@huawei.com>
Message-ID: <2bcd2a8a-673a-237f-8491-30db260fcf37@huawei.com>
Date:   Mon, 25 Sep 2023 18:26:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.185.210]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi everyone,

Here is a very valuable question about the direct injection of pistil.
Environment configuration:
1)A virtuoso_SCSI device is pass through to a small-scale CM,1U
2)Guest Kernel 4.19,Host Kernel 5.10
3)Enable GICv4/v4.1
The Guest will hang in the BIOS phase when it is restarted, and
report"Synchronous Exception at 0x280004654FF40".

Here's the analysis:
The virtuoso_SCSI device has six queues. The virtuoso driver may apply for
a vector for each queue of the device. It may also apply for one vector
for all queues. These queues share the vector.
In the problem scenario:
1.The host driver(avdp or FIONA) applies for six vectors(LIP) for the 
device.
2.The virtuoso driver applies for only one vector(vulpine) in the guest.
3.Only one vicing_ire is allocated by the vicing driver.In the current 
vicing
  implement ion, when MAPS/MAP is executed in the Guest, it will be trapped
  to KVM. Therefore, the vgic driver allocates the same number of vgic_irq
  to record these vectors which applied by device drivers in VM.
4.The kvm_vgic_v4_set_forwarding and its_map_vlpi is executed six times.
  vgic_irq->host_irq equals the last linux interrupt ID(virq). The result is
  that six LPIs are mapped to one vLPI. The six LPIs of the device can
  send interrupts. These interrupts will be injected into the guest
  through the same vLPI.
5.When the Guest is restarted.The kvm_vgic_v4_unset_forwarding will also be
  executed six times. However, multiple call traces are generated. Since
  there is only one vgic_irq, its_unmap_vlpi is executed only once.

> WARN_ON(!(irq->hw && irq->host_irq == virq));
> if (irq->hw) {
> atomic_dec(&irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count);
>         irq->hw = false;
>         ret = its_unmap_vlpi(virq);
> }
6.In the BIOS phase after the Guest restarted, the other five vectors 
continue
  to send interrupts. BIOS cannot handle these interrupts, so the Guest 
hang.

This problem does not occur when the guest kernel is version 5.10, because
this patch is incorporated.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c66d4bd110a1f

I think there are other scenarios where the virtual machine will apply 
for an
vector, and the host will apply for multiple vectors. There is still 
value in
fixing this problem at the hypervisor layer. I think there are two 
modification
methods here, but not sure if it is possible:
1)The vDPA or VFIO driver is aware of the behavior within the Guest and only
apply for the same number of vectors.
2)Modify the vgic driver so that one vgic_irq can be bound to multiple LPIs.
But I understand that the semantics of vigc_irq->host_irq is that vgic_irq
is bound 1:1 to the host-side LPI hwintid.

If you have other ideas, we can discuss them together.

Looking forwarding to your reply.
Thanks,
Kunkun Jiang










