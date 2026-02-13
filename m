Return-Path: <kvm+bounces-71073-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8JF3KV6jj2mqSAEAu9opvQ
	(envelope-from <kvm+bounces-71073-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 23:19:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 252BC139C1A
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 23:19:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 54A58302EA85
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 22:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 263FB30BF6B;
	Fri, 13 Feb 2026 22:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lp1JxfpW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566E627F754
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 22:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771021146; cv=none; b=ZLt59l3cDgjshQLnBaWR0MBUTvGkbEOVJX7JrCll+XttkPbaKUVfHHMal2F7X/TA3JUlcax43baU/b/DnFsRPUTYCogDePFEOOYd316rRH3cTZY29uiwsSS2lYjbB4H3aZN7lddVNqqM2XVm9kY8gytNMct96iMdQPl0+ZBMEu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771021146; c=relaxed/simple;
	bh=4SfVeVyOopNUEYpALsPtH/J4tdgq8bQHBnqCt9tGo8k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l2HJonhdZpJh7Bp6YOhp20RTA3nISyNsti/YHbsvHmCGQgfCFj6QqKO3rcy9UEqWR5UeAIALTaZsUKpCXlYE8ZGtQvCHIZ6Yrmb0vIsd9GXlxMGBG9XgQ+24exFSE6PuQPDzVnLAhEdfVzFWDGVrL3fAM3WX2T9qAmo3+cUqDV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lp1JxfpW; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a9638b0422so9935605ad.3
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 14:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771021145; x=1771625945; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zjKURXqU+Zr0HcMfUxCtx2SVToxbcyc0zFBF1VQb9Ag=;
        b=lp1JxfpWhfKo64z3xcrr73d7ItxzQ3cbS4g+iRbelY9/K5W/lqlEuLHKzRPoh1kwXC
         m68lShZZqkRFoNhqg0eODPykfNVZhSZaRUac+U22U74avuLy9LwNpiLDMR5gkdfKeXuo
         qBs0Eo1M7+7WNKiZbvCp9CTeBopKn7T9x+VYBMG8h79nuUoLZlKJk/zNR+3A7Ndfp7Ah
         R5OzxMVpjhyUxozDLYOLJsEBoyeXzoa3dvP/SLKD2Ne9XdVjY/sWRPzPjiktI4f/Incn
         1reJvTBad01CcKJeUMhfobFEiIA2YSz+FGj0mud9ZfDJHC11tTF9wXPriWPsZmQd+qiC
         ez2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771021145; x=1771625945;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zjKURXqU+Zr0HcMfUxCtx2SVToxbcyc0zFBF1VQb9Ag=;
        b=NYrXmx+3FE5zcN8nzHGHAz0UYb4B+EyT0cNThkR/29/DSOwnqotgKRr2PMpw9VPmyp
         qSccD+5lZZjVuyjzsQOgw4FVrRc/3HBBi6hAk7K5sMigW4YE7fPLkDduzJB4ATgDMPZE
         vl7G9LBLBNIFefYEhqpNz44knuGjw6pIZZMybLfxU+a4ypVqawLkLDCjbhL1wP5YexjW
         cH4roN+5vNxF9sBqEuKjgfBcq1nv0La+UthaSmPjX09R/B9S8mLACAUNg7Kf9ck6MZT7
         20yytoWkJRuP4iX7WxaonF7GSp4SQQbgbOPPmcXgXkMpjxjLY1u/KozQ4zLtdl7LKO9A
         ZcaA==
X-Forwarded-Encrypted: i=1; AJvYcCVJl28VV5o9CU2rqgH8pHk9O3ViBwz9lFot+3eXqFdFrdfbBTNBHiQCbdMB3icH/AYJ52U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyN7lcKCutm/couzmRZzBt1/AYjj8EzOTojZaLnUZw6OwWXYrb
	aqfEzwvQyQIw0JfGZGdDLJxIaUDmnaZH6djNfcNFLD/o1BOf6eealJHJkPYraJxddZdgnn9Z32D
	VjNka1g==
X-Received: from pjbsx13.prod.google.com ([2002:a17:90b:2ccd:b0:354:c63c:5ed6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1c2:b0:2a7:9ded:9b4a
 with SMTP id d9443c01a7336-2ad174dcf04mr9334615ad.36.1771021144404; Fri, 13
 Feb 2026 14:19:04 -0800 (PST)
Date: Fri, 13 Feb 2026 14:19:02 -0800
In-Reply-To: <CALMp9eR4ayj_gwsDQVH8pQvzqgEYVB6ExWp3aFgJXRWikLEikw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com> <20260212155905.3448571-5-jmattson@google.com>
 <gqj4y6awen5dfxy32lbskcxw6xdv4xiiouycyftjacndjinhvp@7p4dtgdh6tjw>
 <aY9BPKhzgxo4UuHB@google.com> <CALMp9eR4ayj_gwsDQVH8pQvzqgEYVB6ExWp3aFgJXRWikLEikw@mail.gmail.com>
Message-ID: <aY-jViitsLQm9B83@google.com>
Subject: Re: [PATCH v4 4/8] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71073-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 252BC139C1A
X-Rspamd-Action: no action

On Fri, Feb 13, 2026, Jim Mattson wrote:
> On Fri, Feb 13, 2026 at 7:20=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > > +static inline void svm_set_hpat(struct vcpu_svm *svm, u64 data)
> > > > +{
> > > > +   svm->vcpu.arch.pat =3D data;
> > > > +   if (npt_enabled) {
> >
> > Peeking at the future patches, if we make this:
> >
> >         if (!npt_enabled)
> >                 return;
> >
> > then we can end up with this:
> >
> >         if (npt_enabled)
> >                 return;
> >
> >         vmcb_set_gpat(svm->vmcb01.ptr, data);
> >         if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(svm))
> >                 vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
> >
> >         if (svm->nested.legacy_gpat_semantics)
> >                 svm_set_l2_pat(svm, data);
> >
> > Because legacy_gpat_semantics can only be true if npt_enabled is true. =
 Without
> > that guard, KVM _looks_ buggy because it's setting gpat in the VMCB eve=
n when
> > it shouldn't exist.
> >
> > Actually, calling svm_set_l2_pat() when !is_guest_mode() is wrong too, =
no?  E.g.
> > shouldn't we end up with this?
>=20
> Sigh. legacy_gpat_semantics is supposed to be set only when
> is_guest_mode() and nested_npt_enabled(). I forgot about back-to-back
> invocations of KVM_SET_NESTED_STATE. Are there other ways of leaving
> guest mode or disabling nested NPT before the next KVM_RUN?

KVM_SET_VCPU_EVENTS will do it if userspace forces a change in SMM state:

		if (!!(vcpu->arch.hflags & HF_SMM_MASK) !=3D events->smi.smm) {
			kvm_leave_nested(vcpu);
			kvm_smm_changed(vcpu, events->smi.smm);
		}

I honestly wasn't even thinking of anything in particular, it just looked w=
eird.

> > > > +           vmcb_set_gpat(svm->vmcb01.ptr, data);
> > > > +           if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(sv=
m))
> > > > +                   vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
> > > > +   }
> > > > +}
> > >
> > > Is it me, or is it a bit confusing that svm_set_gpat() sets L2's gPAT
> > > not L1's, and svm_set_hpat() calls vmcb_set_gpat()?
> >
> > It's not just you.  I don't find it confusing per se, more that it's re=
ally
> > subtle.
> >
> > > "gpat" means different things in the context of the VMCB or otherwise=
,
> > > which kinda makes sense but is also not super clear. Maybe
> > > svm_set_l1_gpat() and svm_set_l2_gpat() is more clear?
> >
> > I think just svm_set_l1_pat() and svm_set_l2_pat(), because gpat straig=
ht up
> > doesn't exist when NPT is disabled/unsupported.
>=20
> My intention was that "gpat" and "hpat" were from the perspective of the =
vCPU.
>=20
> I dislike svm_set_l1_pat() and svm_set_l2_pat(). As you point out
> above, there is no independent L2 PAT when nested NPT is disabled. I
> think that's less obvious than the fact that there is no gPAT from the
> vCPU's perspective. My preference is to follow the APM terminology
> when possible. Making up our own terms just leads to confusion.

How about svm_set_pat() and svm_get_gpat()?  Because hPAT doesn't exist whe=
n NPT
is unsupported/disabled, but KVM still needs to set the vCPU's emulated PAT=
 value.

