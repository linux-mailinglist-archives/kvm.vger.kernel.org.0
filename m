Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4CC16DEB
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 01:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfEGXpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 19:45:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfEGXpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 19:45:09 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E966F8764B;
        Tue,  7 May 2019 23:45:08 +0000 (UTC)
Received: from amt.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E05921001E99;
        Tue,  7 May 2019 23:45:04 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 5A2AA10517B;
        Tue,  7 May 2019 20:44:49 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x47Nij80006291;
        Tue, 7 May 2019 20:44:45 -0300
Date:   Tue, 7 May 2019 20:44:45 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
Message-ID: <20190507234445.GA6185@amt.cnet>
References: <20190507185647.GA29409@amt.cnet>
 <20190507221519.GE2677@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507221519.GE2677@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 07 May 2019 23:45:09 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 12:15:19AM +0200, Peter Zijlstra wrote:
> On Tue, May 07, 2019 at 03:56:49PM -0300, Marcelo Tosatti wrote:
> > 
> > Certain workloads perform poorly on KVM compared to baremetal
> > due to baremetal's ability to perform mwait on NEED_RESCHED
> > bit of task flags (therefore skipping the IPI).
> > 
> > This patch introduces a configurable busy-wait delay before entering the
> > architecture delay routine, allowing wakeup IPIs to be skipped 
> > (if the IPI happens in that window).
> > 
> > The real-life workload which this patch improves performance
> > is SAP HANA (by 5-10%) (for which case setting idle_spin to 30 
> > is sufficient).
> > 
> > This patch improves the attached server.py and client.py example 
> > as follows:
> > 
> > Host:                           31.814230202231556
> > Guest:                          38.17718765199993       (83 %)
> > Guest, idle_spin=50us:          33.317709898000004      (95 %)
> > Guest, idle_spin=220us:         32.27826551499999       (98 %)
> > 
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> Thanks for the CC..
> 
> NAK, this is something that should live in a virt idle governor or
> something along those lines.

Ok, makes sense, will rework the patch!


