Return-Path: <kvm+bounces-73320-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CKdeKTLormlRKAIAu9opvQ
	(envelope-from <kvm+bounces-73320-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:33:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B74423BBAF
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:33:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7137D303CA68
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE3D3D7D72;
	Mon,  9 Mar 2026 15:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sYaaUs2a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A73F3D75C6
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 15:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773069859; cv=none; b=Hp6z50iqt/otwp2JrRj1WJo1teXSBb0732rDyeAU0skpg/9U7WVZXUHs3GfcjZ0CbPoP4BVc4nN7nYurS+NsUcPrirg134rj0KP6lABMW7y4GkjK5QWVoVuTANwM+7IorS2dcvxKqNopQx0/mA08NC3jyb/gjE0yDeeD/CA4yv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773069859; c=relaxed/simple;
	bh=iqr08CzJpJ9MB+Clz+/PkQJLo47o9lxWmUwKvTHmolY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FtsqA6HfPo4KNfMz0+e+/PBnR7ixvkcB8Bvqa6IZVY1+MsrB0Xt/dLCBirry0RUGDHEtPAm17sKkn7wnoRTGEu6AXH0kMpckuPn0cks5/XeSg6x+gm3rtuomMowJ1iS+lzs0P+RDGO9xDoQOON3IVz5UGK+GCaxKV/SvW7Fk8Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sYaaUs2a; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae61939fa5so186941485ad.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 08:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773069857; x=1773674657; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m2Nxr3/dxihY6x8oi77PmypbhOW14c4yfKqAOy8dFzc=;
        b=sYaaUs2aCiUYHMUiyhimCXLOhVVntk9GmdxbNgy4pRBRMxnpbS0CUt59WhEzQOGQLh
         VBql968nPViE46hlFEVD7Ib/qIDj/B+nLIqV/SkUX/q+YYtaUuZzWr4rlTe6U+pUozQP
         YocF9PRWdoI8tI6U38A4Nfex4FiscHC4clFqQd78vSKefF+aaN/U62ZHXQ4G6ygau2IR
         lQM3Tr7I5OKLCUGEaiVo0AYKLDwXnbNbKfdImtzLS5Jjcfc6qVwcXpvu1qIL/vgSHqVO
         YRI/QMyCQrRzUgscwml+9aEr/r2qTap1w4aYxay64z6mRrg/JfK79vY1ygVegUGK9HNh
         QopA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773069857; x=1773674657;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m2Nxr3/dxihY6x8oi77PmypbhOW14c4yfKqAOy8dFzc=;
        b=u70x9U1iprb7w5/g/Jj4bKiNdikbvR1BiTbOY8R27lbddutITNwRql+3whr4vfvBlu
         Yv4pF2Ae635xkRrvtsU0AEQ9clEHDMlJu7tamyDK/N9OAMl2TgfXVyqJks2KjymI7Mjf
         5SkiU3g/1z2z3Bm6bH8bh6bOcij5aOQkdwIA37ikR8lrn71t7xvvz9YAQ5/Bgx1iTukT
         H7aZXoh+/6wuTp3t8+9XunhAOyt+1Pr6bmmZc3wzP4uhn07YfWXSLzBttR7URk/Yk9O9
         8nQt1e+itp8Srb6aKTByIncAudsYZocHeXHqVSgjotnmLQOT6Naamr9LGIjjUvW/6Nh+
         fN7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXHTXaS2Iq6Nm5c12CeEVObp0QzimC7tGXA5/FGZ4Ofz20kT6IqAc4Jpn+rCJDxxpN99rY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr776LAoa/e6sXKh4U2sESLSJOU50+/gqFNBlkAfPJNSGYd5SL
	L/CpHG5SmpuXfF+Q16r2H1V1xBW5Gco6tg8/RLaRVnV5f/xMmFrW+F/Etir2uNjKEYdBROh59Oh
	lRtnnnw==
X-Received: from plsl9.prod.google.com ([2002:a17:903:2449:b0:2ae:3d76:eb1b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1968:b0:2ae:8062:8362
 with SMTP id d9443c01a7336-2ae82266d9fmr111476405ad.0.1773069857431; Mon, 09
 Mar 2026 08:24:17 -0700 (PDT)
Date: Mon, 9 Mar 2026 08:24:16 -0700
In-Reply-To: <9C6FC4E7-DF8A-4583-93A8-3B82806D11CD@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com> <20251026201911.505204-7-xin@zytor.com>
 <20260130134644.GUaXy2RNbwEaRSgLUN@fat_crate.local> <9C6FC4E7-DF8A-4583-93A8-3B82806D11CD@zytor.com>
Message-ID: <aa7mILKnhX9N4228@google.com>
Subject: Re: [PATCH v9 06/22] x86/cea: Export __this_cpu_ist_top_va() to KVM
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, 
	x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org, 
	andrew.cooper3@citrix.com, chao.gao@intel.com, hch@infradead.org, 
	sohil.mehta@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0B74423BBAF
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
	TAGGED_FROM(0.00)[bounces-73320-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.924];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,alien8.de:email]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026, Xin Li wrote:
> > On Jan 30, 2026, at 5:46=E2=80=AFAM, Borislav Petkov <bp@alien8.de> wro=
te:
> diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
> index 2bb65677c079..7eea65bfc838 100644
> --- a/arch/x86/include/asm/fred.h
> +++ b/arch/x86/include/asm/fred.h
> @@ -35,6 +35,13 @@
> =20
>  #ifndef __ASSEMBLER__
> =20
> +enum fred_stack_level {
> +	FRED_STACK_LEVEL_0,
> +	FRED_STACK_LEVEL_1,
> +	FRED_STACK_LEVEL_2,
> +	FRED_STACK_LEVEL_3

Why bother with a layer of indirection and more enums?  Just pivot on the M=
SR
index.

>  #ifdef CONFIG_X86_FRED
>  #include <linux/kernel.h>
>  #include <linux/sched/task_stack.h>
> @@ -105,6 +112,8 @@ static __always_inline void fred_update_rsp0(void)
>  		__this_cpu_write(fred_rsp0, rsp0);
>  	}
>  }
> +
> +unsigned long this_cpu_fred_rsp(enum fred_stack_level lvl);
>  #else /* CONFIG_X86_FRED */
>  static __always_inline unsigned long fred_event_data(struct pt_regs *reg=
s) { return 0; }
>  static inline void cpu_init_fred_exceptions(void) { }
> @@ -113,6 +122,7 @@ static inline void fred_complete_exception_setup(void=
) { }
>  static inline void fred_entry_from_kvm(unsigned int type, unsigned int v=
ector) { }
>  static inline void fred_sync_rsp0(unsigned long rsp0) { }
>  static inline void fred_update_rsp0(void) { }
> +static unsigned long this_cpu_fred_rsp(enum fred_stack_level lvl) { retu=
rn 0; }
>  #endif /* CONFIG_X86_FRED */
>  #endif /* !__ASSEMBLER__ */
> =20
> diff --git a/arch/x86/kernel/fred.c b/arch/x86/kernel/fred.c
> index 433c4a6f1773..363c53701012 100644
> --- a/arch/x86/kernel/fred.c
> +++ b/arch/x86/kernel/fred.c
> @@ -72,6 +72,23 @@ void cpu_init_fred_exceptions(void)
>  	setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
>  }
> =20
> +unsigned long this_cpu_fred_rsp(enum fred_stack_level lvl)
> +{
> +	switch (lvl) {
> +	case FRED_STACK_LEVEL_0:
> +		return __this_cpu_read(fred_rsp0);
> +	case FRED_STACK_LEVEL_1:
> +		return __this_cpu_ist_top_va(ESTACK_DB);
> +	case FRED_STACK_LEVEL_2:
> +		return __this_cpu_ist_top_va(ESTACK_NMI);
> +	case FRED_STACK_LEVEL_3:
> +		return __this_cpu_ist_top_va(ESTACK_DF);
> +	default:
> +		BUG();
> +	}
> +}
> +EXPORT_SYMBOL_FOR_MODULES(this_cpu_fred_rsp, "kvm-intel");

Meh, just do EXPORT_SYMBOL_FOR_KVM so that there's no export when KVM_X86=
=3Dy|n.
And it's possible AMD may need to grab the MSRs too.

> +
>  /* Must be called after setup_cpu_entry_areas() */
>  void cpu_init_fred_rsps(void)
>  {
> @@ -87,7 +104,7 @@ void cpu_init_fred_rsps(void)
>  	       FRED_STKLVL(X86_TRAP_DF,  FRED_DF_STACK_LEVEL));
> =20
>  	/* The FRED equivalents to IST stacks... */
> -	wrmsrq(MSR_IA32_FRED_RSP1, __this_cpu_ist_top_va(ESTACK_DB));
> -	wrmsrq(MSR_IA32_FRED_RSP2, __this_cpu_ist_top_va(ESTACK_NMI));
> -	wrmsrq(MSR_IA32_FRED_RSP3, __this_cpu_ist_top_va(ESTACK_DF));
> +	wrmsrq(MSR_IA32_FRED_RSP1, this_cpu_fred_rsp(FRED_STACK_LEVEL_1));
> +	wrmsrq(MSR_IA32_FRED_RSP2, this_cpu_fred_rsp(FRED_STACK_LEVEL_2));
> +	wrmsrq(MSR_IA32_FRED_RSP3, this_cpu_fred_rsp(FRED_STACK_LEVEL_3));
>  }

