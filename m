Return-Path: <kvm+bounces-31903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C1929C9677
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 00:52:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 509032837CA
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 23:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 163BC1B3938;
	Thu, 14 Nov 2024 23:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DUyGcHA1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CFA1B2199
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 23:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731628343; cv=none; b=igHZOcEBrP/KD2dCetM8gyCVxhaNtuvQObKFPawqV7kIMSHrzNsjzvzkNz8TuQ5W/AyAqGa4jYuqRomtpJF00szQfilzdnbQSBe4aIxJ8YCTNZZlqX0InyMGVcjuEHftKQ3OM4sy0oMZtnZeuNisdQsk94wQg/p8Bx0AiQz0+tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731628343; c=relaxed/simple;
	bh=OWhWU5TJjSFr/WTThMx3ddMOcX6EbmmOOWkxkpTpyeY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LaVvPiDa+BE2p/PmMDMid0Ypsu+sdWVtiCzhahi6Gl6WKPi+hNYOg6aQZQwu9WxT5CX5R+6YEzxy1ehL8sLMymjYMl6dpyryCcO9cv6sM5snlj6W54r+dv4j9mZ06TeA2xdqHEZDwBNwBi05JvMMOjPUhRViHWDxxIGX2mKGH0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DUyGcHA1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731628340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OWhWU5TJjSFr/WTThMx3ddMOcX6EbmmOOWkxkpTpyeY=;
	b=DUyGcHA1IIsmHk2ViLjSkK9W+fS5fiBjV92lkWzsARcUzDCBIJZwW9HiON3WcqcWRUZeZl
	Y70Yxz5llQkSzRsf7KlNXx7nJ0ZpKzk84Fn0BdL+hkAFzqsLDFOaot8ZB65hPi9Vr4ft4D
	ymvRLms4A+SWs+EKwN+dxHekqFgMIlI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198--r0pPo_vNVCoR7jrm2KbYQ-1; Thu, 14 Nov 2024 18:52:19 -0500
X-MC-Unique: -r0pPo_vNVCoR7jrm2KbYQ-1
X-Mimecast-MFC-AGG-ID: -r0pPo_vNVCoR7jrm2KbYQ
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4314c6ca114so856895e9.1
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 15:52:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731628338; x=1732233138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OWhWU5TJjSFr/WTThMx3ddMOcX6EbmmOOWkxkpTpyeY=;
        b=NS6NP0aS84ga39fBeX9+tB53Reyu/vmSrzl/rPdYDDOmbXNZNdHq/msIBO+uOKwItw
         FY5r+vbxUgWlRbpDc4EItm/s8tkoz2JHLy5/gg/eYm6qETa55nUyr3/842u69Jdg6KEY
         Wt2A/Cic6vlvuBBdM3b8cAvmsPW5MhiLeQHi7Qvcw452WQ1+XCgLOyXAmD5mXkPOF5Qr
         OuehrmAot3u8x7l8bW7pAjsQuY1W/SOeoA0oLevd0J5wgjx7KOZW67ptbsNxt8utsjVs
         /ffcV3XKThkrAjB5caW5VJnhA6WWIQ2JmB6Hy16THBe+uXsPQ7zCcW+oWkOJmSZeWwqA
         nLdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdT6T8859nGMDfTqK4kymeOyd+k7AjjU0yd94iIeAH8HJnF0C1HFzY3+gjnnSmiNRkBGI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkbChA6W6KXKPYvPOL/bA42Qku+tPjOWxnJuHWH0R3YL6xMbEs
	XSYFADwktsu6CVktEPOfLwEeS8cyLugdca6q3obmGtJPNYFAEjgVsRd3BEF3Xbn0sYc/23K7hF/
	1dzuKl3GIjXjmxEsWEENG7IlQ5PvRv7gMdaZ9UnJCebXbUhnogSjzfHHXKgKbMlKkADOcZUW27+
	DAASoQdituogPPBrihb8RRGtcB
X-Received: by 2002:a05:600c:1d0a:b0:42c:acb0:dda5 with SMTP id 5b1f17b1804b1-432df7179e0mr3560385e9.1.1731628337863;
        Thu, 14 Nov 2024 15:52:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAQ/+RoxVs0vHvYr1XYzFgBnN9Ums1L7EPUhNDyuddygRScQcWTL/e3tfVEse8FhrjPmq9KxM5hC3qM0t37CM=
X-Received: by 2002:a05:600c:1d0a:b0:42c:acb0:dda5 with SMTP id
 5b1f17b1804b1-432df7179e0mr3560245e9.1.1731628337401; Thu, 14 Nov 2024
 15:52:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZzWo7_GSUNXe7Ip_@linux.dev>
In-Reply-To: <ZzWo7_GSUNXe7Ip_@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 15 Nov 2024 00:52:05 +0100
Message-ID: <CABgObfa=5oeRF9a1XmTyAg7psAzGzaHWnCaQfXBts8=SJP_n=g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 changes for 6.13
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	James Morse <james.morse@arm.com>, David Woodhouse <dwmw@amazon.co.uk>, Fuad Tabba <tabba@google.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>, Will Deacon <will@kernel.org>, 
	James Clark <james.clark@linaro.org>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Sean Christopherson <seanjc@google.com>, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2024 at 8:38=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Paolo,
>
> Here's the main pile of changes for 6.13. The march towards implementing
> nested continues on, this time with the PMU and MMU getting attention.
>
> Note I've taken David's patch to use SYSTEM_OFF2 in the PSCI driver to
> hibernate, which was part of his combined series. There is also an
> extremely trivial conflict between this and the arm64 tree, both adding
> the same field enumeration to the sysreg table.
>
> Details found in the tag, please pull.

Pulled, thanks.

Paolo


