Return-Path: <kvm+bounces-72782-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ENWZNTUFqWlW0QAAu9opvQ
	(envelope-from <kvm+bounces-72782-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:23:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 392CE20AC1A
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 66A0B3062499
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 04:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A22323F26A;
	Thu,  5 Mar 2026 04:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aMhWlKPN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F681E3DCD
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 04:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772684567; cv=none; b=T67szmsk4ZvXQOWrASnKx1di0ThYFOcBKLF7kxQaZkmrvTmZnokcxZgTjLHCvEPoL0Hi/eIpbUmosfoPbwo3kSbA2e7QNsRTYQlbo5K9NwjqwYHWIuMxASrrAXqWzcl8326xKF698xo2CMMEeQJWQ3zEYIBwoNPD3kwn17N8Nnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772684567; c=relaxed/simple;
	bh=81yLoi3tXabw0dqSXUmCvROMbXPWzxbqe15oyfoa03k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aU5I5QXpFzffp0I4a7jur1Y7ajShQ7lLzqyRSVgKb5Rn+XJCpe+gnz26dRxNuBfPQ3YTs3Azo9ZHNKyKWohGgDZVDBmL/Dfeopdl7CrzT1jpXHrjk0khkQwqEz43Ltn5EZ3fVvGXgDdxFe60CN2GC9P2fgq8f+39FD4+D1iiy7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aMhWlKPN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358f058973fso7217657a91.1
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 20:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772684565; x=1773289365; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5W+vjOw4sHJfZ2ztYmHn3awEcYReG2mo7cvKhP8YlFQ=;
        b=aMhWlKPN90aycq0h0qZjHK5zbht4c94Y2IYQ2aje0FfaD/vAEZU9/J/ZOLlD6tViYc
         GH+eYp1bQCWtt631PazBYXz7EnhGhj4nktRkaLCWe0ZkCAycmUjDWUpB7+QqTbx/UH/l
         sgHYgeiX1KroHEECsdXoLGsuNuOzZv8guC5sznHG14g/HHt/3wYZNZ1g7npXP6Y2Y9qc
         mErEU7s4yX3oXv+iaLUpEOrSLahEYwKSkZ73ZVF1MkfEjEu2sWxXi7dxc+4Hgj7RCEdr
         Me3dvyFd6FbNz5yqEbOfro++4wBoR0AAag2F3ulIJzDDr6FZRls1OBXCLhcwFiO1xaee
         MViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772684565; x=1773289365;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5W+vjOw4sHJfZ2ztYmHn3awEcYReG2mo7cvKhP8YlFQ=;
        b=FqGFrN+Jm5gLcCl1BdMaDLEPIipAs1gYYDk9s4LxxQ2xHw8dgrLuNuEZAC23ola6VR
         3hy9YPWp64sh55gJli/15SMWNDl47ekDoKqN4mW5AqnSq0OB+gUrKt7w7bma46gAysCj
         I2HEJdPov/T41t2i/8rfxw6RHsmfwABxO0m6jcwDtWtpCRDrTkAcLE/N9AMsB4GC7JJs
         iaMRskh4p5wut1l2FjJyGbq+4TKSK0gkSLtyRzNDM4FnojpvbNRXHgJmvxwztQpEW2jB
         bloxRoIzo3WulNIEDryi+fRUDIfEwYYu9aT/PKZBEFhVaKhJLhuC1cybmRlVNNBmU66a
         rOjg==
X-Forwarded-Encrypted: i=1; AJvYcCXTJhsv2QivFh2exJmmJYw4bIcRElFriyYNacyWtW0KHEq3Q2H+TT0IlHxKkmlC65PrDCQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu7Y1gyheEw980AlHiM/8P2gWGIua6OLGaY2RZaq+pBnUspIZH
	Op3IWQ2d6dlK82FOxyXMvK1zQX23DuPL571qoPYxjPx+808qT7uq0PzUX3yObe/612eAmiC8RsB
	7HbVyHQ==
X-Received: from pjd13.prod.google.com ([2002:a17:90b:54cd:b0:358:eda2:4a10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fc7:b0:356:7b41:d355
 with SMTP id 98e67ed59e1d1-359a69a0346mr3119329a91.1.1772684564578; Wed, 04
 Mar 2026 20:22:44 -0800 (PST)
Date: Wed, 4 Mar 2026 20:22:43 -0800
In-Reply-To: <20260112235408.168200-10-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112235408.168200-1-chang.seok.bae@intel.com> <20260112235408.168200-10-chang.seok.bae@intel.com>
Message-ID: <aakFE4BMwsdOXL55@google.com>
Subject: Re: [PATCH v2 09/16] KVM: emulate: Support EGPR accessing and tracking
From: Sean Christopherson <seanjc@google.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 392CE20AC1A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72782-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email]
X-Rspamd-Action: no action

For the scope,

KVM: x86:

because other architectures have emulator code, and as is the case here, x86's
emulator code isn't strictly contained to the emulate.c.

On Mon, Jan 12, 2026, Chang S. Bae wrote:
> Extend the emulator context and GPR accessors to handle EGPRs before
> adding support for REX2-prefixed instructions.
> 
> Now the KVM GPR accessors can handle EGPRs. Then, the emulator can
> uniformly cache and track all GPRs without requiring separate handling.
> 
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> ---
>  arch/x86/kvm/kvm_emulate.h | 10 +++++-----
>  arch/x86/kvm/x86.c         |  4 ++--
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index fb3dab4b5a53..16b35a796a7f 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -105,13 +105,13 @@ struct x86_instruction_info {
>  struct x86_emulate_ops {
>  	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
>  	/*
> -	 * read_gpr: read a general purpose register (rax - r15)
> +	 * read_gpr: read a general purpose register (rax - r31)
>  	 *
>  	 * @reg: gpr number.
>  	 */
>  	ulong (*read_gpr)(struct x86_emulate_ctxt *ctxt, unsigned reg);
>  	/*
> -	 * write_gpr: write a general purpose register (rax - r15)
> +	 * write_gpr: write a general purpose register (rax - r31)
>  	 *
>  	 * @reg: gpr number.
>  	 * @val: value to write.
> @@ -314,7 +314,7 @@ typedef void (*fastop_t)(struct fastop *);
>   * a ModRM or SIB byte.
>   */
>  #ifdef CONFIG_X86_64
> -#define NR_EMULATOR_GPRS	16
> +#define NR_EMULATOR_GPRS	32

If we add Kconfig, this would be the place to use it...

