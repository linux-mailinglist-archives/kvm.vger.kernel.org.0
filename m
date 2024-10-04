Return-Path: <kvm+bounces-27907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB0E2990198
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 12:50:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86E8F1F217DD
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 10:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92B113B5B7;
	Fri,  4 Oct 2024 10:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="DrSOV8v9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990B413AD03
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728039009; cv=none; b=hKBZzMwCFnU+cOnp/yRHX7sDpxdpEaX2dqs9zW3O+z0ZSLN84uFcYjxcjjpgOqt4AU7YXjmw4c/PaMTu8e0lAMhrzWcdXKyjq7pL5z09CbTOyXoiMU9qKa8XuWFakNkPu5B05LrcsJm3VzJJe4q89IHRIr60JFtC5jRVOM4mK1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728039009; c=relaxed/simple;
	bh=xEusqPbHWqC2kSvOa0CNTBI7KMX/dFPG15n+u2klxls=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pXFLKpErKFsxe0D6JPahi3dfZd9SJuOVMD5hChkvDcGqAcQygBdlZ6hhWILMSCtlKO+iYfsBWd7arygOXhkCfjA7Q4TwANoXCTDdg1ThEllhzEyH5iWfNw9lB0SIYjdRGtUaR+h+J6iyyETxX8F6ZdmEY7J+k5JrMiadxydknzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=DrSOV8v9; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3e03981dad2so1775157b6e.1
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 03:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1728039006; x=1728643806; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ywSS2L490J8CU6HcXGs1TjYnaQVhnORicV0t1QQIhzc=;
        b=DrSOV8v97XvumGn5kHUJgA8MaOlUWIbaw+Ktv/H+U/ss/oiZi7xQSZJzZL/pKUY3Gb
         T4pXWd01O0MIBFcYWPrNsy24NgnVfTDIE9QJBNEM5vuNoOTrqQcn8zJ81BHvPm4rTlyk
         zY4oH/3z/7vBBhxH62keek9azUrTNHs3p04S70N77PxZE2tu4X2nsmz8nDTcoO1ZLr1h
         J3loSpqm9f0YGg2t0scvVonMBIjYeWYQmolFlq2LoIg1pelpHzGNEf2Qx97QYdZlZGMF
         N2OId7Kw51nEPhDimsshT7+8ZMV3krHQSRy1Rxl013ILvaizcWXFoK6cu5Nz58se6Atq
         Yp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728039006; x=1728643806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ywSS2L490J8CU6HcXGs1TjYnaQVhnORicV0t1QQIhzc=;
        b=v27BtjdLGtf2PuLRmcdxxBT7aAtnit1li7Ts8kkabm8S4qFv4jCWnBWCcJAg9FIx21
         1ce55S3XOD6HKPO0MxwYVqPZArpKIjj7ywlU8U005qiaMbFPOLSSdgsfzYcII+LbhtSd
         vObkuE4DeK++iEBSMQ2H+rsZ2DgBCmucqDrlq+f5VEaK9HpLPFkaa/ouP5UzTrDRnTBp
         I0zvSrFq6wz47fK8hNI0r+YQl2Hm90J6u9bv4ZLT2d4jtL/1SXftK9LjTaMEH92hfWz4
         pEnRnsmN4IFIwW9snulR7Ka2utGghHei0BR2QEMIJulVLDLZlSIcT8X9t7jhnKoMVwSW
         iaWg==
X-Forwarded-Encrypted: i=1; AJvYcCXXi2C6ez1ZdRu4a4qRo6oX7Es7/DbYDzNAwsUBPuqAoOE9EjDuCJ5kdZSay9oVVe9k28Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOql41IA17H4e7P8OqbsPa81avrmIc+ADmMxk+od7gqS8yOWL3
	1F0I9+swSlKkfAhpmwg0MH3iQBub3k2IBJF3RfZMYRJ7CEWXoZ1KMQPDH6dOMXneJohZPaayw+9
	SjLRAYBWBn/MpiAdeLhVRBypRhG+zWO75CvURiA==
X-Google-Smtp-Source: AGHT+IFdS1NgCgffh0R0p2aEd2ZRC4hGoiJ1ekyWkNR4iWURqjLghfq2K21CKe2rjB4nMhlYIqLz4cS31CYnPsoOl4o=
X-Received: by 2002:aca:1118:0:b0:3e3:b291:833e with SMTP id
 5614622812f47-3e3ba1adb0dmr2801841b6e.9.1728039006554; Fri, 04 Oct 2024
 03:50:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240808081439.24661-1-yongxuan.wang@sifive.com>
In-Reply-To: <20240808081439.24661-1-yongxuan.wang@sifive.com>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Fri, 4 Oct 2024 18:49:55 +0800
Message-ID: <CAMWQL2gBOma5c_A4JPnTK6uDfbyqcbcf_4qZ4Pt_S3mvBY3s0w@mail.gmail.com>
Subject: Re: [PATCH 1/1] RISC-V: KVM: Fix APLIC in_clrip and clripnum write emulation
To: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc: greentime.hu@sifive.com, vincent.chen@sifive.com, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ping

On Thu, Aug 8, 2024 at 4:14=E2=80=AFPM Yong-Xuan Wang <yongxuan.wang@sifive=
.com> wrote:
>
> In the section "4.7 Precise effects on interrupt-pending bits"
> of the RISC-V AIA specification defines that:
>
> If the source mode is Level1 or Level0 and the interrupt domain
> is configured in MSI delivery mode (domaincfg.DM =3D 1):
> The pending bit is cleared whenever the rectified input value is
> low, when the interrupt is forwarded by MSI, or by a relevant
> write to an in_clrip register or to clripnum.
>
> Update the aplic_write_pending() to match the spec.
>
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
> ---
>  arch/riscv/kvm/aia_aplic.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
> index da6ff1bade0d..97c6dbcabf47 100644
> --- a/arch/riscv/kvm/aia_aplic.c
> +++ b/arch/riscv/kvm/aia_aplic.c
> @@ -142,8 +142,6 @@ static void aplic_write_pending(struct aplic *aplic, =
u32 irq, bool pending)
>
>         if (sm =3D=3D APLIC_SOURCECFG_SM_LEVEL_HIGH ||
>             sm =3D=3D APLIC_SOURCECFG_SM_LEVEL_LOW) {
> -               if (!pending)
> -                       goto skip_write_pending;
>                 if ((irqd->state & APLIC_IRQ_STATE_INPUT) &&
>                     sm =3D=3D APLIC_SOURCECFG_SM_LEVEL_LOW)
>                         goto skip_write_pending;
> --
> 2.17.1
>

