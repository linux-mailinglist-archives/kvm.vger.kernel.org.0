Return-Path: <kvm+bounces-61988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D1AA7C322D5
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 17:58:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B52418C3D70
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 16:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C84C337BA6;
	Tue,  4 Nov 2025 16:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NDLrkHQy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73D333710D
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 16:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762275483; cv=none; b=mXyg75VYW9mrxNXJLkreZMAMGmRJQ07vR9HcAwr9cLZR/K+OX796n7isOJeG2IBzGagizqB1W7tqPkrggAbwBnBXOXap1EW9v3vxB8XzeVqjAXZG37ccVN609Gda+0SbLwI8R6mhOnaMBYFDuDlMk8KAbizs1qcQuRXgqCeqg04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762275483; c=relaxed/simple;
	bh=MLxu0gtInESRID8NR2D+q4Fg38q1LxThCzek6LcEgjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YeEZ0OmwYk/W8OnpxNA9Ipffen5fAeRyVtd1AZImANSrwfrL4/CyfdOBFI3wddkFqzykJ/+td5WT2awl2GMsH4b/EKN7X7GCNh56TzkcV9X095PhblTgC+hIYBaqppphFP5kgXuZvRVp4XkrIN2D4+CmhovknGLl+Y10lxHjgtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NDLrkHQy; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-294f3105435so184845ad.1
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 08:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762275481; x=1762880281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1pgtEMq9ZUk+kseBgX5WWKcWe4fzxfLf0gu9Y3xm2I0=;
        b=NDLrkHQy3Ob4hRRtbxggNDhBR1nypE1FP1yW/YqpiDmEgtSdgOLnp6M+QR3qlLaOdv
         na6DYSumO3d9kC0KaUwSYmUCO0zle+zMG09DxZmY+xjttuvZ63M+rfyAAffqNw1MTHv+
         H/dOp7lBxBJwd22LkVFIOpgYFRHQnvw52ULe2K6kax98vdMKBNM3D7jh5GTLfcZ4YIWq
         S2dCKk61gLSffAOCUM7rlFDgobcZH1dJKTXoRcUTTOhNT0Ia2ouIVrJIu/VRAsddmENi
         Qy6NFwmhRHZhOua29fMFc7YZIyZfEmmA6Pek1vA0saMU87lbBMcDWV56+bH5nl2IwzWq
         mZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762275481; x=1762880281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1pgtEMq9ZUk+kseBgX5WWKcWe4fzxfLf0gu9Y3xm2I0=;
        b=qoA618Hrgfw5KFXJGBYnnB1gR3sVdkqGh59jC8wa740zPqDhOcYXj34II4ix/mA2IY
         zitvtvWpNyOkBEOwq9asPo50VQA/sa2nifaNetNU9ypdahQK8vAxTs2Blgu1rluTCmhD
         CKEr5HxKaVVQ2jy9dQtHW1LK7DHPr4Agv3LFC3NE1Tii2g87j3HQuBtj5+U4aiHCqoWT
         4ifsqQo9zajvrjIS66FOhOZQP0RPbJsvsU1LMrW5Cmh5ygqOeTJiQXNYWQB5CRwpad+L
         kp7MZAq9ZRhFpWKwiirTDxxag7gTa5podcFK0cG7Q2i5XcU2R833Ot+XQcEmvcIamp9Q
         0VRg==
X-Forwarded-Encrypted: i=1; AJvYcCXsOx9n9332ZI0x2z+buzoequFtVmJKbjHlV3WY+wJ1cZO7eaVch1zND/MFBindTivF0Qk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3CU1ct++t/Vb+p/w9tbLWHJAm15aaCr0n7h+bxzIBAWEmnACr
	jCTx9XHqmmVuLjRCQdhh04GGkBcqqQygM91H9gZuH1W+C1m001QdqeXWT8KL6mOxV5kUt48s5KG
	/U9/A5kAr/pUr8sw6snWSB3hAdkzkDwEvLbYrHu0Q
X-Gm-Gg: ASbGncvj/DPgCfdU9y8mGXhmeamWiWC1evCVkyVbqTX+/jaNVc/wh/wq9qCvesXyxuR
	B0nlrqeZ4sh6gm1Xk0qjw0vj1c14WNkY+5CYFxnx1foiUHzeWsUwSN4l1zRwT8GoYM8SJiAX++m
	EhiYx5262H4OB+iX+DB87MrIVYPNewLP0HyVa8EyAkDRPwW4V4foQDKa0Yxp7r6ftlhdlzJh1vu
	qXfEYDRIS7eXMoOvH/UTPXRGs7hpSGBIskDr+gy5k+gT5iUdrGV5PLWzDNLuBWq20qRLMpV/Wu5
	jDWaFPMVjNQgoZfm
X-Google-Smtp-Source: AGHT+IHUxkJ0RN5Xm4CyoZSdBY0Vq3jB/8eT9XMWGzMrH10Zf9EOWeMDOuGQzeXUotHJOvmp8GH7QuQLGK8lFWObMK8=
X-Received: by 2002:a17:902:ec81:b0:290:d7fd:6297 with SMTP id
 d9443c01a7336-295fd265e91mr5647015ad.2.1762275480356; Tue, 04 Nov 2025
 08:58:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104011205.3853541-1-seanjc@google.com>
In-Reply-To: <20251104011205.3853541-1-seanjc@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 4 Nov 2025 08:57:47 -0800
X-Gm-Features: AWmQ_bmkdySjs6o9qb2hOZL1cbgDT8q5xNA8GcEaO4SL10YhI2cVwYJZi_NMezc
Message-ID: <CAGtprH9H7cHAzdTpPrP-H8Z7yWgRFmTtXNjORDJsuq6AKPbnHg@mail.gmail.com>
Subject: Re: [PATCH] KVM: guest_memfd: Remove bindings on memslot deletion
 when gmem is dying
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com, 
	Hillf Danton <hdanton@sina.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 3, 2025 at 5:12=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Deliberately don't acquire filemap invalid lock when the file is dying as
> the lifecycle of f_mapping is outside the purview of KVM.  Dereferencing
> the mapping is *probably* fine, but there's no need to invalidate anythin=
g
> as memslot deletion is responsible for zapping SPTEs, and the only code
> that can access the dying file is kvm_gmem_release(), whose core code is
> mutually exclusive with unbinding.
>
> Note, the mutual exclusivity is also what makes it self to access the

           ^ safe

> bindings on a dying gmem instance.  Unbinding either runs with slots_lock
> held, or after the last reference to the owning "struct kvm" is put, and
> kvm_gmem_release() nullifies the slot pointer under slots_lock, and puts
> its reference to the VM after that is done.
>
> Reported-by: syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68fa7a22.a70a0220.3bf6c6.008b.GAE@goo=
gle.com
> Tested-by: syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com
> Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-s=
pecific backing memory")
> Cc: stable@vger.kernel.org
> Cc: Hillf Danton <hdanton@sina.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-By: Vishal Annapurve <vannapurve@google.com>

> ---
>  virt/kvm/guest_memfd.c | 46 +++++++++++++++++++++++++++++-------------
>  1 file changed, 32 insertions(+), 14 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fbca8c0972da..050731922522 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -623,24 +623,11 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memor=
y_slot *slot,
>         return r;
>  }
>
> -void kvm_gmem_unbind(struct kvm_memory_slot *slot)
> +static void __kvm_gmem_unbind(struct kvm_memory_slot *slot, struct kvm_g=
mem *gmem)
>  {
>         unsigned long start =3D slot->gmem.pgoff;
>         unsigned long end =3D start + slot->npages;
> -       struct kvm_gmem *gmem;
> -       struct file *file;
>
> -       /*
> -        * Nothing to do if the underlying file was already closed (or is=
 being
> -        * closed right now), kvm_gmem_release() invalidates all bindings=
.
> -        */
> -       file =3D kvm_gmem_get_file(slot);
> -       if (!file)
> -               return;
> -
> -       gmem =3D file->private_data;
> -
> -       filemap_invalidate_lock(file->f_mapping);
>         xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL)=
;
>
>         /*
> @@ -648,6 +635,37 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>          * cannot see this memslot.
>          */
>         WRITE_ONCE(slot->gmem.file, NULL);
> +}
> +
> +void kvm_gmem_unbind(struct kvm_memory_slot *slot)
> +{
> +       struct file *file;
> +
> +       /*
> +        * Nothing to do if the underlying file was _already_ closed, as
> +        * kvm_gmem_release() invalidates and nullifies all bindings.
> +        */
> +       if (!slot->gmem.file)
> +               return;
> +
> +       file =3D kvm_gmem_get_file(slot);
> +
> +       /*
> +        * However, if the file is _being_ closed, then the bindings need=
 to be
> +        * removed as kvm_gmem_release() might not run until after the me=
mslot
> +        * is freed.  Note, modifying the bindings is safe even though th=
e file
> +        * is dying as kvm_gmem_release() nullifies slot->gmem.file under
> +        * slots_lock, and only puts its reference to KVM after destroyin=
g all
> +        * bindings.  I.e. reaching this point means kvm_gmem_release() c=
an't
> +        * concurrently destroy the bindings or free the gmem_file.

Maybe a bit more description here is warranted:

Reaching this point also means that kvm_gmem_release() hasn't *yet*
freed the private_data or the bindings.

> +        */
> +       if (!file) {
> +               __kvm_gmem_unbind(slot, slot->gmem.file->private_data);
> +               return;
> +       }
> +
> +       filemap_invalidate_lock(file->f_mapping);
> +       __kvm_gmem_unbind(slot, file->private_data);
>         filemap_invalidate_unlock(file->f_mapping);
>
>         fput(file);
>
> base-commit: 4361f5aa8bfcecbab3fc8db987482b9e08115a6a
> --
> 2.51.2.1006.ga50a493c49-goog
>
>

