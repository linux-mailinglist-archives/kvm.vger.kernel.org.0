Return-Path: <kvm+bounces-17595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 274818C85C3
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 13:38:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1B80285A4D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 11:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BDF03FBA2;
	Fri, 17 May 2024 11:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PB+XpWWP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3013FB99
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 11:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715945868; cv=none; b=Omwst/8R9tvsNV5TyLf2gM6qlFBeDz5YmnF4ENldAeYzmYc8U+IeQ+R4NEwGVMLh6Qk8IeN8DhckzxwVB0oFE59BuSWgpYbNYIX8JcnJHadmQ1tGyI6heJ9TRAhBSUA9acWYqx+sP8RQOyOFFEeC1iWdjNLc8pZ/HAhw2baUqPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715945868; c=relaxed/simple;
	bh=HEtnw/BdphLBpo4OrRSdV8cFrcIENB5/mmOVrVtHhvY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BojYQRy3LENEOEs7oWhLIx6wkYXSz4xY3bvY8GKUVMexH63khe7CDUdtMi3o29dCDNgydbrPcpHDZsx9OWm4qFBtc2BvR5Kz+cOofM72aFi6XqRErgbyGxWiP1j60ZctX6LNiRyxIvo+HjYlQo945JDgr3ZBpKjwEPdFha2xrd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PB+XpWWP; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-56e1baf0380so4939388a12.3
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 04:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715945865; x=1716550665; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0oJmMoyMkTFCwpF5hU4ad9sTUj7YaaTAGe4oCeqI0Rs=;
        b=PB+XpWWPByVjmy+Qh+9fyJoFeC1AxTJUMOjAolaE1vGC/YD/UxQMiQ5TiRBNsvgNc3
         vjLrHXvI7QE4qWcummoYMobrxbW6NTDq1MBlwbFEONgW03ROE23wE5SCqOgo3aGFV5vR
         E3Du9DmmCnvJ15k9+O9WraBZYI3WQsScV0tDpZEcqYPaVC5ocsBcvDJALgedvjCS99R3
         kDz4QLZB/Thts59+MNajTNr7D8OwrFVRhQVvTwIVf874UxVg7sAVQhkfHmXUXqp4UEi9
         Fnctlcm1o/5Y1jsEjS1PG+b8yten+QY8/f1dKCy8h8R+HSmzuIXX45Qqh/3sBuUXln8z
         /WEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715945865; x=1716550665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0oJmMoyMkTFCwpF5hU4ad9sTUj7YaaTAGe4oCeqI0Rs=;
        b=fV6XQJY9qqmG/5k1SsWXanhr4eUxpwXSEPSAqC40w5LMqM+jgApVDB4ZjjzxpISyYR
         6r9syKpByRi+S5k00TN/ow7/FDAvHWnnKrH41nxpk888MSktsPNbbhdV8ZlPwRwMl/BG
         VldTPXQRLJv9KiFvt/3Xw9y1bJ9fY8a1C6+zUtX3XbuXGDrLFlua8Q0hLS2ooJVPDt7H
         qU33MXOEAgs8Nxa6NACjYxuoLHV6NCunrS7Z6doO9bsxrN+Nxq8kN/BuNSAWXZkv6etT
         Mhf0Ji/VVaXRSdotKjjx0B67PVD2NcHGcyogJOVcnPws0B0vB36/3PC6/zal4ZRvuNEW
         yVGw==
X-Forwarded-Encrypted: i=1; AJvYcCVfnE72LI/2c3MhsKuRlnD54DMW1d3vU6Gg6xseG9MuBioEQHt3ZpLPLIYZ49G/5NvQDZdplR2WxdxyajDj70QmnmEV
X-Gm-Message-State: AOJu0YxxivlzD32qqpUsm6oCdEtrUHI1VV8VV389TudF+KXNkXgUCWkZ
	QfbKGs7S8GdX/UP3wYPwRvULoFMRqtNoYrUsyWE0vXB0QMDbaimiuP+MZmT+kpvyBhF+IjkQiQQ
	8xFDa/yk4Ckpng+qzCpiZcqBZEew=
X-Google-Smtp-Source: AGHT+IE34jS7FcgMEKNkiMOXym1oMM33XvbvRugz8OlAnKVAQVwXde37z4N0qJOkyEc/XxwTKg1HzQh0JVUsu9p9D0I=
X-Received: by 2002:a50:aa91:0:b0:56e:34e0:4699 with SMTP id
 4fb4d7f45d1cf-5734d67eb8bmr15513844a12.30.1715945864766; Fri, 17 May 2024
 04:37:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240515080607.919497-1-liangchen.linux@gmail.com> <82c8c53b-56e8-45af-902a-a6b908e5a8b3@redhat.com>
In-Reply-To: <82c8c53b-56e8-45af-902a-a6b908e5a8b3@redhat.com>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Fri, 17 May 2024 19:37:32 +0800
Message-ID: <CAKhg4t+=vMTaAfbetNZXfgUBiVZYo-tJK-BPX7RbL5kYJrFt=A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Prevent L0 VMM from modifying L2 VM registers
 via ioctl
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, 
	syzbot+988d9efcdf137bc05f66@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2024 at 7:08=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On 5/15/24 10:06, Liang Chen wrote:
> > In a nested VM environment, a vCPU can run either an L1 or L2 VM. If th=
e
> > L0 VMM tries to configure L1 VM registers via the KVM_SET_REGS ioctl wh=
ile
> > the vCPU is running an L2 VM, it may inadvertently modify the L2 VM's
> > registers, corrupting the L2 VM. To avoid this error, registers should =
be
> > treated as read-only when the vCPU is actively running an L2 VM.
>
> No, this is intentional.  The L0 hypervisor has full control on the CPU
> registers, no matter if the VM is in guest mode or not.
>

I see. Thank you! The patch [1] will provide a convenient way for
userspace to determine if the CPU is in guest mode, which should be
sufficient for userspace to avoid mistakenly setting L2 registers.

[1] https://lore.kernel.org/kvm/20240508132502.184428-1-julian.stecklina@cy=
berus-technology.de/T/#u

> Looking at the syzkaller report, the first thing to do is to remove the
> threading, because vcpu ioctls are anyway serialized by the vcpu mutex.
>
> Let's assume that the first 7 operations, i.e. all except KVM_RUN and
> KVM_SET_REGS, execute in sequence.  There is possible interleaving of
> the two syz_kvm_setup_cpu$x86 calls, but because only the second sets
> up nested virtualization, we can hope that we're lucky.[1]
>
> To do so, change the main to something like
>
> int main(int argc, char **argv)
> {
>    int i;
>    syscall(__NR_mmap, /*addr=3D*/0x1ffff000ul, /*len=3D*/0x1000ul, /*prot=
=3D*/0ul,
>            /*flags=3DMAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul, /*fd=
=3D*/-1,
>            /*offset=3D*/0ul);
>    syscall(__NR_mmap, /*addr=3D*/0x20000000ul, /*len=3D*/0x1000000ul,
>            /*prot=3DPROT_WRITE|PROT_READ|PROT_EXEC*/ 7ul,
>            /*flags=3DMAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul, /*fd=
=3D*/-1,
>            /*offset=3D*/0ul);
>    syscall(__NR_mmap, /*addr=3D*/0x21000000ul, /*len=3D*/0x1000ul, /*prot=
=3D*/0ul,
>            /*flags=3DMAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul, /*fd=
=3D*/-1,
>            /*offset=3D*/0ul);
>
>    // r0 =3D openat$kvm(0xffffffffffffff9c, &(0x7f0000000440), 0x0, 0x0)
>    execute_call(0);
>    // r1 =3D ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
>    execute_call(1);
>    // r2 =3D ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x0)
>    execute_call(2);
>    // mmap(&(0x7f0000000000/0x3000)=3Dnil, 0x3000, 0x2, 0x13, r2, 0x0)
>    execute_call(3);
>    // syz_kvm_setup_cpu$x86(r1, 0xffffffffffffffff, &(0x7f0000fe7000/0x18=
000)=3Dnil, &(0x7f0000000200)=3D[@text16=3D{0x10, 0x0}], 0x1, 0x0, 0x0, 0x0=
)
>    execute_call(4);
>    // ioctl$KVM_REGISTER_COALESCED_MMIO(0xffffffffffffffff, 0x4010ae67, &=
(0x7f0000000000)=3D{0x2})
>    execute_call(5);
>    // syz_kvm_setup_cpu$x86(0xffffffffffffffff, r2, &(0x7f0000fe7000/0x18=
000)=3Dnil, &(0x7f0000000340)=3D[@text64=3D{0x40, 0x0}], 0x1, 0x50, 0x0, 0x=
0)
>    execute_call(6);
>    // ioctl$KVM_RUN(r2, 0xae80, 0x0) (rerun: 64)
>    for (i =3D 0; i < atoi(argv[1]); i++)
>      execute_call(7);
>    // ioctl$KVM_SET_REGS(r2, 0x4090ae82, &(0x7f00000000c0)=3D{[0x7], 0x0,=
 0x60000})
>    // interleaved with KVM_RUN
>    execute_call(8);
>    // one more KVM_RUN to show the bug
>    execute_call(7);
>    return 0;
> }
>
> This reproduces the fact that KVM_SET_REGS can sneak in between any
> two KVM_RUN.  You'll see that changing the argument may cause an entry wi=
th
> invalid guest state (argument is 0 or >=3D 3 - that's ok) or the WARN
> (argument =3D=3D 1).
>
> The attached cleaned up reproducer shows that the problem is simply that
> EFLAGS.VM is set in 64-bit mode.  To fix it, it should be enough to do
> a nested_vmx_vmexit(vcpu, EXIT_REASON_TRIPLE_FAULT, 0, 0); just like
> a few lines below.
>

Yes, that was the situation we were trying to deal with. However, I am
not quite sure if I fully understand the suggestion, "To fix it, it
should be enough to do a nested_vmx_vmexit(vcpu,
EXIT_REASON_TRIPLE_FAULT, 0, 0); just like a few lines below.". From
what I see, "(vmx->nested.nested_run_pending, vcpu->kvm) =3D=3D true" in
__vmx_handle_exit can be a result of an invalid VMCS12 from L1 that
somehow escaped checking when trapped into L0 in nested_vmx_run. It is
not convenient to tell whether it was a result of userspace
register_set ops, as we are discussing, or an invalid VMCS12 supplied
by L1. Additionally, nested_vmx_vmexit warns when
'vmx->nested.nested_run_pending is true,' saying that "trying to
cancel vmlaunch/vmresume is a bug".

Thanks,
Liang

> Paolo
>
> [1] in fact the first syz_kvm_setup_cpu$v86 passes vcpufd=3D=3D-1 and
> the second passes vmfd=3D=3D-1.  Each of them does only half of the work.
> The ioctl$KVM_REGISTER_COALESCED_MMIO is also mostly dummy because it
> passes -1 as the file descriptor, but it happens to set
> vcpu->run->request_interrupt_window!  Which is important later.
>
>
> > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> > Reported-by: syzbot+988d9efcdf137bc05f66@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/0000000000007a9acb06151e1670@google=
.com
> > ---
> >   arch/x86/kvm/x86.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 91478b769af0..30f63a7dd120 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11527,6 +11527,12 @@ static void __set_regs(struct kvm_vcpu *vcpu, =
struct kvm_regs *regs)
> >
> >   int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_re=
gs *regs)
> >   {
> > +     /*
> > +      * Prevent L0 VMM from inadvertently modifying L2 VM registers di=
rectly.
> > +      */
> > +     if (is_guest_mode(vcpu))
> > +             return -EACCES;
> > +
> >       vcpu_load(vcpu);
> >       __set_regs(vcpu, regs);
> >       vcpu_put(vcpu);

