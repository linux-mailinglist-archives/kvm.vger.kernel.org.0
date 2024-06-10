Return-Path: <kvm+bounces-19266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8659902BB9
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 00:33:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6133E1F229DE
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 22:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045C377107;
	Mon, 10 Jun 2024 22:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Px3Jzu4o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DD9770F6
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 22:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718058828; cv=none; b=AY0A72LdzfCPLAK369dUJB/bqL3zWqZXj038QMWfBS/gt5pWq+jlEKJHSjrqZHpSIMu+Fo9QrTliWaWKtbaBOg2YvntApo9RhGPB08l86p3JzYc5H5kTy91SPZjN3gGh1TpyWd1Fdi+A9K66+f/gRKO2IA8ucykX9t6s4rxeLDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718058828; c=relaxed/simple;
	bh=StWthvCB4BWxmd4dRGMLU9X00xEfwcSw8x1oBCp/b5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EUlzDYCViKcjb1xsSKFfYtGwMLbYLckUm+Jvo+7VtSl+Mj2amRqctEp/yr7WuO6jNbi6kP+1isVu/RrqtQ7pdQvD3wvE0eiEXJryU19iXgt62PH0Np9VLbJ7/l5BMRz0DqdfnZa0oj6Bj7IkEsYdHe1JB3NlrEQLgu9TnHpflMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Px3Jzu4o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718058825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q9TFdXKjxmBDmUtAvwNpPufPPKk1ACaOTKSpv7Hr7Go=;
	b=Px3Jzu4octdy2S0xzgaWQx7Rj7QK215k9NSHSumUpdDmDbV6OGlzlutXGznSUJvuy/f7xT
	ZtFr4b8V0+KT3yaOiXGnawRlQIVK42dB/2O1snkfYQIq8M1VTjoh1oL1f91nvPxOB1XAOH
	+LAvEc7qVkzRd/JyXd5mrLG8L20phVo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-4CpgA_bEPpite-6_UiZt3Q-1; Mon, 10 Jun 2024 18:33:43 -0400
X-MC-Unique: 4CpgA_bEPpite-6_UiZt3Q-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-35f06558bc3so437592f8f.1
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 15:33:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718058822; x=1718663622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q9TFdXKjxmBDmUtAvwNpPufPPKk1ACaOTKSpv7Hr7Go=;
        b=Uad5tPum+epNkiX+a06VM5tfOXabonJzNlyR0OPkOnBCCP3D5+51d70RMSwWPXTWC1
         vxqIszzyWuj5L+dqbqwMb+kiCjlX813JyNqJavRsulHI3YO/aBJRriZRc2HsU8GQ4f3F
         dZyi7qEZq9xcDWxc9Ln+eGzDgAZARk4RFgCefj17WmFCHUmYhk0yvZKlUlkyOCRuYM6n
         sR/X7qMdG+CgHNath69Ka9N9Gx4993ewQYZYJrN5H0xmG0qREiPXY9sMS/v3mh7oF9qy
         ewY8VFUcHI3LuRq7qcjasm9v8m0df5idMQdEeDsn8eGbKpkA1qgb2Q7zZHo5UQWjvsk3
         /5hw==
X-Forwarded-Encrypted: i=1; AJvYcCXE+1rXbckmioIj9HE70GltPkzP+Hh/zsfbDTf+SA4ljwp1lJhjf1Uy1eimBiu+RZJmChmZxd98YJm7aJf99G6+un5H
X-Gm-Message-State: AOJu0Yy08sC2268B1M9oR+tBVM9OQf2Fn/xuRSpoygMyfIia8y2LaW5l
	7+LM3RWNe0mD4Zs8cY7yJnclDBOe3lFHrUmMGnIZ4s5mLavnLcTMrC5FHc+j2kYDd+CFJe0YWWL
	P9MDhVKh3yx3jK9MO3Kr/pfEcnybzpobV9EeewxT8qjrz2czgnQjBcevT2oeii5IuBw6u4ouo4B
	VdaGRCCXiU3v/3eerzEC7KyVmV
X-Received: by 2002:a5d:49c6:0:b0:35f:f21:3ac0 with SMTP id ffacd0b85a97d-35f0f214485mr4886773f8f.63.1718058822676;
        Mon, 10 Jun 2024 15:33:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlQ56aJmWNAm4Cul5RfaGegtdeN4dbrj0iP6I14Ju4f7YtKDBGFWKqPnM6v6124tzBC9GjNKzXRW3pSI7Mu9E=
X-Received: by 2002:a5d:49c6:0:b0:35f:f21:3ac0 with SMTP id
 ffacd0b85a97d-35f0f214485mr4886764f8f.63.1718058822352; Mon, 10 Jun 2024
 15:33:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c0122f66-f428-417e-a360-b25fc0f154a0@p183> <Zmd148whQzsuIzm_@google.com>
In-Reply-To: <Zmd148whQzsuIzm_@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 11 Jun 2024 00:33:30 +0200
Message-ID: <CABgObfZ=_CN24v_VBz+fD1OLBSb=i_Li2cmZ-bHPkY-LFunmUQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: do not account temporary allocations to kmem
To: Sean Christopherson <seanjc@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 11:53=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Mon, Jun 10, 2024, Alexey Dobriyan wrote:
> > Some allocations done by KVM are temporary, they are created as result
> > of program actions, but can't exists for arbitrary long times.
> >
> > They should have been GFP_TEMPORARY (rip!).
>
> Wouldn't GFP_USER be more appropriate for all of these?  E.g. KVM_SET_REG=
S uses
> memdup_user() and thus GFP_USER.

The only difference between GFP_KERNEL and GFP_USER (worst name
ever...) is that the latter strictly respects the cpuset policy, see
cpuset_node_allowed(). It's not needed for allocations such as these
ones, which are bounded in both size and lifetime.

Paolo

>
> > OTOH, kvm-nx-lpage-recovery and kvm-pit kernel threads exist for as lon=
g
> > as VM exists but their task_struct memory is not accounted.
> > This is story for another day.
> >
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > ---
> >
> >  virt/kvm/kvm_main.c |   11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> >
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4427,7 +4427,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >               struct kvm_regs *kvm_regs;
> >
> >               r =3D -ENOMEM;
> > -             kvm_regs =3D kzalloc(sizeof(struct kvm_regs), GFP_KERNEL_=
ACCOUNT);
> > +             kvm_regs =3D kzalloc(sizeof(struct kvm_regs), GFP_KERNEL)=
;
> >               if (!kvm_regs)
> >                       goto out;
> >               r =3D kvm_arch_vcpu_ioctl_get_regs(vcpu, kvm_regs);
> > @@ -4454,8 +4454,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >               break;
> >       }
> >       case KVM_GET_SREGS: {
> > -             kvm_sregs =3D kzalloc(sizeof(struct kvm_sregs),
> > -                                 GFP_KERNEL_ACCOUNT);
> > +             kvm_sregs =3D kzalloc(sizeof(struct kvm_sregs), GFP_KERNE=
L);
> >               r =3D -ENOMEM;
> >               if (!kvm_sregs)
> >                       goto out;
> > @@ -4547,7 +4546,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >               break;
> >       }
> >       case KVM_GET_FPU: {
> > -             fpu =3D kzalloc(sizeof(struct kvm_fpu), GFP_KERNEL_ACCOUN=
T);
> > +             fpu =3D kzalloc(sizeof(struct kvm_fpu), GFP_KERNEL);
> >               r =3D -ENOMEM;
> >               if (!fpu)
> >                       goto out;
> > @@ -6210,7 +6209,7 @@ static void kvm_uevent_notify_change(unsigned int=
 type, struct kvm *kvm)
> >       active =3D kvm_active_vms;
> >       mutex_unlock(&kvm_lock);
> >
> > -     env =3D kzalloc(sizeof(*env), GFP_KERNEL_ACCOUNT);
> > +     env =3D kzalloc(sizeof(*env), GFP_KERNEL);
> >       if (!env)
> >               return;
> >
> > @@ -6226,7 +6225,7 @@ static void kvm_uevent_notify_change(unsigned int=
 type, struct kvm *kvm)
> >       add_uevent_var(env, "PID=3D%d", kvm->userspace_pid);
> >
> >       if (!IS_ERR(kvm->debugfs_dentry)) {
> > -             char *tmp, *p =3D kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
> > +             char *tmp, *p =3D kmalloc(PATH_MAX, GFP_KERNEL);
> >
> >               if (p) {
> >                       tmp =3D dentry_path_raw(kvm->debugfs_dentry, p, P=
ATH_MAX);
>


