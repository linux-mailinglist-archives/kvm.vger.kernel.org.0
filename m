Return-Path: <kvm+bounces-48742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7425AD237B
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 18:12:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CD441644EC
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 16:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C824218838;
	Mon,  9 Jun 2025 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VYhulJzI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793B719D093
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 16:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749485563; cv=none; b=jLXU48omvqr8ZIpAY4mssk0QB1BZIvQDVcO6AAMCgydRNKGRUaBXwy4PS9kDx6KrIgCofJSdcpA2+PtWVHdIsn4b97+rSpXcfW3B9V4elHKlk0c1PjEReAFrpgQndHwjO2yZkTP32VsALg5vryuofgjnxGmdXlUrMIwznYjaXPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749485563; c=relaxed/simple;
	bh=m6OcPKhaGgMcJAfVtRO64wW6yGYsj2g2JLXjPyqdRl8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lf1LbuAvYwhKLhTJla0sA4xIYWpfGuJnTOtPGstYGYXS/mZxEQ6zhCgDzx1KlvkY7+kCSKzlMY7+JkyGn1PVyRRe2/unDbO0p+KwEM0B1Qh1RRoOwe2lUpSNGt63vQDiU8iiGqJNSJKLycdASyl4V8eQ26lYa5iwOP0kDisxvKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VYhulJzI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749485560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=suhwUE5cgfaY38tLR0Xwk5yYjUGSWjTarM/Tmb+ONxA=;
	b=VYhulJzI1kYpk5YbrFqjRsHBCWeLSNT+FTjqtri5X3FtfaIWfCVT5EeXVZ9Rk+5EXQayao
	6uQU+Hly83BBKuQ8+RDGJ2O0vMwH6oMDwYNB/wbuOhxJifIburLbpz2vao3KTyojUZVCa/
	dfW36J67varDbMSBXOmHnk8Bs5vLb1M=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-gR_jFI68Oj2F9_EOp36Jig-1; Mon, 09 Jun 2025 12:12:39 -0400
X-MC-Unique: gR_jFI68Oj2F9_EOp36Jig-1
X-Mimecast-MFC-AGG-ID: gR_jFI68Oj2F9_EOp36Jig_1749485558
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4f85f31d9so1936978f8f.1
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 09:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749485558; x=1750090358;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=suhwUE5cgfaY38tLR0Xwk5yYjUGSWjTarM/Tmb+ONxA=;
        b=oenfQuJg6AMO6eqsBKn0zGiQhMOvREwnRPEzTxEJAwITJYUZP+3hKwlODVB0weXSk2
         0P8Xdyjj2K9Dysymou5i6scBYvKaslyUeKg3Fp/AXp9MBsNeVrTcFj7J2ihc44UY8vsv
         AQLmfrG93jTGxlXE90LikfzWFVYkd/gjyxIW7LpufGND00dQKf5NbB9++w0Cl4j3gvDO
         x90XsWMuMR4PLzjDUo4hOexES+eL2qTyQlpfLx9AiQQiEoo+aFbvktE6iqEcMc8R+XVX
         vxNTP2k8XMW4cxkz7K3M5g1E8elnRvqLRm77+d8MvYqZ5RuVT7T4akIVelu6ptuZHOXE
         m1jg==
X-Forwarded-Encrypted: i=1; AJvYcCWV66Gs4DThT3ksMbfMrIx306HuAQL9zTx/XzGWy46w8EUhxSI1W+oKBQitn3nqQD1zmIE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHzRiUPVpLqCHUA7cTdS7BMyMaFgOR/9qHRPM5Cssvxj4/8Z8y
	l6szsmLVc8MI0/DXVVbl7+58dgPdNZas5+ak9OgV/bTVc/Dm2RGRRiqUe1Hg03uYwpXjRP0H62U
	bDYmJ6ZOLRB1HgjDXh1BQ8xjp72igaUTtmB28UVC1E7lgRD5wEGrX1w==
X-Gm-Gg: ASbGnct5uMqMXtm8VlsI0hdTLaKg7A8qD1f278ZeXS4jOoo2dax8UCQF/J7AhNG9Vwt
	uCgn/iKMdha0e6b9sFGSIQ1EJYLVu1LipfSVUYH1XlfCIXcEh8MUZkHuuy8PoE2syVeHHbEitLX
	FVThOzVovFsb8wJHdV0OVxLLO6Oc7f2ryuypwegu70oTOu6ows/3fC6yvLVqIuMl99wYgQaNgvc
	vaPfTjbUXN+esJbvoGpjwvv1VnIVQGvHEefx+JX8+sZ4l6cOQzErUJ8eLqhZ3tGYV3T7J/l4ZpE
	WtAYiyA5f3gzoSPsBMjM+qsB
X-Received: by 2002:a05:6000:2512:b0:3a4:f722:f98d with SMTP id ffacd0b85a97d-3a531ab6df7mr11538936f8f.51.1749485557899;
        Mon, 09 Jun 2025 09:12:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHofgZLohCG+FWmN+/vAPyJ/ugDytxQFMase2Yyl4U6lYfpYfq8glZkroTe4NesF/K3gOUdGA==
X-Received: by 2002:a05:6000:2512:b0:3a4:f722:f98d with SMTP id ffacd0b85a97d-3a531ab6df7mr11538911f8f.51.1749485557485;
        Mon, 09 Jun 2025 09:12:37 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.64.79])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-45213726c44sm117509405e9.28.2025.06.09.09.12.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jun 2025 09:12:36 -0700 (PDT)
Message-ID: <7ce603ad-33c7-4dcd-9c63-1f724db9978e@redhat.com>
Date: Mon, 9 Jun 2025 18:12:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] target/i386: KVM: add hack for Windows vCPU hotplug with
 SGX
To: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>, zhao1.liu@intel.com,
 mtosatti@redhat.com
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, den@virtuozzo.com,
 andrey.drobyshev@virtuozzo.com
References: <20250609132347.3254285-2-andrey.zhadchenko@virtuozzo.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250609132347.3254285-2-andrey.zhadchenko@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/9/25 15:23, Andrey Zhadchenko wrote:
> When hotplugging vCPUs to the Windows vms, we observed strange instance
> crash on Intel(R) Xeon(R) CPU E3-1230 v6:
> panic hyper-v: arg1='0x3e', arg2='0x46d359bbdff', arg3='0x56d359bbdff', arg4='0x0', arg5='0x0'
> 
> Presumably, Windows thinks that hotplugged CPU is not "equivalent enough"
> to the previous ones. The problem lies within msr 3a. During the startup,
> Windows assigns some value to this register. During the hotplug it
> expects similar value on the new vCPU in msr 3a. But by default it
> is zero.

If I understand correctly, you checked that it's Windows that writes 
0x40005 to the MSR on non-hotplugged CPUs.

>     CPU 0/KVM-16856   [007] .......   380.398695: kvm_msr: msr_read 3a = 0x0
>     CPU 0/KVM-16856   [007] .......   380.398696: kvm_msr: msr_write 3a = 0x40005
>     CPU 3/KVM-16859   [001] .......   380.398914: kvm_msr: msr_read 3a = 0x0
>     CPU 3/KVM-16859   [001] .......   380.398914: kvm_msr: msr_write 3a = 0x40005
>     CPU 2/KVM-16858   [006] .......   380.398963: kvm_msr: msr_read 3a = 0x0
>     CPU 2/KVM-16858   [006] .......   380.398964: kvm_msr: msr_write 3a = 0x40005
>     CPU 1/KVM-16857   [004] .......   380.399007: kvm_msr: msr_read 3a = 0x0
>     CPU 1/KVM-16857   [004] .......   380.399007: kvm_msr: msr_write 3a = 0x40005

This is a random chcek happening, like the one below:

>     CPU 0/KVM-16856   [001] .......   384.497714: kvm_msr: msr_read 3a = 0x40005
>     CPU 0/KVM-16856   [001] .......   384.497716: kvm_msr: msr_read 3a = 0x40005
>     CPU 1/KVM-16857   [007] .......   384.934791: kvm_msr: msr_read 3a = 0x40005
>     CPU 1/KVM-16857   [007] .......   384.934793: kvm_msr: msr_read 3a = 0x40005
>     CPU 2/KVM-16858   [002] .......   384.977871: kvm_msr: msr_read 3a = 0x40005
>     CPU 2/KVM-16858   [002] .......   384.977873: kvm_msr: msr_read 3a = 0x40005
>     CPU 3/KVM-16859   [006] .......   385.021217: kvm_msr: msr_read 3a = 0x40005
>     CPU 3/KVM-16859   [006] .......   385.021220: kvm_msr: msr_read 3a = 0x40005
>     CPU 4/KVM-17500   [002] .......   453.733743: kvm_msr: msr_read 3a = 0x0        <- new vcpu, Windows wants to see 0x40005 here instead of default value>
>     CPU 4/KVM-17500   [002] .......   453.733745: kvm_msr: msr_read 3a = 0x0
> 
> Bit #18 probably means that Intel SGX is supported, because disabling
> it via CPU arguments results is successfull hotplug (and msr value 0x5).

What is the trace like in this case?  Does Windows "accept" 0x0 and 
write 0x5?

Does anything in edk2 run during the hotplug process (on real hardware 
it does, because the whole hotplug is managed via SMM)?  If so maybe 
that could be a better place to write the value.

So many questions, but I'd really prefer to avoid this hack if the only 
reason for it is SGX...

Paolo

> This patch introduces new CPU option: QEMU will copy msr 3a value from
> the first vCPU during the hotplug. This problem may not be limited to
> SGX feature, so the whole register is copied.
> By default the option is set to auto and hyper-v is used as Windows
> indicator to enable this new feature.
> 
> Resolves: #2669
> Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
> ---
>   target/i386/cpu.c     |  2 ++
>   target/i386/cpu.h     |  3 +++
>   target/i386/kvm/kvm.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 48 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 40aefb38f6..5c02f0962d 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -9389,6 +9389,8 @@ static const Property x86_cpu_properties[] = {
>       DEFINE_PROP_BOOL("x-intel-pt-auto-level", X86CPU, intel_pt_auto_level,
>                        true),
>       DEFINE_PROP_BOOL("x-l1-cache-per-thread", X86CPU, l1_cache_per_core, true),
> +    DEFINE_PROP_ON_OFF_AUTO("kvm-win-hack-sgx-cpu-hotplug", X86CPU,
> +                            kvm_win_hack_sgx_cpu_hotplug, ON_OFF_AUTO_AUTO),
>   };
>   
>   #ifndef CONFIG_USER_ONLY
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 545851cbde..0505d3d1cd 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2301,6 +2301,9 @@ struct ArchCPU {
>       /* Forcefully disable KVM PV features not exposed in guest CPUIDs */
>       bool kvm_pv_enforce_cpuid;
>   
> +    /* Copy msr 3a on cpu hotplug */
> +    OnOffAuto kvm_win_hack_sgx_cpu_hotplug;
> +
>       /* Number of physical address bits supported */
>       uint32_t phys_bits;
>   
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 56a6b9b638..c1e7d15e2e 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -5266,6 +5266,42 @@ static int kvm_get_nested_state(X86CPU *cpu)
>       return ret;
>   }
>   
> +static int kvm_win_hack_hotplug_with_sgx(CPUState *cs)
> +{
> +    DeviceState *dev = DEVICE(cs);
> +    X86CPU *cpu = X86_CPU(cs);
> +    int ret;
> +
> +    /*
> +     * If CPU supports Intel SGX, Windows guests expect readmsr 0x3a after
> +     * hotplug to have some bits set, just like on other vCPUs. Unfortunately
> +     * by default it is zero and other vCPUs registers are filled by Windows
> +     * itself during startup.
> +     * Just copy the value from another vCPU.
> +     */
> +
> +    if (cpu->kvm_win_hack_sgx_cpu_hotplug == ON_OFF_AUTO_OFF ||
> +        (cpu->kvm_win_hack_sgx_cpu_hotplug == ON_OFF_AUTO_AUTO &&
> +        !hyperv_enabled(cpu))) {
> +        return 0;
> +    }
> +
> +    if (cpu->env.msr_ia32_feature_control) {
> +        return 0;
> +    }
> +
> +    if (IS_INTEL_CPU(&cpu->env) && dev->hotplugged && first_cpu) {
> +        ret = kvm_get_one_msr(X86_CPU(first_cpu),
> +                              MSR_IA32_FEATURE_CONTROL,
> +                              &cpu->env.msr_ia32_feature_control);
> +        if (ret != 1) {
> +            return ret;
> +        }
> +    }
> +
> +    return 0;
> +}
> +
>   int kvm_arch_put_registers(CPUState *cpu, int level, Error **errp)
>   {
>       X86CPU *x86_cpu = X86_CPU(cpu);
> @@ -5273,6 +5309,13 @@ int kvm_arch_put_registers(CPUState *cpu, int level, Error **errp)
>   
>       assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
>   
> +    if (level == KVM_PUT_FULL_STATE) {
> +        ret = kvm_win_hack_hotplug_with_sgx(cpu);
> +        if (ret < 0) {
> +            return ret;
> +        }
> +    }
> +
>       /*
>        * Put MSR_IA32_FEATURE_CONTROL first, this ensures the VM gets out of VMX
>        * root operation upon vCPU reset. kvm_put_msr_feature_control() should also


