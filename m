Return-Path: <kvm+bounces-33106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E1B19E4D81
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 07:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A469168AA9
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 06:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DC6C1991D9;
	Thu,  5 Dec 2024 06:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Sb+KBnq8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D15284A22
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 06:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733378970; cv=none; b=XR2YeQrOQgzWQw0JPSCnWEK4ZgqFpfMvEahIS+KU40oxSUF9uFCps9E7SG8IAflRou3PI4X7BedXyLam5sd+eDrFeurOAOTWc7lqoJNG4x4DvrOzXZuTl7BIL2U3nG7lTdkG56isgDp61E1Qt3Z2/zXf37nX7NnqU9p0rfW0sHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733378970; c=relaxed/simple;
	bh=ha/tTjNA7iNUNNwAK8VOBu4fR+9xQhqvVimxkSptFaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e7wMwQbS2yeSor8G8f2cSnJ1yZs2XO9xBlw54D2/lkG8vOmC5aUm8p/ujNc8HNYd8v2Fe5lYsv2QT7nky2rBeHARVRiGHAW8ADrnrlaeqRJbMsR1WJBJsdBEJk3HszSmytTdFbUHw4R1FAFQ64pDwddeDuyFmkIdsPpDCoFf2ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Sb+KBnq8; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-8418ecda128so19419339f.2
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 22:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1733378968; x=1733983768; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aL2ODb59ZMLyvYZNKyPV9w4ocXZc2/Drlrpw4dYUQ6s=;
        b=Sb+KBnq8jwhs+5mgSiCjTA37EXuTY0c3RjqZCJErupbk1d/GrufM690z3CsEbLSHEi
         zJzZy9Aa0siYE1ZfxzxRSGi4WzYrCvzEfVOS6MVszmKmrsAonP1arFHXpmPYy8rUmCHy
         0srtOBCzxDB/z9jmi61BPlvAPElM4VFqjIJQz7rfxer95Tz8ZdCJS3pm357IyOtxNh5y
         QDmbCWGpywXsqvsX4C/6hNGHPhguNyIpf0WHMvjp7d5pqR9nTko573B13MIL3RCcteqX
         Pg2+ZB6ipdMEsAiAXMJPbKav5q+cnFEvB17WHV5ofxbmk2ygyLunMRDSBAmgbvBPFjXW
         685Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733378968; x=1733983768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aL2ODb59ZMLyvYZNKyPV9w4ocXZc2/Drlrpw4dYUQ6s=;
        b=eOP7RqVe78p7QkMYy3XRq7H2F3eTq7U3m0IbAsz2iptI4J7qzb4kbm7RfgUwibYxvn
         XhiSEtA6/8U8Q9wxZo6tM2m73QtjbB7+WjwaePYhEtiRBQYZT71VI9MMBSY98EelYUWp
         w67Y+hFN7U0LkmwA4OoSgraTNJm0kOYwBZCLLKMm5gpKx5lYdSe1eEu1dJ7sbtkgqeaE
         vn0KKbBhT4dQDJCbdpuY/WDcHvzGBEjU0hxxIpUsTJz+ADLvyW6PzReuBswJFeZjuHOc
         XTXOClyH0GW+KDEnCvhv5G/TdMSB3L83XKmBJQ7gsH/ad4zMxMjOW25JAw8b4oLx2Rm1
         ZCtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRlZ/B1LAc2a6IOzY8pfuVRBJu0VNcyghxhmEdVoJLdvvb6GsrlJ0ZBCH1UOJMvJLt93I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAo1HoGYsDbtJ4Nx9vLvAs7Rpt+7hAlecdmyUPMIujGWkbmEM2
	YMzmBz9cRcJkI1QLCinl8WHrNPlwi4fX/w6pedxuv0YXhVpR1pA6KvEsjhN9jbmWa1YpfBPChF+
	tGOZYh6C527WNv4P6eu50XbvmE8PTFO22+C0etw==
X-Gm-Gg: ASbGncsVWSEG9Wv1PycS7hLmXXiDw0Naa5mdYCgLBzuEDjidZhZHjGHQ6bF1rr4u5SP
	TBgRFNPbuL0iQDDiGhgfW2ixbqokstA==
X-Google-Smtp-Source: AGHT+IEOJFcAi0n4c1mbGRpzcMhoQOlyi+pjiyaxzgnJjkOrtltLnY8I/trZOofEuFvj7Y58FOr5LXqv2HOUgAuNT5U=
X-Received: by 2002:a05:6602:160b:b0:83a:7a19:1de0 with SMTP id
 ca18e2360f4ac-8445b5e5949mr1404993539f.14.1733378967761; Wed, 04 Dec 2024
 22:09:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1732854096.git.zhouquan@iscas.ac.cn>
In-Reply-To: <cover.1732854096.git.zhouquan@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 5 Dec 2024 11:39:16 +0530
Message-ID: <CAAhSdy2aPmV6U+GnCnqExXzO3okpDFTbCgwz+Y=dZDVBO0E7Eg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] RISC-V: KVM: Allow Svvptc/Zabha/Ziccrse exts for guests
To: zhouquan@iscas.ac.cn
Cc: ajones@ventanamicro.com, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 2, 2024 at 8:53=E2=80=AFAM <zhouquan@iscas.ac.cn> wrote:
>
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> Advertise Svvptc/Zabha/Ziccrse extensions to KVM guest
> when underlying host supports it.
>
> ---
> Change since v1:
> - Arrange Svvptc in alphabetical order (Andrew)
> - Add Reviewed-by tags
>
> ---
> v1 link:
> https://lore.kernel.org/all/cover.1732762121.git.zhouquan@iscas.ac.cn/
>
> Quan Zhou (4):
>   RISC-V: KVM: Allow Svvptc extension for Guest/VM
>   RISC-V: KVM: Allow Zabha extension for Guest/VM
>   RISC-V: KVM: Allow Ziccrse extension for Guest/VM
>   KVM: riscv: selftests: Add Svvptc/Zabha/Ziccrse exts to get-reg-list
>     test

Queued this series for 6.14

Thanks,
Anup

>
>  arch/riscv/include/uapi/asm/kvm.h                |  3 +++
>  arch/riscv/kvm/vcpu_onereg.c                     |  6 ++++++
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 12 ++++++++++++
>  3 files changed, 21 insertions(+)
>
> --
> 2.34.1
>

