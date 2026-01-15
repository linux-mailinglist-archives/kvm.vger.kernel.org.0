Return-Path: <kvm+bounces-68204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E37D26461
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:19:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BA115301A0E5
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C60C3BFE5D;
	Thu, 15 Jan 2026 17:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XlUHcAI9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587D33BFE22
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 17:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497177; cv=none; b=KV2vPCdpeEtp8xX8R3UEnNpALAvzUnzEDZDTf1LV6ZSIfY80dLVJyZaKTsZAN5VOHUtmlVN4jR3gQIQu44gaogMCLGYlnRb1cuHIeMd4eCeBJEeQ69j7k+lQ5CnLfxzbpigdGyTqOBoIN4huV6IxpkB7hVvWlJX4CO69+kdmL3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497177; c=relaxed/simple;
	bh=4f9ahSm6ERIRjsPqkornw3LwHuEt4pIdF9AaKwmoiNM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dmB9E7eG2qEjDzdVTdn2XIjXJ+Oi8XVu8Fe4aSPSBGb8jf97QrG/ft3CGbQyWK2wYTZP9aBTZTaAiCxBcShX3LV0dxqppiGuHLrnDoNsvhrFXNDYULVX3gMr/j9kk/HhRGWYPlX7VfVH29gVR7IqJC0cFLkSdbe3SX4h9wwbM6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XlUHcAI9; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b609c0f6522so2052426a12.3
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 09:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768497176; x=1769101976; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2iXUk4sks+mNv87AcX+c72NCBW2V7T78MAYEKbYV4oU=;
        b=XlUHcAI9x8GLhSCRNn+qSmOfhPZdnw9H/9UFbnmnb3h5s0+14QwNJZvyddVlHE95i9
         1itGrbXfnpr5QFGLr37RfoRpmfndQAITQ0p3YDlzAf527OQYFmzpIWxn2iITI+zUIrKE
         3u/gBfXiI6GOppWPPPWG5LLudK46wR10p6GyMFrc5lBF+37fVkNZYUxtj4A3H9UXfiFR
         k894lC0mu7B1lLSDNtNZ/peVYNiUdAfEuPustwvziUYzmi0YHbDnRGyKF8ZXG1ujIsAE
         lBgtTBOK40z2XKPRkjOiPj2gUqhxTKAUAKn6jBwJekXSK87igncbKCDFTl4SWwn1nlQF
         PzXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768497176; x=1769101976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2iXUk4sks+mNv87AcX+c72NCBW2V7T78MAYEKbYV4oU=;
        b=hQlsHoZyMAFiDSpSyVzuuIMPBLDJ9kErTb/1OMHAIBpont1b5+ivjbK1DXa8bM4dI0
         hmHFTQTFn7HJ3PIv2tumqPieMclw3HXIVMRJUYALoV6WMhRpBvN6x3VX59EwkgMzz/1S
         wiz62BIimUlYn0qxfDxjsNyjJ0mztsX8s2uYUM0WhQO7RvXpS6a4/uYpB8WY5wgeajqq
         w6JX27NUpS7rAz80hkyG9Crt3sDMBvCglsT/O7WNdNJOjfYiy/8qZxbUk0fwwEZRxUMb
         6l/OLCykv38N9lVcpu8Q8+fHh4LRGTAqFXk3Ypw541qjXTymdK95RpcCWR3tq71tk3nN
         vLsA==
X-Forwarded-Encrypted: i=1; AJvYcCWWJO0k03jVgvxu6SjLEp6phKvjgYapUtGAr5RWWFwcl85aLROs3jmp0ZtTe4fi8w6Tcu8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzykRFgn0pF+G3BCJYXt/0aRcuMlgZwv7VD/lwfPzjjQsA1eDvr
	gJKv/p7+OGlp8a6QwRX3NlajhQoReaRGhhqxEEUtpe1raphlngVh//FMDcUkGNgTIu7MUzUlFrd
	htRemlA==
X-Received: from pgww28.prod.google.com ([2002:a05:6a02:2c9c:b0:bd9:a349:94c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6009:b0:347:9ae1:cffb
 with SMTP id adf61e73a8af0-38dfe5e5392mr396962637.24.1768497175645; Thu, 15
 Jan 2026 09:12:55 -0800 (PST)
Date: Thu, 15 Jan 2026 09:12:54 -0800
In-Reply-To: <20260115170511.GFaWkeR1TuFMlzy2LJ@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com> <20260115122204.GDaWjb7Npp80GK-mFn@fat_crate.local>
 <CABgObfYk-PxxGOj3az26=tt-p7_qu=eFhgdjKFqva7Stui9HYA@mail.gmail.com>
 <aWkYVwTyOPxnRgzN@google.com> <20260115170511.GFaWkeR1TuFMlzy2LJ@fat_crate.local>
Message-ID: <aWkgFv_allv34JYY@google.com>
Subject: Re: [PATCH v2 0/4] x86, fpu/kvm: fix crash with AMX
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 15, 2026, Borislav Petkov wrote:
> On Thu, Jan 15, 2026 at 08:39:51AM -0800, Sean Christopherson wrote:
> >  :   1. vCPU loads non-init XTILE data without ever setting XFD to a non-zero value
> >  :      (KVM only disables XFD interception on writes with a non-zero value).
> >  :   2. Guest executes WRMSR(MSR_IA32_XFD) to set XFD[18] = 1
> >  :   3. VM-Exit due to the WRMSR
> >  :   4. Host IRQ arrives and triggers kernel_fpu_begin()
> >  :   5. save_fpregs_to_fpstate() saves guest FPU with XFD[18]=0
> >  :   6. fpu_update_guest_xfd() stuffs guest_fpu->fpstate->xfd = XFD[18]=1
> >  :   7. vcpu_enter_guest() attempts to load XTILE data with XFD[18]=1
> 
> I don't know, maybe I'm missing an important aspect but if not, I'm wondering
> how you folks are not seeing the big honking discrepancy here.
> 
> *Anything* poking in MSRs under the kernel's feet where the kernel doesn't
> know about that poking, is bound to cause trouble. And this is no exception.

KVM isn't poking the MSR, KVM is literally calling a kernel API, fpu_update_guest_xfd(),
to ask/tell the kernel to update the guest's XFD.  It's the FPU code that's buggy,
because it doesn't ensure the state _it_ saved _without KVM's knowledge_ is
consistent with new XFD.

> Step 5. above should use the updated XFD[18]=1. The guest just disabled that
> state! Anything else is bonkers.

As I explained in my previous reply, that's easier said than done:

  In theory we could ensure KVM saved exactly what is resident in hardware, but
  that's quite tricky (and costly!) as it would require doing xfd_update_state()
  before _every_ save_fpregs_to_fpstate(), e.g. not just in fpu_swap_kvm_fpstate().
  E.g. if the host kernel used the FPU from IRQ context (spoiler alert!), then KVM
  wouldn't have a chance to swap in the maximal XFD[18]=0 value (i.e. the userspace
  task's XFD).

