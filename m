Return-Path: <kvm+bounces-29995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9E4C9B5A8E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 05:06:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7114E1F24A66
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 04:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 358DE1991A5;
	Wed, 30 Oct 2024 04:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IviO3mWA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BF37E9
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 04:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730261210; cv=none; b=K9Z/5GTo/MYGDjhBKR7gMJe7H1/y0c3SfL0yxcj5V7RIhRoZI3zj0lyGMnAaPmxMTEcX68oDX39igssxKAulNgOkmF0ORW32YzR040hxsb3BzXPpP0kx+hCZhMmFdplSxNmAttDCMaWgVaPpz+82AfHerwA/PNasLmQWAoaON3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730261210; c=relaxed/simple;
	bh=vUZFsfsUG8jYWEl4ErVD99iWin8FwDFUVOfxNkFRBtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lUKHitNLPFoF1KQZ9kdZ1W97YLl2WhFPTUyPBFtsVdhH4EDOGvfL5Blsjn2CVNMOoYLs7dkWoEjx5B6xXMAMQvaExWXukJNq7sVVAAO7tYQAqJMUz8mr/IOCZlfzcF0FbTmV9qD/LNNel853QGkCNbE2RfspmHFZKYADZ+AW/Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IviO3mWA; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-4a5ad5c1c06so2133671137.3
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 21:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730261207; x=1730866007; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qKNag8kvCVAwcSFrD5wZs2oqPhzGbSq/NfVP+BmorYo=;
        b=IviO3mWAP+g3JJ1oa4ZQ8xjzte5xmaMnF8k0nN7dIxXVCFSo6rB2NCiGievHgG206l
         +4Qpuq12OhZiHrMc8dKJsofF69PRU6rwFjt32RwEmVsu80itLWqDTJ64ER8NAs2wPODQ
         nK1Ve831BgUiP+esv6PHPVzo9ahYkzSfksvXqOc912eAWhIxxjxyQtLOfzIR0s1lLQeM
         KwmctwsJSyRconk3zsLxWPZfxS51b14f92lDO8gqqQO9iYUi7q7TJBeONQ65fqy/VVsW
         3zCVDm9oQuakalOKUAeur8zywGPfUaT79/cud36NKvbg6FhL5LkDMa67yuFYGlraoI4F
         Hfyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730261207; x=1730866007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qKNag8kvCVAwcSFrD5wZs2oqPhzGbSq/NfVP+BmorYo=;
        b=qGVoRh+eHZoSKHPA5cDIUZADGefcquUwUC8D30Jjwatc3wMRJ2PUrORuA7Pk6D2ejK
         s69+VBKcxpym6Y5ZVRmBYgmT/oydFqm+KfKZEl/Nve92Xyh68L/D2PRJAbHTUwY09gVl
         w+uw4Mk+2PfcS6n6to/XYdq0Qvxm6NS05eg//I8nhk6SwoxAZSOyr2Dpp7hJvJoOOhKU
         6TGU7Nd1sS3Cmn/XKz/BBG4rorV07BqdicC8ftxin8mbQOgQZlENo+kkhMpAfVycpsaH
         z1tq6ZaOpswwXZ+IpKjPowbAtUprpT4xalUK2w3yFXWAz3cyj9rymkhPWPo02dAA8pBd
         fx1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVfY771BhV3DAZYnS11VGl89sG/AnPKJ67/k6B82f+NrUJqc53Df0a3hckdOtSbqgVmsp0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYRMLmIUooHMgkLYy+Z6yQFzLEV0Srz+Z3Ag00Senv+LOA+kbD
	cZVlbaWC+El/33t/RtbQqWE0nviCwQNTJLEVvlf7X29Qkznej35wd+U27SF0++I5lZzlqxbJn23
	QBKdLlWMppn7iMRFZVS4WoAvbRHM+P7DP
X-Google-Smtp-Source: AGHT+IESIki4URh1tyrqlvYWsOUWqoV4EL82z199gSIWFBO1H1UgDaGfZbX3YEhkyuQt2a4QEK1i1joSDZTDG4XeHF0=
X-Received: by 2002:a05:6102:418a:b0:4a4:8d6d:a37d with SMTP id
 ada2fe7eead31-4a8cfd888a5mr14038027137.28.1730261207295; Tue, 29 Oct 2024
 21:06:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241028023809.1554405-1-maobibo@loongson.cn> <20241028023809.1554405-2-maobibo@loongson.cn>
 <b5f4a39a-278a-1918-29f2-b9da197ce055@loongson.cn> <08fa5950-8ca4-b6fc-fac7-77bc5c16893a@loongson.cn>
 <8b7dfe0f-f4cd-d61a-c850-d92b5aec39e8@loongson.cn>
In-Reply-To: <8b7dfe0f-f4cd-d61a-c850-d92b5aec39e8@loongson.cn>
From: Alistair Francis <alistair23@gmail.com>
Date: Wed, 30 Oct 2024 14:06:21 +1000
Message-ID: <CAKmqyKOGcjOFqUMiySYxtCyx-5_Rbx3=w9BYeUuS8mSrQ0bhxg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] linux-headers: Add unistd_64.h
To: gaosong <gaosong@loongson.cn>
Cc: maobibo <maobibo@loongson.cn>, Peter Maydell <peter.maydell@linaro.org>, 
	Alistair Francis <alistair.francis@wdc.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Bin Meng <bmeng.cn@gmail.com>, 
	Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 11:47=E2=80=AFAM gaosong <gaosong@loongson.cn> wrot=
e:
>
> =E5=9C=A8 2024/10/28 =E4=B8=8B=E5=8D=885:55, maobibo =E5=86=99=E9=81=93:
> >
> >
> > On 2024/10/28 =E4=B8=8B=E5=8D=883:39, gaosong wrote:
> >> =E5=9C=A8 2024/10/28 =E4=B8=8A=E5=8D=8810:38, Bibo Mao =E5=86=99=E9=81=
=93:
> >>> since 6.11, unistd.h includes header file unistd_64.h directly on
> >>> some platforms, here add unistd_64.h on these platforms. Affected
> >>> platforms are ARM64, LoongArch64 and Riscv. Otherwise there will
> >>> be compiling error such as:
> >>>
> >>> linux-headers/asm/unistd.h:3:10: fatal error: asm/unistd_64.h: No
> >>> such file or directory
> >>>   #include <asm/unistd_64.h>
> >> Hi,  Bibo
> >>
> >> Could you help tested this patch on ARM machine? I don't have an ARM
> >> machine.
> > yeap, I test on arm64 machine, it passes to compile with header files
> > updated. However there is no riscv machine by hand.
> >
> Thank you,
>
> @Peter and  @Alistair Francis Could you help tested this patch on RISCV
> machine?

I don't have a RISC-V machine either unfortunately.

You can test it with QEMU though

Alistair

