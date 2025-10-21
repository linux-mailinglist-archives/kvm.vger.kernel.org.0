Return-Path: <kvm+bounces-60666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FFACBF6D18
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 15:38:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 30D3E4FF0DB
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 13:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B9C33893B;
	Tue, 21 Oct 2025 13:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mdCpJs3L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3BB3370FB
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 13:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761053685; cv=none; b=O1vTaD/1HYZoShG+HF+oqXgnXv95zaMHBClBMqRJRxLJlTtiCaLXuEqItA/SrH/mAiFDIY7uNuuvgcEirlFUdejDkqLiZN8x7i7H1Q4EBluEnjlYTpqmJM+AySJpb6hHWyFZNkLpG178+Z05EfvY9fTiiYlDShUC3ElRKbqyrkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761053685; c=relaxed/simple;
	bh=JD9tnLvhb0BCLBhU3oDZt9t/3nIJ0uQg415gEcHPfTw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tVRnvk+9kG0JvoUT7F1ccjB4BClekBsGIZfzON3b1GQ7hLhpJyF8YSN8C5ggp+QDbJz37BQ0Lr+y56iIgmuB0Cw3+3nsOW1rjA5CuQRLEYjW991I8rV6fIQ9hufXpZj7xCKsqkbP0GqTibNFXOPSkzyCAqROeQRhSiaizh+abdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mdCpJs3L; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-427a125c925so2502623f8f.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 06:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761053680; x=1761658480; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UzfH8PMUJmAJUfqV7EQWQQrNJP7atdrSjM6p96pL1d0=;
        b=mdCpJs3L8Lrl52acqFzLTPiYmp/MSQg3SmkpM/wvs5er2i6BWn0YhLdm98ABdwPgXC
         4ZG3hZm4xo+LT6nR+T8D/HP6slo7SlU78bvhfDqHN+V55jQnerCQirFzEuTRbMOqKaKd
         d56+/yd713kGbzhDOkXiXP+yI1tFF3gpqo0KPGoIGM24ZCZkPetAWO/P2RNf8e1xtFT+
         ZgKS2m60c524vxvDshO3exyuKV1r2369ReExO/wlRvcvGPpMTsMHJsC/E2h8tEG2CLzY
         Vo+PGRWK3B7mZLXwDLseD+yYcBVGu7OjTIQewZ0Gi8ztK09ZtUXnJrFv4xm2yrGn8fAt
         zTXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761053680; x=1761658480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UzfH8PMUJmAJUfqV7EQWQQrNJP7atdrSjM6p96pL1d0=;
        b=sxQBQ3N9rTvGjLrECfr5Y/cJshl548clI0rNXTacTz98SwS8QaAbbt3pn7kGJsrbED
         9qqZlebTqkd2w54BOTKj/hajXJ5WIKNG9AUfkwDwSJXKg5H/hVhmaOB4mc8FsrAvemps
         vTsx1OIxXKZN03FhdEZgPtcK/isCQSdTgjGu+PuFjB8a3TWBbW18Grb81AdLldXYfyIi
         WWPfVCZDu/IIgBmtyOrxxVu2Hn0j1z3OFd68wqpv1H97OBm3hqhUpudQSl+pSWbl6+sn
         UYyJmHOyIDAn5o/B7zA03H3l0xgTnLVMmSscsa3zaQEr+gOW8fMfJ5bEUB3SQKx0Dd6b
         mo0g==
X-Gm-Message-State: AOJu0YwIrWmMJTBm9gcna7NsY8u5WImNT2aZa/YKT5VXMeLuGv4zS2Cl
	M69792Zk+aUYskpeWnrA6N/fQrA1FvwNIYnsR5KBJv59ur/DyA4yYmcdV/f7ydfUeGFyBLuUo3O
	YqAgSKk+eGQ0tTg==
X-Google-Smtp-Source: AGHT+IGiIgbaC40m9Xvw65qy211QKJVo0mx93SoS5R34PfEI1F2nHUhgIqWH8aoIsEOJEz48uo70kFhjxJPiSg==
X-Received: from wma7.prod.google.com ([2002:a05:600c:8907:b0:46e:2897:9c17])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:40da:b0:427:928:789e with SMTP id ffacd0b85a97d-42709287b2cmr10579240f8f.61.1761053680190;
 Tue, 21 Oct 2025 06:34:40 -0700 (PDT)
Date: Tue, 21 Oct 2025 13:34:39 +0000
In-Reply-To: <20251016200417.97003-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016200417.97003-1-seanjc@google.com> <20251016200417.97003-2-seanjc@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDO1FFOJKSTK.3LSOUFU5RM6PD@google.com>
Subject: Re: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D cache
 flush is skipped
From: Brendan Jackman <jackmanb@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu Oct 16, 2025 at 8:04 PM UTC, Sean Christopherson wrote:
> If the L1D flush for L1TF is conditionally enabled, flush CPU buffers to
> mitigate MMIO Stale Data as needed if KVM skips the L1D flush, e.g.
> because none of the "heavy" paths that trigger an L1D flush were tripped
> since the last VM-Enter.

Presumably the assumption here was that the L1TF conditionality is good
enough for the MMIO stale data vuln too? I'm not qualified to assess if
that assumption is true, but also even if it's a good one it's
definitely not obvious to users that the mitigation you pick for L1TF
has this side-effect. So I think I'm on board with calling this a bug.
If anyone turns out to be depending on the current behaviour for
performance I think they should probably add it back as a separate flag.

> MDS mitigation was inadvertently fixed by commit 43fb862de8f6 ("KVM/VMX:
> Move VERW closer to VMentry for MDS mitigation"), but previous kernels
> that flush CPU buffers in vmx_vcpu_enter_exit() are affected.
>
> Fixes: 650b68a0622f ("x86/kvm/vmx: Add MDS protection when L1D Flush is not active")
> Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f87c216d976d..ce556d5dc39b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6663,7 +6663,7 @@ int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>   * information but as all relevant affected CPUs have 32KiB L1D cache size
>   * there is no point in doing so.
>   */
> -static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
> +static noinstr bool vmx_l1d_flush(struct kvm_vcpu *vcpu)
>  {
>  	int size = PAGE_SIZE << L1D_CACHE_ORDER;
>  
> @@ -6691,14 +6691,14 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
>  		kvm_clear_cpu_l1tf_flush_l1d();
>  
>  		if (!flush_l1d)
> -			return;
> +			return false;
>  	}
>  
>  	vcpu->stat.l1d_flush++;
>  
>  	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
>  		native_wrmsrq(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
> -		return;
> +		return true;
>  	}
>  
>  	asm volatile(
> @@ -6722,6 +6722,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
>  		:: [flush_pages] "r" (vmx_l1d_flush_pages),
>  		    [size] "r" (size)
>  		: "eax", "ebx", "ecx", "edx");
> +	return true;

The comment in the caller says the L1D flush "includes CPU buffer clear
to mitigate MDS" - do we actually know that this software sequence
mitigates the MMIO stale data vuln like the verw does? (Do we even know if
it mitigates MDS?)

Anyway, if this is an issue, it's orthogonal to this patch.

Reviewed-by: Brendan Jackman <jackmanb@google.com>

>  }
>  
>  void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
> @@ -7330,8 +7331,9 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  	 * and is affected by MMIO Stale Data. In such cases mitigation in only
>  	 * needed against an MMIO capable guest.
>  	 */
> -	if (static_branch_unlikely(&vmx_l1d_should_flush))
> -		vmx_l1d_flush(vcpu);
> +	if (static_branch_unlikely(&vmx_l1d_should_flush) &&
> +	    vmx_l1d_flush(vcpu))
> +		;
>  	else if (static_branch_unlikely(&cpu_buf_vm_clear) &&
>  		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
>  		x86_clear_cpu_buffers();


