Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F227614661
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 10:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfEFIbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 04:31:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbfEFIbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 04:31:34 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 397CE81DFA;
        Mon,  6 May 2019 08:31:34 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C8A11001DDE;
        Mon,  6 May 2019 08:31:25 +0000 (UTC)
Message-ID: <1cc7efd1852f298b01f09955f2c4bf3b20cead13.camel@redhat.com>
Subject: Re: [PATCH v2 06/10] nvme/core: add mdev interfaces
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Max Gurtovoy <maxg@mellanox.com>
Cc:     Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Keith Busch <keith.busch@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@infradead.org>,
        Liang Cunming <cunming.liang@intel.com>,
        Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        John Ferlan <jferlan@redhat.com>,
        Liu Changpeng <changpeng.liu@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Amnon Ilan <ailan@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Date:   Mon, 06 May 2019 11:31:27 +0300
In-Reply-To: <20190504064938.GA30814@lst.de>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
         <20190502114801.23116-7-mlevitsk@redhat.com>
         <20190503122902.GA5081@infradead.org>
         <d1c0c7ae-1a7d-06e5-d8bb-765a7fd5e41d@mellanox.com>
         <20190504064938.GA30814@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 06 May 2019 08:31:34 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2019-05-04 at 08:49 +0200, Christoph Hellwig wrote:
> On Fri, May 03, 2019 at 10:00:54PM +0300, Max Gurtovoy wrote:
> > Don't see a big difference of taking NVMe queue and namespace/partition to 
> > guest OS or to P2P since IO is issued by external entity and pooled outside 
> > the pci driver.
> 
> We are not going to the queue aside either way..  That is where the
> last patch in this series is already working to, and which would be
> the sensible vhost model to start with.

Why are you saying that? I actualy prefer to use a sepearate queue per software
nvme controller, tat because of lower overhead (about half than going through
the block layer) and it better at QoS as the separate queue (or even few queues
if needed) will give the guest a mostly guaranteed slice of the bandwidth of the
device.

The only drawback of this is some code duplication but that can be worked on
with some changes in the block layer.

The last patch in my series was done with 2 purposes in mind which are to
measure the overhead, and to maybe utilize that as a failback to non nvme
devices.

Best regards,
	Maxim Levitsky

