Return-Path: <kvm+bounces-47914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 787C1AC747E
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 01:25:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 367CE4E215C
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 23:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 495D1230BF9;
	Wed, 28 May 2025 23:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qvPhFn5C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE582230BFF
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 23:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748474727; cv=none; b=NBsyI3r70ysgT/6heBmogZd+nxx2rr8oz4TVECcsEsQ3hkvVhU9spgI2rX9gwLOv5gr/5kxpqFTmjLLDwWEHqC4HgIvtsqeCvp1DmMxTRorYHOeM49ZvCxjYhQMVV4hs+kZmywq3K2n2+UI9eXhGVyGvnZM72HkIB71cOOKU8s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748474727; c=relaxed/simple;
	bh=HgABNnq1PWhhK0FklJ/SVzoi8Z+ONJI1riVy8DoPDxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kKEoANnng3TzML4oz5D5Fs3qGVCtx7Dmna6zxpPjQIxr6RXU2SCig+gnXXgNa9pAfi1sL1FjSMxlSosncuchcftXKEkIkpa3+qabEKAlP0b8BLj0Kp38l92SowUmbgUbafUUVuCsIS2uuUJlkrR8WNm7RheKedhEQryEa900T9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qvPhFn5C; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747adea6ddbso183761b3a.0
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 16:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748474725; x=1749079525; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gcxQaHt9YO/4vp8lHIwRWi8ySYcHIjzznVMdx4yu7+k=;
        b=qvPhFn5C7xkIsZMR74eG1/yGyBDLzHvm0ki039CDhMZMtrTYu9xtTbWIonU4QFFrRy
         P7P6vvexlvwz8jI0hYou3l8HRum86xYAq+oOawt+8fhC6YXPGMPIzFyerjH49NRfWSuN
         5lFkIxd10awpvxrNt2PJMf6YpTaFZLMVMdehAV4neX2uNDaNEWneELyxLLXG3JNMlVhf
         gcbleUICbeO28+7a52ckZNwrbSf3rciEZRRUMbOM9U3CL7sv+Muc6GDl40Nbfz92OBBU
         fqjrmoUr3ggY4SYmzbid5kI/PuT+y8P2BQmdqu+uBBj5tb1ujfcijxVrxPa1hm7/wNzF
         CGNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748474725; x=1749079525;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gcxQaHt9YO/4vp8lHIwRWi8ySYcHIjzznVMdx4yu7+k=;
        b=rFXrfbO6DNIj8wFmN5VyZczyJkkkTq29cZQA+43MatgTtoWYFOSQbaGriR7idngfiw
         FzkoJRUGg5zrNFuSFA3K7pnsAt/inTdLT0kKKnt3MawempI/JShyGCoCZ/7KilPPYBCF
         ognusPKRqsWa7YnuyEHmNQz9Il4LFlUnTNRCbpPbF9qNRMcidB89u70BFK859YrKu7RG
         ehk1Dz7oqvXIh1ui3bRARNakQuy8d1hBlRyQFE+e2cuKbeagliHXtBO9gY05Iw2pIkR0
         PjrGfxwrSPg37wVPKPJ7/zNxPxjK/4HZZdmH3BPQi+pGaUKvJEk/To0Nh3L92bomW8wB
         Os+w==
X-Forwarded-Encrypted: i=1; AJvYcCVoPCPgFxe4BMypRSrFIWz1WQdc8GDG3iIy2IzpXuHYF9mhdYiLv87+igVLhkHb8PWE5Co=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYlsjlT94chpx8BkCU8o2AQRQYjXXWomrKcOlOsQ229wUuRcE/
	z0JswiUn1YIiYbqLWrQDBV5LIrvrx48bGspEOSw60wdS190nEPvoHgOLoZjTCZkq8u9liNG8Xh1
	affZRWA==
X-Google-Smtp-Source: AGHT+IErw9co+DcBT121540SfwKH6gZVIzfkdn9B2d2kwxMAwaFIuqhkwNuL6Huhgc39bFpmxXdGbf8i9Ig=
X-Received: from pgdu5.prod.google.com ([2002:a05:6a02:2f45:b0:b2e:c392:14f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:699:b0:218:cdcf:106b
 with SMTP id adf61e73a8af0-21aad7827femr6695431637.9.1748474725210; Wed, 28
 May 2025 16:25:25 -0700 (PDT)
Date: Wed, 28 May 2025 16:25:24 -0700
In-Reply-To: <20250528201756.36271-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aDdILHOu9g-m5hSm@google.com> <20250528201756.36271-1-jthoughton@google.com>
Message-ID: <aDebZD1Kmmg15zs7@google.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: amoorthy@google.com, corbet@lwn.net, dmatlack@google.com, 
	kalyazin@amazon.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	pbonzini@redhat.com, peterx@redhat.com, pgonda@google.com, 
	wei.w.wang@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025, James Houghton wrote:
> On Wed, May 28, 2025 at 1:30=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c5d21bcfa3ed4..f1db3f7742b28 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2127,15 +2131,23 @@ void kvm_arch_commit_memory_region(struct kvm *kv=
m,
>  				   const struct kvm_memory_slot *new,
>  				   enum kvm_mr_change change)
>  {
> -	bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> +	u32 old_flags =3D old ? old->flags : 0;
> +	u32 new_flags =3D new ? new->flags : 0;
> +
> +	/*
> +	 * If only changing flags, nothing to do if not toggling
> +	 * dirty logging.
> +	 */
> +	if (change =3D=3D KVM_MR_FLAGS_ONLY &&
> +	    !((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
> +		return;
> =20
>  	/*
>  	 * At this point memslot has been committed and there is an
>  	 * allocated dirty_bitmap[], dirty pages will be tracked while the
>  	 * memory slot is write protected.
>  	 */
> -	if (log_dirty_pages) {
> -
> +	if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
>  		if (change =3D=3D KVM_MR_DELETE)
>  			return;
> =20
>=20
> So we need to bail out early if we are enabling KVM_MEM_USERFAULT but
> KVM_MEM_LOG_DIRTY_PAGES is already enabled, otherwise we'll be
> write-protecting a bunch of PTEs that we don't need or want to WP.
>=20
> When *disabling* KVM_MEM_USERFAULT, we definitely don't want to WP
> things, as we aren't going to get the unmap afterwards anyway.
>=20
> So the check we started with handles this:
> > > > > + =C2=A0 =C2=A0 =C2=A0 u32 old_flags =3D old ? old->flags : 0;
> > > > > + =C2=A0 =C2=A0 =C2=A0 u32 new_flags =3D new ? new->flags : 0;
> > > > > +
> > > > > + =C2=A0 =C2=A0 =C2=A0 /* Nothing to do if not toggling dirty log=
ging. */
> > > > > + =C2=A0 =C2=A0 =C2=A0 if (!((old_flags ^ new_flags) & KVM_MEM_LO=
G_DIRTY_PAGES))
> > > > > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>=20
> So why also check for `change =3D=3D KVM_MR_FLAGS_ONLY` as well? Everythi=
ng I just
> said doesn't really apply when the memslot is being created, moved, or
> destroyed. Otherwise, consider the case where we never enable dirty loggi=
ng:
>=20
>  - Memslot deletion would be totally broken; we'll see that
>    KVM_MEM_LOG_DIRTY_PAGES is not getting toggled and then bail out, skip=
ping
>    some freeing.

No, because @new and thus new_flags will be 0.  If dirty logging wasn't ena=
bled,
then there's nothing to be done.

>  - Memslot creation would be broken in a similar way; we'll skip a bunch =
of
>    setup work.

No, because @old and thus old_flags will be 0.  If dirty logging isn't bein=
g
enabled, then there's nothing to be done.

>  - For memslot moving, the only case that we could possibly be leaving
>    KVM_MEM_LOG_DIRTY_PAGES set without the change being KVM_MR_FLAGS_ONLY=
,
>    I think we still need to do the split and WP stuff.

No, because KVM invokes kvm_arch_flush_shadow_memslot() on the memslot and =
marks
it invalid prior to installing the new, moved memslot.  See kvm_invalidate_=
memslot().

So I'm still not seeing what's buggy.

