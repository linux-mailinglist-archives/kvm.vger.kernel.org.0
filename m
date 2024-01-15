Return-Path: <kvm+bounces-6289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4B2782E24F
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 22:50:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3ACD1C22216
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 21:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6FA91B29A;
	Mon, 15 Jan 2024 21:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qDHmaxT7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D7B1B27A
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 21:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2cd46e7ae8fso101582151fa.1
        for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 13:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705355396; x=1705960196; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pMgg84hiNTj9PW8xFI6uZ2/mSwaRhDLPU+YL0NcQxY=;
        b=qDHmaxT7c9wKbxqfoE2gD6klWwZTAJDkQ/5RR8Gotn8Ik6QURSFXRJ57vdYy1jc/DG
         anX6w6f6r1zvHrJB+UZ0pb7bZJXOD67eqhsHu/ADHXvd1ljy1kl4IbQgnDDe3bFpBAkX
         WON/JkoO6Y+hz2KqdWHi5gKK/a8jKdeJVn7duCUoqqhtN2CT8zINbns6PGNDQVr7IZja
         k2j4bYr1QsuupRCbbnw0fxyYRFHQHsI8XSnxkEfHEtVOb11bVe2DaLcg2ZOXmpm4ri3x
         /nl3EG0Exu1+Elw4Iat8SmLgjTCz1yzKP2sbcZml7hAi5xUkjPQ/nEsikrBaJzf19ACV
         Gu2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705355396; x=1705960196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2pMgg84hiNTj9PW8xFI6uZ2/mSwaRhDLPU+YL0NcQxY=;
        b=ipxtTgE5FF++V5XA5T2R4by3XdEj+o5SDGXdNQ1/uB0c3Jw8hwq8nPR6AWmoXFgHtG
         benO5i+7PcGfoXev8fX0NXxKpVz4gDMYaJuavv3moYqfKUQvSjw01DDYfJZdx1R3mA/0
         kmcsmY4tfuhB5JIB4HyJ8uCj43pjwXUZyDQU5B3bdHpiQyW7rgfwcvdf2dILD2AAnPUc
         +yDH6A+yOBcswqZNuH+fKHUtPaXRl6n+uV1MCJ2KWAlwMSuP710lGTtFfU6UJkrYJCcJ
         Q88S+sQkQqAdGW+I5cwVGYfvrigIvwpxDQ0afRE4dHQgLh7+IsU8BOQr3xvXn1Kekcod
         gVpQ==
X-Gm-Message-State: AOJu0Yxe3n7aEgRql4Zj5NbwoW4DLlh8zLC6V3fqjDAztZLWktAcfFHe
	IXCyybWILKBOQL/u1x/Ny/KwoaVNKQlCQyKD9QiEDYkIs4T/oGnbsECuTk8wFQ==
X-Google-Smtp-Source: AGHT+IHj1cqvnRemfYuBs3p6RF7YiwtvZ5OJke6Wa+KlzJP9mUiXWwi/Q+zJkopSBh7lVtsd0uAP+/QiU6U0pqLueiA=
X-Received: by 2002:a2e:a36f:0:b0:2cc:f6ac:a2db with SMTP id
 i15-20020a2ea36f000000b002ccf6aca2dbmr1267846ljn.196.1705355396357; Mon, 15
 Jan 2024 13:49:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240109165622.4104387-1-jingzhangos@google.com> <05e504bb-9aec-6026-1ea8-bca59ad439bf@huawei.com>
In-Reply-To: <05e504bb-9aec-6026-1ea8-bca59ad439bf@huawei.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 15 Jan 2024 13:49:43 -0800
Message-ID: <CAAdAUth_ZVb2GWFTN5_7UCJUQYqkZOPg9gscv9weQ2LxuSfzkg@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: selftests: Handle feature fields with
 nonzero minimum value correctly
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Itaru Kitayama <itaru.kitayama@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Zenghui,

On Sun, Jan 14, 2024 at 11:41=E2=80=AFPM Zenghui Yu <yuzenghui@huawei.com> =
wrote:
>
> Hi Jing,
>
> On 2024/1/10 0:56, Jing Zhang wrote:
> > There are some feature fields with nonzero minimum valid value. Make
> > sure get_safe_value() won't return invalid field values for them.
> > Also fix a bug that wrongly uses the feature bits type as the feature
> > bits sign causing all fields as signed in the get_safe_value() and
> > get_invalid_value().
> >
> > Fixes: 54a9ea73527d ("KVM: arm64: selftests: Test for setting ID regist=
er from usersapce")
> > Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> > Reported-by: Itaru Kitayama <itaru.kitayama@linux.dev>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  .../selftests/kvm/aarch64/set_id_regs.c       | 20 +++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/=
testing/selftests/kvm/aarch64/set_id_regs.c
> > index bac05210b539..f17454dc6d9e 100644
> > --- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> > +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> > @@ -224,13 +224,20 @@ uint64_t get_safe_value(const struct reg_ftr_bits=
 *ftr_bits, uint64_t ftr)
> >  {
> >       uint64_t ftr_max =3D GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0)=
;
> >
> > -     if (ftr_bits->type =3D=3D FTR_UNSIGNED) {
> > +     if (ftr_bits->sign =3D=3D FTR_UNSIGNED) {
> >               switch (ftr_bits->type) {
> >               case FTR_EXACT:
> >                       ftr =3D ftr_bits->safe_val;
> >                       break;
> >               case FTR_LOWER_SAFE:
> > -                     if (ftr > 0)
> > +                     uint64_t min_safe =3D 0;
> > +
> > +                     if (!strcmp(ftr_bits->name, "ID_AA64DFR0_EL1_Debu=
gVer"))
> > +                             min_safe =3D ID_AA64DFR0_EL1_DebugVer_IMP=
;
> > +                     else if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_Cop=
Dbg"))
> > +                             min_safe =3D ID_DFR0_EL1_CopDbg_Armv8;
> > +
> > +                     if (ftr > min_safe)
>
> As I mentioned in my previous reply, there is a compilation error with
> gcc-10.3.1.
>
> | aarch64/set_id_regs.c: In function 'get_safe_value':
> | aarch64/set_id_regs.c:233:4: error: a label can only be part of a
> statement and a declaration is not a statement
> |   233 |    uint64_t min_safe =3D 0;
> |       |    ^~~~~~~~
> | aarch64/set_id_regs.c:262:4: error: a label can only be part of a
> statement and a declaration is not a statement
> |   262 |    uint64_t min_safe =3D 0;
> |       |    ^~~~~~~~
>
> Please fix it.

Will fix it.
>
> Zenghui

Thanks,
Jing

