Return-Path: <kvm+bounces-41636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C7E6A6B1CE
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 00:48:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B6377B3C37
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6192922CBE8;
	Thu, 20 Mar 2025 23:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="j6iccm/B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60E822B8D0
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 23:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742514261; cv=none; b=ZKVACSvaWXCzzbIpz9rt0aU0AYJVI+ETo0NX/NvdJgHVTdmGvf+rnWdNrylHf3S/MCFqEf3W6lBffM2Md/pZSraRSx/HtQmB8hSqoFzH2L7Has2enyymnIoUJYj8EFBJsRQOQmh+K0Ew/S08pLpfWLDWUpo2RnCljMS/GEkoqrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742514261; c=relaxed/simple;
	bh=J7aAh5AR1kzWqeBM6kAqTkZ3MI/BnDmNbKrsdudZgWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZSrZ5/KTkOwJjfX8s4TOngzOie0hr6Szvqi21rlqbuKXMTxAu1YliR7HO3LnNLXe+0E8Pk3Mf4ZZMXOCCj+px/B9LktoNSBlOUQdFoZK0gZEPCMdbBvPpd1fqJzEys7+HkBa8r7lHVBNjWTmP8jInvBpdTa3CcDz3aFQSx55J6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=j6iccm/B; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3011737dda0so1855662a91.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 16:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742514257; x=1743119057; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sx9RFbFhV18UVxcJVn2E8kE6xVU3d+kjpx4dubf4KQY=;
        b=j6iccm/BIVapr3vzZH/+V/2eelwmQZuI2IE3ubPWPlxs+e2L6Mr6BBBVW/0lzS3+hT
         xfkkOxjERj4TbLF0uxX968SEbZGhKDo4EHNvpYMrbOCQ6TjXsyG4I0rOSggDk4h9W+LS
         l+BJ0tdjwYsCvu5GQkdlBeza4LuWVHnqOTPPSgupvYru1AuHErQmrgx0cFlwNCOodV7l
         7rLk8vOdAnux7x7lph8mSiZt+nSRUQcBVSd6tzwLXYS/rLkgBXbRK02TmONmTK1mwRvs
         EIJTXchJoi4w8yxUWRYYSZ/KYllmPRJyhoItIVY9R18Bk+bq9rH3Gb2BT3+PLaMjYTYY
         l2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742514257; x=1743119057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sx9RFbFhV18UVxcJVn2E8kE6xVU3d+kjpx4dubf4KQY=;
        b=L1wIDGb7sY3GVUjOVuvHgbnwxK8Nmr6DBzWQVKWAzdpHDi3h2/gu9WleWbyDV9tJQx
         qD8ugbcNWgMS0giqhrV4wrR0Mu4M8C+gZMLZ2iMFUrTl89FlkdKR9x9YxYbnfQoK2Mky
         j4DWxzyt4s8bsODvmzyKX2czKtJqxBzZxZe6/1XUVmns0c8owixYRcc6jUC2ULnTLc1G
         DeFscnquLfNfjX5sjTL3SMuqE6y+JH1X+kDuwU/Gew2UvVvDSoEgQds7iABSYYbnLtfl
         gzRpU5OpozXHVz4EeBm/uR89sPUVqM2UIByYIO0D001GEQfZuUaA14lVfAE/+9hfSeXE
         OlJg==
X-Forwarded-Encrypted: i=1; AJvYcCUIwvxlRssgHil1sTdPsnNLAeE2EBaIsTGXbj0KO8n6p/yEqL4i7e6yT+EJ7wKp9s7hX6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/VqxDJv5daTWTVOuRa8Zoq6J0HmTbQ4w5y9Kv5G0/5vlr0mH5
	6A54thcPRP1Vz/VxhMwrrhxAD0EaBFZKHa/34qwO63nUA2DoYIBZSu1aL3TNfFiWfWcfGZgaFb8
	/Si/zUGOeptBob+ZBknwXiqnNf9UBskxsFNT+eg==
X-Gm-Gg: ASbGnct3KrwS1+tTPV4HUIWc1B/YD/f+q4gdF1KeD3ynjXEBZrwuZdD4FtsWdFUkzVq
	WEo2iQAMzWAzkJbfXlJcgPfRV4sb4oZehMAeqI5mgIR1ablz+Jkk02ZTFMw8kCvD3GCMp6MGjf+
	EH8BJZXKLKUDOEYQh3dob4hhPS
X-Google-Smtp-Source: AGHT+IHZLYL66qJW18COX6JZ7o2M448VXcpFC9tv/3ygvfrm/plvo7x5Xd4P6IHJW/2EPCNgKPKtCGWglcvBlvp8pYg=
X-Received: by 2002:a17:90b:28c4:b0:2fe:a742:51b0 with SMTP id
 98e67ed59e1d1-3031002af0fmr1663139a91.31.1742514256837; Thu, 20 Mar 2025
 16:44:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317-kvm_exit_fix-v1-1-aa5240c5dbd2@rivosinc.com> <Z9hI5vEHngcKvvRa@google.com>
In-Reply-To: <Z9hI5vEHngcKvvRa@google.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Thu, 20 Mar 2025 16:44:05 -0700
X-Gm-Features: AQ5f1JqRewenHnUHTLoLyUK3jy666k2pQWgIEFEkTaIpT0EXNn1CrZi3jTO1WxM
Message-ID: <CAHBxVyFLeZFwEnJYa-oUbAKVimdVsr=Ct76Jf=TyWeoAkHe8yQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Teardown riscv specific bits after kvm_exit
To: Sean Christopherson <seanjc@google.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <apatel@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 17, 2025 at 9:08=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Mar 17, 2025, Atish Patra wrote:
> > During a module removal, kvm_exit invokes arch specific disable
> > call which disables AIA. However, we invoke aia_exit before kvm_exit
> > resulting in the following warning. KVM kernel module can't be inserted
> > afterwards due to inconsistent state of IRQ.
> >
> > [25469.031389] percpu IRQ 31 still enabled on CPU0!
> > [25469.031732] WARNING: CPU: 3 PID: 943 at kernel/irq/manage.c:2476 __f=
ree_percpu_irq+0xa2/0x150
> > [25469.031804] Modules linked in: kvm(-)
> > [25469.031848] CPU: 3 UID: 0 PID: 943 Comm: rmmod Not tainted 6.14.0-rc=
5-06947-g91c763118f47-dirty #2
> > [25469.031905] Hardware name: riscv-virtio,qemu (DT)
> > [25469.031928] epc : __free_percpu_irq+0xa2/0x150
> > [25469.031976]  ra : __free_percpu_irq+0xa2/0x150
> > [25469.032197] epc : ffffffff8007db1e ra : ffffffff8007db1e sp : ff2000=
000088bd50
> > [25469.032241]  gp : ffffffff8131cef8 tp : ff60000080b96400 t0 : ff2000=
000088baf8
> > [25469.032285]  t1 : fffffffffffffffc t2 : 5249207570637265 s0 : ff2000=
000088bd90
> > [25469.032329]  s1 : ff60000098b21080 a0 : 037d527a15eb4f00 a1 : 037d52=
7a15eb4f00
> > [25469.032372]  a2 : 0000000000000023 a3 : 0000000000000001 a4 : ffffff=
ff8122dbf8
> > [25469.032410]  a5 : 0000000000000fff a6 : 0000000000000000 a7 : ffffff=
ff8122dc10
> > [25469.032448]  s2 : ff60000080c22eb0 s3 : 0000000200000022 s4 : 000000=
000000001f
> > [25469.032488]  s5 : ff60000080c22e00 s6 : ffffffff80c351c0 s7 : 000000=
0000000000
> > [25469.032582]  s8 : 0000000000000003 s9 : 000055556b7fb490 s10: 00007f=
fff0e12fa0
> > [25469.032621]  s11: 00007ffff0e13e9a t3 : ffffffff81354ac7 t4 : ffffff=
ff81354ac7
> > [25469.032664]  t5 : ffffffff81354ac8 t6 : ffffffff81354ac7
> > [25469.032698] status: 0000000200000100 badaddr: ffffffff8007db1e cause=
: 0000000000000003
> > [25469.032738] [<ffffffff8007db1e>] __free_percpu_irq+0xa2/0x150
> > [25469.032797] [<ffffffff8007dbfc>] free_percpu_irq+0x30/0x5e
> > [25469.032856] [<ffffffff013a57dc>] kvm_riscv_aia_exit+0x40/0x42 [kvm]
> > [25469.033947] [<ffffffff013b4e82>] cleanup_module+0x10/0x32 [kvm]
> > [25469.035300] [<ffffffff8009b150>] __riscv_sys_delete_module+0x18e/0x1=
fc
> > [25469.035374] [<ffffffff8000c1ca>] syscall_handler+0x3a/0x46
> > [25469.035456] [<ffffffff809ec9a4>] do_trap_ecall_u+0x72/0x134
> > [25469.035536] [<ffffffff809f5e18>] handle_exception+0x148/0x156
> >
> > Invoke aia_exit and other arch specific cleanup functions after kvm_exi=
t
> > so that disable gets a chance to be called first before exit.
> >
> > Fixes: 54e43320c2ba ("RISC-V: KVM: Initial skeletal support for AIA")
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
>
> FWIW,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>
> >  arch/riscv/kvm/main.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> > index 1fa8be5ee509..4b24705dc63a 100644
> > --- a/arch/riscv/kvm/main.c
> > +++ b/arch/riscv/kvm/main.c
> > @@ -172,8 +172,8 @@ module_init(riscv_kvm_init);
> >
> >  static void __exit riscv_kvm_exit(void)
> >  {
> > -     kvm_riscv_teardown();
> > -
> >       kvm_exit();
> > +
> > +     kvm_riscv_teardown();
>
> I wonder if there's a way we can guard against kvm_init()/kvm_exit() bein=
g called
> too early/late.  x86 had similar bugs for a very long time, e.g. see comm=
it
> e32b120071ea ("KVM: VMX: Do _all_ initialization before exposing /dev/kvm=
 to userspace").
>
> E.g. maybe we do something like create+destroy a VM at the end of kvm_ini=
t() and
> the beginning of kvm_exit()?  Not sure if that would work for kvm_exit(),=
 but it
> should definitely be fine for kvm_init().
>
Yes. That would be super useful. I am not sure about the exact
mechanism to achieve that though.
Do you just test code guarded within a new config that just
creates/destroys a dummy VM ?

May be kunit test for KVM fits here in some way ?

> It wouldn't prevent bugs, but maybe it would help detect them during deve=
lopment?

