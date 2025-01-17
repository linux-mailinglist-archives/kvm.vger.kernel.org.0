Return-Path: <kvm+bounces-35871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E704A1589D
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 21:29:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC88B3A91A0
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7314A1ABED9;
	Fri, 17 Jan 2025 20:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="j9GFd6xm"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E60C1A9B2C;
	Fri, 17 Jan 2025 20:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145766; cv=none; b=XhFlSJA4O52MKemfrzRqWr4c4NzDtYnxU41vZWd9PaXo5qsQCMGZxsdylbChOoNx4wEYgK7egvmnN/5KT8amkDtTuFVBLDRsnLSkFG/zAVFT3RZNDVe57ZbJBx73xUtV1Wcp2Dj/AXd7EruNgesiRfeM+m7qkJTt3q9odbofmNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145766; c=relaxed/simple;
	bh=jDwH0jwClGveK7duljYjk1jmCfhZmrsPZOmyyDX0DKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QqIeHGs3P5VP6YIHN3DRYqOR6f1d3p5VIBxEWBrQXtDgr/b6s4ZwUS9iQCi3S0Ese+r45Jzpi8fA6t4TVnJw6Vy1BF191HYNWM6qKcdJSFseESmtje2GuXdfQ3Qf6+9iRHDUNPuzaTT2cOMdvWDIafac6NQu3rJyxeF/SZftqJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=j9GFd6xm; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3B29F40E0378;
	Fri, 17 Jan 2025 20:29:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id UdVvd6dyOmzf; Fri, 17 Jan 2025 20:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1737145750; bh=GPILzkLj/s4MV8NcCkZWrcr6vzeYAhrHniUXkucJLWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j9GFd6xmmBbx1qiuPe74fYzvdgfbqSPJG2emUD4JOjtUBCmZzjtpdpx+XU3cHhtUD
	 BdzKY2s3yebf3cB+rgfhW0Msm/dRCAr//aWicu5CFpl1amWPyica5iY6Rlx7DRB4g4
	 Q/4uwJJvDOauSzjCtyZRdbHTkdlilh7S89qj4LrBmTDZNOZwO7syNR3c3/SCZfdC2V
	 +/hgDVxp8BdeUJG8xDeAj64AWTfctXETxRIrE+aRb1IGNoBrtZ5Dza/Gi2SMIC1xTM
	 jrDB8yHwUTHW6vF6npqrobOnWuCFlVPbbhkkYwXw4CLvm8Od0L0HoFJVRQ2B0SDoqX
	 sCN4yzsdKOnEVlExo1FLjCMFxe3CYVkejTE1ZjcmPnHQdvye97eC/UZhjdNwJmHt3k
	 oMM+v32Q28b3EVDLgbloiwH0apJKjtdznBBfRc47NaDPGN09q9b8tBQo1osi1CrBU5
	 KQmcQ2hymuwe7amj452spu7NS9YzftDiwkf3Sc8mmQ8mpkEzoKOFCck4e6HX4WtvMt
	 Grs4a3Et1Sqx6f2aIhoahwkt4FohEI+vM2F8e38DtJKSM1t/x+M9g/dnDOi9Q26y3A
	 N7dqfWns6UMStRlZ9HJdvk+G7ZFRUaNJmTZzzcIX/iu3yVMqPeybsdT76kikB8hkuX
	 HOPzPSgbZ86aDXfPUKTAURWI=
Received: from zn.tnic (p200300Ea971f93e4329C23fFFeA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93e4:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 04A8E40E0289;
	Fri, 17 Jan 2025 20:28:54 +0000 (UTC)
Date: Fri, 17 Jan 2025 21:28:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	pgonda@google.com, pbonzini@redhat.com, francescolavra.fl@gmail.com,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
Message-ID: <20250117202848.GAZ4q9gMHorhVMfvM0@fat_crate.local>
References: <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local>
 <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com>
 <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com>
 <Z36FG1nfiT5kKsBr@google.com>
 <20250108153420.GEZ36a_IqnzlHpmh6K@fat_crate.local>
 <Z36vqqTgrZp5Y3ab@google.com>
 <4ab9dc76-4556-4a96-be0d-2c8ee942b113@amd.com>
 <Z4gqlbumOFPF_rxd@google.com>
 <20250116162525.GFZ4ky9TdSn7jltgw7@fat_crate.local>
 <Z4k6OcbLqMxvvmb-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z4k6OcbLqMxvvmb-@google.com>

On Thu, Jan 16, 2025 at 08:56:25AM -0800, Sean Christopherson wrote:
> It's only with SNP and TDX that the clocksource becomes at all interesting.

So basically you're saying, let's just go ahead and trust the TSC when the HV
sets a bunch of CPUID bits.

But we really really trust it when the guest type is SNP+STSC or TDX since
there the HV is out of the picture and the only one who can flub it there is
the OEM.

> CPUID 0x15 (and 0x16?) is guaranteed to be available under TDX, and Secure TSC
> would ideally assert that the kernel doesn't switch to some other calibration
> method too.  Not sure where to hook into that though, without bleeding TDX and
> SNP details everywhere.

We could use the platform calibrate* function pointers and assign TDX- or
SNP-specific ones and perhaps even define new such function ptrs. That's what
the platform stuff is for... needs staring, ofc.

> I agree the naming is weird, but outside of the vendor checks, the VM code is
> identical to the "native" code, so I don't know that it's worth splitting into
> multiple functions.
> 
> What if we simply rename it to calibrate_tsc_from_cpuid()?

This is all wrong layering with all those different guest types having their
own ->calibrate_tsc:

arch/x86/kernel/cpu/acrn.c:32:  x86_platform.calibrate_tsc = acrn_get_tsc_khz;
arch/x86/kernel/cpu/mshyperv.c:424:             x86_platform.calibrate_tsc = hv_get_tsc_khz;
arch/x86/kernel/cpu/vmware.c:419:               x86_platform.calibrate_tsc = vmware_get_tsc_khz;
arch/x86/kernel/jailhouse.c:213:        x86_platform.calibrate_tsc              = jailhouse_get_tsc;
arch/x86/kernel/kvmclock.c:323: x86_platform.calibrate_tsc = kvm_get_tsc_khz;
arch/x86/kernel/tsc.c:944:      tsc_khz = x86_platform.calibrate_tsc();
arch/x86/kernel/tsc.c:1458:                     tsc_khz = x86_platform.calibrate_tsc();
arch/x86/kernel/x86_init.c:148: .calibrate_tsc                  = native_calibrate_tsc,
arch/x86/xen/time.c:569:        x86_platform.calibrate_tsc = xen_tsc_khz;

What you want sounds like a redesign to me considering how you want to keep
the KVM guest code and baremetal pretty close... Hmmm, needs staring...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

