Return-Path: <kvm+bounces-10822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62115870AED
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 20:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 852521C20E4B
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 19:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BBD979DD0;
	Mon,  4 Mar 2024 19:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="if4l83O9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80D87995B
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 19:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709581588; cv=none; b=Hj7EMWRB+b7EY+6Wf0gnDRN5zwaC5A+WYj4X5n8XUTmQ0xRsQ1BA+m+SdkkUypCaaKqAKJmFQY5amWctnMcL8XrW1WDCEDa2OSeCGyZ5tfoSRjWu0ksTFYODRri0WCEYJxiB3DBtRCYXkE9V07YUfjPKICFL64EB2Bda3q4QFEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709581588; c=relaxed/simple;
	bh=aOqHk6SVd7G59dSUt4yGvRnSNmhLPrAQTYd8u3xfOEA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DdD9W+3cCzwbuU1T4LSmAt6JbgaZF0btLNd+h8YRqwOJ0g7d2c5RFJAgT+dwdaQ0GbY3iY1+TcbgBycqgf4KvIt6wQvU5RJ3boMlpDD/nX1MA4M5mG3ZW2h9cJznlPPhpIHD30ZrJk5gsYnUXYzPdRxA2/zV8fViyKRHNEDDqPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=if4l83O9; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf618042daso7390571276.0
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 11:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709581586; x=1710186386; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VWzHdRna3zMy+XLYBNvG6plLaOTh5XkeubVVBNUfIw0=;
        b=if4l83O9zqyZF+RJplfo5dSbH52VmsnlZcb+cEBy+Lu4BBdvRbRyDcv4zlSU83N7P7
         UDaQLd1QTNkBkKokjLT7a3ShrDisPSDo4wJD0cBJ/ucXhCYN3nNmDJZnobOWiT2YBPbK
         AJRAmwIu+/Co35w2pOV16b8FkR894pC8PTLgb4FaJA+twPq/cAA7cCGZINXCEPI7MbyX
         CphkbzYw/qG7Li38Qr9yfmKMo7DRF10VrDTBRaZGqxWptKn/4RXSMtR7JzwpU2kVVXo+
         dMHZmWrAzUk1+W+UA6P94dutGKyXKz4CsYsmuTl4XrmqXWgbqYvmszayMSGMHz+kpvdc
         vT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709581586; x=1710186386;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VWzHdRna3zMy+XLYBNvG6plLaOTh5XkeubVVBNUfIw0=;
        b=IKdP5WOApem58W7+ZgZX1i+k8p9SWjc+wp1avPi6wHCevFGz7v90gIg3JBLAeu57m3
         vFvUpOgMV09Fp0TdyOwbshbIJNE0CklvkwaENvV1JKsRL9DrFXUnr/LLCjrmGBWtItiH
         q2NU2PkaBy0CPElkxel5TEvYH/e8KwlE+MwQDn2n/rhD17Uf9z3PPNwvT4qaHAUyWlMA
         YEzpEObq+erftxd7BbanyUR0ArCkBah0fJD8h5yRIIja5BKyJMSnlwe3QSXOrPcGsRS/
         AjeXYZp3sQkaMBQtodZZg90duzftlyZcOtYzbP+a0CfeZwgCO6RpmCxnNOmEnxqVP6+u
         RtsA==
X-Forwarded-Encrypted: i=1; AJvYcCXKpI9I3VGBzqlz951R41q0cA6Dn/sjR4CQGq4YgJ6aZkl6rAjXjFxe9D6qWdsSJnoBko1Ne1YdwWvTManSl/mGcOOn
X-Gm-Message-State: AOJu0YxAUJ03F2XSj21BJCEx3Ji3/ZkmPwuKionfc+Qbby6sruF6h4RH
	dOr72EpuSBmTFhPo35dgXmipgjSLO+U1H7hrcHTltkgFDJrLBNnFaHl43YhrZ+EueNLKKB+xjTg
	cNQ==
X-Google-Smtp-Source: AGHT+IHSp+E82/ypS4UweAZlpJyK2PaD1v+2hDqPO3hjubOPh1Qou0p7AnyKgGQKbThW17QfzK3uokGmnz0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1143:b0:dc7:6cfa:dc59 with SMTP id
 p3-20020a056902114300b00dc76cfadc59mr389188ybu.4.1709581585728; Mon, 04 Mar
 2024 11:46:25 -0800 (PST)
Date: Mon, 4 Mar 2024 11:46:24 -0800
In-Reply-To: <f5bbe9ac-ca35-4c3e-8cd7-249839fbb8b8@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240301075007.644152-1-sandipan.das@amd.com> <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
 <cc8699be-3aae-42aa-9c70-f8b6a9728ee3@amd.com> <f5bbe9ac-ca35-4c3e-8cd7-249839fbb8b8@linux.intel.com>
Message-ID: <ZeYlEGORqeTPLK2_@google.com>
Subject: Re: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits correctly
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sandipan Das <sandipan.das@amd.com>, Like Xu <like.xu.linux@gmail.com>, pbonzini@redhat.com, 
	mizhang@google.com, jmattson@google.com, ravi.bangoria@amd.com, 
	nikunj.dadhania@amd.com, santosh.shukla@amd.com, manali.shukla@amd.com, 
	babu.moger@amd.com, kvm list <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 04, 2024, Dapeng Mi wrote:
>=20
> On 3/1/2024 5:00 PM, Sandipan Das wrote:
> > On 3/1/2024 2:07 PM, Like Xu wrote:
> > > On 1/3/2024 3:50 pm, Sandipan Das wrote:
> > > > With PerfMonV2, a performance monitoring counter will start operati=
ng
> > > > only when both the PERF_CTLx enable bit as well as the correspondin=
g
> > > > PerfCntrGlobalCtl enable bit are set.
> > > >=20
> > > > When the PerfMonV2 CPUID feature bit (leaf 0x80000022 EAX bit 0) is=
 set
> > > > for a guest but the guest kernel does not support PerfMonV2 (such a=
s
> > > > kernels older than v5.19), the guest counters do not count since th=
e
> > > > PerfCntrGlobalCtl MSR is initialized to zero and the guest kernel n=
ever
> > > > writes to it.
> > > If the vcpu has the PerfMonV2 feature, it should not work the way leg=
acy
> > > PMU does. Users need to use the new driver to operate the new hardwar=
e,
> > > don't they ? One practical approach is that the hypervisor should not=
 set
> > > the PerfMonV2 bit for this unpatched 'v5.19' guest.
> > >=20
> > My understanding is that the legacy method of managing the counters sho=
uld
> > still work because the enable bits in PerfCntrGlobalCtl are expected to=
 be
> > set. The AMD PPR does mention that the PerfCntrEn bitfield of PerfCntrG=
lobalCtl
> > is set to 0x3f after a system reset. That way, the guest kernel can use=
 either
>=20
> If so, please add the PPR description here as comments.

Or even better, make that architectural behavior that's documented in the A=
PM.

> > > > ---
> > > >  =C2=A0 arch/x86/kvm/svm/pmu.c | 1 +
> > > >  =C2=A0 1 file changed, 1 insertion(+)
> > > >=20
> > > > diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> > > > index b6a7ad4d6914..14709c564d6a 100644
> > > > --- a/arch/x86/kvm/svm/pmu.c
> > > > +++ b/arch/x86/kvm/svm/pmu.c
> > > > @@ -205,6 +205,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vc=
pu)
> > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pmu->version > 1) {
> > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pmu->global=
_ctrl_mask =3D ~((1ull << pmu->nr_arch_gp_counters) - 1);
> > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pmu->global=
_status_mask =3D pmu->global_ctrl_mask;
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pmu->global_ctrl =3D ~p=
mu->global_ctrl_mask;
>=20
> It seems to be more easily understand to calculate global_ctrl firstly an=
d
> then derive the globol_ctrl_mask (negative logic).

Hrm, I'm torn.  On one hand, awful name aside (global_ctrl_mask should real=
ly be
something like global_ctrl_rsvd_bits), the computation of the reserved bits=
 should
come from the capabilities of the PMU, not from the RESET value.

On the other hand, setting _all_ non-reserved bits will likely do the wrong=
 thing
if AMD ever adds bits in PerfCntGlobalCtl that aren't tied to general purpo=
se
counters.  But, that's a future theoretical problem, so I'm inclined to vot=
e for
Sandipan's approach.

> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index e886300f0f97..7ac9b080aba6 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -199,7 +199,8 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
> kvm_pmu_cap.num_counters_gp);
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pmu->version > 1) {
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 pmu->global_ctrl_mask =3D ~((1ull << pmu->nr_arch_gp_counters)
> - 1);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 pmu->global_ctrl =3D (1ull << pmu->nr_arch_gp_counters) - 1;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 pmu->global_ctrl_mask =3D ~pmu->global_ctrl;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 pmu->global_status_mask =3D pmu->global_ctrl_mask;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > > >  =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pmu->counter_bitmask[KVM_PMC=
_GP] =3D ((u64)1 << 48) - 1;
> >=20

