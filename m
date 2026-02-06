Return-Path: <kvm+bounces-70385-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kIfbIAA0hWlg+AMAu9opvQ
	(envelope-from <kvm+bounces-70385-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 01:21:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E816F891F
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 01:21:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8EE01301F302
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 00:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BAC1207A20;
	Fri,  6 Feb 2026 00:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iEht5Ooa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08131E2858
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 00:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770337267; cv=none; b=IfiLXoGLMA0/lcgZnjvl8B9d9LWWfmWipFlgdxQe81eIE1YESUj2oo4pbaueO6amE2rUHJ0vI8+fDHxAtL+M1vcEjDifIESol15BJA9fES1ZgDc2+YwVxzB3F/2uQB5pWEm+JvdEYJXHq2QuYYwtF/eUW76UU/Z9BpOnm5GZSMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770337267; c=relaxed/simple;
	bh=BMmtCfVRs1JPSbChskF7MjSxHKDnG4eHrpYBfP/uvUo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jhjgLx6pNnxp6dB7r+e0alESddAgzcHVMaZDb+YENno5wrEY8axb+ScNqQIFtWVagK2cYw7vQ7jZZsf90LJFzPkTuDdW3Qme+dJgF5CwJoMGGs8ZPzIdhQ0esqWjDyIsqvVY2wkj4N25m95lIUhGsZyiCSw03/DpZzxN9gUF7Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iEht5Ooa; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a7701b6353so1269455ad.3
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 16:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770337267; x=1770942067; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6/R82b6ipXP3HjFMLNNSmPnXxmBZeRjO/OvuTWlHcV8=;
        b=iEht5OoaUlJrdja2yTrQqBwvbpM52Vi6GZFujOZp1x+Uze8DNv/8IQHr5eIJ/yLbKT
         aoY2VilIlqrcncoolu4r0FxIl179P6bwzvsuW0I3O4gyUbvYBSK+nNSCwv6wPZVZdxK+
         Sz9yUE0rRzdVqbwDSLcArjCR76VdCYzvGI0gfriXlb3Jf7R6mB4HF3M2wKygzx/HQO98
         ljwooa8NSdqx+c+lP69ylLG46hAw7wOIHmI+S6NjLpPxDsXpeIB/VbjU4ST8TQZtdgcf
         WNmfu/LKUp4P6dC6cxM+vox50JYbQf0EYFfFzSTYAIuRbzy1tSYVkxkDNA+SHLm1CwzM
         5iGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770337267; x=1770942067;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6/R82b6ipXP3HjFMLNNSmPnXxmBZeRjO/OvuTWlHcV8=;
        b=EJ2NfI6YftWW8B2xPKfjIEEtAgv5IZ2QbIw1/kLpibxdTU+nKGfDKwQNblzOfG6Tns
         0A2n2Ond909GHDL1CCVhh6mbQ0jYvYA8HH0aeHElG0KJiM/LVVUt88naTIPFRjZ2YN+o
         KTFJGkM7O2fxkPyYxzogyF9amj8jj9N29iNzPbRBgZuKtFpwN8pdDqCMH/q6f6BwsTDw
         /Htd4XEryLBXsf4p9/B9viY0UMvr4inKlEs5b7S4wvAxfpm6b8m6AnSEW09DVDG63s5G
         IVGWSF/CbNYysEZO7paqZSzBH2SyAqwR1tIASbb77En5fOVDN3DbVlSB3ngPi39y377z
         G5gA==
X-Forwarded-Encrypted: i=1; AJvYcCV1vb0wVLvi7STgblcfWgHCmgTHsVAs2HDe+MqJm1dd0LHXN8gPqqy+neWlYi+D0sGpZXI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxA/OZuvQYG7k3DJxSMHKspYr2eA3YWQb9LS+37OUssnoKNX5Jp
	IVoPuLbZSxf++eGdt523mQF89T77l2UDPudCJy2SCDSz3Js4kLXnNo7T+xSKlY+RIa7F5U76PWr
	l+ZG/7g==
X-Received: from plly21.prod.google.com ([2002:a17:902:7c95:b0:298:1181:b342])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:40d2:b0:2a3:e6fa:4a06
 with SMTP id d9443c01a7336-2a9516f5730mr9130835ad.39.1770337267113; Thu, 05
 Feb 2026 16:21:07 -0800 (PST)
Date: Thu, 5 Feb 2026 16:21:05 -0800
In-Reply-To: <CAE6NW_YexKSp19uATMQschZbbvon=Cdhv4EH6tRf-FNzgtL6ew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121004906.2373989-1-chengkev@google.com> <20260121004906.2373989-2-chengkev@google.com>
 <aXFOPP3P-HE6YbEZ@google.com> <sdyb3l4ihmcd7uxb6wivkyknmzy4bcctqyyidxq7hr2d2jfs6e@iz3fhfp6t4ss>
 <aXov3WWozd2UIFXw@google.com> <CAE6NW_YexKSp19uATMQschZbbvon=Cdhv4EH6tRf-FNzgtL6ew@mail.gmail.com>
Message-ID: <aYUz8Ur91l7MyCK7@google.com>
Subject: Re: [PATCH 1/3] KVM: SVM: Fix nested NPF injection to set PFERR_GUEST_{PAGE,FINAL}_MASK
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
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
	TAGGED_FROM(0.00)[bounces-70385-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 2E816F891F
X-Rspamd-Action: no action

On Wed, Feb 04, 2026, Kevin Cheng wrote:
> On Wed, Jan 28, 2026 at 10:48=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Jan 22, 2026, Yosry Ahmed wrote:
> > > On Wed, Jan 21, 2026 at 02:07:56PM -0800, Sean Christopherson wrote:
> > > > On Wed, Jan 21, 2026, Kevin Cheng wrote:
> > > > > When KVM emulates an instruction for L2 and encounters a nested p=
age
> > > > > fault (e.g., during string I/O emulation), nested_svm_inject_npf_=
exit()
> > > > > injects an NPF to L1. However, the code incorrectly hardcodes
> > > > > (1ULL << 32) for exit_info_1's upper bits when the original exit =
was
> > > > > not an NPF. This always sets PFERR_GUEST_FINAL_MASK even when the=
 fault
> > > > > occurred on a page table page, preventing L1 from correctly ident=
ifying
> > > > > the cause of the fault.
> > > > >
> > > > > Set PFERR_GUEST_PAGE_MASK in the error code when a nested page fa=
ult
> > > > > occurs during a guest page table walk, and PFERR_GUEST_FINAL_MASK=
 when
> > > > > the fault occurs on the final GPA-to-HPA translation.
> > > > >
> > > > > Widen error_code in struct x86_exception from u16 to u64 to accom=
modate
> > > > > the PFERR_GUEST_* bits (bits 32 and 33).
> > > >
> > > > Please do this in a separate patch.  Intel CPUs straight up don't s=
upport 32-bit
> > > > error codes, let alone 64-bit error codes, so this seemingly innocu=
ous change
> > > > needs to be accompanied by a lengthy changelog that effectively aud=
its all usage
> > > > to "prove" this change is ok.
> > >
> > > Semi-jokingly, we can add error_code_hi to track the high bits and
> > > side-step the problem for Intel (dejavu?).
> >
> > Technically, it would require three fields: u16 error_code, u16 error_c=
ode_hi,
> > and u32 error_code_ultra_hi.  :-D
> >
> > Isolating the (ultra) hi flags is very tempting, but I worry that it wo=
uld lead
> > to long term pain, e.g. because inevitably we'll forget to grab the hi =
flags at
> > some point.  I'd rather audit the current code and ensure that KVM trun=
cates the
> > error code as needed.
> >
> > VMX is probably a-ok, e.g. see commit eba9799b5a6e ("KVM: VMX: Drop bit=
s 31:16
> > when shoving exception error code into VMCS").  I'd be more worred SVM,=
 where
> > it's legal to shove a 32-bit value into the error code, i.e. where KVM =
might not
> > have existing explicit truncation.
>=20
> As I understand it, intel CPUs don't allow for setting bits 31:16 of
> the error code, but AMD CPUs allow bits 31:16 to be set.

Yep.

> The 86_exception error_code field is u16 currently so it is always trunca=
ted
> to u16 by default. In that case, after widening the error code to 64 bits=
, do
> I have to ensure that any usage of the error that isn't for NPF, has to
> truncate it to 16 bits?
>
> Or do I just need to verify that all SVM usages of the error_code for
> exceptions truncate the 64 bits down to 32 bits and all VMX usages trunca=
te
> to 16 bits?

Hmm, good question.

I was going to say "the second one", but that's actually meaningless becaus=
e
(a) "struct kvm_queued_exception" stores the error code as a u32, which it =
should,
and (b) event_inj_err is also a u32, i.e. it's impossible to shove a 64-bit=
 error
code into hardware on SVM.

And thinking through this more, if there is _existing_ code that tries to s=
et
bits > 15 in the error_code, then UBSAN would likely have detected the issu=
e,
e.g. due to trying to OR in a "bad" value.

Aha!  A serendipitous quirk in this patch is that it does NOT change the lo=
cal
error_code in FNAME(walk_addr_generic) from a u16 to a u64.

We should double down on that with a comment.  That'd give me enough confid=
ence
that we aren't likely to break legacy shadow paging now or in the future.  =
E.g.
in a patch to change x86_exception.error_code to a u64, also do:

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.=
h
index 901cd2bd40b8..f1790aa9e391 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -317,6 +317,12 @@ static int FNAME(walk_addr_generic)(struct guest_walke=
r *walker,
        const int write_fault =3D access & PFERR_WRITE_MASK;
        const int user_fault  =3D access & PFERR_USER_MASK;
        const int fetch_fault =3D access & PFERR_FETCH_MASK;
+       /*
+        * Note!  Track the error_code that's common to legacy shadow pagin=
g
+        * and NPT shadow paging as a u16 to guard against unintentionally
+        * setting any of bits 63:16.  Architecturally, the #PF error code =
is
+        * 32 bits, and Intel CPUs don't support settings bits 31:16.
+        */
        u16 errcode =3D 0;
        gpa_t real_gpa;
        gfn_t gfn;

> Just wanted to clarify because I think the wording of that statement
> is confusing me into thinking that maybe there is something wrong with
> 32 bit error codes for SVM?

It's more that I am confident that either KVM already truncates the error c=
ode
on VMX, or that we'll notice *really* quickly, because failure to truncate =
an
error code will generate a VM-Fail.

On SVM, we could royally screw up an error code and it's entirely possible =
we
wouldn't notice until some random guest breaks in some weird way.

> If the only usage of the widened field is NPF, wouldn't it be better
> to go with an additional field like Yosry suggested (I see that VMX
> has the added exit_qualification field in the struct)?

No?  paging_tmpl.h is used to shadow all flavors of nested NPT as well as a=
ll
flavors of legacy paging.  And more importantly, unlike EPT, nested NPT isn=
't
otherwise special cased.  As shown by this patch, it _is_ possible to ident=
ify
nested NPT in select flows, and we could certainly do so more generically b=
y
checking if the MMU is nested, but I'd prefer not to special case any parti=
cular
type of shadow paging without a strong reason to do so.

And more importantly, if we have two (or three) error code fields, then we =
need
to remember to pull data from all error code fields.  I.e. in an effort to =
avoid
introducing bugs, we would actually make it easier to introduce _other_ bug=
s.

