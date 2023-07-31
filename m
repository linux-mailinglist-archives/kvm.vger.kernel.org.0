Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92EB076A238
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 22:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjGaUvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 16:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjGaUvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 16:51:33 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF42198B
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 13:51:31 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 46e09a7af769-6b9cf7e6ab2so3936396a34.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 13:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690836691; x=1691441491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sA6RLOzvb+R/VirMyioCzSgd+J6ABt3La5KSmzg7wAE=;
        b=0vhqfaZ8BwS6RjQPZj790CmzozaRFz2lu+dfT8Cqm8cEdDGyIP52wN1jal3TsAGOfY
         c2HadV0s5VksKLxYnd4NNTeoHb9BpXbxz5mFtdI3a8uQ0WbwVKvUoe6uv+BMR/OxkWEB
         TBHmrCfY26q9c/J0QomP68Zyi8uDPZeOsPSmqpssH/T2kuA7P1DnIoofLati94umgBBb
         8QPya3CYyn3ePwplbBXdAJHifIDGsACbgJRS1WUfoQm0afq73bUha22dXgrhIUibUZD1
         DQjgc5RZVtKzXCZUm6qkqxxN3KcUTbO+FE00bMDL5/myydQSB49006LTabENoVYPV7uz
         ETTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690836691; x=1691441491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sA6RLOzvb+R/VirMyioCzSgd+J6ABt3La5KSmzg7wAE=;
        b=jNpvYuompJyoXmKsphRL+flTG1DkAqe7GY0EF+3pZd75GNgWe1zayiVYwaiV7Y6kzc
         CKWdJtFnlLKBYf5oV1ypaOSTNuSdYSVOepvj3v5sKs2PG5knnbrloHh9cNmPzQcZpfv5
         YqFErNA94gmiOA1bfw/7D7UUk47PzBniibQeFU37weFmR7cm8TBV6NHiYXgtuVGB1VNJ
         KyEXtkYeJbDrKelle1uC9g4GvTzPIKPjOed6tS8ONT8mCLnhyiGiWZY9VR3gzOhd6+mS
         OKYZsm313IWO/LgaywEBhj+xGJhj10G0ZLr25uTn4xCE4pvQjjVZvyxxHk/ZgVIxM3Zv
         Quvw==
X-Gm-Message-State: ABy/qLaQpRFfABUZ/EjHcYkqkC3L+eIULI03thn/TaoDinyawZSiRVGm
        NcEbOnLKYZrxYr8+rf3u3VvF4MmkyD+i3MAeLeRb6ApEvmno0V450a0=
X-Google-Smtp-Source: APBJJlHCQrXDqZnToOKhRJ8t4676bc3DFEKqs7rDC1LKy+awXMSQWraYxbTkevh/m8H+gwfVzjpd0qKH/kjizZ+DDMI=
X-Received: by 2002:a05:6870:6110:b0:1be:fdae:601b with SMTP id
 s16-20020a056870611000b001befdae601bmr1922806oae.52.1690836690744; Mon, 31
 Jul 2023 13:51:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-4-jingzhangos@google.com> <87o7k77yn5.fsf@redhat.com>
 <CAAdAUthM6JJ0tEqWELcW48E235EbcjZQSDLF9OQUZ_kUtqh3Ng@mail.gmail.com>
 <87sf9h8xs0.fsf@redhat.com> <86r0p1txun.wl-maz@kernel.org>
 <87pm4l8uj8.fsf@redhat.com> <87cz0bqa0t.wl-maz@kernel.org>
In-Reply-To: <87cz0bqa0t.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 31 Jul 2023 13:51:18 -0700
Message-ID: <CAAdAUti=EcMJbq2pXB+WGnc7NewYe25kCR58q7pN4BczMGH9fg@mail.gmail.com>
Subject: Re: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
To:     Marc Zyngier <maz@kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
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
        Suraj Jitindar Singh <surajjs@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 29, 2023 at 3:36=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 21 Jul 2023 10:48:27 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
> >
> > On Fri, Jul 21 2023, Marc Zyngier <maz@kernel.org> wrote:
> >
> > > On Fri, 21 Jul 2023 09:38:23 +0100,
> > > Cornelia Huck <cohuck@redhat.com> wrote:
> > >>
> > >> On Thu, Jul 20 2023, Jing Zhang <jingzhangos@google.com> wrote:
> > >> > No mechanism was provided to userspace to discover if a given idre=
g or
> > >> > any fields of a given idreg is writable. The write to a readonly i=
dreg
> > >> > can also succeed (write ignored) without any error if what's writt=
en
> > >> > is exactly the same as what the idreg holds or if it is a write to
> > >> > AArch32 idregs on an AArch64-only system.
> > >>
> > >> Hm, I'm not sure that's a good thing for the cases where we want to
> > >> support mix-and-match userspace and kernels. Userspace may want to k=
now
> > >> upfront whether it can actually tweak the contents of an idreg or no=
t
> > >> (for example, in the context of using CPU models for compatibility),=
 so
> > >> that it can reject or warn about certain configurations that may not
> > >> turn out as the user expects.
> > >>
> > >> > Not sure if it is worth adding an API to return the writable mask =
for
> > >> > idregs, since we want to enable the writable for all allocated
> > >> > unhidden idregs eventually.
> > >>
> > >> We'd enable any new idregs for writing from the start in the future,=
 I
> > >> guess?
> > >>
> > >> I see two approaches here:
> > >> - add an API to get a list of idregs with their writable masks
> > >> - add a capability "you can write to all idregs whatever you'd expec=
t to
> > >>   be able to write there architecture wise", which would require to =
add
> > >>   support for all idregs prior to exposing that cap
> > >>
> > >> The second option would be the easier one (if we don't manage to bre=
ak
> > >> it in the future :)
> > >
> > > I'm not sure the last option is even possible. The architecture keeps
> > > allocating new ID registers in the op0=3D=3D3, op1=3D=3D{0, 1, 3}, CR=
n=3D=3D0,
> > > CRm=3D=3D{0-7}, op2=3D=3D{0-7} space, so fields that were RES0 until =
then
> > > start having a non-0 value.
> > >
> > > This could lead to a situation where you move from a system that
> > > didn't know about ID_AA64MMFR6_EL1.XYZ to a system that advertises it=
,
> > > and for which the XYZ instruction has another behaviour. Bad things
> > > follow.
> >
> > Hrm :(
> >
> > >
> > > My preference would be a single ioctl that returns the full list of
> > > writeable masks in the ID reg range. It is big, but not crazy big
> > > (1536 bytes, if I haven't messed up), and includes the non ID_*_EL1
> > > sysreg such as MPIDR_EL1, CTR_EL1, SMIDR_EL1.
> > >
> > > It would allow the VMM to actively write zeroes to any writable ID
> > > register it doesn't know about, or for which it doesn't have anything
> > > to restore. It is also relatively future proof, as it covers
> > > *everything* the architecture has provisioned for the future (by the
> > > time that space is exhausted, I hope none of us will still be involve=
d
> > > with this crap).
> >
> > Famous last words :)
> >
> > But yes, that should work. This wouldn't be the first ioctl returning a
> > long list, and the VMM would just call it once on VM startup to figure
> > things out anyway.
>
> To be clear, see below for what I had in mind. It is of course
> untested, and is probably overlooking a number of details, but you'll
> hopefully get my drift. I think this has some benefit over the
> per-sysreg ioctl, as it covers everything in one go, and is guaranteed
> to be exhaustive (until the architecture grows another range of ID
> crap).
>
> Note that we don't necessarily need to restrict ourselves to a single
> range either. We could also return some other ranges depending on
> additional parameters (Oliver mentioned offline the case of the
> PCMEIDx_EL0 registers).
>
> Thank,
>
>         M.
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2ca2973abe66..fa79f3651423 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3589,3 +3589,91 @@ int __init kvm_sys_reg_table_init(void)
>
>         return 0;
>  }
> +
> +/*
> + * From DDI0487J.a, D19.2.66 ("ID_AA64MMFR2_EL1, AArch64 Memory Model
> + * Feature Register 2"):
> + *
> + * "The Feature ID space is defined as the System register space in
> + * AArch64 with op0=3D=3D3, op1=3D=3D{0, 1, 3}, CRn=3D=3D0, CRm=3D=3D{0-=
7},
> + * op2=3D=3D{0-7}."
> + *
> + * This covers all R/O registers that indicate anything useful feature
> + * wise, including the ID registers.
> + */
> +
> +/* Userspace-visible definitions */
> +#define ARM64_FEATURE_ID_SPACE_SIZE    (3 * 8 * 8)
> +#define __ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)          \
> +       ({                                                              \
> +               __u64 __op1 =3D op1 & 3;                                 =
 \
> +               __op1 -=3D (__op1 =3D=3D 3);                             =
     \
> +               ((ARM64_SYS_REG_SHIFT_MASK(3, OP0) |                    \
> +                 ARM64_SYS_REG_SHIFT_MASK(__op1, OP1) |                \
> +                 ARM64_SYS_REG_SHIFT_MASK(0, CRN) |                    \
> +                 ARM64_SYS_REG_SHIFT_MASK(crm & 7, CRM) |              \
> +                 ARM64_SYS_REG_SHIFT_MASK(op2, OP2)) -                 \
> +                (ARM64_SYS_REG_SHIFT_MASK(3, OP0) |                    \
> +                 ARM64_SYS_REG_SHIFT_MASK(0, OP1) |                    \
> +                 ARM64_SYS_REG_SHIFT_MASK(0, CRN) |                    \
> +                 ARM64_SYS_REG_SHIFT_MASK(0, CRM) |                    \
> +                 ARM64_SYS_REG_SHIFT_MASK(0, OP2)));                   \
> +       })
> +
> +#define ARM64_FEATURE_ID_SPACE_INDEX(r)                                 =
       \
> +       __ARM64_FEATURE_ID_SPACE_IDX(sys_reg_Op0(r),                    \
> +                                    sys_reg_Op1(r),                    \
> +                                    sys_reg_CRn(r),                    \
> +                                    sys_reg_CRm(r),                    \
> +                                    sys_reg_Op2(r))
> +
> +struct feature_id_writeable_masks {
> +       u64     mask[ARM64_FEATURE_ID_SPACE_SIZE];
> +};
> +
> +static bool is_feature_id_reg(u32 encoding)
> +{
> +       return (sys_reg_Op0(encoding) =3D=3D 3 &&
> +               (sys_reg_Op1(encoding) < 2 || sys_reg_Op1(encoding) =3D=
=3D 3) &&
> +               sys_reg_CRn(encoding) =3D=3D 0 &&
> +               sys_reg_CRm(encoding) <=3D 7);
> +}
> +
> +int kvm_get_writeable_feature_regs(struct kvm *kvm, u64 __user *masks)
> +{
> +       /* Wipe the whole thing first */
> +       for (int i =3D 0; i < ARM64_FEATURE_ID_SPACE_SIZE; i++)
> +               if (put_user(0, masks + i))
> +                       return -EFAULT;
> +
> +       for (int i =3D 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> +               const struct sys_reg_desc *reg =3D &sys_reg_descs[i];
> +               u32 encoding =3D reg_to_encoding(reg);
> +               u64 val;
> +
> +               if (!is_feature_id_reg(encoding) || !reg->set_user)
> +                       continue;
> +
> +               /*
> +                * For ID registers, we return the writable mask.
> +                * Other feature registers return a full 64bit mask.
> +                * That's not necessarily compliant with a given
> +                * revision of the architecture, but the RES0/RES1
> +                * definitions allow us to do that
> +                */
> +               if (is_id_reg(encoding)) {
> +                       if (!reg->val)
> +                               continue;
> +
> +                       val =3D reg->val;
> +               } else {
> +                       val =3D ~0UL;
> +               }
> +
> +               if (put_user(val,
> +                            (masks + ARM64_FEATURE_ID_SPACE_INDEX(encodi=
ng))))
> +                       return -EFAULT;
> +       }
> +
> +       return 0;
> +}
Thanks Marc.
The whole idea is clear to me now. I'll implement this in the next version.

Jing
>
>
>
> --
> Without deviation from the norm, progress is not possible.
