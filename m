Return-Path: <kvm+bounces-61443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A98B5C1DE1A
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 01:18:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5F91A4E18B1
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 00:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D15811D5CD1;
	Thu, 30 Oct 2025 00:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U1tQa/lU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5CC5464D
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 00:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761783503; cv=none; b=SrmkszD29Uph96MLZbyGC+L+sazf5fy9KngTAkp1TVxDzWJlaXoKTKKF2D+adpmAF6N1pPqr3GIC7xTduPnZYQlXCLcF4AuX8jND8MvGRBHhv7wzTVV7sMOrc2oM4g8TbL8K8AWSpWUH8pyw4pPyAYxXD1cVP4s23gmn+YbtfWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761783503; c=relaxed/simple;
	bh=JB2LEI4A5f74efQFX9e5urcPJQDPxTpuN3kVdrHIaT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G53nObXuyCOnl7UTMo1WV5kcRGgnIw3gNeXadwRlOGoOSNOyVvTTeCdSoISAwDop2vqqdL94Sl4TKiSA5jyffIeVqPPr9ZLGGnbChuo8hieskGwgh9d662HnfaiuKnVCDz7mvn/SlQ1Dtk9ZcOh+6EO6+8Ih1xlkvsYsTzStS0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U1tQa/lU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340410b11b8so371150a91.2
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 17:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761783501; x=1762388301; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/APfDoAjvMMG72cPIAEX8+eFsFzG2tjZbjY4ARPdXLk=;
        b=U1tQa/lUxRET/55TrDwLmrrNvr9F3S3XMubLthBkpb2ZVAYLBQOCwH42i+swheWPsn
         K+9IM79yaiW1SshvqUOj3Gv7CSszZphZ5rtr3urSrTUZrDuMjhKTrZkIN/KrWKzVXVm2
         BdvJK8q/D0unbnJQu82djqqZmMr8JzIbctJogNwm6Rj8xWfOk/Sfe04XA7/4CLxVcqce
         N3r+DBdQaX4YI/vdjzMwl2q5uSi9ef+SpQAfV6PSga6RXpYutCR32U3g7V5TNzMF0zgY
         i5+FZxJNd0VCzXjMrhwFtwz/9R1QYWeDlqbbb6ZNOGpwOa6wZzVt59lNdqSk074d7FCi
         rRRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761783501; x=1762388301;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/APfDoAjvMMG72cPIAEX8+eFsFzG2tjZbjY4ARPdXLk=;
        b=CV+fdraiN1zfhFqpOZTzAFuZRxNhPnUKEZKD9LnmfHy5eNt93sYQ4R6FM5/AGXJGE8
         WlZXZ+pqcSjibZ0Rb7QOaaDOWLtmDZk4O5lKEgzhVOrcm15BNvqJPINBdSfqzRpufDG9
         ZeBmq/48w93YdVSBGrkAl5Yy0mUDdQukj/WfE5QMBSk3xlo6DWjksi+171MlX1TTz5BV
         8q9/c8rdNDJ+68KNqst0B155qz9DzLMZ7TFYTIFPlBENCNkvMgHFHD1moBHds0AX/KHA
         YrxFrmoxvHg/S7k3/R4N7njoRBo9PGINz6B/NBgF4MIjQs59APJXLsoR9X5I2GQ7HHIM
         ZMVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQRKDJ+2JU5nNcB9s1a8E4/KGPkNhTbGzz6xaN/Qz0zzbc2l+HxZqeRHEciIiTh36Ti6w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxuDTWUoFh2+S8AB2rubEVtLaarsPDPKo0nTcz6s6iefdZXALE
	dTM7iRBVyIh1IEgrNIlHAlAf6YxIQ36rBJvMpg43Y+2w8IYNNFjG2WXFrpBW64jTGmITex97/Cz
	dke1bJA==
X-Google-Smtp-Source: AGHT+IGgocyQQIi5AG23kjZirIFz98FRrrSK1VO35VHRCnkojOzL21/TedfvF0EX8P2/KGVYsS95rTUFxFY=
X-Received: from pjsj7.prod.google.com ([2002:a17:90a:7347:b0:33d:61e3:893])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3912:b0:340:299f:e244
 with SMTP id 98e67ed59e1d1-3404c41b811mr1502709a91.12.1761783500906; Wed, 29
 Oct 2025 17:18:20 -0700 (PDT)
Date: Wed, 29 Oct 2025 17:18:19 -0700
In-Reply-To: <20251029-verw-vm-v1-2-babf9b961519@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com> <20251029-verw-vm-v1-2-babf9b961519@linux.intel.com>
Message-ID: <aQKuy34wmCWvXcMS@google.com>
Subject: Re: [PATCH 2/3] x86/mmio: Rename cpu_buf_vm_clear to cpu_buf_vm_clear_mmio_only
From: Sean Christopherson <seanjc@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Tao Zhang <tao1.zhang@intel.com>, 
	Jim Mattson <jmattson@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 29, 2025, Pawan Gupta wrote:
> cpu_buf_vm_clear static key is only used by the MMIO Stale Data mitigation.
> Rename it to avoid mixing it up with X86_FEATURE_CLEAR_CPU_BUF_VM.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---

...

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f87c216d976d7d344c924aa4cc18fe1bf8f9b731..451be757b3d1b2fec6b2b79157f26dd43bc368b8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -903,7 +903,7 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
>  	if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
>  		flags |= VMX_RUN_SAVE_SPEC_CTRL;
>  
> -	if (static_branch_unlikely(&cpu_buf_vm_clear) &&
> +	if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only) &&
>  	    kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
>  		flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;

The use in vmx_vcpu_enter_exit() needs to be renamed as well.  The code gets
dropped in patch 3, but intermediate builds will fail.

