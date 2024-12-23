Return-Path: <kvm+bounces-34343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B1339FAEF4
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 14:51:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78B7D1883DBA
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 13:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B041AE00E;
	Mon, 23 Dec 2024 13:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="kYu/fZ5/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4049911185
	for <kvm@vger.kernel.org>; Mon, 23 Dec 2024 13:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734961873; cv=none; b=o8TLh1MysQjovHHRzhEH6YS9ABj0LepmEHtc7mgDBcsaDuC7yGfVC5Sp2ZRdFBRTOduupdO4oEc/xD5FxUpHfaW9kBXqNiDI+l69OtTYP5ow7NF6Uz3HNhrcXvgFJBTzhii8swlPCTdHmrs3SZ5oEKOmcY3nE3vKKU3AvXVPGoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734961873; c=relaxed/simple;
	bh=0z14O2c0hBkbTovxNzfEfUBcWodPjuEGNfan40OqewM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vB5yi3qJwra6T9pGQd8VFh7LSqR7Yi8CEDOJHFl7hoatt9A1sSnNjjd6N5NjKFe+zRqzMKFJILEZgEvSMVTN5gHngwoBJp0bMCp591elTpaWCaOxyMORibnz+Uhaghxh74TpHqBaPCzspttYjhIJFX5tCLLIMdRnlWa1FS2Rh2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=kYu/fZ5/; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a8aed87a0dso13118505ab.3
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2024 05:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1734961869; x=1735566669; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uBUGbvOTK35f8UJtqBoqDjyz/sfzFGS+AJ+9yAi4e5I=;
        b=kYu/fZ5/fleQezAHo1zN1LXEjhgXlErj5auVNrSTytg/8N+KaKQjTVSNBGxk+uax0a
         bs12rewh7PChbb9kelTcs+aHUsZckn7DtFf+XnoPFKcn0aNz1wpP1e9u5B/ORMFIO82t
         YHJyhE1sBwiNoKrtgmi+Sia8APmO1hfX+fpC4dEOYLkXPBEJhGLlaIdTNwIaUecetWWU
         f+2f6pTNZtOB1SQeykdQ9FuZNf/bVAy2QLyBnkTkkwk7PdC3PrBoxecFR9/k6LZgScM6
         J52fbH08sRNbSHIaXLRoqJdyXRyeHQ5NnToWxsZcjYtR1xCkiJTmw15XSBVgzgsIsXxo
         3lKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734961869; x=1735566669;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uBUGbvOTK35f8UJtqBoqDjyz/sfzFGS+AJ+9yAi4e5I=;
        b=TdxT1sdrkJzFLmIu0valFbVX5B2s1J7gr8vJoN9h1ZEC2HHwGbYYJrMlHYVsqKcHUd
         k/2HI33zM0bXlnCL/PMzribqseCkAWvOkKlwBXwZ2D1IkkkFd+9AefbiTfXL32p7DqwD
         Y6ruF68raPoUgfrycQT+bHNbi3YPsFd9/4Zlg2TlXaql2jjjhXwkaflfDJAHktir09JU
         TlvZC6yONn1/CBZfzYDv014zmuttHHUwbeGFW5RVNVPI8hO1N+W2PKAY7ztgqqDp26a6
         1hrpdJsJh9FKasF9Li9GJFg/yvkCGV0AENuGdWzMUCFPvQhdP76wJpHsqvKRCIQWan4b
         rvww==
X-Forwarded-Encrypted: i=1; AJvYcCW2CWGrGVAxWlyofotA6ZMGiu1dMh1j+32HQMtg1uo3i3e2JvZOfosCboHc25urn+U84BA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAWV4hX3tWdEi+PPAqzmqkIs80AjP0XxOy4Z4c8F2aqqfH3/qv
	w5YE3hLP90v1ILoYhUJIr8MiRnsX6AqZRAmX9403UGlXvjsVyNe3dUv9mt8No9KajglJYKfAtKu
	8qt02bxrTIj5z308pNm/qGmFghMYKDp6ddUZBLw==
X-Gm-Gg: ASbGncuSgZsGKjB90KUHnA2P2uDEwGyzpjXiHxdqju8JOfIQY0Oub02B8Z2YXyQUHc1
	KNhyrWnxZ6tMlmF9X9RWY+NpP4KjptyCXpQaaAM0=
X-Google-Smtp-Source: AGHT+IHVkaJEErCuD3prh5w1E8qTx+W2cqJc7u6exkKNlpVGYeWLcnq7zk029yKzN8LpTkNzf1AFZ0W0DTXNOw/cscM=
X-Received: by 2002:a05:6e02:b42:b0:3a7:e67f:3c58 with SMTP id
 e9e14a558f8ab-3c2d1aa2b80mr109886385ab.3.1734961869289; Mon, 23 Dec 2024
 05:51:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241212-kvm_guest_stat-v1-0-d1a6d0c862d5@rivosinc.com> <20241212-kvm_guest_stat-v1-1-d1a6d0c862d5@rivosinc.com>
In-Reply-To: <20241212-kvm_guest_stat-v1-1-d1a6d0c862d5@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 23 Dec 2024 19:20:58 +0530
X-Gm-Features: AbW1kvYTtPTa3y6m7DD0FCrFgf0XJvu4Z-dbRYtVc6TLQHaQkADxyK7GuE7MGZU
Message-ID: <CAAhSdy1SGZTh4k1A22YWMeQ4ryCHeh3rV9feu+3SSF8b86J5nA@mail.gmail.com>
Subject: Re: [PATCH 1/3] RISC-V: KVM: Redirect instruction access fault trap
 to guest
To: Atish Patra <atishp@rivosinc.com>
Cc: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Quan Zhou <zhouquan@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2024 at 2:26=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> The M-mode redirects an unhandled instruction access
> fault trap back to S-mode when not delegating it to
> VS-mode(hedeleg). However, KVM running in HS-mode
> terminates the VS-mode software when back from M-mode.
>
> The KVM should redirect the trap back to VS-mode, and
> let VS-mode trap handler decide the next step.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_exit.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index fa98e5c024b2..c9f8b2094554 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -187,6 +187,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct=
 kvm_run *run,
>         case EXC_STORE_MISALIGNED:
>         case EXC_LOAD_ACCESS:
>         case EXC_STORE_ACCESS:
> +       case EXC_INST_ACCESS:
>                 if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
>                         kvm_riscv_vcpu_trap_redirect(vcpu, trap);
>                         ret =3D 1;
>
> --
> 2.34.1
>

