Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B1F5FDCFD
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 17:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiJMPTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 11:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiJMPTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 11:19:33 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF703114DE8
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 08:19:30 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oizwM-00B3Aa-Fc;
        Thu, 13 Oct 2022 17:18:57 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     virtualization@lists.linux-foundation.org
Cc:     andrey.zhadchenko@virtuozzo.com, mst@redhat.com,
        jasonwang@redhat.com, kvm@vger.kernel.org, stefanha@redhat.com,
        sgarzare@redhat.com, den@virtuozzo.com, ptikhomirov@virtuozzo.com
Subject: [RFC PATCH v2 00/10] vhost-blk: in-kernel accelerator for virtio-blk guests
Date:   Thu, 13 Oct 2022 18:18:29 +0300
Message-Id: <20221013151839.689700-1-andrey.zhadchenko@virtuozzo.com>
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

As there is some interest from QEMU userspace, I am sending second version
of this patchet.

Main addition is a few patches about vhost multithreading so vhost-blk can
be scaled. Generally the idea is not a new one - somehow attach workers to
the virtqueues and do the work on them.

I have seen several previous attemps like cgroup-aware worker pools or the
userspace threads, but they seem very complicated and involve a lot of
subsystems. Probably just spawning a few more vhost threads can do a good
job.

As this is RFC, I did not convert any vhost users except vhost_blk. If
anyone is interested in this regarding other modules, please tell me.
I can test it to see if it is beneficial and maybe send multithreading
separately.
Also multithreading part may eventually be of help with vdpa-blk.

---

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
have the most features. So vhost_blk module is partially based on it. Multiple
virtqueue support was addded, some places reworked. Added support for several
vhost workers.

test setup and results:
fio --direct=1 --rw=randread  --bs=4k  --ioengine=libaio --iodepth=128
QEMU drive options: cache=none
filesystem: xfs

SSD:
               | randread, IOPS  | randwrite, IOPS |
Host           |      95.8k	 |	85.3k	   |
QEMU virtio    |      61.5k	 |	79.9k	   |
QEMU vhost-blk |      95.6k	 |	84.3k	   |

RAMDISK (vq == vcpu == numjobs):
                 | randread, IOPS | randwrite, IOPS |
virtio, 1vcpu    |	133k	  |	 133k       |
virtio, 2vcpu    |	305k      |	 306k       |
virtio, 4vcpu    |	310k	  |	 298k       |
virtio, 8vcpu    |	271k      |	 252k       |
vhost-blk, 1vcpu |	110k	  |	 113k       |
vhost-blk, 2vcpu |	247k	  |	 252k       |
vhost-blk, 4vcpu |	558k	  |	 556k       |
vhost-blk, 8vcpu |	576k	  |	 575k       | *single kernel thread
vhost-blk, 8vcpu |      803k      |      779k       | *two kernel threads

v2:
Re-measured virtio performance with aio=threads and iothread on latest QEMU

vhost-blk changes:
 - removed unused VHOST_BLK_VQ
 - reworked bio handling a bit: now add all pages from signle iov into
bio until it is full istead of allocating one bio per page
 - changed how to calculate sector incrementation
 - check move_iovec() in vhost_blk_req_handle()
 - remove snprintf check and better check ret from copy_to_iter for
VIRTIO_BLK_ID_BYTES requests
 - discard vq request if vhost_blk_req_handle() returned negative code
 - forbid to change nonzero backend in vhost_blk_set_backend(). First of
all, QEMU sets backend only once. Also if we want to change backend when
we already running requests we need to be much more careful in
vhost_blk_handle_guest_kick() as it is not taking any references. If
userspace want to change backend that bad it can always reset device.
 - removed EXPERIMENTAL from Kconfig

Andrey Zhadchenko (10):
  drivers/vhost: vhost-blk accelerator for virtio-blk guests
  drivers/vhost: use array to store workers
  drivers/vhost: adjust vhost to flush all workers
  drivers/vhost: rework cgroups attachment to be worker aware
  drivers/vhost: rework worker creation
  drivers/vhost: add ioctl to increase the number of workers
  drivers/vhost: assign workers to virtqueues
  drivers/vhost: add API to queue work at virtqueue's worker
  drivers/vhost: allow polls to be bound to workers via vqs
  drivers/vhost: queue vhost_blk works at vq workers

 drivers/vhost/Kconfig      |  12 +
 drivers/vhost/Makefile     |   3 +
 drivers/vhost/blk.c        | 819 +++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.c      | 263 +++++++++---
 drivers/vhost/vhost.h      |  21 +-
 include/uapi/linux/vhost.h |  13 +
 6 files changed, 1064 insertions(+), 67 deletions(-)
 create mode 100644 drivers/vhost/blk.c

-- 
2.31.1

