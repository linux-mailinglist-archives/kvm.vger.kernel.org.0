Return-Path: <kvm+bounces-66091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C6B0ECC5170
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 21:27:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4A961303E3F6
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 20:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67AFF325494;
	Tue, 16 Dec 2025 20:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="39POEVkm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E0E29BDBF
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 20:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765916845; cv=none; b=AKbHE+IEqPi8MiCWlBP2duKqZJrzFCqsKNcHXP4dE52314zDCJ22PCcsMd2KXd5rYX1a6zzXD+APiWjM0zGdUv500OTj4MKnUrCpMQPzkvEmi4mjbbEGFjdeAAIoXus4HKeGPeIIrlPwljdwxtRw3Qm8i7dHoXZCP+xegPnq1w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765916845; c=relaxed/simple;
	bh=Z998CI2R9DWz+sTwtdUeSbY5j3fYLGUJm4DrT6xZPcs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PqvMdpP3bzm6LDk7lEYZubB5Yj35MH4LYjcRUoFsGHpZF8IGrcz6TZtPUA2ypEBuwe0cghw+J6Q1a0YJO3LsGwsv5HDsFe3qDgkU6P69MTd4t8OLHAvySEHC49E4h2CZicHK2nYEOz0MH28hzEz8GwEozAi6LH6Tt6VE2mq4gz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=39POEVkm; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29f8e6a5de4so48716025ad.2
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 12:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765916843; x=1766521643; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H3Trw34QtTWFxZuG8XSavxKfB6i1mWXvC4DFoqDAeK0=;
        b=39POEVkmbNyPXJMrTDGj8GlkX7PmkuBWEQKprY0YkQbJ51eoM0bFUocgJp/Rn+FZ0O
         yBixDooG9/Cs08w6D1NqvGkA9HyVuiRr7j4fSmkVq6tkjKJtaA7cRAmdeh4YtV0RtmsN
         f0xqoBRhPg+NYfZVJa4XJcFT2omm5YXiXjAGoHNPat91Pz80HB50WhoSo83rOvc6CZqv
         k8I3ZPPwhCd/OhYAlIOlIzwpk5mXruWgAjsiAd3BtqQoG2qh5dpdNabaEPA29sCsChJY
         bThecjJFbGbXLqmQXWR1nhxWhrnCYEbOTnCCFYmZ9vCMEoZ4giQ6qOH+uvaw2zQu+1ze
         aOSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765916843; x=1766521643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H3Trw34QtTWFxZuG8XSavxKfB6i1mWXvC4DFoqDAeK0=;
        b=lU5hMxsk66ACPGEDWrPJfMHwaiZfJR3w6aGvB1xnqCbSpbecZlU3xDLe3vdpDEoPW2
         5G/uVSvYZz9huVRCpKVLcURoqcWwT60QKuHjrhJ4+0hzEVM6IKpzbMzndhp0NPh8SnTl
         Md4YMxbeFAG8+edwDMTVzNhKI76yV/rYRrExVPvfAaxVw0L34BjPCmLOoZIq0Ecrydb8
         EeYSD7HR1IG1OtsWNWDMrJb0z3kS1m27IujdXqb3Ev3sOqYitstr7723AQRtBhO/ZkvM
         A1tZJgOT7FtVfXG6tHg3yFMO+Js+n9Iz56grcAq+TxnVPT45xZ6dx0xq44phfq9QiAvt
         CfjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCxYgJ7HYmt62NEL+DCpgXH3o+IkOGq7mxsD+mGMkh5d+ifFH+VhJdaJqMVaSkhqXV4CI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQnRLs1qWCH7DKS0MdzPYlijik2GuDDvLXzamkoOGXCg5sFt0+
	IA5EMJFr9VcF8uXaiY8tYNiJTv+/C7yYjgVNqbk9Iw7axy4BQvsAbKhnLGU9xBRjIbrgVPYufAV
	5rp5oNQ==
X-Google-Smtp-Source: AGHT+IGw2Y0oIyPL7/Z5ZRFL99wOZF3DjNm68wKpEr6Cmy7A+IK7g+lrFwpJHi9taJfG166riArjM3fAmcI=
X-Received: from plqw1.prod.google.com ([2002:a17:902:a701:b0:29d:5afa:2c5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2ca:b0:2a0:d596:a88d
 with SMTP id d9443c01a7336-2a0d596ab66mr100954225ad.26.1765916843233; Tue, 16
 Dec 2025 12:27:23 -0800 (PST)
Date: Tue, 16 Dec 2025 12:27:21 -0800
In-Reply-To: <20250816101308.2594298-3-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250816101308.2594298-1-dwmw2@infradead.org> <20250816101308.2594298-3-dwmw2@infradead.org>
Message-ID: <aUHAqVLlIU_OwESM@google.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: Provide TSC frequency in "generic"
 timing infomation CPUID leaf
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, graf@amazon.de, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Colin Percival <cperciva@tarsnap.com>, Zack Rusin <zack.rusin@broadcom.com>, 
	Doug Covelli <doug.covelli@broadcom.com>
Content-Type: text/plain; charset="us-ascii"

+Doug and Zach

VMware folks, TL;DR question for you:

  Does VMware report TSC and APIC bus frequency in CPUID 0x40000010.{EAX,EBX},
  or at the very least pinky swear not to use those outputs for anything else?

On Sat, Aug 16, 2025, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> In https://lkml.org/lkml/2008/10/1/246 a proposal was made for generic
> CPUID leaves, of which only 0x40000010 was defined, to contain the TSC
> and local APIC frequencies. The proposal from VMware was mostly shot
> down in flames, *but* XNU does unconditionally assume that this leaf
> contains the frequency information, if it's present on any hypervisor:
> https://github.com/apple/darwin-xnu/blob/main/osfmk/i386/cpuid.c
> 
> So does FreeBSD: https://github.com/freebsd/freebsd-src/commit/4a432614f68

For me, the more convincing argument is following the breadcrumbs from the
changelog for the above commit

 : This speeds up the boot process by 100 ms in EC2 and other systems,
 : by allowing the early calibration DELAY to be skipped.

back to QEMU commit 9954a1582e ("x86-KVM: Supply TSC and APIC clock rates to guest
like VMWare"), with an assumption that EC2 enables vmware-cpuid-freq.  I.e. the
de facto reference VMM for KVM (QEMU), has utilized CPUID 0x40000010 in this way
for almost 9 years.

> So at this point it would be daft for a hypervisor to expose 0x40000010
> for any *other* content.

My only hesitation is that VMware _does_ put other content in 0x40000010.  From
arch/x86/kernel/cpu/vmware.c:

  static u8 __init vmware_select_hypercall(void)
  {
  	int eax, ebx, ecx, edx;
  
  	cpuid(CPUID_VMWARE_FEATURES_LEAF, &eax, &ebx, &ecx, &edx);
  	return (ecx & (CPUID_VMWARE_FEATURES_ECX_VMMCALL |
  		       CPUID_VMWARE_FEATURES_ECX_VMCALL));
  }

And oddly, Linux doesn't use CPUID to get the TSC frequency on VMware:

	eax = vmware_hypercall3(VMWARE_CMD_GETHZ, UINT_MAX, &ebx, &ecx);

	if (ebx != UINT_MAX) {
		lpj = tsc_khz = eax | (((u64)ebx) << 32);
		do_div(tsc_khz, 1000);
		WARN_ON(tsc_khz >> 32);
		pr_info("TSC freq read from hypervisor : %lu.%03lu MHz\n",
			(unsigned long) tsc_khz / 1000,
			(unsigned long) tsc_khz % 1000);

		if (!preset_lpj) {
			do_div(lpj, HZ);
			preset_lpj = lpj;
		}

		vmware_tsc_khz = tsc_khz;
		tsc_register_calibration_routines(vmware_get_tsc_khz,
						  vmware_get_tsc_khz,
						  TSC_FREQ_KNOWN_AND_RELIABLE);

However, VMware appears to deliberately avoid using EAX and EBX, and the above
FreeBSD commit (and current code) is broken if VMware does NOT populate CPUID
0x40000010 with at least the TSC frequency.  Because FreeBSD prioritizes getting
the TSC frequency from CPUID:

	if (tsc_freq_cpuid_vm()) {
		if (bootverbose)
			printf(
		    "Early TSC frequency %juHz derived from hypervisor CPUID\n",
			    (uintmax_t)tsc_freq);
	} else if (vm_guest == VM_GUEST_VMWARE) {
		tsc_freq_vmware();
		if (bootverbose)
			printf(
		    "Early TSC frequency %juHz derived from VMWare hypercall\n",
			    (uintmax_t)tsc_freq);
	}

where tsc_freq_cpuid_vm() only checks if 0x40000010 is available, not if
0x40000010.EAX contains a sane, non-zero frequency.

  static int
  tsc_freq_cpuid_vm(void)
  {
  	u_int regs[4];
  
  	if (vm_guest == VM_GUEST_NO)
  		return (false);
  	if (hv_high < 0x40000010)
  		return (false);
  	do_cpuid(0x40000010, regs);
  	tsc_freq = (uint64_t)(regs[0]) * 1000;
  	tsc_early_calib_exact = 1;
  	return (true);
  }

I.e. if VMware isn't populating 0x40000010.EAX with the TSC frequency, then I
would think FreeBSD would be getting bug reports when running on VMware, which
AFAICT isn't the case.

So jumping back to my questions for the VMware folks, if VMware enumerates timing
information in CPUID 0x40000010.{EAX,EBX}, or at least doesn't use those outputs
for other purposes, then I 100% agree that reserving CPUID 0x40000010 for timing
information in KVM's PV CPUID leaves is a no-brainer.  Even if the answer to both
is "no", I think it still makes sense to carve out 0x40000010, it'll just require
a bit more care and some different context.

