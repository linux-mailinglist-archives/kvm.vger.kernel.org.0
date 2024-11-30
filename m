Return-Path: <kvm+bounces-32789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2DB79DF3D6
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 00:43:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71FE2281475
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2024 23:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 172401AB6EF;
	Sat, 30 Nov 2024 23:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EMfFjDXc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A782158D92
	for <kvm@vger.kernel.org>; Sat, 30 Nov 2024 23:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733010184; cv=none; b=Qo35HygslrPHddhdZp1LDsDDtCZ3FgKtZ7F800aFv670Y3VLuMBkzKcOpfPADMdlse/VJT/t5MFzoO5fF6pLEwJunV4+lOPU7qnM2w8HBxduNMFNepHDHBpnI43Hr/V28IBVA48R2uWeSHsH/CZ+1NFGQnj2FpboCMlz6bnkpRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733010184; c=relaxed/simple;
	bh=dmyM2X6GDFcDEtkf0EAY6/OynnRgtllGwUKFUh9dCJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CudAMFPBxMF2A/TSSDOHRbUd043BBffBEe228bnhsbPQVPTTxtg4eVvHpXs2ga69PLHrieTn3RSWpCk8raCE9UndfJ0rJ6gPnPYFxf8C91DiurYUw3Po0A1ObmhnVLjnDIe3SOcY3xb/8+9biwtpJhtSh57zzrRN1mOEvBcltT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EMfFjDXc; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aa549d9dffdso460963866b.2
        for <kvm@vger.kernel.org>; Sat, 30 Nov 2024 15:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1733010180; x=1733614980; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dxlhX570UpX/l+v7xOWsI34LvjuvMoCbewUEouqkiZI=;
        b=EMfFjDXcAsRV/LAArEbdvoZBmfH3W79ZiOhgcb7WFmoVPa8Y5D4bc1Az0iE/PktZij
         BJ4sS9RCncJrcHAO6XR4+OTY0d4T+snTIVPSAftQ2yFk+9ZvOcunLv/hXvgkZljoGzfN
         hURgyEk+Km+WEKkFfz11obxqWKm9XLPKJrj+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733010180; x=1733614980;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dxlhX570UpX/l+v7xOWsI34LvjuvMoCbewUEouqkiZI=;
        b=UIkKermeLZgtCpBiUCk3oTkWoi5MKvywaU8b0F04lqOl7doN0My9T82XlCvbylr5Q+
         FmYgUUtGmr1J519t6OiBg9Yqa/81cEePr59NelkxUh0Bv3/fMgyeAJuKbSJB2NCTRCoS
         4ZbO0yX9jrGDA9kzruGZmRU5nDt9FQwSSiqiPsoCGPy532OL1DXpVyZ4ODnlBnL9fhgV
         EJKqngPuAHleDbwamQEBMzBZFy8+XdpTyJoLvSsLAtWASjm4Ubr7eMXsBp6lTfVSBD5I
         FouATNmSlN24aiHMcCR8pCRfBUTBXho0i4jeWmn2Q71IVGPY79CbNi5DgoXgF7gNT+/E
         NN2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXBvp5wNWHyRv/BpBW14qFKWpIb1tgEFcpdQZ0pgZIHYTUPrWITq6zoKM0Zk0il8rSzU0I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPThh0I+hbfLAK8+cKJVXmmbRFk4pKhR6xYL+9BlaUYhyH9tkc
	w8Q++sCdNweo/r1pduZq2xXJoWQLvUK3TfjQIqKakSeoZKSuFkfpvpzIkUDpakDBD1cmGpaACPm
	pER2A9w==
X-Gm-Gg: ASbGnctvwDsM8yx/E+MTYobB9Cw6J8qrwHdDokYLsTXsX/mpVussKqSWoY1AHl3VRzn
	yf0PQh31FQFOvNCKaOacnG6IKZ78sBjJgS2yu4IBB+WqudCvC9PGe+WHGI9IMYc+xJkb2A6Qei4
	uLmC8Ju1TcJD0XpV4U5kefgwOtZ5qoAJcKXaqcrnrtGOfSO7pgtsiinbcv0O0YTQlbOIb/Tje+l
	gbNQVisbRI3g+7ub0ZG9NXwiFFmR+oq6YTOx5+n4p12y0lHzltYB5ulRcAAZjeTvycTNNvrVgTN
	RGJlPhkqGQ6K36eDKHSFFdni
X-Google-Smtp-Source: AGHT+IFAeYXwJReubrmNiCteUY2UrTVjIQZMXwjeLsL1AlgJIEoAITR62vZ0H5WUV1wmRv5JOWarHA==
X-Received: by 2002:a17:907:781a:b0:a99:ecaf:4543 with SMTP id a640c23a62f3a-aa580f578e6mr1624394166b.25.1733010180089;
        Sat, 30 Nov 2024 15:43:00 -0800 (PST)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5999734ccsm328294866b.204.2024.11.30.15.42.59
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Nov 2024 15:42:59 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a9a68480164so402614066b.3
        for <kvm@vger.kernel.org>; Sat, 30 Nov 2024 15:42:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWKFUf7kXlOge445AdxaDz4DQHvP+4v+fg7Of8SQZP0R63LppDSFKEPww05kHnx1eyocEc=@vger.kernel.org
X-Received: by 2002:a17:907:780d:b0:a9e:43d9:401a with SMTP id
 a640c23a62f3a-aa580f2a8d9mr1569428666b.14.1733010179098; Sat, 30 Nov 2024
 15:42:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241129231841.139239-1-pbonzini@redhat.com> <CAHk-=wjP5pBmMLpGtb=G7wUed5+CXSSAa0vfc-ZKgLHPvDpUqg@mail.gmail.com>
 <c43676a2-8db6-4ff1-b519-3fd3aa290e4b@redhat.com>
In-Reply-To: <c43676a2-8db6-4ff1-b519-3fd3aa290e4b@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Nov 2024 15:42:42 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiJnBGxUd4Bwnxgtzp1sDXO-+eN9mZfUi_3Cki3Y+hXDw@mail.gmail.com>
Message-ID: <CAHk-=wiJnBGxUd4Bwnxgtzp1sDXO-+eN9mZfUi_3Cki3Y+hXDw@mail.gmail.com>
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 6.13
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 30 Nov 2024 at 15:21, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/1/24 00:11, Linus Torvalds wrote:
> > On Fri, 29 Nov 2024 at 15:18, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> This was acked on the mailing list by the RISC-V maintainer, see
> >>    https://patchew.org/linux/20240726084931.28924-1-yongxuan.wang@sifive.com/
> >
> > Please don't use random links. Maybe patchew will stay around. Maybe
> > it won't. This is the first I ever see of it.
>
> I'm not surprised. :)  I'm going to launch into a full comparison of
> lore/patchwork/patchew---but the reason why I used patchew this time, is
> that I wanted to make sure that the one that was acked and included was
> the most recent submission for this series

Well, I can see the Ack from Palmer there on

   https://lore.kernel.org/all/20240726084931.28924-1-yongxuan.wang@sifive.com/

in the thread overview - or press "expand" there (either flat or
nested) if you want to see the whole discussion rather than just the
overview..

So it's not like the Ack wasn't visible there right on lore too...

              Linus

