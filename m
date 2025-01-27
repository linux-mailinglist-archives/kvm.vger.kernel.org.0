Return-Path: <kvm+bounces-36675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C07E4A1DBC5
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 19:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98047165966
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 18:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D5218C930;
	Mon, 27 Jan 2025 18:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gghxYmY5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81D31891AA
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 18:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738000875; cv=none; b=jzt4LCUZbkSZtzJIz/yOmNSSuTj9Ggc/zNapYAc3Cx+78NAAp/wMQtqdYa8oJKrFwD5UGsAnt8F6J9aAi3Snnex58TNY+X0V+OJFNNcuNwQ9RCBUmEUJYaglIcBr884M1rX3SZKbPQbyDPXjb8cfmtS4G9NqGz4aeWEIPjPEfPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738000875; c=relaxed/simple;
	bh=1cOcIz0DIGvczCBp9ybLL0iIveWExRghDna3nGlIV5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RZJLBS3TN52Cbak+MzR/5d6ICnXc/JMpjp+dmAognTl6c5rWcorpCgO9apRb7JC5pMAnydUdkZgRJFTgZZRaJ7DXgP4Uy9nTwKuuHMFSBQK5sMWs1NAOMbN36/yDCaHgzccTBmJxpvmJANHy//FHeUg8zDu6Eq37P9gl/Ojx9IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gghxYmY5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f550d28f7dso9040952a91.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 10:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738000873; x=1738605673; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qelpo+bqUKPwYvbUtt7I2eKYY3x1nXO+q4iLLlJCglE=;
        b=gghxYmY5aYxsdCmYRICJxmqQienONVpVIZOfewSlyEAX2EZwSwxkdCLCn8RcxKLC7W
         4TX4UcWxIo06/NHd+BPisT/Xf+fn4gXd6p5ZgBTisdDnXqjoX2LnMmSaSan1UsOqlIT7
         wddV3KGNyzltNuLjRPeMHhC1IJpAQCO0gaH2HInA8/p1C3BMs39D41QH/4clkGOPqUIA
         4wIfRvr6ff//EzqkWbGynpwy6xFBOeY6Bryfa7JStWMdfkWgrOlyNj5fJccjOpsKJ+BF
         QzIHVACU1Fbr5h2N4K+yQu29yZy8uPwArrn47wutkLFl5a65kiEqrBHEnEtL8jpz0Tdn
         GNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738000873; x=1738605673;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qelpo+bqUKPwYvbUtt7I2eKYY3x1nXO+q4iLLlJCglE=;
        b=o9tLmEXUXTHvA7NxOAa+VLaR6cJd8sbZZmcDi5qkeXSfKtIWKk0Nw7QoO9R7VodF11
         c7cYnhTj/ZqihDYnJW5M05QSIjY9D5yHOEzGU9EyPK0J4SXdHUS9FLLUQXl9z5OxuPB2
         YL0Ci5cZmVY+9CTrN9JmH2lFozDVwCwEKZSJ9i2bFJQIH5mGoJHzXcCZVkcl+F8ZIVYR
         XVKcXqAhI8dKHoxkqs4eIC8QCRx3B2Sol/MqWhUh54ynnO2JWUDA7zKCikssKrmAukW9
         RdOwc/sza8Dj2SxTbk+ZywNWgEaQVYzixh1lB4hZAoPX88pDRdpiK2G9zUtZhtdrFGJq
         VMEg==
X-Forwarded-Encrypted: i=1; AJvYcCVDucmK6E38Nr5T18mz7wov/937rE2ZU4+3igqNmrKNty/2Ac84DQsmY5PuZoC6HPPFagc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0v0i6wFbx44lWviH5wplng2KGuaF5DatSYFUf/so3cvE5uicO
	CA948Xpd9iBDwU0WBAPpxUBl//FYldQ0DWTARkSn/M47ghszB8QgGz0ypG6Q62sfKUBOcQJW3ur
	7tw==
X-Google-Smtp-Source: AGHT+IE3TXMkD7YvXwxJlYbYJxN0p8fDn7mEt4NUNXTVukiToYN5+uF53WBQmFcqa9xHRrDf64ZTGy+h168=
X-Received: from pfba10.prod.google.com ([2002:a05:6a00:ac0a:b0:72b:2f6b:c0a3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3487:b0:725:456e:76e
 with SMTP id d2e1a72fcca58-72daf94f68dmr57498221b3a.6.1738000873220; Mon, 27
 Jan 2025 10:01:13 -0800 (PST)
Date: Mon, 27 Jan 2025 10:01:11 -0800
In-Reply-To: <CABgObfY6C=2LnKQSPon7Mi8bFnKhpT87OngjyGLf73s6yeh5Zg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250124191109.205955-1-pbonzini@redhat.com> <20250124191109.205955-2-pbonzini@redhat.com>
 <Z5Pz7Ga5UGt88zDc@google.com> <CABgObfa4TKcj-d3Spw+TAE7ZfO8wFGJebkW3jMyFY2TrKxMuSw@mail.gmail.com>
 <Z5QhGndjNwYdnIZF@google.com> <0188baf2-0bff-4b08-af1d-21815d4e3b42@redhat.com>
 <Z5Qz3OGxuRH_vj_G@google.com> <CABgObfY6C=2LnKQSPon7Mi8bFnKhpT87OngjyGLf73s6yeh5Zg@mail.gmail.com>
Message-ID: <Z5fJ56t4Tw7V_QbY@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: fix usage of kvm_lock in set_nx_huge_pages()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2025, Paolo Bonzini wrote:
> On Sat, Jan 25, 2025 at 1:44=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > I like the special casing, it makes the oddballs stand out, which in tu=
rn (hopefully)
> > makes developers pause and take note.  I.e. the SRCU walkers are all no=
rmal readers,
> > the set_nx_huge_pages() "never" path is a write in disguise, and
> > kvm_hyperv_tsc_notifier() is a very special snowflake.
>=20
> set_nx_huge_pages() is not a writer in disguise.  Rather, it's
> a *real* writer for nx_hugepage_mitigation_hard_disabled which is
> also protected by kvm_lock;

Heh, agreed, I was trying to say that it's a write that is disguised as a r=
eader.

> and there's a (mostly theoretical) bug in set_nx_huge_pages_recovery_para=
m()
> which reads it without taking the lock.

It's arguably not a bug.  Userspace has no visibility into the order in whi=
ch
param writes are processed.  If there are racing writes to the period/ratio=
 and
"never", both outcomes are legal (rejected with -EPERM or period/ratio chan=
ges).
If nx_hugepage_mitigation_hard_disabled becomes set after the params are ch=
anged,
then vm_list is guaranteed to be empty, so the wakeup walk is still a nop.

