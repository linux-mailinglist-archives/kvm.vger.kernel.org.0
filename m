Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B312F1EAD
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 20:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390851AbhAKTJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 14:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387783AbhAKTJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 14:09:43 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29D8C061786;
        Mon, 11 Jan 2021 11:09:02 -0800 (PST)
Received: from zn.tnic (p200300ec2f088f005dbd09e41b233316.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:8f00:5dbd:9e4:1b23:3316])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 209F21EC0535;
        Mon, 11 Jan 2021 20:09:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610392141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=FanHOoh2hy7l6LGf+AGyElqhb1QEUzzHXgdlqb+1V/o=;
        b=qppRsOAH5oyxha2Ytgu5DQ9d7UeLMhnjzM/+SjaoV1pvk/los7OGC7c7CcXlxuOkJQJy6/
        PdCa3QjA3lDSIXIwxnJIf1rJoPVIKdZENwzyhW1wRqj8zKw3Vw6Vq9vx1fCy5KdLqTJ1OQ
        CgCfu8U14ac0M2huNuSxggp75IBxHyo=
Date:   Mon, 11 Jan 2021 20:09:01 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210111190901.GG25645@zn.tnic>
References: <20210106221527.GB24607@zn.tnic>
 <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
 <20210107064125.GB14697@zn.tnic>
 <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
 <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
 <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
 <20210108071722.GA4042@zn.tnic>
 <X/jxCOLG+HUO4QlZ@google.com>
 <20210109011939.GL4042@zn.tnic>
 <X/yQyUx4+veuSO0e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <X/yQyUx4+veuSO0e@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 11, 2021 at 09:54:17AM -0800, Sean Christopherson wrote:
> Yes, but KVM including the bug caps in kvm_cpu_caps is extremely unlikely, and
> arguably flat out wrong.  Currently, kvm_cpu_caps includes only CPUID-based
> features that can be exposed direcly to the guest.  I could see a scenario where
> KVM exposed "bug" capabilities to the guest via a paravirt interface, but I
> would expect that KVM would either filter and expose the kernel's bug caps
> without userspace input, or would add a KVM-defined paravirt CPUID leaf to
> enumerate the caps and track _that_ in kvm_cpu_caps.
> 
> Anyways, I agree that overlapping the bug caps it's a bit of unnecessary
> cleverness.  I'm not opposed to incorporating NBUGINTS into KVM, but that would
> mean explicitly pulling in even more x86_capability implementation details.

Also, the kernel and kvm being part of it :) kinda tries to fix those
bugs and not expose them to the guest so exposing a bug would probably
be only for testing purposes...

> That part is deliberate and isn't a dependency so much as how things are
> implemented.  The true dependency is on the bit offsets within each word. 

Right.

> The kernel could completely rescramble the word numbering and KVM
> would chug along happily. What KVM won't play nice with is if the
> kernel broke up a hardware- defined, gathered CPUID leaf/word into
> scattered features spread out amongst multiple Linux-defined words.

Yes, kvm wants the bits just as they are in the CPUID leafs from the hw.

> It's mostly historical; before the kvm_cpu_caps concept was introduced, the code
> had grown organically to include both boot_cpu_data and raw CPUID info.  The
> vast, vast majority of the time, doing CPUID is likely redundant.  But, as noted
> in commit d8577a4c238f ("KVM: x86: Do host CPUID at load time to mask KVM cpu
> caps"), the code is quite cheap and runs once at KVM load.  My argument back
> then was, and still is, that an extra bit of paranoia is justified since the
> code and operations are quite nearly free.

Ok.

> This particular dependency can be broken, and quite easily at that.  Rather than
> memcpy() boot_cpu_data.x86_capability, it's trivially easy to redefine the F()
> macro to invoke boot_cpu_has(), which would allow dropping the memcpy().  The
> big downside, and why I didn't post the code, is that doing so means every
> feature routed through F() requires some form of BT+Jcc (or CMOVcc) sequence,
> whereas the mempcy() approach allows the F() features to be encoded as a single
> literal by the compiler.
> 
> From a latency perspective, the extra code is negligible.  The big issue is that
> all those extra checks add 2k+ bytes of code.  Eliminating the mempcy() doesn't
> actually break KVM's dependency on the bit offsets, so we'd be bloating kvm.ko
> by a noticeable amount without providing substantial value.
> 
> And, this behavior is mostly opportunistic; the true justification/motiviation
> for taking a dependency on the X86_FEATURE_* bit offsets is for communication
> with userspace, querying the guest CPU model, and runtime checks.

Ok, I guess we'll try to find a middle ground here and not let stuff
grow too ugly to live.

> It's effectively for communication with userspace.  Userspace, via ioctl(),
> dictates the vCPU model to KVM, including the exact CPUID results. 

And using the CPUID leafs with the exact bit positions is sort of an
"interface" there, I see.

> to properly
> virtualize/emulate the defined vCPU model, KVM must query the dictated CPUID
> results to determine what features are supported, what guest operations
> should fault, etc...  E.g. if the vCPU model, via CPUID, states that SMEP isn't
> supported then KVM needs to inject a #GP if the guest attempts to set CR4.SMEP.
> 
> KVM also uses the hardware-defined CPUID ABI to advertise which features are
> supported by both hardware and KVM.  This is the kvm_cpu_cap stuff, where KVM
> reads boot_cpu_data to see what features were enabled by the kernel.

Right.

> It would be possible for KVM to break the dependency on X86_FEATURE_* bit
> offsets by defining a translation layer, but I strongly feel that adding manual
> translations will do more harm than good as it increases the odds of us botching
> a translation or using the wrong feature flag, creates potential namespace
> conflicts, etc...

Ok, lemme see if we might encounter more issues down the road...

+enum kvm_only_cpuid_leafs {
+       CPUID_12_EAX     = NCAPINTS,
+       NR_KVM_CPU_CAPS,
+
+       NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
+};
+

What happens when we decide to allocate a separate leaf for CPUID_12_EAX
down the road?

You do it already here

Subject: [PATCH 04/13] x86/cpufeatures: Assign dedicated feature word for AMD mem encryption

for the AMD leaf.

I'm thinking this way around - from scattered to a hw one - should be ok
because that should work easily. The other way around, taking a hw leaf
and scattering it around x86_capability[] array elems would probably be
nasty but with your change that should work too.

Yah, I'm just hypothesizing here - I don't think this "other way around"
will ever happen...

Hmm, yap, I can cautiously say that with your change we should be ok...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
