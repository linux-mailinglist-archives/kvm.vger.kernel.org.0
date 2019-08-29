Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03186A1984
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 14:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfH2MEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 08:04:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfH2MEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 08:04:46 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5099649;
        Thu, 29 Aug 2019 12:04:45 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85FC619D7A;
        Thu, 29 Aug 2019 12:04:41 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 8408F105140;
        Thu, 29 Aug 2019 09:04:24 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x7TC4Mmr010498;
        Thu, 29 Aug 2019 09:04:22 -0300
Date:   Thu, 29 Aug 2019 09:04:22 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when
 dedicated physical CPUs are available
Message-ID: <20190829120422.GC4949@amt.cnet>
References: <7b1e3025-f513-7068-32ac-4830d67b65ac@intel.com>
 <c3fe182f-627f-88ad-cb4d-a4189202b438@redhat.com>
 <20190803202058.GA9316@amt.cnet>
 <CANRm+CwtHBOVWFcn+6Z3Ds7dEcNL2JP+b6hLRS=oeUW98A24MQ@mail.gmail.com>
 <20190826204045.GA24697@amt.cnet>
 <CANRm+Cx0+V67Ek7FhSs61ZqZL3MgV88Wdy17Q6UA369RH7=dgQ@mail.gmail.com>
 <CANRm+CxqYMzgvxYyhZLmEzYd6SLTyHdRzKVaSiHO-4SV+OwZUQ@mail.gmail.com>
 <CAJZ5v0iQc0-WzqeyAh-6m5O-BLraRMj+Z7sqvRgGwh2u2Hp7cg@mail.gmail.com>
 <20190828143916.GA13725@amt.cnet>
 <CAJZ5v0jiBprGrwLAhmLbZKpKUvmKwG9w4_R7+dQVqswptis5Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0jiBprGrwLAhmLbZKpKUvmKwG9w4_R7+dQVqswptis5Qg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Thu, 29 Aug 2019 12:04:45 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 01:37:35AM +0200, Rafael J. Wysocki wrote:
> On Wed, Aug 28, 2019 at 4:39 PM Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >
> > On Wed, Aug 28, 2019 at 10:45:44AM +0200, Rafael J. Wysocki wrote:
> > > On Wed, Aug 28, 2019 at 10:34 AM Wanpeng Li <kernellwp@gmail.com> wrote:
> > > >
> > > > On Tue, 27 Aug 2019 at 08:43, Wanpeng Li <kernellwp@gmail.com> wrote:
> > > > >
> > > > > Cc Michael S. Tsirkin,
> > > > > On Tue, 27 Aug 2019 at 04:42, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Aug 13, 2019 at 08:55:29AM +0800, Wanpeng Li wrote:
> > > > > > > On Sun, 4 Aug 2019 at 04:21, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Thu, Aug 01, 2019 at 06:54:49PM +0200, Paolo Bonzini wrote:
> > > > > > > > > On 01/08/19 18:51, Rafael J. Wysocki wrote:
> > > > > > > > > > On 8/1/2019 9:06 AM, Wanpeng Li wrote:
> > > > > > > > > >> From: Wanpeng Li <wanpengli@tencent.com>
> > > > > > > > > >>
> > > > > > > > > >> The downside of guest side polling is that polling is performed even
> > > > > > > > > >> with other runnable tasks in the host. However, even if poll in kvm
> > > > > > > > > >> can aware whether or not other runnable tasks in the same pCPU, it
> > > > > > > > > >> can still incur extra overhead in over-subscribe scenario. Now we can
> > > > > > > > > >> just enable guest polling when dedicated pCPUs are available.
> > > > > > > > > >>
> > > > > > > > > >> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > > > > >> Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > > > > >> Cc: Radim Krčmář <rkrcmar@redhat.com>
> > > > > > > > > >> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > > > > > > >> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > > > > > > >
> > > > > > > > > > Paolo, Marcelo, any comments?
> > > > > > > > >
> > > > > > > > > Yes, it's a good idea.
> > > > > > > > >
> > > > > > > > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > > >
> > > > Hi Marcelo,
> > > >
> > > > If you don't have more concern, I guess Rafael can apply this patch
> > > > now since the merge window is not too far.
> > >
> > > I will likely queue it up later today and it will go to linux-next
> > > early next week.
> > >
> > > Thanks!
> >
> > NACK patch.
> 
> I got an ACK from Paolo on it, though.  Convince Paolo to withdraw his
> ACK if you want it to not be applied.
> 
> > Just don't load the haltpoll driver.
> 
> And why would that be better?

Split the group of all kvm users in two: overcommit group and non-overcommit
group.

Current situation regarding haltpoll driver is:

overcommit group: haltpoll driver is not loaded by default, they are
happy.

non overcommit group: boots without "realtime hints" flag, loads haltpoll driver, 
happy.

Situation with patch above:

overcommit group: haltpoll driver is not loaded by default, they are
happy.

non overcommit group: boots without "realtime hints" flag, haltpoll driver
cannot be loaded.




