Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D31C24FFD2
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 16:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgHXObE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 10:31:04 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50912 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725916AbgHXObC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Aug 2020 10:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598279461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/IFdj83nl9k/Rfbaic8KM5ZKD+s0TU+9sUzyhScs5ec=;
        b=jFhUHGsNhZk/d0kUfLeJ8jDez7k/x9VitASi1+454cO5fBzH6aRepDuU8CDObs+cA5489Q
        5Ty/oFWyYxWCra6nHtPE5Mt9E9cyG4/qUAv4e/OMleKfEVEwoBa6jvZ403eN7GdH3KM5r/
        yP0jf1mQK/cH5VPXOrnLVHE+bwuyiWg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-U95dWT7_NLCjkbnV4pqcIg-1; Mon, 24 Aug 2020 10:30:58 -0400
X-MC-Unique: U95dWT7_NLCjkbnV4pqcIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 226EC101962C;
        Mon, 24 Aug 2020 14:30:57 +0000 (UTC)
Received: from w520.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5A352BFBF;
        Mon, 24 Aug 2020 14:30:56 +0000 (UTC)
Date:   Mon, 24 Aug 2020 08:30:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: vfio-pci regression on x86_64 and Kernel v5.9-rc1
Message-ID: <20200824083056.14339fd7@w520.home>
In-Reply-To: <6d0a5da6-0deb-17c5-f8f5-f8113437c2d6@linux.ibm.com>
References: <6d0a5da6-0deb-17c5-f8f5-f8113437c2d6@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 22 Aug 2020 10:46:49 +0200
Niklas Schnelle <schnelle@linux.ibm.com> wrote:

> Hi Alex, Hi Cornelia,
> 
> yesterday I wanted to test a variant of Matthew's patch for our detached VF
> problem on an x86_64 system, to make sure we don't break anything there.
> However I seem to have stumbled over a vfio-pci regression in v5.9-rc1
> (without the patch), it works fine on 5.8.1. 
> I haven't done a bisect yet but will as soon as I get to it.
> 
> The problem occurs immediately when attaching or booting a KVM VM with
> a vfio-pci pass-through. With virsh I get:
> 
> % sudo virsh start ubuntu20.04
> [sudo] password for XXXXXX:
> error: Failed to start domain ubuntu20.04
> error: internal error: qemu unexpectedly closed the monitor: 2020-08-22T08:21:12.663319Z qemu-system-x86_64: -device vfio-pci,host=0000:03:10.2,id=hostdev0,bus=pci.6,addr=0x0: VFIO_MAP_DMA failed: Cannot allocate memory
> 2020-08-22T08:21:12.663344Z qemu-system-x86_64: -device vfio-pci,host=0000:03:10.2,id=hostdev0,bus=pci.6,addr=0x0: VFIO_MAP_DMA failed: Cannot allocate memory
> 2020-08-22T08:21:12.663360Z qemu-system-x86_64: -device vfio-pci,host=0000:03:10.2,id=hostdev0,bus=pci.6,addr=0x0: VFIO_MAP_DMA failed: Cannot allocate memory
> 2020-08-22T08:21:12.667207Z qemu-system-x86_64: -device vfio-pci,host=0000:03:10.2,id=hostdev0,bus=pci.6,addr=0x0: VFIO_MAP_DMA failed: Cannot allocate memory
> 2020-08-22T08:21:12.667265Z qemu-system-x86_64: -device vfio-pci,host=0000:03:10.2,id=hostdev0,bus=pci.6,addr=0x0: vfio 0000:03:10.2: failed to setup container for group 54: memory listener initialization failed: Region pc.ram: vfio_dma_map(0x55ceedea1610, 0x0, 0xa0000, 0x7efcc7e00000) = -12 (Cannot allocate memory)
> 
> and in dmesg:
> 
> [  379.368222] VFIO - User Level meta-driver version: 0.3
> [  379.435459] ixgbe 0000:03:00.0 enp3s0: VF Reset msg received from vf 1
> [  379.663384] cgroup: cgroup: disabling cgroup2 socket matching due to net_prio or net_cls activation
> [  379.764947] vfio_pin_pages_remote: RLIMIT_MEMLOCK (9663676416) exceeded
> [  379.764972] vfio_pin_pages_remote: RLIMIT_MEMLOCK (9663676416) exceeded
> [  379.764989] vfio_pin_pages_remote: RLIMIT_MEMLOCK (9663676416) exceeded
> [  379.768836] vfio_pin_pages_remote: RLIMIT_MEMLOCK (9663676416) exceeded
> [  379.979310] ixgbevf 0000:03:10.2: enabling device (0000 -> 0002)
> [  379.979505] ixgbe 0000:03:00.0 enp3s0: VF Reset msg received from vf 1
> [  379.992624] ixgbevf 0000:03:10.2: 2e:7a:3e:95:5d:be
> [  379.992627] ixgbevf 0000:03:10.2: MAC: 1
> [  379.992629] ixgbevf 0000:03:10.2: Intel(R) 82599 Virtual Function
> [  379.993594] ixgbevf 0000:03:10.2 enp3s0v1: renamed from eth1
> [  380.043490] ixgbevf 0000:03:10.2: NIC Link is Up 1 Gbps
> [  380.045081] IPv6: ADDRCONF(NETDEV_CHANGE): enp3s0v1: link becomes ready
> 
> This does not seem to be device related, I initially tried with
> a VF of an Intel 82599 10 Gigabit NIC but also tried other
> physical PCI devices. I also initially tried increasing the ulimit
> but looking at the code it seems the limit is actually 9663676416 bytes
> so that should be plenty.
> 
> Simply rebooting into v5.8.1 (official Arch Linux Kernel but that's
> pretty much exactly Greg's stable series and I based my config on its config)
> fixes the issue and the same setup works perfectly.
> In most documentation people only use Intel boxes for pass-through
> so I should mention that this is a AMD Ryzen 9 3900X
> with Starship/Matisse IOMMU and my Kernel command line contains
> "amd_iommu=on iommu=pt".
> Does any of this ring a bell for you or do we definitely need
> a full bisect or any other information?

Hi Niklas,

It does not sound familiar to me and I haven't encountered it in my
testing of rc1, though I haven't tested on AMD specifically.  There was
nothing from my pull request that should have affected page pinning.
Please let us know your results.  Thanks,

Alex

