Return-Path: <kvm+bounces-41242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6428A657A3
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:13:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F536885DD8
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 157C41917FB;
	Mon, 17 Mar 2025 16:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3B6TmCqY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1B814A4F9
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742227691; cv=none; b=EYJ7B1M0y7Kc4wLQUsQIZX1Cf/cEnE4yJK6AdPRMX8Aj/bRb/uc7wIhYTkbuUhJzfPO3En7w2hsmyOeQJxHt3kqNiiOBsSKIn9BZV8TG9n780WzWqD8EsYAveOrxgqEqugcsciF0l8v8kSZ6ZU8fdeke+xglOGhhXiMv1C4FqBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742227691; c=relaxed/simple;
	bh=egIWuxBaIjnaXMdoXaDCft2vbzvuOzWQFmi9GgQvLBE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iLNlKcVU5uxvQjr+tfCPHVsS9Hf7ti3zmpG0/L7OtFLFYaHwXe6mvYZO7gbTYiOHGqGNWQHNkmV3jL+zJPzyiTFCjvU60lNTcYgoTmyu5RTwa2wTyDfJJE9sTvWU26cL7VfTwvR0LxwK9+iP/2yCs+j2BSUpRwLfhXK4xQ6EnMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3B6TmCqY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff6943febeso3045285a91.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742227689; x=1742832489; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kFGsIS9GUasJNsr+AyNzSWrAC+Oat7GEq5DJqh+FPjE=;
        b=3B6TmCqY/xB7CV5e9CNaSuiXYHC29peBFDE1xoRUgRGFwB5N7FlNnRPZ4iOa8No7xl
         FbhkT5HtaJEajavFPKbTiGR/d8dMOZqb4/NhcYF+R1elyLV2jH+BKikIHX1UsdWvwEF0
         yX8RAg0cg+aQCsyQaOOFlRS6yxYKaZdnXxaqyy6SgKzc+BGkBneFUelU1HxoupDw89AO
         HDMAo/hBtV4jHHuX8JBkNLVTMXdh1K2zBZnyit2ObPZCPW+YMaY6h495yeIY8cgiZeVM
         lpmoI52qfp/KS+avL9J7M0yjN72VNvW0b5+JzhE9zD9tDuq7EpCpwutSU1LhzeIGofXn
         QR+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742227689; x=1742832489;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kFGsIS9GUasJNsr+AyNzSWrAC+Oat7GEq5DJqh+FPjE=;
        b=aQf5mJz6RvXfddY0hkOgqr8otKR96kMMSfregjXO12JGFXNuqhnO6KjcKipz0caFTt
         seOBkNnoSnQlJTUohEcYRbciAvLlUQmmtmvgwmaRzsONnDwPnr7Jlev3+1TkkxeLI98Z
         hceO8sa4Na6VvxRRRMuo7QuZvgql1EI5eOMWrbHevnuU1ptUy/w4tmFaY/4ymgfzX39r
         LwCC/4vHhniZQlrDNZQDtTkNkpdif3C8E5Eax5qdJoR6zRQeYVdVRSskN/JHTsiYD+Pv
         V6/6wbf/v5ebP4Ou8kRTiHWFCP8+McbQAX/5WCBCcSK1CeSDYID9xHdU3vX9o8Xa7PtW
         h1uQ==
X-Forwarded-Encrypted: i=1; AJvYcCUY1t+oIq1TQCo4q6xP9zkfdvQZ2r1vYnPWhlic+MR8/rnftTOs+nNPsa+kiC7g+eFGG3w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2l02yZHQE+EH3P+0dVOq6x4TnVjpMgRKYvxn7pgEeaeDaA4Z4
	xsirUfawGzzfSuyA+7PW8rhDAkuWb94Xbq9gDxZydv2alEIUXlcYiPDA4e+AEa8/EVm1GdvD6YM
	I/zRwls5/ysj+5ygkn9gKPlDqCpNMfXnkEbyAR8s7+oqCyPj1Ppk+qp4=
X-Google-Smtp-Source: AGHT+IF+hruQfmOR7ShC4vLyikmFYkRsFWDD656xmQF7xQnZ3FiYAQLSOrsH0dqIoNXqWj4kGILXNWg7yAo=
X-Received: from pjbli15.prod.google.com ([2002:a17:90b:48cf:b0:2ef:d136:17fc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e48:b0:2fa:4926:d18d
 with SMTP id 98e67ed59e1d1-3019f4f043cmr10445a91.13.1742227688937; Mon, 17
 Mar 2025 09:08:08 -0700 (PDT)
Date: Mon, 17 Mar 2025 09:08:06 -0700
In-Reply-To: <20250317-kvm_exit_fix-v1-1-aa5240c5dbd2@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250317-kvm_exit_fix-v1-1-aa5240c5dbd2@rivosinc.com>
Message-ID: <Z9hI5vEHngcKvvRa@google.com>
Subject: Re: [PATCH] RISC-V: KVM: Teardown riscv specific bits after kvm_exit
From: Sean Christopherson <seanjc@google.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <apatel@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-ccpol: medium

On Mon, Mar 17, 2025, Atish Patra wrote:
> During a module removal, kvm_exit invokes arch specific disable
> call which disables AIA. However, we invoke aia_exit before kvm_exit
> resulting in the following warning. KVM kernel module can't be inserted
> afterwards due to inconsistent state of IRQ.
> 
> [25469.031389] percpu IRQ 31 still enabled on CPU0!
> [25469.031732] WARNING: CPU: 3 PID: 943 at kernel/irq/manage.c:2476 __free_percpu_irq+0xa2/0x150
> [25469.031804] Modules linked in: kvm(-)
> [25469.031848] CPU: 3 UID: 0 PID: 943 Comm: rmmod Not tainted 6.14.0-rc5-06947-g91c763118f47-dirty #2
> [25469.031905] Hardware name: riscv-virtio,qemu (DT)
> [25469.031928] epc : __free_percpu_irq+0xa2/0x150
> [25469.031976]  ra : __free_percpu_irq+0xa2/0x150
> [25469.032197] epc : ffffffff8007db1e ra : ffffffff8007db1e sp : ff2000000088bd50
> [25469.032241]  gp : ffffffff8131cef8 tp : ff60000080b96400 t0 : ff2000000088baf8
> [25469.032285]  t1 : fffffffffffffffc t2 : 5249207570637265 s0 : ff2000000088bd90
> [25469.032329]  s1 : ff60000098b21080 a0 : 037d527a15eb4f00 a1 : 037d527a15eb4f00
> [25469.032372]  a2 : 0000000000000023 a3 : 0000000000000001 a4 : ffffffff8122dbf8
> [25469.032410]  a5 : 0000000000000fff a6 : 0000000000000000 a7 : ffffffff8122dc10
> [25469.032448]  s2 : ff60000080c22eb0 s3 : 0000000200000022 s4 : 000000000000001f
> [25469.032488]  s5 : ff60000080c22e00 s6 : ffffffff80c351c0 s7 : 0000000000000000
> [25469.032582]  s8 : 0000000000000003 s9 : 000055556b7fb490 s10: 00007ffff0e12fa0
> [25469.032621]  s11: 00007ffff0e13e9a t3 : ffffffff81354ac7 t4 : ffffffff81354ac7
> [25469.032664]  t5 : ffffffff81354ac8 t6 : ffffffff81354ac7
> [25469.032698] status: 0000000200000100 badaddr: ffffffff8007db1e cause: 0000000000000003
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
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---

FWIW,

Reviewed-by: Sean Christopherson <seanjc@google.com>

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
> -	kvm_riscv_teardown();
> -
>  	kvm_exit();
> +
> +	kvm_riscv_teardown();

I wonder if there's a way we can guard against kvm_init()/kvm_exit() being called
too early/late.  x86 had similar bugs for a very long time, e.g. see commit
e32b120071ea ("KVM: VMX: Do _all_ initialization before exposing /dev/kvm to userspace").

E.g. maybe we do something like create+destroy a VM at the end of kvm_init() and
the beginning of kvm_exit()?  Not sure if that would work for kvm_exit(), but it
should definitely be fine for kvm_init().

It wouldn't prevent bugs, but maybe it would help detect them during development?

