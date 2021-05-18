Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1EB387457
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 10:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347561AbhERIs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 04:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241591AbhERIs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 04:48:58 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D69EC061573;
        Tue, 18 May 2021 01:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Qo/ejMpseWPZweg994TuCvjOYtuu85Q0Ic4AlvPr1h8=; b=lC4eEu47b6H8uDkjU4w9yr+BPN
        OWXv04azGL5wtNekiPlJI0OxIFZfeoIG0JNnOw6R0LXlYIISYFzEP4EdgB7gPWqoRObeGzZPi0nRT
        aBLoyWcOC6QRjXHVl8sTckJwF3U/eF/EDAtMabaBecMW/mwXStZlW5DwP9oFcynvWLOtgkzMKbU3O
        yQn7KLRwV4yrxbTgpaFLAHLrmLu090zoDaOEMFshOzYtoCjlWtY2ilPccq9bdmsZSzxcjkYXMeHjk
        1XiCnb8QOlUX9ff9J8/2x0yVlbIhs54V+IuicKIEtPC3vBGIYySR3wlFXT7lKg6Dnuory24w38O88
        JSBniVvw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1livNf-00Hapq-Gs; Tue, 18 May 2021 08:47:11 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DE6AC30022A;
        Tue, 18 May 2021 10:47:09 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C58322BE6E846; Tue, 18 May 2021 10:47:09 +0200 (CEST)
Date:   Tue, 18 May 2021 10:47:09 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andi Kleen <ak@linux.intel.com>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 07/16] KVM: x86/pmu: Reprogram PEBS event to emulate
 guest PEBS counter
Message-ID: <YKN/DVNt847iEctd@hirez.programming.kicks-ass.net>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-8-like.xu@linux.intel.com>
 <YKIrtdbXRcZSiohg@hirez.programming.kicks-ass.net>
 <ff5a419f-188f-d14c-72c8-4b760052734d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff5a419f-188f-d14c-72c8-4b760052734d@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021 at 07:44:15AM -0700, Andi Kleen wrote:
> 
> On 5/17/2021 1:39 AM, Peter Zijlstra wrote:
> > On Tue, May 11, 2021 at 10:42:05AM +0800, Like Xu wrote:
> > > +	if (pebs) {
> > > +		/*
> > > +		 * The non-zero precision level of guest event makes the ordinary
> > > +		 * guest event becomes a guest PEBS event and triggers the host
> > > +		 * PEBS PMI handler to determine whether the PEBS overflow PMI
> > > +		 * comes from the host counters or the guest.
> > > +		 *
> > > +		 * For most PEBS hardware events, the difference in the software
> > > +		 * precision levels of guest and host PEBS events will not affect
> > > +		 * the accuracy of the PEBS profiling result, because the "event IP"
> > > +		 * in the PEBS record is calibrated on the guest side.
> > > +		 */
> > > +		attr.precise_ip = 1;
> > > +	}
> > You've just destroyed precdist, no?
> 
> precdist can mean multiple things:
> 
> - Convert cycles to the precise INST_RETIRED event. That is not meaningful
> for virtualization because "cycles" doesn't exist, just the raw events.
> 
> - For GLC+ and TNT+ it will force the event to a specific counter that is
> more precise. This would be indeed "destroyed", but right now the patch kit
> only supports Icelake which doesn't support that anyways.
> 
> So I think the code is correct for now, but will need to be changed for
> later CPUs. Should perhaps fix the comment though to discuss this.

OK, can we then do a better comment that explains *why* this is correct
now and what needs help later?

Because IIUC the only reason it is correct now is because:

 - we only support ICL

   * and ICL has pebs_format>=2, so {1,2} are the same
   * and ICL doesn't have precise_ip==3 support

 - Other hardware (GLC+, TNT+) that could possibly care here
   is unsupported atm. but needs changes.

None of which is actually mentioned in that comment it does have.
