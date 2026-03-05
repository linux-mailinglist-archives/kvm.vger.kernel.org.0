Return-Path: <kvm+bounces-72767-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AKZZMpvNqGngxQAAu9opvQ
	(envelope-from <kvm+bounces-72767-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 01:26:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 45DE0209691
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 01:26:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 59C433040AB9
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 00:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95E21DDA24;
	Thu,  5 Mar 2026 00:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bZS5tFeG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782973FFD
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 00:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772670343; cv=none; b=Pc+8kUaCjOkkXTtzfNpQWR64CKBXOomIGBcNEBGFYsN99scBUIVs+hsTmj60AUzCC3pgcGn/3xs+TPOgdFoUogB2284G9MC72wu/4FRkqf7Lh1KfKWBU7DMr0+BdJm6SklcG+0/rIVyiFgnANmU7MHlrNrZkAUVlHY0AHIhghek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772670343; c=relaxed/simple;
	bh=mUxrgPvdoi3NLrb186ru794HJXSt0wMU9NWs4rAc07k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T1BlQFyu5SXAV0hPGlUAIuZafHg6x8YPadmGxAgA7FZBO9KogBAAxYlkciZELtZLF8tZPnxk1d89yvCmgaBuRdtglJNw/aW/gSDLYWZzk2DDytV94pQdSONxpf6Nks5MBxiraeBK5v6OKolRrkV5SCbI05BJzQbgc5s2bFjAGQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bZS5tFeG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-358e95e81aeso34527315a91.0
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 16:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772670341; x=1773275141; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6VS0dk9UF5seMj98ZZR+BIsl/8iPOzHKFtlmFRwLVSc=;
        b=bZS5tFeG544y5XMZe9oJPLrqBTefC0wHWN55OCePC+JJB5Ox/9IbKiEOy2UbstYI6Y
         U6HjRONIZ7pUW+wCvwZQ/PFdmUeNkTyAm41NynuIrundEolsUGdYGA1TOZhn0zZV/k+P
         BHsDmxsj2tPW/gH/+1Fd2JkplsJ1eenAQ6bszMNdYeFGjpmsL43+Bf9PD5RGTeF13i5H
         Rai7QZyZrG6q4t/dRGGWoy+I2ekWUPiLwbm5cLCELdSHmXKCDZwd9A+wtRKLhraBkDtr
         swhKkzhYbJiJ7aRqzOv9SQGhP0Cch7kTvC+ALWyKMQLKb6ASC5kipYo9hSg8nzUPca4t
         ZdwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772670341; x=1773275141;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6VS0dk9UF5seMj98ZZR+BIsl/8iPOzHKFtlmFRwLVSc=;
        b=kFks3vMsOWqF8SCgYBQKyrflNHI/ew05ApeWPcz7zVkJSLlZMYTbyfQNX859VmcOpP
         IK8+oAUt35AfqZ0bMv9sBITMYHfluxpLnTWN5WlvPG3VvF+Gxa3XFiGRvQzInjaQOisX
         WfRAjqMbs925oZxfEKJwQW3r4G8Y5YyiRIylKESQjP+a4cMCF/SOf4xBtwzd8bFdLfz+
         Jy4D/PjhZ72D6aRBpbt47msTihJCG+vX9MuEZFCZSLfzAUwelCS0Gf1Os6CevWR3R8yd
         uotOTcy7OcYtLn8K9katVRXgv7R/UHUGeOqQ1sOBahWE0V7YMfVIrOsynZJWc1aKigGh
         tSGA==
X-Forwarded-Encrypted: i=1; AJvYcCXEUPJ7JG7rixZkwy68RSRjyrGA53f6gUroMvAwAa5TQ8GZ4hKEnrVBA1CI1Of/w7kMsaU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqMHe7S88do5o0SnvxrcqzxRxB8TMoSgVX2/DYJp//fzQJjUwh
	vDiB3QdAAqAF5e+KwQYQ0tBYJq3wpJja8nLsh9W1jYeAdnS8fyL+sTuVAUxQPV64R9uEq95jyp7
	MJzBWog==
X-Received: from pjzb1.prod.google.com ([2002:a17:90a:e381:b0:359:7e40:7d79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3fc4:b0:359:974a:3d65
 with SMTP id 98e67ed59e1d1-359a6a421a8mr3564264a91.16.1772670340830; Wed, 04
 Mar 2026 16:25:40 -0800 (PST)
Date: Wed, 4 Mar 2026 16:25:39 -0800
In-Reply-To: <20251026201911.505204-4-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com> <20251026201911.505204-4-xin@zytor.com>
Message-ID: <aajNg6YrDljfneEE@google.com>
Subject: Re: [PATCH v9 03/22] KVM: VMX: Disable FRED if FRED consistency
 checks fail
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com, 
	hch@infradead.org, sohil.mehta@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 45DE0209691
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72767-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Sun, Oct 26, 2025, Xin Li (Intel) wrote:
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 6bd67c40ca3b..651507627ef3 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -405,6 +405,16 @@ static inline bool vmx_pebs_supported(void)
>  	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
>  }
>  
> +static inline bool cpu_has_vmx_fred(void)
> +{
> +	/*
> +	 * setup_vmcs_config() guarantees FRED VM-entry/exit controls
> +	 * are either all set or none.  So, no need to check FRED VM-exit
> +	 * controls.
> +	 */

Eh, omit the comment, there are at least six other control pairs that use this
logic.

> +	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_FRED);

Unnecessary parentheses.

> +}
> +
>  static inline bool cpu_has_notify_vmexit(void)
>  {
>  	return vmcs_config.cpu_based_2nd_exec_ctrl &
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index be48ba2d70e1..fcfa99160018 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8020,6 +8020,9 @@ static __init void vmx_set_cpu_caps(void)
>  		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
>  	}
>  
> +	if (!cpu_has_vmx_fred())
> +		kvm_cpu_cap_clear(X86_FEATURE_FRED);
> +
>  	if (!enable_pmu)
>  		kvm_cpu_cap_clear(X86_FEATURE_PDCM);
>  	kvm_caps.supported_perf_cap = vmx_get_perf_capabilities();
> -- 
> 2.51.0
> 

