Return-Path: <kvm+bounces-73215-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mAxsEhiJq2nXdwEAu9opvQ
	(envelope-from <kvm+bounces-73215-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:10:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E02BB229962
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5184A306825B
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 02:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A05303A12;
	Sat,  7 Mar 2026 02:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KX7V6fFa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40701B4257
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 02:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772849418; cv=none; b=Gfn/LTUQdiRJ+wU9BTGXz+R8UdS6KYpNgwTrLu2+sFhNZeumJjP28gY5BULpNg1muFgTxpJRwiefI6e5zmFmhroEYsgbBqcf6+LfnTyAZQIOYcCSH+q2Dfioch7eldmLZvy4AVS/oykfMPhnmxr/rx7DVTrDEPBvwgKcLvX6Hg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772849418; c=relaxed/simple;
	bh=9h4cduGK17GQj8nyW3SF7iI1VXySYDk0sliwwVt98BQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nz/vbqcDByl031vA8Hzv+Wag4b2pgZATgPhaaN6LNGanvO4YeYWce79knjES7sLewKpDqXHksp2Br1tPUKb6aQg6Ez31plH78NclglpjtrdmjQ8PORWdLdoFctoAD0JpFtgdnJUdBtdF16JSYUxAwwguNYksCKH08zxRi62eJQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KX7V6fFa; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b62da7602a0so5927639a12.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 18:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772849416; x=1773454216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VA9d9qqBA64RLM6+sK3wbxGS9ABEXBuT3KUjnzm+Jyg=;
        b=KX7V6fFabBjiWcPBeGIRKxStTzKZGW7PKod9DQwxvDQaZGw+gIKfh8WvFNkjk8SOiQ
         dcsuK8uYywQvnNQgtyJ/ciR0bIbjL8OSs8+ERE1Da8SaaIud4ge/tuWwRDYW7CFXe7zK
         BDNkD4Y1c46/o+HdfLH4oewkdp38oD9nuH1NkPUoQhPY3F3VUMK53f1UycEu+/4xFP5w
         RV/BA4y7WSu6Vojsy7u9j38UnJXbEft+MmSGuJrDSQmU3XeRzwctTyLyjv7ELMNlxVxj
         X9jgO+smJKOA8zoLVnbOUFO9oTD9wISyTYpICo43gv7nSUDp6re0sSjxAmAxpXX8Itfu
         664g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772849416; x=1773454216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VA9d9qqBA64RLM6+sK3wbxGS9ABEXBuT3KUjnzm+Jyg=;
        b=L8ABzeI4FR47jJU2ld8QCM4TZEPqsWXCcN566kwRA9M9AfClOXj3ZYZpiJlXJBbyx+
         dStEN4YbQIgAvxE9Vj4NzXOI3z/k7XNPXIaOi6weQ+hRVMIRYxgyWsvHY/4iD6RmwGZS
         GYGgkO9T0URwvEDcQpXtt0qV6nyJ9M/3CIW0XPyjmVJnBTldPyXhDxYOnHxzGxLUWOEn
         Nj0v3hrj8v5l8gvHFFZiQMQvhVRLjQGAZGuR9loeJoYdz/hIPh9S+oeX7pRpUzdSj+Xc
         ZFT5fMXzNWlyN5LPhiIxBdNc5HorF7Pwg1L9CRJqKbPqlEzzCeJJiyQfkD4fWfqKA4sv
         b+Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWvNbhQ/r8FNV/2rxfNa3BcpT3KCO3AklL01bwCdAAPCy26jax2G455WaVW87CLoSuG808=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx042Uonl+p4nSVxilTk4IKJvc2m+ReF6cUeopJ/D4UyhT3THRA
	wSRheC1m/QQszFQkA9m3w4w9FLSTVIlcqYbnWp/NzHeVbQOzW+4mfe/uLdLRSzWyePzesAZl3bd
	KWKhU+A==
X-Received: from pfiy21.prod.google.com ([2002:a05:6a00:1915:b0:7b7:c77:a04b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a06:b0:38b:e9eb:b12b
 with SMTP id adf61e73a8af0-398590877e7mr4395240637.41.1772849416212; Fri, 06
 Mar 2026 18:10:16 -0800 (PST)
Date: Fri, 6 Mar 2026 18:10:14 -0800
In-Reply-To: <20260129063653.3553076-3-shivansh.dhiman@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com> <20260129063653.3553076-3-shivansh.dhiman@amd.com>
Message-ID: <aauJBkfODjTSnSD6@google.com>
Subject: Re: [PATCH 2/7] KVM: SVM: Disable interception of FRED MSRs for FRED
 supported guests
From: Sean Christopherson <seanjc@google.com>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, xin@zytor.com, 
	nikunj.dadhania@amd.com, santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: E02BB229962
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73215-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.919];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, Shivansh Dhiman wrote:
> +static void svm_recalc_fred_msr_intercepts(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	bool fred_enabled = svm->vmcb->control.virt_ext & FRED_VIRT_ENABLE_MASK;

Please use guest_cpu_cap_has().  The VMCB enable bit is a reflection of the
guest's capabilities, not the other way around.

And s/fred_enabled/intercept.

> +
> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP0, MSR_TYPE_RW, !fred_enabled);
> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP1, MSR_TYPE_RW, !fred_enabled);
> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP2, MSR_TYPE_RW, !fred_enabled);
> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP3, MSR_TYPE_RW, !fred_enabled);
> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_STKLVLS, MSR_TYPE_RW, !fred_enabled);
> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP1, MSR_TYPE_RW, !fred_enabled);
> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP2, MSR_TYPE_RW, !fred_enabled);
> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP3, MSR_TYPE_RW, !fred_enabled);
> +	svm_set_intercept_for_msr(vcpu, MSR_IA32_FRED_CONFIG, MSR_TYPE_RW, !fred_enabled);
> +}
> +
>  static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -795,6 +811,8 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>  	if (sev_es_guest(vcpu->kvm))
>  		sev_es_recalc_msr_intercepts(vcpu);
>  
> +	svm_recalc_fred_msr_intercepts(vcpu);
> +
>  	/*
>  	 * x2APIC intercepts are modified on-demand and cannot be filtered by
>  	 * userspace.
> -- 
> 2.43.0
> 

