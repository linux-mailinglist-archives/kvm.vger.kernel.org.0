Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746444672F3
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 08:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379032AbhLCH6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 02:58:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231537AbhLCH6h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 02:58:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638518113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cvJ2lpX+tqY4cC2bOGam94PSlCFquDfAJX6mgIvRyFA=;
        b=PZKT6WjbuT+Ok/aZUkqiW2c88l9sZgCL9ekH4iYvYZ7Ft2DYTT+4WQLaQCGtObp2jkuHAC
        /3CCDANYWBSGGbTGGKJq9c17eCrfBJK7EjnVvVwK8srb6maeQhwXJHqgTahLeLtnCgunun
        QcORHxTqQoJRRykKU/BBnjv/qNk3Jdw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-hL9BxUIwPAuTe8fn28d6lA-1; Fri, 03 Dec 2021 02:55:08 -0500
X-MC-Unique: hL9BxUIwPAuTe8fn28d6lA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E11541015211;
        Fri,  3 Dec 2021 07:53:56 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8003B60C13;
        Fri,  3 Dec 2021 07:53:54 +0000 (UTC)
Message-ID: <ce49cc3e3ae5885d992261589cd0f4adad118776.camel@redhat.com>
Subject: Re: Re: [PATCH v2 2/2] KVM: x86: use x86_get_freq to get freq for
 kvmclock
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     zhenwei pi <pizhenwei@bytedance.com>,
        Thomas Gleixner <tglx@linutronix.de>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Date:   Fri, 03 Dec 2021 09:53:53 +0200
In-Reply-To: <20211202224555.GE16608@worktop.programming.kicks-ass.net>
References: <20211201024650.88254-1-pizhenwei@bytedance.com>
         <20211201024650.88254-3-pizhenwei@bytedance.com> <877dcn7md2.ffs@tglx>
         <b37ffc3d-4038-fc5e-d681-b89c04a37b04@bytedance.com>
         <ffbb8a16f267e73316084d1252696edaf81e35a9.camel@redhat.com>
         <20211202224555.GE16608@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-02 at 23:45 +0100, Peter Zijlstra wrote:
> On Thu, Dec 02, 2021 at 09:19:25AM +0200, Maxim Levitsky wrote:
> > On Thu, 2021-12-02 at 13:26 +0800, zhenwei pi wrote:
> > Note that on my Zen2 machine (3970X), aperf/mperf returns current cpu freqency,
> 
> Correct, and it computes it over a random period of history. IOW, it's a
> random number generator.
> 
> > 1. It sucks that on AMD, the TSC frequency is calibrated from other 
> > clocksources like PIT/HPET, since the result is not exact and varies
> > from boot to boot.
> 
> CPUID.15h is supposed to tell us the actual frequency; except even Intel
> find it very hard to actually put the right (or any, really) number in
> there :/ Bribe your friendly AMD engineer with beers or something.

That what I thought. I asked just in case maybe AMD does have some vendor specific msrs
you know about but we didn't bother to support it.
I didn't find any in their PRM.

> 
> > 2. In the guest on AMD, we mark the TSC as unsynchronized always due to the code
> > in unsynchronized_tsc, unless invariant tsc is used in guest cpuid,
> > which is IMHO not fair to AMD as we don't do this for  Intel cpus.
> > (look at unsynchronized_tsc function)
> 
> Possibly we could treat >= Zen similar to Intel there. Also that comment
> there is hillarious, it talks about multi-socket and then tests
> num_possible_cpus(). Clearly that code hasn't been touched in like
> forever.
Thank you!

> 
> > 3. I wish the kernel would export the tsc frequency it found to userspace
> > somewhere in /sys or /proc, as this would be very useful for userspace applications.
> > Currently it can only be found in dmesg if I am not mistaken..
> > I don't mind if such frequency would only be exported if the TSC is stable,
> > always running, not affected by CPUfreq, etc.
> 
> Perf exposes it, it's not really convenient if you're not using perf,
> but it can be found there.
That is good to know! I will check out the source but if you remember,
is there cli option in perf to show it, or it only uses it for internal
purposes?

> 
> 
> ---
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 2e076a459a0c..09da2935534a 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -29,6 +29,7 @@
>  #include <asm/intel-family.h>
>  #include <asm/i8259.h>
>  #include <asm/uv/uv.h>
> +#include <asm/topology.h>
>  
>  unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
>  EXPORT_SYMBOL(cpu_khz);
> @@ -1221,9 +1222,20 @@ int unsynchronized_tsc(void)
>  	 * Intel systems are normally all synchronized.
>  	 * Exceptions must mark TSC as unstable:
>  	 */
> -	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
> +	switch (boot_cpu_data.x86_vendor) {
> +	case X86_VENDOR_INTEL:
> +		/* Really only Core and later */
> +		break;
> +
> +	case X86_VENDOR_AMD:
> +	case X86_VENDOR_HYGON:
> +		if (boot_cpu_data.x86 >= 0x17) /* >= Zen */
> +			break;
> +		fallthrough;
> +
> +	default:
>  		/* assume multi socket systems are not synchronized: */
> -		if (num_possible_cpus() > 1)
> +		if (topology_max_packages() > 1)
>  			return 1;
>  	}
>  

This makes sense!

> 


Best regards,
	Maxim Levitsky

