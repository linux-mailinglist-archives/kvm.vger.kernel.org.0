Return-Path: <kvm+bounces-43471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB81A9060E
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 16:20:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AEB3189AD57
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 14:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B371C68A6;
	Wed, 16 Apr 2025 14:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IxBEcPwk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5662F1A9B53
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 14:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744812737; cv=none; b=HsKxvjSbCHd2asvR0nQFtt5YIMmbSF6vBTBTJMecCs+r0Dhh+r6tT0YeznyEkuGhImQXYq3tzZ7ScscSMNWirtXPYRK8uKiR2la6LgCTP2cTSOMHeRFILsD2Y+oECCY0z1ngpJwyd6IjLYW2RbyLslGFVEP5Fpm0qzRDdgApZ7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744812737; c=relaxed/simple;
	bh=bw5C9w+o12ud9Z1FyQpOsnySKaLgEqUjtoLD2BcALF8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jPXSy/Gvo/3ELo/s8mxovGnDjg46oKBIDW0daosE9XDxUdPMWOeaqpFquLuLjh7Z+CKboSjamtUOkyCRI+Zmh21GbI8AlfrTU1SQhHEw1s7qPCixd+YD814sKQDSYDR5zMXG3icmKFFPK7ZpPyHXjYw1nuTa4BMQoD4In1EcmG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IxBEcPwk; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736d64c5e16so5630491b3a.3
        for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 07:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744812735; x=1745417535; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zroUK9dDtvKLEdKAjHVasPmRx4K7+EiONh5VwvTGM/I=;
        b=IxBEcPwkHkKpyiNr/yUDaFTZ8y12bv/aLEFdSDPBC3RUpuly//O85cO9tXF7ID1RSG
         Sqfobs7ZRM8d5mBoUIHRBI1WkCM9mkOTKnAMW9SN081GW1L36KenRMGevx4GCPzlKEGa
         xbysfs6AicTEDesyPnoSBWowYj8jhhxujzAvqwkEjtsNbHTHd8IAraUkSRLOrDCnZFLL
         6jTZIJy30C9c1mdo/4oG9OxmyWIZOI8AimfdCsbFSHFgCxlUVr4Z7zHJB8IDuf16cVy1
         8SgCip6DHILrpIfnPxTwVoy+vBZOXRWuRmS8WT+Ha6exZB83QBxquXTT8bxQrvSQ974o
         y0eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744812735; x=1745417535;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zroUK9dDtvKLEdKAjHVasPmRx4K7+EiONh5VwvTGM/I=;
        b=L+z2N9oj/3jK5FLYDAHmiZebI95I9f81RhOpEdP5CazIFnPaShh1Ox60Vv9gCNlbwc
         oqsbXJmWGbL/nMjAu4oxY1ARceDPIkMsHYr+J5bkuHsorCDegdp9TUjT4eI+bnWuMbEO
         MgqqnlFnPmlxtP/Y5URBqKqGJQ6Kuv/WJ0B3aCyBcM72kFWYd1PS5bHwJy31EQiSkBnv
         e9jCKToMn2HLrHLEjj0FpSraYb3efKpA2C7TL+B3m/ZVQ1iaLw+MKEGhg+HX74EddbVe
         vSr5oBr75K0eS54R+ykFODS+tYsgU4LkWUa2bCCo2HgpizdPt+rxUbcPOuBuLFiZN11y
         WUJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBpKpnp8poJeFTGe+w7sxy2Ij0KQU6E5Wee5zrWBfD9Bo7m94AstF4rxm8bVG0DsdxriI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIqBMh3rLaWQeRwCJgys5vVrBg8eKEst0zd4ZfpXPwS9UkyfzR
	PpOCm2zR4WmhBaew7py2xGDm3R85yz4XQozHSkFkrkoNvBmUrHz94EqFCdRLHbxPYxIjyZnRfiV
	RmA==
X-Google-Smtp-Source: AGHT+IH9Q6+GYbLyECzLvcQBfJGMT7QIrja6tcXgWSs3Od7EVVgfyRXmRHcsRraYJIkvI7aqC5mPF+nkKcI=
X-Received: from pfbhw8.prod.google.com ([2002:a05:6a00:8908:b0:736:3a40:5df5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d50d:b0:1f5:8d8f:27aa
 with SMTP id adf61e73a8af0-203b3e4fe8dmr3241108637.8.1744812735351; Wed, 16
 Apr 2025 07:12:15 -0700 (PDT)
Date: Wed, 16 Apr 2025 07:12:13 -0700
In-Reply-To: <20250416134326.1342-1-chenyufeng@iie.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250416134326.1342-1-chenyufeng@iie.ac.cn>
Message-ID: <Z_-6veJq79R-H0EH@google.com>
Subject: Re: [PATCH] kvm: x86: Don't report guest userspace emulation error to
 userspace in kvm_task_switch()
From: Sean Christopherson <seanjc@google.com>
To: Chen Yufeng <chenyufeng@iie.ac.cn>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 16, 2025, Chen Yufeng wrote:
> This patch prevents that emulation failures which result from emulating
> task switch for an L2-Guest results in being reported to userspace.
> 
> Without this patch a malicious L2-Guest would be able to kill the L1 by 
> triggering a race-condition between an vmexit and the task switch emulator.

Only if L1 doesn't intercept task switches, which is only possible on SVM (they
are a mandatory intercept on VMX).  If L1 is deferring task switch emulation to
L0, then IMO L0 is well within its rights to exit to userspace if KVM can't
emulate the task switch.

So unless I'm missing something, I vote to keep the code as-is.

> This patch is smiliar to commit fc3a9157d314 ("KVM: X86: Don't report L2 
> emulation failures to user-space")

Generic emulation is different.  There are legitimate scenarios where KVM needs
to emulate L2 instructions, without L1's explicit consent, and so KVM needs to
guard against L2 playing games with its code stream.

Task switches are very different.  KVM doesn't fetch from the code stream, i.e.
L2 can't play TLB games, and I highly doubt there is a real world hypervisor
that doesn't intercept task switches.

> Fixes: 1051778f6e1e ("KVM: x86: Handle emulation failure directly in kvm_task_switch()")
> 
> Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
> ---
>  arch/x86/kvm/x86.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3712dde0bf9d..b22be88196ed 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11874,9 +11874,11 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>  	 */
>  	if (ret || vcpu->mmio_needed) {
>  		vcpu->mmio_needed = false;
> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -		vcpu->run->internal.ndata = 0;
> +		if (!is_guest_mode(vcpu)) {
> +			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +			vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> +			vcpu->run->internal.ndata = 0;
> +		}
>  		return 0;
>  	}
>  
> -- 
> 2.34.1
> 

