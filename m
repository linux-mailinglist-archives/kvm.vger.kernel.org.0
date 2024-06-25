Return-Path: <kvm+bounces-20448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA90915D24
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 05:09:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3A5C5B2162D
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 03:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8918851021;
	Tue, 25 Jun 2024 03:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dOUxVfyq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673BF49637;
	Tue, 25 Jun 2024 03:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719284918; cv=none; b=gmdCPcLDkarc+bZYOJXf46sihbxi/kR6CJPnw5+mGax6HUyME0nqAuN/4iLNLN++uqKgWYybImWhjT0AlvWg0U4f3cGuVGnZDlrWh38nFzvT7RNO78Y7Yc3FpxNI/LIW+Kf2CYtlG9XKm9fH1yvtcHVTBpGkfyHt4s59EpKQPYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719284918; c=relaxed/simple;
	bh=vIVrnfboOxbuTirmuTt8aeyFvYwGOBS9e3v/Q1D3Xgw=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=qc/bBjGTjVUQoIiCRpNJxBvTfKyiOPr3SIj6yBQsWw6nbR5AzJrq1SLIr8dsB4ACXwVgLgl4nISJtLFpp8o/47/8kmFxsytgG+m1RvE4ifsOPi4dvGsDwUO3YmaiTgjCinxKN8iiFKzPsPlG0EXRyD3J6ogqjzoU8CM5yVbVYTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dOUxVfyq; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7067272245aso1675412b3a.1;
        Mon, 24 Jun 2024 20:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719284917; x=1719889717; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/k7w6eOagUVzT5t2x2qlz385f2D6eOWag8XbqegCfrk=;
        b=dOUxVfyqqd2qpTlmy7JXtHlua9hsA3iYageuCtrs9fxUJoOV7MWf8EAkyHb4/slqw+
         cgApFM9UISNbpuZTl6LYc5Gly6fUlN8aJ6CKpueiFDYU3X60HejoMRYQE3vGfHYcIph0
         a8sylmMcFDb7H+wmyOKBO6Z2r/WrpeK7ZpycQiHoZpfhAL+lGZsy1AfgB+WcgtNpaAeu
         OXjiIax2EVC8z2F9VxVAqNhDk8KPj2PvCqt9fhrucQQhk7FKEY+VDGIIPwJ0GBWWucHr
         8+TEYJo4sPku5PUqpx/ND1WcloUN3JUCkpN/ND96WEmSw7cfEdbif+bp85Nyxczfr7P+
         IJOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719284917; x=1719889717;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/k7w6eOagUVzT5t2x2qlz385f2D6eOWag8XbqegCfrk=;
        b=cvwdchMj+sCtylS7+h7GU5oN9v2F97hNfqNG0tPJmbr11ln+zAJ5+bzbf4JEmoVye0
         WaGv01ItH55LFE88obTwn7yVGvlzPgYKkLK/4PXBcilJcc9kCmeBi66uLpcocOKwcMKY
         s5xf2O084UA1QxQocowAVOK0+adqRfqdvDpVRSXsbNYshP3F9bWwhkPNwkIKeovkOZF4
         bjT6Ht+gkTF/MouHyzOSXQoXtEBV5KvzWwiU55mkWnOGmlBUUTk0qIA5hOI0OluLWky/
         uctm7QlXieV6+fMU3nmT9GrTNDbd7gbaAm09bxuUt6X6+Y42zh/Gh7Z70xmYpOrES66r
         bFQA==
X-Forwarded-Encrypted: i=1; AJvYcCUVWTkV9Q/5pGM1u67D73sSKWp+oxCzBV3Czjrkb2kPb/nC/83T0osmdEcXxwWTFy5sZtdBUFqhzAq9S8tgMNIJE2Pp
X-Gm-Message-State: AOJu0YxgzcENddrGJReRtM2O6AqvcMM/UhtS2kffBHcU93OIqTGXore3
	5Z6xlc3rKLJ2kwl+Tid+pxnI1FYF3nMRsXW0nfvOC5vpi/4lgptW
X-Google-Smtp-Source: AGHT+IGrqV6UWeWrAvsGmwAxJSoxNrHgkVqu+fz0Z52IArlff7rEd8XUZ2RipQ26grl4iYpnUlrM0w==
X-Received: by 2002:a05:6a00:139e:b0:705:f5c0:8ba2 with SMTP id d2e1a72fcca58-70674550d48mr6966087b3a.2.1719284916510;
        Mon, 24 Jun 2024 20:08:36 -0700 (PDT)
Received: from localhost (118-211-5-80.tpgi.com.au. [118.211.5.80])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-716ba79e7cesm6239680a12.71.2024.06.24.20.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jun 2024 20:08:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Jun 2024 13:08:29 +1000
Message-Id: <D28RMVNELBHS.HJUXVDHDPAC4@gmail.com>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>, "Nico Boehr"
 <nrb@linux.ibm.com>, "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>
Cc: <linux-s390@vger.kernel.org>, "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Janosch
 Frank" <frankja@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v3 1/7] lib: Add pseudo random functions
X-Mailer: aerc 0.17.0
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
 <20240620141700.4124157-2-nsg@linux.ibm.com>
In-Reply-To: <20240620141700.4124157-2-nsg@linux.ibm.com>

On Fri Jun 21, 2024 at 12:16 AM AEST, Nina Schoetterl-Glausch wrote:
> Add functions for generating pseudo random 32 and 64 bit values.
> The implementation uses SHA-256 and so the randomness should have good
> quality.
> Implement the necessary subset of SHA-256.
> The PRNG algorithm is equivalent to the following python snippet:
>
> def prng32(seed):
>     from hashlib import sha256
>     state =3D seed.to_bytes(8, byteorder=3D"big")
>     while True:
>         state =3D sha256(state).digest()
>         for i in range(8):
>             yield int.from_bytes(state[i*4:(i+1)*4], byteorder=3D"big")
>

Nice, could use this for powerpc radom SPR value tests (and
probably other things too).

> Acked-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>
> Notes:
>     Since a PRNG with better quality was asked for I decided to use SHA-2=
56
>     because:
>      * it is a standard, commonly used algorithm
>      * high quality randomness is assured
>      * the implementation can be checked against the spec
>      * the implementation can be easily checked via comparison
>    =20
>     I tested the implementation in the following way:
>    =20
>     cat <<'EOF' > rand.py
>     #!/usr/bin/python3
>    =20
>     def prng32(seed):
>         from hashlib import sha256
>         state =3D seed.to_bytes(8, byteorder=3D"big")
>         while True:
>             state =3D sha256(state).digest()
>             for i in range(8):
>                 yield int.from_bytes(state[i*4:(i+1)*4], byteorder=3D"big=
")
>    =20
>     r =3D prng32(0)
>     for i in range(100):
>         print(f"{next(r):08x}")
>    =20
>     EOF
>    =20
>     cat <<'EOF' > rand.c
>     #include <stdio.h>
>     #include "rand.h"
>    =20
>     void main(void)
>     {
>     	prng_state state =3D prng_init(0);
>     	for (int i =3D 0; i < 100; i++) {
>     		printf("%08x\n", prng32(&state));
>     	}
>     }
>     EOF
>     cat <<'EOF' > libcflat.h
>     #define ARRAY_SIZE(_a) (sizeof(_a)/sizeof((_a)[0]))
>     EOF
>     chmod +x rand.py
>     ln -s lib/rand.c librand.c
>     gcc -Ilib librand.c rand.c
>     diff <(./a.out) <(./rand.py)

Cool... you made a unit test for the unit tests. We could start a
make check? :)

Acked-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick

