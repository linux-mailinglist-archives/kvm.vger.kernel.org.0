Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D881CEEF
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 20:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfENSUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 14:20:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbfENSUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 14:20:45 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AAD214DB11;
        Tue, 14 May 2019 18:20:44 +0000 (UTC)
Received: from amt.cnet (ovpn-112-6.gru2.redhat.com [10.97.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E022608AC;
        Tue, 14 May 2019 18:20:41 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 05C3310517B;
        Tue, 14 May 2019 14:42:42 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x4EHgccD013133;
        Tue, 14 May 2019 14:42:38 -0300
Date:   Tue, 14 May 2019 14:42:37 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, kvm-devel <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
Message-ID: <20190514174235.GA12269@amt.cnet>
References: <20190507185647.GA29409@amt.cnet>
 <CANRm+Cx8zCDG6Oz1m9eukkmx_uVFYcQOdMwZrHwsQcbLm_kuPA@mail.gmail.com>
 <20190514135022.GD4392@amt.cnet>
 <20190514152015.GM20906@char.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514152015.GM20906@char.us.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 14 May 2019 18:20:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 14, 2019 at 11:20:15AM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, May 14, 2019 at 10:50:23AM -0300, Marcelo Tosatti wrote:
> > On Mon, May 13, 2019 at 05:20:37PM +0800, Wanpeng Li wrote:
> > > On Wed, 8 May 2019 at 02:57, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > >
> > > >
> > > > Certain workloads perform poorly on KVM compared to baremetal
> > > > due to baremetal's ability to perform mwait on NEED_RESCHED
> > > > bit of task flags (therefore skipping the IPI).
> > > 
> > > KVM supports expose mwait to the guest, if it can solve this?
> > > 
> > > Regards,
> > > Wanpeng Li
> > 
> > Unfortunately mwait in guest is not feasible (uncompatible with multiple
> > guests). Checking whether a paravirt solution is possible.
> 
> There is the obvious problem with that the guest can be malicious and
> provide via the paravirt solution bogus data. That is it expose 0% CPU
> usage but in reality be mining and using 100%.

The idea is to have a hypercall for the guest to perform the
need_resched=1 bit set. It can only hurt itself.


