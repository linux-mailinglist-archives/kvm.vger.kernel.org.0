Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BE42B67A1
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 15:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgKQOf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 09:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbgKQOf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 09:35:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A55C0613CF;
        Tue, 17 Nov 2020 06:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sollcZRLnQJ8RrafQij/FmHLw4zZVs0otZjXpirh3Ew=; b=XvjFyytAeKKVlJlLTby1rvMj7n
        25wQJIA3xixyu+91CeN1Z5/ShGkAJtd+CJzTFPJiolWrKNipizl3VMKhr7oHyo1FTmQ5fYTgvKVAM
        KQOEdSuEBBSAbVT+NjTrHu3TnPGXaudIlwsQ0grrNmoUOaLtXyvwkBELbyK63d33XwpRxTA4cr2h9
        AdSm5yP9EKmNb3J4WJcnmBhqfZHVgs/44LkqwZzUCQgw1KSdpDXAncle6Zlt4qkpuQP0aG8JFk+by
        nNuhv/0s15zlKPnxD/q1dYliRnGDDqdYch0pGzRCxnxHD61EAWnVzNL5Q31aqQFqtYbfYoEja8hUY
        LD+RaDGA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kf24x-00023e-1Z; Tue, 17 Nov 2020 14:35:31 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D3558307A49;
        Tue, 17 Nov 2020 15:35:29 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BDEE220113347; Tue, 17 Nov 2020 15:35:29 +0100 (CET)
Date:   Tue, 17 Nov 2020 15:35:29 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/17] perf: x86/ds: Handle guest PEBS overflow PMI
 and inject it to guest
Message-ID: <20201117143529.GJ3121406@hirez.programming.kicks-ass.net>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201109021254.79755-5-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109021254.79755-5-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 09, 2020 at 10:12:41AM +0800, Like Xu wrote:
> With PEBS virtualization, the PEBS records get delivered to the guest,
> and host still sees the PEBS overflow PMI from guest PEBS counters.
> This would normally result in a spurious host PMI and we needs to inject
> that PEBS overflow PMI into the guest, so that the guest PMI handler
> can handle the PEBS records.
> 
> Check for this case in the host perf PEBS handler. If a PEBS overflow
> PMI occurs and it's not generated from host side (via check host DS),
> a fake event will be triggered. The fake event causes the KVM PMI callback
> to be called, thereby injecting the PEBS overflow PMI into the guest.
> 
> No matter how many guest PEBS counters are overflowed, only triggering
> one fake event is enough. The guest PEBS handler would retrieve the
> correct information from its own PEBS records buffer.
> 
> If the counter_freezing is disabled on the host, a guest PEBS overflow
> PMI would be missed when a PEBS counter is enabled on the host side
> and coincidentally a host PEBS overflow PMI based on host DS_AREA is
> also triggered right after vm-exit due to the guest PEBS overflow PMI
> based on guest DS_AREA. In that case, KVM will disable guest PEBS before
> vm-entry once there's a host PEBS counter enabled on the same CPU.

How does this guest DS crud work? DS_AREA is a host virtual address;
ISTR there was lots of fail trying to virtualize it earlier. What's
changed? There's 0 clues here.

Why are the host and guest DS area separate, why can't we map them to
the exact same physical pages?

