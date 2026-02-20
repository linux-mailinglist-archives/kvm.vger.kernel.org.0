Return-Path: <kvm+bounces-71427-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oLCHJ1jlmGn3NwMAu9opvQ
	(envelope-from <kvm+bounces-71427-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 23:51:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 18DCA16B545
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 23:51:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DD46E30479E6
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 22:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185F2314D23;
	Fri, 20 Feb 2026 22:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uzUZ/aPt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DE726FA6F
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 22:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771627844; cv=none; b=oS2fHTQltzAiST7U0/CQ8+b8uvKNoHJkmd1A0gK9rwkr55vXY80h3SFmdCqP+13NM2bHyHGQc+XFr2XEM7uPBTe1TO9IGdrA2HjAOlHs7/ry5t274XxRwKKzvtIImJqk/PmCBaCYz8JUMlscQ/l2V9P8jwV6RHAd9/4vpKfLA3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771627844; c=relaxed/simple;
	bh=qzwRSg/0qiM+uFnL9N0cgsRichbx7RIiySSaOZBvyzA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hvkXkmKvzk0Ozi/Fuyu2ZvjEVjKAr/hml4TF4SzUVNZVtsgXFuBE54jjJsYj73tnKEoLQ90Hnvb0S7EyHSvpbAPFjR4R5Tbh4Oq1dXtUxqCl80oxG6ICLKKZNdS2lQUEYmN+lZBMIZgmmzmJPq9xoJrh6un29xnPINL9zRqh0Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uzUZ/aPt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35464d7c539so2468335a91.0
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 14:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771627842; x=1772232642; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m5mAyXEtpJDZOMbQ8H4xlAjFOU8f1VLCaYwlzDPl6V8=;
        b=uzUZ/aPtgHh/aQvkK5LaKr78joYl0WyVIZxwvBHU6QgOyRvnW9FY8qMycUS10ywqHr
         SPIS2II/wKsLIRGSC4ksa2HjmD3nCTaAkP2und6pI8rFrZ5mM0ZvB7zaajrpnUbWsUjO
         PlYbUjGnXnxB50AWLAGQo1rEztCXoDg/cD0NQW2dOWLl1SYOhH+6BGh4QRYAgoPukKbq
         rZtxZpN1nuhiqITxhD02lg9Cv7IUvg4+ur3c0vrPdTaPxGpi4SxHUjqoRdGkVfIUnsfr
         9M/FOJJM6TBPCleXI+n4GK9YOBvRcYTHYHuKnyblu5W8GAgAS0hJ58xOCz3HFH1+jwQ5
         nuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771627842; x=1772232642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m5mAyXEtpJDZOMbQ8H4xlAjFOU8f1VLCaYwlzDPl6V8=;
        b=aSQaPtl6pIms57XiuipPevrGgp1fd/nPLn1aPhPDMooN8rzYcKUfzdx88h11597eSV
         jhdGrGHO6y6nqzOpIRrch+U+kHCmUKq8nPw+0EF4mvg+Qbo3U4nPUxVNgFttY7IvidRQ
         +VfwNAcl3ACbaJwWO6kX7ZkjPcPTz2iMWnjJsyxcrEDLNy9maclvg3hJVVcN7ge7AmEv
         g+tOzYu6FtOe3jjmLjrpUWiyLIgcCD+f0uBVwSQxTEtWVych1XQVun9dezKKnFLQHcfX
         OPSnjRHciybtvF4vx0uppHfayyXJmbg/XuLu65vy5NDyIDbhD0krT+U3TF0EOwGL0pGG
         vrSA==
X-Forwarded-Encrypted: i=1; AJvYcCXLWKgyP9Yyc+9pxcCcF9KxulyOvKrtcVir+gH/wFmc5TkyDKFr6aK/BxiITQFgeJN6Wqs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4gqYG62a9mPZRsBynTyTi1oqKpE4kgGTZjnRKIe/FDLhqOfOY
	WDF7TpKxKr83zyJQDj112BYq3ooGzni8oR9PN/RLitfCm+TNQaYzUzgJCQzeHOr8BAp9JBWuOk/
	haDALRg==
X-Received: from pjx16.prod.google.com ([2002:a17:90b:5690:b0:34c:3879:557a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f07:b0:354:be2e:c05c
 with SMTP id 98e67ed59e1d1-358ae8123f9mr1175236a91.14.1771627841902; Fri, 20
 Feb 2026 14:50:41 -0800 (PST)
Date: Fri, 20 Feb 2026 14:50:40 -0800
In-Reply-To: <unqj7mrl5j2feevcuwfpiurhtzppbdn7b5gimlalvunv3bx25y@5ko7vwgzxxdw>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212230751.1871720-1-yosry.ahmed@linux.dev>
 <20260212230751.1871720-5-yosry.ahmed@linux.dev> <aZZVqQrQ1iCNJhJJ@google.com>
 <wwa2h5gcb7gfxgmsh3jdwa4d4xurkmgd26dnkwupgzcln3khfu@v3w2w6nf4tq7>
 <aZiUxBRPovFd4nDd@google.com> <unqj7mrl5j2feevcuwfpiurhtzppbdn7b5gimlalvunv3bx25y@5ko7vwgzxxdw>
Message-ID: <aZjlQGmYT4ufduOT@google.com>
Subject: Re: [RFC PATCH 4/5] KVM: SVM: Recalculate nested RIPs after restoring REGS/SREGS
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71427-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 18DCA16B545
X-Rspamd-Action: no action

On Fri, Feb 20, 2026, Yosry Ahmed wrote:
> > > >         svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
> > > >         if (is_evtinj_soft(vmcb02->control.event_inj)) {
> > > >                 svm->soft_int_injected = true;
> > > > -               svm->soft_int_csbase = vmcb12_csbase;
> > > > -               svm->soft_int_old_rip = vmcb12_rip;
> > > > +
> > > >                 if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> > > >                         svm->soft_int_next_rip = svm->nested.ctl.next_rip;
> > > 
> > > Why not move this too?
> > 
> > For the same reason I think we should keep 
> > 
> > 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> > 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> > 
> > where it is.  When NRIPS is exposed to the guest, the incoming nested state is
> > the one and only source of truth.  By keeping the code different, we'd effectively
> > be documenting that the host.NRIPS+!guest.NRIPS case is the anomaly.
> 
> I see, makes sense. I like the fact that we should be able to completely
> drop vmcb12_rip and vmcb12_csbase with this (unless we want to start
> using it for the bus_lock_rip check), which will also remove the need
> for patch 2.

...

> It seems a bit fragile that the 'if' is somewhere and the 'else' (or the
> opposite condition) is somewhere else. They could get out of sync. 

> Maybe
> a helper will make this better:
> 
> /* Huge comment */
> bool nested_svm_use_vmcb12_next_rip(struct kvm_vcpu *vcpu)
> {
> 	return guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
> 		!svm->nested.nested_run_pending;
> }
> 
> or maybe the name makes more sense as the negative:
> nested_svm_use_rip_as_next_rip()?
> 
> I don't like both names..
> 
> Aha! Maybe it's actually better to have the helper set the NextRip
> directly?
> 
> /* Huge comment */
> u64 nested_vmcb02_update_next_rip(struct kvm_vcpu *vcpu)
> {
> 	u64 next_rip;
> 
> 	if (WARN_ON_ONCE(svm->vmcb != svm->nested.vmcb02.ptr))
> 		return;
> 
> 	if (!boot_cpu_has(X86_FEATURE_NRIPS))
> 		return;
> 
> 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
> 	    !svm->nested.nested_run_pending)
> 	    	next_rip = svm->nested.ctl.next_rip;
> 	else
> 		next_rip = kvm_rip_read(vcpu);
> 
> 	svm->vmcb->control.next_rip = next_rip;
> }
> 
> Then, we just call this from nested_vmcb02_prepare_control() and
> svm_vcpu_run() (with the soft IRQ stuff). In some cases we'll put the
> wrong thing in vmcb02 and then fix it up later, but I think that's fine
> (that's what the patch is doing anyway).
> 
> However, we lose the fact that the whole thing is guarded by
> nested_run_pending, so performance in svm_vcpu_run() could suffer. We
> could leave it all guarded by nested_run_pending, as
> nested_vmcb02_update_next_rip() should do nothing in svm_vcpu_run()
> otherwise, but then the caller is depending on implementation details of
> the helper.
> 
> Maybe just put it in svm_prepare_switch_to_guest() to begin with and not
> guard it with nested_run_pending?

Of all the options, I still like open coding the two, even though it means the
"else" will be separated from the "if", followed by the
nested_svm_use_vmcb12_next_rip() helper option.   I straight up dislike
nested_vmcb02_update_next_rip() because it buries simple concepts behind a
complex function (copy vmcb12->next_rip to vmcb02->next_rip is at its core a
*very* simple idea).  Oh, and it unnecessarily rewrites vmcb02->next_rip in the
common case where the guest has NRIPs.

I'm a-ok with the separate "if" and "else", because it's not a pure "else", and
that's the entire reason we have a mess in the first place: we wrote an if-else,
but what is actually necessitate by KVM's uAPI is two separate (but tightly
coupled) if-statements.

