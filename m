Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB179743E4A
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 17:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbjF3PIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 11:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbjF3PH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 11:07:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA0B1FF9
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 08:07:55 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-573d70da2dcso18895987b3.1
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 08:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688137675; x=1690729675;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mrWYh3PRBbdzI533s9Ew0EAXehsA/qHZG3mTg4wZnHM=;
        b=M1ViaITYNRj8vOECiWQf6QNdpr/b0hFVhpgzkgimB1iEHmCDCMLI34196l3hwb2wFd
         diTLBgH11Y3Yz/AQl321djbXYGMoKJidYzGGvTA5T3WyfjEVeOfu/C46ymNffPfJsHYq
         AX6XnwSJ7EYOUbJFoT7rcWmRNxbPLl0ucFXnYQsaJeFRdgHbrjh7Zm0BNNpqXt2WieR/
         Lc4y9cDWNbIIKX0TnWVBDT7BxkZAeNVBaT0g3Nc3pwvixMIRUOI96QE8a8DzB93hhASM
         5bzHf/kBbI+E4138JxhDhGCStj77y7PNA7E2S9hUDEQuYFoONX7EnyRouIr6LBKOdA+0
         iGMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688137675; x=1690729675;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mrWYh3PRBbdzI533s9Ew0EAXehsA/qHZG3mTg4wZnHM=;
        b=J+FxpNQO7H+cLJuqoN35vi/gqv291fZ6BSu/OHZPBM0/9MiGvTPqqyAjsY6kUfp54W
         Whv35YMA2oeUuuji1FxhulQtFTuL2Pwa2U6qaEkJKd7PiExOkWG2iukALBEb/78Kfr+K
         t3hjYFL2dwldAl7NJaXnmzEBsHp/Dc+rVtJHuonIKUSroA2Ohv9h+8LDdwBBCAW/J9vD
         2K7wavTrI9FY/Jyd6h7FeAz0saX/PvLCs3X+eVYEzj6EI4qUMoncHNEC7VW6YMnLHQAF
         1jGUGKfxOcdwzUCdhekBsAOt/Ymr777l6nqnPYTklEKw7rlMfICfOO+JE7UC45hWFJ2Y
         Qufw==
X-Gm-Message-State: ABy/qLZ91QZu6z8B4GFrmggrr076AbzR4mpMOfooSnbPeUpYPpEtUeUJ
        1Kl5xojmMExgy89SWQPf68OVYvk/6DU=
X-Google-Smtp-Source: APBJJlHzoZOss0LPcsdk/XcICJPt4SQdaa9IAQxT9IT978Tg6wtIVsT7DmNGf+bLYov52r6dXSriFO4hUJQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d586:0:b0:573:9e16:2cca with SMTP id
 x128-20020a0dd586000000b005739e162ccamr22477ywd.0.1688137674950; Fri, 30 Jun
 2023 08:07:54 -0700 (PDT)
Date:   Fri, 30 Jun 2023 08:07:52 -0700
In-Reply-To: <0a98683f-3e60-1f1b-55df-f2a781929fdf@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-11-weijiang.yang@intel.com> <ZH73kDx6VCaBFiyh@chao-email>
 <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com> <ZIulniryqlj0hLnt@google.com>
 <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com> <ZIywqx6xTAMFyDPT@google.com>
 <0a98683f-3e60-1f1b-55df-f2a781929fdf@intel.com>
Message-ID: <ZJ7vyBw1nbTBOfuf@google.com>
Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception classification
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com,
        gil.neiger@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023, Weijiang Yang wrote:
>=20
> On 6/17/2023 2:57 AM, Sean Christopherson wrote:
> > > Do you mean documentation for #CP as an generic exception or the beha=
vior in
> > > KVM as this patch shows?
> > As I pointed out two *years* ago, this entry in the SDM
> >=20
> >    =E2=80=94 The field's deliver-error-code bit (bit 11) is 1 if each o=
f the following
> >      holds: (1) the interruption type is hardware exception; (2) bit 0
> >      (corresponding to CR0.PE) is set in the CR0 field in the guest-sta=
te area;
> >      (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) th=
e vector
> >      indicates one of the following exceptions: #DF (vector 8), #TS (10=
),
> >      #NP (11), #SS (12), #GP (13), #PF (14), or #AC (17).
> >=20
> > needs to read something like
> >=20
> >    =E2=80=94 The field's deliver-error-code bit (bit 11) is 1 if each o=
f the following
> >      holds: (1) the interruption type is hardware exception; (2) bit 0
> >      (corresponding to CR0.PE) is set in the CR0 field in the guest-sta=
te area;
> >      (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) th=
e vector
> >      indicates one of the following exceptions: #DF (vector 8), #TS (10=
),
> >      #NP (11), #SS (12), #GP (13), #PF (14), #AC (17), or #CP (21)[1]
> >=20
> >      [1] #CP has an error code if and only if IA32_VMX_CR4_FIXED1 enume=
rates
> >          support for the 1-setting of CR4.CET.
>=20
> Hi, Sean,
>=20
> I sent above change request to Gil(added in cc), but he shared different
> opinion on this issue:

Heh, "opinion".

> =C2=A0It may make things clearer if we document the statement above (all
> CET-capable parts enumerate IA32_VMX_BASIC[56] as 1).
>=20
> I will see if we can update future revisions of the SDM to clarify this."

That would be helpful.  Though to be perfectly honest, I simply overlooked =
the
existence of IA32_VMX_BASIC[56].

Thanks!

> Then if this is the case,=C2=A0 kvm needs to check IA32_VMX_BASIC[56] bef=
ore
> inject exception to nested VM.
>=20
> And this patch could be removed, instead need another patch like below:
>=20
> diff --git a/arch/x86/include/asm/msr-index.h
> b/arch/x86/include/asm/msr-index.h
> index ad35355ee43e..6b33aacc8587 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1076,6 +1076,7 @@
> =C2=A0#define VMX_BASIC_MEM_TYPE_MASK=C2=A0=C2=A0=C2=A0 0x003c00000000000=
0LLU
> =C2=A0#define VMX_BASIC_MEM_TYPE_WB=C2=A0=C2=A0=C2=A0 6LLU
> =C2=A0#define VMX_BASIC_INOUT=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0x0040=
000000000000LLU
> +#define VMX_BASIC_CHECK_ERRCODE=C2=A0=C2=A0=C2=A0 0x0140000000000000LLU

"Check Error Code" isn't a great description.  The flag enumerates that the=
re the
CPU does *not* perform consistency checks on the error code when injecting =
hardware
exceptions.

So something like this?

  VMX_BASIC_NO_HW_ERROR_CODE_CC

or maybe

  VMX_BASIC_PM_NO_HW_ERROR_CODE_CC

if we want to capture that only protected mode is exempt (I personally pref=
er
just VMX_BASIC_NO_HW_ERROR_CODE_CC as "PM" is a bit ambiguous).

> @@ -2873,7 +2873,8 @@ static int nested_check_vm_entry_controls(struct
> kvm_vcpu *vcpu,
> =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 should_have_error_code =3D
> =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 intr_type =
=3D=3D INTR_TYPE_HARD_EXCEPTION && prot_mode &&
> =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 x86_except=
ion_has_error_code(vector);
> -=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (CC(has_error_code !=3D should_=
have_error_code))
> +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (!cpu_has_vmx_basic_check_errco=
de() &&
> +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 CC(has_error_co=
de !=3D should_have_error_code))

This is wrong on mutiple fronts:

  1. The new feature flag only excempts hardware exceptions delivered to gu=
ests
     with CR0.PE=3D1.  The above will skip the consistency check for all ev=
ent injection.

  2. KVM needs to check the CPU model that is exposed to L1, not the capabi=
lities
     of the host CPU.

Highlighting the key phrases in the SDM:

  The field's deliver-error-code bit (bit 11) is 1 if each of the following=
 holds: (1) the interruption type is
                                                      ^^^^^^^
  hardware exception; (2) bit 0 (corresponding to CR0.PE) is set in the CR0=
 field in the guest-state area;
  (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vecto=
r indicates one of the following
  exceptions: #DF (vector 8), #TS (10), #NP (11), #SS (12), #GP (13), #PF (=
14), or #AC (17).
 =20
  The field's deliver-error-code bit is 0 if any of the following holds: (1=
) the interruption type is not hardware
                                             ^^^^^^
  exception; (2) bit 0 is clear in the CR0 field in the guest-state area; o=
r (3) IA32_VMX_BASIC[56] is read as
  0 and the vector is in one of the following ranges: 0=E2=80=937, 9, 15, 1=
6, or 18=E2=80=9331.

I think what we want is:

		/* VM-entry interruption-info field: deliver error code */
		if (!prot_mode || intr_type !=3D INTR_TYPE_HARD_EXCEPTION ||
		    !nested_cpu_has_no_hw_error_code_cc(vcpu)) {
			should_have_error_code =3D
				intr_type =3D=3D INTR_TYPE_HARD_EXCEPTION && prot_mode &&
				x86_exception_has_error_code(vector);
			if (CC(has_error_code !=3D should_have_error_code))
				return -EINVAL;
		}
