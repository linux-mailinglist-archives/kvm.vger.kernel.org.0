Return-Path: <kvm+bounces-30616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7252F9BC493
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:12:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B5B5282AD6
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 011651B6D0B;
	Tue,  5 Nov 2024 05:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="u1kntvzQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D093156F45
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730783516; cv=none; b=lYDtQjXIq/85S3A8cTLDcHA+0D9QDcuaM94bU2OnShiSnHPGaQ518YaYk+i7obvKpylmhOQqjQORkiO0tGQFT0eIsyR4w0QJ++bmXb8dkXAIw/z6enoZBCmedPbGxJyiBCkUHPs/lDqEHMnNXh6BSvW5COLclt2/oWLQ+Q56JqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730783516; c=relaxed/simple;
	bh=g3X43PZZfzcStSl1Yx3BdP8/SjXgxrtAXnFZ6F/ppEo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h8TEACNTogRvSY3JgoWpJywHFifN0Rckzs5ce7LAYhyWN4HLriOkpQ2jM7oo3pvZL8ApIF3t7YXVD9qX7yUCuGLoiG1KWK74bEdvxPSTltRgxql/YeePSR94JlFRRBjOzzh1sOyPklPvbHsgVnfdr6sI3gnXsg1YxRW/7rtM3EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=u1kntvzQ; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a6bd37f424so10511785ab.2
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 21:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1730783512; x=1731388312; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8l5esNem8PBBNIAd06UP9heND5ENpGUkBH0v3nolocY=;
        b=u1kntvzQwSkUi5h5nF0L5+UjpFBGP4A+wqJ7vEkBpr7uc8UU5tLkRL8oGv29VNdjC2
         apWdvF2FHWssiu/yS6/Jxab8BZNjhOWf4forxPjNcNg16Omx50p89D3PI6qiD4VaErBg
         TrQ+MaHegDobTkesK4JTlvvfqzV1yvMEL9nIGdGXibSr2bX8hDd1y+q6Bdo9F7UxznoM
         ARUuKChYNqzvU/pk3+/JF2ba/GE/lTQzWE/PbzmJOBaxw7CcN+DXObb6Cp2X2dbDS6Gb
         3FcCYSYvo4C1LM+b2Ivz4wjt0OxgY8NiGvyEaSEvIwZMRm6GEtmML8wmORx+OkKPuMVN
         MV1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730783512; x=1731388312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8l5esNem8PBBNIAd06UP9heND5ENpGUkBH0v3nolocY=;
        b=B6UBA4wkuKJlhRuzvTmzPB4psHZRv5G+R42oVPKKGnh7rUjsa/sWvvDtjLk01LgSzi
         hpl1aHQ9cy8LA9jI3KTjOYR9aGfqWJvyehiBontKlH7nli+rXOPb1/3Wo+7nNt3yur1O
         i5Exnzzyic4v5s5GWx1upNl8NSGemPivnBkaPV9se0mmtvTxa45l8VQrwKKBEE1x1Y0E
         PxbQNNlwx1otO78yyqLFAtrszoMLfWyGNxgr5UOovdQwUOgq3qtmEtUIZBukXCD9slQ3
         ZYuR46sOfBfxqacdvNWsGw8udDZiFvRVbZd24LA88jMiII3qwNucauuRpD0O3zHrsWc8
         VAlQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5BI/Ivppt0EgsQLxM9HMvJmKrlybdqhR55X9SoMjYCQVi9emQWZnAITKCqXoyNAbZ/zs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1NxdEqyG8MR5FM10+P7WgmzT2qDtlc7kQ11UK0jxCfoTF/aVN
	/XfaOwZ1/mFkPUbVez/nF5VJkUHFP7GKuIrgqmVC0ZnsdWZBfopnq+Tfuv2goNoPW9fcn1MOVkI
	LLdRTZ1KE7KJmZLWCNe08U3VjpJJ7lWGPV98lCg==
X-Google-Smtp-Source: AGHT+IGEudYnCi3xjKq3yQuyp0LPEhZYmxUddO6fuja49PgBoSWrtEJM9MPf9ivcp3qpb4s6OoJ/iT+dNNtaTMkeEdw=
X-Received: by 2002:a05:6e02:3f83:b0:3a6:c320:7ed with SMTP id
 e9e14a558f8ab-3a6c3200a55mr86555625ab.10.1730783512341; Mon, 04 Nov 2024
 21:11:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029085542.30541-1-yongxuan.wang@sifive.com>
In-Reply-To: <20241029085542.30541-1-yongxuan.wang@sifive.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 5 Nov 2024 10:41:41 +0530
Message-ID: <CAAhSdy022PTmMZ90OxRxSOiR9nKept+tKVj8XrqbekkM209eYQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] RISC-V: KVM: Fix APLIC in_clrip and clripnum write emulation
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, greentime.hu@sifive.com, 
	vincent.chen@sifive.com, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2024 at 2:25=E2=80=AFPM Yong-Xuan Wang <yongxuan.wang@sifiv=
e.com> wrote:
>
> In the section "4.7 Precise effects on interrupt-pending bits"
> of the RISC-V AIA specification defines that:
>
> "If the source mode is Level1 or Level0 and the interrupt domain
> is configured in MSI delivery mode (domaincfg.DM =3D 1):
> The pending bit is cleared whenever the rectified input value is
> low, when the interrupt is forwarded by MSI, or by a relevant
> write to an in_clrip register or to clripnum."
>
> Update the aplic_write_pending() to match the spec.
>
> Fixes: d8dd9f113e16 ("RISC-V: KVM: Fix APLIC setipnum_le/be write emulati=
on")
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> Reviewed-by: Vincent Chen <vincent.chen@sifive.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.13.

Thanks,
Anup

> ---
> v2;
> - add fixes tag (Anup)
> - follow the suggestion from Anup
> ---
>  arch/riscv/kvm/aia_aplic.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
> index da6ff1bade0d..f59d1c0c8c43 100644
> --- a/arch/riscv/kvm/aia_aplic.c
> +++ b/arch/riscv/kvm/aia_aplic.c
> @@ -143,7 +143,7 @@ static void aplic_write_pending(struct aplic *aplic, =
u32 irq, bool pending)
>         if (sm =3D=3D APLIC_SOURCECFG_SM_LEVEL_HIGH ||
>             sm =3D=3D APLIC_SOURCECFG_SM_LEVEL_LOW) {
>                 if (!pending)
> -                       goto skip_write_pending;
> +                       goto noskip_write_pending;
>                 if ((irqd->state & APLIC_IRQ_STATE_INPUT) &&
>                     sm =3D=3D APLIC_SOURCECFG_SM_LEVEL_LOW)
>                         goto skip_write_pending;
> @@ -152,6 +152,7 @@ static void aplic_write_pending(struct aplic *aplic, =
u32 irq, bool pending)
>                         goto skip_write_pending;
>         }
>
> +noskip_write_pending:
>         if (pending)
>                 irqd->state |=3D APLIC_IRQ_STATE_PENDING;
>         else
> --
> 2.17.1
>

