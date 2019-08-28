Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7321AA055F
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 16:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfH1Oww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 10:52:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbfH1Owv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 10:52:51 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 902B3A53271;
        Wed, 28 Aug 2019 14:52:51 +0000 (UTC)
Received: from amt.cnet (ovpn-112-8.gru2.redhat.com [10.97.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B2126060D;
        Wed, 28 Aug 2019 14:52:49 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 8D696105139;
        Wed, 28 Aug 2019 11:52:31 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x7SEqVZx014465;
        Wed, 28 Aug 2019 11:52:31 -0300
Date:   Wed, 28 Aug 2019 11:52:31 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when
 dedicated physical CPUs are available
Message-ID: <20190828145231.GA14426@amt.cnet>
References: <1564643196-7797-1-git-send-email-wanpengli@tencent.com>
 <7b1e3025-f513-7068-32ac-4830d67b65ac@intel.com>
 <c3fe182f-627f-88ad-cb4d-a4189202b438@redhat.com>
 <20190803202058.GA9316@amt.cnet>
 <CANRm+CwtHBOVWFcn+6Z3Ds7dEcNL2JP+b6hLRS=oeUW98A24MQ@mail.gmail.com>
 <20190826204045.GA24697@amt.cnet>
 <CANRm+Cx0+V67Ek7FhSs61ZqZL3MgV88Wdy17Q6UA369RH7=dgQ@mail.gmail.com>
 <20190828144858.GA14215@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828144858.GA14215@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Wed, 28 Aug 2019 14:52:51 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 11:48:58AM -0300, Marcelo Tosatti wrote:
> On Tue, Aug 27, 2019 at 08:43:13AM +0800, Wanpeng Li wrote:
> > > > kvm adaptive halt-polling will compete with
> > > > vhost-kthreads, however, poll in guest unaware other runnable tasks in
> > > > the host which will defeat vhost-kthreads.
> > >
> > > It depends on how much work vhost-kthreads needs to do, how successful
> > > halt-poll in the guest is, and what improvement halt-polling brings.
> > > The amount of polling will be reduced to zero if polling
> > > is not successful.
> > 
> > We observe vhost-kthreads compete with vCPUs adaptive halt-polling in
> > kvm, it hurt performance in over-subscribe product environment,
> > polling in guest can make it worse.
> > 
> > Regards,
> > Wanpeng Li
> 
> Wanpeng,
> 
> Polling should not be performed if there is other work to do. For
> example, halt-polling could check a host/guest shared memory 
> region indicating whether there are other runnable tasks in the host.
> 
> Disabling polling means you will not achieve the improvement 
> even in the transitional periods where the system is not
> overcommitted (which should be frequent given that idling 
> is common).
> 
> Again, about your patch: it brings no benefit to anyone. 
> 
> Guest halt polling should be already disabled by default
> (the driver has to be loaded for guest polling to take place).

The most efficient solution would be to mwait on a memory 
region that both host and guest would write to.

No cpu cycles burned, full efficiency.

However both host and guest would have to write to this region, which
brings security concerns.


