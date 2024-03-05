Return-Path: <kvm+bounces-11055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D204587258E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:22:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88D1A28387E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8557316427;
	Tue,  5 Mar 2024 17:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vX1bXk8p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57C214A9F
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 17:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709659332; cv=none; b=cyeHGTy8rzr4f3B+hmxLwEzZj3kZkAgQV6P9GJQPvjDEcq2xbNyd+ZZbtuflfKGlRymIcbvp9vc6eXKsMUXlGCKaObw9KJ+lN9jgzkypVL42ZOcsZyyLWJzs1BaVz3hBE7AzSI8FF8KtLrhT17n7QACgZpZolXJv0MwL7MmmdmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709659332; c=relaxed/simple;
	bh=pwOrjfAOm0UVWurpdjRjhZSdf0C9prn8yc/6q2b8AtQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XuGuLjKUKPYgggL4mBJkRoM3wyjm5D4VNFdjwx52P9rIwEnSNzUlkSaUMwRiUs4k0HrPRr9zmTin/EAGyicCGucLuhwV52ADPN10ZqfqpNDDOHSQnwa0Aa58U9RirupmWM1XlSpSuyJqQS0q5BC812qDP4UJ1vhVRprBgkB0UdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vX1bXk8p; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc647f65573so10349327276.2
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 09:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709659330; x=1710264130; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kkawy6SBW/c0hBCVzYm6ir0cPepyH+x2hY6g8C2mgqI=;
        b=vX1bXk8pxp17cyk6WY5Fs9FaXL0d6bq9s058uBlJ9pBdi+HIdrz6cacvo2Ez1Mv73H
         01PO0Dz1bX5EwAAtA5BbOUd8pWVd9NVUG94aHH9kdi/FqkpqTOQ9uMqMUoTMbkpqshuD
         VkD/tHb0Utx7HCNe6R5sryFYwH8od55igALCvGf5l5DQpEK39TDXPiKskJfR/5NfsLVe
         7xT4G3dFvQWcxhMeHjUuX/5yn4VljgUEK60NDDxvIPZ8+EhwD0U4p6sYP9XXQiXovL9f
         D/l9v99TjWLrUeVDdHjvRloEllkEb3pUkFPl2baaEiyLEXRXLQupVKNHhOqARV5CjhT/
         5pXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709659330; x=1710264130;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kkawy6SBW/c0hBCVzYm6ir0cPepyH+x2hY6g8C2mgqI=;
        b=k8dijvTM35OkKoJyFmiIxgpRLu571xHh+Bm7KS0H1g5+0esJTn5BB0KqlIRrQ8B6s2
         +GLVWkWonUambKzhIUKLx6/UuJ/XCiSFYA3R4Rljv0dfxX2lTKafUyteKaqfihFnL8Yl
         RZzUML8lROvVvy39fnySjXox/NRrOIfQK0EHEbPPCG6e3MqRgIeqUTix6GgTWtMrfG6A
         3CY7aADMdMn7CDAtg6mHpBP8g/w8/b4+U4DntXjR9u6fwzIHeRB3yXNCZg558e5DsP0g
         O4JWZl7I+dHiFKV2+KAplQG6RmM9kgQrAHldyxahk2cbYZKWuouyte0i3WYVk3X+anUE
         eRLw==
X-Forwarded-Encrypted: i=1; AJvYcCUtWZXgFyeZLqXtIGj2s+7UhrJoP6eS5g+H+Ej1YlrFN2JgwHY2VKNKAY0wsEVZO/7OP/SMHmc01+kbNCWekZyEfJsG
X-Gm-Message-State: AOJu0YzSkz/Sqrtt84nCVBi9KmbaTuERNt9D6eL+gOwHwksQpYEXg/i6
	y/47d5CqIzZbpGjud3g4WUB6jQh+ImdHKTO4osazOeWzXbG0quPeP2C5GCm+YPxSy5ChG1BPXUI
	8sQ==
X-Google-Smtp-Source: AGHT+IHjijMg6haor2+fxukpIgm7342bWGSF+cpR0joPwOd9ERBEhCSkI+psP3njmNYvnqfOP1a3u8KT1U0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18c9:b0:dcd:5e5d:458b with SMTP id
 ck9-20020a05690218c900b00dcd5e5d458bmr3230561ybb.3.1709659329909; Tue, 05 Mar
 2024 09:22:09 -0800 (PST)
Date: Tue, 5 Mar 2024 09:22:08 -0800
In-Reply-To: <8a846ba5-d346-422e-817b-e00ab9701f19@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240301075007.644152-1-sandipan.das@amd.com> <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
 <cc8699be-3aae-42aa-9c70-f8b6a9728ee3@amd.com> <f5bbe9ac-ca35-4c3e-8cd7-249839fbb8b8@linux.intel.com>
 <ZeYlEGORqeTPLK2_@google.com> <8a846ba5-d346-422e-817b-e00ab9701f19@gmail.com>
Message-ID: <ZedUwKWW7PNkvUH1@google.com>
Subject: Re: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits correctly
From: Sean Christopherson <seanjc@google.com>
To: Like Xu <like.xu.linux@gmail.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	pbonzini@redhat.com, mizhang@google.com, jmattson@google.com, 
	ravi.bangoria@amd.com, nikunj.dadhania@amd.com, santosh.shukla@amd.com, 
	manali.shukla@amd.com, babu.moger@amd.com, kvm list <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 05, 2024, Like Xu wrote:
> On 5/3/2024 3:46 am, Sean Christopherson wrote:
> > > > > > ---
> > > > > >   =C2=A0 arch/x86/kvm/svm/pmu.c | 1 +
> > > > > >   =C2=A0 1 file changed, 1 insertion(+)
> > > > > >=20
> > > > > > diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> > > > > > index b6a7ad4d6914..14709c564d6a 100644
> > > > > > --- a/arch/x86/kvm/svm/pmu.c
> > > > > > +++ b/arch/x86/kvm/svm/pmu.c
> > > > > > @@ -205,6 +205,7 @@ static void amd_pmu_refresh(struct kvm_vcpu=
 *vcpu)
> > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pmu->version > 1) {
> > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pmu->g=
lobal_ctrl_mask =3D ~((1ull << pmu->nr_arch_gp_counters) - 1);
> > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pmu->g=
lobal_status_mask =3D pmu->global_ctrl_mask;
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pmu->global_ctrl =
=3D ~pmu->global_ctrl_mask;
> > >=20
> > > It seems to be more easily understand to calculate global_ctrl firstl=
y and
> > > then derive the globol_ctrl_mask (negative logic).
> >=20
> > Hrm, I'm torn.  On one hand, awful name aside (global_ctrl_mask should =
really be
> > something like global_ctrl_rsvd_bits), the computation of the reserved =
bits should
> > come from the capabilities of the PMU, not from the RESET value.
> >=20
> > On the other hand, setting _all_ non-reserved bits will likely do the w=
rong thing
> > if AMD ever adds bits in PerfCntGlobalCtl that aren't tied to general p=
urpose
> > counters.  But, that's a future theoretical problem, so I'm inclined to=
 vote for
> > Sandipan's approach.
>=20
> I suspect that Intel hardware also has this behaviour [*] although guest
> kernels using Intel pmu version 1 are pretty much non-existent.
>=20
> [*] Table 10-1. IA-32 and Intel=C2=AE 64 Processor States Following Power=
-up,
> Reset, or INIT (Contd.)

Aha!  Nice.  To save people lookups, the table says:

  IA32_PERF_GLOBAL_CTRL:  Sets bits n-1:0 and clears the upper bits.

and=20

  Where "n" is the number of general-purpose counters available in the proc=
essor.

Which means that (a) KVM can handle this in common code and (b) we can dodg=
e the
whole reserved bits chicken-and-egg problem since global_ctrl *can't* be de=
rived
from global_ctrl_mask.

This?  (compile tested only)

---
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 5 Mar 2024 09:02:26 -0800
Subject: [PATCH] KVM: x86/pmu: Set enable bits for GP counters in
 PERF_GLOBAL_CTRL at "RESET"

Set the enable bits for general purpose counters in IA32_PERF_GLOBAL_CTRL
when refreshing the PMU to emulate the MSR's architecturally defined
post-RESET behavior.  Per Intel's SDM:

  IA32_PERF_GLOBAL_CTRL:  Sets bits n-1:0 and clears the upper bits.

and

  Where "n" is the number of general-purpose counters available in the proc=
essor.

This is a long-standing bug that was recently exposed when KVM added
supported for AMD's PerfMonV2, i.e. when KVM started exposing a vPMU with
PERF_GLOBAL_CTRL to guest software that only knew how to program v1 PMUs
(that don't support PERF_GLOBAL_CTRL).  Failure to emulate the post-RESET
behavior results in such guests unknowingly leaving all general purpose
counters globally disabled (the entire reason the post-RESET value sets
the GP counter enable bits is to maintain backwards compatibility).

The bug has likely gone unnoticed because PERF_GLOBAL_CTRL has been
supported on Intel CPUs for as long as KVM has existed, i.e. hardly anyone
is running guest software that isn't aware of PERF_GLOBAL_CTRL on Intel
PMUs.

Note, kvm_pmu_refresh() can be invoked multiple times, i.e. it's not a
"pure" RESET flow.  But it can only be called prior to the first KVM_RUN,
i.e. the guest will only ever observe the final value.

Reported-by: Reported-by: Babu Moger <babu.moger@amd.com>
Cc: Like Xu <like.xu.linux@gmail.com>
Cc: Mingwei Zhang <mizhang@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 87cc6c8809ad..f61ce26aeb90 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -741,6 +741,8 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
+
 	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
 		return;
=20
@@ -750,8 +752,18 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 	 */
 	kvm_pmu_reset(vcpu);
=20
-	bitmap_zero(vcpu_to_pmu(vcpu)->all_valid_pmc_idx, X86_PMC_IDX_MAX);
+	bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	static_call(kvm_x86_pmu_refresh)(vcpu);
+
+	/*
+	 * At RESET, both Intel and AMD CPUs set all enable bits for general
+	 * purpose counters in IA32_PERF_GLOBAL_CTRL (so that software that
+	 * was written for v1 PMUs don't unknowingly leave GP counters disabled
+	 * in the global controls).  Emulate that behavior when refreshing the
+	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
+	 */
+	if (kvm_pmu_has_perf_global_ctrl(pmu))
+		pmu->global_ctrl =3D GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
 }
=20
 void kvm_pmu_init(struct kvm_vcpu *vcpu)

base-commit: 1d7ae977d219e68698fdb9bed1049dc561038aa1
--=20

