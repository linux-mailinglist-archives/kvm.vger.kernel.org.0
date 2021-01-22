Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D152FFFA4
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 10:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbhAVJ7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 04:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727375AbhAVJ5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 04:57:22 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8828DC061788;
        Fri, 22 Jan 2021 01:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LOIQHL9x2mAeYTMhoeeG2U9wpg3O8N1h/6OElLbRyUs=; b=cDW7vsNYC6CaxNQm8EZ6I6PCqh
        PVHJZ5S7oX7zfBuRkRmkBqR2UrAGlFmmx8Xf9/Z75eVE2UguP7ZRKKWGyfkIy6sHjqviJocax8e3g
        +1L9fqITPfJOPAhFQGAyrjAsSF0Uvbg9RbWYsX5Q0H9m5uWv8V4ADJ7FgZNxBiM1dId9cPYc0f1/T
        a+uiDrZoSeO0I60c3XuHL0i7de1jE9lBZJdscw2Lcet0erlx5cqwW6tFaY6wgm18hwEGgR14ifzFI
        pZ8RJ+gFwKxWpBD58djPLTdjm5yP3rw9x0AEu5lrh76vb7I0gm9IFFmSwc7Ox48ux+deykcHtT14B
        kLqWu/3g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l2tAx-0008Sb-1V; Fri, 22 Jan 2021 09:56:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C12ED3003E1;
        Fri, 22 Jan 2021 10:56:12 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8D8BD200D6EE4; Fri, 22 Jan 2021 10:56:12 +0100 (CET)
Date:   Fri, 22 Jan 2021 10:56:12 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Andi Kleen <andi@firstfloor.org>, "Xu, Like" <like.xu@intel.com>,
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
Message-ID: <YAqhPPkexq+dQ5KD@hirez.programming.kicks-ass.net>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <YACXQwBPI8OFV1T+@google.com>
 <f8a8e4e2-e0b1-8e68-81d4-044fb62045d5@intel.com>
 <YAHXlWmeR9p6JZm2@google.com>
 <20210115182700.byczztx3vjhsq3p3@two.firstfloor.org>
 <YAHkOiQsxMfOMYvp@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAHkOiQsxMfOMYvp@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021 at 10:51:38AM -0800, Sean Christopherson wrote:
> On Fri, Jan 15, 2021, Andi Kleen wrote:
> > > I'm asking about ucode/hardare.  Is the "guest pebs buffer write -> PEBS PMI"
> > > guaranteed to be atomic?
> > 
> > Of course not.
> 
> So there's still a window where the guest could observe the bad counter index,
> correct?

Guest could do a hypercall to fix up the DS area before it tries to read
it I suppose. Or the HV could expose the index mapping and have the
guest fix up it.

Adding a little virt crud on top shouldn't be too hard.
