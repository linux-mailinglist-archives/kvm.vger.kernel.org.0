Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 698E516B4FE
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 00:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgBXXUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 18:20:10 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21843 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727843AbgBXXUJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 18:20:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582586408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3xN9hq90N1oCxmHLczxcJX9jZofURAy8C2m6ZpIZZKs=;
        b=cKQHMhMnqZKg69DgkLqrXdyHbMTOdgi8DToVxGYzq5/YbPyhTbKMujbjTCqPSWpM3pKNgR
        NyIWdBv7QW+e99AXKJlwTVPQ23utTC4g6iDDrxZEDEkd3vqBXfQgpzn9K+Z5VpId3aTKWR
        ajchrLyhtpZHlQnCNVXcb8L21K/9D2I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-0lQIe_ILNPGMrP8js9XiWw-1; Mon, 24 Feb 2020 18:20:06 -0500
X-MC-Unique: 0lQIe_ILNPGMrP8js9XiWw-1
Received: by mail-wm1-f69.google.com with SMTP id y125so289727wmg.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 15:20:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3xN9hq90N1oCxmHLczxcJX9jZofURAy8C2m6ZpIZZKs=;
        b=oevWplkfUv57HCb780K/RIz3QTjVlRDZdxpDJbCqZgWqvHYQDeolh/wzmBee8j4D1M
         nhCNhGRTqm/nzgx1CjdkWfmbma99eGOP9DSYUCAjgfdRUF1DdKBzD+75I/vowJbHanE0
         bq/sSamx33XT1q5gYtwCqDktdrHlInJQiPZ7fu5wGlrEAeeAwn/Szu1AOZ7PhpOqPCyC
         bRsByH8A+c/0qDCBaopI88YTNZjyJQt1HPhtTWFKc7MeqW3rjxGQVw484c7NnprGmoxk
         yY255/UgOJHOBQfKeprut3MmPN36UpngYPVR5zYYIdIk8+ThFKssXAffP406D2gBIaq2
         fAmg==
X-Gm-Message-State: APjAAAUGFVyDoZLdZV4T8w/NuJKqgNqij8CWS8uNWSa73llpoUlx9hO3
        W2rdW7tCwuHWB2IqtEglvcJ7wdDUszYvCsP9rAB1TPM+fXrHSLH0MB0A5MY/u/oYqN6M34zAh/i
        kp69h6XGCwZSD
X-Received: by 2002:a1c:9d85:: with SMTP id g127mr1267505wme.75.1582586405668;
        Mon, 24 Feb 2020 15:20:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqw4/T7cggFhTWfC4KkRP75jACd72Qyu+h14eKTuE+dLWVQ5k57SvfKJwNvSwtdxDI6CJ+/UOw==
X-Received: by 2002:a1c:9d85:: with SMTP id g127mr1267494wme.75.1582586405459;
        Mon, 24 Feb 2020 15:20:05 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o9sm21491605wrw.20.2020.02.24.15.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 15:20:04 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 38/61] KVM: x86: Introduce kvm_cpu_caps to replace runtime CPUID masking
In-Reply-To: <20200224225743.GP29865@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-39-sean.j.christopherson@intel.com> <87h7zgndxl.fsf@vitty.brq.redhat.com> <20200224225743.GP29865@linux.intel.com>
Date:   Tue, 25 Feb 2020 00:20:03 +0100
Message-ID: <87ftezmv30.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, Feb 24, 2020 at 05:32:54PM +0100, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> 

...

>
>> > +
>> > +	BUILD_BUG_ON(sizeof(kvm_cpu_caps) >
>> > +		     sizeof(boot_cpu_data.x86_capability));
>> > +
>> > +	memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
>> > +	       sizeof(kvm_cpu_caps));
>> > +
>> > +	kvm_cpu_cap_mask(CPUID_1_EDX,
>> > +		F(FPU) | F(VME) | F(DE) | F(PSE) |
>> > +		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
>> > +		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
>> > +		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
>> > +		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
>> > +		0 /* Reserved, DS, ACPI */ | F(MMX) |
>> > +		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
>> > +		0 /* HTT, TM, Reserved, PBE */
>> > +	);
>> > +
>> > +	kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
>> > +		F(FPU) | F(VME) | F(DE) | F(PSE) |
>> > +		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
>> > +		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
>> > +		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
>> > +		F(PAT) | F(PSE36) | 0 /* Reserved */ |
>> > +		f_nx | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
>> > +		F(FXSR) | F(FXSR_OPT) | f_gbpages | F(RDTSCP) |
>> > +		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW)
>> > +	);
>> > +
>> > +	kvm_cpu_cap_mask(CPUID_1_ECX,
>> > +		/* NOTE: MONITOR (and MWAIT) are emulated as NOP,
>> > +		 * but *not* advertised to guests via CPUID ! */
>> > +		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
>> > +		0 /* DS-CPL, VMX, SMX, EST */ |
>> > +		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
>> > +		F(FMA) | F(CX16) | 0 /* xTPR Update, PDCM */ |
>> > +		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
>> > +		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
>> > +		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
>> > +		F(F16C) | F(RDRAND)
>> > +	);
>> 
>> I would suggest we order things by CPUID_NUM here, i.e.
>> 
>> CPUID_1_ECX
>> CPUID_1_EDX
>> CPUID_7_1_EAX
>> CPUID_7_0_EBX
>> CPUID_7_ECX
>> CPUID_7_EDX
>> CPUID_D_1_EAX
>> ...
>
> Hmm, generally speaking I agree, but I didn't want to change the ordering
> in this patch when moving the code.  Throw a patch on top?  Leave as is?
> Something else?

My line of thought was: it's not a mechanical "s,const u32
xxx_x86_features =,kvm_cpu_cap_mask...," change, things get moved from
do_cpuid_7_mask() and __do_cpuid_func() so we may as well re-order them,
reviewing-wise it's more or less the same. But honestly, this is very
minor, feel free to leave as-is.

-- 
Vitaly

