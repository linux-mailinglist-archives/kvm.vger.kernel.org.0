Return-Path: <kvm+bounces-33033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DC429E3B44
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 14:29:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C6CC1642C5
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A5E1BE86E;
	Wed,  4 Dec 2024 13:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kRijPg2L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BA81BAED6;
	Wed,  4 Dec 2024 13:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733318972; cv=none; b=gjSfxEI6Jxqk1f3LnKCCnhOoGts4Y/+D2kVA1I5zJNvxpmQIVvRPg150Vnt9xkR5hSbV3TYjzK8/GovrQHQ6tVALBaTZL2wd7YOsVnY+0DQ8+nyb78PItr8VvbG72Sey6lvNTcDErbd6pJyoiWFbHgp9s3cMHTjzJYiMlwN4NZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733318972; c=relaxed/simple;
	bh=8LgSuA+WBQTgsBc7R3pJ6N4Ie4tNuspeOQJsTHEnPSk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILMuyV742OW1XpyqZkpAKATC2Pa5nEbgGFm3MZN5jct/bc9ovHKwdSaaY+d8r2aG41Lt7uNUFU+pMPlPgHsHEZE0uwWQ0KPZFtmPljCZiOXOJAYO3Gtn77yZZoyn8bvvuRXhW1P/tmWolbE/6d1SpFzztqhF+I0uymdKrz0N4v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kRijPg2L; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-53df6322ea7so11784524e87.0;
        Wed, 04 Dec 2024 05:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733318969; x=1733923769; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fT7/iM28e3ijCY97txSoUKDIQiA4vS4c3ajFKAjinfw=;
        b=kRijPg2LiZzlgh9p9UKHGbucz64anb5aPd+n3SdZZCt+0z76w/LihWQa61QXufwyS3
         JEiLmA2ZjpuGbG+ru2vn1HHzLkb4s1jsXkdN4EoDCc2cpX9Q8PFL21D+xlurvHNdOfxx
         8snh6O2LE80N0/yFg52Y1dKOH0cjs/5uGDuVnNseDCDIuEClkn9JzxZ6UG0ljuGRFOBo
         j74e72xcAf/CJ07CYmRmdcFbc1I50eVjpEbEbcrWQiUWEyvikucuzBa2NbBoJgtarVDG
         UWiUwDffhHxSxbkuH0Y5ZZj1BKH+MYYXOXpMkc5CL4jncbZDdDeix380q0i4FMvoM7aP
         BLsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733318969; x=1733923769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fT7/iM28e3ijCY97txSoUKDIQiA4vS4c3ajFKAjinfw=;
        b=uQvfz9T50Lg3rvJYVT513ftj3dA08Rm+yvZGQrPBXCoipCWUgBhmLb06aGj8TpOGFp
         QAEFkJngc7zVJvBQ6gyo/U6OtU84RKzysmvR3bdwwI3lOhZAiRFUJYapgCLcioKY7qnQ
         Ap7eqiBV5OWdCmJM5GHiX5FLx0LCX5tUYY8uiS/MMnbRLPORSQ+DytmN/Frj/H3QYxDq
         ZUsl8kjvdmJkOvSwJBRyeI4SApnKH3G5cW1HNu61iMunOFppdxnLpadnv7EtIxD6tI8V
         ma1qOxnqGrfZ4Yi7fEh1Ab/R7EIzQ3/L5lHvZqYQaKe2ivJ9J4HiCuCXLNuDR/afVxIS
         Xi3w==
X-Forwarded-Encrypted: i=1; AJvYcCUi4R7SApy9YSOJxGcBwulIMc6swbCtwJnekfiwprDdsCglFWB1fP2X5veaUcHSSpbMstk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnGg/YO4Q/leaPTTtJNfFMk0H5IhJn778N6vLgLul9MP5YWj3Z
	bT5ztL74pv0A+FR5unBDJwqVi4Uuvq5CWsCuEFGTNszzkGtPWlYY58S1+Kl7KIrXqdhMQ0pHnDl
	rDttx/On4SOhwENWySZgqDrptVb09
X-Gm-Gg: ASbGncvMV0VFcWkZaRZ9PYUmc09+zmP71c1lpBcUxZ92NSSbjSgjK/y2bHzXhv4O36K
	xeK9Pg87k8naUs5zF27nrHeI1mQhVoO0UXDjMJSzQ0rt0mw==
X-Google-Smtp-Source: AGHT+IHQ/z4ayQeLSfV1OPqA1bxmHeGUn3/wBpzgSPvCqpElKZx/4rueiPY+Mv8VyS1esGzWIwWSiGdWuokpyzB/ZHg=
X-Received: by 2002:ac2:4e0c:0:b0:53e:1ee1:25b3 with SMTP id
 2adb3069b0e04-53e1ee1263amr1421442e87.27.1733318968843; Wed, 04 Dec 2024
 05:29:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-6-arnd@kernel.org>
In-Reply-To: <20241204103042.1904639-6-arnd@kernel.org>
From: Brian Gerst <brgerst@gmail.com>
Date: Wed, 4 Dec 2024 08:29:17 -0500
Message-ID: <CAMzpN2joPcvg887tJLF_4SU4aJt+wTGy2M_xaExrozLS-mvXsw@mail.gmail.com>
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Andy Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Davide Ciminaghi <ciminaghi@gnudd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 5:34=E2=80=AFAM Arnd Bergmann <arnd@kernel.org> wrot=
e:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The HIGHMEM64G support was added in linux-2.3.25 to support (then)
> high-end Pentium Pro and Pentium III Xeon servers with more than 4GB of
> addressing, NUMA and PCI-X slots started appearing.
>
> I have found no evidence of this ever being used in regular dual-socket
> servers or consumer devices, all the users seem obsolete these days,
> even by i386 standards:
>
>  - Support for NUMA servers (NUMA-Q, IBM x440, unisys) was already
>    removed ten years ago.
>
>  - 4+ socket non-NUMA servers based on Intel 450GX/450NX, HP F8 and
>    ServerWorks ServerSet/GrandChampion could theoretically still work
>    with 8GB, but these were exceptionally rare even 20 years ago and
>    would have usually been equipped with than the maximum amount of
>    RAM.
>
>  - Some SKUs of the Celeron D from 2004 had 64-bit mode fused off but
>    could still work in a Socket 775 mainboard designed for the later
>    Core 2 Duo and 8GB. Apparently most BIOSes at the time only allowed
>    64-bit CPUs.
>
>  - In the early days of x86-64 hardware, there was sometimes the need
>    to run a 32-bit kernel to work around bugs in the hardware drivers,
>    or in the syscall emulation for 32-bit userspace. This likely still
>    works but there should never be a need for this any more.
>
> Removing this also drops the need for PHYS_ADDR_T_64BIT and SWIOTLB.
> PAE mode is still required to get access to the 'NX' bit on Atom
> 'Pentium M' and 'Core Duo' CPUs.

8GB of memory is still useful for 32-bit guest VMs.


Brian Gerst

