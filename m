Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBA014724
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 11:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfEFJES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 05:04:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbfEFJER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 05:04:17 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7DD605945B;
        Mon,  6 May 2019 09:04:17 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D03F55F9D4;
        Mon,  6 May 2019 09:04:04 +0000 (UTC)
Message-ID: <e8f6981863bdbba89adcba1c430083e68546ac1a.camel@redhat.com>
Subject: Re: [PATCH v2 00/10] RFC: NVME MDEV
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Fam Zheng <fam@euphon.net>, Keith Busch <keith.busch@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>, kvm@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liang Cunming <cunming.liang@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liu Changpeng <changpeng.liu@intel.com>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Amnon Ilan <ailan@redhat.com>, John Ferlan <jferlan@redhat.com>
Date:   Mon, 06 May 2019 12:04:06 +0300
In-Reply-To: <20190503121838.GA21041@lst.de>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
         <20190503121838.GA21041@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 06 May 2019 09:04:17 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2019-05-03 at 14:18 +0200, Christoph Hellwig wrote:
> I simply don't get the point of this series.
> 
> MDEV is an interface for exposing parts of a device to a userspace
> program / VM.  But that this series appears to do is to expose a
> purely software defined nvme controller to userspace.  Which in
> principle is a good idea, but we have a much better framework for that,
> which is called vhost.

Let me explain the reasons for choosing the IO interfaces as I did:

1. Frontend interface (the interface that faces the guest/userspace/etc):

VFIO/mdev is just way to expose a (partially) software defined PCIe device to a
guest.

Vhost on the other hand is an interface that is hardcoded and optimized for
virtio. It can be extended to be pci generic, but why to do so if we already
have VFIO.

So the biggest advantage of using VFIO _currently_ is that I don't add any new
API/ABI to the kernel, and neither the userspace (qemu) needs to learn to use a
new API. 

It also worth noting that VFIO supports nesting out of box, so I don't need to
worry about it (vhost has to deal with that on the protocol level using its
IOTLB facility).

On top of that, it is expected that newer hardware will support the PASID based
device subdivision, which will allow us to _directly_ pass through the
submission queues of the device and _force_ us to use the NVME protocol for the
frontend.

2. Backend interface (the connection to the real nvme device):

Currently the backend interface _doesn't have_ to allocate a dedicated queue and
bypass the block layer. It can use the block submit_bio/blk_poll as I
demonstrate in the last patch in the series. Its 2x slower though.

However, similar to the (1), when the driver will support the devices with
hardware based passthrough, it will have to dedicate a bunch of queues to the
guest, configure them with the appropriate PASID, and then let the guest use
these queues directly.


Best regards,
	Maxim Levitsky

