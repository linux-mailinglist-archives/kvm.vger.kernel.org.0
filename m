Return-Path: <kvm+bounces-41542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16274A69FB7
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 07:17:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 820D4421F32
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 06:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FE2B1DED78;
	Thu, 20 Mar 2025 06:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="WO/d9EMt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C226579C4
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 06:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742451419; cv=none; b=Air8Ut/Vci0S7PK75fGrXtNDYpJ55C6p1EalCliowgNKxU27hi02OWVV1vTqSp2kqWrVRbmf6N09qUDo2mX8g5+VR4st/Ak7X5d25n1s5WNqOM16LOh922oc5/4kDMPobwa5Fn8uxzMzOdNMEfD9RfngLrpw9OPN/TZblQwyd68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742451419; c=relaxed/simple;
	bh=Pn23df60N2TqUpXgsnipthg5aodyTkZWQb1xoT6fL1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uO0AQIvoypeI5sfrC2ZfAUoYT6ElkrUMW1C/hh68IFvZRrim+vj3y5g6Eidc/ZOCFowdCOdVERqwzsrjM4iC2XPdelNknhPSk5s+z2ESDVt1f8QvxvSgWgGV9i7NSCJKdUy8qQDYydMD/XnZK4C5MliCrARYzogkZ2jNPVZ9wUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=WO/d9EMt; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d571ac3d2fso4638155ab.2
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 23:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1742451417; x=1743056217; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OumWTE1YfFz2VvLMd8Qp/KkVHZxtkWOHY+KRV1KScms=;
        b=WO/d9EMta9VQoNVARRR841R5tkkn5+Llq1QmPthMO8l49gAjJ1QhVJn2o2cojpnMHB
         4flyAlwNTgYi2+U1CC0JcNZq0vy0/bZaneOWK5u+q/japJtF62dBciipn8DBJ099bc3Y
         xdaMen1BxkHFyBLvoyglqKQtdW9xF0J7vcfcjFKuK0lseSLUoVNhG/vPbIzg0YodbK/P
         jdHPk5b1FKN7QwGqla/i5ZzW7vVVt3/X4PnsHlhFwrYbNvP9Mglo1d5SaSA2wMmVfKt6
         Gz/zdcm9SeB6nmxCNzQETdp3YRM0ExC4Gx+itJORCV0dXlVWD7bMSkrawDharz7onGzg
         1jhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742451417; x=1743056217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OumWTE1YfFz2VvLMd8Qp/KkVHZxtkWOHY+KRV1KScms=;
        b=JEUEzdKv3U2yuqrRpAHe1bb70VcUJKGU6QnoVwU560a8wGkX8vKf1EfterqrLa+Idc
         RRcN7bE110If8pH6dr9vS1PGgrD+AwwLUqwxCYzhY9TTj8K2Xk7zRdRHCzuvy9tTKPll
         mG9diNCX8oFRe7cAafSh9UQqdXXUZ7n1J2En/OS1dFYLfz9df1qbMILTPzDo1AmhKtBX
         XlJDZY27zYsvO9uY4WvELQSjWfGPISPurL9UDxvFsm1S90bL0zbAqe7OIX0MTWbXvtPT
         Jz/FnqYYhFTTe6cDGkuG4CjcgUlA9PiujoE68cv0SuQSCQBd42oBlXNj7Tr7khaYRxJ5
         GnUw==
X-Gm-Message-State: AOJu0YwxUndr3ED8YGWjhfU+z1HpZTeQ4DVt9R9ulVwoynRAfrOz/fn9
	JTqSK2lJNR3FWuUM3bQxsPTrDOUMdv64eK6unx6ILx2RYkn0n6n6fkxlgXmFuqQhASANgL/ytCg
	sQRtbhPbPkLdyiJ9IgbJkGCMBsYYcJYM830otew==
X-Gm-Gg: ASbGnct+t9VAjree4pnUua/31zgrK9PS2GOPRspTdopJig13F3uISJrtHzuZmdcQYjb
	aa6fgnYimfO4E3CluZ5I4x+YZd31bHm9hUKULZy6EPlDBHthq8L6TOmVroMZeXeCs4lQ2sRb/pZ
	ttsB9g4jdteEJak18qFU5gA+PRfw8=
X-Google-Smtp-Source: AGHT+IHipmErTnY5JH+X1dtI8RojvvbQcWLsdi/XQW8CsQKWvuNjEAmBqXPOtO4Jae23WAgQHVx1Xbh9o0P7ZC58A0w=
X-Received: by 2002:a05:6e02:1d9c:b0:3d3:d074:b0d2 with SMTP id
 e9e14a558f8ab-3d586b14fcamr55445275ab.2.1742451416731; Wed, 19 Mar 2025
 23:16:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250221025929.31678-1-duchao@eswincomputing.com>
In-Reply-To: <20250221025929.31678-1-duchao@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 20 Mar 2025 11:46:45 +0530
X-Gm-Features: AQ5f1Jp8ck1csnU-BaM6TvZZs8RKPQqg6ZKhFpmtTukK9VGozPJ4dYYmH7prrsQ
Message-ID: <CAAhSdy0iyb0PfUbuaDMi+QXF7LRoL2i=hHSe7deLyia3rmFcyQ@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: KVM: Optimize comments in kvm_riscv_vcpu_isa_disable_allowed
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2025 at 8:29=E2=80=AFAM Chao Du <duchao@eswincomputing.com>=
 wrote:
>
> The comments for EXT_SVADE are a bit confusing. Optimize it to make it
> more clear.
>
> Signed-off-by: Chao Du <duchao@eswincomputing.com>

Queued this patch for Linux-6.15.
I have taken care of Drew's comment.

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_onereg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index f6d27b59c641..43ee8e33ba23 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -203,7 +203,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsign=
ed long ext)
>         case KVM_RISCV_ISA_EXT_SVADE:
>                 /*
>                  * The henvcfg.ADUE is read-only zero if menvcfg.ADUE is =
zero.
> -                * Svade is not allowed to disable when the platform use =
Svade.
> +                * Svade can't be disabled unless we support Svadu.
>                  */
>                 return arch_has_hw_pte_young();
>         default:
> --
> 2.34.1
>

