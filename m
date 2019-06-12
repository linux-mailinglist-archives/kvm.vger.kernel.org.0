Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 971C442C0E
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 18:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437774AbfFLQV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 12:21:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35330 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405705AbfFLQV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 12:21:26 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FB8F30BB524;
        Wed, 12 Jun 2019 16:21:26 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D02F71001B0F;
        Wed, 12 Jun 2019 16:21:25 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id EC7DC10516A;
        Wed, 12 Jun 2019 13:15:49 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x5CGFjFV004957;
        Wed, 12 Jun 2019 13:15:45 -0300
Date:   Wed, 12 Jun 2019 13:15:41 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v3 1/4] KVM: LAPIC: Make lapic timer unpinned when timer
 is injected by pi
Message-ID: <20190612161538.GA4764@amt.cnet>
References: <1560255429-7105-1-git-send-email-wanpengli@tencent.com>
 <1560255429-7105-2-git-send-email-wanpengli@tencent.com>
 <20190611203919.GB7520@amt.cnet>
 <CANRm+CxX4__=p8BJ_Dd6GbKrgEpQH733sN_FATYrD2jNRayXaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CxX4__=p8BJ_Dd6GbKrgEpQH733sN_FATYrD2jNRayXaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 12 Jun 2019 16:21:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 12, 2019 at 08:45:10AM +0800, Wanpeng Li wrote:
> On Wed, 12 Jun 2019 at 04:39, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >
> > On Tue, Jun 11, 2019 at 08:17:06PM +0800, Wanpeng Li wrote:
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > Make lapic timer unpinned when timer is injected by posted-interrupt,
> > > the emulated timer can be offload to the housekeeping cpus.
> > >
> > > The host admin should fine tuned, e.g. dedicated instances scenario
> > > w/ nohz_full cover the pCPUs which vCPUs resident, several pCPUs
> > > surplus for housekeeping, disable mwait/hlt/pause vmexits to occupy
> > > the pCPUs, fortunately preemption timer is disabled after mwait is
> > > exposed to guest which makes emulated timer offload can be possible.
> >
> > Li,
> >
> > Nice!
> >
> > I think you can drop the HRTIMER_MODE_ABS_PINNED and
> > instead have
> >
> > void kvm_set_pending_timer(struct kvm_vcpu *vcpu)
> > {
> >         kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
> >         kvm_vcpu_kick(vcpu);
> > }
> >
> > As an alternative to commit 61abdbe0bcc2b32745ab4479cc550f4c1f518ee2
> > (as a first patch in your series).
> >
> > This will make the logic simpler (and timer migration, for
> > nonhousekeeping case, ensures timer is migrated).
> 
> Good point. :)

Actually should probably revisit the KVM_REQ_PENDING_TIMER logic,
and only use the LAPIC injection to avoid guest entry,
and use LAPIC's vcpu_kick as well.

> > Also, should make this work for non housekeeping case as well.
> > (But that can be done later).
> 
> The timer fire may cause other vCPUs vmexits for non housekeeping
> case(after migrating timers fail during vCPU is scheduled to run in a
> different pCPU). 

There should be no timer migration fail in the non housekeeping case?

> Could you explain more?

Would have to find an optimal placement of interrupt handlers and vcpus.

Say, if a socket has 4 pcpus, and 3 vcpus, the free pcpu could house
the interrupt handlers.

But can start with housekeeping structure, then later find a solution
for nonhousekeeping.

