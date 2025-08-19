Return-Path: <kvm+bounces-54971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D4D84B2BE3C
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 11:59:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF3141887454
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 09:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8280E31B11A;
	Tue, 19 Aug 2025 09:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Crgz4/rJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4AA31AF36
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 09:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755597439; cv=none; b=GNrsws8av7GHflYXExaQAmZo7sfubTZGljZUT0Iv71pjulCPDe7HNDhN/QHEy/F0mWOYumoSH2jM53mBrAYQSZqzOaEz6dRYLik5rHo4uDYPVEXtCV5Ki/mFQCevc8sSE8PrgpsDnscbABeD3hO1SnzDZ7NQPQDpOcAX/m40LxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755597439; c=relaxed/simple;
	bh=RQZmLelstrX1SotmAT9zZXcUSdkqlq/nNJekgpnEDi8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n06fzAUZ5SaZpUlMkjsfmY902/NnSdsRO3J2cIis1XpRrZMDg9Vg5dZosiDzgAMmkHZnIVaRZfvyWs5AsS5AuIaJY9Mox3Sd/xTnR9LsVPJUNUHHTZghQPdQtsU7/UDcv/9O90OwSelYGySnTENfVJ9Jga/HuCBQkI+rEpCh9fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Crgz4/rJ; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-55ce52658a7so4886132e87.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 02:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755597435; x=1756202235; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B657FCRrA1HpbcN+g/vtvEIg1TfbvbOHf4kJ5LZvO5U=;
        b=Crgz4/rJWY9ajhNfIko3K3qRIt2Ao8Kn/WyBwNb+k4BNCgtl3Hifc3buCHBsGCXAn7
         ER+IXudCW+H/ScI8yAbvRnpnb/mNCcnVrYv9PxKPlwUMKhS5XKanmM2yoytOg1xD2MLk
         WqCA+wqVuBurg8VGgzdI3rpUYxX6Z9daMcOGdySIRBPqiwTdumu7/Puj3tknNnI/aKHp
         If/Vna9fqPuzX1zb7V7P9pXXNwT2o5nBhVScqeTzas75Ee0iQuG8a54m8+YXhk3Q8JI5
         qX6ahOntDHLGUZqm+xSqmfjOD+9plca8SxujfKVMNMeazjWaE8IdEJPVZyYAJOUutGZC
         so2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755597435; x=1756202235;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B657FCRrA1HpbcN+g/vtvEIg1TfbvbOHf4kJ5LZvO5U=;
        b=KvqP9b+4sShWc9VPxuNS0vWwN2sTxIIk9AiU2kAk0gxyuUQ5Gj49vs20YzNZFO72OA
         pY+C9Lk6jS5SZ0MHgWLxDBdrhS2+/98MlOGttYAzzZeu18dz1UQXJxKu9G+P6KWAgIJH
         JyOb+jGw1UZJcoVVqisa8XF1SJIgspnlbDkQmDeHD1GKIFCEq952E0XZidDCc6yXsf6q
         8EGKl9McynRRiYJCiOK05N0UE5G+62cSrTw+S08WtOgn/152dJCWSycRoLRKfhK/mnML
         9prynaVBSdK74bfNk8aad8ciKgzcDr2srZbxf58VdbmPWuWe3niG+DvXonHOxG4alPOU
         +RMg==
X-Forwarded-Encrypted: i=1; AJvYcCUB5Wj+ELNeH1guUEizdlwyToHAAHySvC7NNNnBdK0SZwlQYzoB40rzAuRXKOCBH01nmB8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFsYkH2YJj/Q3ZasDFhcUFg0NZQI3o7e6vI07CcklsN6grEszd
	XMp4V6fdGcSFsvBNSk3fkzEkK4CwWb4DIAk+zxZXx/zthyCKI9cXIba6jxuu18fng511AqpYwjw
	SKgAGzrRWq7kvgw7pz9imt9tFLmz13BCfcZJdUXK1AQ==
X-Gm-Gg: ASbGncs3uDMU3wVTqnM2EX0YB4O3UemmqvtMZWqrW7EfOystap9DEu1+m468PfpTKnS
	7CJF8DvgzGEe755V6Tka1MYIlqZwdR9QgpX7MuL5D8UqMhd7vm2HC9FrBRlYi8FTI1mIROvqUaD
	hOwbygFqVugCI1mA94707YhIFoxkOk+mPvp82BrPiN5h1t4SzinVLic1SOue391n4QSSoCnmRtU
	e7D/ryj
X-Google-Smtp-Source: AGHT+IE584Lps5ZJGPPasz2qjXvE1uln/YoeKZ+NEr5/UBb8mlMMaF+8xE4Mk12v0EiPPAIF33QJj8U3svU1V3OfZ8Y=
X-Received: by 2002:a05:6512:3411:b0:55c:e5c3:1a44 with SMTP id
 2adb3069b0e04-55e007db76bmr626581e87.48.1755597435230; Tue, 19 Aug 2025
 02:57:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy3omyk7YGVHNV5mgR13cON1SxdpqsxGQJsWWE1Hoyw=5A@mail.gmail.com>
 <20250819012558.88733-1-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20250819012558.88733-1-fangyu.yu@linux.alibaba.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Tue, 19 Aug 2025 15:27:01 +0530
X-Gm-Features: Ac12FXyTUxSpF4ciP7rx8i1SvNQzuuHLy0NA8cpXjF9T81-EV5Hi44pHTVwLXYE
Message-ID: <CAK9=C2XN3izaV_cB5dTkRD0FRD+gqdRVYWKxMAuaCG+LP3D2aw@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Using user-mode pte within kvm_riscv_gstage_ioremap
To: fangyu.yu@linux.alibaba.com
Cc: anup@brainfault.org, alex@ghiti.fr, aou@eecs.berkeley.edu, 
	atish.patra@linux.dev, guoren@linux.alibaba.com, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	palmer@dabbelt.com, paul.walmsley@sifive.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 6:56=E2=80=AFAM <fangyu.yu@linux.alibaba.com> wrote=
:
>
> >>
> >> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> >>
> >> Currently we use kvm_riscv_gstage_ioremap to map IMSIC gpa to the spa =
of
> >> guest interrupt file within IMSIC.
> >>
> >> The PAGE_KERNEL_IO property does not include user mode settings, so wh=
en
> >> accessing the IMSIC address in the virtual machine,  a  guest page fau=
lt
> >> will occur, this is not expected.
> >>
> >> According to the RISC-V Privileged Architecture Spec, for G-stage addr=
ess
> >> translation, all memory accesses are considered to be user-level acces=
ses
> >> as though executed in Umode.
> >>
> >> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> >
> >Overall, a good fix. Thanks!
> >
> >The patch subject and description needs improvements. Also, there is no
> >Fixes tag which is required for backporting.
> >
> >I have taken care of the above things at the time of merging this patch.
> >
> >Queued this patch as fixes for Linux-6.17
> >
> >Thanks,
> >Anup
> >
>
> Thanks for your review.
> I will send a v2 patch to fix these comments.

No need, it's already part of my riscv_kvm_fixes branch at:
https//github.com/kvm-riscv/linux.git

Regards,
Anup

