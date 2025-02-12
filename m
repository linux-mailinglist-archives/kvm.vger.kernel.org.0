Return-Path: <kvm+bounces-37992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 902EEA332E1
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 23:51:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A2D97A2D20
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 22:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B388D21129D;
	Wed, 12 Feb 2025 22:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wFEp7xgl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39241EF08E
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 22:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739400653; cv=none; b=XT0p20PUkjetnP8ZV0NTeK3LMbvNqviIOiusLNyzE390jFd5UlU0ZaAp5k4pee80Qb0DJxhbx7Seawqpdrkz8+uCtw7EjEKf+bf7BLLc6z7dzyR4nX521+UulR7e1sGLYXGOKzVBb/T3tUsilmXXpmeTjZKCdRh7gKgji6a23D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739400653; c=relaxed/simple;
	bh=uXm8uKmNjS20RmDk1SMqOD3I2J1mL4UkI1TzOjxtnkQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u9CKoO4Q3qsCqpHrcqtXpHI0Agm+Dfw/8AredMv5zhjfVBJkALFdnvTKXpP/V940EbE4nesZ9x4vFEz1cwdkcTlg+FfYaqpLHL3IHAHm700ElYHjQO14fE2TgC49A8CIz9VergWyqjOvzcJ+mvJMhOTy3IusW4UmfTZFYJow3K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wFEp7xgl; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa1c093f12so781633a91.2
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 14:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739400651; x=1740005451; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A7M7mwSZmFgIdf/jVcNpFyiHweXH73hNuBjTuWyoztw=;
        b=wFEp7xgl0OVABYmzcnuN8JJWBU3n5vtSnjKDC5uRcaAlFC0StvVfPmaz81AgoAecA3
         FQJ+WPi/Lk1q8pH++x8EQE2Td6E1Ug+453TTfL+cPFWHeAWeK6Qtyu5axET6rIiK9yPe
         nmuGKLflrjoam6oEmYTVTaa3U2lPytuZxim+34czdxVr4PohG7eZPgGUC8ZkBS8Thv5p
         /+iX6HmL663OXP1G2CuaFQRSv1/Ib1ADz70dXkhbssmnTjqvmg47ap4buTd8UHBMVZGQ
         Ww4A5b/E8o2KD36r7bKZ7QGGnvuR+rI/77m/cKBNdVo/RKXTSpAJiNqJLJkU0qluyvJV
         CEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739400651; x=1740005451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A7M7mwSZmFgIdf/jVcNpFyiHweXH73hNuBjTuWyoztw=;
        b=tvpSRTa9ptDyRan1lCBzyVASYhUIGzYDzsQGvpQRSOY0wK1iHrkqQGHnR+cB+809O/
         aYdOzpNEbab2NxH5aLZg7BYs7db9tF27ET1jkQ0sTOFx4F9AdLQzCxQyZy4BAaML+v8Y
         dQS92aE+ovwZmp53N/YntON9gjjDk25oJf/Ed9Z8ULjJXK4U1oZyqd8f1JmUUuuvT3Xr
         3CINg25ynDMhgTaMyTIOJMrjxi1SQq5Brxu7x8anOzVHhBIsK1BIvG3CpbE8IAHQlN8Q
         s4WMDUtI5wHEDbWh7mlhlbHjDZafqu7Xd/ucS1wjuTt4i+cSSfkdV2IbPXj4rEiTizat
         wTkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBWI1heyRWPRR1dZ29sRGtRpYFvaS3oYmO95TCQCp+SlCApYPhQt9UV+NEqk9Yc2/ErTo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuxurfZ6tYY701cMYfZjTjRg6fHZ0K44U/zQbbd7Lz+7p8o+Al
	XSQWBv0bnBDuHPiydsrB2uGoGgCJJrWrEKAtMEZyummm3XqWCaCHoHQM0uupYSIkB6kDlu9zYzv
	frA==
X-Google-Smtp-Source: AGHT+IFVTTUUI1xszagrzillVwGnjrtr+PRt659s6KUyzEgsoiBKTxdBzhJcBaI8v4c/MK/Id5lMncRdTWE=
X-Received: from pfblj12.prod.google.com ([2002:a05:6a00:71cc:b0:730:78e8:8e52])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2341:b0:730:97a6:f04
 with SMTP id d2e1a72fcca58-7322c38479emr6679600b3a.7.1739400651124; Wed, 12
 Feb 2025 14:50:51 -0800 (PST)
Date: Wed, 12 Feb 2025 14:50:45 -0800
In-Reply-To: <20250212221217.161222-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <67689c62.050a0220.2f3838.000d.GAE@google.com> <20250212221217.161222-1-jthoughton@google.com>
Message-ID: <Z60lxSqV1r257yW8@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in vmx_handle_exit (2)
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: syzbot+ac0bc3a70282b4d586cc@syzkaller.appspotmail.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 12, 2025, James Houghton wrote:
> Here's what I think is going on (with the C repro anyway):
> 
> 1. KVM_RUN a nested VM, and eventually we end up with
>    nested_run_pending=1.
> 2. Exit KVM_RUN with EINTR (or any reason really, but I see EINTR in
>    repro attempts).
> 3. KVM_SET_REGS to set rflags to 0x1ac585, which has X86_EFLAGS_VM,
>    flipping it and setting vmx->emulation_required = true.
> 3. KVM_RUN again. vmx->emulation_required will stop KVM from clearing
>    nested_run_pending, and then we hit the
>    KVM_BUG_ON(nested_run_pending) in __vmx_handle_exit().
> 
> So I guess the KVM_BUG_ON() is a little bit too conservative, but this
> is nonsensical VMM behavior. So I'm not really sure what the best
> solution is. Sean, any thoughts?

Heh, deja vu.  This is essentially the same thing that was fixed by commit
fc4fad79fc3d ("KVM: VMX: Reject KVM_RUN if emulation is required with pending
exception"), just with a different WARN.

This should fix it.  Checking nested_run_pending in handle_invalid_guest_state()
is overkill, but it can't possibly do any harm, and the weirdness can be addressed
with a comment.

---
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f72835e85b6d..8c9428244cc6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5869,11 +5869,17 @@ static int handle_nmi_window(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static bool vmx_emulation_required_with_pending_exception(struct kvm_vcpu *vcpu)
+static bool vmx_unhandleable_emulation_required(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	return vmx->emulation_required && !vmx->rmode.vm86_active &&
+	if (!vmx->emulation_required)
+		return false;
+
+	if (vmx->nested.nested_run_pending)
+		return true;
+
+	return !vmx->rmode.vm86_active &&
 	       (kvm_is_exception_pending(vcpu) || vcpu->arch.exception.injected);
 }
 
@@ -5896,7 +5902,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		if (!kvm_emulate_instruction(vcpu, 0))
 			return 0;
 
-		if (vmx_emulation_required_with_pending_exception(vcpu)) {
+		if (vmx_unhandleable_emulation_required(vcpu)) {
 			kvm_prepare_emulation_failure_exit(vcpu);
 			return 0;
 		}
@@ -5920,7 +5926,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 
 int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu)
 {
-	if (vmx_emulation_required_with_pending_exception(vcpu)) {
+	if (vmx_unhandleable_emulation_required(vcpu)) {
 		kvm_prepare_emulation_failure_exit(vcpu);
 		return 0;
 	}

base-commit: b1da62b213ed5f01d7ead4d14e9d51b48b6256e4
-- 

