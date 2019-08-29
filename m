Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A07CA1D6A
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 16:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfH2Ojl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 10:39:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52689 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727899AbfH2Ojl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 10:39:41 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B31A820ABB;
        Thu, 29 Aug 2019 14:39:40 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 724BB196B2;
        Thu, 29 Aug 2019 14:39:38 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 6614A105140;
        Thu, 29 Aug 2019 11:39:11 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x7TEd7P8014097;
        Thu, 29 Aug 2019 11:39:07 -0300
Date:   Thu, 29 Aug 2019 11:39:06 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when
 dedicated physical CPUs are available
Message-ID: <20190829143904.GA13983@amt.cnet>
References: <CANRm+CwtHBOVWFcn+6Z3Ds7dEcNL2JP+b6hLRS=oeUW98A24MQ@mail.gmail.com>
 <20190826204045.GA24697@amt.cnet>
 <CANRm+Cx0+V67Ek7FhSs61ZqZL3MgV88Wdy17Q6UA369RH7=dgQ@mail.gmail.com>
 <CANRm+CxqYMzgvxYyhZLmEzYd6SLTyHdRzKVaSiHO-4SV+OwZUQ@mail.gmail.com>
 <CAJZ5v0iQc0-WzqeyAh-6m5O-BLraRMj+Z7sqvRgGwh2u2Hp7cg@mail.gmail.com>
 <20190828143916.GA13725@amt.cnet>
 <CAJZ5v0jiBprGrwLAhmLbZKpKUvmKwG9w4_R7+dQVqswptis5Qg@mail.gmail.com>
 <20190829120422.GC4949@amt.cnet>
 <CANRm+CwYq7NZeKffioWcHy_oWGyeHqXsygF_cppMD17mHuVgYw@mail.gmail.com>
 <20190829125304.GA12214@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829125304.GA12214@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 29 Aug 2019 14:39:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 09:53:04AM -0300, Marcelo Tosatti wrote:
> On Thu, Aug 29, 2019 at 08:16:41PM +0800, Wanpeng Li wrote:
> > > Current situation regarding haltpoll driver is:
> > >
> > > overcommit group: haltpoll driver is not loaded by default, they are
> > > happy.
> > >
> > > non overcommit group: boots without "realtime hints" flag, loads haltpoll driver,
> > > happy.
> > >
> > > Situation with patch above:
> > >
> > > overcommit group: haltpoll driver is not loaded by default, they are
> > > happy.
> > >
> > > non overcommit group: boots without "realtime hints" flag, haltpoll driver
> > > cannot be loaded.
> > 
> > non overcommit group, if they don't care latency/performance, they
> > don't need to enable haltpoll, "realtime hints" etc. Otherwise, they
> > should better tune.
> 
> As mentioned before, "being overcommitted" is a property which is transitional.
> 
> A static true/false scheme reflects this poorly.
> 
> Therefore the OS should detect it and act accordingly.

Hi Wanpeng Li,

One suggestion for a dynamic "is overcommited" scheme:

If the amount of stolen time, in the past record_steal_time window, 
is more than 20% of the time in that window, then mark system
as overcommitted. Otherwise, clear it.

Make that 20% configurable by as kvm module parameter.

Use that info to enable/disable overcommit features.

That should work, right?




