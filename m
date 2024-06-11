Return-Path: <kvm+bounces-19356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AECF69045D8
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 22:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 272031F23394
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 20:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B111527A2;
	Tue, 11 Jun 2024 20:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CXhBu0FG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549C25CDF0
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 20:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718138388; cv=none; b=u8eIC3BaYHU36NBJ7TmnriCkzbiCGUN41gaQxlvQwg83x55Yt2e6mxGA220gfQTacpIix8hHUkQ5/WLna/8+kc64V7Gbf8Dlo//ib4u3dJL0BMQsiqcO2nFQjB188eHw8EFm7GxXmWAgmpMgJm8paX5i95qU0agMjeDmZKlTOxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718138388; c=relaxed/simple;
	bh=Uwv7P+rpbL3D4lWasBXzA1FdWhb0FlRL25Aj/PT5ky8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XygIHtQ5dTcMWkpM+iVa3/2tCKajAaFhGPrfklE2wpLcfyLnYxwGb0AnoZHv+k4TlSidDNod1HvEpR96B3fANzk1BpQkUIbgBGtpeFV1aczGcfg1bAhopnjQnmIQ0PW3e8t0GxnnCqpHqie1NjfVcC5Z9RlTC8pd7fYw3URdGas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CXhBu0FG; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42171fa0a32so23055e9.0
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 13:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718138386; x=1718743186; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uwv7P+rpbL3D4lWasBXzA1FdWhb0FlRL25Aj/PT5ky8=;
        b=CXhBu0FGXtgkEy11Lid9NMC8XBoNUxYHMTPO6jBo++AeJc0N3ZfzjG5XZA/oSwkTrS
         9oKifm8BtLS/DBWdQUhPiZeNED376lnnSrm0JiihIroSRDqw8tbHecBhCtFTT7VmvPRs
         x953xeSAypdHU5GFF4krzn2U2ZDebziXyX6oFkFdo2wzudqFEMd2XFXQnD7WrV0EFHNT
         1QsD2GhtXvlNKXYUeuHq6yuiVigCl/3l9hW/6tOOdAxnx/RmfEOaXaMbmmEuotnVlPZL
         VinPFecKQxaQF1fQYx0pfzv9UN8A6Zyz/xtJlOyaY8iSK43y1YqX4WQcDH1ogIp7/MLu
         grtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718138386; x=1718743186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uwv7P+rpbL3D4lWasBXzA1FdWhb0FlRL25Aj/PT5ky8=;
        b=RcThMy3aYJIxRI8QhBandlU4D9iFSqsLaGdc9u+uzVZSybw/51U3DudbayO3uilwy+
         EhnckchR2fRXOs7up1MSVRmyK60hBpoR4q3EC7au70jOlUOF77An/9lLSDMUjhJffHHi
         CNtNKMPGNRMuSmDUtD/5/JSCCB2qTXBfd1PBdsFX5NAxbLZI1MR4v4AamX9scSMdnjlG
         kCYMnv3JAYrRMA2AEVxW22cYk/SeKuakwIIwTDSnb6iDWKPPV4JXzWN/l8AczSTi9A+W
         2or66j9h/pmhKBTp7Nx9vm2mhdS3J0pIdyl9E37JQWdGYPuOPtZo0zZzUg2oaun1jkVf
         bOOg==
X-Forwarded-Encrypted: i=1; AJvYcCXk87oN7Ic6igHrXPx2Io3E2OqdRlVojup7fdPQT2TQboXQIQQ7HZZwvfIqpPgT+F6Y43cwUmDLjxXHiyFynfEB5uSt
X-Gm-Message-State: AOJu0YxmToq0tcMcpVDIn2qKbpHQr9mGGybbpLJ0Qevisw70AlSkgHZH
	EnbEbm/KHY4kVNYsOLeii6WiBXqH3hCw/sxOZnxReLyhGzKo575QghzH3mfHvKgUB5Gy635Khip
	fOh7rVozs5FXfECQe47z2I0ZMwY/kOAnP6fmJ
X-Google-Smtp-Source: AGHT+IH+CbdX5Jd916IabrKfbqeWvGCL7LL9WXw1sJsxc+uDAViKu6aEHqBlAMyLtMyJTX4kNPtqpJKHeoLv1yDsgn0=
X-Received: by 2002:a05:600c:3d0a:b0:41a:444b:e1d9 with SMTP id
 5b1f17b1804b1-42281b927b6mr453365e9.4.1718138385453; Tue, 11 Jun 2024
 13:39:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com> <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
In-Reply-To: <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
From: Yu Zhao <yuzhao@google.com>
Date: Tue, 11 Jun 2024 14:39:07 -0600
Message-ID: <CAOUHufbRhAXXNtvGaYiGM2jkhGAeiFR7n0kSUZJ3ixQen=d4LQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024 at 10:50=E2=80=AFAM James Houghton <jthoughton@google.=
com> wrote:
>
> On Mon, Jun 10, 2024 at 10:34=E2=80=AFPM Yu Zhao <yuzhao@google.com> wrot=
e:
> >
> > On Mon, Jun 10, 2024 at 6:22=E2=80=AFPM James Houghton <jthoughton@goog=
le.com> wrote:
> > >
> > > This new notifier is for multi-gen LRU specifically
> >
> > Let me call it out before others do: we can't be this self-serving.
> >
> > > as it wants to be
> > > able to get and clear age information from secondary MMUs only if it =
can
> > > be done "fast".
> > >
> > > By having this notifier specifically created for MGLRU, what "fast"
> > > means comes down to what is "fast" enough to improve MGLRU's ability =
to
> > > reclaim most of the time.
> > >
> > > Signed-off-by: James Houghton <jthoughton@google.com>
> >
> > If we'd like this to pass other MM reviewers, especially the MMU
> > notifier maintainers, we'd need to design a generic API that can
> > benefit all the *existing* users: idle page tracking [1], DAMON [2]
> > and MGLRU.
> >
> > Also I personally prefer to extend the existing callbacks by adding
> > new parameters, and on top of that, I'd try to consolidate the
> > existing callbacks -- it'd be less of a hard sell if my changes result
> > in less code, not more.
> >
> > (v2 did all these, btw.)
>
> I think consolidating the callbacks is cleanest, like you had it in
> v2. I really wasn't sure about this change honestly, but it was my
> attempt to incorporate feedback like this[3] from v4. I'll consolidate
> the callbacks like you had in v2.

Only if you think updating the MMU notifier API is overall the best option.

As I said earlier, I don't mind not doing the extra work, i.e., the
bitmap/_fast_only parameters and the _FAST_YOUNG return value, as long
as we know where we win and lose, i.e., simplicity and regressions. I
would call all the potential regressions (the nested VM case, the
arm64 case and the memcached benchmark) minor, compared with what we
got from v2. But my opinion doesn't really matter much because I'm not
your customer :)

