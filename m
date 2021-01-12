Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB9F2F36D7
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 18:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392399AbhALRQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 12:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbhALRQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 12:16:41 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F84C0617A2
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 09:16:01 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id x12so1727228plr.10
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 09:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zPA/kupc5PvuURWfWA0OWF+7d6IqYen+WcUkJA6luoY=;
        b=MvvVrjF7I8h4m7oC/8OHhehgAUWmAaMuqcj12EKUHP0U7bsNjd0oORWOEB04VQCxI3
         1yO/+IyRtV1g76LD4kFdd7x/X06Msi0AJrhfbNCmpXS5HgKN3bckN4B0dd0w+bMOIyG5
         A1aU6ZM8BQznrSOHTpboIq9exiQmfhISJqv05PTtfLfvuiDRz3uFd5DITnu0A0GBhiO+
         681e2ee7TEb0keNQa2k1rGzk0UtqgZauZJWrEXAONhqg/6T5XXBEEcd+DqjfEGFaphdZ
         3h0MvI5A//RoTRuRUwfsTmKr4LbnZL6bWR1K6d+PsL7JmXbCu/BecEDnIT/BxYr3Znq0
         lmKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zPA/kupc5PvuURWfWA0OWF+7d6IqYen+WcUkJA6luoY=;
        b=iu3O7Wl7P5/ShFNqEcS9Dmq0lMVPUroH5XDE/eaaOUlb4Pqd1RKV4DWLC68EV+Lamo
         Nn3UToIEg1iE2Z9YcYUVwnmVaP7myvxACYtFraCwhVr4Y7FKDItE794HVYckIJxGx9K1
         W2Om7e6gMQi0Zk58Rg7GWTChk+imTd+jwDGmVNZHzsngtcG4jAKI0Hjfm/zDRC7g13yW
         sU2LKIACNOqsKD3SRaQuCH8iZxrhHjGuhbEj2KEwRG5wLObAYS9igPvJlyfImGwgkawY
         EmAb2O+Nkoi3NJYYwmF4dNRJtTTvUWOULS702J3nTkHF3728q2BhUpEWROUJHA6DznUW
         Q17g==
X-Gm-Message-State: AOAM530O0Uv14aT8k2PpejYWZujIzanIJPRQscLtMNaCPGFt9AKskN1+
        k/0+rtNnj0TqGFUq4E1Syvmw/g==
X-Google-Smtp-Source: ABdhPJwZXtxGgrfI1wtQHC+qtQ6REHQmbmYYIQm6ZleaDSIIwDLkrX8dwNf2RB1Upn1WEfVcgu7fpA==
X-Received: by 2002:a17:90a:4b07:: with SMTP id g7mr132876pjh.0.1610471760588;
        Tue, 12 Jan 2021 09:16:00 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id f67sm3863554pfg.159.2021.01.12.09.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 09:15:59 -0800 (PST)
Date:   Tue, 12 Jan 2021 09:15:52 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <X/3ZSKDWoPcCsV/w@google.com>
References: <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
 <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
 <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
 <20210108071722.GA4042@zn.tnic>
 <X/jxCOLG+HUO4QlZ@google.com>
 <20210109011939.GL4042@zn.tnic>
 <X/yQyUx4+veuSO0e@google.com>
 <20210111190901.GG25645@zn.tnic>
 <X/yk6zcJTLXJwIrJ@google.com>
 <20210112121359.GC13086@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112121359.GC13086@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Borislav Petkov wrote:
> On Mon, Jan 11, 2021 at 11:20:11AM -0800, Sean Christopherson wrote:
> > Well, mechanically, that would generate a build failure if the kernel does the
> > obvious things and names the 'enum cpuid_leafs' entry CPUID_12_EAX.  That would
> > be an obvious clue that KVM should be updated.
> 
> Then we need to properly document that whenever someone does that
> change, someone needs to touch the proper places.
> 
> > If the kernel named the enum entry something different, and we botched the code
> > review, KVM would continue to work, but would unnecessarily copy the bits it
> > cares about to its own word.   E.g. the boot_cpu_has() checks and translation to
> > __X86_FEATURE_* would still be valid.  As far as failure modes go, that's not
> > terrible.
> 
> Right, which reminds me: with your prototype patch, we would have:
> 
> static __always_inline void __kvm_cpu_cap_mask(enum cpuid_leafs leaf)
> {
>         const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
>         struct kvm_cpuid_entry2 entry;
> 
>         reverse_cpuid_check(leaf);
> 
>         cpuid_count(cpuid.function, cpuid.index,
>                     &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
> 
>         kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
> }
> 
> which does read CPUID from the hw and kvm_cpu_caps[] has already the
> copied bits from boot_cpu_data.x86_capability.
> 
> Now you said that reading the CPUID is mostly redundant but we're
> paranoid so we do it anyway, just in case, so how about we remove the
> copying of boot_cpu_data.x86_capability? That's one less dependency
> on the baremetal implementation.
>
> Practically, nothing changes for kvm because it will read CPUID which is
> the canonical thing anyway. And this should simplify the deal more and
> keep it simple(r).

We want the boot_cpu_data.x86_capability memcpy() so that KVM doesn't advertise
support for features that are intentionally disabled in the kernel, e.g. via
kernel params.  Except for a few special cases, e.g. LA57, KVM doesn't enable
features in the guest if they're disabled in the host, even if the features are
supported in hardware.

For some features, e.g. SMEP and SMAP, honoring boot_cpu_data is mostly about
respecting the kernel's wishes, i.e. barring hardware bugs, enabling such
features in the guest won't break anything.  But for other features, e.g. XSAVE
based features, enabling them in the guest without proper support in the host
will corrupt guest and/or host state.

So it's really the CPUID read that is (mostly) superfluous.
