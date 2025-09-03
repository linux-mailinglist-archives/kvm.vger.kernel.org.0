Return-Path: <kvm+bounces-56677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E4CFB418A4
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 10:35:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6A68202072
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 08:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA982E7BAC;
	Wed,  3 Sep 2025 08:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k1YarMPD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD9D2D77E8;
	Wed,  3 Sep 2025 08:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756888503; cv=none; b=eH/pA5OcYnnTTnTPfamDQN3bOGUl0GrzlMQ4fWrUbaa9j6Gh3C9+r1YqlyYBcA06NQ5Ehfpw3Fy+ufb7BfY4GlBT4XBfCJpdPvamZNgH/Bxi64PEtI9BwcFNPV2JGnd+nskw4pwyVztPB3014cPJxylZcYH9d6vN6QBwxjh7Up8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756888503; c=relaxed/simple;
	bh=XteDl1zVOiXjiYPnlWq9OETDQUuk0IaURRSG0BN6xCc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pur8j6+026v4EpnoblkbaBrst5RkSYPwqhVHARxulexa46ky/sMZVnJW6U/SULgcZqgBVGn1YPA1eNHK0Ta6e0mrynx9icDBWhimlzuopbFdoTJygrgUwwgHQuh3NR1wakCGOt1dhKagNVRTmD4pIi//Ov96EmVXnepzSOBxFkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k1YarMPD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C324CC4AF09;
	Wed,  3 Sep 2025 08:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756888502;
	bh=XteDl1zVOiXjiYPnlWq9OETDQUuk0IaURRSG0BN6xCc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=k1YarMPDAy9bCTZ00cOms9emBK/b4XjR0Mv/zmmrz1GTP0m1fxiPBhueLPHrXVulR
	 4n+ABFZSyQpcFVklByuOWfp8lEQdGKpRdHbaNyN9f0gk1nNncYWTGqocm3F2U5mT3p
	 iUfpHJ03MIRyiI8210lwRjOcuoIc+OLGO8sIHJ8tHRPsfw1oKEaAd5BDUyQ/XB0J88
	 6U8031ebK/Fa/nI6MUODMIEbSmZKszmZzNSPjCGPLRZcaTOdb+24fqotTl+e+2nLl7
	 ifTXjz8uf4zo/nG+Z223XMWJRnJOsnb8iTM6HlzGnUckaCRe41YGuD+9nVikSMgI/n
	 kT1yO9ndaY1JA==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-afcb7322da8so1235560466b.0;
        Wed, 03 Sep 2025 01:35:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU4OAR7a3AoNMoJQ43mQ+7VkaIEUdaH+CiJkJQWsygbOH4w0Ared8lqnFslEmBH5E9L9CpS9k2TU3HdDs+f@vger.kernel.org, AJvYcCVcnHc/ZfkW2quR/UV2ymtmtxbKZRDvvyeP36Ng+TBMtig3hZgG15PpFe5McdXox5do5fw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjzXzCHaheMR7zZ2t9dDe1h1J3DgMKRrY0iIpwyny8DI0+CYrp
	zvokCrxg5cgjhYMnUrnry2VJ+9O7IOnvv3+Z17F0+WJexvhhxX4Oq2JL4uRw4UtA/DCy2ymU02S
	4aILNL6ul9jie7b0JwjJL5U5vnFqExZ4=
X-Google-Smtp-Source: AGHT+IHhahnriqlWrEhFY3gRtNpn7SkQXo+SfUCEWZEGctQT2mk4bMxN1v1M0J7nYTuZC9fx1t30XrBi027CeDgomIQ=
X-Received: by 2002:a17:906:8419:b0:b03:d5ca:b14 with SMTP id
 a640c23a62f3a-b03d5d95212mr1132351366b.61.1756888501258; Wed, 03 Sep 2025
 01:35:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902094945.2957566-1-maobibo@loongson.cn> <20250902094945.2957566-2-maobibo@loongson.cn>
 <CAAhV-H7hCggw_zhQk89uvBrpAPxgHCS_BC5+twsyZdwWkF4A1g@mail.gmail.com> <4eb3fffa-8330-ad54-8cbc-2cabf6355c74@loongson.cn>
In-Reply-To: <4eb3fffa-8330-ad54-8cbc-2cabf6355c74@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 3 Sep 2025 16:34:49 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7iETpPUqVYoOXDNX53BMx1AQAtDD12VXw8GD=H1YSZpQ@mail.gmail.com>
X-Gm-Features: Ac12FXw9M9lorOI8LrsWDRpsZqImjLuXNJEoG_l4AlYbpf_202JURW-JHAtGJUI
Message-ID: <CAAhV-H7iETpPUqVYoOXDNX53BMx1AQAtDD12VXw8GD=H1YSZpQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] LoongArch: KVM: Avoid use copy_from_user with lock
 hold in kvm_eiointc_regs_access
To: Bibo Mao <maobibo@loongson.cn>
Cc: Xianglai Li <lixianglai@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 2, 2025 at 8:17=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2025/9/2 =E4=B8=8B=E5=8D=887:58, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Tue, Sep 2, 2025 at 5:49=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> w=
rote:
> >>
> >> Function copy_from_user() and copy_to_user() may sleep because of page
> >> fault, and they cannot be called in spin_lock hold context. Otherwise =
there
> >> will be possible warning such as:
> >>
> >> BUG: sleeping function called from invalid context at include/linux/ua=
ccess.h:192
> >> in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 6292, name: qem=
u-system-loo
> >> preempt_count: 1, expected: 0
> >> RCU nest depth: 0, expected: 0
> >> INFO: lockdep is turned off.
> >> irq event stamp: 0
> >> hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> >> hardirqs last disabled at (0): [<9000000004c4a554>] copy_process+0x90c=
/0x1d40
> >> softirqs last  enabled at (0): [<9000000004c4a554>] copy_process+0x90c=
/0x1d40
> >> softirqs last disabled at (0): [<0000000000000000>] 0x0
> >> CPU: 41 UID: 0 PID: 6292 Comm: qemu-system-loo Tainted: G W 6.17.0-rc3=
+ #31 PREEMPT(full)
> >> Tainted: [W]=3DWARN
> >> Stack : 0000000000000076 0000000000000000 9000000004c28264 9000100092f=
f4000
> >>          9000100092ff7b80 9000100092ff7b88 0000000000000000 9000100092=
ff7cc8
> >>          9000100092ff7cc0 9000100092ff7cc0 9000100092ff7a00 0000000000=
000001
> >>          0000000000000001 9000100092ff7b88 947d2f9216a5e8b9 9000100087=
73d880
> >>          00000000ffff8b9f fffffffffffffffe 0000000000000ba1 ffffffffff=
fffffe
> >>          000000000000003e 900000000825a15b 000010007ad38000 9000100092=
ff7ec0
> >>          0000000000000000 0000000000000000 9000000006f3ac60 9000000007=
252000
> >>          0000000000000000 00007ff746ff2230 0000000000000053 9000200088=
a021b0
> >>          0000555556c9d190 0000000000000000 9000000004c2827c 000055556c=
fb5f40
> >>          00000000000000b0 0000000000000007 0000000000000007 0000000000=
071c1d
> >> Call Trace:
> >> [<9000000004c2827c>] show_stack+0x5c/0x180
> >> [<9000000004c20fac>] dump_stack_lvl+0x94/0xe4
> >> [<9000000004c99c7c>] __might_resched+0x26c/0x290
> >> [<9000000004f68968>] __might_fault+0x20/0x88
> >> [<ffff800002311de0>] kvm_eiointc_regs_access.isra.0+0x88/0x380 [kvm]
> >> [<ffff8000022f8514>] kvm_device_ioctl+0x194/0x290 [kvm]
> >> [<900000000506b0d8>] sys_ioctl+0x388/0x1010
> >> [<90000000063ed210>] do_syscall+0xb0/0x2d8
> >> [<9000000004c25ef8>] handle_syscall+0xb8/0x158
> >>
> >> Fixes: 1ad7efa552fd5 ("LoongArch: KVM: Add EIOINTC user mode read and =
write functions")
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/kvm/intc/eiointc.c | 33 ++++++++++++++++++++---------=
--
> >>   1 file changed, 21 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/in=
tc/eiointc.c
> >> index 026b139dcff2..2fb5b9c6e8ad 100644
> >> --- a/arch/loongarch/kvm/intc/eiointc.c
> >> +++ b/arch/loongarch/kvm/intc/eiointc.c
> >> @@ -462,19 +462,17 @@ static int kvm_eiointc_ctrl_access(struct kvm_de=
vice *dev,
> >>
> >>   static int kvm_eiointc_regs_access(struct kvm_device *dev,
> >>                                          struct kvm_device_attr *attr,
> >> -                                       bool is_write)
> >> +                                       bool is_write, int *data)
> >>   {
> >>          int addr, cpu, offset, ret =3D 0;
> >>          unsigned long flags;
> >>          void *p =3D NULL;
> >> -       void __user *data;
> >>          struct loongarch_eiointc *s;
> >>
> >>          s =3D dev->kvm->arch.eiointc;
> >>          addr =3D attr->attr;
> >>          cpu =3D addr >> 16;
> >>          addr &=3D 0xffff;
> >> -       data =3D (void __user *)attr->addr;
> >>          switch (addr) {
> >>          case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
> >>                  offset =3D (addr - EIOINTC_NODETYPE_START) / 4;
> >> @@ -513,13 +511,10 @@ static int kvm_eiointc_regs_access(struct kvm_de=
vice *dev,
> >>          }
> >>
> >>          spin_lock_irqsave(&s->lock, flags);
> >> -       if (is_write) {
> >> -               if (copy_from_user(p, data, 4))
> >> -                       ret =3D -EFAULT;
> >> -       } else {
> >> -               if (copy_to_user(data, p, 4))
> >> -                       ret =3D -EFAULT;
> >> -       }
> >> +       if (is_write)
> >> +               memcpy(p, data, 4);
> >> +       else
> >> +               memcpy(data, p, 4);
> > p is a local variable, data is a parameter, they both have nothing to
> > do with s, why memcpy need to be protected?
> p is pointer to register buffer rather than local variable. When dump
> extioi register to user space, maybe one vCPU is writing extioi register
> at the same time, so there needs spinlock protection.
Make sense, applied.

Huacai

>
> >
> > After some thinking I found the code was wrong at the first time.  The
> > real code that needs to be protected is not copy_from_user() or
> > memcpy(), but the above switch block.
> For switch block in function kvm_eiointc_regs_access() for example, it
> is only to get register buffer pointer, not register content. Spinlock
> protection is not necessary in switch block.
>
> Regards
> Bibo Mao
> >
> > Other patches have similar problems.
> >
> > Huacai
> >
> >>          spin_unlock_irqrestore(&s->lock, flags);
> >>
> >>          return ret;
> >> @@ -576,9 +571,18 @@ static int kvm_eiointc_sw_status_access(struct kv=
m_device *dev,
> >>   static int kvm_eiointc_get_attr(struct kvm_device *dev,
> >>                                  struct kvm_device_attr *attr)
> >>   {
> >> +       int ret, data;
> >> +
> >>          switch (attr->group) {
> >>          case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
> >> -               return kvm_eiointc_regs_access(dev, attr, false);
> >> +               ret =3D kvm_eiointc_regs_access(dev, attr, false, &dat=
a);
> >> +               if (ret)
> >> +                       return ret;
> >> +
> >> +               if (copy_to_user((void __user *)attr->addr, &data, 4))
> >> +                       ret =3D -EFAULT;
> >> +
> >> +               return ret;
> >>          case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
> >>                  return kvm_eiointc_sw_status_access(dev, attr, false)=
;
> >>          default:
> >> @@ -589,11 +593,16 @@ static int kvm_eiointc_get_attr(struct kvm_devic=
e *dev,
> >>   static int kvm_eiointc_set_attr(struct kvm_device *dev,
> >>                                  struct kvm_device_attr *attr)
> >>   {
> >> +       int data;
> >> +
> >>          switch (attr->group) {
> >>          case KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL:
> >>                  return kvm_eiointc_ctrl_access(dev, attr);
> >>          case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
> >> -               return kvm_eiointc_regs_access(dev, attr, true);
> >> +               if (copy_from_user(&data, (void __user *)attr->addr, 4=
))
> >> +                       return -EFAULT;
> >> +
> >> +               return kvm_eiointc_regs_access(dev, attr, true, &data)=
;
> >>          case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
> >>                  return kvm_eiointc_sw_status_access(dev, attr, true);
> >>          default:
> >> --
> >> 2.39.3
> >>
>
>

