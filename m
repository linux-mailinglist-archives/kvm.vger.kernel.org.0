Return-Path: <kvm+bounces-38361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED10FA38061
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:39:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D6CA3ACD39
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0772B217707;
	Mon, 17 Feb 2025 10:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="1e8nsgRy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF972165E3
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 10:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739788640; cv=none; b=n6W8y0TB5UFqjlfHgh59j7KVDI7mJvf+qH7D6UeclQuuZZ5SE9I+kXRYa0kHAOVDuHK3k8vmhaxf0V4CbigTFTetiWFb0B2a4XOxY9ZxOtocC7CMWhaAu3RJiE82pl1aiScKlQqSnoHFrhCnHxKVhd4qruYpbIdqU1l3bwX9M4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739788640; c=relaxed/simple;
	bh=dtbILtLxMaUl8l2yPdhhHAGatYs4PRjliukECJuJak8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XwI+7WhpN9ruxjqQ2OnGE88vbhtcrjXSsd4uAGvCvtQVQcIqgWZCKg2uzEsVeyTXOLWY7PjR46NE3WNwbbZCzyg5dxzxP/Hjz3EdRNhhvo1vR4+OhIcX/kDqufvz/uQ9CTYtvrcsgH8PBTiS8CeZ2n1metYFICteB+V5axI2oNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=1e8nsgRy; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3ce886a2d5bso38930915ab.1
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 02:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1739788637; x=1740393437; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U/4vfKOluL1Eg686lBWaj194kh5dTDmMHAYz+CjFLAs=;
        b=1e8nsgRyoAu7BopQM+4mk4O8hjOS6rE4Ba7aGPZLwi/+Z29YwM1VQaL1CARDI6u03s
         YJ9sjVFHA980uaOUoL58HJ/ZLjqnVE5+Q+3BE5vhU6bZ/OdWfksvZeFVgp8jDOM5FMEa
         x/i+WYcPI1K2t4Xi7wngNQFqQWdyBf8AHDLVvlznc9MSuV/2tzhq5DsdP51YgvktIPLA
         QU98kyQ0NJtZ9kOYXD7b92BdYKxxfBIZsl/KLtBsWKfbn2Zjl5lWNSHWQH6xcLPe8efl
         Wz4qvK+KgyZKMjiAHfZmfAvdkFSziVsUiLiEnubcdYa3lZjhix8LLgRLNHKNJ7se1V7b
         LuEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739788637; x=1740393437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U/4vfKOluL1Eg686lBWaj194kh5dTDmMHAYz+CjFLAs=;
        b=ZVQp9pvdSZJntRQX/LJ+/l3fin4olfejzTrabdRpCsSuNB37hnvVfHvjObix7qT23r
         pDYi5u5unTcgUG1vr+ujAsnlL05gn2VjddGv0LbinKJMNKk2VnvGnlwV/kr84PTjO/Hn
         glEXq4b1T1QFQ+l+sXpnM/x17mNS7hk8bQr3U5h9K9d4+nGKZn++qBDgjsyMsnIQij0P
         CMMqQyz10F1/765d8j26y0CnlJybmhmOlTIoM+QQe9Sq2bDLodrIav5BXm06P+3uWzEF
         AgLUWgNYB874B3SCzAa9ltk5kfNPANOFedJnoSVLeaZ48CvK/O1mwJ2REzBumDaLMjHt
         NBVA==
X-Gm-Message-State: AOJu0YxEeIwNobybRAlpGotaJySjc13ZvG0kYjWelEwvXu+GJxo5J3a/
	xT4QSPyzIGhSQATtJoPutMnD0cY1MJhRuk852ek44nXyY3r8svuZIn+njNlEeD32I2VpKkFxCvR
	XXyjWeLNuRYDS1wuqFfdhyMRM4DVYSf0lMqyycA==
X-Gm-Gg: ASbGnctT99AhIyWNH4PFsxwx0SVxQXgBaiHjXWX2jihl9N6rGNqhMPD0bEJ3Yq4kZWl
	LuRV0H4XP4GFaOKEnN89oXGbhnozLwhGed98rLIfGaKde4ivBcxgfLbaR20OajiwgD6xL4PYxTg
	==
X-Google-Smtp-Source: AGHT+IGSgdNxJGmNM6uEFns6lOMjpsz78qALluZZkDvBBvFmGCBC14C1R6jfhNyS8tBwA04k2Qxv26XqVPutxJOehyI=
X-Received: by 2002:a05:6e02:330f:b0:3d1:9f4d:131 with SMTP id
 e9e14a558f8ab-3d28077166fmr81057795ab.1.1739788637040; Mon, 17 Feb 2025
 02:37:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250217084506.18763-7-ajones@ventanamicro.com> <20250217084506.18763-9-ajones@ventanamicro.com>
In-Reply-To: <20250217084506.18763-9-ajones@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 17 Feb 2025 16:07:04 +0530
X-Gm-Features: AWEUYZm9T-78sMEKcz3AEQRarONAs9iFjfd-t2ah-PgfAHb_xncGPr7rpaa4a5k
Message-ID: <CAAhSdy2NxgiE4O0BV5nivTzhUSDH-vo+zqvxb39hga3K4-DgFQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] riscv: KVM: Fix hart suspend_type use
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, cleger@rivosinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2025 at 2:15=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> The spec says suspend_type is 32 bits wide and "In case the data is
> defined as 32bit wide, higher privilege software must ensure that it
> only uses 32 bit data." Mask off upper bits of suspend_type before
> using it.
>
> Fixes: 763c8bed8c05 ("RISC-V: KVM: Implement SBI HSM suspend call")
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_sbi_hsm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.=
c
> index 13a35eb77e8e..3070bb31745d 100644
> --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> @@ -9,6 +9,7 @@
>  #include <linux/errno.h>
>  #include <linux/err.h>
>  #include <linux/kvm_host.h>
> +#include <linux/wordpart.h>
>  #include <asm/sbi.h>
>  #include <asm/kvm_vcpu_sbi.h>
>
> @@ -109,7 +110,7 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *v=
cpu, struct kvm_run *run,
>                 }
>                 return 0;
>         case SBI_EXT_HSM_HART_SUSPEND:
> -               switch (cp->a0) {
> +               switch (lower_32_bits(cp->a0)) {
>                 case SBI_HSM_SUSPEND_RET_DEFAULT:
>                         kvm_riscv_vcpu_wfi(vcpu);
>                         break;
> --
> 2.48.1
>

