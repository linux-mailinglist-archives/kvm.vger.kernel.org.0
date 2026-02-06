Return-Path: <kvm+bounces-70521-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mFgqDSt0hmn/NQQAu9opvQ
	(envelope-from <kvm+bounces-70521-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 00:07:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D187104074
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 00:07:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5CBC2303DAA2
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 23:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85EF30FF3B;
	Fri,  6 Feb 2026 23:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IKsXX8G9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9472E54AA
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 23:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770419223; cv=none; b=tXRx6FGB0bAdQFqpFh2hY0SCHnVMaiP1nubipIr/kBTY6c2q9ZNaqqbwDn6cZpvsGIyzXD1l3LzEfse6EnV+MazTKv9sU8rjJl1j76Ml81NjJsZwpz4FdTiERXl73jPB0pnYKADe02l/+ZjixwflS3xIcKYZ9714f9ygq2HhdJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770419223; c=relaxed/simple;
	bh=FcYDzvYt6qRCfMBuYQg/fNZI/Ov7o7ltbY9lGgUO2kM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tV2+oy+dztuXdUfkUN2Y9a+eCLSc8j+rxOG9l69eAKPcbsi0DrfYTNqnaMue2oB4IGYb7GehQqxPEHiWtscWltJPbw/wA81L6EMOJGGlATpFhqSehjP34AP88hzV5g9FvVOcU3gV/v/ilttXFme2IseErCPprkC/WED9DXNc1u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IKsXX8G9; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82442b44d94so711348b3a.2
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 15:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770419222; x=1771024022; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KZYAv7PTE+yvvy/ZSJd8rfyOzgaRiZuGA2UK+o3e2Dc=;
        b=IKsXX8G93tbTYFPP3ASBcU66NWVIpzE/0Cgtvu7rXa+gc80NfMLcyCV/RD8VcvYdxl
         ouY4zvKjE5h1x2T55o/nU2dDw+KCgMS/RJKVjIlDUJ7dRZjOS23MIq5THawr5GhYtdny
         DV7NqzLAvypH0eRFhuMoD/aLZ1e9xxq1j2+kDBoO5IyoyEQyzWwa2hZgM/2MPpi2RIx5
         8N2cngOFJansRlSfWNEcfxuDLGSMiWWkS21jr6VORg0bb0gLR1ZQ8zrVEqgoM52fH+la
         zkfP3Jqwbx1vn1LexD8pvLCTveQwNjA5jh3OYu//psTam2q1SrREtoN9Z/vR+DJJBxPT
         oaBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770419222; x=1771024022;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KZYAv7PTE+yvvy/ZSJd8rfyOzgaRiZuGA2UK+o3e2Dc=;
        b=IHqSU8d4EAgmQEoLaR1IP8tkryslU/+sA2XsApb7QGvuJy5pa2vxptagIWI2JhhHhE
         M6jJRQogxt0mEB29qVmWeINNdmIoViIF3QqxNriBUFixW9yNlkxiLEDxVcxoqAAhbVGt
         lyrvwlsDnNWY+VU6tktOA7a0gfhFmGb+598MLgcKWr30roCFxf9K6RvhuVGrw0x84uKW
         30B5RIoiESbcOvqBl3n2yRHRS32heiUFd+r07OZb0FuRWLELb0Qp7Nj+AOccy0twTI+D
         yV3rcLuLkq+z2CUpgrL3jhxt2QEqnx8zmWYpvNNWtfm2SChSrTXjuyqMHu1kq9IWb4Dj
         /L+w==
X-Forwarded-Encrypted: i=1; AJvYcCWCq8FsA173EwTVKWPNf2wiKhJGgI2qsJcccVzt98gFu01H8l9IDqGRxatkOUWrLGqJxtY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL8FNt9oUJqOnkyD+eDFBpT6wLpWVUjZG8CShL9b+on/JezAg/
	I1EYyaqVda0kPG2dqbvu7SdihORFRPeqJBAYlgXjEYj+hhKUZuGCelqv/xKeoHxlASOZTS4/wBe
	6WTEqsQ==
X-Received: from pfbkq17.prod.google.com ([2002:a05:6a00:4b11:b0:823:6d9:cee8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:e0a:b0:81f:852b:a934
 with SMTP id d2e1a72fcca58-82441623946mr3395482b3a.24.1770419222227; Fri, 06
 Feb 2026 15:07:02 -0800 (PST)
Date: Fri, 6 Feb 2026 15:07:00 -0800
In-Reply-To: <CALMp9eSRj=aykY7FbnPm1OgSwFSkJ=uVVmwsnGjV-A_-AQjxMQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com> <20260205214326.1029278-3-jmattson@google.com>
 <aYYwwWjMDJQh6uDd@google.com> <fb750b1bb21bd47f85eb133d69b2c059188f4c05@linux.dev>
 <CALMp9eTJAD4Dc88egovSjV-N2YHd8G80ZP-dL5wXFDAC+WR6fA@mail.gmail.com>
 <aYY9JOMDBPDY48lA@google.com> <CALMp9eSRj=aykY7FbnPm1OgSwFSkJ=uVVmwsnGjV-A_-AQjxMQ@mail.gmail.com>
Message-ID: <aYZ0FMl6E6P1MRf0@google.com>
Subject: Re: [PATCH v3 2/8] KVM: x86: nSVM: Cache and validate vmcb12 g_pat
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
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70521-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: 8D187104074
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Jim Mattson wrote:
> On Fri, Feb 6, 2026 at 11:12=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, Feb 06, 2026, Jim Mattson wrote:
> > > On Fri, Feb 6, 2026 at 10:23=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linu=
x.dev> wrote:
> > > >
> > > > February 6, 2026 at 10:19 AM, "Sean Christopherson" <seanjc@google.=
com> wrote:
> > AFAICT, the only "problem" is that g_pat in the serialization payload w=
ill be
> > garbage when restoring state from an older KVM.  But that's totally fin=
e, precisely
> > because L1's PAT isn't restored from vmcb01 on nested #VMEXIT, it's alw=
ays resident
> > in vcpu->arch.pat.  So can't we just do this to avoid a spurious -EINVA=
L?
> >
> >         /*
> >          * Validate host state saved from before VMRUN (see
> >          * nested_svm_check_permissions).
> >          */
> >         __nested_copy_vmcb_save_to_cache(&save_cached, save);
> >
> >         /*
> >          * Stuff gPAT in L1's save state, as older KVM may not have sav=
ed L1's
> >          * gPAT.  L1's PAT, i.e. hPAT for the vCPU, is *always* tracked=
 in
> >          * vcpu->arch.pat, i.e. gPAT is a reflection of vcpu->arch.pat,=
 not the
> >          * other way around.
> >          */
> >         save_cached.g_pat =3D vcpu->arch.pat;
>=20
> Your comment is a bit optimistic. Qemu, for instance, hasn't restored
> MSRs yet, so vcpu->arch.pat will actually be the current vCPU's PAT
> (in the case of snapshot restore, some future PAT).

Yeah, FWIW, I was _trying_ account for that by not explicitly saying that a=
rch.pat
is the "new" L1 state, but it's difficult to dance around :-/

> But, in any case, it should be a valid PAT.
>
> >         if (!(save->cr0 & X86_CR0_PG) ||
> >             !(save->cr0 & X86_CR0_PE) ||
> >             (save->rflags & X86_EFLAGS_VM) ||
> >             !nested_vmcb_check_save(vcpu, &ctl_cached, &save_cached))
>=20
> Wrong ctl_cached. Those are the vmcb02 controls, but we are checking
> the vmcb01 save state.

*sigh*

> I think it would be better to add a boolean argument, "check_gpat,"
> which will be false at this call site and nested_npt_enabled(vcpu) at
> the other call site.

Yeah, agreed.  Because even though arch.pat should be valid, IIUC there isn=
't a
consistent check on hPAT because it's never reloaded.

