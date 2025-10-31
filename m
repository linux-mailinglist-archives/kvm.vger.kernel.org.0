Return-Path: <kvm+bounces-61700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41EB5C26192
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 17:25:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A222563A60
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 16:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8502FC891;
	Fri, 31 Oct 2025 16:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iMzVn8la"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597BA2FB63A
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761927124; cv=none; b=ACOUt0QoyPJ20h258lGiU1ZWRZAZhxCmgNYFCoAOgrJUOpVNViadj5elWf/O0AMvtUvT+dEOYyiAW2RDCCxLKZRTXou3BS3Styg0af0Tbxu70gS53hu++YbsxLZx5FkpcO1mqOEYRxJEcX5TdJtVqJDS+0yMR52uUr7/uDJlIQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761927124; c=relaxed/simple;
	bh=hzVPRR/PNroU24atllYXBoJ2qJSIQHeePErrHqVWCB8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pcoNtdGsPA4RB9nF0kFGBwx07oUOnn3X+etp/jcN7i6hmCB1f+U/QgJ8td3PvU9aiOYqKo99kpzdcN7NyB8OZRIQKac/c1SKUsS3vAKJG6pTqz0H8ZI7JSGLHd/CIyCqgY5e+2GdnkKM0YxivyecEIgxELC29WWY5Aa1ksyRYos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iMzVn8la; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34029cbe2f5so5115531a91.0
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 09:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761927122; x=1762531922; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dMP6guLZLag+yHuFE4kHvSR3duvwUyed0UuDNCgNgP0=;
        b=iMzVn8lajAWeDDd730gmsQnXHHau33T3QQ4B82Pk6eDyc5+srPjKWhHWwbGUcA0YyX
         R5Rl7tEWJPAMHK21al1dvFSQ+MSFj1vX8FRrI1QLKH3DFGQNw1rXRU/q8TcNxsqDdSj7
         AAlqiziE6XYFC8kYscx95GdKmelbvGBEAWVanXHKnWWSGDg9M84Wh76+EXnli981tTJi
         +k+FaUU2jmAZ8x57vl83g9ctqOFTIpJopAWTk4AGSfKYJzLuKAt/oqk0eJV5I+boixij
         k4211RKiFVY+I9qu3NzKty40BG8V3brzw1kbMlHFw0HxkD8Q1bA2ACtd8ohMWF7gu1QR
         grEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761927122; x=1762531922;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dMP6guLZLag+yHuFE4kHvSR3duvwUyed0UuDNCgNgP0=;
        b=k3glMq6MyHGJxXkP35EJSQ0g9NIB283d1XYzhWoYlskuSLn4bzFYqiI5DcjeT0eVru
         +bFgjCFSB4V4gkk2vMAGneZez9Lv1unyODDD1KCqKwQqZF/p4kjaebnRYtz6gay5RxRU
         RQqGJ8Cc4/On6VR/9w6rBn0IFVay5dO2YG/V72x99hmZvqmDY1/K1HuoeqVdXF5da1F3
         Bhaki79vyhCGGu6jOLPfC6AStmDfVGclslCcboprfnSOYNR/HfcXNYi1bXKO95H09bhd
         xUSmcj3M3an1vpBSP3R81FyL5MDXmEGUbMQk7Wb55aocPckVUjov4tG5UkbOM8u22r/Z
         kzWw==
X-Forwarded-Encrypted: i=1; AJvYcCUWuG35gYNfXMSvyR1RRA+blSnmZp0vhisREGkzK5qDlz5ZqLoecxy8K+RkNs/mUfOu9w0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBMGgZ103p7k+Wm4Y+XfSd+/cuwp8gV3xZUSe7DBOS01DhpvYG
	/MKzkj+xUcqckmbvyBORcpq4UDZ+Ht3bprjXld5mSQxm3QwgRljFwRnIMcNI71ud9r5gQo4Vlid
	wrdkAlA==
X-Google-Smtp-Source: AGHT+IGO8dGOZ2qilHfxU5yBlgEevBxzNRGJt5Gse7WpPy9qbnl6Lc+kpZGMdkE+9eUqqCUXbsAJFpJ+SCY=
X-Received: from pjbcq19.prod.google.com ([2002:a17:90a:f993:b0:339:ee5f:ec32])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3850:b0:33b:b308:7659
 with SMTP id 98e67ed59e1d1-340830ad168mr5241736a91.36.1761927121578; Fri, 31
 Oct 2025 09:12:01 -0700 (PDT)
Date: Fri, 31 Oct 2025 16:12:00 +0000
In-Reply-To: <CAAhR5DHidvrzdkugdL-UNDugYUd9zypbbu1131GexbZpTPzB3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com> <20251028212052.200523-21-sagis@google.com>
 <6904c3834e3c0_231474100ca@iweiny-mobl.notmuch> <aQTSdk3JtFu1qOMj@google.com> <CAAhR5DHidvrzdkugdL-UNDugYUd9zypbbu1131GexbZpTPzB3g@mail.gmail.com>
Message-ID: <aQTf0EXxtsi_4UaB@google.com>
Subject: Re: [PATCH v12 20/23] KVM: selftests: Add support for TDX TDCALL from guest
From: Sean Christopherson <seanjc@google.com>
To: Sagi Shahar <sagis@google.com>
Cc: Ira Weiny <ira.weiny@intel.com>, linux-kselftest@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2025, Sagi Shahar wrote:
> On Fri, Oct 31, 2025 at 10:15=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Fri, Oct 31, 2025, Ira Weiny wrote:
> > > Sagi Shahar wrote:
> > > > From: Erdem Aktas <erdemaktas@google.com>
> > > >
> > > > Add support for TDX guests to issue TDCALLs to the TDX module.
> > >
> > > Generally it is nice to have more details.  As someone new to TDX I
> > > have to remind myself what a TDCALL is.  And any random kernel develo=
per
> > > reading this in the future will likely have even less clue than me.
> > >
> > > Paraphrased from the spec:
> > >
> > > TDCALL is the instruction used by the guest TD software (in TDX non-r=
oot
> > > mode) to invoke guest-side TDX functions.  TDG.VP.VMCALL helps invoke
> > > services from the host VMM.
> > >
> > > Add support for TDX guests to invoke services from the host VMM.
> >
> > Eh, at some point a baseline amount of knowledge is required.  I highly=
 doubt
> > regurgitating the spec is going to make a huge difference
> >
> > I also dislike the above wording, because it doesn't help understand _w=
hy_ KVM
> > selftests need to support TDCALL, or _how_ the functionality will be ut=
ilized.
> > E.g. strictly speaking, we could write KVM selftests without ever doing=
 a single
> > TDG.VP.VMCALL, because we control both sides (guest and VMM).  And I ha=
ve a hard
> > time belive name-dropping TDG.VP.VMCALL is going to connect the dots be=
tween
> > TDCALL and the "tunneling" scheme defined by the GHCI for requesting em=
ulation
> > of "legacy" functionality".
> >
> > What I would like to know is why selftests are copy-pasting the kernel'=
s scheme
> > for marshalling data to/from the registers used by TDCALL, how selftest=
s are
> > expected to utilize TDCALL, etc.  I'm confident that if someone actuall=
y took the
> > time to write a changelog explaining those details, then what TDCALL "i=
s" will
> > be fairly clear, even if the reader doesn't know exactly what it is.
> >
> > E.g. IMO this is ugly and lazy on multiple fronts:
>=20
> To give some context to why this was done this way: Part of the reason
> for the selftests is to test the GHCI protocol itself.

The only part of the protocol that we're actually testing is the guest<=3D>=
KVM
interaction.  Testing the guest<=3D>VMM interaction is self-referential, i.=
e. we're
validating that we implemented the guest and VMM sides correctly, which is =
all
kinds of silly.

> Some of the selftests will issue calls with purposely invalid arguments t=
o
> ensure KVM handles these cases properly. For example, issuing a port IO c=
alls
> with sizes other than 1,2 or 4 and ensure we get an error on the guest si=
de.

That's fine, great in fact, but that's completely orthogonal to how selftes=
ts
implement the literal guest or VMM code.

> The code was intentionally written to be specific to TDX so we can
> test the TDX GHCI spec itself.

That's 100% possible without copy+pasting the kernel, and also 100% possibl=
e
while also providing sane, common interaces.

> As I understand it, you want the selftests to operate at a higher
> level and abstract away the specific GHCI details so that the code can
> be shared between TDX and SEV.=20

No, I want us to think critically about what we're actually doing, and I wa=
nt us
to write code that is maintainable and as easy to follow as possible.

> I can refactor the code to abstract away implementation details. However,
> tests that want to exercise the API at a fine-grained level to test diffe=
rent
> arguments will need to define these TDCALLs themselves.

It's not so much about abstracting details as it is about making it easy to=
 write
tests.  Yes, some TDX-specific tests will need to know the gory details.  B=
ut in
the grand scheme, those will be a very tiny percentage of all KVM selftests=
.

E.g. in all likelihood there should be literally _one_ test to validate tha=
t KVM
and the TDX-Module honor the guest<=3D>KVM GHCI contract.  Or maybe one tes=
t per
instruction/operation.  Everything else, even tests that are TDX specific, =
should
not care one whit about the GHCI.

> These calls were placed in a header that can be included in the guest
> code. I can add higher level wrappers that can be used for common
> code.
>=20
> >
> > uint64_t tdg_vp_vmcall_ve_request_mmio_write(uint64_t address, uint64_t=
 size,
> >                                             uint64_t data_in)
> > {
> >        struct tdx_tdcall_args args =3D {
> >                .r10 =3D TDG_VP_VMCALL,
> >                .r11 =3D TDG_VP_VMCALL_VE_REQUEST_MMIO,
> >                .r12 =3D size,
> >                .r13 =3D MMIO_WRITE,
> >                .r14 =3D address,
> >                .r15 =3D data_in,
> >        };
> >
> >        return __tdx_tdcall(&args, 0);
> > }
> >
> > First, these are KVM selftests, there's no need to provide a super fanc=
y namespace
> > because we are "competing" with thousands upon thousands of lines of co=
de from
> > other components and subsystems.
> >
> > Similarly, tdg_vp_vmcall_ve_request_mmio_write() is absurdly verbose.  =
Referencing
> > #VE in any way is also flat out wrong.
>=20
> This name was taken from the GHCI spec: TDG.VP.VMCALL<#VE.RequestMMIO>
> ("Intel TDX Guest-Hypervisor Communication Interface v1.5" section 3.7)

I know, and I'm saying throw away the GHCI except for when it's absolutely =
necessary
to care what the GHCI says.

