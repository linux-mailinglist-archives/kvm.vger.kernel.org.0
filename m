Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02ED5805A2
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 22:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237101AbiGYUak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 16:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237089AbiGYUaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 16:30:35 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0712250A
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 13:30:33 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oG4hv-00BzA1-SW;
        Mon, 25 Jul 2022 22:30:03 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        asias@redhat.com, den@virtuozzo.com,
        andrey.zhadchenko@virtuozzo.com
Subject: [RFC PATCH 0/1] vhost-blk: in-kernel accelerator for virtio-blk guests
Date:   Mon, 25 Jul 2022 23:27:52 +0300
Message-Id: <20220725202753.298725-1-andrey.zhadchenko@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although QEMU virtio-blk is quite fast, there is still some room for
improvements. Disk latency can be reduced if we handle virito-blk requests
in host kernel so we avoid a lot of syscalls and context switches.
The idea is quite simple - QEMU gives us block device and we translate
any incoming virtio requests into bio and push them into bdev.
The biggest disadvantage of this vhost-blk flavor is raw format.
Luckily Kirill Thai proposed device mapper driver for QCOW2 format to attach
files as block devices: https://www.spinics.net/lists/kernel/msg4292965.html

Also by using kernel modules we can bypass iothread limitation and finaly scale
block requests with cpus for high-performance devices.


There have already been several attempts to write vhost-blk:

Asias' version: https://lkml.org/lkml/2012/12/1/174
Badari's version: https://lwn.net/Articles/379864/
Vitaly's https://lwn.net/Articles/770965/

The main difference between them is API to access backend file. The fastest
one is Asias's version with bio flavor. It is also the most reviewed and
have the most features. So his module is partially based on it. Multiple
virtqueue support was addded, some places reworked.

test setup and results:
fio --direct=1 --rw=randread  --bs=4k  --ioengine=libaio --iodepth=128
QEMU drive options: cache=none
filesystem: xfs

SSD:
               | randread, IOPS  | randwrite, IOPS |
Host           |      95.8k	 |	85.3k	   |
QEMU virtio    |      57.5k	 |	79.4k	   |
QEMU vhost-blk |      95.6k	 |	84.3k	   |

RAMDISK (vq == vcpu):
                 | randread, IOPS | randwrite, IOPS |
virtio, 1vcpu    |	123k	  |	 129k       |
virtio, 2vcpu    |	253k (??) |	 250k (??)  |
virtio, 4vcpu    |	158k	  |	 154k       |
vhost-blk, 1vcpu |	110k	  |	 113k       |
vhost-blk, 2vcpu |	247k	  |	 252k       |
vhost-blk, 4vcpu |	576k	  |	 567k       |

Major features planned for the next versions:
 - DISCARD\WRITE_ZEROES support
 - multiple vhost workers

Andrey Zhadchenko (1):
  drivers/vhost: vhost-blk accelerator for virtio-blk guests

 drivers/vhost/Kconfig      |  12 +
 drivers/vhost/Makefile     |   3 +
 drivers/vhost/blk.c        | 831 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vhost.h |   5 +
 4 files changed, 851 insertions(+)
 create mode 100644 drivers/vhost/blk.c

-- 
2.31.1

