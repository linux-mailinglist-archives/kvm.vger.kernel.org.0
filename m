Return-Path: <kvm+bounces-71434-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4PriKHL2mGlKOgMAu9opvQ
	(envelope-from <kvm+bounces-71434-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:04:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22E6816B7DC
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:04:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 48C8D3020877
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 00:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89EFE3EBF17;
	Sat, 21 Feb 2026 00:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m/FqtFF6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93822173
	for <kvm@vger.kernel.org>; Sat, 21 Feb 2026 00:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771632218; cv=none; b=dh4o7gtxm0diVqIktCBS/Bu6puNr6paMxEkH8dQ+4IDS11lRgPiOHhC1pbn9C5glJTAcMC62exraXiA5q5ohJvocY/vdW+7+n7kQ7MgMSfS/LRWP/0B+f0u/pdLIJe+YO3W2EIOxejlO06o0ytkoU7iPx2IoHCHOp0UzFXnO3Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771632218; c=relaxed/simple;
	bh=31KWCCX+LvFAIKPRveEEG5uOt1SqC6vbeLFJhD/9wJQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dcbcfc/tPd1+8QYGAPoZbwPIVbKbM8EwALILc3uT5Lw6hXenyLZ31at0AHIlu2KjLp2yh9Lvx55YH0ztGxxE2Jni0rUJ+7BOw/rpMx7c0nTPiat2YfaxJsllSAlvNtB264jKBtyTM7wG+7EIy2TkD5FT6OJvdnJkPuuGM9lfil0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m/FqtFF6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c72d23dfso16264379a91.2
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 16:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771632217; x=1772237017; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=skNLWsBnXFiQIKygICh0qKw/8RYTg3oDn+XJFJ/7bE4=;
        b=m/FqtFF6dyMDVg88kswmpsjdzW0vkSFv3LmejQJ8W87luSmdpmz4RK4jHrvDhb4T+y
         JE1Dtd/XCzj9r2mq0NE9d1iEUm2kjK/DU9+/QMghkQo+lCiYhT1boYkzo3VC/WG9hdfP
         AhxiafGLxdZDjP28Dj3NjrgDSEyYhrp248o+bzhpkKAJsJ3GoikLfCUIbITA/HycvJy1
         BcEc65PFKoEtKoaRGtiHd/Gm52jXW7dR6Ah8vdLr1YgPutKQCl5FBEIIoFWb/EgSZBEx
         rQpsiB4sgf8QHKuIydHotPdYgJxhyrpl/bZkrlJVerYeN1HRPjzS1JwAvvixFDlldUxT
         PfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771632217; x=1772237017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=skNLWsBnXFiQIKygICh0qKw/8RYTg3oDn+XJFJ/7bE4=;
        b=MLFtyJq+jhGTY3anhnK48bMJMDHWH3PdZC4KSJ9APbc3KPkBu0lj755CT++iaklI+3
         P7N+AF94g4Jm6ILyCYmyRBzKwoLjGLbXWdajdZwVxntv2+fKglIa3q9bNxKVGoIxs8Wv
         l7lbMvPlbC7vE9zbC6WLeSpgMfRoA1uaC3apiz2c73mgmyA8/hNB0i7a6Nul47Hv6aH5
         4JMipNNzaOQEwSSJFAHzIxkXW8vQpg2ie30V4/xK9tyeX2eQ38H+HYcW957n8p04hn8n
         ggEwO3KCyLxPkxwhVHNRdmu2IrmctCb+2U3zqW2jWKLwnmrWmU4jr8Pw0Q1ZFK8Goaof
         lRWw==
X-Forwarded-Encrypted: i=1; AJvYcCWa/F/MkCTeU3OeIt4ZrBxKIT7U9GS14dg7SdkU1esgrpGvveiKQgnYS6dtNQBM9Nm9Bqg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDLN3WMBFD25Ya95JXmCSCtbjrPbE/wRJOpyKWPaDyOVTkAmim
	sOGFwsmbSO8/SSzhICXVlrrlvUmexBhCTnMvQVV+iTYXLP4khD3WvdV9Gred/orrX3jQtoN/jcY
	fGelKIw==
X-Received: from pjnx6.prod.google.com ([2002:a17:90a:8a86:b0:354:bcc4:d8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f8c:b0:32b:c9c0:2a11
 with SMTP id 98e67ed59e1d1-358ae7e715amr1143059a91.4.1771632216859; Fri, 20
 Feb 2026 16:03:36 -0800 (PST)
Date: Fri, 20 Feb 2026 16:03:35 -0800
In-Reply-To: <smsla7jgdncodh57uh7dihumnteu5sgxyzby2jc6lcp3moayzf@ixqj4ivmlgb2>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260210005449.3125133-1-yosry.ahmed@linux.dev>
 <20260210005449.3125133-2-yosry.ahmed@linux.dev> <aYqOkvHs3L-AX-CG@google.com>
 <4g25s35ty23lx2je4aknn6dg4ohviqhkbvvel4wkc4chhgp6af@kbqz3lnezo3j>
 <aYuE8xQdE5pQrmUs@google.com> <ck57mmdt5phh64cadoqxylw5q2b72ffmabmlzmpphaf27lbtxw@4kscovf6ahve>
 <aYvIpwjsJ50Ns4ho@google.com> <mxn6y6og34ejncnsvdapcoep4ewcnwnheszhwkp2undkqcu5zv@bpmseexuug5z>
 <aYvPwH8JcRItaQRI@google.com> <smsla7jgdncodh57uh7dihumnteu5sgxyzby2jc6lcp3moayzf@ixqj4ivmlgb2>
Message-ID: <aZj2V9-noq10b5CM@google.com>
Subject: Re: [PATCH 1/4] KVM: nSVM: Sync next_rip to cached vmcb12 after VMRUN
 of L2
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71434-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 22E6816B7DC
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Yosry Ahmed wrote:
> > > > > > +       u8 __vmcb12_ctrl[sizeof(struct vmcb_ctrl_area_cached)];
> > > > > 
> > > > > We have a lot of accesses to svm->nested.ctl, so we'll need a lot of
> > > > > clutter to cast the field in all of these places.
> > > > > 
> > > > > Maybe we add a read-only accessor that returns a pointer to a constant
> > > > > struct?
> > > > 
> > > > That's what I said :-D
> > > > 
> > > > 	* All reads are routed through accessors to make it all but impossible
> > > > 	* for KVM to clobber its snapshot of vmcb12.
> > > > 
> > > > There might be a lot of helpers, but I bet it's less than nVMX has for vmcs12.
> > > 
> > > Oh I meant instead of having a lot of helpers, have a single helper that
> > > returns it as a pointer to const struct vmcb_ctrl_area_cached? Then all
> > > current users just switch to the helper instead of directly using
> > > svm->nested.ctl.
> > > 
> > > We can even name it sth more intuitive like svm_cached_vmcb12_control().
> > 
> > That makes it to easy to do something like:
> > 
> > 
> > 	u32 *int_ctl = svm_cached_vmcb12_control(xxx).
> > 
> > 	*int_ctl |= xxx;
> > 
> > Which is what I want to defend against.
> 
> Do compilers allow implicit dropping of const qualifiers?

Nope, not with the kernel's build flags.

> Building with this diff fails for me:
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index de90b104a0dd..0a73dd8f9163 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1343,10 +1343,17 @@ static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
>         nested_svm_simple_vmexit(to_svm(vcpu), SVM_EXIT_SHUTDOWN);
>  }
> 
> +static const struct vmcb_ctrl_area_cached *svm_cached_vmcb12_control(struct vcpu_svm *svm) {
> +       return &svm->nested.ctl;
> +}

...

> Is this sufficient?

It's certainly better, but unless a sea of helpers is orders of magnitude worse,
I would prefer to make it even harder to put hole in our foot.

E.g. unless we're hyper diligent about constifying everything, it's not _that_
hard to imagine a chain of events where we end up with a "live" pointer to the
cache.

  1. A helper like __nested_vmcb_check_controls() isn't const, so we cast to strip
     the const.

  2. Someone "improves" the code by grabbing the non-const variable to pass it
     into other helpers.

  3. The non-const variable is used to update the cache for whatever reason, and
     it works 99.9% of the time, until it doesn't.

Now, I don't think that's at all likely to happen, but as the years pile on and
developers come and go, the probability of introducing a goof goes up, bit by bit.

> > > > > I think this will be annoying when new fields are added, like
> > > > > insn_bytes. Perhaps at some point we move to just serializing the entire
> > > > > combined vmcb02/vmcb12 control area and add a flag for that.
> > > > 
> > > > If we do it now, can we avoid the flag?
> > > 
> > > I don't think so. Fields like insn_bytes are not currently serialized at
> > > all. The moment we need them, we'll probably need to add a flag, at
> > > which point serializing everything under the flag would probably be the
> > > sane thing to do.
> > > 
> > > That being said, I don't really know how a KVM that uses insn_bytes
> > > should handle restoring from an older KVM that doesn't serialize it :/
> > > 
> > > Problem for the future, I guess :)
> > 
> > Oh, good point.  In that case, I think it makes sense to add the flag asap, so
> > that _if_ it turns out that KVM needs to consume a field that isn't currently
> > saved/restored, we'll at least have a better story for KVM's that save/restore
> > everything.
> 
> Not sure I follow. Do you mean start serializing everything and setting
> the flag ASAP (which IIUC would be after the rework we discussed), 

Yep.

> or what do you mean by "add the flag"?




