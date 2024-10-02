Return-Path: <kvm+bounces-27815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1111798E085
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 18:20:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4252D1C23B28
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 16:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F21E1D1511;
	Wed,  2 Oct 2024 16:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zOuwqF03"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08521D14FA
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 16:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727885869; cv=none; b=kwxD5AhQoTOOEZTqeeiv7PYeH/lFrSzdyS5NA3EebIF8GFBMYO6RgL4HRpjXofXETvk2qTnff3N67Jzxv2ZSe9EMzGs99tSUOpnYuR4whspLMGKhOQ9bV2Hvvsq3dm6s3F4/UoZ1vBy9sVXpT8M8O2yQAtOTjIFCoMqqYAfKVDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727885869; c=relaxed/simple;
	bh=dJPiSQMtzoT6qmJD4ZlMBa33FRAvvOCW0QW5w3VD/sg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CkYx2SZvlTU45t5Yb3loAXDE5Rt8Nvruf2N1Cctwow2LxVHnmHmGA4B3p77wIJepNI03jiN/VlWLwM7jJ4WoFgLpLqDldkv31fosYRo0BH7I3n87FnY3ZQfVq4+RszryfugpplkbqRisCVoe7u6SFdSxgJEC2UZco8suivjVuBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zOuwqF03; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5398c2e4118so29047e87.0
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2024 09:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727885866; x=1728490666; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ARJcCMXQ+rp7186iuswXniuSA2NCVjCtv9/VFdXLQe8=;
        b=zOuwqF03EUdfGKL2IwAeXK63uplYHZq6a1xM7SbsjMqIagCuxEUk5ya3n8NWqAK1mF
         hEDmZkLW+QF4HFnyPw0/qCPh1aIIA8BhQjM6UtO0HTkhTcB2v9FcrXNmV0upVGw4Uvb7
         2fCP2RepZcNktFY42T/XJuhEYB0f5Z/whxGDeHIeSCvlQCxXxvOIDj5o1uoK2L+JGP+m
         sEJYOdm1Q7U7CS8Mc3B1ED3UxW3LgaivyYFLyHWrMOLf8+BvgsbUDAZpEsDxslax1Gki
         DQHcdMg07JhEJfkm/4uYVrptg9mh/0XpBsKTSyrdm+r8/4DeEvIdcnSGXAxmorq40U3A
         9pMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727885866; x=1728490666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ARJcCMXQ+rp7186iuswXniuSA2NCVjCtv9/VFdXLQe8=;
        b=C6HDtN4l4187TYZ7yo9v7LOsMIS/nfKT+IYePlzdngb8FNpq4iG4WDjtWsvf8Z6MLr
         uiYMXu5ZLevkFkWgcMfooNG+5hi5SymUIAaeeMd08vaiGuP9ALn3NE3gLiiyuykYtlLo
         G5hI7RCF9si4QeSQRMV2wdg1kNE2w+pGvYc9L/Y/Pk2V22OwdyF4LEv/KkeHVxqzfMJS
         eefQdOKgkaHOKJHHrUfrrMGAeLu5rf4eDWUSlrc0j4xWkbTxavpcb4cjDBOHC8DXsLI5
         /0JOMYR9xUE3t+QA2oy/Zd8Yq0Xlqrrz/acUL8FzoxxysWjQbYYQ7Zw2ZYnEYdqXZyPj
         MByA==
X-Forwarded-Encrypted: i=1; AJvYcCXQCCQrZ1aWi5NWNKdkFSou98LBnKrk5Jw2jfdlDRXP0ihX6z8eQb/MPL+ATEO9L07eYdk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWg3DuLw+G8m6ffar2IS6QgJEw0iNofXBh+bFiaoa++EJBHV/D
	BhfDG3Ct3hfxS/G8y3C9t5cRkZ8Tu+57db40qLXWY9LolWM3VqnVC3G+0daXi267+kntk0Cbcbh
	qDB4E7RwxU61ObcsQVMrirfP1NrVWCP52wMRU
X-Google-Smtp-Source: AGHT+IGsxRWz32UOeReGn8kkna8PcZY9fOYXyW+STw1/2gSLimHMsKPUTudsdcadk2EE8gUZlftzea8kLqZb40eMbVU=
X-Received: by 2002:a05:6512:402a:b0:539:9f44:db7b with SMTP id
 2adb3069b0e04-539a1f6d772mr398247e87.1.1727885865603; Wed, 02 Oct 2024
 09:17:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913214316.1945951-1-vipinsh@google.com> <20240913214316.1945951-3-vipinsh@google.com>
 <Zvx02r8XjllG7oI_@google.com>
In-Reply-To: <Zvx02r8XjllG7oI_@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Wed, 2 Oct 2024 09:17:06 -0700
Message-ID: <CAHVum0eCmr=YJSvt1CjhS=dz8dTkF6vkJPmm2eyqhQaq+aWVVw@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Use MMU shrinker to shrink KVM MMU
 memory caches
To: David Matlack <dmatlack@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, zhi.wang.linux@gmail.com, 
	weijiang.yang@intel.com, mizhang@google.com, liangchen.linux@gmail.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 1, 2024 at 3:17=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On 2024-09-13 02:43 PM, Vipin Sharma wrote:
> > @@ -6997,13 +7007,50 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *=
kvm, u64 gen)
> >  static unsigned long mmu_shrink_scan(struct shrinker *shrink,
> >                                    struct shrink_control *sc)
> >  {
> > -     return SHRINK_STOP;
> > +     struct kvm *kvm, *next_kvm, *first_kvm =3D NULL;
> > +     unsigned long i, freed =3D 0;
> > +     struct kvm_vcpu *vcpu;
> > +
> > +     mutex_lock(&kvm_lock);
> > +     list_for_each_entry_safe(kvm, next_kvm, &vm_list, vm_list) {
> > +             if (!first_kvm)
> > +                     first_kvm =3D kvm;
> > +             else if (first_kvm =3D=3D kvm)
> > +                     break;
> > +
> > +             list_move_tail(&kvm->vm_list, &vm_list);
> > +
> > +             kvm_for_each_vcpu(i, vcpu, kvm) {
> > +                     if (!mutex_trylock(&vcpu->arch.mmu_memory_cache_l=
ock))
> > +                             continue;
> > +                     freed +=3D kvm_mmu_empty_memory_cache(&vcpu->arch=
.mmu_shadow_page_cache);
> > +                     freed +=3D kvm_mmu_empty_memory_cache(&vcpu->arch=
.mmu_shadowed_info_cache);
> > +                     mutex_unlock(&vcpu->arch.mmu_memory_cache_lock);
> > +                     if (freed >=3D sc->nr_to_scan)
> > +                             goto out;
>
> Looking at the caller in mm/shrinker.c, sc->nr_to_scan will be <=3D 128
> (SHRINK_BATCH), which is only enough for 2 vCPUs. So I think the
> shrinker will only ever free 2 vCPU caches of each VM (probably the
> first 2 vCPUs) before reordering the list and moving onto the next VM on
> the next call.
>
> Does that match the behavior you observe?
>
Yes, for dropping cache one time on a big VM, I get multiple calls of
mmu_shrink_scan() where sc->nr_to_scan is at max 128 in each call.

mmu_memory_cache_lock availability will play a role in selecting the
two vCPUs. On a VM where not much faults are happening it will
probably be the first two vCPUs.

