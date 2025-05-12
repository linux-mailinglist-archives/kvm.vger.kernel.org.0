Return-Path: <kvm+bounces-46254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C287AAB4381
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D5028E050A
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3281296FB0;
	Mon, 12 May 2025 18:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eaEugD1c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F621C8639
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747074215; cv=none; b=m2jgf0ZZqNXIwlTzbDicKbN3b/PgcUpYieJhMnmFIdVPS52a03SAwh8bjBm/VOISdDWUTQq3cnojHg+9x0Gvza3I071F04rGVks8tpbkgcY4pK/s2WXTaMS+G3FupPYWUrTObca+bDa1GeYJiyBIZRBxlLJiXiLh3NIZrC2nvMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747074215; c=relaxed/simple;
	bh=xBGFDbIy9RqjSxPXztoA+FCBn3Xtom0hkV9I1lIirmI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YufvmHH/FfUFrnNrg/b73OYxY9RzrcdpXRvLUQY7SYBrdfZtfNYW+w91X8HJfOswGEGYpNrmYHlUQ9hMGAtoO9/Ec3LVS/igpZWbXvmTSko26z87HrhVrUN0YFRKnqd6MWO9k7oVIqBXROKWbksSbL15XP8X/nQytmO5yQVCzos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eaEugD1c; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b240fdc9c20so3422793a12.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747074214; x=1747679014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DhXF/CHBNXDZ8TD5O0grJafmQnUhM9pMjEfCT/Aj0J8=;
        b=eaEugD1cGC3XwMnAgt3W0XRWMod540mPcMzwc6c4Cv9honKtDPHxA0taUFXZJr4SEv
         WCr2gjc0toFjTqpzQMGUj7Vkk6R4UCyHT9gFxmYhKOLqbQj2mLBJsnRkYK+J0io6okxY
         6UTS5pghVjnsahuRO4nfncBV/PdG+03cYXZ0AhS+Xo749w3mncBjXONAffOP5UH3PbAI
         oRNhYYqoJgUGAxWsGFw5mTCoODcltsGVICLn4XBgY5Zb/MPK+SHMHOCrZHNLqza4bf86
         /dq0AduKOLYnOPnJhhwHEvdPdazG+1Kuqqn3N3hqZtMbCwiLkCaNbDdaa2qTDo3NFiWN
         0/EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747074214; x=1747679014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DhXF/CHBNXDZ8TD5O0grJafmQnUhM9pMjEfCT/Aj0J8=;
        b=Dg0RoQcOQ28hiDxhFqU/PrtJPKQdO9UJ5op1blT0VhQ02zoumUYYTUNTF2HP2ZXmkx
         vKdUid6k2KGm/ffGl7cQsZK0/6ctva6dk94MRNWoart6Kb710pGcTTptS/fSq4zV7dzM
         HYAu9fxdg+L5rYo2bYGvHCuuggNIhqLqUbnqCjEM1eA/GgAvNEEOXuQZSJoY6hGIqhcd
         0piJmPYuc1diUyVl5TjfTjbGEMywmkK1PIIpP+8D1xTAtXPMkp85tFkIS1oAFBgaFkD6
         ocJE/e6LQG6FQdlguFrl3046ZWHmrBbfilwqk16JFwTGkTUBxVTD4tBh+QPOibiFY9jv
         PoSA==
X-Forwarded-Encrypted: i=1; AJvYcCVDjq26pokMBK4OFjOlTkOvtidkXfG0AOxyX4BYgFaHLZKjmQ7btArDiFdB7+x4xBFyYqE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye+Zuqi57ueQAA81y5yyKmDalyZZDObjTu+R/jtMuLF99yh/fM
	+MHuvPduPjZMY0RTztz/PygIlfdzsZq2BXDcEwTyZ9SEzoQrbTmGfH6kU2j5vV/MpWyZPYQSVj3
	IMQ==
X-Google-Smtp-Source: AGHT+IFxuWdlhqICz+7tB+ZoaL8tfHry8cvS0vmOzMxg7tsh6qE+qvmYcSnCxleO5Xjbzty+biW82xsevWs=
X-Received: from pjbse15.prod.google.com ([2002:a17:90b:518f:b0:308:64af:7bb9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d2c5:b0:30c:523e:89e7
 with SMTP id 98e67ed59e1d1-30c523e8d29mr15208716a91.16.1747074213775; Mon, 12
 May 2025 11:23:33 -0700 (PDT)
Date: Mon, 12 May 2025 11:23:32 -0700
In-Reply-To: <20250313203702.575156-7-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-7-jon@nutanix.com>
Message-ID: <aCI8pGJbn3l99kq8@google.com>
Subject: Re: [RFC PATCH 06/18] KVM: VMX: Wire up Intel MBEC enable/disable logic
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 13, 2025, Jon Kohler wrote:
> Add logic to enable / disable Intel Mode Based Execution Control (MBEC)
> based on specific conditions.
> 
> MBEC depends on:
> - User space exposing secondary execution control bit 22
> - Extended Page Tables (EPT)
> - The KVM module parameter `enable_pt_guest_exec_control`
> 
> If any of these conditions are not met, MBEC will be disabled
> accordingly.

Why?  I know why, but I know why despite the changeloge, not because of the
changelog.

> Store runtime enablement within `kvm_vcpu_arch.pt_guest_exec_control`.

Again, why?  If you actually tried to explain this, I think/hope you would realize
why it's wrong.

> Signed-off-by: Jon Kohler <jon@nutanix.com>
> 
> ---
>  arch/x86/kvm/vmx/vmx.c | 11 +++++++++++
>  arch/x86/kvm/vmx/vmx.h |  7 +++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7a98f03ef146..116910159a3f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2694,6 +2694,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  			return -EIO;
>  
>  		vmx_cap->ept = 0;
> +		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
>  		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
>  	}
>  	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_VPID) &&
> @@ -4641,11 +4642,15 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>  		exec_control &= ~SECONDARY_EXEC_ENABLE_VPID;
>  	if (!enable_ept) {
>  		exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
> +		exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
>  		exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
>  		enable_unrestricted_guest = 0;
>  	}
>  	if (!enable_unrestricted_guest)
>  		exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
> +	if (!enable_pt_guest_exec_control)
> +		exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;

This is wrong and unnecessary.  As mentioned early, the input that matters is
vmcs12.  This flag should *never* be set for vmcs01.

>  	if (kvm_pause_in_guest(vmx->vcpu.kvm))
>  		exec_control &= ~SECONDARY_EXEC_PAUSE_LOOP_EXITING;
>  	if (!kvm_vcpu_apicv_active(vcpu))
> @@ -4770,6 +4775,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  		if (vmx->ve_info)
>  			vmcs_write64(VE_INFORMATION_ADDRESS,
>  				     __pa(vmx->ve_info));
> +
> +		vmx->vcpu.arch.pt_guest_exec_control =
> +			enable_pt_guest_exec_control && vmx_has_mbec(vmx);

This should effectively be dead code, because vmx_has_mbec() should never be
true at vCPU creation.

