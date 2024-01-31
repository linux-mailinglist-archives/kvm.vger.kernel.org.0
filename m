Return-Path: <kvm+bounces-7602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DCBA844AA4
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:00:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF309B29E1C
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 22:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A19BE39AFB;
	Wed, 31 Jan 2024 22:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TkeS8GgD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F69E39FF5
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 22:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706738408; cv=none; b=EN3rDBu6y3tfZvL5K9Rhb2f6Itxa19nwVhAqzh7BoX5up65SVi3PLXsseazxjWbnVZbTJmljsQmcnm/EY9t/y7gO+/qUps+TRx5y/Kkn9J/yfiH65Zq7YNUOB89Cz65QqgAEvY0uxhuJJ2+CXoqRot1nFBqGfo85tbTHXLpYpuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706738408; c=relaxed/simple;
	bh=pTPZRdj/clNw8Oelh7URCewuDtXPDjO7UvOoX7E79cU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FeYOiaXtbQ9Q1muwB8nds6puNgliQF0q+G3BoUdng7SJ6gQR1Klt667XbusBj7Bpl1bYBUlvhAGLebCY4YT6YdihmYmIt8J8HKWuwVMHTYCcAQr/L7Tly1vxeDPMbTQxclUc9VIB+WuPEUfaUC4/zlgtBqiwcv/TmHb/pUSvvVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TkeS8GgD; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-218dd3fdb7cso132268fac.2
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 14:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706738406; x=1707343206; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3HWn2vkHxIR1F0Lo5tspJmR3xmAUHbpogVpChRP7V7U=;
        b=TkeS8GgDHWr4KJ931bIZpdLmF+bWTNwHeqUrm+sqyqwGwPbgsd4KTh8go802QT3hgo
         1RFO1Qw08pRBNfa13cFtIFfvs1wtXWff2cqDBMrZcd6nq/ASsB11qWSKAs846czaDMDK
         awgDpnF2R84dckfj664oHVwTj5tw2Ou2veWy3Er3QQeViU3mdTQVP6cNpeDRxGjR/aJ5
         pibv47WDbHT6yZCOuueg6NYkeRrBOaPgFD2rrC230W2dC0Wpkt+uGd6DI9M8XSZLedXc
         JO9M1F8AqJ9vWe9OSaEzpniKgkAeeTEY4brPRJIGQzOPXO9i2oX2hihX2RMs5B/CsIxI
         tjXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706738406; x=1707343206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3HWn2vkHxIR1F0Lo5tspJmR3xmAUHbpogVpChRP7V7U=;
        b=sWxwSnRfVUo21QEkVutjibDP7GAxVPJQK7LJvnvHn83FBCQEEMU+WjH79KWzr957Mu
         kt+Bxmcw1q7uvqQpcT39UAoHAio/cnQGHbDJ5WRSnJs757OvhBcXrX0gEBZPSRHXesZ7
         BJL9ax5smLJHK8FtkRapFl+/z5s7SatqOcan2Bhbz4vgzClzLLfeoMt5nUGF4Inppv+b
         O1dHrKoSO/pLzGwW5EgloZoQvvhlnkZMdOCgu8KcXphYZW197OCWnnAbi+aSOO5Zg4l8
         bBppY0qCdXqrI+URM+p6YongozP4UuIDxG/jbwaO3JXAoWvSiQ9eMXH5FiG0nJNAriE4
         nT+g==
X-Gm-Message-State: AOJu0YyStN8P/vWMezzUxyEi4KilgQkwyNgQjDVnzH4fCrVrMN6tbNzi
	Rnb9r7ko8v3mU/IC45zLj/db4w+nZo5eK5xw/XZFJFl8VCI0vaUxpxH8W7XmHZ5pR3QEv2m+xR8
	4ZbE3EsKe2JVAnaa8lRxbzT2UbInvci3whcBk
X-Google-Smtp-Source: AGHT+IGKCsKTkygbpPhG3XJ9O5u/HE7aI2abahJw3REKjJnkzRFEpCfEVmamGfDvrnVqdpiddT5NVHn+Cs9fjWdogOQ=
X-Received: by 2002:a05:6871:783:b0:210:af25:a5a0 with SMTP id
 o3-20020a056871078300b00210af25a5a0mr3347929oap.1.1706738406281; Wed, 31 Jan
 2024 14:00:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
In-Reply-To: <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 31 Jan 2024 13:59:30 -0800
Message-ID: <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: James Houghton <jthoughton@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 4:26=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> Feel free to add:
>
> Reviewed-by: James Houghton <jthoughton@google.com>

> If we include KVM_MEM_GUEST_MEMFD here, we should point the reader to
> KVM_SET_USER_MEMORY_REGION2 and explain that using
> KVM_SET_USER_MEMORY_REGION with this flag will always fail.

Done and done (I've split the guest memfd doc update off into its own
commit too).

> > @@ -3070,6 +3074,15 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_=
memory_slot *slot, gfn_t gfn,
> >                 writable =3D NULL;
> >         }
> >
> > +       if (!atomic && can_exit_on_missing
> > +           && kvm_is_slot_exit_on_missing(slot)) {
> > +               atomic =3D true;
> > +               if (async) {
> > +                       *async =3D false;
> > +                       async =3D NULL;
> > +               }
> > +       }
> > +
>
> Perhaps we should have a comment for this? Maybe something like: "If
> we want to exit-on-missing, we want to bail out if fast GUP fails, and
> we do not want to go into slow GUP. Setting atomic=3Dtrue does exactly
> this."

I was going to push back on the use of "we" but I see that it's all
over kvm_main.c :).

I agree that a comment would be good, but isn't the "fast GUP only iff
atomic=3Dtrue" statement a tautology? That's an actual question, my
memory's fuzzy. What about

> When the slot is exit-on-missing (and when we should respect that)
> set atomic=3Dtrue to prevent GUP from faulting in the userspace
> mappings.

instead?

