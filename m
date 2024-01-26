Return-Path: <kvm+bounces-7203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A23DB83E2AA
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 20:34:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 424C61F2362F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 19:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C969E22630;
	Fri, 26 Jan 2024 19:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OPm+4IVZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91ED22606
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 19:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706297674; cv=none; b=Smg1Ian+5wIurssOQ+Qa6Wwf5jf+3Zpc3zTXMjQWCP/uBqyMtmen2sZY/HaByyRkE6WFVpxlp1qPYyBRHF1t1xyF10mghQ9gYG3uBApDdI9ttqoOvJyf5ZUqRD4hssQoljW6wsIx+BfeLDoo554OMR4Zy3EL7PAJATFxoAmiAPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706297674; c=relaxed/simple;
	bh=N9Ey+GNs6mImmS+vqlu63GW6nIrlmLmxZOJyPG76Uvg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fsM5pvJRoMVZpGPAT/6td7khrerH3qHSQvBHloJPrhCLcqn36CGZ+lykoOsy8XgVr/Uch2h3PWjaLuBpOJDG9EpfJZH2E1yn7MBbkV7lM9kv0a6HPDBOah8+qQePPoa8hTQmmJOmwh/S9GM6DDJdBEep6qu18vdAlVKzGwp0MlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OPm+4IVZ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d740687d8dso5855525ad.1
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 11:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706297672; x=1706902472; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VDi21S2WSjOuRBpM9Lk1FIKTWvNjyTGMc+fXaSns+7w=;
        b=OPm+4IVZZ5nYF1QTrktjGgLa9H4ZehC4010UmB9UJILUkF8Gub7hElGKlKsqYvAQQ4
         9BVZaws7Jh9bVBVPZSCH28iJ3bjpepycVCYo8CKLaskcytqCel7qTnovTDQJOJ6UC+no
         iAY+/KZW9VygCEwh5A1FhmDqlge3ny6lGrTFV8rmBu2pQJ+XZDiN1YOU6x3GyKp4DVxn
         8IjwL0Xb09mH6WQTo6lGpPRGwppRAgex0mxAFMH+swkj53Jv+98m60sF78194y6TZ1Tm
         HoH90RWChDK/WOE7DwDKvRMgSGtuzm4BxQSWUI+UWqqACoh4DdMYVSqMwGHuRntI0CwP
         g0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706297672; x=1706902472;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VDi21S2WSjOuRBpM9Lk1FIKTWvNjyTGMc+fXaSns+7w=;
        b=YbJgk2vx2EHyTyqynXGD4Y2j+xt9q8+IIj8H6VHFsW7h5hhjBbvYb+jqUyZbp/WlN1
         6qfy1OPslBz0rkSFcEv8ONvHAYgfTH0e227T3P+FBroJKf4+NNVh5Tn5atl/RQaYZpms
         pWwFDWHiIJEFZWyYy0movXMkkKh74gghWrcHSMxmMzx7EBHLaKuBfgax3HP/tu8bAyNU
         FPI+D87vTo9Z569IR4FxH2BtMCVBkC02LGvJodB1acX3kr+GLFMtVNoPsEzmGCoUboME
         sSw6BYaDSEQM6EZ8bdjwBfMLmG8hrqOXS9mjzaElJq9kRYai3Lr4XLiLQQ3cjpqyA2fG
         1FnA==
X-Gm-Message-State: AOJu0YyPJtZvufYf96DSn4H8MjUxBkuo87Ugjbo8auexurDh9P1heB6V
	oqq8PA1j3FES5HX32OADDEtRjHlBwTAjLaHEF1A2ZRfwKezc2undDA48dEKwfka401TIHYOcuuL
	OBQ==
X-Google-Smtp-Source: AGHT+IG6iDfrXKF60Mn1tXIVcYuPyDJTeL9v6HNsiYCB2kJPLXZPTB5XEhh6DLfPtzAqTXhO4WuuZTwYFVw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:238f:b0:1d5:693a:8906 with SMTP id
 v15-20020a170903238f00b001d5693a8906mr2053plh.3.1706297672003; Fri, 26 Jan
 2024 11:34:32 -0800 (PST)
Date: Fri, 26 Jan 2024 11:34:30 -0800
In-Reply-To: <CAL715WKMpui=+U56Qc5AiuLhUw_g-bjvtN5OmVz_hGdJmF1M5g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240124003858.3954822-1-mizhang@google.com> <20240124003858.3954822-2-mizhang@google.com>
 <ZbExcMMl-IAzJrfx@google.com> <CAAAPnDFAvJBuETUsBScX6WqSbf_j=5h_CpWwrPHwXdBxDg_LFQ@mail.gmail.com>
 <ZbGAXpFUso9JzIjo@google.com> <ZbGOK9m6UKkQ38bK@google.com>
 <ZbGUfmn-ZAe4lkiN@google.com> <ZbGn8lAj4XxiecFn@google.com>
 <ZbP7BTvdZ1-b3MmE@google.com> <CAL715WKMpui=+U56Qc5AiuLhUw_g-bjvtN5OmVz_hGdJmF1M5g@mail.gmail.com>
Message-ID: <ZbQJRtaxhpZR7ntT@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Reset perf_capabilities in vcpu to 0 if
 PDCM is disabled
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Frederick Mayle <fmayle@google.com>, Steven Moreland <smoreland@google.com>, 
	Aaron Lewis <aaronlewis@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 26, 2024, Mingwei Zhang wrote:
> +Frederick Mayle +Steven Moreland
>=20
> On Fri, Jan 26, 2024 at 10:33=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Jan 25, 2024, Mingwei Zhang wrote:
> > > On Wed, Jan 24, 2024, Sean Christopherson wrote:
> > > > On Wed, Jan 24, 2024, Mingwei Zhang wrote:
> > > > > I think this makes a lot of confusions on migration where VMM on =
the source
> > > > > believes that a non-zero value from KVM_GET_MSRS is valid and the=
 VMM on the
> > > > > target will find it not true.
> > > >
> > > > Yes, but seeing a non-zero value is a KVM bug that should be fixed.
> > > >
> > > How about adding an entry in vmx_get_msr() for
> > > MSR_IA32_PERF_CAPABILITIES and check pmu_version? This basically pair=
s
> > > with the implementation in vmx_set_msr() for MSR_IA32_PERF_CAPABILITI=
ES.
> > > Doing so allows KVM_GET_MSRS return 0 for the MSR instead of returnin=
g
> > > the initial permitted value.
> >
> > Hrm, I don't hate it as a stopgap.  But if we are the only people that =
are affected,
> > because again I'm pretty sure QEMU is fine, I would rather we just fix =
things in
> > our VMM and/or internal kernel.
>=20
> It is not just QEMU. crossvm is another open source VMM that suffers
> from this one.

Does CrosVM support migration or some other form of save/restore (RR?)?  An=
d if
so, does CrosVM do that in conjunction with hiding the vPMU from the guest?

Because if not, then I think we can squeak by.

