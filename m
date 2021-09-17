Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5033A40F346
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 09:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240404AbhIQHbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 03:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236843AbhIQHbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 03:31:11 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2026FC061574;
        Fri, 17 Sep 2021 00:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=17mkqfuKdfnPg9YSAeGWHc/O4GLOFEnsaFTJ4hUb1Qc=; b=R175PzEhjMPDTuiig9T+/8FvBN
        wCwITbQjI86keC2UZcKL3oHklcXqScPxlhfsprjzgtQHXNUwlN8OYqdLQ7ztxGmPqLPGGL1HvK5TW
        8un1CwadAtDZMXP8kHm7KJ60CKQlzq6kBsXmSOCidcFaqUG49FGQ/Q91WQSCSzrudnHUpN1n/dtAK
        3oCiHTPea1eYl35kiZcqB3afHwTSqwkSRYpje8CyTQKsMtTXOUjDfhQXOeCpbGDLw3jXUuiLQwU+o
        fpmbPjE5lGD64IJe7KimQfKhdgCV7/TWkKj798HvtN0fT0soP/DzPI91f4RdvEreoDEx02Cp2qq0O
        NM1LgiIg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mR8Ig-003p42-0g; Fri, 17 Sep 2021 07:28:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 64E5430031A;
        Fri, 17 Sep 2021 09:28:42 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id EBC3F2B27F98D; Fri, 17 Sep 2021 09:28:41 +0200 (CEST)
Date:   Fri, 17 Sep 2021 09:28:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH v2 00/13] perf: KVM: Fix, optimize, and clean up callbacks
Message-ID: <YURDqVZ1UXKCiKPV@hirez.programming.kicks-ass.net>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828201336.GD4353@worktop.programming.kicks-ass.net>
 <YUO5J/jTMa2KGbsq@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUO5J/jTMa2KGbsq@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021 at 09:37:43PM +0000, Sean Christopherson wrote:
> On Sat, Aug 28, 2021, Peter Zijlstra wrote:

> Argh, sorry, I somehow managed to miss all of your replies.  I'll get back to
> this series next week.  Thanks for the quick response!
> 
> > Lets keep the whole intel_pt crud inside x86...
> 
> In theory, I like the idea of burying intel_pt inside x86 (and even in
> Intel+VMX code for the most part), but the actual implementation is a
> bit gross.  Because of the whole "KVM can be a module" thing,

ARGH!! we should really fix that. I've heard other archs have made much
better choices here.

> either
> the static call and __static_call_return0 would need to be exported,
> or a new register/unregister pair would have to be exported.

So I don't mind exporting __static_call_return0, but exporting a raw
static_call is much like exporting a function pointer :/

> The unregister path would also need its own synchronize_rcu().  In general, I
> don't love duplicating the logic, but it's not the end of the world.
> 
> Either way works for me.  Paolo or Peter, do either of you have a preference?

Can we de-feature kvm as a module and only have this PT functionality
when built-in? :-)


> > ---
> > Index: linux-2.6/arch/x86/events/core.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/events/core.c
> > +++ linux-2.6/arch/x86/events/core.c
> > @@ -92,7 +92,7 @@ DEFINE_STATIC_CALL_RET0(x86_pmu_guest_ge
> >  
> >  DEFINE_STATIC_CALL_RET0(x86_guest_state, *(perf_guest_cbs->state));
> >  DEFINE_STATIC_CALL_RET0(x86_guest_get_ip, *(perf_guest_cbs->get_ip));
> > -DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, *(perf_guest_cbs->handle_intel_pt_intr));
> > +DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, unsigned int (*)(void));
> 
> FWIW, the param needs to be a raw function, not a function pointer. 

Yeah, I keep making that mistake.. and I wrote the bloody thing :/

I have a 'fix' for that, but I need to finish that and also flag-day
change :-(

  https://lkml.kernel.org/r/YS+0eIeAJsRRArk4@hirez.programming.kicks-ass.net
