Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820E0151E6
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 18:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfEFQtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 12:49:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:25683 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbfEFQtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 12:49:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 May 2019 09:49:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,438,1549958400"; 
   d="scan'208";a="230002448"
Received: from unknown (HELO localhost.localdomain) ([10.232.112.69])
  by orsmga001.jf.intel.com with ESMTP; 06 May 2019 09:49:01 -0700
Date:   Mon, 6 May 2019 10:43:25 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, Fam Zheng <fam@euphon.net>,
        "Busch, Keith" <keith.busch@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Amnon Ilan <ailan@redhat.com>, John Ferlan <jferlan@redhat.com>
Subject: Re: [PATCH v2 00/10] RFC: NVME MDEV
Message-ID: <20190506164325.GB2219@localhost.localdomain>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
 <20190503121838.GA21041@lst.de>
 <e8f6981863bdbba89adcba1c430083e68546ac1a.camel@redhat.com>
 <20190506125752.GA5288@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506125752.GA5288@lst.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 06, 2019 at 05:57:52AM -0700, Christoph Hellwig wrote:
> > However, similar to the (1), when the driver will support the devices with
> > hardware based passthrough, it will have to dedicate a bunch of queues to the
> > guest, configure them with the appropriate PASID, and then let the guest useA
> > these queues directly.
> 
> We will not let you abuse the nvme queues for anything else.  We had
> that discussion with the mellanox offload and it not only unsafe but
> also adds way to much crap to the core nvme code for corner cases.
> 
> Or to put it into another way:  unless your paravirt interface requires
> zero specific changes to the core nvme code it is not acceptable at all.

I agree we shouldn't specialize generic queues for this, but I think
it is worth revisiting driver support for assignable hardware resources
iff the specification defines it.

Until then, you can always steer processes to different queues by
assigning them to different CPUs.
