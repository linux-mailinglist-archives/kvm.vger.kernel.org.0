Return-Path: <kvm+bounces-61682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DC076C25077
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 13:35:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0DB204F70CA
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 12:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92A7348875;
	Fri, 31 Oct 2025 12:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="axXGAO3A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7896933E369
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 12:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761913961; cv=none; b=j7ydkOW4qJJKKknZgdgR7VV7yetgKkmbASVni3LzwTw9IXg3hwIbHIvu+cEazsO5GHZ8g2ARypuZx55Q38Ua7qDeT2fq5xtaBzhsRL/ATWlOodNiG84Km1VSJgxZoei3PJYI6SxQTwUxv9gEeVKDar+DTW97lw9/QPdYSvPhHS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761913961; c=relaxed/simple;
	bh=vQeFGtlqhgywDgznB4JAZCMBFOIaYYLeyFyIC1DM7BQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jugz3im9eLEBek/aAez0vEtifci8CyD6FSQwUVmXzzgiCxknUFksa8oahA7bcKu9p1RL3VyXo0ZpKL+VYdYTC6O3NXo2sBeP7fyUGAhPuQK2++79rlgTRlvEJw47f1jAgOg7h+879uaoD7HeOJY4Nguyi1xT7g0Y2bErIndlc30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=axXGAO3A; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e47d14dceso12412295e9.2
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 05:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761913955; x=1762518755; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=db7P2jbk3Fkbtr7b2QsaX30FZiDLD2HY6aLapQ5nQME=;
        b=axXGAO3A8C3qfhBxwVnxEF+WA8nrXEJdTMG02bhXT6LRkfGpo/qatULYrTvE9H4Tk+
         f1IO/zGRIZJoQrERXvxxADlSOxkrvERkUXjJq+ymbNT4wQMS8htDWpGHVCg3dZfwnEYt
         5mwQuEodDIvTzKMPN5u2MntWJTk8jTqnay1uE5cAmhvqroU/NIP7npc6NxFuX8o7bEib
         Dl/uc3CmpaROVHOfO3Rnx3oytEKH4/bTr3PuvyviTQLdr9AFKnhM1LIiO5c7oZC0jy6y
         Yml2UBokxTsdFVb2UFySLRhtquDd+MRG0wg9RqPro2sOti1Tv2+NiEnLVoHCMBwCWi71
         8ERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761913955; x=1762518755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=db7P2jbk3Fkbtr7b2QsaX30FZiDLD2HY6aLapQ5nQME=;
        b=Z8LozORIp3NwT+fuePDhgbW2YujU1IUWW+UVR+5WRnTUjrkLP9R/XXjc59gbIwvFFS
         PnOPdxkodZy8mpDwJgCKSSJLBfqraN3f/+smzOTGg+jYzBA46vhRFiyDAr3iWiBopLtP
         2zJr73LveF01XMbRz6OKro4s0zigj3vCna0ydv3jfrxcmkwgEk8gjzuceH7mmK/jywVV
         SxbgtzAAgIsw4g4BBEwyNFhO0Bn3JH3JLWGS6VM9rS/9llin9o5SPsH5M6qR8cfw7w5o
         eI5n8JF5DflkVe9XH8Yw9WDSpi/MlasY8yHKb0FneRXT4ehTr46uhnsKLZJHFK+DbWmk
         CpKw==
X-Gm-Message-State: AOJu0YxefQlObZoPG5IpUNKZrqjKdMyoy1dFSMDYBY84Tce+8aaXNJNE
	kIsHGq1plRcoZa8vJltyr5AcAWCl7Tzi5HHz62WtdeGM3UPcwmt/ARy3/uXfDtHlca+RS9xWxY+
	ZwAy6dK8QK7s/4A==
X-Google-Smtp-Source: AGHT+IGbPo3kHovVtooeq2/6Etwo2zwlUdziBFwBs5h8QYkknPArFiPwXzGXMXRW4yEOziWKwAnTJda1x3rWAQ==
X-Received: from wmcn22.prod.google.com ([2002:a05:600c:c0d6:b0:46e:1f26:9212])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:4393:b0:475:f16b:bcbf with SMTP id 5b1f17b1804b1-477331dbef2mr14011285e9.14.1761913955394;
 Fri, 31 Oct 2025 05:32:35 -0700 (PDT)
Date: Fri, 31 Oct 2025 12:32:34 +0000
In-Reply-To: <20251031003040.3491385-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-5-seanjc@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDWIDCO0UKMD.2C46H6XQO1NXK@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
From: Brendan Jackman <jackmanb@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri Oct 31, 2025 at 12:30 AM UTC, Sean Christopherson wrote:
> Rework the handling of the MMIO Stale Data mitigation to clear CPU buffers
> immediately prior to VM-Enter, i.e. in the same location that KVM emits a
> VERW for unconditional (at runtime) clearing.  Co-locating the code and
> using a single ALTERNATIVES_2 makes it more obvious how VMX mitigates the
> various vulnerabilities.
>
> Deliberately order the alternatives as:
>
>  0. Do nothing
>  1. Clear if vCPU can access MMIO
>  2. Clear always
>
> since the last alternative wins in ALTERNATIVES_2(), i.e. so that KVM will
> honor the strictest mitigation (always clear CPU buffers) if multiple
> mitigations are selected.  E.g. even if the kernel chooses to mitigate
> MMIO Stale Data via X86_FEATURE_CLEAR_CPU_BUF_MMIO, some other mitigation
> may enable X86_FEATURE_CLEAR_CPU_BUF_VM, and that other thing needs to win.
>
> Note, decoupling the MMIO mitigation from the L1TF mitigation also fixes
> a mostly-benign flaw where KVM wouldn't do any clearing/flushing if the
> L1TF mitigation is configured to conditionally flush the L1D, and the MMIO
> mitigation but not any other "clear CPU buffers" mitigation is enabled.
> For that specific scenario, KVM would skip clearing CPU buffers for the
> MMIO mitigation even though the kernel requested a clear on every VM-Enter.
>
> Note #2, the flaw goes back to the introduction of the MDS mitigation.  The
> MDS mitigation was inadvertently fixed by commit 43fb862de8f6 ("KVM/VMX:
> Move VERW closer to VMentry for MDS mitigation"), but previous kernels
> that flush CPU buffers in vmx_vcpu_enter_exit() are affected (though it's
> unlikely the flaw is meaningfully exploitable even older kernels).
>
> Fixes: 650b68a0622f ("x86/kvm/vmx: Add MDS protection when L1D Flush is not active")
> Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmenter.S | 14 +++++++++++++-
>  arch/x86/kvm/vmx/vmx.c     | 13 -------------
>  2 files changed, 13 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 1f99a98a16a2..61a809790a58 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -71,6 +71,7 @@
>   * @regs:	unsigned long * (to guest registers)
>   * @flags:	VMX_RUN_VMRESUME:	use VMRESUME instead of VMLAUNCH
>   *		VMX_RUN_SAVE_SPEC_CTRL: save guest SPEC_CTRL into vmx->spec_ctrl
> + *		VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO: vCPU can access host MMIO
>   *
>   * Returns:
>   *	0 on VM-Exit, 1 on VM-Fail
> @@ -137,6 +138,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	/* Load @regs to RAX. */
>  	mov (%_ASM_SP), %_ASM_AX
>  
> +	/* Stash "clear for MMIO" in EFLAGS.ZF (used below). */
> +	ALTERNATIVE_2 "",								\
> +		      __stringify(test $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, %ebx), 	\
> +		      X86_FEATURE_CLEAR_CPU_BUF_MMIO,					\
> +		      "", X86_FEATURE_CLEAR_CPU_BUF_VM

Ah, so this ALTERNATIVE_2 (instead of just an ALTERNATIVE that checks
CLEAR_CPU_BUF_MMIO) is really about avoiding the flags needing to be
mutually exclusive? I.e. this is 

if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_MMIO) && 
    !cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_VM))
	test $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, %ebx

... right? This is a good idea but I think it warrants a comment to
capture the intent, without having the commit message in short-term
memory I'd have struggled with this code, I think.

>  	/* Check if vmlaunch or vmresume is needed */
>  	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
>  
> @@ -161,7 +168,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
>  
>  	/* Clobbers EFLAGS.ZF */
> -	VM_CLEAR_CPU_BUFFERS
> +	ALTERNATIVE_2 "",							\
> +		      __stringify(jz .Lskip_clear_cpu_buffers;			\

Maybe I'm just an asm noob (I was very impressed by this trick of
using CF and ZF together like this!) but I think it's helpful to
have the comment like the jnc has below, and Pawan had in his version,
to really make the test->jz dependency obvious, since the two
instructions are quite far apart.


> +				  CLEAR_CPU_BUFFERS_SEQ;			\
> +				  .Lskip_clear_cpu_buffers:),			\
> +		      X86_FEATURE_CLEAR_CPU_BUF_MMIO,				\
> +		      __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM

Sorry I'm really nitpicking but I think it's justified for asm
readability...

It's a bit unfortunate that one branch says
CLEAR_CPU_BUFFERS_SEQ and the other says __CLEAR_CPU_BUFFERS. With the
current code I think it would be more readable to jut have
__stringify(CLEAR_CPU_BUFFERS_SEQ) in the CLEAR_CPU_BUF_VM case, then
you don't have to mentally expand the macro to see how the two branches
actually differ.

Anyway the actual idea here LGTM, thanks.

