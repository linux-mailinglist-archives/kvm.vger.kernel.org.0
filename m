Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F43314A75
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 14:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfEFM6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 08:58:13 -0400
Received: from verein.lst.de ([213.95.11.211]:52187 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfEFM6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 08:58:13 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 7423D67358; Mon,  6 May 2019 14:57:52 +0200 (CEST)
Date:   Mon, 6 May 2019 14:57:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Fam Zheng <fam@euphon.net>,
        Keith Busch <keith.busch@intel.com>,
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
Subject: Re: [PATCH v2 00/10] RFC: NVME MDEV
Message-ID: <20190506125752.GA5288@lst.de>
References: <20190502114801.23116-1-mlevitsk@redhat.com> <20190503121838.GA21041@lst.de> <e8f6981863bdbba89adcba1c430083e68546ac1a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8f6981863bdbba89adcba1c430083e68546ac1a.camel@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 06, 2019 at 12:04:06PM +0300, Maxim Levitsky wrote:
> 1. Frontend interface (the interface that faces the guest/userspace/etc):
> 
> VFIO/mdev is just way to expose a (partially) software defined PCIe device to a
> guest.
> 
> Vhost on the other hand is an interface that is hardcoded and optimized for
> virtio. It can be extended to be pci generic, but why to do so if we already
> have VFIO.

I wouldn't say vhost is virtio specific.  At least Hanne's vhost-nvme
doesn't get impacted by that a whole lot.

> 2. Backend interface (the connection to the real nvme device):
> 
> Currently the backend interface _doesn't have_ to allocate a dedicated queue and
> bypass the block layer. It can use the block submit_bio/blk_poll as I
> demonstrate in the last patch in the series. Its 2x slower though.
> 
> However, similar to the (1), when the driver will support the devices with
> hardware based passthrough, it will have to dedicate a bunch of queues to the
> guest, configure them with the appropriate PASID, and then let the guest useA
> these queues directly.

We will not let you abuse the nvme queues for anything else.  We had
that discussion with the mellanox offload and it not only unsafe but
also adds way to much crap to the core nvme code for corner cases.

Or to put it into another way:  unless your paravirt interface requires
zero specific changes to the core nvme code it is not acceptable at all.
