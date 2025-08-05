Return-Path: <kvm+bounces-54003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5FEB1B50E
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:36:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7D6618A4B81
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 565BF274FF0;
	Tue,  5 Aug 2025 13:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VQjZth/A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DAF1400C
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754401002; cv=none; b=AS4F5zGYFhRJ2+eQPL5meXoVQBkrwR9eIG2ja/OLj6YBqJfbOC8efmAPMweCA7yFgXNeEo7Tea3Qj9bv4h5waNl6XvB3NYZhIxD1aM6ogmghTwaYx9VszXinlJGUqkDt/CL9+Q0nNVSATI4VvJsOiPkX2z/Xyl1tIXaZgXcnWsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754401002; c=relaxed/simple;
	bh=J6DjSwoZRUXD6cC0Swrx2Kq6FOSNEG7qx/VOWa/IiUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uexng0R7I6TC28uw5gIvPhCCx1vX8KbydfqRAi4/rOEZ9nLwrp7amSge2zpug4pPWo84UHXxZceP8VQJsnCEMvo6RuZf6IGk90Tv+OubJsTDuJGxeUaTvUZ3UYJi3m2ZojTXaSoipyHPdzZdmMpkZS1QxO9P8NRf3QmX403ssoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VQjZth/A; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-af9842df867so109556366b.1
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1754400998; x=1755005798; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DMoGQJPU4f1NGWiqNzClF6T4JpK0+MQSV0Gqu0kgblw=;
        b=VQjZth/AEgV3OIs2otct06jh3IXdKLZZWzAOz7M+QoDA9BAlMwknY52UddJVNtoLMV
         VpxU/oDDzLnVFaZmH6UiCQu2OJKwBQsWoXbCJHZJQixP+STpy4G1jEvOpTfqinAo+tDF
         nH1+RqlX8FWAWIcwYZSV70mKsXTZF9wADfCJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754400998; x=1755005798;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DMoGQJPU4f1NGWiqNzClF6T4JpK0+MQSV0Gqu0kgblw=;
        b=uxUfgKM8tjo3yl0U1lMvvSt6cA0t4UKKDNrthbAbRq5R011lDAHiRw9sbg2E9KfjWG
         B4GWwi1t4wscZshlRaMZrQqDxqilwrs8UiVAqJ8ba29K2GU3cWlhDE8Ayv25dSC2cUH1
         M+ljkmiL2u8N+5mMCGE0oncQHWxghP0h/IyuB27MEWahJCRUupZfH2Vy6VOTovBrRtkT
         rWOt5g/dor23GCvB6V6iRUz2k8U0PdDMW+fRVLretCrILL4l3jobWzf+2wTtOc/1xWZn
         h2S6HqDWq43hLaFgXZ9TOD7GAJKls+3zXy4XqeWqLzj/HYbETvaHqYv5ulsS6O35jFdh
         AHSw==
X-Forwarded-Encrypted: i=1; AJvYcCXht19BMMWPFMMdxJXYJIkSkZ9ks7RP073zi/5IH9SsxXN737EsRLoh++R9YH6sONiiuc8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+jOwD7PE9bdxlX1ogVhxlj4REXKfp5qWxT79z8kkAR668vuYY
	tC04odqbqcNKWIZL6FP/HIZ0v8aSVX/vbFxu2vD4/AHdNJzJl4E0ckOYN4nNNq4b4RCoHmKmAZB
	apCEdxw2O0A==
X-Gm-Gg: ASbGncva/93+DRtvpiWOzt5ogQKyinB2v/HNIZDFehCJddQjS1GUFYvntMKY7ugBEXr
	/EF67z73GoREAbmZxMsA5fB1xc/rARK9t/kk1FTzFrvvS5uG1wUVlujTJUSP8dPyC/Ne1JSXjsn
	5AxFDgf3wE8G0zHbUDm/KtxAlybwMvasiHXcP8Z1M5DS2WgZC0MF40Kmn0g0WM/kNuvgE5d4K34
	CITgPM5ms7q2i+EKXAGqrocZfrFMEzVooGJrpyCKPaJj41I+zrMd3pL72VU55FWPa7U7cEuzsPD
	8x5h8bEYb72KCjIGcunPlxZOoDPOuQQZQng6ClxggkJXP8B8P9LHJbaj1WZskDMXoHpzhHk8x/u
	vIOQR2xleXrVQiyB4PNBO+24x0YyMXORjG7u+3h7iPh3f9x2NwdMu/N2cumK8wVBrC4H9ZeXSsZ
	N6cOo6Emc=
X-Google-Smtp-Source: AGHT+IGrE8mxp5r6bri3cJQ+y+njDxz4Em0cYHePGrPChP9mPaJFyuu1V+mEEHFtjK81c0CVd69OgQ==
X-Received: by 2002:a17:906:d554:b0:ad4:f517:ca3 with SMTP id a640c23a62f3a-af94003330fmr1471521666b.20.1754400998127;
        Tue, 05 Aug 2025 06:36:38 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a21c044sm901469766b.105.2025.08.05.06.36.37
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:36:37 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6157c81ff9eso8171311a12.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:36:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW+/OIvXDIo8NsMtStVv0TIMjEWjXiJxB0oLMRD8IEtb8mhDVpAkYRi7aHdYR5mzE7G+RA=@vger.kernel.org
X-Received: by 2002:a05:6402:254e:b0:615:aec5:b5bc with SMTP id
 4fb4d7f45d1cf-615e6cd3968mr11395134a12.0.1754400996985; Tue, 05 Aug 2025
 06:36:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com> <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com> <20250805132558.GA365447@nvidia.com>
In-Reply-To: <20250805132558.GA365447@nvidia.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Aug 2025 16:36:20 +0300
X-Gmail-Original-Message-ID: <CAHk-=wg75QKYCCCAtbro5F7rnrwq4xYuKmKeg4hUwuedcPXuGw@mail.gmail.com>
X-Gm-Features: Ac12FXyPQ_UPydLfRJMzum57G0PVuq0AJqMF82gLhObs0pxwHXHWtx7lBNKByIg
Message-ID: <CAHk-=wg75QKYCCCAtbro5F7rnrwq4xYuKmKeg4hUwuedcPXuGw@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Aug 2025 at 16:26, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> David, there is another alternative to prevent this, simple though a
> bit wasteful, just allocate a bit bigger to ensure the allocation
> doesn't end on an exact PAGE_SIZE boundary?

So I don't mind adding a check for "page_section()", because at least
that makes sense.

But yes, it would also probably be a good idea to try to minimize
SPARSEMEM without VMEMMAP. I'd love to get rid of it entirely, of
course, but even if that isn't possible, I'd *really* just like people
to try to make sure that it's neve ra valid thing to try to combine
memory across different sections.

David mentioned the 1GB hugepage folios, and I really thought that
even *those* were all in one section. They *should* be.

Do we have any relevant architectures that still do SPARSEMEM without
VMEMMAP? Because if it's purely some "legacy architecture" thing (ie
x86-32), how about just saying "no 1GB hugepages for you".

Because that whole SPARSEMEM without VMEMMAP is certainly painful even
outside of nth_page, and minimizing the pain sounds sane.

                Linus

