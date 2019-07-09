Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5EA63582
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 14:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfGIMT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 08:19:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38406 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfGIMT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 08:19:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MyOM/2+Oky6LA/ruPYXuAPmONroqpqYRgUXxYrFYTtU=; b=KfuIHfV3koXqt/Jts8MD8/W13
        kcWhPz76IGYboyZ91/lOMi79ryn1hSa5CrP8xODQz7iu6znhrFfbKx9pGQQ3K2XV4OS3LhllSSx9P
        jSCCnwXHtnqWh/mEXk4b3twzA4+txHM9evX3i0hVznLo13nEqPhIxDGP2muJu2JOUDo2SOMe+y670
        HUO0FO9aunk8oyURXUG3rkcVJ7PaDMBJB5Xb8cMhzQ+QnBhlqLALcqOPUPC6Nje3HmHmLpFnB3aY3
        Sdn2AnUFb07o379hd7WwHPgavnSx8vu+T9E+N+uo7cdDQX2KqDyX1ZLzUTKDjBnvS6aQPW/2uIz4+
        EPEycpoWw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hkp5W-0003r6-Kz; Tue, 09 Jul 2019 12:19:14 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E28E320976D87; Tue,  9 Jul 2019 14:19:12 +0200 (CEST)
Date:   Tue, 9 Jul 2019 14:19:12 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, kan.liang@intel.com,
        mingo@redhat.com, rkrcmar@redhat.com, like.xu@intel.com,
        jannh@google.com, arei.gonglei@huawei.com, jmattson@google.com
Subject: Re: [PATCH v7 08/12] KVM/x86/vPMU: Add APIs to support host
 save/restore the guest lbr stack
Message-ID: <20190709121912.GY3402@hirez.programming.kicks-ass.net>
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com>
 <1562548999-37095-9-git-send-email-wei.w.wang@intel.com>
 <20190708144831.GN3402@hirez.programming.kicks-ass.net>
 <5D240435.2040801@intel.com>
 <20190709093917.GS3402@hirez.programming.kicks-ass.net>
 <5D247BC2.70104@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D247BC2.70104@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 09, 2019 at 07:34:26PM +0800, Wei Wang wrote:

> > But what about the counter scheduling rules;
> 
> The counter is emulated independent of the lbr emulation.

> > what happens when a CPU
> > event claims the LBR before the task event can claim it? CPU events have
> > precedence over task events.
> 
> I think the precedence (cpu pined and task pined) is for the counter
> multiplexing,
> right?

No; for all scheduling. The order is:

  CPU-pinned
  Task-pinned
  CPU-flexible
  Task-flexible

The way you created the event it would land in 'task-flexible', but even
if you make it task-pinned, a CPU (or CPU-pinned) event could claim the
LBR before your fake event.

> For the lbr feature, could we thought of it as first come, first served?
> For example, if we have 2 host threads who want to use lbr at the same time,
> I think one of them would simply fail to use.
>
> So if guest first gets the lbr, host wouldn't take over unless some
> userspace command (we added to QEMU) is executed to have the vCPU
> actively stop using lbr.

Doesn't work that way.

Say you start KVM with LBR emulation, it creates this task event, it
gets the LBR (nobody else wants it) and the guest works and starts using
the LBR.

Then the host creates a CPU LBR event and the vCPU suddenly gets denied
the LBR and the guest no longer functions correctly.

Or you should fail to VMENTER, in which case you starve the guest, but
at least it doesn't malfunction.

