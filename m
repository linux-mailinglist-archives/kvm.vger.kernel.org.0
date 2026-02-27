Return-Path: <kvm+bounces-72196-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GNHTC/rUoWlcwgQAu9opvQ
	(envelope-from <kvm+bounces-72196-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:31:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 460E41BB7BE
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:31:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 09BFB301EA06
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69DD43E4AE;
	Fri, 27 Feb 2026 17:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oph6hK87"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E0641323A
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 17:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772213489; cv=none; b=totJIHeoWcU1tAlRC6Chw4bmzFYdEht7kyOTyD1K2kVjPTwzjyepSDphrEEZSfxU2gUx2dNpGheujM5VjgwzmJiAdChQRWY4WoyPKeFE9xNZcm4IBACsypsG8CQTf7csRH/ivvFhlOjhGTPy+b8jBJqEzrIX6w2wZ5rzrm03Yyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772213489; c=relaxed/simple;
	bh=C6T8tz1soUsu6cnsTKtI/JKwGT41nE+6WjgOze/17EM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=edvP/5mIh3s0dQdA8TRPxUR8xg9NOTLQ33J5K/NQ44XK0IdSUsDLP1rPvz1+kfRPqoJJfTIX2Bxm5lD5GkMFDkXLnJZPLddIaOnP7w8AlCcjjURGMkpOjd4xXo3FTIiKds3eR0y2mAXwiMVKk+2M9fF9LUwLhphwG+XFNeGJqgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oph6hK87; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8BCC2BC86
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 17:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772213488;
	bh=C6T8tz1soUsu6cnsTKtI/JKwGT41nE+6WjgOze/17EM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oph6hK87oJSuPRhD/qUxpe/b8Lj/Mjg3hvrURczorg8UiIb5X+noxwcBNrzTmvSJc
	 J6IBgcQP8hgUKkd+dqopg3BLZlqldP+GFOqcpSt7m3UIZ2y4WTl9qyAtLHfdH32tJq
	 /Ve3hDPgTCdOW9W207+5Bi1JWnC9ib6wjdtLWRmH4SsaQDVy8WjTACjhMpRhCUmZhC
	 qUBWozLga+9KYHQYAq9gVk4X66xdcerZchkKh2nG6nLMPt/55q6J2PHczsd70fEr2G
	 92y5mo45jewe2uU4xDU22tTBWIxwt+DhOzeLmJx4x/aP1cv5EBh7V1N904dTFHlNw7
	 W43ZzmuJsJSxA==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b8f8d80faebso552151366b.1
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 09:31:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU91loO7+pHK/X2BhVl6Wltmkc4goBDEwothWBqqXf63MejxvcNJ6AVpmMGWhMxb0KC0BA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzitnjjjbozahK8CSeaIeqHOKihJ88L3pUzwE5MpXnNdhqmbSLI
	d3ODUcWXeybmmb0Y99y272OxJ/uE6G8m6oOSzRf1K7Tt5aQF0L6tY3fJJYKV8gkmQjfuhYDMK+H
	yERfGF1N6wjui8b9PrRHf314RheJgl6Y=
X-Received: by 2002:a17:907:78e:b0:b8f:dec3:6606 with SMTP id
 a640c23a62f3a-b937595fe4bmr211466366b.23.1772213487650; Fri, 27 Feb 2026
 09:31:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260227011306.3111731-1-yosry@kernel.org> <20260227011306.3111731-4-yosry@kernel.org>
 <aaG_o58_0aHT8Xjg@google.com> <aaHHg2-lcpvkejB8@google.com>
In-Reply-To: <aaHHg2-lcpvkejB8@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 27 Feb 2026 09:31:16 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMdyvAJUvnxH0Scb6z3L51Djb1qpMAzX3M9g7hOkB=ZOQ@mail.gmail.com>
X-Gm-Features: AaiRm50LdGDBRhphUfqO8tjiam6xc4hFPaBeXGbA_XGXTLbFbW6mNF4UMfTipAg
Message-ID: <CAO9r8zMdyvAJUvnxH0Scb6z3L51Djb1qpMAzX3M9g7hOkB=ZOQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86: Check for injected exceptions before
 queuing a debug exception
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-72196-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 460E41BB7BE
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 8:34=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Feb 27, 2026, Sean Christopherson wrote:
> > So instead of patch 1, I want to try either (a) blocking KVM_SET_VCPU_E=
VENTS,
> > KVM_X86_SET_MCE, and KVM_SET_GUEST_DEBUG if nested_run_pending=3D1, *an=
d* follow-up
> > with the below WARN-spree, or (b) add a separate flag, e.g. nested_run_=
in_progress
> > or so, that is set with nested_run_pending, but cleared on an exit to u=
serspace,
> > and then WARN on _that_, i.e. so that we can detect KVM bugs (the whole=
 point of
> > the WARN) and hopefully stop playing this losing game of whack-a-mole w=
ith syzkaller.

I like the idea of the WARN there, although something in the back of
my mind tells me I went through this code before with an exception in
mind that could be injected with nested_run_pending=3D1, but I can't
remember it. Maybe it was injected by userspace and all is good.

That being said, I hate nested_run_in_progress. It's too close to
nested_run_pending and I am pretty sure they will be mixed up.

exception_from_userspace's name made me think this is something we
could key off to WARN, but it's meant to morph queued exceptions from
userspace into an "exception_vmexit" if needed. The field name is
generic but its functionality isn't, maybe it should have been called
exception_check_vmexit or something. Anyway..

That gave me an idea though, can we add a field to
kvm_queued_exception to identify the origin of the exception
(userspace vs. KVM)? Then we can key the warning off of that.

We can potentially also avoid adding the field and just plumb the
argument through to kvm_multiple_exception(), and WARN there if
nested_run_pending is set and the origin is not userspace?

> >
> > I think I'm leaning toward (b)?  Except for KVM_SET_GUEST_DEBUG, where =
userspace
> > is trying to interpose on the guest, restricting ioctls doesn't really =
add any
> > value in practice.  Yeah, in theory it could _maybe_ prevent userspace =
from shooting
> > itself in the foot, but practically speaking, if userspace is restoring=
 state into
> > a vCPU with nested_run_pending=3D1, it's either playing on expert mode =
or is already
> > completely broken.
> >
> > My only hesitation with (b) is that KVM wouldn't be entirely consistent=
, since
> > vmx_unhandleable_emulation_required() _does_ explicitly reject a "users=
pace did
> > something stupid with nested_run_pending=3D1" case.  So from that persp=
ective, part
> > of me wants to get greedy and try for (a).
>
> On second (fifth?) thought, I don't think (a) is a good idea.  In additio=
n to
> potentially breaking userspace, it also risks preventing genuinely useful=
 sequences.
> E.g. even if no VMM does so today, it's entirely plausible that a VMM cou=
ld want
> to asynchronously inject an #MC to mimic a broadcast, and that the inject=
ion could
> collide with a pending nested VM-Enter.
>
> I'll send a separate (maybe RFC?) series for (b) using patch 1 as a start=
ing point.
> I want to fiddle around with some ideas, and it'll be faster to sketch th=
ings out
> in code versus trying to describe things in text.

So you'll apply patch 3 as-is, drop patch 2, and (potentially) take
patch 1 and build another series on top of it?

