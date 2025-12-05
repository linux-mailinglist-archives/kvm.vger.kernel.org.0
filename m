Return-Path: <kvm+bounces-65377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 87340CA8C5B
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 19:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 24FA83026F8F
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 18:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 970CD343D74;
	Fri,  5 Dec 2025 18:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yAb/DPI6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC0D3271E0
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 18:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764959026; cv=none; b=tEE3zg7PBd0M4QiKe0ePPJFON/LRhty0EzKSzwuxCB7mGWV9HwRLAz+kPl0yLgDuJagK4hplwPvyxs6nikWN/UtAbzxFiDAZFZen/gb0pWlnlQhcaDivQS+2uukLEh9FCzfyRVvC8oCqFYMgPfYxO9sLWC06JcPAnh7inFELCc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764959026; c=relaxed/simple;
	bh=tuSE/NPeIPZv0T1R7ISQkLqsTw60bgooej+WJk2mtkM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KL81P+OmCfFlFAtepeIXbuqdjxjg/eJt+FL2oNtA8wFu/e6E9n45N0wMXHar7BfJPRUOF/0z2mCTadPlOX27aMVyf7GFLNe6tnKG0TUSezeEE7cC1ztAmLRoTull2R/mlbX0LeoefHA4k2fMf69Mj3q2arMKvT9jFjI0lVXKSBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yAb/DPI6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340c261fb38so3883026a91.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 10:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764959024; x=1765563824; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qTzJ3fFbHNg+Y5ksEzbBY6QMbRGpva8/nn9IicDkFak=;
        b=yAb/DPI6rnLQ5dus0kRtFNyT77JbJjPoJN40MCD8WBekMTHc4oWD8FczXuBPl3P8Io
         Vgi3afKxWeKt+32CtL/zH+3ls9TIYuYmlZlzUw2RgDthnbEqKqdBNf6WXXY0Q2wuYfa6
         qPNP2cL7kqIynXplhZtL1XVeEU05baswq5OJRBa+L6KBiv8VydyYL3SMFTJ9U+HPr/GU
         mBywkTi37uWjJCh8ybZMLROyB1pAFeB+rFWV4Nh/ZS2aOcyhUOx1D8TLpzMr7jLVIWZx
         PDULPBNe+A1lSCeOY7YZAVSUlGQKR661/+eKMYmNLL7OGpfEtCdgPgxYTZ2y/5oKBzmx
         PC4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959024; x=1765563824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qTzJ3fFbHNg+Y5ksEzbBY6QMbRGpva8/nn9IicDkFak=;
        b=tQouS4/odIQp9Jn1k7LskdLvwVNkZJ0JcmQvQd/5mfpPI8Wnci84NMJC4L8Kc1Yinj
         WxOq+gvT7S0nMw4OvGFg35DdUoTGTz5sVIrXw1od/HB4UOcfpyUSku79uC2lixn14jzi
         BaXajHakLq0nWX4IYArcRfoRS/gYCjyL13RJwoffQmk7XQzjJJE1ateHyjKHKrpo+v3o
         o1nv3DPD0bqtZpdvdL+AoOwvtOKt79xRU01AxZCDNZ/G6CAk7fJCFK87MhTeWtPSI243
         i+dBmQaDX9/s6q8wE8bfHAnnfMg8LJAuGL41pAVlcq5qDIW+z84s0QLzWdF2f6a58val
         CVfg==
X-Gm-Message-State: AOJu0YylbpPSVnWlldsGxbAOr2F4dUg1TKJAPNwJzXQ0SYJZv/Djruem
	arkOeh9ThnZhwUYWjJl35D6alKcDgPgdwkontp6LGBcO1PFcPObGbA1fYi3Yr79WsK6qVLng8sU
	8K3MsSg==
X-Google-Smtp-Source: AGHT+IEWVvHa+4kFz5YgRzFoH1A2AZVaqfN0I7i5pY7mC/HauFO0hq0wQRHoYpNTs6SgQ9NngOKkSpA7ZpE=
X-Received: from pjbbo18.prod.google.com ([2002:a17:90b:912:b0:33b:c211:1fa9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b50:b0:340:29a1:1b0c
 with SMTP id 98e67ed59e1d1-349a24cb7e6mr31067a91.7.1764959023910; Fri, 05 Dec
 2025 10:23:43 -0800 (PST)
Date: Fri, 5 Dec 2025 10:23:42 -0800
In-Reply-To: <3c0686934fc33ebb484aa5cc71443a22504df7ca.1757416809.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1757416809.git.houwenlong.hwl@antgroup.com> <3c0686934fc33ebb484aa5cc71443a22504df7ca.1757416809.git.houwenlong.hwl@antgroup.com>
Message-ID: <aTMjLkW2h_FWjfxe@google.com>
Subject: Re: [PATCH 7/7] KVM: selftests: Verify 'BS' bit checking in pending
 debug exception during VM entry
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: kvm@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 10, 2025, Hou Wenlong wrote:
>  #define IRQ_VECTOR 0xAA
>  
> +#define  CAST_TO_RIP(v)  ((unsigned long long)&(v))
> +
>  /* For testing data access debug BP */
>  uint32_t guest_value;
>  
>  extern unsigned char sw_bp, hw_bp, write_data, ss_start, bd_start;
> -extern unsigned char fep_bd_start;
> +extern unsigned char fep_bd_start, fep_sti_start, fep_sti_end;
> +
> +static void guest_db_handler(struct ex_regs *regs)
> +{
> +	static int count;
> +	unsigned long target_rips[2] = {
> +		CAST_TO_RIP(fep_sti_start),
> +		CAST_TO_RIP(fep_sti_end),
> +	};
> +
> +	__GUEST_ASSERT(regs->rip == target_rips[count], "STI: unexpected rip 0x%lx (should be 0x%lx)",
> +		       regs->rip, target_rips[count]);
> +	regs->rflags &= ~X86_EFLAGS_TF;
> +	count++;
> +}
> +
> +static void guest_irq_handler(struct ex_regs *regs)
> +{
> +}
>  
>  static void guest_code(void)
>  {
> @@ -69,13 +89,25 @@ static void guest_code(void)
>  	if (is_forced_emulation_enabled) {
>  		/* DR6.BD test for emulation */
>  		asm volatile(KVM_FEP "fep_bd_start: mov %%dr0, %%rax" : : : "rax");
> +
> +		/* pending debug exceptions for emulation */
> +		asm volatile("pushf\n\t"
> +			     "orq $" __stringify(X86_EFLAGS_TF) ", (%rsp)\n\t"
> +			     "popf\n\t"
> +			     "sti\n\t"
> +			     "fep_sti_start:"
> +			     "cli\n\t"
> +			     "pushf\n\t"
> +			     "orq $" __stringify(X86_EFLAGS_TF) ", (%rsp)\n\t"
> +			     "popf\n\t"
> +			     KVM_FEP "sti\n\t"
> +			     "fep_sti_end:"
> +			     "cli\n\t");
>  	}
>  
>  	GUEST_DONE();
>  }
>  
> -#define  CAST_TO_RIP(v)  ((unsigned long long)&(v))
> -
>  static void vcpu_skip_insn(struct kvm_vcpu *vcpu, int insn_len)
>  {
>  	struct kvm_regs regs;
> @@ -110,6 +142,9 @@ int main(void)
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  	run = vcpu->run;
>  
> +	vm_install_exception_handler(vm, DB_VECTOR, guest_db_handler);
> +	vm_install_exception_handler(vm, IRQ_VECTOR, guest_irq_handler);

But the IRQ should never be taken thanks to the CLI in the STI shadow.  I.e.
installing a dummy handler could mask failures, no?

> +
>  	/* Test software BPs - int3 */
>  	memset(&debug, 0, sizeof(debug));
>  	debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
> -- 
> 2.31.1
> 

