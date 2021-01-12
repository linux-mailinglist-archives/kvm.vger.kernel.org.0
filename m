Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2802F2ECB
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 13:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732741AbhALMOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 07:14:47 -0500
Received: from mail.skyhub.de ([5.9.137.197]:57542 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732455AbhALMOr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 07:14:47 -0500
Received: from zn.tnic (p200300ec2f0e8c0026b5c8bc02f060b7.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:8c00:26b5:c8bc:2f0:60b7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A5F861EC0472;
        Tue, 12 Jan 2021 13:14:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610453645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=4w8mzi966gYW3Xfnk2BjaCXIPZPykNO5//jfGuwn8bg=;
        b=W4KSP/np+hFfozdVXNuZ9SJqfFYB6B93B4xH/8lum//CNETvhZ//YuQTDmyUw+aZG1mlYP
        bR98Kx0uOrjGeIISnlIIX4oXNzdgDyQv0mjR5sxF5pmIccjM9R0fZMG5HfYTTqJRE5l4CA
        G1+91h/fDHXRplrGgVHye/Tp1LrisUM=
Date:   Tue, 12 Jan 2021 13:13:59 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210112121359.GC13086@zn.tnic>
References: <20210107064125.GB14697@zn.tnic>
 <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
 <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
 <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
 <20210108071722.GA4042@zn.tnic>
 <X/jxCOLG+HUO4QlZ@google.com>
 <20210109011939.GL4042@zn.tnic>
 <X/yQyUx4+veuSO0e@google.com>
 <20210111190901.GG25645@zn.tnic>
 <X/yk6zcJTLXJwIrJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <X/yk6zcJTLXJwIrJ@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 11, 2021 at 11:20:11AM -0800, Sean Christopherson wrote:
> Well, mechanically, that would generate a build failure if the kernel does the
> obvious things and names the 'enum cpuid_leafs' entry CPUID_12_EAX.  That would
> be an obvious clue that KVM should be updated.

Then we need to properly document that whenever someone does that
change, someone needs to touch the proper places.

> If the kernel named the enum entry something different, and we botched the code
> review, KVM would continue to work, but would unnecessarily copy the bits it
> cares about to its own word.   E.g. the boot_cpu_has() checks and translation to
> __X86_FEATURE_* would still be valid.  As far as failure modes go, that's not
> terrible.

Right, which reminds me: with your prototype patch, we would have:

static __always_inline void __kvm_cpu_cap_mask(enum cpuid_leafs leaf)
{
        const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
        struct kvm_cpuid_entry2 entry;

        reverse_cpuid_check(leaf);

        cpuid_count(cpuid.function, cpuid.index,
                    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);

        kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
}

which does read CPUID from the hw and kvm_cpu_caps[] has already the
copied bits from boot_cpu_data.x86_capability.

Now you said that reading the CPUID is mostly redundant but we're
paranoid so we do it anyway, just in case, so how about we remove the
copying of boot_cpu_data.x86_capability? That's one less dependency
on the baremetal implementation.

Practically, nothing changes for kvm because it will read CPUID which is
the canonical thing anyway. And this should simplify the deal more and
keep it simple(r).

Hmmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
