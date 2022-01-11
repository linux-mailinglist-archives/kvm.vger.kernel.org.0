Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BA848A63E
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 04:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiAKDZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 22:25:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:46706 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348042AbiAKDZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 22:25:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641871541; x=1673407541;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7nvliX2pitYIn5elvcc0RhLaOrecvDNaby86k0Cd5T0=;
  b=Z8R4a8gqmri5CRIyZyFd/3+1sjGCMoHO/rQGFJOQWEr9yvqG9Q/oB9V/
   k/4u26IlrTqbiamJ40eRsTjX+ZOfpSTzolSTLnsZKc+NpynXamvqtXPWT
   VIamvZXEIsoSTaeyqIMk/mPx6dWTYsAfAg1LEjxjFvISi3rB0/5MF0aJe
   s6d1+EaqWrKvHi8C4AEiytAOMuOVvUEdYifwifcHkaemuhgTLq9avHAQK
   hYOz/E9d6Y7Uq7qd1dl+rYAsesLKrwDAcq9RZXdOakkqJBQhsA4xVcyfR
   8rP61hbI48T27bdLusu4C6MWIG2j1iw2jofseZNClVlO5WkgUz5Ujb+5R
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="230734096"
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="230734096"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 19:25:41 -0800
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="528546614"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 19:25:37 -0800
Date:   Tue, 11 Jan 2022 11:36:30 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] KVM: x86: Move check_processor_compatibility from
 init ops to runtime ops
Message-ID: <20220111033629.GC2175@gao-cwp>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-2-chao.gao@intel.com>
 <YdzAzT5AqO0aCsHk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdzAzT5AqO0aCsHk@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 11:27:09PM +0000, Sean Christopherson wrote:
>On Mon, Dec 27, 2021, Chao Gao wrote:
>> so that KVM can do compatibility checks on hotplugged CPUs. Drop __init
>> from check_processor_compatibility() and its callees.
>
>Losing the __init annotation on all these helpers makes me a bit sad, more from a
>documentation perspective than a "but we could shave a few bytes" perspective.

This makes sense.

>More than once I've wondered why some bit of code isn't __init, only to realize
>its used for hotplug.

Same problem to some global data structures which can be __initdata if hotplug
isn't supported.

>
>What if we added an __init_or_hotplug annotation that is a nop if HOTPLUG_CPU=y?

Personally __init_or_hotplug is a little long as an annotation. How about
__hotplug?

One concern is: is it acceptable to introduce a new annotation and use it in
new code but not fix all places that should use it in existing code.

I think the right process is
1. introduce a new annotation
2. fix existing code to use this annotation
3. add new code.

There is no doubt that #2 would take great effort. I'm not sure if it is really
worth it.

>At a glance, KVM could use that if the guts of kvm_online_cpu() were #idef'd out
>on !CONFIG_HOTPLUG_CPU.  That also give us a bit of test coverage for bots that
>build with SMP=n.

Will do with your suggested-by.

>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index a80e3b0c11a8..30bbcb4f4057 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -11380,7 +11380,7 @@ void kvm_arch_hardware_unsetup(void)
>        static_call(kvm_x86_hardware_unsetup)();
> }
>
>-int kvm_arch_check_processor_compat(void)
>+int __init_or_hotplug kvm_arch_check_processor_compat(void)
> {
>        struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
>
>diff --git a/include/linux/init.h b/include/linux/init.h
>index d82b4b2e1d25..33788b3c180a 100644
>--- a/include/linux/init.h
>+++ b/include/linux/init.h
>@@ -53,6 +53,12 @@
> #define __exitdata     __section(".exit.data")
> #define __exit_call    __used __section(".exitcall.exit")
>
>+#ifdef CONFIG_HOTPLUG_CPU
>+#define __init_or_hotplug
>+#else
>+#define __init_or_hotplug __init
>+#endif /* CONFIG_HOTPLUG_CPU
>+
> /*
>  * modpost check for section mismatches during the kernel build.
>  * A section mismatch happens when there are references from a
>
