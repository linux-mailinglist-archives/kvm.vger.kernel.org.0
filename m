Return-Path: <kvm+bounces-36662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DF42A1D951
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 16:16:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AA5F188787D
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 15:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56AAE152196;
	Mon, 27 Jan 2025 15:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vz42PS6C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A621738DD8
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 15:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737990922; cv=none; b=O8FJJ5vSbENozS1U4pLx7sfnTGldV5G35wC6oFLyI+h1r+VVFhq8d2dUz7tTivLXSs6QgYTUqh66SyIL+3x7bKb3qUMYIjYsyBgY4qyVI4Gc7gMCk1bInXMr9Uty0xsMLZbLBfLiqTwGANsZ9+WzPvP3gobnsQcJC+jg7fqyiNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737990922; c=relaxed/simple;
	bh=Dv7+mQtwYD42Jjuf9XDSRD1jcbBvvwu8+MprYC7uv3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jiq7x6BP9OGTgVnbkYrVVK5OGRqlPKJj9yjzoT0vdwdIRXEme+wtrxaXA/M/g26gJfwGt6dsoGpYcuo3ghZokjYLW+BJajYYahA0sPP6Bgl1IFbNbB9qJ63Ict/JuSHq9GuM9c2e2oVVS7qfbFekG4xpef6yRyvrJ2ujbceTBl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vz42PS6C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737990918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dv7+mQtwYD42Jjuf9XDSRD1jcbBvvwu8+MprYC7uv3s=;
	b=Vz42PS6CBQShahMtivGDpNPWK72/frv0ypI6aGdgPRQ9n0zxB5XCTzZ6TARUlbnZyMvGQ2
	6EGq/KHfOQPBnqXD14SsACaiRKmlhExMVQk+r1zPzQpMFl5ggltXzlilqekR+4gRF4Nivn
	CZcRlvEHyAUcRkky3KUXkuiY+HkI7DU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-QUb7IQ4kO9u3m2DEx-EVlw-1; Mon, 27 Jan 2025 10:15:14 -0500
X-MC-Unique: QUb7IQ4kO9u3m2DEx-EVlw-1
X-Mimecast-MFC-AGG-ID: QUb7IQ4kO9u3m2DEx-EVlw
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38c24ac3706so3773227f8f.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 07:15:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737990913; x=1738595713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dv7+mQtwYD42Jjuf9XDSRD1jcbBvvwu8+MprYC7uv3s=;
        b=o684Pik78L0Gyo5Aj9LigRVGnC3t+/EzOVBxVo58KHbAjoosmGOLlsR6ZYJq55QsWH
         M6OOx+SKdc5Q80KGFFjbnS8ui7pNCTeNNowpx0R9qhVeAVCW+isEOaFp4xh8ghmkOEhc
         nBjCxXlCZB73YYE8TxzsTc1WE9Lf/QOBzA1MwrKAw7PmpX6YxcwfKMz5wIL1P/E7kYCR
         2GtTzA0cde+aqr17EOqCYUDVlYuYvLrPhw8v/LFoEi5xu3oh74KEWsdt3JS2J13d0zEQ
         vPXarnSyXqZIJGx789JtPSpRotJJja2Ruzw9wfeVe3b3ytb/QQnbdTkJj4bWdhEXwxYJ
         x+Zg==
X-Forwarded-Encrypted: i=1; AJvYcCUH/h0/dP/Ja0fRLnacgKlU7VDOGFWd8Tyr2esNpF+dbexRUq0i+EF7OxXrOmKP1TT/DTs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoiOMouHb1vcm/akeJK8G/IIIew3SkGruP8WNfLdp0ag3VLvIc
	teOOvkyh5FSP7x0slFqXxfP+L+lyb32Rrx0o+pwUEvq668TIUVOIrZJr2gARvx0lV3JkqkfkHf5
	XxFPyOeLKE2EBDeipkPuTz5l+aHWgieYalO06gNzFPVtj4VpmOaYPQPn53ddvjGngFwvJzj4IOQ
	VAiMRAbTzE7ulMhFf+qW3eAD7x
X-Gm-Gg: ASbGncsYkz8wDfNSEuqvr3riEyBJMzTdbxY0hRhlSV9fiYWedwJ76Vg2taggyvWtb7W
	mwdN8IFFDDyaxeLC+BR/plHOKYTKsWGjQ05PK1izUA6mQLoi+lMr5FPrGlRweyA==
X-Received: by 2002:a5d:64c2:0:b0:385:df73:2f18 with SMTP id ffacd0b85a97d-38bf59ed533mr47518886f8f.51.1737990913145;
        Mon, 27 Jan 2025 07:15:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE47O9XzRrxKtO4UMj/RH5aYACrMqgZIcqDAz45P6jqa/M8XBT2pQmpaJtgUsVvZJACcUacU3JF1qk0+RWjgWQ=
X-Received: by 2002:a5d:64c2:0:b0:385:df73:2f18 with SMTP id
 ffacd0b85a97d-38bf59ed533mr47518860f8f.51.1737990912840; Mon, 27 Jan 2025
 07:15:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124163741.101568-1-pbonzini@redhat.com> <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
 <20250126142034.GA28135@redhat.com> <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
 <20250126185354.GB28135@redhat.com> <CAHk-=wiA7wzJ9TLMbC6vfer+0F6S91XghxrdKGawO6uMQCfjtQ@mail.gmail.com>
 <20250127140947.GA22160@redhat.com>
In-Reply-To: <20250127140947.GA22160@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 27 Jan 2025 16:15:01 +0100
X-Gm-Features: AWEUYZlYmBQCrohFRr8THABGaTjxEE4J1IYax4X00067peE2DMrzi7feOa-e6PE
Message-ID: <CABgObfaar9uOx7t6vR0pqk6gU-yNOHX3=R1UHY4mbVwRX_wPkA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2025 at 3:10=E2=80=AFPM Oleg Nesterov <oleg@redhat.com> wro=
te:
> On 01/26, Linus Torvalds wrote:
> > On Sun, 26 Jan 2025 at 10:54, Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > I don't think we even need to detect the /proc/self/ or /proc/self-th=
read/
> > > case, next_tid() can just check same_thread_group,
> >
> > That was my thinking yes.
> >
> > If we exclude them from /proc/*/task entirely, I'd worry that it would
> > hide it from some management tool and be used for nefarious purposes
>
> Agreed,
>
> > (even if they then show up elsewhere that the tool wouldn't look at).
>
> Even if we move them from /proc/*/task to /proc ?

Indeed---as long as they show up somewhere, it's not worse than it
used to be. The reason why I'd prefer them to stay in /proc/*/task is
that moving them away at least partly negates the benefits of the
"workers are children of the starter" model. For example it
complicates measuring their cost within the process that runs the VM.
Maybe it's more of a romantic thing than a real practical issue,
because in the real world resource accounting for VMs is done via
cgroups. But unlike the lazy creation in KVM, which is overall pretty
self-contained, I am afraid the ugliness in procfs would be much worse
compared to the benefit, if there's a benefit at all.

> Perhaps, I honestly do not know what will/can confuse userspace more.

At the very least, marking workers as "Kthread: 1" makes sense and
should not cause too much confusion. I wouldn't go beyond that unless
we get more reports of similar issues, and I'm not even sure how
common it is for userspace libraries to check for single-threadedness.

Paolo

> > But as mentioned, maybe this is all more of a hack than what kvm now do=
es.
>
> I don't know. But I will be happy to make a patch if we have a consensus.
>
> Oleg.
>


