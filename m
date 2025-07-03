Return-Path: <kvm+bounces-51400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C21F1AF6F69
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:56:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17C831C81521
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 09:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBDBC2DCF68;
	Thu,  3 Jul 2025 09:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="p86i/b8J";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="iqDGoKzl"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F8D2E03FD;
	Thu,  3 Jul 2025 09:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751536586; cv=none; b=nzw39TkD/LIUqqbF6e/3x3v1/tC/o+A4fHbFGNpm2tZOAG77JFstiqH3ltFobVnUmDcfixz2JrsM/4aL67G9MDr3Zq7K7UdrB/vkXGVajvor/aWySXtF1wG1rtbRqfAQEIkPFW45NQfHst0tlIjT6UNdaho1EY15S4Q3dZvXN2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751536586; c=relaxed/simple;
	bh=qDLm4CgNLZPOYtYXEq9zAF6zy52XqGAELNE6mJ8vijg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UVHG8aVp80LTNpHE8UreNByt1IenADjJso0ZQ72ngPb4neIZGVSRUfYRikpKTU2NLPeu4OR5bn/z7kMrTYP19aGM46Kp+FLj6hMq631pGRqYPGEPcUACk/WmE/ditqs3KYoYvDcpokQBbYuwo+mmTs+CktJ0TSdwjtBkOCiQx9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=p86i/b8J; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=iqDGoKzl; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1751536582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=McVtbViVAKjtJayVZUeulSTCPeoSBRL44rxBPUG2jB8=;
	b=p86i/b8JUVbnwgdjsNfwmENRt/T+VGmjJhmhkljdHJXvR0sTYvxvMUtIMAWhk0HqR86opU
	V/7mrMfVSKi+JhOBdfZ2F8zsrtAIk+Uxq2cVtG8P+sHhJ4+n1lhS6Uvg9RHrvrTALii+eP
	bdgAfjxEORipzy76Ti3r0MEGqP2Y1jn7vviPr4jzWUAbzSM6PYf45eClIhLCz0fSvKbIrF
	ZXOJotGfsfFpE4xFufPgNzAdqSwuFlU6lY8f6d3DzRMf4kWJDDXauBN9dQCH/QKJAypuOQ
	rBa1aS8NfJRA67EENXnp3qZth6OlKkQkLZs18ngojlFLbcU06FjtwU5PSeIORw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1751536582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=McVtbViVAKjtJayVZUeulSTCPeoSBRL44rxBPUG2jB8=;
	b=iqDGoKzloeHZz6Nnx+UChibR0z94U5nMP8x6gDXEyVt2mfQvdrnoGSxCmyNAVRA+Gsx1MC
	4xnIBfXwsZgA9AAw==
To: =?utf-8?B?55m954OB5YaJ?= <baishuoran@hrbeu.edu.cn>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>
Cc: Kun Hu <huk23@m.fudan.edu.cn>, Jiaji Qin <jjtan24@m.fudan.edu.cn>,
 linux-kernel@vger.kernel.org, syzkaller@googlegroups.com,
 kvm@vger.kernel.org, Paolo Bonzini <bonzini@redhat.com>
Subject: Re: BUG: spinlock bad magic in lock_timer_base
In-Reply-To: <8d6bd3e.1228f.197cf7e7892.Coremail.baishuoran@hrbeu.edu.cn>
References: <8d6bd3e.1228f.197cf7e7892.Coremail.baishuoran@hrbeu.edu.cn>
Date: Thu, 03 Jul 2025 11:56:21 +0200
Message-ID: <87jz4pwqbe.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03 2025 at 16:54, =E7=99=BD=E7=83=81=E5=86=89 wrote:

> Dear Maintainers,

The timer maintainers are hardly the right group to ask. The timer code
is just the messenger :)

I've Cc'ed the KVM folks, as you correctly identified KVM already as the
probable source of the problem.

> When using our customized Syzkaller to fuzz the latest Linux kernel, the =
following crash (110th)was triggered.

6.14 is not really the latest kernel.

> HEAD commit: 6537cfb395f352782918d8ee7b7f10ba2cc3cbf2
> git tree: upstream
> Output:https://github.com/pghk13/Kernel-Bug/blob/main/0702_6.14/BUG%3A%20=
spinlock%20bad%20magic%20in%20lock_timer_base/report110.txt=20
> Kernel config:https://github.com/pghk13/Kernel-Bug/blob/main/0702_6.14/co=
nfig.txt
> C reproducer:https://github.com/pghk13/Kernel-Bug/blob/main/0702_6.14/BUG=
%3A%20spinlock%20bad%20magic%20in%20lock_timer_base/110repro.c Syzlang=20
> reproducer:https://github.com/pghk13/Kernel-Bug/blob/main/0702_6.14/BUG%3=
A%20spinlock%20bad%20magic%20in%20lock_timer_base/110repro.txt Our reproduc=
er uses mounts a constructed filesystem image.
>=20=20
> The error occurs in the lock_timer_base (timer.c lines 1770-1790 or
> so). It happens cleanup_srcu_struct during the KVM VM shutdown
> process, and it is likely that the memory pointed to by the timer
> object has been freed. The timer_base pointer returned by the
> get_timer_base (tf) points to an invalid memory area
> (__init_begin+0x2a500)

If you enable DEBUG_OBJECTS_TIMERS and DEBUG_OBJECTS_FREE the kernel
should survive and provide some useful output.

> We have reproduced this issue several times on 6.14 again.

Does the probkem still exist on the latest upstream kernel release
candidate, i.e. v6.16-rc4?

Leaving the report context intact for kvm folks.

Thanks,

        tglx
=20=20=20=20

> If you fix this issue, please add the following tag to the commit:
> Reported-by: Kun Hu <huk23@m.fudan.edu.cn>, Jiaji Qin <jjtan24@m.fudan.ed=
u.cn>, Shuoran Bai <baishuoran@hrbeu.edu.cn>
>
>
>
>
> BUG: spinlock bad magic on CPU#2, syz.6.399/18129
>  lock: __init_begin+0x2a500/0x41000, .magic: 00000000, .owner: <none>/-1,=
 .owner_cpu: 0
> CPU: 2 UID: 0 PID: 18129 Comm: syz.6.399 Not tainted 6.14.0 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubunt=
u1.1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x116/0x1b0
>  do_raw_spin_lock+0x22c/0x2e0
>  _raw_spin_lock_irqsave+0x45/0x60
>  lock_timer_base+0x125/0x1c0
>  __try_to_del_timer_sync+0x7f/0x160
>  __timer_delete_sync+0x120/0x1c0
>  cleanup_srcu_struct+0x122/0x5a0
>  kvm_put_kvm+0x7c9/0xa10
>  kvm_vcpu_release+0x4b/0x70
>  __fput+0x417/0xb60
>  __fput_sync+0xa6/0xc0
>  __x64_sys_close+0x8b/0x120
>  do_syscall_64+0xcf/0x250
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fafdad1ebdb
> Code: 03 00 00 00 0f 05 48 3d 00 f0 ff ff 77 41 c3 48 83 ec 18 89 7c 24 0=
c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 2f 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
> RSP: 002b:00007ffde8c95b20 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 00007fafdad1ebdb
> RDX: ffffffffffffffff RSI: 0000000000000000 RDI: 0000000000000005
> RBP: 00007ffde8c95bf8 R08: 0000000000000000 R09: 00007fafda8015a6
> R10: 0000000000000001 R11: 0000000000000293 R12: 00007fafdafa5fa0
> R13: 000000000002f3ea R14: ffffffffffffffff R15: 00007fafdafa5fa0
>  </TASK>

