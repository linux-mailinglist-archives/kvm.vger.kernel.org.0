Return-Path: <kvm+bounces-71642-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MLxUMvzrnWncSgQAu9opvQ
	(envelope-from <kvm+bounces-71642-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:20:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E54C318B3B8
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:20:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 279F83050E5A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD472C21F1;
	Tue, 24 Feb 2026 18:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jbk9WMnX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3822BE642
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 18:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957227; cv=none; b=hdV72HcnkH7y2SsaC20gfWJ1IUhCn8qdMqAiVqggSRf257Gs6NnMfCy/n4NS3SANfwVDePKAmZmba/RXf9jYCvc9uoMddHhSRuJHvnAfBUwNYXfGQBC6pUKxWqSj8s+bvhgHIkLsL1xtqqpkmCeoCFRNFAJL5vL0c90odBG/mzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957227; c=relaxed/simple;
	bh=6HBIbz1MIHxgv47f23pkLD3mpNvQPB8Pf233Cy+qpbI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hg9ygp1IIx0GbpOT5Iln67DZ6RVTb8YZamTFPBsrMO0vnqOEvSYSJhxJm1R7TXbkSpYNt1+Cx4MtBlUCVc8zfRCDA6rv1Im7FCBcQbbnRtNfsn4U5VhLJOwy0KW13IpJkds8K2nkYTNPL0n/FE6spW0ums1MCHAISmETo8AJjCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jbk9WMnX; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2adad0625d1so39197695ad.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 10:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771957226; x=1772562026; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XPIHlG6KtLJYesq6Mh62LHbWNEo//7J55cZVZpHo2WQ=;
        b=jbk9WMnXeZKwYpTD4Rmto/OgrR90S1QYFk9KPfqe8iU0p2fr2D3QuSr3YT/ZWxnaIT
         l6od1qQtKwsVpbepzjpI+nf722Indm2goMGEgEHp7Vu12d07P3HJCW9tVJs4KckFxR4e
         3xFkZgXPrgaXZ9IJCdm2HQAcPKqO3YKXboLOnux5UgZCzQYBjTkUxBYg6qQou7XCx4Rc
         L3/FPYF88UmbNnBOU5C5RSZCb5esgM0NAp5hlSaKbZrzXqQ6fXGbsv2sbUdCIzKrPdum
         9/YfaZ/gfsb81qhwC0UC24RaTiW85OZVgHMYeVNczSODfKRmW28gZ5DwZ1Kfhfgi83a2
         eVvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771957226; x=1772562026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XPIHlG6KtLJYesq6Mh62LHbWNEo//7J55cZVZpHo2WQ=;
        b=tj/BM8DHwQgrikD8jfa/ffx4H18P8gD8T3ZcJIEKR3WjISYfJ5owazBZGi/7N0Xs/l
         AmTRqKHz1md1FRH2aCssvedYKqxVrzQVY7+1N9kJ1b6ks6gxfYi62D+NaIDGBqr1Hmab
         suAiQ4UI6vyt7A96OXqN6q+FCLepQpKWF4S/EbLuBttnvv6XBEo5oJ9hzsNK9U9xoeHI
         l0m0uvwcoHtWEAAc36L4g+SBubCmp+wbZW66ckKnlwHpBIkoWkXMVoKRvCdXgTTOaYV5
         K7yE632GQOZpwFs/lOlz2v6H4Eg67yovS1q1rfZD6h3Kst0Pslvtno+25fNfvQalpR9G
         wD+A==
X-Forwarded-Encrypted: i=1; AJvYcCV03xSQrV6ubaoV2aii/fEoP8XZHxmUNO/v4nRPNwlOIqPr00yJl4Y8PEPcuEzQVLJp9lo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnZ0SgXLzNNr6fvsyUDZCjRcBIMa7+H1GzbIGjER6o3ZWrZpyZ
	/dt2BxBYU3p9AxY2b7nu3Ljre8S59F5IkBySIQ7LSISVFuQItZ5Twgs9WCGEbGgbAO2wa/VRzfa
	2+2mUXw==
X-Received: from plbw5.prod.google.com ([2002:a17:902:d3c5:b0:2ad:555b:cb2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1212:b0:2a0:cccf:9d24
 with SMTP id d9443c01a7336-2ad744280cfmr117088455ad.16.1771957225490; Tue, 24
 Feb 2026 10:20:25 -0800 (PST)
Date: Tue, 24 Feb 2026 10:20:23 -0800
In-Reply-To: <20260223215118.2154194-2-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223215118.2154194-1-bvanassche@acm.org> <20260223215118.2154194-2-bvanassche@acm.org>
Message-ID: <aZ3r5_P74tUJm2oF@google.com>
Subject: Re: [PATCH 01/62] kvm: Make pi_enable_wakeup_handler() easier to analyze
From: Sean Christopherson <seanjc@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	linux-kernel@vger.kernel.org, Marco Elver <elver@google.com>, 
	Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>, 
	Jann Horn <jannh@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
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
	TAGGED_FROM(0.00)[bounces-71642-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[16];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,acm.org:email]
X-Rspamd-Queue-Id: E54C318B3B8
X-Rspamd-Action: no action

For the scope, please use:

   KVM: VMX:

On Mon, Feb 23, 2026, Bart Van Assche wrote:
> The Clang thread-safety analyzer does not support comparing expressions
> that use per_cpu(). Hence introduce a new local variable to capture the
> address of a per-cpu spinlock. This patch prepares for enabling the
> Clang thread-safety analyzer.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 4a6d9a17da23..f8711b7b85a8 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -164,6 +164,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  	struct vcpu_vt *vt = to_vt(vcpu);
>  	struct pi_desc old, new;
> +	raw_spinlock_t *wakeup_lock;
>  
>  	lockdep_assert_irqs_disabled();
>  
> @@ -179,11 +180,11 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  	 * entirety of the sched_out critical section, i.e. the wakeup handler
>  	 * can't run while the scheduler locks are held.
>  	 */
> -	raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu),
> -			     PI_LOCK_SCHED_OUT);
> +	wakeup_lock = &per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu);

Addressing this piecemeal doesn't seem maintainable in the long term.  The odds
of unintentionally regressing the coverage with a cleanup are rather high.  Or
we'll end up with confused and/or grumpy developers because they're required to
write code in a very specific way because of what are effectively shortcomings
in the compiler.

> +	raw_spin_lock_nested(wakeup_lock, PI_LOCK_SCHED_OUT);
>  	list_add_tail(&vt->pi_wakeup_list,
>  		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
> -	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +	raw_spin_unlock(wakeup_lock);
>  
>  	WARN(pi_test_sn(pi_desc), "PI descriptor SN field set before blocking");
>  

