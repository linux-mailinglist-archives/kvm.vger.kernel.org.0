Return-Path: <kvm+bounces-41476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8569A68521
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 07:35:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 499F64223D0
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 06:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC69B212D96;
	Wed, 19 Mar 2025 06:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="f57pklXC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF9635972
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 06:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742366111; cv=none; b=Hvl8QB6xWCs1ZWJrcBG4aifaDgY0hX456QfnHCWt+JsuXRiZd3uZ1o+6HypqWZIM20erpumVfHHgU/M3OYPBTxbTKIutNfvT+G4bnSP2eVIWTNWFQbzESRr6eRxM/SQA9GBc4aUG8krf+ww1GUVa7nOiddI2db4xIZxsKz8OOUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742366111; c=relaxed/simple;
	bh=3C2fH56/ANPFLK5srhoeuXlQMjKMqMfCndGH5a7mUAE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZXTKEXHVkbHFcwvnkqkiyRyplpSrBrTVT2wbE8H9/58s9H5xc3S03euAujg94M+wNkchcPD4MhtXe0lFFdrGfgfhiKUbD7w81AHv533llLN7TIxwgdFE4ai4onohE6aVQCuSnosTwpOIG5OeJDvaa6BssLOCjbm9NbkcmQY4nGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=f57pklXC; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-54ac9b3ddf6so589974e87.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 23:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742366107; x=1742970907; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nRcMBAnBB1cdPSStkQP8KD4Ik0+X3f5WUJpWyEcmszQ=;
        b=f57pklXCk1ulSi5raEGocP5b89UxVGNCODC3W0kcDuRMkWmmgd4rHos1dkxd0432eg
         zlhvDnxPuankZHKJyw+ZaUbY6mLGwn+SLgw+J2dZtN58ntRuFrN+Lww2ThWiAd7aPYqS
         xE40NxaHHPNROU9vv2zhj8s7LGUm8YQqdUFn5df013IQvc+DpXaSLqJPMD+JvS7EVpYp
         62PD4xYXSvApQ+dd9Ow6Ggnmcwr2lj1X/HSFUKW9KCS2buWsQzQz7V+fsir+I6A02jui
         QUUBZR+Ll5AFzSB6iC3AbJ2XJHt8F8VnPbTZjbm+4tM08ywwMJkiel0q4N3s6gPeURse
         577g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742366107; x=1742970907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nRcMBAnBB1cdPSStkQP8KD4Ik0+X3f5WUJpWyEcmszQ=;
        b=hz9C4VWWl37JAVS7RIjnxTLVi26QyeFNtkrtUXO+A9lktdQhQlqr6bJsdtjR8EDHIL
         8YvhqCx5GGu+20OR760xOH72lw+CzbIep56SsAsKZWWTPwIvsQzHvRC9kUZethFURXI+
         MyroTp1MO+Sqj5MvBY5kmXnJhXeIIpxRuMT+1alAqLyh783wKq7ZojIm7jIqLjWIXEn0
         fZczTnon2B82+mDRXz6EHr+4B72DQAyjmeg/w5T3tGSyOfO2/nD+Kh5wlwk617B3ivcQ
         e5GU8BpF25oiIhdVIcC3P07jJUF/Hj49cJmS/V2ySeqHjIsLuakWWdJq6zbN7hoPFc9M
         s/Bg==
X-Forwarded-Encrypted: i=1; AJvYcCXkP91hPnbsfAXCrZ78FtiNGo3Hxxj76fQlLHqqw7gU3aWiQvbTuosbccCLzsFC8O0MNmI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2r7PZrlIE4zI1r2toS9SrVm5iqJU1a3+XznE0mfJmDS/ZO18v
	aYB5eHAFFxGQew56Xn9Te4+lK48yLJ6FGM4smqFGC1ss0+fAuEOG1lygjGHLZDUxNukCVRKk7aW
	ccKQtLY7RCXkiUzVpKWGCQGDsr6UaawHD178Edw==
X-Gm-Gg: ASbGncsH6G+0gCSaUdKjPUBTntrpx7UGvTWbBU1pDUlERyiZTPNihU0s0HL4o+68UdD
	j5kkSu8RR6AdhhRSV0XXctYnOAJtU+TCubjS46AS3l03Drtc+trajgnVM0CcA1T9JhKXdzzYzwY
	EdOgJ1aqInzXQeDPjsBf1fRveLMb4=
X-Google-Smtp-Source: AGHT+IG2DF9ysJOnGisWYlJRKJjNI7goJzS2EHde/phn2/2Rqicusog58ZNjwKuNH+aDT8iIlFKP1DPR1Tk9Qcbg6iY=
X-Received: by 2002:a05:6512:2c89:b0:54a:cc09:eacc with SMTP id
 2adb3069b0e04-54acc09ebcemr366625e87.39.1742366106954; Tue, 18 Mar 2025
 23:35:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317-kvm_exit_fix-v1-1-aa5240c5dbd2@rivosinc.com>
In-Reply-To: <20250317-kvm_exit_fix-v1-1-aa5240c5dbd2@rivosinc.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Wed, 19 Mar 2025 12:04:55 +0530
X-Gm-Features: AQ5f1JqvoOcfbMQnETX7LXFFQmbgXKx4mcvkbI8cra0TF1szaF4KZK20bqrxCC4
Message-ID: <CAK9=C2XzuUO3NiKOwwa+Xyh+j7XUtHNBb=YCbe49kHHJY0Ke8Q@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Teardown riscv specific bits after kvm_exit
To: Atish Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 17, 2025 at 1:11=E2=80=AFPM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> During a module removal, kvm_exit invokes arch specific disable
> call which disables AIA. However, we invoke aia_exit before kvm_exit
> resulting in the following warning. KVM kernel module can't be inserted
> afterwards due to inconsistent state of IRQ.
>
> [25469.031389] percpu IRQ 31 still enabled on CPU0!
> [25469.031732] WARNING: CPU: 3 PID: 943 at kernel/irq/manage.c:2476 __fre=
e_percpu_irq+0xa2/0x150
> [25469.031804] Modules linked in: kvm(-)
> [25469.031848] CPU: 3 UID: 0 PID: 943 Comm: rmmod Not tainted 6.14.0-rc5-=
06947-g91c763118f47-dirty #2
> [25469.031905] Hardware name: riscv-virtio,qemu (DT)
> [25469.031928] epc : __free_percpu_irq+0xa2/0x150
> [25469.031976]  ra : __free_percpu_irq+0xa2/0x150
> [25469.032197] epc : ffffffff8007db1e ra : ffffffff8007db1e sp : ff200000=
0088bd50
> [25469.032241]  gp : ffffffff8131cef8 tp : ff60000080b96400 t0 : ff200000=
0088baf8
> [25469.032285]  t1 : fffffffffffffffc t2 : 5249207570637265 s0 : ff200000=
0088bd90
> [25469.032329]  s1 : ff60000098b21080 a0 : 037d527a15eb4f00 a1 : 037d527a=
15eb4f00
> [25469.032372]  a2 : 0000000000000023 a3 : 0000000000000001 a4 : ffffffff=
8122dbf8
> [25469.032410]  a5 : 0000000000000fff a6 : 0000000000000000 a7 : ffffffff=
8122dc10
> [25469.032448]  s2 : ff60000080c22eb0 s3 : 0000000200000022 s4 : 00000000=
0000001f
> [25469.032488]  s5 : ff60000080c22e00 s6 : ffffffff80c351c0 s7 : 00000000=
00000000
> [25469.032582]  s8 : 0000000000000003 s9 : 000055556b7fb490 s10: 00007fff=
f0e12fa0
> [25469.032621]  s11: 00007ffff0e13e9a t3 : ffffffff81354ac7 t4 : ffffffff=
81354ac7
> [25469.032664]  t5 : ffffffff81354ac8 t6 : ffffffff81354ac7
> [25469.032698] status: 0000000200000100 badaddr: ffffffff8007db1e cause: =
0000000000000003
> [25469.032738] [<ffffffff8007db1e>] __free_percpu_irq+0xa2/0x150
> [25469.032797] [<ffffffff8007dbfc>] free_percpu_irq+0x30/0x5e
> [25469.032856] [<ffffffff013a57dc>] kvm_riscv_aia_exit+0x40/0x42 [kvm]
> [25469.033947] [<ffffffff013b4e82>] cleanup_module+0x10/0x32 [kvm]
> [25469.035300] [<ffffffff8009b150>] __riscv_sys_delete_module+0x18e/0x1fc
> [25469.035374] [<ffffffff8000c1ca>] syscall_handler+0x3a/0x46
> [25469.035456] [<ffffffff809ec9a4>] do_trap_ecall_u+0x72/0x134
> [25469.035536] [<ffffffff809f5e18>] handle_exception+0x148/0x156
>
> Invoke aia_exit and other arch specific cleanup functions after kvm_exit
> so that disable gets a chance to be called first before exit.
>
> Fixes: 54e43320c2ba ("RISC-V: KVM: Initial skeletal support for AIA")

The kvm_riscv_treadown() was introduced by some other commit so
we should include a second Fixes tag which is:

Fixes: eded6754f398 ("riscv: KVM: add basic support for host vs guest
profiling")

>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Otherwise, this looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 1fa8be5ee509..4b24705dc63a 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -172,8 +172,8 @@ module_init(riscv_kvm_init);
>
>  static void __exit riscv_kvm_exit(void)
>  {
> -       kvm_riscv_teardown();
> -
>         kvm_exit();
> +
> +       kvm_riscv_teardown();
>  }
>  module_exit(riscv_kvm_exit);
>
> ---
> base-commit: 4701f33a10702d5fc577c32434eb62adde0a1ae1
> change-id: 20250316-kvm_exit_fix-77cd0632d740
> --
> Regards,
> Atish patra
>

