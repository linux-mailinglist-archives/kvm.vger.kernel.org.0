Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A706F5915FE
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 21:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbiHLTdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 15:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbiHLTdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 15:33:17 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99301B14C8
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 12:33:16 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id h9-20020a9d5549000000b0063727299bb4so1184154oti.9
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 12:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=pyCzP0WJ+v7YYl7i0GdEcJsuc5xybpRZaZrTHBnUyuI=;
        b=tjBxXmKuFTbo/X5C0AifdNg85hQbAM5FOzw7DFgL9vEIH0+EFxcG2KUUxhswBHH0RJ
         AxCBrTV2u74aJ1qjAwWd4l+TbydCdbBAL4YSXWaBntv8f3NaJPz/ykssjHULMNPf3BLK
         1Gz+eE3jKkZFObGHsDXG6tQKqedsUiEpEhIrdt8nUeoXDHd1wWZ6gpWNhHJTD237nA5R
         ESMg/BtmQvp6kSM2e3D6zGTgo7NgIvwg7xP+6ISs8N2nJxOncgmPZQOkaxzM0KcwdreB
         5q+A6A4tDa6vK8LK2+QDrt1vf1RZWewf80LKxMOksOEIbvZHF70DzTenT8LjOvQuuQKj
         g2Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=pyCzP0WJ+v7YYl7i0GdEcJsuc5xybpRZaZrTHBnUyuI=;
        b=GeT29oc9r5b0gqScQG+lxHGKuhUf7JwXLAhz3OdMCMBN5Uo8osG65xQ+XX6sk12Xgd
         gXx16y04jAhSZR0BPuMwv/YQRK7JhTs5CiFSF+ux5apDRka5oKdoAlTvibNdySb0v3A2
         6gav5MYfkzKff7qF0VnjK8RI2MbTqgTHlmJs4q5lv92ULHJXbt8ueIJ1cyprAPC4xZEi
         Wb63Wgqd5v5mNqHfwIP9OMmbLJgTXvEgEhohgEkd2Mv0B9Q+NuAXXoHRxYRDYVF/zZ+L
         jsFim5P+Ic57NPS1+015RvvlaeTft+6dzClo3G8ulq6/2avrFPL9ZrnATwmRmHD/dBr9
         KLNw==
X-Gm-Message-State: ACgBeo0ppWiJejlJcUY55ty0L/5oOxZyAZxqOiwltBdtHGU3w6ZarRwo
        cvP7iJEYHmXPObMaiZWgk4RY3k2TeMGrJRwU0VxB4g==
X-Google-Smtp-Source: AA6agR4q5K+d+SumrFuiYTU4yOXlMwxRoORIsQLNRB++Mt2hVl9TwB5nW6XFmnhTrVWMiVw9uD19XytcSSZtjHa9cOw=
X-Received: by 2002:a9d:6517:0:b0:636:a8e7:4e86 with SMTP id
 i23-20020a9d6517000000b00636a8e74e86mr2104096otl.367.1660332795744; Fri, 12
 Aug 2022 12:33:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220812014706.43409-1-yuan.yao@intel.com> <20220812020206.foknky4hghgsadby@yy-desk-7060>
In-Reply-To: <20220812020206.foknky4hghgsadby@yy-desk-7060>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 12 Aug 2022 12:33:05 -0700
Message-ID: <CALMp9eRejAUVzFOsASBc-Md8KUeS1mzqOm9WCJ9dBFkc_NeOJg@mail.gmail.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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

These checks are redundant, aren't they?

That is, nested_vmx_exit_handled_vmcs_access() has already checked
nested_cpu_has_shadow_vmcs(vmcs12).
