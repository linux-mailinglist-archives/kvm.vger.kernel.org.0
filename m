Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9BFB37F33
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 23:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfFFVBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 17:01:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63726 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbfFFVBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 17:01:45 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2DB0AC057F2C;
        Thu,  6 Jun 2019 21:01:37 +0000 (UTC)
Received: from ultra.random (ovpn-120-155.rdu2.redhat.com [10.10.120.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D20537D5B4;
        Thu,  6 Jun 2019 21:01:32 +0000 (UTC)
Date:   Thu, 6 Jun 2019 17:01:31 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [patch v2 3/3] cpuidle-haltpoll: disable host side polling when
 kvm virtualized
Message-ID: <20190606210131.GE20928@redhat.com>
References: <20190603225242.289109849@amt.cnet>
 <20190603225254.360289262@amt.cnet>
 <20190604122404.GA18979@amt.cnet>
 <cb11ef01-b579-1526-d585-0c815f2e1f6f@oracle.com>
 <20190606183632.GA20928@redhat.com>
 <7f988399-7718-d4f4-f59c-792fbcbcf9b3@oracle.com>
 <70bf0678-1ff7-bfc4-1ce2-fe7392ad663a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70bf0678-1ff7-bfc4-1ce2-fe7392ad663a@oracle.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 06 Jun 2019 21:01:45 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 06, 2019 at 08:22:40PM +0100, Joao Martins wrote:
> On 6/6/19 7:51 PM, Joao Martins wrote:
> > On 6/6/19 7:36 PM, Andrea Arcangeli wrote:
> >> Hello,
> >>
> >> On Thu, Jun 06, 2019 at 07:25:28PM +0100, Joao Martins wrote:
> >>> But I wonder whether we should fail to load cpuidle-haltpoll when host halt
> >>> polling can't be disabled[*]? That is to avoid polling in both host and guest
> >>> and *possibly* avoid chances for performance regressions when running on older
> >>> hypervisors?
> >>
> >> I don't think it's necessary: that would force an upgrade of the host
> >> KVM version in order to use the guest haltpoll feature with an
> >> upgraded guest kernel that can use the guest haltpoll.
> >>
> > Hence why I was suggesting a *guest* cpuidle-haltpoll module parameter to still
> > allow it to load or otherwise (or allow guest to pick).
> > 
> By 'still allow it to load', I meant specifically to handle the case when host
> polling control is not supported and what to do in that case.

All right, we could add a force=1 parameter to force loading as an
opt-in (and fail load by default with force=0).

> >> The guest haltpoll is self contained in the guest, so there's no
> >> reason to prevent that by design or to force upgrade of the KVM host
> >> version. It'd be more than enough to reload kvm.ko in the host with
> >> the host haltpoll set to zero with the module parameter already
> >> available, to achieve the same runtime without requiring a forced host
> >> upgrade.
> >>
> > It's just with the new driver we unilaterally poll on both sides, just felt I
> > would point it out should this raise unattended performance side effects ;)
> > 
> To be clear: by 'unilaterally' I was trying to refer to hosts KVM without
> polling control (which is safe to say that it is the majority atm?).
> 
> Alternatively, there's always the option that if guest sees any issues on that
> case (with polling on both sides=, that it can always blacklist
> cpuidle-haltpoll. But may this is not an issue and perhaps majority of users
> still observes benefit when polling is enabled on guest and host.

It should be workload dependent if it increases performance to
haltpoll both in both host kernel and guest, the only sure cons is
that it'd burn some more energy..

By default the cpuidle-haltpoll driver shouldn't get loaded if it's
built as a module (the expectation is the default will be =m), and it
can still easily disabled with rmmod if it hurts performance.

So the policy if to activate guest haltpoll or not will still reside
in the guest userland: the guest userland code or guest admin, without
a force parameter has to decide if to load or not to load the module,
with the force=1 parameter it'll have to decide if to load it with =0
or =1 (or load it first with =0 and then decide if to try to load it
again with =1 which would be the benefit the force parameter
provides). To decide if to load or not to load it, the guest userland
could check if there's no support for disabling the host haltpoll,
which can be verified with rdmsr too.

# rdmsr 0x4b564d05
rdmsr: CPU 0 cannot read MSR 0x4b564d05

Adding a force=1 parameter to force loading will just add a few lines
more of kernel code, I'm neutral on that but it looks fine either
ways.

Thanks,
Andrea
