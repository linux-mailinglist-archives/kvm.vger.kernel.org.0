Return-Path: <kvm+bounces-36676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC93AA1DBFA
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 19:18:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D7423A4FB5
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 18:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA1B318FDBD;
	Mon, 27 Jan 2025 18:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bnGSSYNT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512BF18B482
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 18:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738001871; cv=none; b=SGlaZ/nRQBItdX+IoqyivS6hCHh6AyLMzA7DNogbakYSC/BgfSIbA69xzqn7HTaela9qP4MiwDtgDZPx2YaggAxLxVHteU6Awq20FGrVNDn/9/ZuG3WAkC9WKd54cxkRfY2VPBRvOoSo2hxZ+e7+YQyS46ntLhwGIZNJPSCKvfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738001871; c=relaxed/simple;
	bh=2/rJa9hCMDf9WmStAiKW+P4kBSOQ8VfvpJZtOVWwOcU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=czzAC+UI/dQ7SMRH4f6wgAGJlDZxAo/jHpAlyFwl2vaSkImhp72gz71VIki/j6GBxi8ZBcDfxDRDUvfSVp6TBqBgTfs6Vsk6/0cOyyihSUaXa5baqlRdT8m2pmb3cRyqj7SMOEvb5qBfEx5He9KSP/RF5b6dtxjhkh8ag79JBUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bnGSSYNT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738001869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jaLoWsaWO/Lu2MvePT5Qy8CFE8tW01qxUEhoywpUxU=;
	b=bnGSSYNTPDugJczhhcNbbSBzNCI9J8igXhNLyb2xFwlK5wc/4zWkZSHjhgwLdLyGGGSscz
	PMe3cylxWU5NbyDGWH7sGXSKxiv9CizMbq0SiAop3UbZ3FV1X8Lv7QG2K1mNYMXFSk0Fy/
	JA6PIwZhJUrURnKyXlxAF15MqjxQCGI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-PnXqGi0UNFSORVfBaemEPg-1; Mon, 27 Jan 2025 13:17:45 -0500
X-MC-Unique: PnXqGi0UNFSORVfBaemEPg-1
X-Mimecast-MFC-AGG-ID: PnXqGi0UNFSORVfBaemEPg
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385e49efd59so1801586f8f.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 10:17:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738001864; x=1738606664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/jaLoWsaWO/Lu2MvePT5Qy8CFE8tW01qxUEhoywpUxU=;
        b=wnhp6SPF6QYrgxBmmnoDfkg7fNwTT/wopMfnfIGqk7x8KEzH2aYKComT1gtYteilQE
         hWxh9DIDjqRmcvyAJxABLevaSGKlXoQmJ1900NhdQIBo15ILJIxyaSlBtHdOxXCuJybI
         YrlJd+Ru/4/fd6aFlU7EImquR+L6oQVcFXOKkVqCRUZpxa2MidZjmwXxzsvpJzlAnENV
         ju6fWZa4FadQbiKSQmr+9R17sHARrrWJdwXgZQZLZekxD+J9Z7o0GHnmeeSTUaaqEls5
         ETjnJz6EDiNysqNehLVxPgcmRdVw8DAprPxoCdWHd1efr+Mz/feJCiVZkEKGjZ3nLNGo
         OgUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqIHt4dgCGD+oxu4mP2Nx0oLBx9WmRUBj//tEF5TOwmlmgFgNFyMsidgMIW33otRnpU28=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVr9ojv1/77MeFNOkPRVn0aNty33eNZSuuzju6csAi9QHX+QLZ
	GAjsWYmoRyufdO+aZJafPoMwHcsMf2a8ztjmGsDJSBuib/1Slrc+ZL+RrV9UqxIXsypHWYQ+Sgb
	voU87ZU2+06RTfrwshwecKapr5j5KxjzOsf4JE0aJ1zPakjjkmAJ6/0E+iXKUE/TVRugy6VdFyI
	gMXJ4htd0kDeQekvrQHdFtwO0n
X-Gm-Gg: ASbGncvT1AI8V73zsm+xaA4YD+jSkQE911iDkVNiUhoTD5IRxKMA8LjqWYFsWFqtJ50
	OfKvwLT39VEZoZ0aZQU4a7RodTnCjp1QW6RotBXjHXZ9MSubg8u8wp4yDzqA0yg==
X-Received: by 2002:a5d:64e9:0:b0:382:450c:2607 with SMTP id ffacd0b85a97d-38bf566e73cmr31691626f8f.4.1738001864255;
        Mon, 27 Jan 2025 10:17:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEmU3dTjWWul/KB/iOoDxRbzOZ50pB0gXel0EtYYTNqWx8rzNGOh4VLrJP4EOvUHrvxqO24zNXA5+pngphRHkk=
X-Received: by 2002:a5d:64e9:0:b0:382:450c:2607 with SMTP id
 ffacd0b85a97d-38bf566e73cmr31691610f8f.4.1738001863890; Mon, 27 Jan 2025
 10:17:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124191109.205955-1-pbonzini@redhat.com> <20250124191109.205955-2-pbonzini@redhat.com>
 <Z5Pz7Ga5UGt88zDc@google.com> <CABgObfa4TKcj-d3Spw+TAE7ZfO8wFGJebkW3jMyFY2TrKxMuSw@mail.gmail.com>
 <Z5QhGndjNwYdnIZF@google.com> <0188baf2-0bff-4b08-af1d-21815d4e3b42@redhat.com>
 <Z5Qz3OGxuRH_vj_G@google.com> <CABgObfY6C=2LnKQSPon7Mi8bFnKhpT87OngjyGLf73s6yeh5Zg@mail.gmail.com>
 <Z5fJ56t4Tw7V_QbY@google.com>
In-Reply-To: <Z5fJ56t4Tw7V_QbY@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 27 Jan 2025 19:17:31 +0100
X-Gm-Features: AWEUYZlguTGitDK-NScGFG5wh-HhzYZHPaScilvce3_eiVj6gYXSUWpwKquIT_4
Message-ID: <CABgObfb7chO33LpCvktpQUwS=Pnt7Mj+Dj4vATWVj48NmMXmag@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: fix usage of kvm_lock in set_nx_huge_pages()
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2025 at 7:01=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jan 27, 2025, Paolo Bonzini wrote:
> > On Sat, Jan 25, 2025 at 1:44=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > I like the special casing, it makes the oddballs stand out, which in =
turn (hopefully)
> > > makes developers pause and take note.  I.e. the SRCU walkers are all =
normal readers,
> > > the set_nx_huge_pages() "never" path is a write in disguise, and
> > > kvm_hyperv_tsc_notifier() is a very special snowflake.
> >
> > set_nx_huge_pages() is not a writer in disguise.  Rather, it's
> > a *real* writer for nx_hugepage_mitigation_hard_disabled which is
> > also protected by kvm_lock;
>
> Heh, agreed, I was trying to say that it's a write that is disguised as a=
 reader.
>
> > and there's a (mostly theoretical) bug in set_nx_huge_pages_recovery_pa=
ram()
> > which reads it without taking the lock.
>
> It's arguably not a bug.  Userspace has no visibility into the order in w=
hich
> param writes are processed.  If there are racing writes to the period/rat=
io and
> "never", both outcomes are legal (rejected with -EPERM or period/ratio ch=
anges).
> If nx_hugepage_mitigation_hard_disabled becomes set after the params are =
changed,
> then vm_list is guaranteed to be empty, so the wakeup walk is still a nop=
.

I think we have enough arguably necessary lockless cases to think about
linearizability of sysfs writes and reads of vm_list. :)  If you agree,
set_nx_huge_pages() and set_nx_huge_pages_recovery_param() can be
changed to simply have a guard(mutex)(&kvm_lock) around them, instead
of protecting just the vm_list walk.

Paolo


