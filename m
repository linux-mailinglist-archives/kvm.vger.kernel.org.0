Return-Path: <kvm+bounces-35306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA815A0BE29
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 17:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D23DA167E3A
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 16:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EFC420F071;
	Mon, 13 Jan 2025 16:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q8jCYnFg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AC13A8D0
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736787578; cv=none; b=V97dogbCq20Nw7dLcFYdpaQECaXgPKJoU6479atZPtlrtKzo28jljuYKJx6p5qpwPr5jz95KpoC0h90vyu4hchhArAmrzUf/T+w6z8nKmu6br24a/xrpRQKhEk47bc6tmRfvBMit7hP5CtSTZF/oboNFov0+VeV99eLQIg2kn+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736787578; c=relaxed/simple;
	bh=PXoDtKjpL57QI5TTVIsaHaCrbTm8U8iRsyaErR4Gcrw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZAJ/xFMVc4DZA2GUVFFIxtfehPRHPQJNrb4ihbrATAwC7zP/7PKJcBcQmNKnuyFvhlu4GkW9RksnGnuImmS+gIdDoYptmAdlTswx35urCEHTUOi1YETY+OQrgoTht6Gx2LS57Y9otbd6GOLZ6b5fAilww0sATKoSXwJLNdYEtmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q8jCYnFg; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21648ddd461so88118605ad.0
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 08:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736787576; x=1737392376; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lNi4ttNXrfrXDMynei5+HVfxxr2BRc6T71jVjH9tT8o=;
        b=q8jCYnFgJVeLiK4CIR8EIw2lsB6JhLo91/eiyqQFMbNT9EdWJ4x7TjnHLdbVqAhjOD
         hN/tb44E1GEYmwjSEEwqBQa61B/moMmQlz3U402uJPkhOc41+HrfubABuMIXz5NXb0Wj
         0nRM5TYUQmqsGxE5E7il3FPgUZWLptymRFIFgogkltXEVVnC+QQZFE9TJtgYkqZ4frN2
         rvdja6uDopIzLBlmDCeGGkRx+ERmk/l6ZxCNstw/KNAI0zYjTsP4U54Z0ELcBAicyQXx
         a8N32ihqhUnSDULVK8ZaUt0M9S6nRi6aFAW9exAjywAhLcIVJkUSmh6Cb3T+mxB4VbRT
         iskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736787576; x=1737392376;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lNi4ttNXrfrXDMynei5+HVfxxr2BRc6T71jVjH9tT8o=;
        b=l51GY7fy5EmvKWRJ/yvFWMUsSd0D4Zi4yDJ9cD4exg5KmJrKaUk5JHFMpX4NoaIP4k
         cceIdNVy5p8E2OCVYCootdlJCe/16Im0DMye3A3YJoGm/YeFa88/Vo/V/T9UMnPx3UNq
         EVtBWoIs7whzswU0xNoUPzcOvFBm/Zar1kDYFXcoFkkhKfj5txk/F5YhUHK8MkQyh+xr
         XSsmb7/TP+dYQp0z2gkSGNNkh6WBtMfx2+t3mWtHODrTRjnNBiV/u/PsphXZjZrK0INS
         nEg8UMlwRJj+5MSd34vOZ6C0EPw2h+OGPFXljlTewizN/6cl2JLYUR3q8v1mxKgj1I0I
         L8+w==
X-Forwarded-Encrypted: i=1; AJvYcCX6eggpEVOvcd3LL1mIew9p74Zqxyyxo2DqVeUfcP5z3HnkcywFOEhzgFhME5G04/LKQm4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqMZBsLvD6Fh6yMPbcSbuNrCI8juiQ10g/XMxSiz2GstJip2Lj
	jTYpsUN+wBr2AJdfPzXgh0ZSvl0Q9Mf+l2lT9Wfi8AKJAVCmcDzy+QihCRWDfECwcu51QV/uzqc
	Wwg==
X-Google-Smtp-Source: AGHT+IENu5ZK9kPpRwdS1+EeXpR6nVCXMTR+IXJJExBjfsTrkclg65OJwbQ4mKEvtimncd2M4JDnxOz3MCM=
X-Received: from plks12.prod.google.com ([2002:a17:903:2cc:b0:211:fb3b:763b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e74b:b0:215:5ea2:654b
 with SMTP id d9443c01a7336-21a83f3eebemr334554025ad.1.1736787576636; Mon, 13
 Jan 2025 08:59:36 -0800 (PST)
Date: Mon, 13 Jan 2025 08:59:35 -0800
In-Reply-To: <Z4R12HOD1o8ETYzm@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111012450.1262638-1-seanjc@google.com> <20250111012450.1262638-4-seanjc@google.com>
 <Z4R12HOD1o8ETYzm@intel.com>
Message-ID: <Z4VGdxyswQ6qcKR0@google.com>
Subject: Re: [PATCH 3/5] KVM: Add a common kvm_run flag to communicate an exit
 needs completion
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 13, 2025, Chao Gao wrote:
> On Fri, Jan 10, 2025 at 05:24:48PM -0800, Sean Christopherson wrote:
> >Add a kvm_run flag, KVM_RUN_NEEDS_COMPLETION, to communicate to userspace
> >that KVM_RUN needs to be re-executed prior to save/restore in order to
> >complete the instruction/operation that triggered the userspace exit.
> >
> >KVM's current approach of adding notes in the Documentation is beyond
> >brittle, e.g. there is at least one known case where a KVM developer added
> >a new userspace exit type, and then that same developer forgot to handle
> >completion when adding userspace support.
> 
> This answers one question I had:
> https://lore.kernel.org/kvm/Z1bmUCEdoZ87wIMn@intel.com/
> 
> So, it is the VMM's (i.e., QEMU's) responsibility to re-execute KVM_RUN in this
> case.

Yep.

> Btw, can this flag be used to address the issue [*] with steal time accounting?
> We can set the new flag for each vCPU in the PM notifier and we need to change
> the re-execution to handle steal time accounting (not just IO completion).
> 
> [*]: https://lore.kernel.org/kvm/Z36XJl1OAahVkxhl@google.com/

Uh, hmm.  Partially?  And not without creating new, potentially worse problems.

I like the idea, but (a) there's no guarantee a vCPU would be "in" KVM_RUN at
the time of suspend, and (b) KVM would need to take vcpu->mutex in the PM notifier
in order to avoid clobbering the current completion callback, which is definitely
a net negative (hello, deadlocks).

E.g. if a vCPU task is in userspace processing emulated MMIO at the time of
suspend+resume, KVM's completion callback will be non-zero and must be preserved.
And if a vCPU task is in userspace processing an exit that _doesn't_ require
completion, setting KVM_RUN_NEEDS_COMPLETION would likely be missed by userspace,
e.g. if userspace checks the flag only after regaining control from KVM_RUN.

In general, I think setting KVM_RUN_NEEDS_COMPLETION outside of KVM_RUN would add
too much complexity.

> one nit below,
> 
> >--- a/arch/x86/include/uapi/asm/kvm.h
> >+++ b/arch/x86/include/uapi/asm/kvm.h
> >@@ -104,9 +104,10 @@ struct kvm_ioapic_state {
> > #define KVM_IRQCHIP_IOAPIC       2
> > #define KVM_NR_IRQCHIPS          3
> > 
> >-#define KVM_RUN_X86_SMM		 (1 << 0)
> >-#define KVM_RUN_X86_BUS_LOCK     (1 << 1)
> >-#define KVM_RUN_X86_GUEST_MODE   (1 << 2)
> >+#define KVM_RUN_X86_SMM			(1 << 0)
> >+#define KVM_RUN_X86_BUS_LOCK		(1 << 1)
> >+#define KVM_RUN_X86_GUEST_MODE		(1 << 2)
> >+#define KVM_RUN_X86_NEEDS_COMPLETION	(1 << 2)
> 
> This X86_NEEDS_COMPLETION should be dropped. It is never used.

Gah, thanks!

