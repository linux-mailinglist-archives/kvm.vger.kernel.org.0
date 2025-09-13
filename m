Return-Path: <kvm+bounces-57487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECAC8B55AB7
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 02:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A632AAC7BA9
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 00:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 741A93BBF2;
	Sat, 13 Sep 2025 00:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yL32FsNx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F59BA3D
	for <kvm@vger.kernel.org>; Sat, 13 Sep 2025 00:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757723571; cv=none; b=l8rM70mf3zai0tVquW/ruZhW0k93V+LGVu1SZDuaqXo+5c+w0IIhxUV37Rg0BPvrTFrHR7ukkhnxMGkxjYoJsysuV1w5so5pga4GZ14XiuWa5E7nwtsiCPHUryiiQ0gRPcQuIj/wjpVAU61YanDrDvqv+U6vlWzJYD7GOhLB5dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757723571; c=relaxed/simple;
	bh=IT6MSLnpFHgFKYjMuFi70CbKYPgsH9aVuiAyxa9oN5A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=icBMUCfQC1aiJXj/BAIU9aNGw0APe7BNPbeuOWL3Hp2C+SBOCkUq6Ze/F70AQKlIGvtyNeYWqcUiN7+mpJCfDDf0EcFQT70/3uNwoNbR9g6IZUpccdpB7/kFcIWwFNvuraDoqiTREGG29o7PDBVSfOPJcEvgyF8tU7CFb9/q3iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yL32FsNx; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24b2d018f92so42925ad.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 17:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757723569; x=1758328369; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPwE7Pme5w6u5U8aFVe8q7Weh+CgFUkRYwar8edwhNk=;
        b=yL32FsNxuFUdMw9k4d3pEDlTXrWRrPS4QdM2S7A9MRS4WqkOQCfJN1PlmT5S5uTsUM
         gJhsiSaCVnHDzfbvG/PThD68ePeRmiu87WfWGchXzLXKFjjC5CMZ4+wMf6Hpjrb7ztw4
         6DK6O5T/GR3Nn9uh+oir3B0cuNJHn0xj2mMX6To/hgKDcVCwa7S59saoOgRKQBGBabkc
         Z/HpyB5q3anRJOVr4p2lXhJbkteSujGA+uzc5xtqdFDCJifd9iPyEPxDJeALM9dPIyhn
         Qr60gTqp7t0f1NeXGTlpkpBIy4KgkkTI4gaKIfBUgJPaWLwcLOTNe++uZKnp3zglrVcD
         QsDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757723569; x=1758328369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OPwE7Pme5w6u5U8aFVe8q7Weh+CgFUkRYwar8edwhNk=;
        b=iHOpK7uI0e9jRcq7yLctLQfcx1gY6Q2vTHYzGq75KUjSMoOYKO2jX0F/z7SIGjl+1s
         SAMa8P55M4ybT+taQU93wCD/yq0SEIi5dWCVUjXf0izM8aiFa4KPRQYBBhC7kOOEDcPc
         CIZFudw4yvd4+hkHxTYVAtTt7dWyldPanSIChpFZ7iJrxsT8x3c01uU2NGoHXGaGsMhM
         is9sKJzfRkljywirhSvCAVHAUB2TJmq3j94vqJvTMzhWsGxM/WpWF/XuJCXP/jEW0ihk
         /k7LWEyRcHkuDthp446aLJBkoAzfS1+a9pzeqA7vwDY8fShaSXND9xqrfLwYI9E0Qgfv
         sNRg==
X-Forwarded-Encrypted: i=1; AJvYcCXGqAf9DOYnnwmNyP8kT/hjAni0X9FevgbAgi3dMCetJFwUf2GvFNiES+XBnQkWKhyKPHc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMVBag/IK5MKwfy9r+3i37aX5LQoOK8I4J2uFgW+wrj7mTBUd8
	AFiJ997gUjYTCbjkCq9tl5Skj+48itrtBILu6sugye3Zb0DcSqGYR4QLM04AYKGCIh4W3/NuFJM
	GFrGLcFTGFmrILKCUJyk5mMCp7RKqrQM3WqOmsPEd
X-Gm-Gg: ASbGnctiGzv6SexrUceWIyrfJY4ECyJCW4yUssZtnDWty2lKJsMkWdHiVYxydunkZWY
	ldOYZid7q98T6gAl0ZjMAuPNpVblyRbGpUtTf+r+HFT9vKd8ALua1P+u839OgTogZsHADUrk22K
	2BYYq20ipQ5WNj/5SjE1JNgY5FoSU8xKeZfXP/2JI6VypfNLp1ubRz6yQeosfc2lSLK4L8ehm+Z
	bg8wqEO4Pjh0T89uyBvLO9peJ5ljLLxZUmeVgBRFHqyocqrs3oSnU4=
X-Google-Smtp-Source: AGHT+IGyniyNvC+5dYajzXHs7b1Mzj6QmpCkTIBoREKn+Xp9wM0uMHekuGSQTf8LNSd1b9GQgUor0v1MNkX25vcyoi0=
X-Received: by 2002:a17:903:2343:b0:25b:fba3:afa7 with SMTP id
 d9443c01a7336-260e5f7673cmr1180545ad.10.1757723568813; Fri, 12 Sep 2025
 17:32:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902111951.58315-1-kalyazin@amazon.com> <20250902111951.58315-2-kalyazin@amazon.com>
 <CADrL8HV8+dh4xPv6Da5CR+CwGJwg5uHyNmiVmHhWFJSwy8ChRw@mail.gmail.com>
 <87d562a1-89fe-42a8-aa53-c052acf4c564@amazon.com> <CADrL8HUObfEd80sr783dB3dPWGSX7H5=0HCp9OjiL6D_Sp+2Ww@mail.gmail.com>
In-Reply-To: <CADrL8HUObfEd80sr783dB3dPWGSX7H5=0HCp9OjiL6D_Sp+2Ww@mail.gmail.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 12 Sep 2025 17:32:36 -0700
X-Gm-Features: Ac12FXwAFGev-hCtU5uGjoLOuij4m50OSdUHMCxeiDSrTcweNfyyj3SZXIqeY0M
Message-ID: <CAGtprH_LF+F9q=wLGCp9bXNWhoVXH36q2o2YM-VbF1OT64Qcpg@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] KVM: guest_memfd: add generic population via write
To: James Houghton <jthoughton@google.com>
Cc: kalyazin@amazon.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "michael.day@amd.com" <michael.day@amd.com>, 
	"david@redhat.com" <david@redhat.com>, "Roy, Patrick" <roypat@amazon.co.uk>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2025 at 3:35=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> > >> +
> > >> +       if (folio_test_uptodate(folio)) {
> > >> +               folio_unlock(folio);
> > >> +               folio_put(folio);
> > >> +               return -ENOSPC;
> > >
> > > Does it actually matter for the folio not to be uptodate? It seems
> > > unnecessarily restrictive not to be able to overwrite data if we're
> > > saying that this is only usable for unencrypted memory anyway.
> >
> > In the context of direct map removal [1] it does actually because when
> > we mark a folio as prepared, we remove it from the direct map making it
> > inaccessible to the way write() performs the copy.  It does not matter
> > if direct map removal isn't enabled though.  Do you think it should be
> > conditional?
>
> Oh, good point. It's simpler (both to implement and to describe) to
> disallow a second write() call in all cases (no matter if the direct
> map for the page has been removed or if the contents have been
> encrypted), so I'm all for leaving it unconditional like you have now.
> Thanks!

Are we deviating from the way read/write semantics work for the other
filesystems? I don't think other filesystems carry this restriction of
one-time-write only. Do we strictly need the differing semantics?
Maybe it would be simpler to not overload uptodate flag and just not
allow read/write if folio is not mapped in the direct map for non-conf
VMs (assuming there could be other ways to deduce that information).
Can there be users who want to populate the file ranges multiple times
as it seems more performant?

>
> >
> > [1]: https://lore.kernel.org/kvm/20250828093902.2719-1-roypat@amazon.co=
.uk
> >
> > >

