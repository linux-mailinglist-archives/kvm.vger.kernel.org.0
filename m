Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA1375C1D8
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 10:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjGUIjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 04:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjGUIjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 04:39:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E632D51
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 01:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689928712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NwNy9iOU1ioDiJtC0wNNa3aEUmMXumdBTFbQ/HwLllU=;
        b=UofF/vTaAPjNsBSi4TfqmaBxLPGT2d3epR5qoRsv68fi+/Gu4GotRqpPn9C4j/kT2UzxJc
        HIaqBDsP78gdRttmOs6NfXlJr3nifxiyQ9nqskiEAoLOF3g85Voo3dpssoUN48dRxp9vyF
        DOLZ7ZRGcajnEnJK54WA+v+1szc56eI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-Blr1Gv_KOaS1Li0WyBAPWQ-1; Fri, 21 Jul 2023 04:38:25 -0400
X-MC-Unique: Blr1Gv_KOaS1Li0WyBAPWQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8C88936D20;
        Fri, 21 Jul 2023 08:38:24 +0000 (UTC)
Received: from localhost (unknown [10.39.193.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E20A492B02;
        Fri, 21 Jul 2023 08:38:24 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
In-Reply-To: <CAAdAUthM6JJ0tEqWELcW48E235EbcjZQSDLF9OQUZ_kUtqh3Ng@mail.gmail.com>
Organization: Red Hat GmbH
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-4-jingzhangos@google.com>
 <87o7k77yn5.fsf@redhat.com>
 <CAAdAUthM6JJ0tEqWELcW48E235EbcjZQSDLF9OQUZ_kUtqh3Ng@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Fri, 21 Jul 2023 10:38:23 +0200
Message-ID: <87sf9h8xs0.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20 2023, Jing Zhang <jingzhangos@google.com> wrote:

> Hi Cornelia,
>
> On Thu, Jul 20, 2023 at 1:52=E2=80=AFAM Cornelia Huck <cohuck@redhat.com>=
 wrote:
>>
>> On Tue, Jul 18 2023, Jing Zhang <jingzhangos@google.com> wrote:
>>
>> > All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
>> > from usrespace with this change.
>>
>> Typo: s/usrespace/userspace/
> Thanks.
>>
>> >
>> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
>> > ---
>> >  arch/arm64/kvm/sys_regs.c | 4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> > index 053d8057ff1e..f33aec83f1b4 100644
>> > --- a/arch/arm64/kvm/sys_regs.c
>> > +++ b/arch/arm64/kvm/sys_regs.c
>> > @@ -2008,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_descs[]=
 =3D {
>> >         .set_user =3D set_id_dfr0_el1,
>> >         .visibility =3D aa32_id_visibility,
>> >         .reset =3D read_sanitised_id_dfr0_el1,
>> > -       .val =3D ID_DFR0_EL1_PerfMon_MASK, },
>> > +       .val =3D GENMASK(63, 0), },
>> >       ID_HIDDEN(ID_AFR0_EL1),
>> >       AA32_ID_SANITISED(ID_MMFR0_EL1),
>> >       AA32_ID_SANITISED(ID_MMFR1_EL1),
>> > @@ -2057,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_descs[]=
 =3D {
>> >         .get_user =3D get_id_reg,
>> >         .set_user =3D set_id_aa64dfr0_el1,
>> >         .reset =3D read_sanitised_id_aa64dfr0_el1,
>> > -       .val =3D ID_AA64DFR0_EL1_PMUVer_MASK, },
>> > +       .val =3D GENMASK(63, 0), },
>> >       ID_SANITISED(ID_AA64DFR1_EL1),
>> >       ID_UNALLOCATED(5,2),
>> >       ID_UNALLOCATED(5,3),
>>
>> How does userspace find out whether a given id reg is actually writable,
>> other than trying to write to it?
>>
> No mechanism was provided to userspace to discover if a given idreg or
> any fields of a given idreg is writable. The write to a readonly idreg
> can also succeed (write ignored) without any error if what's written
> is exactly the same as what the idreg holds or if it is a write to
> AArch32 idregs on an AArch64-only system.

Hm, I'm not sure that's a good thing for the cases where we want to
support mix-and-match userspace and kernels. Userspace may want to know
upfront whether it can actually tweak the contents of an idreg or not
(for example, in the context of using CPU models for compatibility), so
that it can reject or warn about certain configurations that may not
turn out as the user expects.

> Not sure if it is worth adding an API to return the writable mask for
> idregs, since we want to enable the writable for all allocated
> unhidden idregs eventually.

We'd enable any new idregs for writing from the start in the future, I
guess?

I see two approaches here:
- add an API to get a list of idregs with their writable masks
- add a capability "you can write to all idregs whatever you'd expect to
  be able to write there architecture wise", which would require to add
  support for all idregs prior to exposing that cap

The second option would be the easier one (if we don't manage to break
it in the future :)

