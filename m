Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9CA145A0
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 09:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfEFH4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 03:56:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfEFH4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 03:56:34 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04CB43086227;
        Mon,  6 May 2019 07:56:34 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 921CE5DA35;
        Mon,  6 May 2019 07:56:22 +0000 (UTC)
Message-ID: <599086a07da9943e1748d5608357ebc85b2330db.camel@redhat.com>
Subject: Re: [PATCH v2 08/10] nvme/pci: implement the mdev external queue
 allocation interface
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Keith Busch <keith.busch@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Liang Cunming <cunming.liang@intel.com>,
        Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        John Ferlan <jferlan@redhat.com>,
        Liu Changpeng <changpeng.liu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Heitke, Kenneth" <kenneth.heitke@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Amnon Ilan <ailan@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Date:   Mon, 06 May 2019 10:55:19 +0300
In-Reply-To: <20190503120915.GA30013@localhost.localdomain>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
         <20190502114801.23116-9-mlevitsk@redhat.com>
         <63a499c3-25be-5c5b-5822-124854945279@intel.com>
         <f1f471e0b734413e6c0f7a8bb1a03041b1d12d6d.camel@redhat.com>
         <20190503120915.GA30013@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 06 May 2019 07:56:34 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2019-05-03 at 06:09 -0600, Keith Busch wrote:
> On Fri, May 03, 2019 at 12:20:17AM +0300, Maxim Levitsky wrote:
> > On Thu, 2019-05-02 at 15:12 -0600, Heitke, Kenneth wrote:
> > > On 5/2/2019 5:47 AM, Maxim Levitsky wrote:
> > > > +static void nvme_ext_queue_free(struct nvme_ctrl *ctrl, u16 qid)
> > > > +{
> > > > +	struct nvme_dev *dev = to_nvme_dev(ctrl);
> > > > +	struct nvme_queue *nvmeq;
> > > > +
> > > > +	mutex_lock(&dev->ext_dev_lock);
> > > > +	nvmeq = &dev->queues[qid];
> > > > +
> > > > +	if (WARN_ON(!test_bit(NVMEQ_EXTERNAL, &nvmeq->flags)))
> > > > +		return;
> > > 
> > > This condition is probably not expected to happen (since its a warning)
> > > but do you need to unlock the ext_dev_lock before returning?
> > 
> > This is true, I will fix this. This used to be BUG_ON, but due to
> > checkpatch.pl
> > complains I turned them all to WARN_ON, and missed this.
> 
> Gentle reminder to trim your replies to the relevant context. It's
> much easier to read when we don't need to scroll through hundreds of
> unnecessary lines.

I fully agree, sorry! Next time I will do this.
Best regards,
	Maxim Levitsky

