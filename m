Return-Path: <kvm+bounces-72444-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UP3qCK4hpmlQKwAAu9opvQ
	(envelope-from <kvm+bounces-72444-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:47:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5141E6D3D
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:47:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 036AF3030983
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 23:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14AA834E763;
	Mon,  2 Mar 2026 23:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gFsoPqaW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C2D31F998
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 23:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772495273; cv=none; b=SM9s3wAlMmiVtDXBpzuDceF8sqQXCLT41QNwt7vlJInGnvPAx9P4Cnmmeiv27UitcJbz0pZKQDXcbLQLhIYn/+P0herqEejWVwTvM8q6IWDL2AVtLdV3gNVzfNdo+t4H+HWfLak3oX/5R4+NzojHRMyN3KXxljteS/ToH4MZQu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772495273; c=relaxed/simple;
	bh=gDKf8MkiXtX8fnJadcRrbA6hjhwRgw/jy+uZjd8WTLc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gnN1wfi7w6+BIuPsgo4M9DoLNXmt+E1K96dcN8VTCrkuX6+cTuC1NmKt3wp/zeVb+zaiiiFcJ2xlHY46NnLNfc5+rIx8iHoS4Q0ADFgxj7VKFHzCIzbhwxdoUE0MAKfptO5PRNyhCi6oP7sv/MlEm8Jox/VyH+XQLHVOs/RX3r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gFsoPqaW; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae415b68b1so25122445ad.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 15:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772495271; x=1773100071; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZnHr5TCbnlFoOtgJ9sz2D7mEHmLlKpVEDOL01Ue7p/s=;
        b=gFsoPqaWygogohUAIUwCFgJb5/cTzcLtU+Tp4EGD4YQhypVkhgLpbzZ/BPBTvoGyfs
         tM1Dbrk0SZasXgWUbU9wDa4INwcl6vlZmv38IkNBJbo0chfRccET6J5WaYqK3abtPu7H
         BYIqIpx+rihYteHC0n7sIF+AAcaQLG8tIx2c2ov1t96Y7xx20yrQTjc0wBZgVjrwYD/4
         i2UrCGnNMa/r7jG0YHCswLU9HObUyD6j+3DOCC0zI8yfdVsUH0ZuZOdT6+hAEQgRKToi
         /H7U+kTpxIeAPdskuwsr9YBf/2PzAdEWMxAwL7XnoV/3G62aCDfzSid5f8EzynZzUSZm
         aYwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772495271; x=1773100071;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZnHr5TCbnlFoOtgJ9sz2D7mEHmLlKpVEDOL01Ue7p/s=;
        b=hB1fzq3ARwYWNQTVRnIVFwzyb9BmVwLH4/51P6g7SvIclKkZI9If2xtkqPipXb3zKN
         74Inxbzz4MicQZjvK8RANHbUHy+gQMkQxLhyoHzDz4vTZ8KEzEzsctBm/HT3IKE72Xeg
         jTpoIgNyYk6O1OcTCrybAVFz0FUaG0ueGdhNy4rDCW5mp35M3wL86NtEZlgsgg7ewmbN
         qy7tW2800UN9mNLG83M72DBcai35Q2Khadw8gHtCYENdtrUD2XmV+7hoQOtPMBRuBBcd
         AMsv7rJY83zng2PUTFvBVQ6VfqfAxuPLMM+1vRjIAla9xovnuA72rvmWZkVPTpZGSHPf
         zG9g==
X-Forwarded-Encrypted: i=1; AJvYcCWgEF+x6igYe5YEcxUCNx9jYioc6Q5+IqfHu6J7jhO/NjfTnITRzcH2FLVd+lfa4RIJkho=@vger.kernel.org
X-Gm-Message-State: AOJu0YzH4+zw0AmuLWv/nl8/XeqDh1Nc4XU53pVFIVaB5PYkjnT59dNN
	TOLm4fNhCfeyJahC9ooJUGEz9Lr9WrAE0n3t8l82PHTtICujMiIe6V7gCjSSlwD2JXRw3NH/y55
	3vJbvBg==
X-Received: from plov20.prod.google.com ([2002:a17:902:8d94:b0:2ab:3ae7:5481])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea10:b0:2ae:4f15:1ab6
 with SMTP id d9443c01a7336-2ae4f15218fmr60122995ad.15.1772495271343; Mon, 02
 Mar 2026 15:47:51 -0800 (PST)
Date: Mon, 2 Mar 2026 15:47:49 -0800
In-Reply-To: <CAO9r8zOKUv+FiTN8tKu0dP3x_FiH2xMJBSw5XaJ7=hRmZo+oJw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260227011306.3111731-1-yosry@kernel.org> <20260227011306.3111731-4-yosry@kernel.org>
 <aaG_o58_0aHT8Xjg@google.com> <aaHHg2-lcpvkejB8@google.com>
 <CAO9r8zMdyvAJUvnxH0Scb6z3L51Djb1qpMAzX3M9g7hOkB=ZOQ@mail.gmail.com>
 <aaHf9Lxx8ap_3DRI@google.com> <CAO9r8zOFWHZ5LHRRKL4KU8TctjNs+vQYDr9OoBmao=eG9Q8C2w@mail.gmail.com>
 <aaYbx59lQf5beYSv@google.com> <CAO9r8zOKUv+FiTN8tKu0dP3x_FiH2xMJBSw5XaJ7=hRmZo+oJw@mail.gmail.com>
Message-ID: <aaYhpceF1o0T_r39@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Check for injected exceptions before
 queuing a debug exception
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8F5141E6D3D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72444-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026, Yosry Ahmed wrote:
> On Mon, Mar 2, 2026 at 3:22=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Fri, Feb 27, 2026, Yosry Ahmed wrote:
> > > > > That being said, I hate nested_run_in_progress. It's too close to
> > > > > nested_run_pending and I am pretty sure they will be mixed up.
> > > >
> > > > Agreed, though the fact that name is _too_ close means that, aside =
from the
> > > > potential for disaster (minor detail), it's accurate.
> > > >
> > > > One thought is to hide nested_run_in_progress beyond a KConfig, so =
that attempts
> > > > to use it for anything but the sanity check(s) would fail the build=
.  I don't
> > > > really want to create yet another KVM_PROVE_xxx though, but unlike =
KVM_PROVE_MMU,
> > > > I think we want to this enabled in production.
> > > >
> > > > I'll chew on this a bit...
> > >
> > > Maybe (if we go this direction) name it very explicitly
> > > warn_on_nested_exception if it's only intended to be used for the
> > > sanity checks?
> >
> > It's not just about exceptions though.  That's the case that has caused=
 a rash
> > of recent problems, but the rule isn't specific to exceptions, it's ver=
y broadly
> > Thou Shalt Not Cancel VMRUN.
> >
> > I think that's where there's some disconnect.  We can't make the nested=
_run_pending
> > warnings go away by adding more sanity checks, and I am dead set agains=
t removing
> > those warnings.
> >
> > Aha!  Idea.  What if we turn nested_run_pending into a u8, and use a ma=
gic value
> > of '2' to indicate that userspace gained control of the CPU since neste=
d_run_pending
> > was set, and then only WARN on nested_run_pending=3D=3D1?  That way we =
don't have to
> > come up with a new name, and there's zero chance of nested_run_pending =
and something
> > like nested_run_in_progress getting out of sync.
>=20
> Yeah this should work, the only thing I would change is using macros
> instead of 1 and 2 for readability.

I was "this" close to using a enum or #define, but I couldn't figure out a =
clean
solution to this code:

	vcpu->arch.nested_run_pending =3D
		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);

as I didn't want to end up with effectively:

	if (true)
		x =3D 1;
	else
		x =3D 0;

But thinking more on it, that code is inherently untrusuted, so it can be t=
his:

	if (kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING)
		vcpu->arch.nested_run_pending =3D KVM_NESTED_RUN_PENDING_UNTRUSTED;
	else
		vcpu->arch.nested_run_pending =3D 0;

which is pretty much the same, but at least is a bit more than a convoluted=
 cast
from a bool to an int.

FWIW, I verified this makes the C reproducer happy.

