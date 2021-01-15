Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158F22F7832
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbhAOMC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbhAOMC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:02:56 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CBDC0613C1;
        Fri, 15 Jan 2021 04:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IEDy//10vz3URBwmS3YNZCnBj0jCnmtUNWcZq8+aI3I=; b=Nb/J2rF5gU4XJiiwYzj6u0+6nm
        3r9hlPur9ict7JhQI+BNNhAVV4Llr8F6bjMNNJ1VJ9xTCypx0DvvzTP1w4rlYMZx6SupQPYZOOCvd
        KX65JfiUIwiVDuaFuRAgbSSG11eVQ3Sq9qK8qmiDGPYUBrcpZLXTW2MCnZeJQPDZRBuV3KwEQ+34V
        MeU2sBIkrqu22movaTcol5xtmJE3n1YeU4iwJ5pED96YWGMLBrYcE5jtaX0hIzVVGr8JBJx8bG4za
        XgyYW1Flv/UCjcpPSr1VIeBvllNLuWzzf3SDqDBhWw8KUHQe4I5XgAr/tsDgMeXzVlziHUQtitNpX
        ebWPE+Lw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l0NnJ-000586-3G; Fri, 15 Jan 2021 12:01:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 229A33010CF;
        Fri, 15 Jan 2021 13:01:27 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F3E2520B5D699; Fri, 15 Jan 2021 13:01:26 +0100 (CET)
Date:   Fri, 15 Jan 2021 13:01:26 +0100
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
Message-ID: <YAGEFgqQv281jVHc@hirez.programming.kicks-ass.net>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-5-like.xu@linux.intel.com>
 <X/86UWuV/9yt14hQ@hirez.programming.kicks-ass.net>
 <9c343e40-bbdf-8af0-3307-5274070ee3d2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c343e40-bbdf-8af0-3307-5274070ee3d2@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021 at 11:39:00AM +0800, Xu, Like wrote:

> > Why do we need to? Can't we simply always forward the PMI if the guest
> > has bits set in MSR_IA32_PEBS_ENABLE ? Surely we can access the guest
> > MSRs at a reasonable rate..
> > 
> > Sure, it'll send too many PMIs, but is that really a problem?
> 
> More vPMI means more guest irq handler calls and
> more PMI virtualization overhead.

Only if you have both guest and host PEBS. And in that case I really
can't be arsed about some overhead to the guest.

> In addition,
> the correctness of some workloads (RR?) depends on
> the correct number of PMIs and the PMI trigger times
> and virt may not want to break this assumption.

Are you sure? Spurious NMI/PMIs are known to happen anyway. We have far
too much code to deal with them.

> > > +	 * If PEBS interrupt threshold on host is not exceeded in a NMI, there
> > > +	 * must be a PEBS overflow PMI generated from the guest PEBS counters.
> > > +	 * There is no ambiguity since the reported event in the PMI is guest
> > > +	 * only. It gets handled correctly on a case by case base for each event.
> > > +	 *
> > > +	 * Note: KVM disables the co-existence of guest PEBS and host PEBS.
> > Where; I need a code reference here.
> 
> How about:
> 
> Note: KVM will disable the co-existence of guest PEBS and host PEBS.
> In the intel_guest_get_msrs(), when we have host PEBS ctrl bit(s) enabled,
> KVM will clear the guest PEBS ctrl enable bit(s) before vm-entry.
> The guest PEBS users should be notified of this runtime restriction.

Since you had me look at that function, can clean up that
CONFIG_RETPOLINE crud and replace it with static_call() ?
