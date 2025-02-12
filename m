Return-Path: <kvm+bounces-37977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA54A32C53
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 17:49:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FF283A9DAE
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 16:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ABF9253B4B;
	Wed, 12 Feb 2025 16:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cDlK7Fi8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDE820B1E5
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 16:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739378965; cv=none; b=g+RlvABPO/zHmCkA0Cgqz2iz6KQlbof6kExSBzuGEjslJ1iVo+3Moa0c90caWI9Guvg0ZM+ICSQR162Ah0RLAfhsj8IRCJwoJ8I+0g/baSQqewFlZCuklnhrlZIsZPhjzKbr4itbyrpSmAkNE/Cq+yysyeVHsv6qB15R0PR0GeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739378965; c=relaxed/simple;
	bh=K9W3+ja3lk2X/pLiWNDDUjkQDh2hb6rMIAeT9C3cR6Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OChnsojEY/pwhpFC+awXPQCV92x/y1jFLbiuNJHtp8jqqB1nUd6CQ7qKtF31AdJ/IGWXf+sFwMdH2AIz2yI4jAgMOxJ2ircEGVlxLPYsV6C37OjIum3cY7HG1wsKA/EiBeuQqUF3xlDUkFc+cS6yArW4FyOSqybFGdH/I7QkM9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cDlK7Fi8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f46b7851fcso20880914a91.1
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 08:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739378963; x=1739983763; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kP37d1ws2n5F1FJZ8WLnY6NGYlL7GOZQPCCTeAYyrIs=;
        b=cDlK7Fi8U7h9IFqYvvfDj2oFv0v+R9vTNaRm2swS0LVP4uTAVPmu0aOSS4fPFLdAL8
         wldBsbHwjMlIN/cAixdPqga0L/dKSKMtXrg8/8Q6wN/4u9+n1yXMJKVIH95WklFHkEZZ
         9lm91+4wEWDXNb4AnPn+XJTCnSHhtLi2OG6xaGDZo/f+cdWMVm+yNhU9wmIR7GQQHas1
         0PyoaRwu62TjA72KvUbs3Kam6bxwn+ldy/kKIiTn5Qt+aibn+VPUeeOADQX11wAXneqs
         Oj4WZttKu1OKJp/QOwhYKWctcOFcw+KWu9c5qIspcLQMZv6ao2db0msXPBdE0tYwXowe
         4Iiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739378963; x=1739983763;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kP37d1ws2n5F1FJZ8WLnY6NGYlL7GOZQPCCTeAYyrIs=;
        b=li3h7Uxpe6PDNUdpzLIocSw+vZjtOuORDpOZVpjZ4jq4JYPHYsPJAGgq9fwVYsP0ot
         Y3cYhcEVvOjR2eSzyuZGr8Lc/pvgBcIl/hotN+fM4CtOnCUAuM50HnVIkefTkI9O1qPW
         +iPxTnPCD0shrVFhv2ague7ZRaqXsbuWzIJD3/qhQRG03yw4KEyBziTvFGvHFIwjpZnm
         z0SEadnRqdnNzeVGmrt9l1VET0oFzSz79ld2Ed0g6JcxgQuZ4jM0YSLMGOYLDvvQP4pe
         Al3bJmdGC4wruReiRbJpGLddk757SWUq2tE/g1nzR4QPFjID6dTzUOKlunR3Xca9y5fF
         omAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvxwnfjy9npMKyutSSmjyrCkeSDiA6JZHYp2m8mVhWLITwkRM0GRuGY9Cv8vmAgK7jBD0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5i2sjSdHU1jDFfFn7U/hCk/zSaLiNpLrlRo8f+c/gquesYHq3
	NC/TocD1JMq5wktkEzdFMHjZB7yUC9rLD5+suajDef2/fRFATHKaEHxLpOOi175Hht1+YT2JTyf
	H6A==
X-Google-Smtp-Source: AGHT+IH6wNrakUz012f78wqKjQH+4yjmg+SQ2QTSMhcyxLfWd0+FnYoV+nIIT5v8NeefU4cSRXFiCm4pEYo=
X-Received: from pfiy22.prod.google.com ([2002:a05:6a00:1916:b0:730:9a11:69a3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1709:b0:730:99cb:7c2f
 with SMTP id d2e1a72fcca58-7322c383fb3mr5386724b3a.6.1739378963595; Wed, 12
 Feb 2025 08:49:23 -0800 (PST)
Date: Wed, 12 Feb 2025 08:49:22 -0800
In-Reply-To: <CALMp9eRB025OAi2fpdweKr+fOAovmOKfF7XPwvf8HJKbJSvmhg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113200150.487409-1-jmattson@google.com> <20250113200150.487409-3-jmattson@google.com>
 <CALMp9eRB025OAi2fpdweKr+fOAovmOKfF7XPwvf8HJKbJSvmhg@mail.gmail.com>
Message-ID: <Z6zREu-pShh-ivK-@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Clear pv_unhalted on all transitions to KVM_MP_STATE_RUNNABLE
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
	Gleb Natapov <gleb@redhat.com>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, 
	Suzuki Poulose <suzuki@in.ibm.com>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 05, 2025, Jim Mattson wrote:
> On Mon, Jan 13, 2025 at 12:02=E2=80=AFPM Jim Mattson <jmattson@google.com=
> wrote:
> >
> > In kvm_set_mp_state(), ensure that vcpu->arch.pv.pv_unhalted is always
> > cleared on a transition to KVM_MP_STATE_RUNNABLE, so that the next HLT
> > instruction will be respected.
> >
> > The "fixes" list may be incomplete.
>=20
> The only commit I'm not sure of is commit 1a65105a5aba ("KVM: x86/xen:
> handle PV spinlocks slowpath"). That commit introduces an mp_state
> transition to KVM_MP_STATE_RUNNABLE  without clearing pv_unhalted, so
> perhaps it should be in the "fixes" list. OTOH, this seems to be an
> independent implementation of PV spinlocks, so maybe it's not a
> problem.

I'll add it to the list, and drop the "list may be incomplete" line.
KVM_HC_KICK_CPU is unreachable if Xen hypercalls are enabled, but nothing w=
ould
prevent a clever guest from sending an virtual IPI with APIC_DM_REMRD.  Whe=
ther
or not that makes the Xen code a KVM bug is definitely debatable, but I can=
't
imagine will care about Fixes being slightly overzealous.

