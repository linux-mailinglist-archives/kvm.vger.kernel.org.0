Return-Path: <kvm+bounces-72775-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNfLHDnhqGnzyAAAu9opvQ
	(envelope-from <kvm+bounces-72775-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:49:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E21B209FFD
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F29E93039CA4
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 01:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 188E623F431;
	Thu,  5 Mar 2026 01:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GMtJkjHj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FBC1643B
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 01:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772675368; cv=none; b=fNb0pzo/cSQh7SFFDFtVIZ51TTs1W6XBGYGOHnEDhIK1fGHxHZNbLX08tDOEVZg3MLTFH+oWCi1DVPMZQCRH97oRZeUYWAioUoSV1aLJOa7MMehzY4I7hZxQ9qwRrcjVxupZKFXcw5Q4+/yd3CD9oTOQ5OvY5ZAIDyenI7y0j6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772675368; c=relaxed/simple;
	bh=QsGvvZgBswGhh6q51RcmfFvMflu6GVSHKIUeSa47SmI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NlWKO7u53/f0fFQua46UA5Pi4TzhSLdfZXS2iK242xw5FlxNtwWovm6bchp78QWOdTcr7d6HNmUK8MKoC4+fnp46AoGVVbE1H67zyhMXkf7fPGjwiRi6GHfkafG8YWvrbmshmEZq0frBwHs+NdxLp3SoGzEahDrXFYf+uJ2qQ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GMtJkjHj; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c737ced4036so626240a12.1
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 17:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772675367; x=1773280167; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0nBxGvrjSGaqGUT1HQmx6sXgHlT0kR2meTAAgdjspys=;
        b=GMtJkjHjCNi+MC76KEjLVhUOyLy4LUXNE+mYDAdJgBb1atqYLXQxj1zl1UXzZLEbJC
         YPCdEHGcTLNJVi7P22lV+IvJc0THpLOu9OqiIzsS+giDNP1nwHPgVNYxAOGgYf+mhA19
         kB93S7zGU4FLlxm69lnHSKr/O6hAgREwxtuTh93yJR69384QKHoc5JfCjw8C39ZRKoyD
         DzY9gTGFDAE1X9bMpxFGFMR/awvGKyDUC8mzV/MVeLCHjefKfdIscBmzaXF8UCIIiCLQ
         zS7vK+jOdY5O9/R9GpRjQnu7lJSUczvBb/mF40uv2OpKm2R3A5fBuXvZZkjQUvIhIRWo
         P2YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772675367; x=1773280167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0nBxGvrjSGaqGUT1HQmx6sXgHlT0kR2meTAAgdjspys=;
        b=JDM7RJaTk33X1cOZOi0H7BAzWje98Pjj2vyEdmKhppU5QhWzwxPI4T/WpfaWKBz8z7
         JWERy4RV1xzWGE9yQIypbqYsSlehdFuxVPig7jSlldO62/GuwGnb05tu9pOYHEZUDKI6
         uYZsQEqRCebpahDJx+EfNiiRVjnhJof7nLrhwgNeWWiU65HOHg4r8dLiv7Sg9oxb7pTZ
         iTJjrL8cMx2Uy7pEK60lWKyAKTuYJhinKmNDi4DviXIC9m69Cm1ULpkGGQnrDsddhsKJ
         QtPAAUSo+GY3mkh3ALmbpuZP2cnz+iL1u8suWTW2/bnA5vjzxP+vWz1K8oGNZ/A+NKvc
         xnPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUB7pLBHBzF8RLWw6Kd74CWmfqBkEeZ4fVJ803ya9ck8bZNjX3V9zCOJByxxoSsYcPGSK0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGNQwuJrh/jwDn5C1QH8NbNhWnNYSWmF7j2W96dZbYbvCqQyJa
	Rh8PVD5ZpI+L55+8Vm5zViVrzoYH/2MDvjCECOsl7eM+aFXJkV+psKbrHP4x/IU2zGlFWh6CggL
	N9skjzw==
X-Received: from pgbck19.prod.google.com ([2002:a05:6a02:913:b0:c73:8240:7190])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:498:b0:36a:d3c9:efa5
 with SMTP id adf61e73a8af0-3982e1b3ed0mr3468683637.52.1772675366351; Wed, 04
 Mar 2026 17:49:26 -0800 (PST)
Date: Wed, 4 Mar 2026 17:49:24 -0800
In-Reply-To: <20260112235408.168200-3-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112235408.168200-1-chang.seok.bae@intel.com> <20260112235408.168200-3-chang.seok.bae@intel.com>
Message-ID: <aajhJBRS4FPL7nwj@google.com>
Subject: Re: [PATCH v2 02/16] KVM: x86: Refactor GPR accessors to
 differentiate register access types
From: Sean Christopherson <seanjc@google.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 0E21B209FFD
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
	TAGGED_FROM(0.00)[bounces-72775-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Jan 12, 2026, Chang S. Bae wrote:
> Refactor the GPR accessors to introduce internal helpers to distinguish
> between legacy and extended GPRs. Add CONFIG_KVM_APX to selectively
> enable EGPR support.

Why?  If we really want to make this code efficient, use static calls to wire
things up if and only if APX is fully supported.

> +#ifdef CONFIG_KVM_APX
> +static unsigned long kvm_read_egpr(int reg)
> +{
> +	return 0;
> +}
> +
> +static void kvm_write_egpr(int reg, unsigned long data)
> +{
> +}
> +
> +unsigned long kvm_gpr_read_raw(struct kvm_vcpu *vcpu, int reg)
> +{
> +	switch (reg) {
> +	case VCPU_REGS_RAX ... VCPU_REGS_R15:
> +		return kvm_register_read_raw(vcpu, reg);
> +	case VCPU_XREG_R16 ... VCPU_XREG_R31:
> +		return kvm_read_egpr(reg);
> +	default:
> +		WARN_ON_ONCE(1);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gpr_read_raw);
> +
> +void kvm_gpr_write_raw(struct kvm_vcpu *vcpu, int reg, unsigned long val)
> +{
> +	switch (reg) {
> +	case VCPU_REGS_RAX ... VCPU_REGS_R15:
> +		kvm_register_write_raw(vcpu, reg, val);
> +		break;
> +	case VCPU_XREG_R16 ... VCPU_XREG_R31:
> +		kvm_write_egpr(reg, val);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gpr_write_raw);
> +#endif

Has anyone done analysis to determine if KVM's currently inlining of
kvm_register_read() and kvm_register_write() is actually a net positive?  I.e.
can we just cut over to non-inline functions with static calls?

