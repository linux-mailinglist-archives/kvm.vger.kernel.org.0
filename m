Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A74F357DA7
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 09:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhDHHxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 03:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDHHxa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 03:53:30 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA0FC061760;
        Thu,  8 Apr 2021 00:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=wCSDKuxNXp6i0Vj0NeH+Iq/7O86OSdHa4I1QJDn0nYo=; b=H1zy3h1cFL0t9/w1j+u1AYmOJM
        7tzpqyObA4qP/8WHx6oxgWwJkMQaLEvyqp/7rRIvClrQqIjoH2sGQA8BzwKfa9JQBl21fR2pL+nPj
        OwsdP2qGWPQfoUsbt0a0qTMw05cRRgd6cAWLaRjvxpHaAJ+QOTV9ENV/JwStpcMtQBr/EDGwe/Hyf
        2W6ac8f2pVwnJTOY048ajOGgWf8GarXobXsRk/FFtsGV/kv9APo5U2RpO6fPejgrYjHK5T+/nKS5x
        nc0E48uQtY0eSNna2WT608ay9D2vCUdJZBwyaU/LaGGVkLjZ5yRN8uEkmppeCLpy49FjeBqLubKuI
        gLOOdy2Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lUPTE-007HF3-8x; Thu, 08 Apr 2021 07:52:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 486903003E3;
        Thu,  8 Apr 2021 09:52:52 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 30ED424BF1903; Thu,  8 Apr 2021 09:52:52 +0200 (CEST)
Date:   Thu, 8 Apr 2021 09:52:52 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v4 08/16] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to
 manage guest DS buffer
Message-ID: <YG62VBBix2WVy3XA@hirez.programming.kicks-ass.net>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
 <20210329054137.120994-9-like.xu@linux.intel.com>
 <YG3SPsiFJPeXQXhq@hirez.programming.kicks-ass.net>
 <610bfd14-3250-0542-2d93-cbd15f2b4e16@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <610bfd14-3250-0542-2d93-cbd15f2b4e16@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021 at 01:39:49PM +0800, Xu, Like wrote:
> Hi Peter,
> 
> Thanks for your detailed comments.
> 
> If you have more comments for other patches, please let me know.
> 
> On 2021/4/7 23:39, Peter Zijlstra wrote:
> > On Mon, Mar 29, 2021 at 01:41:29PM +0800, Like Xu wrote:
> > > @@ -3869,10 +3876,12 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
> > >   		if (arr[1].guest)
> > >   			arr[0].guest |= arr[1].guest;
> > > -		else
> > > +		else {
> > >   			arr[1].guest = arr[1].host;
> > > +			arr[2].guest = arr[2].host;
> > > +		}
> > What's all this gibberish?
> > 
> > The way I read that it says:
> > 
> > 	if guest has PEBS_ENABLED
> > 		guest GLOBAL_CTRL |= PEBS_ENABLED
> > 	otherwise
> > 		guest PEBS_ENABLED = host PEBS_ENABLED
> > 		guest DS_AREA = host DS_AREA
> > 
> > which is just completely random garbage afaict. Why would you leak host
> > msrs into the guest?
> 
> In fact, this is not a leak at all.
> 
> When we do "arr[i].guest = arr[i].host;" assignment in the
> intel_guest_get_msrs(), the KVM will check "if (msrs[i].host ==
> msrs[i].guest)" and if so, it disables the atomic switch for this msr
> during vmx transaction in the caller atomic_switch_perf_msrs().

Another marvel of bad coding style that function is :-( Lots of missing
{} and indentation fail.

This is terrible though, why would we clear the guest MSRs when it
changes PEBS_ENABLED. The guest had better clear them itself. Removing
guest DS_AREA just because we don't have any bits set in PEBS_ENABLED is
wrong and could very break all sorts of drivers.

> In that case, the msr value doesn't change and any guest write will be
> trapped.  If the next check is "msrs[i].host != msrs[i].guest", the
> atomic switch will be triggered again.
> 
> Compared to before, this part of the logic has not changed, which helps to
> reduce overhead.

It's unreadable garbage at best. If you don't want it changed, then
don't add it to the arr[] thing in the first place.

> > Why would you change guest GLOBAL_CTRL implicitly;
> 
> This is because in the early part of this function, we have operations:
> 
>     if (x86_pmu.flags & PMU_FL_PEBS_ALL)
>         arr[0].guest &= ~cpuc->pebs_enabled;
>     else
>         arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
> 
> and if guest has PEBS_ENABLED, we need these bits back for PEBS counters:
> 
>     arr[0].guest |= arr[1].guest;

I don't think that's right, who's to say they were set in the first
place? The guest's GLOBAL_CTRL could have had the bits cleared at VMEXIT
time. You can't unconditionally add PEBS_ENABLED into GLOBAL_CTRL,
that's wrong.

> > guest had better wrmsr that himself to control when stuff is enabled.
> 
> When vm_entry, the msr value of GLOBAL_CTRL on the hardware may be
> different from trapped value "pmu->global_ctrl" written by the guest.
> 
> If the perf scheduler cross maps guest counter X to the host counter Y,
> we have to enable the bit Y in GLOBAL_CTRL before vm_entry rather than X.

Sure, but I don't see that happening here.
