Return-Path: <kvm+bounces-46991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F242ABC275
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 17:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE8FF3B2827
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 15:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9402857F0;
	Mon, 19 May 2025 15:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XmzRytd+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78F272639
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 15:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747668628; cv=none; b=dUn7Jd5ig+GE4ENeP9tw2gYo5I5y4QMhEB88dledxEpxWCtW+83je9XMxbGXttjp6ysWiQZ/7URQOiu5jqJeAgHYx6iqXvOMm+73RUvj0D+vsWHTInMvNXZSvQN9yl5AwpDvP1guvIk0rRvrKRDsiW3AGqY9Fd7gQ68vjrgR+s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747668628; c=relaxed/simple;
	bh=fkFlVu+qSZ4MV+nfcuRKYA58hJOKW9NoQdJAOOm99X8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LKAsTfdUlEKNkudtMxgtUYkvUbFGO9TWsI+P7bJEPEfOfAWfO9giNZ4YurxgaWJFMzLcBUQ6VY4sd3FwAlGB/ABDEJUTH4PWwLhcdbzIoN3j2yKf2/jEkc+Cen9Tho6cE95FMCYstFD+kt/OoKhKzKS9TXYsUG0/hmGzN75MVCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XmzRytd+; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e7b9346e748so1271970276.1
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 08:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747668626; x=1748273426; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UM2NB/3HzJ5wj1PBg1WB1WKrV42DeuPH6QHE0a8NqcQ=;
        b=XmzRytd+L4/IlpaDayuRgYNjy0i1IfKXzXmq/qMQ3BPtcYcvZAyfexxWLAoj1KjsBO
         NpqamhT0gPAkbKNDc7HExgLx5O5yZAId5ss3I6vog4Iq4pXBbFZmWBpHkL+LuQmANOSV
         kHdf97KUDV5RYrBmRbkmPykP85HauwOK7Iubjdtso6VFtMZfcma+kuQLuAKhyt85+vhI
         NmGDcEBPHwYbASvkI4Fimsz4Ut1KeELgw1r+f7lsHbGWKBdXPPV6PJN23KmcEbKWc48x
         Oe0OdZOgs3s6DTo0rcKe3mjLrqT3CmDk1cC5XWadLcq6+nw504qAAL5I7sJogYob2BlD
         ZAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747668626; x=1748273426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UM2NB/3HzJ5wj1PBg1WB1WKrV42DeuPH6QHE0a8NqcQ=;
        b=d8ojvPQeHP4fs6NbJOsXFktHalgJWN4bk9hrCYJOaEUCZnCjQsCcLDC6QPnf/HHOJv
         /W6/Y3oL1XdoqwZUoMNgaFrG8YGd2ITTLcrgamcHf7m2VSVmuRdPnCV88N/aXZjxNJOn
         GdYDM+7Z4s8pgF/oQRS2ViAVUK7SJKJojscdb2lDZWzUCMYkWZdROwor0fKBNhjj5TxG
         P2qPl6HCeV4aJqLZRTgb88UmC/EeFo+63nYlOOerk0VOsFB5iBC9cQSOJOqsgh69CttG
         KF9XM8CFo9DfQNz9zsz+S2uekQtqG82HP69LR6uJ7hE3vhdwUmbeovRgA7e50zwRgx5q
         ezKA==
X-Forwarded-Encrypted: i=1; AJvYcCX5gX6DuMTj3b+RFQ3pU7RLyEJpf7USLkHF5PkNVzyuLPlHO3lwK2B3xlZKCbZ0Pby7PfU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoMhGoY6UTuKJrl8lrpZOdtVp+y0VC7wVTkzatTnZz6GJREYQp
	gSA84d9o9YN6UObMdsRuXNzUPo9KjNAMylMRL4swjXu7sbHZT29cm/0MQkbDbKSm2aFuq+ECbTp
	cTBKvIaF4yclcuBUezI8faoEYKOtIUv6hB7e6nGCW
X-Gm-Gg: ASbGncupG2jX7dmZ7NPHIjxJT3uGdBhAq040WKUWe4eMcVld9OqpAsd7NAEBL8N7ZaS
	LoomNBz/42NVEo3BnSfNEgpvmd6uSxIi9ppiSbjl5XD8KZYVtptDgZGC53V77j/2Ev3TG1wbkbE
	zuzeIFZfoAExCKBJs66RUlvEQJUsDZAi/zwAD2i75Suqr/FsxAh4N2cWxTgNEcQf2zy/c=
X-Google-Smtp-Source: AGHT+IF4G7XKufk4nKQ8/07FV1dIbOJlzIo1f6O8lwRhNg1kWPvrBzIucmkiFgVls4GQsyRXFfqMSh2hVWS2Mb/gx44=
X-Received: by 2002:a05:6902:2087:b0:e7b:6714:3d0f with SMTP id
 3f1490d57ef6-e7b6b204794mr15500391276.24.1747668625365; Mon, 19 May 2025
 08:30:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516215422.2550669-1-seanjc@google.com> <20250516215422.2550669-4-seanjc@google.com>
 <fb0580d9-103f-4aa1-94ae-c67938460d71@redhat.com> <aCsz_wF7g1gku3GU@google.com>
In-Reply-To: <aCsz_wF7g1gku3GU@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 19 May 2025 11:29:47 -0400
X-Gm-Features: AX0GCFsM8QgcC3jY-eb-hlQUgXu5GT_l4kCZow784OctLf01TP57u4_QRZ8uz5E
Message-ID: <CADrL8HXSde+EeLD2UsDNkxAxdmKomEA1XqdDuF4iFaksiZUHLw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] KVM: x86/mmu: Defer allocation of shadow MMU's
 hashed page list
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2025 at 9:37=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Sat, May 17, 2025, Paolo Bonzini wrote:
> > On 5/16/25 23:54, Sean Christopherson wrote:
> > > +   /*
> > > +    * Write mmu_page_hash exactly once as there may be concurrent re=
aders,
> > > +    * e.g. to check for shadowed PTEs in mmu_try_to_unsync_pages(). =
 Note,
> > > +    * mmu_lock must be held for write to add (or remove) shadow page=
s, and
> > > +    * so readers are guaranteed to see an empty list for their curre=
nt
> > > +    * mmu_lock critical section.
> > > +    */
> > > +   WRITE_ONCE(kvm->arch.mmu_page_hash, h);
> >
> > Use smp_store_release here (unlike READ_ONCE(), it's technically incorr=
ect
> > to use WRITE_ONCE() here!),
>
> Can you elaborate why?  Due to my x86-centric life, my memory ordering kn=
owledge
> is woefully inadequate.

The compiler must be prohibited from reordering stores preceding this
WRITE_ONCE() to after it.

In reality, the only stores that matter will be from within
kvcalloc(), and the important bits of it will not be inlined, so it's
unlikely that the compiler would actually do such reordering. But it's
nonetheless allowed. :) barrier() is precisely what is needed to
prohibit this; smp_store_release() on x86 is merely barrier() +
WRITE_ONCE().

Semantically, smp_store_release() is what you mean to write, as Paolo
said. We're not really *only* preventing torn accesses, we also need
to ensure that any threads that read kvm->arch.mmu_page_hash can
actually use that result (i.e., that all the stores from the
kvcalloc() are visible). This sounds a little bit weird for x86 code,
but compiler reordering is still a possibility.

And I also agree with what Paolo said about smp_load_acquire(). :)

Thanks Paolo. Please correct me if I'm wrong above.

> > with a remark that it pairs with kvm_get_mmu_page_hash().  That's both =
more
> > accurate and leads to a better comment than "write exactly once".
>

