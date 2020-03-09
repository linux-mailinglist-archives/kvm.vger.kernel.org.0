Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAE517E315
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 16:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgCIPGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 11:06:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38886 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbgCIPGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 11:06:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r2s3gIPBweXfuFOjhh7nUBoOiFWLhoiQfZtS6vOmD/A=; b=c3HOGujTpXWo2lQjkzMSyzqsLX
        Ejq9uuXrAcpnK7/Jr3R3P3LlOR3Mp7JfLouaPortD2AFz8/kt1wys/i01pTg0ltHTdT8HlrD3IB63
        k2AUnHDbabmyptmuhxK/yOY37iilBGoYguHSxUWMiSt0aUNi2gxldIiX8/u4//h6RImZnMvwwN4Ng
        zhbheTvFKLSKeHJRuG3pojWQXU5FrBKqBIkGh2UeG9S2TSTavcZyQmtHzP3hrDInD7UtYRJnlMwnl
        aQLe+odfbh3LVrJSQeOmQ6Z2DSl8MXYh/jtL3fls0AYJx8wlCnLwBd1yUL1nVUGG6bFAWi2CCemQD
        jWiYPTzg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBJyD-00074L-Ms; Mon, 09 Mar 2020 15:05:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 22B303058B4;
        Mon,  9 Mar 2020 16:05:26 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0A12D284A2808; Mon,  9 Mar 2020 16:05:26 +0100 (CET)
Date:   Mon, 9 Mar 2020 16:05:26 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     Luwei Kang <luwei.kang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, tglx@linutronix.de, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        like.xu@linux.intel.com
Subject: Re: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a
 dedicated counter for guest PEBS
Message-ID: <20200309150526.GI12561@hirez.programming.kicks-ass.net>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
 <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
 <20200306135317.GD12561@hirez.programming.kicks-ass.net>
 <b72cb68e-1a0a-eeff-21b4-ce412e939cfd@linux.intel.com>
 <20200309100443.GG12561@hirez.programming.kicks-ass.net>
 <97ce1ba4-d75a-8db2-ea2f-7d334942b4e6@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97ce1ba4-d75a-8db2-ea2f-7d334942b4e6@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 09:12:42AM -0400, Liang, Kan wrote:

> > Suppose your KVM thing claims counter 0/2 (ICL/SKL) for some random PEBS
> > event, and then the host wants to use PREC_DIST.. Then one of them will
> > be screwed for no reason what so ever.
> > 
> 
> The multiplexing should be triggered.
> 
> For host, if both user A and user B requires PREC_DIST, the multiplexing
> should be triggered for them.
> Now, the user B is KVM. I don't think there is difference. The multiplexing
> should still be triggered. Why it is screwed?

Becuase if KVM isn't PREC_DIST we should be able to reschedule it to a
different counter.

> > How is that not destroying scheduling freedom? Any other situation we'd
> > have moved the !PREC_DIST PEBS event to another counter.
> > 
> 
> All counters are equivalent for them. It doesn't matter if we move it to
> another counter. There is no impact for the user.

But we cannot move it to another counter, because you're pinning it.

> In the new proposal, KVM user is treated the same as other host events with
> event constraint. The scheduler is free to choose whether or not to assign a
> counter for it.

That's what it does, I understand that. I'm saying that that is creating
artificial contention.


Why is this needed anyway? Can't we force the guest to flush and then
move it over to a new counter?
