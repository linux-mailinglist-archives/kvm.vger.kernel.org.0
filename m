Return-Path: <kvm+bounces-26434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C371974723
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E7BC1C25997
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1523423A0;
	Wed, 11 Sep 2024 00:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nFwf9QkA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C836B2C9D;
	Wed, 11 Sep 2024 00:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726013315; cv=none; b=NaqaGx/C8sZQtAE9H15RBAdMBXKrG8DobBk+V0VVLQuGf3PsJRchFdIL+R9njhjTB8u/1gsFF/HQ8NlTwZvWLB9XueCkWXI6NHBUUtnGOceMJnFTk02KGTulYUYCV3JoJGSixfQY/8/keZEBL+izF5+xNiXHkA9vrldOF8phtbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726013315; c=relaxed/simple;
	bh=D5+ndBtVapiQkYJsKHG2VeEzF8YWZCa6WToENcX4xGk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=Qx2dAS1KzpJNDqp9AM2bTt0QQcTelmkuAQaBeqaAE1M3WlrJFFNtdeImzIkrg55cq6qcL/rFMxuTsgAQOQf7x/YCk1I6yWTklkSHaCGkl8FZ0jSN4l15thJlUwVDNLjbK8hAIMWhWh07rRbCr5ZYoa0oByiYXLNzBqxZwjE6R2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nFwf9QkA; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-206bd1c6ccdso56333075ad.3;
        Tue, 10 Sep 2024 17:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726013313; x=1726618113; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GIVoTa7DbVK9Xb7rHJOwqIqIQbFvLn1afRy41hXZ318=;
        b=nFwf9QkAe7665lsaDx7kqyZvMxohzZnhfzQnhb6tvEpbyDGnP+80/tSUoqfvoMr5+F
         jYxs3JwHs3JGhgs3J3Fq+6usyv+F0Xntw4wM877icZXmYz0Cx0KQI39PWjVgxAq7P54x
         xOxPhvACuo/HlySn/J1WmLidn+BkABeYc1kIlXf9Of7qlgvV9QUcRoDZyzqI18Zy/jhI
         ijTTI1Tn3V8Pt8o4GJnLpMciA8MGnQhqsf+ICa6zP1n3qH7HnB/4x9QO+4u+kQFX8Z9F
         TvvT+x4/UpQw2Za9fEa4ncr8d6qp2j2ex7QxPfHjEhTyZztIHlpGuSheiU23Ll+IMHGi
         V4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726013313; x=1726618113;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GIVoTa7DbVK9Xb7rHJOwqIqIQbFvLn1afRy41hXZ318=;
        b=ducEHWd8cInssDLYg4HFB1JWJfSWMxM09BvysV0lFu0RtW72TcsIruLNu4YNkZJhzA
         EECIJpiAkpNq9IdhK6VfIXNLeRmmLRX4KOEmqVT4Kl0+99o8HsqwjrBYxZb7x2tsM3OH
         U1rmOs/hvOur9ff9CpSOjpk6UPvpwKkJ4B6zHl4G8hKqlYrNMqBtITHG5bdukn85R+5A
         tz5AgWIaMXsL+fBL4wcSh7RHeFdtkaPQjzyI2KIlcwpRvqI+5kvlo5F2WzuUkl4dkmtQ
         CvY912ZxwuAbjYwQufRU02MEFgZ6Zj9haYtAKuOpgHCASd+3fFuQIFecHZRQx7Q3Gd6K
         2H3w==
X-Forwarded-Encrypted: i=1; AJvYcCW0yC65knt+ls9eTC3bNeu+Q+CXzrRMG837oZxjuhWZ+CILImkamG+D/c+k+VRou0AhyLsU/lISXm2YTA==@vger.kernel.org, AJvYcCWRYNSht+mBotoOE4U/oZdkyi3Q4DHDjjkMCYXNxduh/HG8OWRWSOKurea+K/B1Bj8Wff4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnTFU34gkN/poTXjZuZl79GAlR2veN0uZ7ZwiOco+Yg1CTLHOa
	onmjRDO4bbG2xe82rWCrxZGhMvSaQPqQzXMSSTGuVEsGOKm9/Fhq
X-Google-Smtp-Source: AGHT+IFI8//EbE/gHR4iY1Po7jEcpiXzm01F+imeNjISSHpDyxl/I7se1YOfHzreK/iUzyqJTQp1qg==
X-Received: by 2002:a17:903:32c1:b0:206:fd9d:b87f with SMTP id d9443c01a7336-2074c5eb15fmr26527005ad.17.1726013312836;
        Tue, 10 Sep 2024 17:08:32 -0700 (PDT)
Received: from localhost ([1.146.47.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710eea8e3sm53480125ad.174.2024.09.10.17.08.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 17:08:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Sep 2024 10:08:23 +1000
Message-Id: <D430NH4TXH15.KR19KPMT2APE@gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/4] riscv: Drop mstrict-align
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>, <kvmarm@lists.linux.dev>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>
Cc: <pbonzini@redhat.com>, <thuth@redhat.com>, <lvivier@redhat.com>,
 <frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>, <nrb@linux.ibm.com>,
 <atishp@rivosinc.com>, <cade.richard@berkeley.edu>, <jamestiotio@gmail.com>
X-Mailer: aerc 0.18.2
References: <20240904105020.1179006-6-andrew.jones@linux.dev>
 <20240904105020.1179006-7-andrew.jones@linux.dev>
In-Reply-To: <20240904105020.1179006-7-andrew.jones@linux.dev>

On Wed Sep 4, 2024 at 8:50 PM AEST, Andrew Jones wrote:
> The spec says unaligned accesses are supported, so this isn't required
> and clang doesn't support it. A platform might have slow unaligned
> accesses, but kvm-unit-tests isn't about speed anyway.
>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  riscv/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 179a373dbacf..2ee7c5bb5ad8 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -76,7 +76,7 @@ LDFLAGS +=3D -melf32lriscv
>  endif
>  CFLAGS +=3D -DCONFIG_RELOC
>  CFLAGS +=3D -mcmodel=3Dmedany
> -CFLAGS +=3D -mstrict-align
> +#CFLAGS +=3D -mstrict-align

Just remove the line?

Or put a comment there instead to explain.

Thanks,
Nick

