Return-Path: <kvm+bounces-52894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C113BB0A5C5
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 16:02:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C8DF3B20E4
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 14:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2863F2DAFC1;
	Fri, 18 Jul 2025 14:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qW0ZRugA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E902D97A0
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752847292; cv=none; b=RClvaatv0VoH45pcECSRypDj7foNghVKiHGO0bz0ZfyBjMcbu4DxJe6HGXnUk0VauYLuJnVIzLIKZphuxwcvnftzXjsHvjW+BOAusf0SjSWf7KGdUwouKwgx3J9Zr6lH51pJIhEHpkKqTNEJ9UiN/j8pay02/MOQekQ0u7K4yJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752847292; c=relaxed/simple;
	bh=6qUNR7GXVCYo+1bPYXlhFU/JJDnvM1+CbJ56g/528IA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A26p6R2bR4RAspHz7u8nhhFR82DfTMLwt86M6ppHkqXfeb4nnJ3EXgwIUE1dtZLb80kEdvAOon9UlXhvDHi9+lsEFWJ1BIpjiRN6Rngaoa9mo2eCx29hgPeUksAW2IhSjkkC5xPLpIgIgNeznxJLMj8mS/LYD8JYHwysCCyF8ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qW0ZRugA; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23638e1605dso17373415ad.0
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 07:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752847290; x=1753452090; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lih3tMFn734cUO8oMeOE2pBVAMcrztqc4UNLK1aIv7M=;
        b=qW0ZRugAw/KwiXrfCi0mPFoQbjjcPAruyJ7Q3FaendrNz7uXXByrfOE6CAdDOf0D0B
         8f8+kuQYvLtZloF1x/yW67NahUz/+ECovnyZFsGO9HHNRtNyjvYgGkyTsT06987NEHtm
         jPQks+zUvxwiFQxLN7dee7jMUx4XtPkoUT19mDt0dGjZnpC07ONKPQVVuyrdncCUkJt4
         8PvApOy42KLsSqqHyahqSjjLK97duwNHPX2lZUYUBEGRSicwf5YqzeK4PP8JdB7uexSq
         h+OOPL07MylGENyaEvBr4UkCirdsLKcIa2+muqMMDznqGmUBn6Q9TUllxuplcnoF/sRT
         +cWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752847290; x=1753452090;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Lih3tMFn734cUO8oMeOE2pBVAMcrztqc4UNLK1aIv7M=;
        b=ZbNCUau1bb20bPa6b6gE2I/QIeArsH3JQuKwlotgmLn6nAj/Sn1nThIS9LSzCJZjBX
         dDPO9b5ncjs3MbdegBmuDSutMlKAQXjSJ63zImNIcIOkNIk/S/PwD5s8eG+kCrtlEjpE
         dYu6Z4TQjUGeejpQ/403OoQeLVRmmSd6olB2+Woed3tGP+yyRcdCSjI5vLwIBPRJR/At
         6WyDXAlhKFefHjcVWEEsX7SBHRF+BeGOm4xnEZIYL+eTdDrG59W0eUB47pGqX5lrhKd2
         OvKBynUBWD4TGo8IG2NlQqrYWNBDeaVNzprxA0s5Blec2C1fmKE+mOVlviMY2CsRW/Pc
         6smw==
X-Forwarded-Encrypted: i=1; AJvYcCUq7we12xcKtV0fFkdt9l+oT9x69T4ClYCWT3UB1Z7a/lj6iXI+jAwYEonbaLqaLegEmeA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwD+JxKrSiW89z/G3v8gq6jDAIRMIM8/aZmX+VUXN8/kZvqpSVg
	OENZwTB2pSkYJ9wALz4ee6FqWfHjKTQS2dwZSX1Fz9I9Qrq3ISTS5XngmUYd9L79QxgkjTAatAe
	xE7XWrg==
X-Google-Smtp-Source: AGHT+IHP07AjLXzCOdd3HKA4TPbL/Fpp7KeEDJaInxBKjZEon2PeEt9DRu0eo8YWnQ8vO58ZnOMfDZCgpqc=
X-Received: from plbkp8.prod.google.com ([2002:a17:903:2808:b0:235:ed02:286a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea04:b0:234:c8ec:51b5
 with SMTP id d9443c01a7336-23e2578f517mr170318515ad.53.1752847290227; Fri, 18
 Jul 2025 07:01:30 -0700 (PDT)
Date: Fri, 18 Jul 2025 07:01:28 -0700
In-Reply-To: <aHo7vRrul0aQqrpK@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250718062429.238723-1-lulu@redhat.com> <CACGkMEv0yHC7P1CLeB8A1VumWtTF4Bw4eY2_njnPMwT75-EJkg@mail.gmail.com>
 <aHopXN73dHW/uKaT@intel.com> <CACGkMEvNaKgF7bOPUahaYMi6n2vijAXwFvAhQ22LecZGSC-_bg@mail.gmail.com>
 <aHo7vRrul0aQqrpK@intel.com>
Message-ID: <aHpTuFweA5YFskuC@google.com>
Subject: Re: [PATCH v1] kvm: x86: implement PV send_IPI method
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, "Kirill A. Shutemov" <kas@kernel.org>, "Xin Li (Intel)" <xin@zytor.com>, 
	Rik van Riel <riel@surriel.com>, "Ahmed S. Darwish" <darwi@linutronix.de>, 
	"open list:KVM PARAVIRT (KVM/paravirt)" <kvm@vger.kernel.org>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2025, Chao Gao wrote:
> On Fri, Jul 18, 2025 at 07:15:37PM +0800, Jason Wang wrote:
> >On Fri, Jul 18, 2025 at 7:01=E2=80=AFPM Chao Gao <chao.gao@intel.com> wr=
ote:
> >>
> >> On Fri, Jul 18, 2025 at 03:52:30PM +0800, Jason Wang wrote:
> >> >On Fri, Jul 18, 2025 at 2:25=E2=80=AFPM Cindy Lu <lulu@redhat.com> wr=
ote:
> >> >>
> >> >> From: Jason Wang <jasowang@redhat.com>
> >> >>
> >> >> We used to have PV version of send_IPI_mask and
> >> >> send_IPI_mask_allbutself. This patch implements PV send_IPI method =
to
> >> >> reduce the number of vmexits.
> >>
> >> It won't reduce the number of VM-exits; in fact, it may increase them =
on CPUs
> >> that support IPI virtualization.
> >
> >Sure, but I wonder if it reduces the vmexits when there's no APICV or
> >L2 VM. I thought it can reduce the 2 vmexits to 1?
>=20
> Even without APICv, there is just 1 vmexit due to APIC write (xAPIC mode)
> or MSR write (x2APIC mode).

xAPIC will have two exits: ICR2 and then ICR.  If xAPIC vs. x2APIC is stabl=
e when
kvm_setup_pv_ipi() runs, maybe key off of that?

> >> With IPI virtualization enabled, *unicast* and physical-addressing IPI=
s won't
> >> cause a VM-exit.
> >
> >Right.
> >
> >> Instead, the microcode posts interrupts directly to the target
> >> vCPU. The PV version always causes a VM-exit.
> >
> >Yes, but it applies to all PV IPI I think.
>=20
> For multi-cast IPIs, a single hypercall (PV IPI) outperforms multiple ICR
> writes, even when IPI virtualization is enabled.

FWIW, I doubt _all_ multi-cast IPIs outperform IPI virtualization.  My gues=
s is
there's a threshold in the number of targets where the cost of sending mult=
iple
virtual IPIs becomes more expensive than the VM-Exit and software processin=
g,
and I assume/hope that threshold isn't '2'.

> >> >> Signed-off-by: Jason Wang <jasowang@redhat.com>
> >> >> Tested-by: Cindy Lu <lulu@redhat.com>
> >> >
> >> >I think a question here is are we able to see performance improvement
> >> >in any kind of setup?
> >>
> >> It may result in a negative performance impact.
> >
> >Userspace can check and enable PV IPI for the case where it suits.
>=20
> Yeah, we need to identify the cases. One example may be for TDX guests, u=
sing
> a PV approach (TDVMCALL) can avoid the #VE cost.

TDX doesn't need a PV approach.  Or rather, TDX already has an "architectur=
al"
PV approach.  Make a TDVMCALL to request emulation of WRMSR(ICR).  Don't pl=
umb
more KVM logic into it.

