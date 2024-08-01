Return-Path: <kvm+bounces-22959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 220DF944F7B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:39:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5314A1C23A01
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 15:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8EB1B1505;
	Thu,  1 Aug 2024 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PtK89mur"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4979213D240
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722526790; cv=none; b=fThzOK6ad7QDoEvTEiFhs4wjppT2/bSWHF5BJqyb4BZJG/aW2t/pUAJ6lEcVKAevblbbuxHnV5CUxg24cRqjmg/HLHueJ5mThuvthjX+4GpLPUWh7W8wJniXBUCHut+POzTpiG8FfIdXzAtk9T6zYRXIOOKYiXekhf36p1D3mls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722526790; c=relaxed/simple;
	bh=Fars94PR2I1z6GGDqirmQhcGrg0IRY2MO4vQOMYyXj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hmQvTSZo8PrvLfE77+9nZ4cJXglCgJpBSQ3SJ/WmJPzAywZqvOheB3yDu34nAukqis9U0mUY0tA0fFbe06v5ayVyjWQA6eYP4LUPFIlIlhOgwuF8VcMqwlRyxhfd+/aC9HdwWHjqJ4bxCUwl3Lk1QSMKqQZsxOwMn6tgkUNfD1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PtK89mur; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722526787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cvtcL26MELukLXBLKiU1OvgArmvH0sx0AOPSGAsOPYQ=;
	b=PtK89murbmqpf5X7opHSGe0ko272oJBhFrenHW8y1gIdtzOQigTYEhf/5h2y+LiVx7yE+I
	G1kve+Z/7x92l7sdctXxgw2UnAtCuSY0J4IPJC4oRW1X2SP0i24DdUIuH31obKpLWgdl9H
	UDbHc1TEkobntn4PFpr6i4k7i9PHqaw=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-6iHOP8tlOoyOXxXEAG5WGw-1; Thu, 01 Aug 2024 11:39:45 -0400
X-MC-Unique: 6iHOP8tlOoyOXxXEAG5WGw-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-64b70c4a269so132736927b3.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 08:39:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722526785; x=1723131585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cvtcL26MELukLXBLKiU1OvgArmvH0sx0AOPSGAsOPYQ=;
        b=BmGT/47n9KfQNxtCT5N3kjQZY8dxH7LWyfuzU8uLq89UcBtt/nCkHs6I22neUuWpH4
         shCtWC8fxO0x8gjymKUwZxOv1S8eRVs5NIvIMIDk/vGtYbA52rTxPPSGkSkUNxklMKZG
         lhc3/yyYT8B9BkZ6y5KwitjJHRCiYRQoslOuOY0kPzi1TOgMpq53J4NH4Sjj0sdkalAS
         YCjQK+o+vimpsXOKvC6zMwIZrVwm9forrQNpCI6FO1GcjsagFWTmfYC5KmmPrnKSzX2g
         +IEc8bPGO8FCxj3zgYEd6nbHV0yAaYSAeRrHLxKKqsiKv4gsXdpcgGD5rB+3H7fZj5tJ
         XncQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGoMCl62DssrX2trPQBnnbIsviIFISsrZfUBHWj8Eeg4bLVNDb7FTKpqfQ03FO2KU1d32dkT4UjZ8Hw57O3MPs5yqm
X-Gm-Message-State: AOJu0YwfqazzJ1WIkkk/yFrWoirUaoymrQ5KIYKgn/zBA9P/Q6ZF31bq
	VrN4zQPPYEuoVNRTU67otQaS9/jh9Ds3LIh+Z4roQEIhoUM9eADNAIG9xNRCHSD8qm5iKP+O5jH
	Y98TIYrT9lK1dXKJbYYujI5/wRSl30zuJ7BVPJcH+klQxhELF4sJQmWhbhLNDbb+znkCrUe1aUr
	98Rv0BgJrcd+qQUDRgmelVh4RG
X-Received: by 2002:a81:6ec3:0:b0:65f:851d:8fb with SMTP id 00721157ae682-689614169ecmr5418707b3.19.1722526785276;
        Thu, 01 Aug 2024 08:39:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEstoQY1wa9dYRGq1XTayGmAh4S4JQ1xiqn++gZGCkL13Di/n3qojj4QYU6j5a+xzQ2XxaZWOdBKgFbysxmOk=
X-Received: by 2002:a81:6ec3:0:b0:65f:851d:8fb with SMTP id
 00721157ae682-689614169ecmr5418347b3.19.1722526784938; Thu, 01 Aug 2024
 08:39:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240726134438.14720-1-crosa@redhat.com> <20240726134438.14720-8-crosa@redhat.com>
 <Zqd10nIix4gXKtDw@redhat.com> <63ef2c5b9ab213f544173df027abf5b056d59e8a.camel@infradead.org>
 <87wml0coat.fsf@draig.linaro.org>
In-Reply-To: <87wml0coat.fsf@draig.linaro.org>
From: Cleber Rosa <crosa@redhat.com>
Date: Thu, 1 Aug 2024 11:39:32 -0400
Message-ID: <CA+bd_6JNRhj4K48Fg_yb7KeXmEYgzxyT1NJJJ6K0yFxamc9UwQ@mail.gmail.com>
Subject: Re: [PATCH 07/13] tests/avocado/kvm_xen_guest.py: cope with asset RW requirements
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: David Woodhouse <dwmw2@infradead.org>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, Beraldo Leal <bleal@redhat.com>, 
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Leif Lindholm <quic_llindhol@quicinc.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org, 
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org, 
	Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 10:26=E2=80=AFAM Alex Benn=C3=A9e <alex.bennee@linar=
o.org> wrote:
> There are no real failures with readonly=3Don although you do see init
> complain a bit about not being able to mount /dev and open log files.
> snapshot allows that to happen but doesn't change the underlying
> storage.
>

I could swear I experienced failures when I developed this patch.  But
like your patch b9371a7b90 already fixes it.

Dropping this one.

Thanks!
- Cleber.


