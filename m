Return-Path: <kvm+bounces-69013-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sMb5EQy2c2liyAAAu9opvQ
	(envelope-from <kvm+bounces-69013-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 18:55:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 32D97793A4
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 18:55:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 73DC93009816
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 17:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 359522580E1;
	Fri, 23 Jan 2026 17:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2V48mEFq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A282184540
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 17:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769190914; cv=none; b=NhsUyD2N3/0WGdtR/2sz96hIC82BHlUm4/ROAJyKdoE2C2S6qlph2Arbav3Xem6S6zCFDzxmMJMpjdrrMwTnl9h2cXmAilKViN8nub3+O+fCrS47L/vWkig05+idWfbVhBL2fP07Ag2zjPSbrW9KfkpOW3DLcw01Pwe8Kb9mQ+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769190914; c=relaxed/simple;
	bh=zXAJgkPE1pPkpAeSf54sl9gNOz+zUWSoNtaXn7i4ovI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cJEJ29EguC+daxaDaq4gXl4rLwk6bT82ZTWT8Fe8vcOWfkGHn/kvTieMBs1y0+YkEGUz9hO5HMupJBldk08cLtRnRWL5lcGmDjdPQc1wU2MoXsSKYzCoIL6D7vEvzwpwkB9bh9GnKVWC3Eq6jHgTiXo14BHE0LrUDJzo9qwHBhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2V48mEFq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ab8aafd24so2365363a91.0
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 09:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769190912; x=1769795712; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NPeVUuvA13SnNgf5n/5K2Vk+ZBZy/3r1jk8iaT+1VRQ=;
        b=2V48mEFqd8LqPsGqiMTb7ZYSHfnZM7Gyuc0J77MtTvBD5R3X5AIb0brd1scnVmCflg
         RL+X1xrTX/8VxL8hfBI0LRATKG9u7BzqXFp81Bh3GY7OJDK1pjbNiaEObmAcpKjswDKr
         INQ8zKmBtnxin5fwjzd4ognzQ+Ln1Y+oJXzacvewVyVa2VkK3mFrQzUb4R3dJTNR1uDI
         DQAUUaFdJqiIE85hD7BYO9kxwH+qqOi6ZRj+8E9lVyccun2Nk18l/zx3bmRDGRVQa65z
         wTc6Sko6VcmJwlkQlbUr/vKaDBYvzIe7PK8dDJ+mk4yrCDrrrEFc0or/n+tg3UEhtBKY
         FFdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769190912; x=1769795712;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NPeVUuvA13SnNgf5n/5K2Vk+ZBZy/3r1jk8iaT+1VRQ=;
        b=STSBqFnmCrufx/Qd0TxO6qZVigJ577m+Ao/PKPC9d0kdkk4HJbc8qpOjFrlPvCZw8r
         00ElYU5V6Lo8sUZFQS0gRcMyGJlR+XIGAwRIgqQG80zrYUNzHsF5MqujS+Koydu2XIOu
         nQYaWBWlSDktIURS+2QBMr3ZP5HeFdWr2rF/0R1GlseRNC0tw0StRL3O+FIZCzMKFFTO
         4yybAgVws/jOm57Eg5DKVKO68KdE+6d4Lwn94nCvFhvuIALN8XNk5VBuQnyyoLxq94So
         fVhnpFureX5U/h7gcXrJ2FCilnEklG/DWJF4OrOvCEDIACYZ9juWQjNHttAu52FJkqwg
         WxCw==
X-Forwarded-Encrypted: i=1; AJvYcCVUitRz7RgcGh1+mNSKPk6jP8yR9EzkZaWyhJRVZptNGXZdU7/TSDnUM8tJ6+9w9WxWiFw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh+C0HyoOO+BJvNWRkW6XOmLDlO1J9ISs5VbVYk2KC87xX+jMs
	P/tGr8asqbeKH46chRU48Nmq69c/A0PNMOd568yBtugnznkfgV7OLnx3Iphfk4J90kDL7MuHc3q
	kLliGtQ==
X-Received: from pjbsl12.prod.google.com ([2002:a17:90b:2e0c:b0:34c:3c14:d369])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55ce:b0:34c:718c:5448
 with SMTP id 98e67ed59e1d1-35335276155mr5631730a91.4.1769190912428; Fri, 23
 Jan 2026 09:55:12 -0800 (PST)
Date: Fri, 23 Jan 2026 09:55:10 -0800
In-Reply-To: <20251120050720.931449-3-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120050720.931449-1-zhao1.liu@intel.com> <20251120050720.931449-3-zhao1.liu@intel.com>
Message-ID: <aXO1_kmDSu_H1BoL@google.com>
Subject: Re: [PATCH 2/4] KVM: x86: Advertise AMX CPUIDs in subleaf 0x1E.0x1 to userspace
From: Sean Christopherson <seanjc@google.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Xudong Hao <xudong.hao@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69013-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 32D97793A4
X-Rspamd-Action: no action

On Thu, Nov 20, 2025, Zhao Liu wrote:
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index 743ab25ba787..99ec9e656655 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -44,6 +44,16 @@
>  #define KVM_X86_FEATURE_BHI_CTRL	KVM_X86_FEATURE(CPUID_7_2_EDX, 4)
>  #define X86_FEATURE_MCDT_NO		KVM_X86_FEATURE(CPUID_7_2_EDX, 5)
>  
> +/* Intel-defined sub-features, CPUID level 0x0000001E:1 (EAX) */
> +#define X86_FEATURE_AMX_INT8_MIRROR	KVM_X86_FEATURE(CPUID_1E_1_EAX, 0) /* Mirror of X86_FEATURE_AMX_INT8 */
> +#define X86_FEATURE_AMX_BF16_MIRROR	KVM_X86_FEATURE(CPUID_1E_1_EAX, 1) /* Mirror of X86_FEATURE_AMX_BF16 */
> +#define X86_FEATURE_AMX_COMPLEX_MIRROR	KVM_X86_FEATURE(CPUID_1E_1_EAX, 2) /* Mirror of X86_FEATURE_AMX_COMPLEX */
> +#define X86_FEATURE_AMX_FP16_MIRROR	KVM_X86_FEATURE(CPUID_1E_1_EAX, 3) /* Mirror of X86_FEATURE_AMX_FP16 */

Unless someone feels *very* strongly about the "mirror" terminology, I'm going to
use ALIAS instead of MIRROR when applying, to match KVM's existing terminology for
the 8000_0001.EDX => 1.EDX aliases.

/*
 * Intel-defined sub-features, CPUID level 0x0000001E:1 (EAX).  Note, several
 * of the bits are aliases to features of the same name that are enumerated via
 * various CPUID.0x7 sub-leafs.
 */
#define X86_FEATURE_AMX_INT8_ALIAS	KVM_X86_FEATURE(CPUID_1E_1_EAX, 0)
#define X86_FEATURE_AMX_BF16_ALIAS	KVM_X86_FEATURE(CPUID_1E_1_EAX, 1)
#define X86_FEATURE_AMX_COMPLEX_ALIAS	KVM_X86_FEATURE(CPUID_1E_1_EAX, 2)
#define X86_FEATURE_AMX_FP16_ALIAS	KVM_X86_FEATURE(CPUID_1E_1_EAX, 3)


