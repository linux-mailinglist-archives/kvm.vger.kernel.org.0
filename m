Return-Path: <kvm+bounces-71572-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8CWiELH+nGnhMQQAu9opvQ
	(envelope-from <kvm+bounces-71572-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:28:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 68E33180794
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:28:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5C8AB3009E25
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 028B423C8AE;
	Tue, 24 Feb 2026 01:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jqwA3zQY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9A370810
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 01:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771896478; cv=none; b=QB92xXusOkPfDCcMf4mtcYvaaq0lL5iGZrABWAvot6U6VzQTMdrhlRqaVQTMBvQJt91Md1nCB1SH6xmKUiR8lUrr5sfbJwbvBfeG0kB8Ow7LvLYKvGOAeCfAgPN6XXbRQ7T2HaJ/X4k9OMOl5ivx0Nw1ldZQYNNVRr44gXP6mTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771896478; c=relaxed/simple;
	bh=vvdEvLfoWawoL6K+kTA9bEko7R7Ro3WCOIidwUL60Mo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E9paKCt1PKFMYr00cGR38+UnVMsTr4uEuc4Trm5isI4+bIaptFk1OrxLvsuRxTVb91O14f8c4oMYT6S6iubu4WcfYxhEU7BebJ0IQzTPI3yEf/pjfKkJRDVPlj9tAL2xL7ExQnEqD2SZhwlRgfWvcBnPjyCO7cQgHCsSnVAFg7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jqwA3zQY; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6de1ee12a3so3354026a12.2
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 17:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771896475; x=1772501275; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=imQRkcmOy4DPdumAym14O8Grk4dKcX7e7AP+6BT4u5Y=;
        b=jqwA3zQYt/wuT5YntfNvrapgTe/b6tzqNv0WGhLFaMVXR3JiRJ2anubQh49f0P8Gd5
         f0kpUEWwwMXZzXzITGyjau64nQOVpT3zwJ7bywKuoEzuK+LypjSCmyDaVvNil1xbYg/q
         BOgvot4u9fVFsm+n4LzgIQkbz7eYjbK74OnAvL7s362NCgt6dTQUwctV2WtT1Db4Ouo6
         6kJvbrkTNlRkwQGwn5BBt7VXDsbfS2pW7Ci6XgGBGZqCeiVKisBM9LP/D9gf3BECWDWy
         4bmeTa9eArA9GK6gIIPtIX70iDblaFnkOHP2IJhIEYutbl4fmlrwnXfzpaVNZo5oUUts
         3Bbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771896475; x=1772501275;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=imQRkcmOy4DPdumAym14O8Grk4dKcX7e7AP+6BT4u5Y=;
        b=I+1KO2wj1E8cz6E3FKNIi5Sbnk/P9LB5m54muQmNCxlEjRI9ECRcIRa4tygruiMLcS
         GlQ4rFgQ/a+RCTKUvtoKlrfGiSpQHxYUm26bqB34qHvxrmvyo2SnlFvmD9xX4sfATofQ
         gOrOUkvpyp9t2Zi6tzVZsoLih8WgqZLzdtrL4usas9JLHz6ktziXmy9aKE7zuXuuI0nR
         E8IoBIgZnyIN8eHTcexWRBgWI6HtJodEa42Ho0daa4pKmND6d1OJHq79ptRlBvbZWY9Q
         +fa2rSeefUu+EcWyezd4heNEA0ZzOQUpmCnPPbmiFyzdjcqtQ2sS9BzGLC4kWThPgHYq
         Dm3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUS4NZ9XVg0uaKrgOhRlP7mYxli1FiyO2EGGX79dTHUXOCG4GfgVwQn71/qefosAmCLt4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsT8tZMnhn+RU0R/lJ5pJwVqrBjDut4E84iRnsPWUaYI1EmV+5
	NtARYLBCrK25kDSlHVlyccs/aYyD1YOwQygVlDARb4YgznB9VOjYW+uzdxYdRxMljh7QAJOu4B7
	OrMF/cA==
X-Received: from pgbfp12.prod.google.com ([2002:a05:6a02:2cec:b0:c52:a841:c79d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:748b:b0:38b:e55a:97c9
 with SMTP id adf61e73a8af0-39545ebb1b9mr8817920637.28.1771896475278; Mon, 23
 Feb 2026 17:27:55 -0800 (PST)
Date: Mon, 23 Feb 2026 17:27:54 -0800
In-Reply-To: <CAO9r8zP1hwzgX3iXDu3TuYQAiqdKrSOw6yuLL+PQFwm=CH0Lug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260206190851.860662-1-yosry.ahmed@linux.dev>
 <20260206190851.860662-26-yosry.ahmed@linux.dev> <aZzfhY1qigh71n2e@google.com>
 <CAO9r8zP1hwzgX3iXDu3TuYQAiqdKrSOw6yuLL+PQFwm=CH0Lug@mail.gmail.com>
Message-ID: <aZz-muXa7RgSR1Ul@google.com>
Subject: Re: [PATCH v5 25/26] KVM: nSVM: Sanitize control fields copied from VMCB12
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
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
	TAGGED_FROM(0.00)[bounces-71572-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 68E33180794
X-Rspamd-Action: no action

On Mon, Feb 23, 2026, Yosry Ahmed wrote:
> > > @@ -499,32 +499,35 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
> > >       if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NPT))
> > >               to->misc_ctl &= ~SVM_MISC_ENABLE_NP;
> > >
> > > -     to->iopm_base_pa        = from->iopm_base_pa;
> > > -     to->msrpm_base_pa       = from->msrpm_base_pa;
> > > +     /*
> > > +      * Copy the ASID here because nested_vmcb_check_controls() will check
> > > +      * it.  The ASID could be invalid, or conflict with another VM's ASID ,
> >
> > Spurious space before the command.
> >
> > > +      * so it should never be used directly to run L2.
> > > +      */
> > > +     to->asid = from->asid;
> > > +
> > > +     /* Lower bits of IOPM_BASE_PA and MSRPM_BASE_PA are ignored */
> > > +     to->iopm_base_pa        = from->iopm_base_pa & PAGE_MASK;
> > > +     to->msrpm_base_pa       = from->msrpm_base_pa & PAGE_MASK;
> > >>      to->tsc_offset          = from->tsc_offset;
> > > -     to->tlb_ctl             = from->tlb_ctl;
> >
> > I don't think we should completely drop tlb_ctl.  KVM doesn't do anything with
> > vmcb12's tlb_ctl only because we haven't addressed the TODO list in
> > nested_svm_transition_tlb_flush().  I think I would rather update this code to
> > sanitize the field now, as opposed to waiting until we address that TODO.
> >
> > KVM advertises X86_FEATURE_FLUSHBYASID, so I think we can do the right thing
> > without having to speculate on what the future will bring.
> >
> > Alternatively, we could add a TODO here or update the one in
> > nested_svm_transition_tlb_flush(), but that seems like more overall work than
> > just hardening the code.
> 
> I will drop the ASID change.
> 
> I honestly don't know where to draw the line at this point. Should I
> split sanitizing all different fields into different patches? Or just
> split the tlb_ctl change? What about the I/O and MSR bitmap change?

FWIW, my rule of thumb is that, when writing the changelog, if I find myself
either (a) having to explain mostly unrelated things or (b) generalizing away
details, then I should split the patch.

In this case, I would do:

  1. int_ctl and friends
  2. tlb_cnt (with a changelog explaining why we're keeping it even though it's unused)
  3. ~0xfffull => PAGE_MASK cleanup
  4. ASID comment

Though honestly, I would drop the ASID change.  The comment is misleading and
arguably flat out wrong.  This

  The ASID could be invalid, or conflict with another VM's ASID, so it should
  never be used directly to run L2.

isn't why KVM musn't use the ASID from vmcb12 verbatim, the real reason is that
the ASID space managed by KVM is logical different than the one managed by L1.
I.e. KVM needs to shadow L1's ASID space, for all intents and purposes.  And so
KVM should never use vmcb12's ASID verbatim because it needs to be "translated".

