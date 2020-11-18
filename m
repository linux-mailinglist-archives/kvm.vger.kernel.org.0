Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E0F2B839B
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 19:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgKRSHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 13:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgKRSHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Nov 2020 13:07:52 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854E1C0613D4;
        Wed, 18 Nov 2020 10:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YzS91EnA1FNJiGjiBHPMzd0uYWSFicdq9v7Qv3Gu6Jk=; b=mjXXLuYtZ+K8Lc9yyxzUBqHmSO
        yKXigXTnSCMKh9dBvF4lRh2UEZNPCeZyav3DuPV2BVLZetszfu7eJEurk1w038QfIB0giEfyD8muW
        rhmlcEFZG+AvD6wQOmYtwG0YAQUWg2igIni9dmVzCbYT/z9vOKsCoErQfCZ8EL25oQ5ZRr7EEz3sQ
        M7BX+agZqE3/KM1KFnlYIGzGVlodxh29c8q5QMsDrrxlvJa0WeoaQTkrAgrE2ltdwwfppNGnw3KdQ
        xUUvJQ4FXyLZ2IZpf39R0rtHa3CWEUSpyJWypiglxj40GrqRVZs5s0W5+xCgfjevqJiopXTEv9/AN
        q9DwXrBw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfRrY-0007CP-5r; Wed, 18 Nov 2020 18:07:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D999F3012C3;
        Wed, 18 Nov 2020 19:07:21 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BB42C2BC7371A; Wed, 18 Nov 2020 19:07:21 +0100 (CET)
Date:   Wed, 18 Nov 2020 19:07:21 +0100
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
Message-ID: <20201118180721.GA3121392@hirez.programming.kicks-ass.net>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201109021254.79755-5-like.xu@linux.intel.com>
 <20201117143529.GJ3121406@hirez.programming.kicks-ass.net>
 <b2c3f889-44dd-cadb-f225-a4c5db3a4447@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2c3f889-44dd-cadb-f225-a4c5db3a4447@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 19, 2020 at 12:15:09AM +0800, Like Xu wrote:

> > ISTR there was lots of fail trying to virtualize it earlier. What's
> > changed? There's 0 clues here.
> 
> Ah, now we have EPT-friendly PEBS facilities supported since Ice Lake
> which makes guest PEBS feature possible w/o guest memory pinned.

OK.

> > Why are the host and guest DS area separate, why can't we map them to
> > the exact same physical pages?
> 
> If we map both guest and host DS_AREA to the exact same physical pages,
> - the guest can access the host PEBS records, which means that the host
> IP maybe leaked, because we cannot predict the time guest drains records and
> it would be over-designed to clean it up before each vm-entry;
> - different tasks/vcpus on the same pcpu cannot share the same PEBS DS
> settings from the same physical page. For example, some require large
> PEBS and reset values, while others do not.
> 
> Like many guest msrs, we use the separate guest DS_AREA for the guest's
> own use and it avoids mutual interference as little as possible.

OK, but the code here wanted to inspect the guest DS from the host. It
states this is somehow complicated/expensive. But surely we can at the
very least map the first guest DS page somewhere so we can at least
access the control bits without too much magic.
