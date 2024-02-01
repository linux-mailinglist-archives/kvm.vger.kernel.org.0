Return-Path: <kvm+bounces-7767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E18D846181
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 20:54:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C5B61F275AF
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 19:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D9885652;
	Thu,  1 Feb 2024 19:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FXyOks56"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBCA85624
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 19:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817244; cv=none; b=t03D1rnZQqGPHEu5JpRO/+zgBpxl2oyYNADoqAuB4DEjPDme9uC+xTnkabpnN7BK1PcF4PwhXUrDy05YvnT7Ebb/C/+gHpOgK6oeB93+wrgjlXRVBGnIX+1IhMvDBFDsuQ+deyIy+VJQl7oA5nny/vUwKvBRKWnbc6EZjMs65Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817244; c=relaxed/simple;
	bh=ZQsn9Trvvh+RY6jMorE8AU+v9azhRM7SEsdC5Uycm3U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b9zi29pjRHLKc816BcY5VwHanNmJAhu/rk7lAFDOtLxB+GKD33Qw60RXmDHHIAIOslk95AgA9mQE8fITs/HUoPLxu55UQHc/BA54D6+WYJBJmxG1tNNCEzRGQs8v8V/Qx21yOyvB3xHISgECwRZ/dViaQ2d9XdiOtpuq2jZLMOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FXyOks56; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-59883168a83so740230eaf.2
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 11:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706817242; x=1707422042; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/LoHtdt3viOsVB5O0XlvICEJk4SiOVHEdN+gLYbxK0=;
        b=FXyOks56jXppBvUhMOnhvleSrioPF4s9KJsD+AVQfttC8+wzXfFEhH56OoAH6s+6U7
         YZPQfUEF0Atz0YOvlPEFrXJ91AGjgF76oUfS5LJk39zggxDCllYsOUuOtXwawBZ1H8un
         I5IbCPn75r6TuvRvxy/NvEZcntjXCWXGS10gxMoNIxDvseFrud9ZMkTclreZgkagsSB9
         919VHzKz6BqFG8EZfxG9B/RViSU/3qIZ74Dp3CHYyvdhjdhSVIb09Ti3/qEw19IuOu9d
         Wb5Xu+fmtB3gGyYBZTbto4wNrpzHNERIgOvsKKoRSfWSogTPhsJWuYo3qX026w5kCiZH
         JWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706817242; x=1707422042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f/LoHtdt3viOsVB5O0XlvICEJk4SiOVHEdN+gLYbxK0=;
        b=LcPDYyxISbvCW6I03BYLgiTj2AVs//MMgIvqTBoffzZWj7UjL+Q0AyJxgUwy/lp02E
         bRvekFbcl5hLiT8MF5pq/vE2A/K9vrbtnu6OSXOXJSqn5Ir2zl8aVBucX4MFAKETEf9f
         kp0OpdBthuH1Y/SKhz4ULyLsXCQZ8ni1ZcIGzfA9YmypFh/Y4s7FMPLvNAmL7IuClRnN
         lKp/JbF1IxkjG6r4ji8YK8+DHSYrR9khWmpr4xyi3E2B4I8S1C432dGF+NFOxqJHBb1n
         I/aXM02//M7LcKCPwpkCiRPedTkom75rAlz93heCqrNYQ5sGJfJadYxgw0G6xkUIbIJ2
         9sPQ==
X-Gm-Message-State: AOJu0YyDnJZSUesVJyn3oF3+fZYE9qBa7XlUBLK40TLsLeoCDDvtBVIs
	yov9dCJTgFz8iZ3owdInqSlGbqtjiwwEJPjiNiznB2/hIdCjsVWV5tKxepju2wQT/mV/+26SV07
	LjvU5i4JNWVRlfqKo/yc65Al8hiWwdtchPmUZ
X-Google-Smtp-Source: AGHT+IEjLEnPw55qSHpu7Ywg6jXC8lZw+1LTzNpNEH76MmLRU7HKs4S3CoVbX+W4IQEQhkg2wMd+9rYo3E9WLfVvJcA=
X-Received: by 2002:a05:6871:5c43:b0:219:faf:b1b4 with SMTP id
 os3-20020a0568715c4300b002190fafb1b4mr19743oac.41.1706817242298; Thu, 01 Feb
 2024 11:54:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
 <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com> <ZbvCU5wPAnePJZtI@google.com>
In-Reply-To: <ZbvCU5wPAnePJZtI@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 1 Feb 2024 11:53:25 -0800
Message-ID: <CAF7b7morHn_-WQBPFexpS_Eb-bXSyu_7CCf-EpBWbAvxReWZXg@mail.gmail.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 1, 2024 at 8:09=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Jan 31, 2024, Anish Moorthy wrote:
> > On Tue, Jan 30, 2024 at 4:26=E2=80=AFPM James Houghton <jthoughton@goog=
le.com> wrote:
> > >
> > > Feel free to add:
> > >
> > > Reviewed-by: James Houghton <jthoughton@google.com>
> >
> > > If we include KVM_MEM_GUEST_MEMFD here, we should point the reader to
> > > KVM_SET_USER_MEMORY_REGION2 and explain that using
> > > KVM_SET_USER_MEMORY_REGION with this flag will always fail.
> >
> > Done and done (I've split the guest memfd doc update off into its own
> > commit too).
> >
> > > > @@ -3070,6 +3074,15 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct =
kvm_memory_slot *slot, gfn_t gfn,
> > > >                 writable =3D NULL;
> > > >         }
> > > >
> > > > +       if (!atomic && can_exit_on_missing
> > > > +           && kvm_is_slot_exit_on_missing(slot)) {
>
> Operators go on the preceding line:

Thanks. On a side note, is this actually documented anywhere? I
searched coding-style.rst but couldn't find it.

> > > Perhaps we should have a comment for this? Maybe something like: "If
> > > we want to exit-on-missing, we want to bail out if fast GUP fails, an=
d
> > > we do not want to go into slow GUP. Setting atomic=3Dtrue does exactl=
y
> > > this."
> >
> > I was going to push back on the use of "we" but I see that it's all
> > over kvm_main.c :).
>
> Ignore the ancient art, push back.  The KVM code base is 15 years old at =
this
> point.  A _lot_ of has changed in 15 years.  The fact that KVM has existi=
ng code
> that's in violation of current standards doesn't justify ignoring the sta=
ndards
> when adding new code.

Well, actually the idea to push back here was more mechanical- I'm a
fan of "we" in comments myself. Somehow I got the idea that it's
discouraged, but that might just be leakage from comments on my past
commit messages.

Again I don't see anything in coding-style.rst, but I wonder if I'm
missing something.

