Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FF9466D24
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 23:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377507AbhLBWtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 17:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242876AbhLBWta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 17:49:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BEEC06174A;
        Thu,  2 Dec 2021 14:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TBNGrGv/MBZEJ2Qn8/d4crwozJEsXAwFNPWxkDSj1is=; b=GYkXLIkQ2IizY9zwCdqaGTw9tX
        C5snD+kMFxfgSoV73Sw6BlkidKbAZqunVafT/BkYkN8UE4P5dCpY6RRAvbNyUrf5LLhSEQv7GYJtt
        VjEAEGr4sj7xwuF1TNUFvfb1zqlHNabLIlUeoP8oaktXn9NilDs2UIX0ePPo6r6XOAxjADnmKYp33
        cfDAbm7DZLUfIRC0HQJpJFPnzn9JWqejjSgz1wRm8N/kkd3kskDOHPRrbYINnpC30/42NEZCMfL9f
        wm7ZwQllY1AQMRW7+4u1d1L8bnRk0q6h2ybaRybZlJMc01e4ytyoloYzLlCGyhJc/0oQvZf7uoWHT
        jWFTeLmg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1msupv-005wZd-A7; Thu, 02 Dec 2021 22:45:56 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9DD849810D4; Thu,  2 Dec 2021 23:45:55 +0100 (CET)
Date:   Thu, 2 Dec 2021 23:45:55 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     zhenwei pi <pizhenwei@bytedance.com>,
        Thomas Gleixner <tglx@linutronix.de>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: Re: [PATCH v2 2/2] KVM: x86: use x86_get_freq to get freq for
 kvmclock
Message-ID: <20211202224555.GE16608@worktop.programming.kicks-ass.net>
References: <20211201024650.88254-1-pizhenwei@bytedance.com>
 <20211201024650.88254-3-pizhenwei@bytedance.com>
 <877dcn7md2.ffs@tglx>
 <b37ffc3d-4038-fc5e-d681-b89c04a37b04@bytedance.com>
 <ffbb8a16f267e73316084d1252696edaf81e35a9.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffbb8a16f267e73316084d1252696edaf81e35a9.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 02, 2021 at 09:19:25AM +0200, Maxim Levitsky wrote:
> On Thu, 2021-12-02 at 13:26 +0800, zhenwei pi wrote:

> Note that on my Zen2 machine (3970X), aperf/mperf returns current cpu freqency,

Correct, and it computes it over a random period of history. IOW, it's a
random number generator.

> 1. It sucks that on AMD, the TSC frequency is calibrated from other 
> clocksources like PIT/HPET, since the result is not exact and varies
> from boot to boot.

CPUID.15h is supposed to tell us the actual frequency; except even Intel
find it very hard to actually put the right (or any, really) number in
there :/ Bribe your friendly AMD engineer with beers or something.

> 2. In the guest on AMD, we mark the TSC as unsynchronized always due to the code
> in unsynchronized_tsc, unless invariant tsc is used in guest cpuid,
> which is IMHO not fair to AMD as we don't do this for  Intel cpus.
> (look at unsynchronized_tsc function)

Possibly we could treat >= Zen similar to Intel there. Also that comment
there is hillarious, it talks about multi-socket and then tests
num_possible_cpus(). Clearly that code hasn't been touched in like
forever.

> 3. I wish the kernel would export the tsc frequency it found to userspace
> somewhere in /sys or /proc, as this would be very useful for userspace applications.
> Currently it can only be found in dmesg if I am not mistaken..
> I don't mind if such frequency would only be exported if the TSC is stable,
> always running, not affected by CPUfreq, etc.

Perf exposes it, it's not really convenient if you're not using perf,
but it can be found there.


---
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 2e076a459a0c..09da2935534a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -29,6 +29,7 @@
 #include <asm/intel-family.h>
 #include <asm/i8259.h>
 #include <asm/uv/uv.h>
+#include <asm/topology.h>
 
 unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
@@ -1221,9 +1222,20 @@ int unsynchronized_tsc(void)
 	 * Intel systems are normally all synchronized.
 	 * Exceptions must mark TSC as unstable:
 	 */
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_INTEL:
+		/* Really only Core and later */
+		break;
+
+	case X86_VENDOR_AMD:
+	case X86_VENDOR_HYGON:
+		if (boot_cpu_data.x86 >= 0x17) /* >= Zen */
+			break;
+		fallthrough;
+
+	default:
 		/* assume multi socket systems are not synchronized: */
-		if (num_possible_cpus() > 1)
+		if (topology_max_packages() > 1)
 			return 1;
 	}
 
