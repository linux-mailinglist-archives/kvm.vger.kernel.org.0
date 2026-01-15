Return-Path: <kvm+bounces-68203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C2DDD2611C
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:06:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 09D713022F0D
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD193BF2F7;
	Thu, 15 Jan 2026 17:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Lq3UvPm9"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A933ACEFE;
	Thu, 15 Jan 2026 17:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496740; cv=none; b=oPUwXgNi6BOe7HyIMY6WTWw6dtOpRSw1i5wi1tlrj1G1JE5xeGw5OVM/PtZWib3MUkchm2M2BfqJ5ry9YOcpWZYM1TBFC/Cb6D8CwcANaYstiTmMD7typ9ngFFr2ETss4Gb1XRYJTUIYMX29gAkSPX8JgjCcaheEQzU6aZ2jNog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496740; c=relaxed/simple;
	bh=uvVz6nAFR+gvd7Q0IV23MYNptO/uzmH+NbFBq7wpVEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6kKyg2ZNafH8CUCSiCudkm6AbumNDB6RMP0rvtOXvxLeNUBGjAtT2E7rSLzRWolT7JGXmGWuiRhdGE+QO8z2ruCW5hCI8Eq4d+uq6Dt7DVCowomWpRnzChQudT68r5BRK9pxOCFneWfGPwMBRwp1x3Wq8oNXBUQIvl6qIVLU94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Lq3UvPm9; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9EB8740E02D2;
	Thu, 15 Jan 2026 17:05:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id HVxMVg4prymo; Thu, 15 Jan 2026 17:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1768496724; bh=fHIhJ3hlz6pKSUTY0YKkzLhmuCLjHwUpcLQVf3oz0Ss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lq3UvPm9mQoKuZO7P/aQLnenVsduGX8uVgR+dznjxO5gi8N9VXpaPZ3o/uOOs6xlp
	 RmyvKOrkA/+FuBAwSIl3JLbBTfb69gG/vM71CTHy9jxpWXuV+OeufGvnh/VLjkG6y9
	 gDKHaTSriPtYyiLZCVB4vH7iL6aTIwYm+Hp7ibe39aO2I28vNaSOtyM3ZBM/jCgtse
	 bY5tmENwiqaezSRPmGWBs/FAoZI18QereP2rvzr/GcTvJbIJTwfIRbTyIll09PWI4f
	 VrpamUCR2UjPOTsfWCr0zodA7koetwLGbVfRV5SSJ19fVUQFcDvjlP+mSnhRUniUCU
	 rs3fraBz0cMcApyr5+zG1RI3aFbT39cYNlTRH/eCAFew3yewyyk889ipYS/d8bXm0X
	 XlG2/50MdokDIaWMExKOXssFKHfyJqG/KTNQaGzcWaA3Dl56O5joNwGmjUEdwu/4aY
	 rOxIa/rTwXkb5IChw4QXJ6KUuopm1EVakTUsbqB4kFLKHCc0LkoWPJa10TNP3TAkaZ
	 zEs/rIX9J7v9tLriyKf8FNO+TR9NjcxaB6P6A4qHNl1SqiNorwrSMD/outsLwR6GwF
	 p9Br51fL5qICmPSObUnpx1kZG8Wuqk4BkYra2A9kaA617Nv4A2w3eWzKA5g89xerDu
	 Xn78vvQ2G13AG0JCrD1hxEyQ=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id C954B40E0252;
	Thu, 15 Jan 2026 17:05:19 +0000 (UTC)
Date: Thu, 15 Jan 2026 18:05:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
	kvm <kvm@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v2 0/4] x86, fpu/kvm: fix crash with AMX
Message-ID: <20260115170511.GFaWkeR1TuFMlzy2LJ@fat_crate.local>
References: <20260101090516.316883-1-pbonzini@redhat.com>
 <20260115122204.GDaWjb7Npp80GK-mFn@fat_crate.local>
 <CABgObfYk-PxxGOj3az26=tt-p7_qu=eFhgdjKFqva7Stui9HYA@mail.gmail.com>
 <aWkYVwTyOPxnRgzN@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aWkYVwTyOPxnRgzN@google.com>

On Thu, Jan 15, 2026 at 08:39:51AM -0800, Sean Christopherson wrote:
>  :   1. vCPU loads non-init XTILE data without ever setting XFD to a non-zero value
>  :      (KVM only disables XFD interception on writes with a non-zero value).
>  :   2. Guest executes WRMSR(MSR_IA32_XFD) to set XFD[18] = 1
>  :   3. VM-Exit due to the WRMSR
>  :   4. Host IRQ arrives and triggers kernel_fpu_begin()
>  :   5. save_fpregs_to_fpstate() saves guest FPU with XFD[18]=0
>  :   6. fpu_update_guest_xfd() stuffs guest_fpu->fpstate->xfd = XFD[18]=1
>  :   7. vcpu_enter_guest() attempts to load XTILE data with XFD[18]=1

I don't know, maybe I'm missing an important aspect but if not, I'm wondering
how you folks are not seeing the big honking discrepancy here.

*Anything* poking in MSRs under the kernel's feet where the kernel doesn't
know about that poking, is bound to cause trouble. And this is no exception.

Step 5. above should use the updated XFD[18]=1. The guest just disabled that
state! Anything else is bonkers.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

