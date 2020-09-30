Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F334F27F495
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 23:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbgI3V5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 17:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730470AbgI3V5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 17:57:25 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1D2C061755;
        Wed, 30 Sep 2020 14:57:24 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601503043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aE8dC9I5iKTJGv2hkvbLLzQFcBGFHFP/7J2ECzWs5Rw=;
        b=pwA8eJ1rz8WzO5MjZ1Kay52a8lgyypTxazoN9apYsq1+TD9DLP3zkX1BxEX0ZtiDdON2Lc
        hUfS1vRc7hVo4qZLyDGKLtJ9hhgRsQxPnfIYQupptsbwrXv1Gq6MoXc3rvZSfhVzmOfiMe
        J6mqjT66RmVTPDCQjDuuI3ITS5kS7SqqRvRvJGPkAQfwLLf3qZimT3K220ebxVy2XWjAci
        UOt0XFMLKwXiiNiMZ9Kxcdgi7kez/7I1a0csTVt6iiZ1yZUM3O7Sl6T2dYvxnBaaf3WLkM
        1n8G7Hawr2WoTXuJLX/6huBPe8QudF4g4Mvg2gSCk7kbLP/cMkmt2B0GWl+ccg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601503043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aE8dC9I5iKTJGv2hkvbLLzQFcBGFHFP/7J2ECzWs5Rw=;
        b=2sMwS7zfROc6xXIExg1b0iGDgg6gLNAfMrWZJRgLHJh4Y4JThgs/2h59DehPhq2BLB2Xq1
        yY1wK5ZMHUg9ICBw==
To:     "Raj\, Ashok" <ashok.raj@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, rafael@kernel.org,
        netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v3 05/18] dmaengine: idxd: add IMS support in base driver
In-Reply-To: <20200930214941.GB26492@otc-nc-03>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com> <160021248979.67751.3799965857372703876.stgit@djiang5-desk3.ch.intel.com> <87sgazgl0b.fsf@nanos.tec.linutronix.de> <20200930185103.GT816047@nvidia.com> <20200930214941.GB26492@otc-nc-03>
Date:   Wed, 30 Sep 2020 23:57:22 +0200
Message-ID: <87d023gc71.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 30 2020 at 14:49, Ashok Raj wrote:
>> It is the weirdest thing, IMHO. Intel defined a dvsec cap in their
>> SIOV cookbook, but as far as I can see it serves no purpose at
>> all.
>> 
>> Last time I asked I got some unclear mumbling about "OEMs".
>> 
> One of the parameters it has is the "supported system page-sizes" which is
> usually there in the SRIOV properties. So it needed a place holder for
> that. 
>
> IMS is a device specific capability, and I almost forgot why we needed
> until I had to checking internally. Remember when a device is given to a
> guest, MSIX routing via Interrupt Remapping is automatic via the VFIO/IRQFD
> and such.

-ENOPARSE

> When we provision an entire PCI device that is IMS capable. The guest
> driver does know it can update the IMS entries directly without going to
> the host. But in order to do remapping we need something like how we manage
> PASID allocation from guest, so an IRTE entry can be allocated and the host
> driver can write the proper values for IMS.

And how is that related to that capbility thing?

Also this stuff is host side and not guest side. I seriously doubt that
you want to hand in the whole PCI device which contains the IMS
thing. The whole point of IMS was as far as I was told that you can
create gazillions of subdevices and have seperate MSI interrupts for
each of them.

Thanks,

        tglx
