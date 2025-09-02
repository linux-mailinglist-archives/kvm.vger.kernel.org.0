Return-Path: <kvm+bounces-56593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C4C2B3FF06
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 14:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 054447AB849
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 12:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4BE2FD1B8;
	Tue,  2 Sep 2025 11:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzg9KSJN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D05285073;
	Tue,  2 Sep 2025 11:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756814332; cv=none; b=naVk1Dh4jTSylbDJVXGnnwHp9GdkTOhRbMEwOtB6nzxTvO1bype7auOilwLM437c/8XY/K7R7k8ajhgtfnl7hsopz7zK/5xO0c/zMYMpsU+t8oRm3p/3fkRoLcIhFj0dOOHMyfaxhm4S+1QHh8YPrV4xXEMg8NkNUCHusJogOco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756814332; c=relaxed/simple;
	bh=j/Jwr/nB0tXPhpoKkVu7JdowEXdG5JIKqo/3ZnOpSi8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c+LbJFnhJYna+TXW3dP8JhZZhDWYL9xjslL/c9vbXa5xVJwThaWM0Rgwb/N0B/NOADWzOXGTtxcPIh2UcbdwA11KnMwfNsa38v5jbQw5SUy1VJZ3nJZ0eOAw7pc/LO/Rtmb9rXk6SY/QTgMf70ulu0bTrMZ48xitg6+TTXzxY7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jzg9KSJN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1382BC4CEF7;
	Tue,  2 Sep 2025 11:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756814332;
	bh=j/Jwr/nB0tXPhpoKkVu7JdowEXdG5JIKqo/3ZnOpSi8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jzg9KSJNBBKL0XaFT+9kUxAtv9rPdbRWppDsJOdV6usvQ3zD7+I1RPQd0MOIXWAHw
	 PtE9ytV2pQimV6WNOGy7KAtKgdCZ6i4SLlyzWVIZki9btxfwOn43vTzU1O/OkTUjWj
	 0Gf/fIis2rCyyq+Y/9DJCAZgCMY9lreaErGcT8zTbJMKNo4WQvrvx70j6W700C4ag3
	 fzSazZ//LhW9PdYGFyVaF26NVUZP4GurTztIGuFbYNOTLEK5T9ypE8uUpv9vzRwNRm
	 hCb4b77KiF9jWeUptr3h7lO11qJoafvjP2c/nSbIiJKcwfoyD9gXvJQccVXkJ67bJk
	 iXO64yFjtGo9Q==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-61ded2712f4so3802382a12.1;
        Tue, 02 Sep 2025 04:58:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWcizi+Ox7T0+m+MiRy2A62lvdv66ZRdiV1rN/+OzNGulKjZ+kpLah/pvdlt/y4RPzTBi/hRZ+W4qn4QgtF@vger.kernel.org, AJvYcCX2WKAv9R5YwZ+Q0agYJOxnkvrpWXBzT9XSCWcf8XBM76mLa1Ig9OQ7FCQjf8E+84CFzlg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUZSjfYQ/ufkm9rYI351bz2uiluGmfN3HpRxQ4EpESqYpOZJBx
	VhmPU8T+vfL31ZmDo63afOBZkrMy7fgfyNGNUNUGFuuhtixZiCIZrX2Ry82Y9Q7qebaKc2D/In7
	zuhlBJ2MRdCtLo5MZC2QM7H1q0EWB5gQ=
X-Google-Smtp-Source: AGHT+IHzG/wKW22VkgqhSqSrx6fuMcYMbjWzX0NMg1/Www8PFf4TcVGlMH/51DhJcAZWk0uJEUQHQqiU23PhMY4xuHQ=
X-Received: by 2002:a17:907:a09:b0:aff:564:128c with SMTP id
 a640c23a62f3a-b01e6d6fb48mr1075429066b.65.1756814330624; Tue, 02 Sep 2025
 04:58:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902094945.2957566-1-maobibo@loongson.cn> <20250902094945.2957566-2-maobibo@loongson.cn>
In-Reply-To: <20250902094945.2957566-2-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 2 Sep 2025 19:58:36 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7hCggw_zhQk89uvBrpAPxgHCS_BC5+twsyZdwWkF4A1g@mail.gmail.com>
X-Gm-Features: Ac12FXzw2QKDeMIrnZ-EJqRnyhVniM9UQBAWMAeOEa_K8ML-RCci0hJUHtWBDlg
Message-ID: <CAAhV-H7hCggw_zhQk89uvBrpAPxgHCS_BC5+twsyZdwWkF4A1g@mail.gmail.com>
Subject: Re: [PATCH 1/4] LoongArch: KVM: Avoid use copy_from_user with lock
 hold in kvm_eiointc_regs_access
To: Bibo Mao <maobibo@loongson.cn>
Cc: Xianglai Li <lixianglai@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Tue, Sep 2, 2025 at 5:49=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrote=
:
>
> Function copy_from_user() and copy_to_user() may sleep because of page
> fault, and they cannot be called in spin_lock hold context. Otherwise the=
re
> will be possible warning such as:
>
> BUG: sleeping function called from invalid context at include/linux/uacce=
ss.h:192
> in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 6292, name: qemu-s=
ystem-loo
> preempt_count: 1, expected: 0
> RCU nest depth: 0, expected: 0
> INFO: lockdep is turned off.
> irq event stamp: 0
> hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> hardirqs last disabled at (0): [<9000000004c4a554>] copy_process+0x90c/0x=
1d40
> softirqs last  enabled at (0): [<9000000004c4a554>] copy_process+0x90c/0x=
1d40
> softirqs last disabled at (0): [<0000000000000000>] 0x0
> CPU: 41 UID: 0 PID: 6292 Comm: qemu-system-loo Tainted: G W 6.17.0-rc3+ #=
31 PREEMPT(full)
> Tainted: [W]=3DWARN
> Stack : 0000000000000076 0000000000000000 9000000004c28264 9000100092ff40=
00
>         9000100092ff7b80 9000100092ff7b88 0000000000000000 9000100092ff7c=
c8
>         9000100092ff7cc0 9000100092ff7cc0 9000100092ff7a00 00000000000000=
01
>         0000000000000001 9000100092ff7b88 947d2f9216a5e8b9 900010008773d8=
80
>         00000000ffff8b9f fffffffffffffffe 0000000000000ba1 ffffffffffffff=
fe
>         000000000000003e 900000000825a15b 000010007ad38000 9000100092ff7e=
c0
>         0000000000000000 0000000000000000 9000000006f3ac60 90000000072520=
00
>         0000000000000000 00007ff746ff2230 0000000000000053 9000200088a021=
b0
>         0000555556c9d190 0000000000000000 9000000004c2827c 000055556cfb5f=
40
>         00000000000000b0 0000000000000007 0000000000000007 0000000000071c=
1d
> Call Trace:
> [<9000000004c2827c>] show_stack+0x5c/0x180
> [<9000000004c20fac>] dump_stack_lvl+0x94/0xe4
> [<9000000004c99c7c>] __might_resched+0x26c/0x290
> [<9000000004f68968>] __might_fault+0x20/0x88
> [<ffff800002311de0>] kvm_eiointc_regs_access.isra.0+0x88/0x380 [kvm]
> [<ffff8000022f8514>] kvm_device_ioctl+0x194/0x290 [kvm]
> [<900000000506b0d8>] sys_ioctl+0x388/0x1010
> [<90000000063ed210>] do_syscall+0xb0/0x2d8
> [<9000000004c25ef8>] handle_syscall+0xb8/0x158
>
> Fixes: 1ad7efa552fd5 ("LoongArch: KVM: Add EIOINTC user mode read and wri=
te functions")
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/intc/eiointc.c | 33 ++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 12 deletions(-)
>
> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/=
eiointc.c
> index 026b139dcff2..2fb5b9c6e8ad 100644
> --- a/arch/loongarch/kvm/intc/eiointc.c
> +++ b/arch/loongarch/kvm/intc/eiointc.c
> @@ -462,19 +462,17 @@ static int kvm_eiointc_ctrl_access(struct kvm_devic=
e *dev,
>
>  static int kvm_eiointc_regs_access(struct kvm_device *dev,
>                                         struct kvm_device_attr *attr,
> -                                       bool is_write)
> +                                       bool is_write, int *data)
>  {
>         int addr, cpu, offset, ret =3D 0;
>         unsigned long flags;
>         void *p =3D NULL;
> -       void __user *data;
>         struct loongarch_eiointc *s;
>
>         s =3D dev->kvm->arch.eiointc;
>         addr =3D attr->attr;
>         cpu =3D addr >> 16;
>         addr &=3D 0xffff;
> -       data =3D (void __user *)attr->addr;
>         switch (addr) {
>         case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
>                 offset =3D (addr - EIOINTC_NODETYPE_START) / 4;
> @@ -513,13 +511,10 @@ static int kvm_eiointc_regs_access(struct kvm_devic=
e *dev,
>         }
>
>         spin_lock_irqsave(&s->lock, flags);
> -       if (is_write) {
> -               if (copy_from_user(p, data, 4))
> -                       ret =3D -EFAULT;
> -       } else {
> -               if (copy_to_user(data, p, 4))
> -                       ret =3D -EFAULT;
> -       }
> +       if (is_write)
> +               memcpy(p, data, 4);
> +       else
> +               memcpy(data, p, 4);
p is a local variable, data is a parameter, they both have nothing to
do with s, why memcpy need to be protected?

After some thinking I found the code was wrong at the first time.  The
real code that needs to be protected is not copy_from_user() or
memcpy(), but the above switch block.

Other patches have similar problems.

Huacai

>         spin_unlock_irqrestore(&s->lock, flags);
>
>         return ret;
> @@ -576,9 +571,18 @@ static int kvm_eiointc_sw_status_access(struct kvm_d=
evice *dev,
>  static int kvm_eiointc_get_attr(struct kvm_device *dev,
>                                 struct kvm_device_attr *attr)
>  {
> +       int ret, data;
> +
>         switch (attr->group) {
>         case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
> -               return kvm_eiointc_regs_access(dev, attr, false);
> +               ret =3D kvm_eiointc_regs_access(dev, attr, false, &data);
> +               if (ret)
> +                       return ret;
> +
> +               if (copy_to_user((void __user *)attr->addr, &data, 4))
> +                       ret =3D -EFAULT;
> +
> +               return ret;
>         case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
>                 return kvm_eiointc_sw_status_access(dev, attr, false);
>         default:
> @@ -589,11 +593,16 @@ static int kvm_eiointc_get_attr(struct kvm_device *=
dev,
>  static int kvm_eiointc_set_attr(struct kvm_device *dev,
>                                 struct kvm_device_attr *attr)
>  {
> +       int data;
> +
>         switch (attr->group) {
>         case KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL:
>                 return kvm_eiointc_ctrl_access(dev, attr);
>         case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
> -               return kvm_eiointc_regs_access(dev, attr, true);
> +               if (copy_from_user(&data, (void __user *)attr->addr, 4))
> +                       return -EFAULT;
> +
> +               return kvm_eiointc_regs_access(dev, attr, true, &data);
>         case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
>                 return kvm_eiointc_sw_status_access(dev, attr, true);
>         default:
> --
> 2.39.3
>

