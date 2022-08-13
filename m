Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B605917CA
	for <lists+kvm@lfdr.de>; Sat, 13 Aug 2022 02:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbiHMAbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 20:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbiHMAbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 20:31:09 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8669C9E113
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 17:31:05 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id bb16so2836408oib.11
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 17:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=aluPyblllUTHog5IvLHaud/5NgeXPV4w8dlHMX76A8s=;
        b=ggBMktobgv700s7tY6pG/2GTBcHb7cOxBPMzCha0P2Quselems4ov5KTFktWczpn4r
         v/Gdkonc3yBqzfjMyQuGqb1iTRbgpsuUo9k5v7wf4ArTkj1B1VnDHJYcSIWJUlnHXoP3
         u+oMBzpEvBV4jz9dk5vEZcZdHW09e8BceSrAvKK22+Ph68g0GqXwv7372DbhcMTAvuky
         u/CtfFjrrWjT86JxOhrCruqpJQmoMl2Bmqo+VWgd/8RJcsinkkpsVAPs5BDS6wI5K6TV
         9prPEOZJZW5iBzmvFJuvBAphqdfwyidhW9ojeHJGjLDxiSx0HiPq7t7fMheyx2lA489R
         XjqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=aluPyblllUTHog5IvLHaud/5NgeXPV4w8dlHMX76A8s=;
        b=EwFmcs3mzMd0nhfJD2GFrZiFdhkLbnJBVxViBFcTVoD8JkNJ9BQ7pRzSsZY1v9ybBA
         W755u0vT5acOgR3qQCCgpYf7XvxH/wSC/AOpTpj9ewPRTUCYhFgGzTw9grWdyhtsWjZu
         kMIGECx07kgVx2ZdHUMakZpbK06c6ukR5RxmD1VNb2GTyrmsmZ5Z6q2+WDoqv7nJ2rm1
         QGXsL4UXNkG+Jc60XSmPnUdYxfTxNF7OKuo4nVmWBkod5OrwtG7Ckmc5z0/LLd2nV6aL
         DnA0m0fYTV8Nt6VsvpuaT5MulzDLC+vqloxs6IAFa9YI3xvIYAGICKmdbf7WApxddWpD
         lEJQ==
X-Gm-Message-State: ACgBeo0WNS6ymvprENaAjPO4W4yUzFNhlZ671gTjvurIA8eIvh6qdiwj
        9iGjAVtvMBQTPy2YrkFrl+g4mBK6YO+Eb08a20wL9A==
X-Google-Smtp-Source: AA6agR76qTUDAHQ3llWsfoj370IovIl+cuugUuw5E/5GxFENtYEkWPrepIALm+PG/pOdoJ8MGUf3zzTQFEEIIqZkbdA=
X-Received: by 2002:a05:6808:150f:b0:343:3202:91cf with SMTP id
 u15-20020a056808150f00b00343320291cfmr6150138oiw.112.1660350664659; Fri, 12
 Aug 2022 17:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220812014706.43409-1-yuan.yao@intel.com> <20220812020206.foknky4hghgsadby@yy-desk-7060>
 <CALMp9eRejAUVzFOsASBc-Md8KUeS1mzqOm9WCJ9dBFkc_NeOJg@mail.gmail.com> <20220812230758.bkpukdocsflxxrru@sapienza>
In-Reply-To: <20220812230758.bkpukdocsflxxrru@sapienza>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 12 Aug 2022 17:30:53 -0700
Message-ID: <CALMp9eT6jSz02L89RBoKuiz3fAo-EqS-Q2B0qF3HrcE1SZ-izw@mail.gmail.com>
Subject: Re: [PATCH 1/1] kvm: nVMX: Checks "VMCS shadowing" with VMCS link
 pointer for non-root mode VM{READ,WRITE}
To:     Yao Yuan <yaoyuan0329os@gmail.com>
Cc:     Yuan Yao <yuan.yao@linux.intel.com>, Yuan Yao <yuan.yao@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
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

On Fri, Aug 12, 2022 at 4:08 PM Yao Yuan <yaoyuan0329os@gmail.com> wrote:
>
> On Fri, Aug 12, 2022 at 12:33:05PM -0700, Jim Mattson wrote:
> > On Thu, Aug 11, 2022 at 7:02 PM Yuan Yao <yuan.yao@linux.intel.com> wro=
te:
> > >
> > > On Fri, Aug 12, 2022 at 09:47:06AM +0800, Yuan Yao wrote:
> > > > Add checking to VMCS12's "VMCS shadowing", make sure the checking o=
f
> > > > VMCS12's vmcs_link_pointer for non-root mode VM{READ,WRITE} happens
> > > > only if VMCS12's "VMCS shadowing" is 1.
> > > >
> > > > SDM says that for non-root mode the VMCS's "VMCS shadowing" must be=
 1
> > > > (and the corresponding bits in VMREAD/VMWRITE bitmap must be 0) whe=
n
> > > > condition checking of [B] is reached(please refer [A]), which means
> > > > checking to VMCS link pointer for non-root mode VM{READ,WRITE} shou=
ld
> > > > happen only when "VMCS shadowing" =3D 1.
> > > >
> > > > Description from SDM Vol3(April 2022) Chapter 30.3 VMREAD/VMWRITE:
> > > >
> > > > IF (not in VMX operation)
> > > >    or (CR0.PE =3D 0)
> > > >    or (RFLAGS.VM =3D 1)
> > > >    or (IA32_EFER.LMA =3D 1 and CS.L =3D 0)
> > > > THEN #UD;
> > > > ELSIF in VMX non-root operation
> > > >       AND (=E2=80=9CVMCS shadowing=E2=80=9D is 0 OR
> > > >            source operand sets bits in range 63:15 OR
> > > >            VMREAD bit corresponding to bits 14:0 of source
> > > >            operand is 1)  <------[A]
> > > > THEN VMexit;
> > > > ELSIF CPL > 0
> > > > THEN #GP(0);
> > > > ELSIF (in VMX root operation AND current-VMCS pointer is not valid)=
 OR
> > > >       (in VMX non-root operation AND VMCS link pointer is not valid=
)
> > > > THEN VMfailInvalid;  <------ [B]
> > > > ...
> > > >
> > > > Fixes: dd2d6042b7f4 ("kvm: nVMX: VMWRITE checks VMCS-link pointer b=
efore VMCS field")
> > > > Signed-off-by: Yuan Yao <yuan.yao@intel.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/nested.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > index ddd4367d4826..30685be54c5d 100644
> > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > @@ -5123,6 +5123,7 @@ static int handle_vmread(struct kvm_vcpu *vcp=
u)
> > > >                */
> > > >               if (vmx->nested.current_vmptr =3D=3D INVALID_GPA ||
> > > >                   (is_guest_mode(vcpu) &&
> > > > +                  nested_cpu_has_shadow_vmcs(vcpu) &&
> > >
> > > Oops, should be "nested_cpu_has_shadow_vmcs(get_vmcs12(vcpu))".
> > >
> > > >                    get_vmcs12(vcpu)->vmcs_link_pointer =3D=3D INVAL=
ID_GPA))
> > > >                       return nested_vmx_failInvalid(vcpu);
> > > >
> > > > @@ -5233,6 +5234,7 @@ static int handle_vmwrite(struct kvm_vcpu *vc=
pu)
> > > >        */
> > > >       if (vmx->nested.current_vmptr =3D=3D INVALID_GPA ||
> > > >           (is_guest_mode(vcpu) &&
> > > > +          nested_cpu_has_shadow_vmcs(vcpu) &&
> > >
> > > Ditto.
> > >
> > > >            get_vmcs12(vcpu)->vmcs_link_pointer =3D=3D INVALID_GPA))
> > > >               return nested_vmx_failInvalid(vcpu);
> > > >
> > > > --
> >
> > These checks are redundant, aren't they?
> >
> > That is, nested_vmx_exit_handled_vmcs_access() has already checked
> > nested_cpu_has_shadow_vmcs(vmcs12).
>
> Ah, you're right it does there.
>
> That means in L0 we handle this for vmcs12 which has shadow VMCS
> setting and the corresponding bit in the bitmap is 0(so no vmexit to
> L1 and the read/write should from/to vmcs12's shadow vmcs, we handle
> this here to emulate this), so we don't need to check the shdaow VMCS
> setting here again. Is this the right understanding ?

That is correct.
