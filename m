Return-Path: <kvm+bounces-22953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51466944EFA
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:19:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5E1CB24856
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 15:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23E081A57F3;
	Thu,  1 Aug 2024 15:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hp+D9O48"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE2B13C80C
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 15:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722525532; cv=none; b=VCv6wW1TukEttPHEhHCbUFhL9U0252edOKNqAyInisqDbgWFVR4OosWGVXbmK2NzsWFZ9cVzcx/Usie2KGAsQF50ASYPrifTZS/FnBNXYiFOZAn8CEVI+YSzMvlDULgCqcBBnW6+f+dYSS9pSzV787Ni9Jd3JxVDHR0/Fhr9OgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722525532; c=relaxed/simple;
	bh=Ai+MxiBgXD7ugTJtL5DuEwZ6P34NFPuM6JAQBwECiP4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SOkV8afUzSq9h9Ud8dBHf8hbmi2kLeLcSi3n6PbbhTBSviRkebhQTF1QXi5nKhEcbucZrKHQ94MX5wfAtKCZlj3iF64d1vtkzXHMF9cfxU8KhJ4RvKcCMRBhlPhKc/L9t7a0T8UIvdNppM5O1w4lQq7NrHLYR7lPqN+2WYtL0xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hp+D9O48; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722525529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iVxVy3b6V33WthljR6Bt7cM5dUbZoIOtKUfZg4kCmyc=;
	b=hp+D9O48zHxoFJpO0Kyvwb6Xw7JcX+xP4xkQn3iuqNyh6USd1CQmPGGJF8JoIpEUVZOOxr
	oN0FiDowUDcomfEwb+UwSjPUWZQtBaxnV0atgb0V63Pi0yL+OR7rGcFN9RZWl4B/h4w0B4
	pKBRJ2+Yj31+X2rB8HZn+WSHVfm5mMw=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-wsdKl54yMAirOsZVd9NFJg-1; Thu, 01 Aug 2024 11:18:46 -0400
X-MC-Unique: wsdKl54yMAirOsZVd9NFJg-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-672bea19c63so154694017b3.2
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 08:18:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722525526; x=1723130326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iVxVy3b6V33WthljR6Bt7cM5dUbZoIOtKUfZg4kCmyc=;
        b=lngwCKSFiIR5YS/t6zWYqYZfclw0rWEBZplH8h/pSe7NP9Ak9oZ9WFsc4gfwswP//F
         l4btgT39eFX2Ow0skWlXRsb8bZAqv3ZVkcK75Ub7iCfWPazq4NYa9FNkq6JHuu44AeTa
         jzZEAKnuOr7ede/cQ+XGALHz9mo4++9TTERsFCFxrvfSZ9qRu7tvAJKgiBmoMTIis74K
         Xmof9RHQrMtp/5o4mlkygMzj1n7jZfEyOObUnn4T0OSGfgCAcUSnXuSsYh4MS1uwb1V4
         JTIYy9HuHHJWcOO26nBahj/tGEb2HHs+E+OM6y0PyJrKHr/YQkB4AC29r1dSH9Cbb7UA
         WBMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrxt3kWaPHl5ZPssbs2t599uhj1FwQTAXG5XsQUzD+0vr/PKYnwZ1RBQmS+Um0dmroamchX915ZIqaeY8IZB4UH989
X-Gm-Message-State: AOJu0YxRxn7zxJJrOJl5UzJNmH2uoUq+yc1LmTk0zlrBRN+h4dTUfTYI
	6iZt6wb3DDC6WRM9EHoC5wsibq7LwsaTu73xNVZFEUinZHM1g2KXUtA0mlwXV3LalrZkPFuR5e+
	/WBamjj6kRiZXJj8VarAovdWE1WM9dpftZ0TkdZcjOMSlfyaOTOVRt1bfUUaaEg9bgkB+zN9HLb
	1LIu/EUXGtfzZTsU20+eaJRfWU
X-Received: by 2002:a81:9c0f:0:b0:65f:d82c:af86 with SMTP id 00721157ae682-68960589ddamr4136917b3.16.1722525526300;
        Thu, 01 Aug 2024 08:18:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPbQpozQt07I/tuxDYhb9Y4hIen+QEehNUOnHcwNsaUMUYATiX4RaM/7svtDO6C1bWRm2ZNpuqmvZrduCYmOw=
X-Received: by 2002:a81:9c0f:0:b0:65f:d82c:af86 with SMTP id
 00721157ae682-68960589ddamr4136647b3.16.1722525526042; Thu, 01 Aug 2024
 08:18:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240726134438.14720-1-crosa@redhat.com> <20240726134438.14720-11-crosa@redhat.com>
 <a7f2d78a-4de6-4bc6-9d54-ee646a9001fe@linaro.org> <CA+bd_6L7o05mENKVuLLfMFK9OF6ckU23ue0xmxiWO5oiT4ZEbw@mail.gmail.com>
 <68710de3-02da-4fa3-936c-62c85197893c@linaro.org>
In-Reply-To: <68710de3-02da-4fa3-936c-62c85197893c@linaro.org>
From: Cleber Rosa <crosa@redhat.com>
Date: Thu, 1 Aug 2024 11:18:34 -0400
Message-ID: <CA+bd_6JMb-asEgR2qLcdton9uqY8ubg0gL-R-FfaEhEjiirRkw@mail.gmail.com>
Subject: Re: [PATCH 10/13] tests/avocado/tuxrun_baselines.py: use Avocado's
 zstd support
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, Beraldo Leal <bleal@redhat.com>, 
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, David Woodhouse <dwmw2@infradead.org>, 
	Leif Lindholm <quic_llindhol@quicinc.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org, 
	Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 8:59=E2=80=AFAM Philippe Mathieu-Daud=C3=A9 <philmd@=
linaro.org> wrote:
> > Also, these patches count on the bump to 103.0 indeed.
>
> Then either mention it in the commit description to avoid wasting
> time to developers cherry-picking / testing this single patch, or
> move it after the version bump, avoiding bisectability issues.
>

You're right.  My bad.

Regards,
- Cleber.

> Thanks,
>
> Phil.
>


