Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E267A9F75
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjIUUWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbjIUUVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:21:55 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49A6100E38
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 12:17:33 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-34fd369052dso4262235ab.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 12:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695323853; x=1695928653; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ozbk2dNvyLppvWHLoOva5zzVtfg/F/fwO01G7KL2kM=;
        b=ZGNY6Pv8hd3xUekbyh2TxFDrVO4le5Pir2q+R+5RobCevJ+63US+jX4jl5YKEH/3/O
         22YzUas2WvMVJSNbm/vhuoivRH9FFj9Zwau/0tzvqNzOGGWQCHBhM5caU8EtaEmoj2wz
         s1Mm5qtKJIsjY5iPFFGOiXEou3906O7+UK7KP6vZuHy/1lqW5Xo0301T2ll5iDxBg1z2
         rrlPMSUReK5Zf4MZJqxeRs8bfZDn7/W+lNnWd4aoRB7gBISl23l9K5XgwnfQZhiZUuod
         Sw5kQt42Z2iZ9vF5Yq7ljd9zNH4Rm4PwI/gHEYzzHB5HSCFZfgAMVFPneEiqmxDykqYL
         T64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695323853; x=1695928653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ozbk2dNvyLppvWHLoOva5zzVtfg/F/fwO01G7KL2kM=;
        b=kgpkpAp0fZNdyWs26QQmxJpsXIwRQsrpp19GqheKaRUU2/4Vt1g6jAh5FgSdbjimBc
         YO7wVyHbOUcOpm6BAXAEl1w8Ro53G9iG9ksMFw9ekNNIwpF6/3mZLg2N8yk33KWj6rEe
         Dp807T31cdb8aMMSnHftCqXAiVzOHVlg49dRXpPfTmwiXVbPik9Nlf20epSm5GjzzNMw
         Dhc9nRPakXuPSWU4s66+ueACZgY71eiePjJ/v6Xqx8PV1AknpNs5NLcx2mSlZjAgww0T
         jbWKl2z5N1q9OpSpSJg+UDw31al/aXa8dvBZLivICcfnHiEvL/ZTPiIfh0nlGWhVNvYg
         rfMQ==
X-Gm-Message-State: AOJu0YwTqoeEsT0Wodr/67S/WKcTvpSWfkP/BOyM1W+9FLpy/xBREsSa
        P+ggI8N+KXAzOjmGvw9GR+UW07jp4Y7n1ig+uWzMpeH3y9wR5ycwKZg=
X-Google-Smtp-Source: AGHT+IGEz5Xdf1ltfP1h7ZOlY0i0Ff2p3WqisTkzXjo50kTCkDUhMr0te2MZhczsxuS2lrcKSxSji/XZakkgWoQtiRY=
X-Received: by 2002:a17:90a:6c05:b0:26b:698f:dda7 with SMTP id
 x5-20020a17090a6c0500b0026b698fdda7mr4682988pjj.32.1695273183695; Wed, 20 Sep
 2023 22:13:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230918180646.1398384-1-apatel@ventanamicro.com>
 <20230918180646.1398384-4-apatel@ventanamicro.com> <CAOnJCUJYDHtbYS4js7PSAeLqT4sL5zi7DT5xeSww+5Nvs2UhcA@mail.gmail.com>
 <CAK9=C2UbjOGyxo8oP36Tinjhv1jRpCb+hVbZCOJ70G4-WiHw1g@mail.gmail.com> <CAOnJCULajHa6H6Rt75rNepYaT-3+Bo=1hQVb_oozPZK13N6yKQ@mail.gmail.com>
In-Reply-To: <CAOnJCULajHa6H6Rt75rNepYaT-3+Bo=1hQVb_oozPZK13N6yKQ@mail.gmail.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Thu, 21 Sep 2023 10:42:50 +0530
Message-ID: <CAK9=C2XxgCGudCH0tQqHe+t+Fyc34sVHia_5bfcZ6ZR37Udx7Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: riscv: selftests: Fix ISA_EXT register handling
 in get-reg-list
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 4:31=E2=80=AFAM Atish Patra <atishp@atishpatra.org>=
 wrote:
>
> On Wed, Sep 20, 2023 at 6:56=E2=80=AFAM Anup Patel <apatel@ventanamicro.c=
om> wrote:
> >
> > On Wed, Sep 20, 2023 at 1:24=E2=80=AFAM Atish Patra <atishp@atishpatra.=
org> wrote:
> > >
> > > On Mon, Sep 18, 2023 at 11:07=E2=80=AFAM Anup Patel <apatel@ventanami=
cro.com> wrote:
> > > >
> > > > Same set of ISA_EXT registers are not present on all host because
> > > > ISA_EXT registers are visible to the KVM user space based on the
> > > > ISA extensions available on the host. Also, disabling an ISA
> > > > extension using corresponding ISA_EXT register does not affect
> > > > the visibility of the ISA_EXT register itself.
> > > >
> > > > Based on the above, we should filter-out all ISA_EXT registers.
> > > >
> > >
> > > In that case, we don't need the switch case any more. Just a
> > > conditional check with KVM_RISCV_ISA_EXT_MAX should be sufficient.
> >
> > If we compare against KVM_RISCV_ISA_EXT_MAX then we will forget
> > adding test configs for newer ISA extensions.
> >
>
> I feel it just bloats the code as we may end up in hundreds of
> extensions in the future
> given the state of the extension scheme.

That is bound to happen so eventually we will have to revisit the
get-reg-list test.

Regards,
Anup

>
> > >
> > > > Fixes: 477069398ed6 ("KVM: riscv: selftests: Add get-reg-list test"=
)
> > > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > > ---
> > > >  .../selftests/kvm/riscv/get-reg-list.c        | 35 +++++++++++----=
----
> > > >  1 file changed, 21 insertions(+), 14 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/too=
ls/testing/selftests/kvm/riscv/get-reg-list.c
> > > > index d8ecacd03ecf..76c0ad11e423 100644
> > > > --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> > > > +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> > > > @@ -14,17 +14,33 @@
> > > >
> > > >  bool filter_reg(__u64 reg)
> > > >  {
> > > > +       switch (reg & ~REG_MASK) {
> > > >         /*
> > > > -        * Some ISA extensions are optional and not present on all =
host,
> > > > -        * but they can't be disabled through ISA_EXT registers whe=
n present.
> > > > -        * So, to make life easy, just filtering out these kind of =
registers.
> > > > +        * Same set of ISA_EXT registers are not present on all hos=
t because
> > > > +        * ISA_EXT registers are visible to the KVM user space base=
d on the
> > > > +        * ISA extensions available on the host. Also, disabling an=
 ISA
> > > > +        * extension using corresponding ISA_EXT register does not =
affect
> > > > +        * the visibility of the ISA_EXT register itself.
> > > > +        *
> > > > +        * Based on above, we should filter-out all ISA_EXT registe=
rs.
> > > >          */
> > > > -       switch (reg & ~REG_MASK) {
> > > > +       case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_A:
> > > > +       case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_C:
> > > > +       case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_D:
> > > > +       case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_F:
> > > > +       case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_H:
> > > > +       case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_I:
> > > > +       case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_M:
> > > > +       case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_SVPBMT:
> > > >         case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_SSTC:
> > > >         case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_SVINVAL:
> > > >         case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
> > > > +       case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICBOM:
> > > > +       case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICBOZ:
> > > >         case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZBB:
> > > >         case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_SSAIA:
> > > > +       case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_V:
> > > > +       case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_SVNAPOT:
> > > >         case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZBA:
> > > >         case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZBS:
> > > >         case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICNTR:
> > > > @@ -50,12 +66,7 @@ static inline bool vcpu_has_ext(struct kvm_vcpu =
*vcpu, int ext)
> > > >         unsigned long value;
> > > >
> > > >         ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value=
);
> > > > -       if (ret) {
> > > > -               printf("Failed to get ext %d", ext);
> > > > -               return false;
> > > > -       }
> > > > -
> > > > -       return !!value;
> > > > +       return (ret) ? false : !!value;
> > > >  }
> > > >
> > > >  void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
> > > > @@ -506,10 +517,6 @@ static __u64 base_regs[] =3D {
> > > >         KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KV=
M_REG_RISCV_TIMER_REG(time),
> > > >         KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KV=
M_REG_RISCV_TIMER_REG(compare),
> > > >         KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KV=
M_REG_RISCV_TIMER_REG(state),
> > > > -       KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT =
| KVM_RISCV_ISA_EXT_A,
> > > > -       KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT =
| KVM_RISCV_ISA_EXT_C,
> > > > -       KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT =
| KVM_RISCV_ISA_EXT_I,
> > > > -       KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT =
| KVM_RISCV_ISA_EXT_M,
> > > >         KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT =
| KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_V01,
> > > >         KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT =
| KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_TIME,
> > > >         KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT =
| KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_IPI,
> > > > --
> > > > 2.34.1
> > > >
> > >
> > >
> > > --
> > > Regards,
> > > Atish
> >
> > Regards,
> > Anup
>
>
>
> --
> Regards,
> Atish
