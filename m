Return-Path: <kvm+bounces-70069-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aDTGEFRAgmlHRQMAu9opvQ
	(envelope-from <kvm+bounces-70069-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:37:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EA48CDDB05
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:37:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F05EB30C6824
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 155CB2580D1;
	Tue,  3 Feb 2026 18:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P+FOZc05"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0030631B136
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 18:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770143410; cv=none; b=aP7Sieuw7p6npIlQiSqahd2i9cuPTha9leQeVl6Uh+v2LrSNiO8hAIvh5DfNcvYmQbQ35CCQgTMD3jo6LIztKqJiGrVAzQg2sf6LNklunW1S/Vc3H/wOhOMZD0DCPNefLXj2rHELnrZTfWfKVeb0zXk1qaMO/T7ght+FQ0s4ta4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770143410; c=relaxed/simple;
	bh=n0I+ucW8F94rcvTVst7anEYgeQyCS9boc4KtFhwfYuM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fyLDB+UtAcLUCHhZK4gFntsb2BsuLiZu7KLmYPhNOlxnxFJHLuy8pE+ieZ6vjJetR9gvteWDEjZ549uZzCSkDyFfLORYx196kRCmi17hvay5WOsPCkc7D588eFinRAVVa5mt9HcHv3Ux3unxzFglRf5i6O7lrC9WtAjqKCilPSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P+FOZc05; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a377e15716so158279435ad.3
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 10:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770143408; x=1770748208; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0iyGtqNJjLfOq7LUy8GJkOhIv5Bk28YCBcA+t6R+k9U=;
        b=P+FOZc05sqe+4isf2X4U72v7uOtzbRCu1oapzvLwRRaFHVvJ/t9QyTSKiUJGe1IaHU
         eVonYwy7W7ujh3l6pBYRycKp650LgABQXMcS8b1jkwoOdgTYey1BFHMMrEKaVCCfJaLh
         yGLc4ERA3iYhH+Zb66t0wPu/zhG0oFPyjNedjx+t7raPX58Aw1ekNZx2GknCnxA7Fzjy
         I2JOsYOxI9uCz/2BeoMYnBJxb6A5fA2/pTByziyW8u+TBXQtP5po+X3pAH5aH4X6Xo4/
         3I5IgI0SoApoJQncZmC+O1oI5ylPiWMo+aJBh8XnNe2UYl+/acY66Ht1IK3TXVfvFbk6
         ZFJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770143408; x=1770748208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0iyGtqNJjLfOq7LUy8GJkOhIv5Bk28YCBcA+t6R+k9U=;
        b=bYHW1VUAVjtNNq2XjlOFle0LE49QVe8x//iOXAvaEIanP9UQcZkyINgOO0xa9Oo65u
         GNDsEG+clt7cIKlQyA+F5lB/kk4nEOedNnHGVkW6qLAVWz/V3EDzBRk4RQ3qb5wn5+MF
         PvefjjT8kOlpSSVVnAbW/qV8cJ9PJQ4j/G1sxPfHYtq/2PCIEwJ0iClgKH7smAKg7hhr
         In8/k1fnuofm4SI1E8L2YA5jmZSeuZlUalLb++hF1JAmEPQ3OpFPqh/1GoxrIt8ttvRH
         y72EqmlSXHKFZu0mx3ZuA9UnQKLWCALc3YIoIErmOxAKK1vLJAOXpkH2iHEzu6BIRKNw
         GAAQ==
X-Gm-Message-State: AOJu0YxXgA1OhkKcvtYweEIkSU06ZAc8ExmtvwDvIx1XDVKPxxMRo1VU
	+hqgLj2iTQFEb8cV3QAeHZQJXUDK04JHfb348/JRWjNPI/29MFBwr2gFe7rURT4YpKZvLZ9194v
	zNPyJdA==
X-Received: from plbjo16.prod.google.com ([2002:a17:903:550:b0:2a0:9937:4b58])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b47:b0:2a9:db7:4472
 with SMTP id d9443c01a7336-2a933bbb43amr2690835ad.10.1770143408293; Tue, 03
 Feb 2026 10:30:08 -0800 (PST)
Date: Tue, 3 Feb 2026 10:30:06 -0800
In-Reply-To: <7acdd9974effabe5dc461aa755eacf9fb0697467.1770116601.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <7acdd9974effabe5dc461aa755eacf9fb0697467.1770116601.git.isaku.yamahata@intel.com>
Message-ID: <aYI-rqFnqJeAb_mB@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: apic, vmexit: replace nop with
 serialize to wait for deadline timer
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70069-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,redhat.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email]
X-Rspamd-Queue-Id: EA48CDDB05
X-Rspamd-Action: no action

On Tue, Feb 03, 2026, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Fix apic and vmexit test cases to pass with APIC timer virtualization
> by replacing nop instruction with serialize instruction.
> 
> apic and vmexit test cases use "wrmsr(TSCDEADLINE); nop" sequence to cause
> deadline timer to fire immediately.  It's not guaranteed because
> wrmsr(TSCDEADLINE) isn't serializing instruction according to SDM [1].
> With APIC timer virtualization enabled, those test can fail.  It worked
> before because KVM intercepts wrmsr(TSCDEADLINE).  KVM doesn't intercept it
> with apic timer virtualization.
> 
> [1] From SDM 3a Serializing intructions
>   An execution of WRMSR to any non-serializing MSR is not
>   serializing. Non-serializing MSRs include the following: IA32_SPEC_CTRL
>   MSR (MSR index 48H), IA32_PRED_CMD MSR (MSR index 49H), IA32_TSX_CTRL MSR
>   (MSR index 122H), IA32_TSC_DEADLINE MSR (MSR index 6E0H), IA32_PKRS MSR
>   (MSR index 6E1H), IA32_HWP_REQUEST MSR (MSR index 774H), or any of the
>   x2APIC MSRs (MSR indices 802H to 83FH).
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  lib/x86/processor.h | 6 ++++++
>  x86/apic.c          | 2 +-
>  x86/vmexit.c        | 2 +-
>  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 42dd2d2a4787..ec91c9c2f87d 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -1086,6 +1086,12 @@ static inline void wrtsc(u64 tsc)
>  }
>  
>  
> +static inline void serialize(void)
> +{
> +	/* serialize instruction. It needs binutils >= 2.35. */

And a CPU that supports it...  I don't see any point in using SERIALIZE.  To check
for support, this code would need to do CPUID to query X86_FEATURE_SERIALIZE, and
CPUID itself is serializing (the big reason to favor SERIALIZE over CPUID is to
avoid a VM-Exit for performance reasons).


> +	asm_safe(".byte 0x0f, 0x01, 0xe8");
> +}
> +
>  static inline void invlpg(volatile void *va)
>  {
>  	asm volatile("invlpg (%0)" ::"r" (va) : "memory");
> diff --git a/x86/apic.c b/x86/apic.c
> index 0a52e9a45f1c..0ee788594499 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -35,7 +35,7 @@ static void __test_tsc_deadline_timer(void)
>  	handle_irq(TSC_DEADLINE_TIMER_VECTOR, tsc_deadline_timer_isr);
>  
>  	wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC));
> -	asm volatile ("nop");
> +	serialize();
>  	report(tdt_count == 1, "tsc deadline timer");
>  	report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
>  }
> diff --git a/x86/vmexit.c b/x86/vmexit.c
> index 5296ed38aa34..6e3f4442f2f3 100644
> --- a/x86/vmexit.c
> +++ b/x86/vmexit.c
> @@ -437,7 +437,7 @@ static int has_tscdeadline(void)
>  static void tscdeadline_immed(void)
>  {
>  	wrmsr(MSR_IA32_TSCDEADLINE, rdtsc());
> -	asm volatile("nop");
> +	serialize();
>  }
>  
>  static void tscdeadline(void)
> 
> base-commit: 86e53277ac80dabb04f4fa5fa6a6cc7649392bdc
> -- 
> 2.45.2
> 

