Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EB478751A
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 18:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242351AbjHXQTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 12:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242474AbjHXQTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 12:19:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0C01FEA
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 09:18:46 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59285f1e267so13180767b3.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 09:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692893918; x=1693498718;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sImAtATpIPQ4GjN+FyqtcPnL+F+zQxPqPl0ZQe9C7p4=;
        b=PoMAnXq2BcFJ+pyjJq9N4dgyu88oSIyYxcGI0j6ILiPfFgF42/e9n6EDb99fwa+yXx
         LDrN37KLYc2Bt7GLkqImYdR4S67S8V8ZAjKvs8szL9tbwFuqX30/WeH0x4B3NZsLucl3
         Nct8q8zMWyfKTdebcDMD8MUuZS2/etO2nxbN+ADeJ72JtQc9N4n8PyvDa/UwFhUbiW96
         6aOhcp6+cRDwzj+t4JK5DY37ZW9P9ATR1p0sP3jotY0kjrIQ93g1AD7OceO8XMPg0uCG
         38ddlNC8DG+t4JFdj6diPaeH7PxsP26Lkpfkog12B3/ye+jamrM+OxHdfLcvl/DInv2a
         pIYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692893918; x=1693498718;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sImAtATpIPQ4GjN+FyqtcPnL+F+zQxPqPl0ZQe9C7p4=;
        b=eVuLHe2E8IiC+RARNksQouHTRNHCfdJKbO9GsLHduxCFBGDyXQYCl4j/oCamyePrhg
         m4OBf7IOEmye8uwzp0D9B1QwM+t1v/tSTPUpzY57xkKa1/czJfcQx+KgiD3DCdMfQasp
         jSgPEvbXPIel1R/njU3KQZiX0yukHbav0HNM57QXq9p7pdbJ7pnLeO6VV/K9J5GlkYwu
         GEoKjPElTWnB3TdqjQIzznHjQZklEqrkwhxkPeZVnPsG5kjSZ7odmeGgSWxSpqlc1qkq
         cE+x9Xu8s8TkbQGCUvvkbagN++enyOa/8YgX6dpjGB/lSpz+ekvuazmkT1XG81YnKfDf
         UeYQ==
X-Gm-Message-State: AOJu0Yy3cd/QckkV7mYSBtwWOlc7ile7b9gA4svGAwLIq2qd4w4sQIx1
        9xaA19DN/qXjH4CbZmzkHzzC+3OEr2Y=
X-Google-Smtp-Source: AGHT+IF15IghsAKoHh0BOfq3fhfVb8/NkHJrUkBZNEHBhDSnmhcDKgKWEs+nwE9NdKNbCRWVreoY8X0QilA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2f87:b0:586:e91a:46c2 with SMTP id
 ew7-20020a05690c2f8700b00586e91a46c2mr301765ywb.4.1692893918800; Thu, 24 Aug
 2023 09:18:38 -0700 (PDT)
Date:   Thu, 24 Aug 2023 09:18:37 -0700
In-Reply-To: <e8bfb368-2869-6ad3-35de-8f7ee5568661@intel.com>
Mime-Version: 1.0
References: <20230720115810.104890-1-weijiang.yang@intel.com>
 <ZMqxxH5mggWYDhEx@google.com> <a5bc09c4-cc24-1e70-b70f-dbbce4251717@intel.com>
 <ZMvfxFgHlWMyrvbq@google.com> <e8bfb368-2869-6ad3-35de-8f7ee5568661@intel.com>
Message-ID: <ZOeC3XYT7kCy/Ukn@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86:VMX: Fixup for VMX test failures
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Gil Neiger <gil.neiger@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 24, 2023, Weijiang Yang wrote:
> On 8/4/2023 1:11 AM, Sean Christopherson wrote:
> > On Thu, Aug 03, 2023, Weijiang Yang wrote:
> > > > This is wrong, no?  The consistency check is only skipped for PM, t=
he above CR0.PE
> > > > modification means the target is RM.
> > > I think this case is executed with !CPU_URG, so RM is "converted" to =
PM because we
> > > have below in KVM:
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 bool urg =3D nested_cpu_has2(vmcs12,
> > > SECONDARY_EXEC_UNRESTRICTED_GUEST);
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 bool prot_mode =3D !urg || vmcs12->guest_cr0 & X86=
_CR0_PE;
> > > ...
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 if (!prot_mode || intr_type !=3D INTR_TYPE_HARD_EX=
CEPTION ||
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !nested_cpu_has_no_hw_errc=
ode(vcpu)) {
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*=
 VM-entry interruption-info field: deliver error code */
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sh=
ould_have_error_code =3D
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 intr_type =3D=3D INTR_TYPE_HA=
RD_EXCEPTION &&
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 prot_mode &&
> > > x86_exception_has_error_code(vector);
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (CC(has_error_code !=3D should_have_error_code))
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 }
> > >=20
> > > so on platform with basic.errcode =3D=3D 1, this case passes.
> > Huh.  I get the logic, but IMO based on the SDM, that's a ucode bug tha=
t got
> > propagated into KVM (or an SDM bug, which is my bet for how this gets t=
reated).
> >=20
> > I verified HSW at least does indeed generate VM-Fail and not VM-Exit(IN=
VALID_STATE),
> > so it doesn't appear that KVM is making stuff (for once).  Either that =
or I'm
> > misreading the SDM (definite possibility), but the only relevant condit=
ion I see is:
> >=20
> >    bit 0 (corresponding to CR0.PE) is set in the CR0 field in the guest=
-state area
> >=20
> > I don't see anything in the SDM that states the CR0.PE is assumed to be=
 '1' for
> > consistency checks when unrestricted guest is disabled.
> >=20
> > Can you bug a VMX architect again to get clarification, e.g. to get an =
SDM update?
> > Or just point out where I missed something in the SDM, again...
>=20
> Sorry for the delayed response! Also added Gil in cc.

Hey Gil!  Thanks for humoring me again.

>=20
> I got reply from Gil as below:
>=20
> "I am not sure whether you (or Sean) are referring to guest state or host=
 state.

The question is whether trying to do VMLAUNCH/VMRESUME with this scenario

  1. unrestricted guest disabled
  2. GUEST_CR0.PE =3D 0
  3. #GP injection _without_ an error code

should VM-Fail due injecting a #GP without an error code, or VM-Exit(INVALI=
D_STATE)
due to CR0.PE=3D0 without unrestricted guest support.

Hardware (I personally tested on Haswell) signals VM-Fail, which doesn't ma=
tch
what's in the SDM:

  The field's deliver-error-code bit (bit 11) is 1 if each of the following=
 holds:

   (1) the interruption type is hardware exception;
   (2) bit 0 (corresponding to CR0.PE) is set in the CR0 field in the guest=
-state area;
   (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vect=
or indicates
       one of the following exceptions: #DF (vector 8), #TS (10), #NP (11),=
 #SS (12),
       #GP (13), #PF (14), or #AC (17).

Specifically #2 doesn't say anything about the check treating GUEST_CR0.PE =
as '1'
if unrestricted guest is disabled.
