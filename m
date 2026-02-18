Return-Path: <kvm+bounces-71298-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2E9CGNhJlmngdQIAu9opvQ
	(envelope-from <kvm+bounces-71298-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:23:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BDB9515AE8A
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:23:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EAC0D3036380
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4716033ADA3;
	Wed, 18 Feb 2026 23:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OmEFCEVr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235FA33AD99
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456967; cv=none; b=kbK8Vy5M67iJIvrhbVlQLv1/VotjQd7PAh643fWEWYEEQ15ooPFBfrxOSz2o4TdQCit0rJ5HFrYfXRIgdBW+UZ6e2TxRzTm/F8VXvaJ1QGnpNP4jbr/sAFGk9YPgeIE72YveNh1vGGpQUWfnp++6lUMt5+DXFlVJQyBqSuXaM3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456967; c=relaxed/simple;
	bh=ak+Fjrc8c6aDkTgBoI7fd+2k7yh8dnyTxfOcRaoQ/ok=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YXyHfnXWl/IG+5/QjJT+gJ0sVKKyciwF+1O8AhSkEPGCxhxIJCPMZAmMRrZqM+VI3G6SAIfjy/HgZkWbc8bnGiF2Jdc40ttZ3Fg2K3zQqwm/5V6OxYxXCSrAtdHjoMOf23bqOnQQ3si3aw4TTVnT3YgvHqFxMVCDUd+xHR1Jb3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OmEFCEVr; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6e1dab2235so155903a12.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 15:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771456965; x=1772061765; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3oBGE3p/lhKaQkwFweneW6rHkdciCRGmOksHejZJMmw=;
        b=OmEFCEVrDaO/oYez2gF5z+P+oStD3Owr3qDvDMp16rkyf7MKJ9dZH9yqzfow86Hek7
         kLu5bVHuEwrXvzV82LNSipzMdOMyHsc3VUI0jWXA5l/JHoKBK9ze6+uFCtE5sbhKp/3Q
         myxjzVNH+vPNEyD9YaC5VlLq15fLBKiLTtGcuxfWAHlWzewJSxpRNQvr1HQzqr0TmisU
         M6SiGz3sIyehWOp4cACokHswIlEm7hCZTvBmI5UddkMduxGYQhalQovS1QlYqgacaeKq
         X6qQKXfMbQMv0GUtmIl6h91PBwDFXBJADgn7JS7yZqkHXwVZsNRbMallFNk4EybddGGQ
         5tCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771456965; x=1772061765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3oBGE3p/lhKaQkwFweneW6rHkdciCRGmOksHejZJMmw=;
        b=fpZvs/wU9H9r3VFVx20BhjFBZZdptaA1FQcyelSlh2rKf4wQenrw96LvZI/PpXQZyO
         5AnSvaVjYs2eglNVGtSYWI8KC+N5aaK5gpN/6oQu9LOEfoMEHczUiK/heU3bZ/zaJ3aY
         QAqljJHMuwJN1v+86pmVh8a2M9GDfAON9jJ1emmae8GHUNJZqE/a4MBxTnCapW9aftll
         XvUtK8sV8hls8WudW7oFXT/GdWBG/PeMwqh/OG53Jyrml1fjsaGstQLIckxwJ4o6XOZS
         4QqpyivqkKOdwPBp46PZIwCV89pBuTwO2LZwGOIyV2ceOmpn7l17DZBcjcU9xg4A0VI2
         crBg==
X-Forwarded-Encrypted: i=1; AJvYcCV1VmJtFtwVrzamhGJslO64flO9KBqD9zeFs9QNADTEztp6kBXCI4W/pGkXcQRzM/ccmAs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr/ygYmHm8JXsKeE3Qp+uplmGPuttErzZNTRDcCimed0IqQoA3
	aJFdVB4byDrH4jSNVuhEkZc4JbJPu0mPVaE3Ef3/Zd7lRVrrgYKT2bvRBrNrTOJJTlVmn5xHfdc
	BlgS6hw==
X-Received: from pgc10.prod.google.com ([2002:a05:6a02:2f8a:b0:b98:d6e8:a405])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6b0d:b0:394:594c:1ab6
 with SMTP id adf61e73a8af0-39512210c2dmr614317637.59.1771456965343; Wed, 18
 Feb 2026 15:22:45 -0800 (PST)
Date: Wed, 18 Feb 2026 15:22:44 -0800
In-Reply-To: <20260212230751.1871720-2-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212230751.1871720-1-yosry.ahmed@linux.dev> <20260212230751.1871720-2-yosry.ahmed@linux.dev>
Message-ID: <aZZJxDVK4ekHxaLb@google.com>
Subject: Re: [RFC PATCH 1/5] KVM: nSVM: Do not use L2's RIP for vmcb02's
 NextRIP after first L2 VMRUN
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
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
	TAGGED_FROM(0.00)[bounces-71298-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: BDB9515AE8A
X-Rspamd-Action: no action

On Thu, Feb 12, 2026, Yosry Ahmed wrote:
> For guests with NRIPS disabled, L1 does not provide NextRIP when running
> an L2 with an injected soft interrupt, instead it advances L2's RIP
> before running it. KVM uses L2's RIP as the NextRIP in vmcb02 to emulate

Should "L2's RIP" be "vmcb12's RIP"?  The "L2's RIP" terminology gets really
confusing in the next paragraph, as NextRIP _is_ L2's (Next)RIP.  Hmm, or maybe
"current RIP"?  I.e. "current RIP" vs. "NextRIP"?

> a CPU without NRIPS.
> 
> However, after L2 runs the first time, NextRIP will be updated by the
> CPU and/or KVM, and L2's RIP is no longer the correct value to use in
> vmcb02. Hence, after save/restore, do not use L2's RIP if a nested run
> is not pending (i.e. L2 has run at least once), use the NextRIP value.

Too many negatives in this last sentence, it can just be (I think):

  Hence, after save/restore, use the current RIP if and only if a nested
  run is pending, otherwise use NextRIP.

> Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
> CC: stable@vger.kernel.org
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index de90b104a0dd..eebbe00714e3 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -844,14 +844,18 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
>  
>  	/*
> -	 * next_rip is consumed on VMRUN as the return address pushed on the
> +	 * NextRIP is consumed on VMRUN as the return address pushed on the
>  	 * stack for injected soft exceptions/interrupts.  If nrips is exposed
> -	 * to L1, take it verbatim from vmcb12.  If nrips is supported in
> -	 * hardware but not exposed to L1, stuff the actual L2 RIP to emulate
> -	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
> -	 * prior to injecting the event).
> +	 * to L1, take it verbatim from vmcb12.
> +	 *
> +	 * If nrips is supported in hardware but not exposed to L1, stuff the
> +	 * actual L2 RIP to emulate what a nrips=0 CPU would do (L1 is
> +	 * responsible for advancing RIP prior to injecting the event). This is
> +	 * only the case for the first L2 run after VMRUN. After that (e.g.
> +	 * during save/restore), NextRIP is updated by the CPU and/or KVM, and
> +	 * the value of the L2 RIP from vmcb12 should not be used.
>  	 */
> -	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) || !svm->nested.nested_run_pending)

This is technically wrong since KVM doesn't require NRIPS.  Maybe this?

	if (boot_cpu_has(X86_FEATURE_NRIPS)) {
		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
		    !svm->nested.nested_run_pending)
			vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
		else
			vmcb02->control.next_rip    = vmcb12_rip;
	}
	

>  		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
>  	else if (boot_cpu_has(X86_FEATURE_NRIPS))
>  		vmcb02->control.next_rip    = vmcb12_rip;
> -- 
> 2.53.0.273.g2a3d683680-goog
> 

