Return-Path: <kvm+bounces-26042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D0C96FE12
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:39:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44F0D1C21CA8
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 22:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0DB15B13B;
	Fri,  6 Sep 2024 22:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JphLrioD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416F9158D8D
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 22:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725662319; cv=none; b=W6FBNI5Srr3U2iQhGWA1jUHm1qs5z3RpxO5NDMUQuupZd8Rdy3Mv6cuIhptT5n4O+wwwGFJdt5/aurfTrfJ6XzWkw5sIDbjVoH/Fms8sw1BXV7JRC7PQEZBnKFmNvCmENKhQ/zMIJysEH3jKFEE/PCC5hU8v54UyHpiaZtTKxdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725662319; c=relaxed/simple;
	bh=6DjXgEpihAA2/g5HWLPjjDNu9oZGS6MvM8OVHKfbVkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k4ewuM2XTMZnW0x/3DWR49NReEIBhsaS0MP/YT3QddfyJZRvpQC2kZQlGOCU78fI93BXeG/q5ZhmZFrwJvGOh1bK8Iav8LcBolnPysLOblS3DdvkGsXb+pNLTf8rHD3wXvzXaARI7a8vmefb0Utp2+g5V8xM1vJITCffMIrfMA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JphLrioD; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a86910caf9cso654291166b.1
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 15:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1725662315; x=1726267115; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QzP18zWcCgFcNTi1CIuGIcIYtM7nse/YF/iK8sEHePo=;
        b=JphLrioDILdWMfsafOgJq/yz2p+eFLcuPw7T1mJKd8Hp+Ay37WDYSOUkfTpH1874a9
         wSoRy5SVIC4l/xNd0w+7TxhSwA5QPCN9u/eWDJdkmseBxNIWNPxtIkS83Gw8cMJWsbSL
         rTmdApQLWHmDJkTRAmRMGJV3J68Psh0mFjrHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725662315; x=1726267115;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QzP18zWcCgFcNTi1CIuGIcIYtM7nse/YF/iK8sEHePo=;
        b=Qs/X2c0E0hy08+nqQVZzgIqcnx2dMfNPPeXckNnYdX01tie6i9hOxxo2DqHrIWg+uM
         cK3DYEhD7WBQZN/ml4o1KHBLVjSHeq0Icsrk5ckGLYCYgnqXB1ZRWTSLC1e0ixjvIys+
         8jF5eehTTSUK5lu9be5EROQVSjHbXmnMV88mvTef1uE4dkN/mFCZU3vvU/8jFT+j2AWC
         k1weOOUeXGx6RwF60NMogdiLqZHqcZ3K0kMQ+ftiUraj0iVwsEseAyBaq/vLWf+6CatH
         /oIT11skPO5la+qe5sXGuDZLACkoXpoXfngVIdESsnp2CRbX7rEyLxd8X2LFJ57cAsvV
         TCxA==
X-Forwarded-Encrypted: i=1; AJvYcCULfcUYuZr6TjFaM21kOBRtUYQ5dNW8vx3syxSmJ/+Jk6dpZNkAGh56kQCWdFoL/jz/ckg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/boXSe8aVFe1MC791ZuZm9EvQrMPGln9kzZDSeFpsABR7WB1k
	AG3U8Nbsc0mb97sg4DN2mex8+TzsyxmDujBLRJQL1Mj0UrcNnQfDaEzqx1/Lvs/8ym/WspcbWyS
	BNbo=
X-Google-Smtp-Source: AGHT+IECWMqwp3nadHtFBsEZeTrfDWa+Lf4KgDyJ8M2N8EPECMDPC6VKrb4Xac+86CISAJFWbZVi3w==
X-Received: by 2002:a17:907:7d94:b0:a86:beb2:1d6d with SMTP id a640c23a62f3a-a8a431c7214mr1174122566b.26.1725662314998;
        Fri, 06 Sep 2024 15:38:34 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d65cddsm1218166b.220.2024.09.06.15.38.34
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 15:38:34 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c3d209da98so3683112a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 15:38:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWQpJWoW8pioFvqICNfdAJxWWv2wCHlvO3pJFZwTFUoPecsSzh0+R6e+8j9cbiSMFRGImc=@vger.kernel.org
X-Received: by 2002:a05:6402:5cd:b0:5c2:6a52:ccc8 with SMTP id
 4fb4d7f45d1cf-5c3db9762b6mr4515569a12.5.1725662313929; Fri, 06 Sep 2024
 15:38:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240906154517.191976-1-pbonzini@redhat.com>
In-Reply-To: <20240906154517.191976-1-pbonzini@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Sep 2024 15:38:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjK7HF3dQT8q_6fr3eLGvKS+c46PdYNVAsHRyQRgcgiyw@mail.gmail.com>
Message-ID: <CAHk-=wjK7HF3dQT8q_6fr3eLGvKS+c46PdYNVAsHRyQRgcgiyw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fixes for Linux 6.11-rc7
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 6 Sept 2024 at 08:45, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> - Specialize return value of KVM_CHECK_EXTENSION(KVM_CAP_READONLY_MEM),
>   based on VM type

Grr. This actually causes a build warning with clang, but I didn't
notice in my "between pulls" build check, because that is with gcc.

So now it's merged with this error:

   arch/x86/kvm/x86.c:4819:2: error: unannotated fall-through between
switch labels [-Werror,-Wimplicit-fallthrough]

and I'm actually surprised that gcc didn't warn about this too.

We definitely enable -Wimplicit-fallthrough on gcc too, but apparently
it's not functional: falling through to a "break" statement seems to
not warn with gcc. Which is nonsensical, but whatever.

                     Linus

