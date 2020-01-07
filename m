Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49CF13293B
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 15:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgAGOrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 09:47:04 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:59600 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727975AbgAGOrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 09:47:04 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3AE2830EE6EF2E3D4DC3;
        Tue,  7 Jan 2020 22:46:54 +0800 (CST)
Received: from localhost (10.177.98.84) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Tue, 7 Jan 2020
 22:46:46 +0800
From:   weiqi <weiqi4@huawei.com>
To:     <alexander.h.duyck@linux.intel.com>, <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <x86@kernel.org>, wei qi <weiqi4@huawei.com>
Subject: [PATCH 0/2] page hinting add passthrough support
Date:   Tue, 7 Jan 2020 22:46:37 +0800
Message-ID: <1578408399-20092-1-git-send-email-weiqi4@huawei.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.98.84]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: wei qi <weiqi4@huawei.com>


I just implemented dynamically updating the iommu table to support pass-through,
It seen to work fine.

Test:
start a 4G vm with 2M hugetlb and ixgbevf passthrough, 
    GuestOS: linux-5.2.6 + 	(mm / virtio: Provide support for free page reporting)
    HostOS: 5.5-rc4
    Host: Intel(R) Xeon(R) Gold 6161 CPU @ 2.20GHz 

after enable page hinting, free pages at GuestOS can be free at host. 


before,
 # cat /sys/devices/system/node/node*/hugepages/hugepages-2048kB/free_hugepages 
 5620
 5620
after start VM,
 # numastat -c qemu

 Per-node process memory usage (in MBs)
 PID              Node 0 Node 1 Total
 ---------------  ------ ------ -----
 24463 (qemu_hotr      6      6    12
 24479 (qemu_tls_      0      8     8
 70718 (qemu-syst     58    539   597
 ---------------  ------ ------ -----
 Total                64    553   616
 # cat /sys/devices/system/node/node*/hugepages/hugepages-2048kB/free_hugepages 
 5595
 5366

the modify at qemu,
 +int kvm_discard_range(struct kvm_discard_msg discard_msg)  
 +{
 +    return kvm_vm_ioctl(kvm_state, KVM_DISCARD_RANGE, &discard_msg);
 +}

 static void virtio_balloon_handle_report(VirtIODevice *vdev, VirtQueue *vq)
 {
            ..................
 +           discard_msg.in_addr = elem->in_addr[i];
 +           discard_msg.iov_len = elem->in_sg[i].iov_len;

            ram_block_discard_range(rb, ram_offset, size);
 +           kvm_discard_range(discard_msg);

then, further test network bandwidth, performance seem ok.
 
Is there any hidden problem in this implementation?
And, is there plan to support pass-throughyour?

wei qi (2):
  vfio: add mmap/munmap API for page hinting
  KVM: add support for page hinting

 arch/x86/kvm/mmu/mmu.c          |  79 ++++++++++++++++++++
 arch/x86/kvm/x86.c              |  96 ++++++++++++++++++++++++
 drivers/vfio/vfio.c             | 109 ++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c | 157 +++++++++++++++++++++++++++++++++++++++-
 include/linux/kvm_host.h        |  41 +++++++++++
 include/linux/vfio.h            |  17 ++++-
 include/uapi/linux/kvm.h        |   7 ++
 virt/kvm/vfio.c                 |  11 ---
 8 files changed, 503 insertions(+), 14 deletions(-)

-- 
1.8.3.1


