Return-Path: <kvm+bounces-12568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1035488A1AA
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:23:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 338431C37B2C
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213DE3DABE4;
	Mon, 25 Mar 2024 10:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="qJ/zhvel"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E9A3DAC15
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711356355; cv=none; b=nuIeac49VKqaav7VfODh3D/1IMWwhNmaMWwM+uYjFAyI6htsPlvGNMBtA56HPXFTzln40+ty0TGxnOIGiXOWYl/FTVjTI5Y6Yaz8SpzmmE09x8j01WL+JEU8HWRIFuTDyZUiPzuhvunnmeWKCFvcFHnZl+m78IaxbmaPFVxLoL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711356355; c=relaxed/simple;
	bh=fO1r3ga0JBx751mFkNBSV+bA60NgEtVq6JELHzFB+jE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rPWOZG4FfDybQL7RsgO3KqDCbO4e90Bo6I1vkhQP/7LKoDM4KoMP8386+iyNkp98PvZjZs2qrl7lnr2VK0XFcn5JpmuKLJjGvUOEWylVeEgtSSw2SvdSApf6K8INNWDRGnzFvgMo+0VuQbiKFqBZ9qKPcuVExyeZ+RBY4qlBGxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=qJ/zhvel; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3684faf6286so17575625ab.1
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 01:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1711356353; x=1711961153; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mAJj9egrVyRikkG0RKQceibcTBuLJH9YKNRRgrENxgU=;
        b=qJ/zhveltvzZ1dy0tj5EosPrq6kX8avnMBJsc+ZW7iRUqfiZovHGCG6I7Di+XjsY4c
         ITMVf9Dr9BXOqvNyGNipW/h4ackSA5L4kkvnrH/WgkenECqv5G00DLwQvxoHwi2Zx+wi
         CtYRihtWqX2bie+DDmk09/mAUBQ4H3+/Svb0jbsKoI4qw6Ivgg0qmlPyPAky1o9mM9zH
         HDlX4Bsln6E+FiYO33Xb+6kjUOC/G0w4SCNlfLXvn8if4hepBqRX0okMIrlpGH3C6Up/
         7vWyi9byhaiTFJ9fapfAuuTKBYejZPj8Vtd5aqnzPJ4zfJgc0uvVvOtOCseGKU3qAjDO
         v4ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711356353; x=1711961153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mAJj9egrVyRikkG0RKQceibcTBuLJH9YKNRRgrENxgU=;
        b=gvMBTwaxOFFZhSgxH4y5/MxbxRlsXotqpuuO87+meg4zdvz7JXBtbtJTiJUN38POkb
         Dvz3o9NlC21rarbh5S8ko2abJu9aDpxG46tgFDguWBQAZMJQnAAsUWcBQKBf6ipBh7PE
         /gHCC9Mc73y2nyV7eueMcsn+noNfMIFo+WJU2dNRPG6FVRzMPxBaTzh+LMW0ldqzyNVJ
         /UKMITEwhZjR8o4srsYj5MLYLiH+1GshEMRUc7ZJ4IL4qvLXEYwDqnz6B+laqGOXBCc2
         3rtvgrkpzWntFoAcpMZg/o5+V+I3jscjBHj6z994RFE2SY6DAnqMM8+2at9b9gxkECHZ
         QBqg==
X-Forwarded-Encrypted: i=1; AJvYcCWUOZqVMtzk+a+JJFqgja5a/PZ9GblL+N4QPg8sxEsAMeSjsuBs5yqAmCqigjAHCTqpio1ki3wiL/eUElP9TnewCDtm
X-Gm-Message-State: AOJu0Ywd4FxkRxy+8mcrqJw35KrQKsy/BNMefw1iZenIrddfdSjjXLKK
	yRR3faScx5+LA5fL6EI+Tap0yDiG3lbIy8KLLTXF3ro3V7vr3uMMAH6aESHlOE3xx+wzBxmba+Q
	oLX7ni59lNQJti8oaF+RwW0IS732Rd31BIyllwQ==
X-Google-Smtp-Source: AGHT+IFVuCUCa9T26qI8wOCmAKjs5jQ0HPi7rCqnQz+zQAp9mUrZiWSUVy4an898YpR/XXTQ+Vy8tiAEK/p3ABMeQm0=
X-Received: by 2002:a92:ce04:0:b0:368:4766:ad75 with SMTP id
 b4-20020a92ce04000000b003684766ad75mr7623231ilo.10.1711356351275; Mon, 25 Mar
 2024 01:45:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307081951.1954830-1-colin.i.king@gmail.com>
In-Reply-To: <20240307081951.1954830-1-colin.i.king@gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 25 Mar 2024 14:15:40 +0530
Message-ID: <CAAhSdy2zg4dD6_hKOWDuXxxcpiiu1RwpeL_h6-hvm+Y2B1hEeQ@mail.gmail.com>
Subject: Re: [PATCH][next] KVM: selftests: Fix spelling mistake "trigged" -> "triggered"
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 7, 2024 at 1:49=E2=80=AFPM Colin Ian King <colin.i.king@gmail.c=
om> wrote:
>
> There are spelling mistakes in __GUEST_ASSERT messages. Fix them.
>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Queued this patch for Linux-6.9 fixes.

Thanks,
Anup

> ---
>  tools/testing/selftests/kvm/aarch64/arch_timer.c | 2 +-
>  tools/testing/selftests/kvm/riscv/arch_timer.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/tes=
ting/selftests/kvm/aarch64/arch_timer.c
> index ddba2c2fb5de..16ac74d07d68 100644
> --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> @@ -136,7 +136,7 @@ static void guest_run_stage(struct test_vcpu_shared_d=
ata *shared_data,
>                 irq_iter =3D READ_ONCE(shared_data->nr_iter);
>                 __GUEST_ASSERT(config_iter + 1 =3D=3D irq_iter,
>                                 "config_iter + 1 =3D 0x%lx, irq_iter =3D =
0x%lx.\n"
> -                               "  Guest timer interrupt was not trigged =
within the specified\n"
> +                               "  Guest timer interrupt was not triggere=
d within the specified\n"
>                                 "  interval, try to increase the error ma=
rgin by [-e] option.\n",
>                                 config_iter + 1, irq_iter);
>         }
> diff --git a/tools/testing/selftests/kvm/riscv/arch_timer.c b/tools/testi=
ng/selftests/kvm/riscv/arch_timer.c
> index e22848f747c0..0f9cabd99fd4 100644
> --- a/tools/testing/selftests/kvm/riscv/arch_timer.c
> +++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
> @@ -60,7 +60,7 @@ static void guest_run(struct test_vcpu_shared_data *sha=
red_data)
>                 irq_iter =3D READ_ONCE(shared_data->nr_iter);
>                 __GUEST_ASSERT(config_iter + 1 =3D=3D irq_iter,
>                                 "config_iter + 1 =3D 0x%x, irq_iter =3D 0=
x%x.\n"
> -                               "  Guest timer interrupt was not trigged =
within the specified\n"
> +                               "  Guest timer interrupt was not triggere=
d within the specified\n"
>                                 "  interval, try to increase the error ma=
rgin by [-e] option.\n",
>                                 config_iter + 1, irq_iter);
>         }
> --
> 2.39.2
>

