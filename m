Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9918B5915F3
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 21:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237176AbiHLT12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 15:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiHLT1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 15:27:25 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD28BB08AC
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 12:27:24 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id n133so2220192oib.0
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 12:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=RFQCcD+o7jwAXDtp4U1/kPCj0a6x0GtskgYZEyvj9NE=;
        b=VN5AtKQ/0zk7x64khzHNWqzjm0YpR7+d4JF2kbafdw/v3J3hYRIdcNzqJ8FPF4RhUs
         QxLkUT7lD4USFVw1hxOGVaETi0LiAOQ7Se5IDMBtHLQrqUhWO9QFA1vmg/sR7Jva4mUN
         bXy3mS5hSvGH8qcmVfFGwtUzPTOuRVmUxe35w4vwvoeQRrC2muArkWZIRADALVts/l9C
         r0DlbDCVBXh4HDqzsk0LtHtUdWg1S2ZSvpJr8uxePjMrBacUFb0muvGa4vGkooI5euss
         QoKyMZdVvCNs8rQQAH6gfCe3pffgGNcqP5ZaavIFXTBtopeW3+iI8Oi2RHV4K9kHIxKw
         ADXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=RFQCcD+o7jwAXDtp4U1/kPCj0a6x0GtskgYZEyvj9NE=;
        b=G3dJlZRtYuwgTeq7ByiKN0NYK5pjtmu7nrEgkP0E1RlCU/ESiHMeEUyKry6WFw/2xy
         IC7Eiq89/MeHcev6mx0KQ5MlOk2mMVowbM7PCa/jPZJfBFhR2wynYGGHcQ2NYVW0yWsg
         0SLfESM5kW2Zm2lhCStChIA/MhzX7qghuyhWryFws6/dyg0ferXtqlDjFxJQV1Voxmtb
         BrMkOoi3KE4oBuorK/kbfeRkpv6SHcI07O8sNTd9420qfsvCwQrnCJ7sYVUgJ/lLUZ3+
         lTaja6GDV73xgKnFZuGhoQQ9wucvHrS4sSQjankHtQJgzqsaA5Tif+PT+MycyM8i7fWj
         z79A==
X-Gm-Message-State: ACgBeo3wkKcdW4aRvAalOCMPGLSPobV+S4UGFPvcqL5LgePmKyLAxOyH
        ZEk2cfL+2nRCA7w3Yx54i/HLbBGyZ820HQlo/6/86Q==
X-Google-Smtp-Source: AA6agR6UTYEA+QjXIoZYrda4A+K5joJ6JqfQgfoRbqeFCe5cFOm100RmivhhsKSDVQ65QXNMpukAivi55f0ZGzlLtNY=
X-Received: by 2002:a05:6808:150f:b0:343:3202:91cf with SMTP id
 u15-20020a056808150f00b00343320291cfmr5737538oiw.112.1660332443800; Fri, 12
 Aug 2022 12:27:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220812014706.43409-1-yuan.yao@intel.com> <20220812020206.foknky4hghgsadby@yy-desk-7060>
In-Reply-To: <20220812020206.foknky4hghgsadby@yy-desk-7060>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 12 Aug 2022 12:27:12 -0700
Message-ID: <CALMp9eSj3SMRkSzgFcFit1up7T8-Wmu7u3ePMVfkqty6CtR6kA@mail.gmail.com>
Subject: Re: [PATCH 1/1] kvm: nVMX: Checks "VMCS shadowing" with VMCS link
 pointer for non-root mode VM{READ,WRITE}
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Yuan Yao <yuan.yao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jon Cargille <jcargill@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022 at 7:02 PM Yuan Yao <yuan.yao@linux.intel.com> wrote:
>
> On Fri, Aug 12, 2022 at 09:47:06AM +0800, Yuan Yao wrote:
> > Add checking to VMCS12's "VMCS shadowing", make sure the checking of
> > VMCS12's vmcs_link_pointer for non-root mode VM{READ,WRITE} happens
> > only if VMCS12's "VMCS shadowing" is 1.
> >
> > SDM says that for non-root mode the VMCS's "VMCS shadowing" must be 1
> > (and the corresponding bits in VMREAD/VMWRITE bitmap must be 0) when
> > condition checking of [B] is reached(please refer [A]), which means
> > checking to VMCS link pointer for non-root mode VM{READ,WRITE} should
> > happen only when "VMCS shadowing" =3D 1.
> >
> > Description from SDM Vol3(April 2022) Chapter 30.3 VMREAD/VMWRITE:
> >
> > IF (not in VMX operation)
> >    or (CR0.PE =3D 0)
> >    or (RFLAGS.VM =3D 1)
> >    or (IA32_EFER.LMA =3D 1 and CS.L =3D 0)
> > THEN #UD;
> > ELSIF in VMX non-root operation
> >       AND (=E2=80=9CVMCS shadowing=E2=80=9D is 0 OR
> >            source operand sets bits in range 63:15 OR
> >            VMREAD bit corresponding to bits 14:0 of source
> >            operand is 1)  <------[A]
> > THEN VMexit;
> > ELSIF CPL > 0
> > THEN #GP(0);
> > ELSIF (in VMX root operation AND current-VMCS pointer is not valid) OR
> >       (in VMX non-root operation AND VMCS link pointer is not valid)
> > THEN VMfailInvalid;  <------ [B]
> > ...
> >
> > Fixes: dd2d6042b7f4 ("kvm: nVMX: VMWRITE checks VMCS-link pointer befor=
e VMCS field")
> > Signed-off-by: Yuan Yao <yuan.yao@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index ddd4367d4826..30685be54c5d 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -5123,6 +5123,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
> >                */
> >               if (vmx->nested.current_vmptr =3D=3D INVALID_GPA ||
> >                   (is_guest_mode(vcpu) &&
> > +                  nested_cpu_has_shadow_vmcs(vcpu) &&
>
> Oops, should be "nested_cpu_has_shadow_vmcs(get_vmcs12(vcpu))".
>
> >                    get_vmcs12(vcpu)->vmcs_link_pointer =3D=3D INVALID_G=
PA))
> >                       return nested_vmx_failInvalid(vcpu);
> >
> > @@ -5233,6 +5234,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
> >        */
> >       if (vmx->nested.current_vmptr =3D=3D INVALID_GPA ||
> >           (is_guest_mode(vcpu) &&
> > +          nested_cpu_has_shadow_vmcs(vcpu) &&
>
> Ditto.
>
> >            get_vmcs12(vcpu)->vmcs_link_pointer =3D=3D INVALID_GPA))
> >               return nested_vmx_failInvalid(vcpu);
> >
> > --
> > 2.27.0
> >
