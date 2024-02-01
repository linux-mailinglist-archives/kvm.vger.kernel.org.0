Return-Path: <kvm+bounces-7763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA3D8460E4
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 20:25:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EAB6290202
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 19:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC31284FCF;
	Thu,  1 Feb 2024 19:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JzGUYkqW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA7885277
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 19:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706815534; cv=none; b=D818yNbf9B1G5ud2k01aLN7irBp6zawqfKv8VdCjuAovxkMt2mtn6J6+7qZPrJFGNepohJxtQTXlIvBP+e6s/bcumqNL+8v9AV2EnE35xxVj70eOpFZtRSdIaRwxEqKHVNgkLczZxCOYpLpqpgW0Tsjr6xo2oeDqpmhriEeBiZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706815534; c=relaxed/simple;
	bh=bvbCut5oOWOl+iOeVLTeOOig5dbdTfqbdQOGLCL2GfQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yj/zGjobdcVAShU19g9O4qfZnpGyp3sMZTSJQHAX1QPhvQl1z2l0HkVD2SOPBqwQgyWnz07o0ZXbuFqOu5n4H245IBCW4beHuoZbVxgXRYLvZzuJOtgacMGW1ut7gRzNlIduuJoq0/1sBp6NMsRKWEfQ6bIIKzCjR165iXBV0Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JzGUYkqW; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-214de82b6ddso811943fac.3
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 11:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706815531; x=1707420331; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ubal1OrVwa84Y35GoSFEWShJgB/F1V74QFj/kiIz0Io=;
        b=JzGUYkqWnHCFrV7FsJqeq5qJU6VOCg3vmkOKN8jJx76iEFa73hBIaMB17/QJP4YZNx
         8Fb7Ek9mBkl0zH5PrwJqjWCpREZX/uOVVQhXHFM5vd0xxTYiRgXD9ZM+pQHhtm6YJ8Wa
         4B+0WUdFqJCmSFyE9YiTtgmpZC3wUeQG7Zl2WUlDSgd0SuEN8164QtlluZTadH26NODf
         qER/QNXCHrMWXX6tnAHdeiD7z+AwvGcDTcjCc8l3Eb+Hw5mg+efjjkWoCc78K5qArcuU
         pSiqaMkmqhCmHgPEqwEikPtQFqAvA8j1x8LWOcJHMidTUs08WosE4J3zmGXgXVeQs2Ed
         afXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706815531; x=1707420331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ubal1OrVwa84Y35GoSFEWShJgB/F1V74QFj/kiIz0Io=;
        b=fQ8Kab0HEL0EGaLtqIwcL4GFeOOFJO3gnNu0RgNuLt/yK32i2ctPKdR2v1LFkz/L3n
         oGzuB845Dovq5JKlPAXT3RNwDnSVIwrSzuDKGfk8Dp9kUUNo0spjGC5WWy2o02D1F6Js
         UgFtpPLlhLUMDtVhvs+DmdtrX0hC37iDO7uQqNrpz10kNOkH38gzHzqmOg2kzaPh2eE5
         Kc+R5yEmZMnkVXUNpqyKP56dGgAv1AEMLILSCiuSnTEG6u3mtEYJ0OkRcU7i7gvrriBX
         mY3KNrum0QBeLbRen9s2mbmY544/pJkZUvuYn0ltQPWUmE6v5BPIdmQqSBJusFgCv8OV
         +hfQ==
X-Gm-Message-State: AOJu0Yx55zAXURDV8v2OyCSxYwh8NVBX2WSvn1nRTIz3N1fXFFKq1sT4
	F2TNCVlA0Pd9SKcD+gK3SQv7yQgjFNvzeXOZByPAC19P/Y6Y3u+2IN6KYgSr1PIJ7Oal4syEn+a
	7Un5RKjSNTAAwN6kuH13/aeenyoIOh8rLZIOw
X-Google-Smtp-Source: AGHT+IEmwK+hYVU5DGWRUAShOp5HV+LvB3R9bXJfvSEQJSjfQucoVuwPxZXFT8CL269XTs7i07H8EV8dXI8or3Sh96E=
X-Received: by 2002:a05:6871:5224:b0:206:862e:1b86 with SMTP id
 ht36-20020a056871522400b00206862e1b86mr6145413oac.31.1706815531449; Thu, 01
 Feb 2024 11:25:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
 <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
 <CADrL8HXSzm_C9UwUb8-H_c6-TRgpkKLE+qeXfyN-X_rHGj2vuw@mail.gmail.com>
 <ZbrxiSNV7e1C6LO-@linux.dev> <ZbvGoz67L3gtnHhI@google.com>
In-Reply-To: <ZbvGoz67L3gtnHhI@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 1 Feb 2024 11:24:54 -0800
Message-ID: <CAF7b7mpAt9Dr2jqU6uH=e9gno282BwtHcU7cSSrdBWz7adAW1A@mail.gmail.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 4:26=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> On that note, I think we need to drop the patch that causes
> read-faults in RO memslots to go through fast GUP. KVM didn't do that
> for a good reason[1].

Thanks a ton for catching this James! That's some informative reading,
and a good reminder to be extra careful messing with stuff I don't
quite understand.

On Thu, Feb 1, 2024 at 8:28=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Feb 01, 2024, Oliver Upton wrote:
> > On Wed, Jan 31, 2024 at 04:26:08PM -0800, James Houghton wrote:
> > > On Wed, Jan 31, 2024 at 2:00=E2=80=AFPM Anish Moorthy <amoorthy@googl=
e.com> wrote:
> >
> > [...]
> >
> > > On that note, I think we need to drop the patch that causes
> > > read-faults in RO memslots to go through fast GUP. KVM didn't do that
> > > for a good reason[1].
> > >
> > > That would break KVM_EXIT_ON_MISSING for RO memslots, so I think that
> > > the right way to implement KVM_EXIT_ON_MISSING is to have
> > > hva_to_pfn_slow pass FOLL_NOFAULT, at least for the RO memslot case.
> > > We still get the win we're looking for: don't grab the userfaultfd
> > > locks.
> >
> > Is there even a legitimate use case that warrants optimizing faults on
> > RO memslots? My expectation is that the VMM uses these to back things
> > like guest ROM, or at least that's what QEMU does. In that case I'd
> > expect faults to be exceedingly rare, and if the VMM actually cared it
> > could just pre-populate the primary mapping.
> >
> > I understand why we would want to support KVM_EXIT_ON_MISSING for the
> > sake of completeness of the UAPI, but it'd be surprising if this
> > mattered in the context of post-copy.
>
> Yeah, I let's just make KVM_EXIT_ON_MISSING mutually exclusive with
> KVM_MEM_READONLY.  KVM (oviously) honors the primary MMU protections, so =
userspace
> can (and does) map read-only memory into the guest without READONLY.  As =
Oliver
> pointed out, making the *memslot* RO is intended for use cases where user=
space
> wants writes to be treated like emulated MMIO.
>
> We can always add support in the future in the extremely unlikely event s=
omeone
> comes along with a legitimate reason for KVM_EXIT_ON_MISSING to play nice=
 with
> KVM_MEM_READONLY.

Gotcha, I'll go ahead and make the flags incompatible for the next
version. Thanks for the tidbit on how RO memslots are used Oliver- I
didn't know that we expect faults on these to be so rare.

