Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A819782F94
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 19:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbjHURkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 13:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbjHURkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 13:40:45 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CB210B
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 10:40:43 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2bcc846fed0so4024681fa.2
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 10:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692639642; x=1693244442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2KX7owYVbLU+ijCZMyTqUTbMoObdlfJG3Oyp5/y4wY=;
        b=oh9VwzBbpPpafybwAP8GHSVpFnHZQDjfRG7xT1QEJ77K8HSIWsAynMTQd6E9joGkP6
         Rq607N/5QDq5bIVhaJnN70wZCbzXL2heuTQS8SRp3GWe8l0xCY2TOSWuAVpdExmgy158
         CQwKrKE/Ae9yP2xfXomETJ39Qf27TSgKwRPeeH7SHWnoWrQy3w77StDMXC5Qkd1yzPCb
         6ngmmuMBt0rSr9ZLEMYSA17abx0bBZBcmGdhHKbPWdFTUT1IYyeSWBsEkCHQCg/HYhP6
         T47g4KE9iVt66bWkAG0OyKCri+pesQVldwCYJzIOT4paN3e2qKy6lTIJhqQ5KJXWuNkB
         XZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692639642; x=1693244442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P2KX7owYVbLU+ijCZMyTqUTbMoObdlfJG3Oyp5/y4wY=;
        b=bHePzwNXRE+68uG6iEdxs3V/4BpUXLF5ZSIxZMBtJtFld29oq6YRIe7XeVhI3XEg0Z
         0TUO/vwT2Y03MDbioMNdzQ9fiHXIGViWcKMm8FbKW0FNttqjQIoisNwl+Vtz0mxNUeKw
         S8AkKjm8QROUpMnn13O444DzNKbFbRqvqA+zHaq4b9qX/mL1OswoREeFb+Dfz3N+efOX
         eIm/ivmHNelsRM2Aq6XXhHqnVBhC0M003e7qnfY6IFu/ZVXwfNaCXOYsk9jITSynn9GN
         3LIpet68BxhUiRgc6kFa+1uAu7t/6JiNv001YoBK1MB3UJR38Ol9x8Wnr5TnYzcOjink
         TY5w==
X-Gm-Message-State: AOJu0YzOyDHxK2xJe1zIvu2BAskuVsBv5vV8VcC3Sv1R/rCmo0KJlLNt
        76XzXsmbVTMGtB4hkXGqUkZkuDIQfQB6kt11MLlNug==
X-Google-Smtp-Source: AGHT+IGixA1mCi+LjuXuZlXx3gJPK2xjvqGQSnRKH4QShLy5tdi/PKQQ9ZOnc0bwcE2qdBZcXZJ0IzEnB1blkIpc1Ws=
X-Received: by 2002:a2e:6e10:0:b0:2b9:cb50:7043 with SMTP id
 j16-20020a2e6e10000000b002b9cb507043mr5697619ljc.2.1692639641800; Mon, 21 Aug
 2023 10:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-8-jingzhangos@google.com> <86pm3lfyxo.wl-maz@kernel.org>
In-Reply-To: <86pm3lfyxo.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 21 Aug 2023 10:40:30 -0700
Message-ID: <CAAdAUtiyJuSioPG3LTPkW82jujt-1405bjSBwMowt9sOoZYQCw@mail.gmail.com>
Subject: Re: [PATCH v8 07/11] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Aug 17, 2023 at 8:53=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 07 Aug 2023 17:22:05 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > All valid fields in ID_AA64PFR0_EL1 are writable from usrespace
> > with this change.
>
> userspace
>
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 879004fd37e5..392613bec560 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2041,7 +2041,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .get_user =3D get_id_reg,
> >         .set_user =3D set_id_reg,
> >         .reset =3D read_sanitised_id_aa64pfr0_el1,
> > -       .val =3D ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK,=
 },
> > +       .val =3D GENMASK(63, 0), },
> >       ID_SANITISED(ID_AA64PFR1_EL1),
> >       ID_UNALLOCATED(4,2),
> >       ID_UNALLOCATED(4,3),
>
> Same remark as the previous patch. What makes it legal to make
> *everything* writable? For example, we don't expose the AMU. And yet
> you are telling userspace "sure, go ahead".
>
> Userspace will then try and restore *something*, and will eventually
> crap itself because the kernel won't allow it.
>
> Why do we bother describing the writable fields if userspace can't
> write to them?

I'll send out another version which wouldn't enable writable masks for
RES0 fields and KVM hidden fields.
Does it sound good to you?

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
