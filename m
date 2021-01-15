Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373F82F7E7B
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 15:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbhAOOpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 09:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729056AbhAOOpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 09:45:46 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E11DC0613C1;
        Fri, 15 Jan 2021 06:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HAt7yi8Bk1IOhi77FGzsXARD2yxrPISnLfMrCWR3Idw=; b=MpDbTwohxLvh/kyNgOG1M+x/LJ
        Ef3ZQ+n5b+cpH09Z41tFCdpjWg4bjR8kXmQWV1hv7rMImabhl6xDSl2guNqm7s8K83DU+z+laeLWP
        J6ubnIiaXhDGc4cishgMyEsrNBmuuOfwcnlwkyJq4CbASShypUHGiPnqznEylW1jZKbpefskw0hqt
        rjCapFt2v1fbhsDpMH8WVAGTgFIeFxCctuuXFK8/o9mwsABzjh1kmuXq50QEWgUEuSll6D1mGOSZs
        8AziIHvCvPqs/E+wyI6g0kAltcjUwMqgGqP9CvOutfoeo0UL11Rf7nN0ZlEiwozJ8BTbfs8XhjXEQ
        0xlUG3dw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l0QLE-000884-JS; Fri, 15 Jan 2021 14:44:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 62FFD301324;
        Fri, 15 Jan 2021 15:44:40 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4F59E20B5D691; Fri, 15 Jan 2021 15:44:40 +0100 (CET)
Date:   Fri, 15 Jan 2021 15:44:40 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/17] perf: x86/ds: Handle guest PEBS overflow PMI
 and inject it to guest
Message-ID: <YAGqWNl2FKxVussV@hirez.programming.kicks-ass.net>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-5-like.xu@linux.intel.com>
 <X/86UWuV/9yt14hQ@hirez.programming.kicks-ass.net>
 <9c343e40-bbdf-8af0-3307-5274070ee3d2@intel.com>
 <YAGEFgqQv281jVHc@hirez.programming.kicks-ass.net>
 <2c197d5a-09a8-968c-a942-c95d18983c9d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c197d5a-09a8-968c-a942-c95d18983c9d@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021 at 10:30:13PM +0800, Xu, Like wrote:

> > Are you sure? Spurious NMI/PMIs are known to happen anyway. We have far
> > too much code to deal with them.
> 
> https://lore.kernel.org/lkml/20170628130748.GI5981@leverpostej/T/
> 
> In the rr workload, the commit change "the PMI interrupts in skid region
> should be dropped"
> is reverted since some users complain that:
> 
> > It seems to me that it might be reasonable to ignore the interrupt if
> > the purpose of the interrupt is to trigger sampling of the CPUs
> > register state.  But if the interrupt will trigger some other
> > operation, such as a signal on an fd, then there's no reason to drop
> > it.
> 
> I assume that if the PMI drop is unacceptable, either will spurious PMI
> injection.
> 
> I'm pretty open if you insist that we really need to do this for guest PEBS
> enabling.

That was an entirely different issue. We were dropping events on the
floor because they'd passed priv boundaries. So there was an actual
event, and we made it go away.

What we're talking about here is raising an PMI with BUFFER_OVF set,
even if the DS is empty. That should really be harmless. We'll take the
PMI, find there's nothing there, and do nothing.
