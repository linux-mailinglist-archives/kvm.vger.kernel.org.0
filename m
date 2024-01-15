Return-Path: <kvm+bounces-6290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7590B82E256
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 22:53:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F7F21C22128
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 21:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B34B61B29C;
	Mon, 15 Jan 2024 21:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y/beaLHG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594C51B277
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 21:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2cdb50d8982so21080801fa.2
        for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 13:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705355597; x=1705960397; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=srI+QJCcaSdOGmilFvhJukBBrNbYl/iiFTS82slCDmA=;
        b=Y/beaLHGMiZ9GxgK2imK6a7lB5BaAEslIz+PTQKmTm4v278OEzqWCXZb1T0oz6DB7n
         OMaD3AJFaEvKcaqLi7HYuJENnmeGESaSkMwcfxwc0AGVuXNoAUmkonHVmELUxe8cdV+n
         Xjyq9O9YuT08+ImjoriILhwwK2GiRIYoJ75m1MU+K0grmxWCf6swcjsqxkI1Zjo/pYos
         xQzsHHSlC3PkMPH7aK1lRlmvBn0s7WmrD7xQRAy86OzjPW2/66aOSdzlHNaq7kaC0ZEd
         +L/nzokpp7QqpmE6NzXT3qZRDpY0PcqyNrWzV8GQDuhfSjFvz3ScXd3i8V3IgovJqq6T
         ZEbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705355597; x=1705960397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=srI+QJCcaSdOGmilFvhJukBBrNbYl/iiFTS82slCDmA=;
        b=awqJqm4mMH9pD3+5bRBqcFcL22UAVteuW8xZcWvDZ6LHo41hNg9mPVuGBPFv/e4ub3
         witF8XwTWtkpO7h7vQQCRnyv8WKtl8zcCJ03mBllsQWODTQA0eayvSIrL3Os3leZ7re+
         o7QPx4HrIHfiF8qr/c+0vneo2Ijpt9uCtiyXyIA4jLQmSaJocRZeSaGNrEenTz0bvZGX
         8x5MkFM1yx6e5MX1tNZeyT0cr9XbCR9NwHUAK4rk5E5/cpTw55gbb66c7wRFPw3NL1XG
         ZSVSTFeMBuwNw1JxiGfhEaN6nmVYXD35HDfzyBxf/E+87Skejiuzto+bgXiRK2hz7kqP
         qLmg==
X-Gm-Message-State: AOJu0YzMjTYH74hKTT0S+7NH72jqi8ebcu901JMoKum7zQJT5QR+h2Zo
	r5qWYogq4qIME/caZtHRFcK0eMk+ccBjEPGxZikMyLkLjIED
X-Google-Smtp-Source: AGHT+IFzcXqZv7MAO5YZ5RVCYAl39JUV9v/r8FCKcNCkLlUAAv/DZU4c6ysxX0gO0iB9+zMFIXIpa8ACAE1KGOO/fug=
X-Received: by 2002:a2e:5c44:0:b0:2cd:1d6e:74c9 with SMTP id
 q65-20020a2e5c44000000b002cd1d6e74c9mr2574217ljb.48.1705355597248; Mon, 15
 Jan 2024 13:53:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240109165622.4104387-1-jingzhangos@google.com> <4e3c051b-ccdb-47d4-9a29-5c92f5101a06@arm.com>
In-Reply-To: <4e3c051b-ccdb-47d4-9a29-5c92f5101a06@arm.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 15 Jan 2024 13:53:04 -0800
Message-ID: <CAAdAUtjPKv08ymo1ydJpigqmOWCAw7dqyKqmYVg4jcbc3MQE5g@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: selftests: Handle feature fields with
 nonzero minimum value correctly
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Itaru Kitayama <itaru.kitayama@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Suzuki,

On Mon, Jan 15, 2024 at 1:34=E2=80=AFAM Suzuki K Poulose <suzuki.poulose@ar=
m.com> wrote:
>
> On 09/01/2024 16:56, Jing Zhang wrote:
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
> >   .../selftests/kvm/aarch64/set_id_regs.c       | 20 +++++++++++++++---=
-
> >   1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/=
testing/selftests/kvm/aarch64/set_id_regs.c
> > index bac05210b539..f17454dc6d9e 100644
> > --- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> > +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> > @@ -224,13 +224,20 @@ uint64_t get_safe_value(const struct reg_ftr_bits=
 *ftr_bits, uint64_t ftr)
> >   {
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
>
> Instead of hardcoding the safe value here in the code, why not "fix" the
> safe value in the ftr_id table and use ftr_bits->safe_val for both the
> above cases ?
>

SGTM. Will do.
> > +
> > +                     if (ftr > min_safe)
> >                               ftr--;
> >                       break;
> >               case FTR_HIGHER_SAFE:
> > @@ -252,7 +259,12 @@ uint64_t get_safe_value(const struct reg_ftr_bits =
*ftr_bits, uint64_t ftr)
> >                       ftr =3D ftr_bits->safe_val;
> >                       break;
> >               case FTR_LOWER_SAFE:
> > -                     if (ftr > 0)
> > +                     uint64_t min_safe =3D 0;
> > +
> > +                     if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_PerfMon"=
))
> > +                             min_safe =3D ID_DFR0_EL1_PerfMon_PMUv3;
> > +
> > +                     if (ftr > min_safe)
> >                               ftr--;
>
> Also, here, don't we need to type case both "ftr" and min_safe to
> int64_t for signed features ?

They are all used as unsigned on purpose. That's why the handling for
signed features are handled in different cases.
>
> Suzuki
>
> >                       break;
> >               case FTR_HIGHER_SAFE:
> > @@ -276,7 +288,7 @@ uint64_t get_invalid_value(const struct reg_ftr_bit=
s *ftr_bits, uint64_t ftr)
> >   {
> >       uint64_t ftr_max =3D GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0)=
;
> >
> > -     if (ftr_bits->type =3D=3D FTR_UNSIGNED) {
> > +     if (ftr_bits->sign =3D=3D FTR_UNSIGNED) {
> >               switch (ftr_bits->type) {
> >               case FTR_EXACT:
> >                       ftr =3D max((uint64_t)ftr_bits->safe_val + 1, ftr=
 + 1);
> >
> > base-commit: 0dd3ee31125508cd67f7e7172247f05b7fd1753a
>

Thanks,
Jing

