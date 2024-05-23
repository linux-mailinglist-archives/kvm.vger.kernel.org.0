Return-Path: <kvm+bounces-18044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 813DB8CD257
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 14:36:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0251E1F22D06
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 12:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04ACE1487F5;
	Thu, 23 May 2024 12:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zweQfHxG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235EA14532F;
	Thu, 23 May 2024 12:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716467809; cv=none; b=KnWYE2sVN4/G9FGiiNfIFtzcDyVjnfvIhd7ham2FgiAt2FizD6uSugIg6JOomL2vSJRij6H7vtg9XJMQlzLzZYYiwnLvhg+INaEHbvy/kl1heRvVuHWiKNhwn31S8ULiSH89zz5/YEUndgs3REhPKRCI7x9N34k6T/a0PSVxoV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716467809; c=relaxed/simple;
	bh=zx5wVeCKb3Bhjyf1r6rlKAj945Wu95U1u9RY3R+rMhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lBn7RbCzgf1fLKAbjoC9dVfk0A2u3wsGk2Hg3BtnoL9nRBEp/uwayYo6bIR7Gue3uE/E/v4gy54TPDMW3sGyeYxJoiB6es2HVoblBuyQ/EAMykdhqEGpgXOQ9V0nRjfxvG8mlg1eYirKL5X41v8z6lYK9XMfbO9/wsnMUozg6c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zweQfHxG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0EEC3277B;
	Thu, 23 May 2024 12:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716467808;
	bh=zx5wVeCKb3Bhjyf1r6rlKAj945Wu95U1u9RY3R+rMhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zweQfHxGyIEx+N7wW8KuT+AFwhxLaC8zdGtdJG+1vJ0RfoluWcYZCHdd+IluyE2g3
	 ZeHwSdSKBOaLHsP9YmI3u6estAcifqGrYaFNvnLF9TGinG2qGsPwWrqpsyOxAeXoaV
	 jvOXNrAu2RvX1OVkO8n3/KY88Kux7J+2pzZi2fEg=
Date: Thu, 23 May 2024 14:36:45 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
	tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
	seanjc@google.com, andrew.cooper3@citrix.com,
	dave.hansen@linux.intel.com, nik.borisov@suse.com,
	kpsingh@kernel.org, longman@redhat.com, bp@alien8.de,
	pbonzini@redhat.com
Subject: Re: [PATCH] x86/bhi: BHI mitigation can trigger warning in #DB
 handler
Message-ID: <2024052336-mandarin-spiritism-51d2@gregkh>
References: <20240523123322.3326690-1-alexandre.chartre@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523123322.3326690-1-alexandre.chartre@oracle.com>

On Thu, May 23, 2024 at 02:33:22PM +0200, Alexandre Chartre wrote:
> When BHI mitigation is enabled, if sysenter is invoked with the TF flag
> set then entry_SYSENTER_compat uses CLEAR_BRANCH_HISTORY and calls the
> clear_bhb_loop() before the TF flag is cleared. This causes the #DB
> handler (exc_debug_kernel) to issue a warning because single-step is
> used outside the entry_SYSENTER_compat function.
> 
> To address this issue, entry_SYSENTER_compat() should use
> CLEAR_BRANCH_HISTORY after making sure flag the TF flag is cleared.
> 
> The problem can be reproduced with the following sequence:
> 
>  $ cat sysenter_step.c
>  int main()
>  { asm("pushf; pop %ax; bts $8,%ax; push %ax; popf; sysenter"); }
> 
>  $ gcc -o sysenter_step sysenter_step.c
> 
>  $ ./sysenter_step
>  Segmentation fault (core dumped)
> 
> The program is expected to crash, and the #DB handler will issue a warning.
> 
> Kernel log:
> 
>   WARNING: CPU: 27 PID: 7000 at arch/x86/kernel/traps.c:1009 exc_debug_kernel+0xd2/0x160
>   ...
>   RIP: 0010:exc_debug_kernel+0xd2/0x160
>   ...
>   Call Trace:
>   <#DB>
>    ? show_regs+0x68/0x80
>    ? __warn+0x8c/0x140
>    ? exc_debug_kernel+0xd2/0x160
>    ? report_bug+0x175/0x1a0
>    ? handle_bug+0x44/0x90
>    ? exc_invalid_op+0x1c/0x70
>    ? asm_exc_invalid_op+0x1f/0x30
>    ? exc_debug_kernel+0xd2/0x160
>    exc_debug+0x43/0x50
>    asm_exc_debug+0x1e/0x40
>   RIP: 0010:clear_bhb_loop+0x0/0xb0
>   ...
>   </#DB>
>   <TASK>
>    ? entry_SYSENTER_compat_after_hwframe+0x6e/0x8d
>   </TASK>
> 
> Fixes: 7390db8aea0d ("x86/bhi: Add support for clearing branch history at syscall entry")
> Reported-by: Suman Maity <suman.m.maity@oracle.com>
> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> ---
>  arch/x86/entry/entry_64_compat.S | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
> index 11c9b8efdc4c..7fa04edc87e9 100644
> --- a/arch/x86/entry/entry_64_compat.S
> +++ b/arch/x86/entry/entry_64_compat.S
> @@ -91,7 +91,6 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
>  
>  	IBRS_ENTER
>  	UNTRAIN_RET
> -	CLEAR_BRANCH_HISTORY
>  
>  	/*
>  	 * SYSENTER doesn't filter flags, so we need to clear NT and AC
> @@ -116,6 +115,12 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
>  	jnz	.Lsysenter_fix_flags
>  .Lsysenter_flags_fixed:
>  
> +	/*
> +	 * CLEAR_BRANCH_HISTORY can call other functions. It should be invoked
> +	 * after making sure TF is cleared because single-step is ignored only
> +	 * for instructions inside the entry_SYSENTER_compat function.
> +	 */
> +	CLEAR_BRANCH_HISTORY
>  	movq	%rsp, %rdi
>  	call	do_SYSENTER_32
>  	jmp	sysret32_from_system_call
> -- 
> 2.39.3
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- You have marked a patch with a "Fixes:" tag for a commit that is in an
  older released kernel, yet you do not have a cc: stable line in the
  signed-off-by area at all, which means that the patch will not be
  applied to any older kernel releases.  To properly fix this, please
  follow the documented rules in the
  Documentation/process/stable-kernel-rules.rst file for how to resolve
  this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot

