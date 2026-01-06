Return-Path: <kvm+bounces-67166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 22DFBCFA9BA
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 20:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8565D32714ED
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 18:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E563135FF66;
	Tue,  6 Jan 2026 18:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TEFnw/JE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887A2357A26
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 18:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767723704; cv=none; b=Jr2TC2w4JyzprgfZcMUcIZV9NZyEYAr3wEuCuekMHWIQCqw/+3XavF+SZO1RKdQphPiNrZStFeWFBADOG/d1szHgRzHU1gbAxQYUuWmEp64jPr0XQiUOhMaH6rNCqhELHUcHq8DjYLK6SQOGLTdtY8G8J0TqzcbSSJmWfGMXTag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767723704; c=relaxed/simple;
	bh=Bl6XDOLwidc+xN/ClLn7iVyKIdYH/visEQ/I6Z+8UJ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FMP1YzN5yZCtOPurV7nYesMDW14Q3saTwK38L3ViXffoBxO4QSBZBDi3/JldH5uzLlDJfkO65jMYA+VIb0+pTMUa3dJLrXmd4RLt+46D/M7KbMaNC5EZLiu6ENtmqwBJhtJemy4PTpNxAaiCCsGe7aWeJkvvxAM2jsZGHwx5dDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TEFnw/JE; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b82c2c2ca2so2148271b3a.1
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 10:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767723702; x=1768328502; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W8ZAJfxmUxCt9e0XaC2RPly2nEPLTh+BniHGcDKTFfg=;
        b=TEFnw/JEieG5L8x1RFi6Yl8sxmf5knxIz3zHC/rjk84pUlBXyDm+Vh3hNtiyFDId/t
         1LINmT26B+NOQXb9vzparCthHARiZWdY+SvAflgwMVTvhPiCk9JSjnxc+f1JTDfZSMiT
         dN4gZfQI1tUhB7GtO8nHqC0LT2noZCmXAv+rb+qWH7LF7MoWgHPANOiN7BM/20BZdHzP
         tSRvCkXVzjhZwR3wWAOH4qqaOW/nOgb2jrTbU9n3eNUNZlrOOS04tK8ruQQlLtiTcbz+
         q1McCUP9/5gjrxFVqRS4P3DhsJi9A+fqeewcLrxVQ3f0/RuG1GU3KA8rSoKyoH0QM6Y5
         1JBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767723702; x=1768328502;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W8ZAJfxmUxCt9e0XaC2RPly2nEPLTh+BniHGcDKTFfg=;
        b=AU+uO6sHqt3RhU17Rv+YzTGCrBrrX/Hl0gyVzEc9xEwow1QM8r0uDnw1e0xobiWn1C
         CFEXlajNBXzRmS0NdHtG7IlKfPC9l7p9pwSj0GrNVIu/4kgUECMahOnMzFXQNhAqS7b2
         aJmXoI51qpTyqzFN32hR/8Dxjg1MFvDuuxdp+XxyIApQdmbzmBXTQcEJs58rGVUZyiUN
         NqpjjkhznqgUIuPj8V1URW2vLfesm9OZxez23bOvkbq5ZzqvfZ1fc2jybtoRZYpGOgn3
         sAqDjd5/DhATjQY1CXcay4B2t8/Knz0/ShOmp2c1C5/MhJytcKAKDJ0bpCUXlI0KQs7+
         0L8w==
X-Forwarded-Encrypted: i=1; AJvYcCXln8Q/P8uk+wItd9KO4r2Eli4hK09S7eeAPaTk9uVxZ88GGPz7JKAXI6kXyPoTG92kl58=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNSA1/C5cIrQmoJ22MIDjqmesohvSN1IfWm44417MVRzQVzNY9
	Ya7qNwnWY0TawGDKOxfiD9pALZM6CDptohBYZxbtQt4DEYnBFmTRHidO8dVvsKhj+lGbkeynNo2
	hqCYotQ==
X-Google-Smtp-Source: AGHT+IH4UHkkaPt4saKx0hwS3DhDSHEE36CUYCL+UoywQQ5oTnr/9U126O/2eFXqpQrj/giwLrl9r1XB+1s=
X-Received: from pfbfo24.prod.google.com ([2002:a05:6a00:6018:b0:772:749b:de38])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3409:b0:7f0:8031:70b8
 with SMTP id d2e1a72fcca58-818829f2c62mr3824968b3a.51.1767723701907; Tue, 06
 Jan 2026 10:21:41 -0800 (PST)
Date: Tue, 6 Jan 2026 10:21:40 -0800
In-Reply-To: <20260106041250.2125920-2-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106041250.2125920-1-chengkev@google.com> <20260106041250.2125920-2-chengkev@google.com>
Message-ID: <aV1StCzKWxAQ-B93@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Generate #UD for certain instructions when
 SVME.EFER is disabled
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2026, Kevin Cheng wrote:
> The AMD APM states that VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and
> INVLPGA instructions should generate a #UD when EFER.SVME is cleared.
> Currently, when VMLOAD, VMSAVE, or CLGI are executed in L1 with
> EFER.SVME cleared, no #UD is generated in certain cases. This is because
> the intercepts for these instructions are cleared based on whether or
> not vls or vgif is enabled. The #UD fails to be generated when the
> intercepts are absent.
>=20
> INVLPGA is always intercepted, but there is no call to
> nested_svm_check_permissions() which is responsible for checking
> EFER.SVME and queuing the #UD exception.

Please split the INVLPGA fix to a separate patch, it's very much a separate
logical change.  That will allow for more precise shortlogs, e.g.

  KVM: SVM: Recalc instructions intercepts when EFER.SVME is toggled

and

  KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=3D0

> Fix the missing #UD generation by ensuring that all relevant
> instructions have intercepts set when SVME.EFER is disabled and that the
> exit handlers contain the necessary checks.
>=20
> VMMCALL is special because KVM's ABI is that VMCALL/VMMCALL are always
> supported for L1 and never fault.
>=20
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 24d59ccfa40d9..fc1b8707bb00c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -228,6 +228,14 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  			if (!is_smm(vcpu))
>  				svm_free_nested(svm);
> =20
> +			/*
> +			 * If EFER.SVME is being cleared, we must intercept these

No pronouns.

			/*
			 * Intercept instructions that #UD if EFER.SVME=3D0, as
			 * SVME must be set even when running the guest, i.e.
			 * hardware will only ever see EFER.SVME=3D1.
			 */

> +			 * instructions to ensure #UD is generated.
> +			 */
> +			svm_set_intercept(svm, INTERCEPT_CLGI);

What about STGI?  Per the APM, it #UDs if:

  Secure Virtual Machine was not enabled (EFER.SVME=3D0) and both of the fo=
llowing
  conditions were true:
    =E2=80=A2 SVM Lock is not available, as indicated by CPUID Fn8000_000A_=
EDX[SVML] =3D 0.
    =E2=80=A2 DEV is not available, as indicated by CPUID Fn8000_0001_ECX[S=
KINIT] =3D 0.


And this code in init_vmcb() can/should be dropped:

	if (vgif) {
		svm_clr_intercept(svm, INTERCEPT_STGI);
		svm_clr_intercept(svm, INTERCEPT_CLGI);
		svm->vmcb->control.int_ctl |=3D V_GIF_ENABLE_MASK;
	}

> +			svm_set_intercept(svm, INTERCEPT_VMSAVE);
> +			svm_set_intercept(svm, INTERCEPT_VMLOAD);
> +			svm->vmcb->control.virt_ext &=3D ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
>  		} else {
>  			int ret =3D svm_allocate_nested(svm);
> =20
> @@ -242,6 +250,15 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  			 */
>  			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
>  				set_exception_intercept(svm, GP_VECTOR);
> +
> +			if (vgif)
> +				svm_clr_intercept(svm, INTERCEPT_CLGI);
> +
> +			if (vls) {
> +				svm_clr_intercept(svm, INTERCEPT_VMSAVE);
> +				svm_clr_intercept(svm, INTERCEPT_VMLOAD);
> +				svm->vmcb->control.virt_ext |=3D VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;

This is wrong.  In the rather absurd scenario that the vCPU model presented=
 to
the guest is an Intel CPU, KVM needs to intercept VMSAVE/VMLOAD to deal wit=
h the
SYSENTER MSRs.

This logic will also get blasted away if svm_recalc_instruction_intercepts(=
)
runs.

So rather than manually handle the intercepts in svm_set_efer() and fight r=
ecalcs,
trigger KVM_REQ_RECALC_INTERCEPTS and teach svm_recalc_instruction_intercep=
ts()
about EFER.SVME handling.

After the dust settles, it might make sense to move the #GP intercept logic=
 into
svm_recalc_intercepts() as well, but that's not a priority.

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 24d59ccfa40d..0b5e6a7e004b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -243,6 +243,8 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
                        if (svm_gp_erratum_intercept && !sev_guest(vcpu->kv=
m))
                                set_exception_intercept(svm, GP_VECTOR);
                }
+
+               kvm_make_request(KVM_REQ_RECALC_INTERCEPTS, vcpu);
        }
=20
        svm->vmcb->save.efer =3D efer | EFER_SVME;


> +			}
>  		}
>  	}
> =20
> @@ -2291,8 +2308,14 @@ static int clgi_interception(struct kvm_vcpu *vcpu=
)
> =20
>  static int invlpga_interception(struct kvm_vcpu *vcpu)
>  {
> -	gva_t gva =3D kvm_rax_read(vcpu);
> -	u32 asid =3D kvm_rcx_read(vcpu);
> +	gva_t gva;
> +	u32 asid;
> +
> +	if (nested_svm_check_permissions(vcpu))
> +		return 1;

Please split the INVLPGA fix to a separate patch.

> +
> +	gva =3D kvm_rax_read(vcpu);
> +	asid =3D kvm_rcx_read(vcpu);

Eh, I'd rather keep the immediate initialization of gva and asid.  Reading =
RAX
and RCX is basically free and completely harmless, and in all likelihood th=
e
compiler will defer the loads until after the permission checks anyways.

> =20
>  	/* FIXME: Handle an address size prefix. */
>  	if (!is_long_mode(vcpu))
> --=20
> 2.52.0.351.gbe84eed79e-goog
>=20

