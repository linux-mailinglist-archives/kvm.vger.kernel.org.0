Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E241F30342E
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731743AbhAZFSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbhAYMwF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 07:52:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B75C0613D6;
        Mon, 25 Jan 2021 03:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IZD+dGpJMuaKiBFySlf5qc6OjXdYWk5ceY7IXIWaNrA=; b=mu5dcukKGytbgmut4RSw7dYW5p
        jcb5tnp16OjtgRykfyfz5gM6Dcvxvfy0l8Ql2XjjHmacq88H1SRBUDZzA49ulM4kutjU+0VK5jQ5t
        nS723mOgAWmB0I0wvGGuVnT9tuEgrTxGokhUpEpSSYtThg6mCJ0/Fdo1N9TF32vKLai9XtwyZmu4/
        rUTHV7jKaxH5JlUbT+TV0sn/gaIddu4ScySHHYGa92fn+GEcyP3P585VchE6U0i4hG4OR38Rr18f0
        B2ZwNZH5TE4p88Ve/9VJhdKASrdNHY/4OhvapqGRj97q34yGtlHXAElDKADMLIXYX/FkDSn28LE6+
        xLtPT5ew==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l3zo1-0047fH-T7; Mon, 25 Jan 2021 11:13:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 76CE43003D8;
        Mon, 25 Jan 2021 12:13:10 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 401F82B0615F7; Mon, 25 Jan 2021 12:13:10 +0100 (CET)
Date:   Mon, 25 Jan 2021 12:13:10 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Xu, Like" <like.xu@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
Message-ID: <YA6nxuM5Stlolk5x@hirez.programming.kicks-ass.net>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <YACXQwBPI8OFV1T+@google.com>
 <f8a8e4e2-e0b1-8e68-81d4-044fb62045d5@intel.com>
 <YAHXlWmeR9p6JZm2@google.com>
 <20210115182700.byczztx3vjhsq3p3@two.firstfloor.org>
 <YAHkOiQsxMfOMYvp@google.com>
 <YAqhPPkexq+dQ5KD@hirez.programming.kicks-ass.net>
 <eb30d86f-6492-d6e3-3a24-f58c724f68fd@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb30d86f-6492-d6e3-3a24-f58c724f68fd@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021 at 04:08:22PM +0800, Like Xu wrote:
> Hi Peter,
> 
> On 2021/1/22 17:56, Peter Zijlstra wrote:
> > On Fri, Jan 15, 2021 at 10:51:38AM -0800, Sean Christopherson wrote:
> > > On Fri, Jan 15, 2021, Andi Kleen wrote:
> > > > > I'm asking about ucode/hardare.  Is the "guest pebs buffer write -> PEBS PMI"
> > > > > guaranteed to be atomic?
> > > > 
> > > > Of course not.
> > > 
> > > So there's still a window where the guest could observe the bad counter index,
> > > correct?
> > 
> > Guest could do a hypercall to fix up the DS area before it tries to read
> > it I suppose. Or the HV could expose the index mapping and have the
> > guest fix up it.
> 
> A weird (malicious) guest would read unmodified PEBS records in the
> guest PEBS buffer from other vCPUs without the need for hypercall or
> index mapping from HV.
> 
> Do you see any security issues on this host index leak window?
> 
> > 
> > Adding a little virt crud on top shouldn't be too hard.
> > 
> 
> The patches 13-17 in this version has modified the guest PEBS buffer
> to correct the index mapping information in the guest PEBS records.

Right, but given there is no atomicity between writing the DS area and
triggering the PMI (as already established earlier in this thread), a
malicious guest can already access this information, no?

