Return-Path: <kvm+bounces-21206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F79192BD6B
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 16:49:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90B0F1C23BF0
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 14:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB62C19CD08;
	Tue,  9 Jul 2024 14:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sj1aoOoF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BD619D8A4
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720536523; cv=none; b=Nem7Uxs8VwhWXGKuC3NNh7kVthRl+5jeuFvo4wO8iVRmRzO3JNGB+xu0d8yPLHgwSUJFkWIez9aJrFzBI39tJvCtKJrMcKgKI/LRv/1vWitMaRNm72j2ZS7qZC7o9NvaE+Se3jC538rqRxF0feNnOXu8p7+8h5Lehk3IKLlQr2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720536523; c=relaxed/simple;
	bh=YRDjUTbPh6l+A4BsqS2IO/LpdWXWnGUHPCjXH0zkMOk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WejZEdQlAJKZi0lcRMr96gvoYo2V5tsGXjLDVKcToFPcXss3gjYKHsQfpPYh1PcIwXbl7QoXi9Op9JxrCcREaRRl5Ysbayfxtgo7ABa9H9Xel3zllZDnEmkkyozS1F9kAy4pDyPxyQj/cxg9Yc3Cp00MYYM1tYJo1eSTVsnG0IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sj1aoOoF; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6b5dfa44f24so30644266d6.3
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 07:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720536520; x=1721141320; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mQDI93A4q/1A1DaKZJ+DPuhD646DQrZv7GuiEfk7v3k=;
        b=Sj1aoOoFtjI5gAPSEvC88ITi+JU/0xlVRLUOEe/PS6JLnyADeQm2WWoU/kC6MWVSBl
         4cfJmxFzIuwnC3AgE/crSJeIeqgROaE4aHyIx3B84x5AK9Nrp2jzeYC9xBEhBXgZeJLN
         YDrJnyocKV+qnMpWFs4YtYLoHE3729XJ5fAsGsqHL0sEDs4sFaKLYiywfx/6n/hAsu8G
         z3nAimfr4aoDJQQbV9VUBek4WKKFqR6rS/kjiWJ+e1wYYhKcwI123AgMAxZvfNXxIFx8
         miDUwjJOpsAWm+zeW8fhCJeDXSOdoJdCVxi31PrkccaptyaruveVHhxY7xWa3AUJf1Ux
         9e6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720536520; x=1721141320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mQDI93A4q/1A1DaKZJ+DPuhD646DQrZv7GuiEfk7v3k=;
        b=C0U0n74Qops3dsXA8AdOW6EfQBC0YzHBzqlM5o0ZhAF5kjqz+NwonhnyKHIy5E6QiR
         0dE6IsCN5yG6y64J+Sb7sf/+huCuM9khIQX9Ls8YSHgItSJyb/kSi/g3jKR1Ytdk66Vv
         jVv+acjPC10mN1/Zm5gs2HNnXJ8BOSB1l/LNMKl75VR5FenuV0wOVSSG7/if2mRL3bgd
         aIS/LVM4Fa2IMxiweyPxYW+iwQbIs3p5kanrkecAsTaZnvCqPHyu20Uo3lAPpoRNUqTa
         Fp198msdmOysrU6RXKVNjMmwxid5+RAo+5xK4CHQssaARV7IZA7bcXAZyEQLhXdzdBFW
         Ns3A==
X-Forwarded-Encrypted: i=1; AJvYcCVrZa9VuNgLlOo7ZnryzbtjvhneBylCp3+77VgYQnXkedo8NIh4Mz/iKGtEJjpdbtyAtCTTvMG/QschYTRLUe+INVoz
X-Gm-Message-State: AOJu0Yy+2I0zAMCmtYsBb+tkOQlOOsxz8eFs5RUCzzbJfUKU0yB9LGas
	el2Cd0h2tiiAMaBAS7WdXLYv4K1cy1jj1kkOS7sz6usXcDNxnt8QnsxM9m45M/rswkxJdX9QsvD
	PVVZrQ8FHRbFBrjMBumQ0Jiu6phNy30tObGDX
X-Google-Smtp-Source: AGHT+IE02rUhlctlVwBDgEtEerF9V3+vIBytw3xbgIsawGzY84TAJlNr5NIYt475Oj+ghyCqvxioMRmzvcQvywUdNvk=
X-Received: by 2002:a05:6214:234b:b0:6b5:e852:7273 with SMTP id
 6a1803df08f44-6b61bf51da5mr35694586d6.36.1720536520359; Tue, 09 Jul 2024
 07:48:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240709132041.3625501-1-roypat@amazon.co.uk> <20240709132041.3625501-9-roypat@amazon.co.uk>
In-Reply-To: <20240709132041.3625501-9-roypat@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 9 Jul 2024 15:48:01 +0100
Message-ID: <CA+EHjTynVpsqsudSVRgOBdNSP_XjdgKQkY_LwdqvPkpJAnAYKg@mail.gmail.com>
Subject: Re: [RFC PATCH 8/8] kvm: gmem: Allow restricted userspace mappings
To: Patrick Roy <roypat@amazon.co.uk>
Cc: seanjc@google.com, pbonzini@redhat.com, akpm@linux-foundation.org, 
	dwmw@amazon.co.uk, rppt@kernel.org, david@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, willy@infradead.org, graf@amazon.com, derekmn@amazon.com, 
	kalyazin@amazon.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, dmatlack@google.com, chao.p.peng@linux.intel.com, 
	xmarcalx@amazon.co.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Patrick,

On Tue, Jul 9, 2024 at 2:21=E2=80=AFPM Patrick Roy <roypat@amazon.co.uk> wr=
ote:
>
> Allow mapping guest_memfd into userspace. Since AS_INACCESSIBLE is set
> on the underlying address_space struct, no GUP of guest_memfd will be
> possible.

This patch allows mapping guest_memfd() unconditionally. Even if it's
not guppable, there are other reasons why you wouldn't want to allow
this. Maybe a config flag to gate it? e.g.,

https://lore.kernel.org/all/20240222161047.402609-4-tabba@google.com/

>
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>  virt/kvm/guest_memfd.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index dc9b0c2d0b0e..101ec2b248bf 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -319,7 +319,37 @@ static inline struct file *kvm_gmem_get_file(struct =
kvm_memory_slot *slot)
>         return get_file_active(&slot->gmem.file);
>  }
>
> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> +{
> +       struct folio *folio;
> +
> +       folio =3D kvm_gmem_get_folio(file_inode(vmf->vma->vm_file), vmf->=
pgoff, true);
> +
> +       if (!folio)
> +               return VM_FAULT_SIGBUS;
> +
> +       vmf->page =3D folio_file_page(folio, vmf->pgoff);
> +
> +       return VM_FAULT_LOCKED;
> +}
> +
> +static const struct vm_operations_struct kvm_gmem_vm_ops =3D {
> +       .fault =3D kvm_gmem_fault
> +};
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) =3D=3D 0)
> +               return -EINVAL;
> +
> +       vm_flags_set(vma, VM_DONTDUMP);
> +       vma->vm_ops =3D &kvm_gmem_vm_ops;
> +
> +       return 0;
> +}
> +
>  static struct file_operations kvm_gmem_fops =3D {
> +       .mmap           =3D kvm_gmem_mmap,
>         .open           =3D generic_file_open,
>         .release        =3D kvm_gmem_release,
>         .fallocate      =3D kvm_gmem_fallocate,
> @@ -594,7 +624,6 @@ static int __kvm_gmem_get_pfn(struct file *file, stru=
ct kvm_memory_slot *slot,
>                 return -EFAULT;
>         }
>
> -       gmem =3D file->private_data;

Is this intentional?

Cheers,
/fuad

>         if (xa_load(&gmem->bindings, index) !=3D slot) {
>                 WARN_ON_ONCE(xa_load(&gmem->bindings, index));
>                 return -EIO;
> --
> 2.45.2
>

