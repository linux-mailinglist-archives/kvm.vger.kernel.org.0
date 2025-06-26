Return-Path: <kvm+bounces-50904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66CDCAEA858
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E92E4E0E30
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E80952F0E31;
	Thu, 26 Jun 2025 20:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NSlfl9Fk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862482F0C62
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 20:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750970649; cv=none; b=CIw9ZE34rD7X3msKsif/M5vlk/58TaTghC0ne/2HZilWlAKMfgbsqIMh9GMVEiTlQyytM5DK5EZLkb6RURe2E2LTkhdHPlCYw5yclNZrdUtLibFz47khYeEudMI3k3cjSz5UMJPuI5DB9aDddoBo3QobA2EM23LhrzoaiX146Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750970649; c=relaxed/simple;
	bh=6AfxQUVh5YrbfQXfMMEOfqQHhWV7YAeM70L9oR6/MOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lt2ebZdgRjdTbJqvgWlxVaDU/naQgl56elPfQYHxCnfVCus/cpjlDaKvWKfRjOzG4H1XwrKcgbDGMfjrp2qC0LtXamO/OJu4w1L1Iab0nNg+f4qsT89xDHE2o7u66XM3sf1dPydkX4bqNk7WFKQBAykc9LaXLTamzzvMko+LZes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NSlfl9Fk; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6098ef283f0so3639a12.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 13:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750970646; x=1751575446; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6AfxQUVh5YrbfQXfMMEOfqQHhWV7YAeM70L9oR6/MOg=;
        b=NSlfl9FkeqAAs+xi0Ep1bSfwYoJDBBxzDhHvs2Sd79lY3ieV2cOendxwbXOiPz49Pl
         agVKaHuigdib23vZXRVwFEThvPTtVdhlankz+jhwyNjJqVa/VZP0/oLBoE9Z/tr5c0dy
         GKOAhm/Sw94PKeRfUDta0NPJ/Moqp0dwmNYyjjhVqDfWcwthT04KKAuV28GlXyQ+K8ln
         /Oi8TQPT9JQ6ifKTuhjFE7SE6i/xCvDJYJ6+xbulV+j2o3yZD4GS1R5mEjVCMeuC5Gnk
         k/Y6uIqpF1wAwfGATzsPYZyh716B75Q5T7I05pFKQoxSC5J5k2Zj7bBM4XwDilvJmsY5
         jqEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750970646; x=1751575446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6AfxQUVh5YrbfQXfMMEOfqQHhWV7YAeM70L9oR6/MOg=;
        b=MY5VJX7mYfJDKvw3kOWW8L9dZaURrjOtG2Bu/ybXbYKd3Foiu0SNrtWgWwlGXUSuh2
         1oJsMgOSNxXR4ZoqXLwxl8DHweNvwLrJ/fMEQb7EEP1WF4ZRhik1fjHYcsMq+C6oFmtS
         itkAXsKODy28peIOQK1vy8jMDlmUtgQw2fIF4QvAAJfGGNbkuS0pCqnWUrrA0GJhfYfU
         4oJ+Yc/aHECNJXv0L2PSvkoZC4jD0qi6NQ5mRZ6ZHuQWJqbzJfBGmQh2+QYhQvA8/XXP
         640z4+ic5OxGOq2uxysWHUdPE7HkJxo/VmVPxlN2aVIk9Oh3xMQy+/PEVk0+hQKYXEbR
         qlwg==
X-Forwarded-Encrypted: i=1; AJvYcCUS40+2FFaLUjf439D3suV+ZMvvX8BV75Rq/LRsGjfHbg7irMvnHOq9qRw3Ue2Sa4J0CX0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx0YIDcNZZddP5/2GS7kSYBv2fgx1J55x1DuTFAjEamwtl44MD
	fvK2qBwG2rcRUaXOAKM/yAB3O7UtKethuzYQEtW72C804VVOPrRi09mHvrIqf6mgPIEJcu+3MpZ
	HEfVvNAqiSYNrF3zZiHcd9nHO3odlINPhurw6m9m/
X-Gm-Gg: ASbGncszvFDh0yulzvCz4ueFFXEi70yYtermmYQYmZWlHxazmAac6n78X9kSPOUvQis
	CR2vk6fNdkoHAzdsr8DSdciteBAyOW8bayUBgDILj82KSg12hlUkLoeTagG1fwP/sZImm7zLSCD
	Q5nSaN66fqgKYiSnON1GE+OdsFEx92wpqICUHqr4/ERyo=
X-Google-Smtp-Source: AGHT+IH8BULP6tAu0/3WdkDsshXgjY0PeHI7oDdXj6geSIlN82xNwEgewL/ZIIFlgcnyKvWjE7iQMlLR2ZL+9a3lNOE=
X-Received: by 2002:a05:6402:4542:b0:607:bd2:4757 with SMTP id
 4fb4d7f45d1cf-60c8e19f563mr1044a12.1.1750970645680; Thu, 26 Jun 2025 13:44:05
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250626145122.2228258-1-naveen@kernel.org> <66bab47847aa378216c39f46e072d1b2039c3e0e.camel@redhat.com>
 <aF2VCQyeXULVEl7b@google.com> <4ae9c25e0ef8ce3fdd993a9b396183f3953c3de7.camel@redhat.com>
In-Reply-To: <4ae9c25e0ef8ce3fdd993a9b396183f3953c3de7.camel@redhat.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 26 Jun 2025 13:43:53 -0700
X-Gm-Features: Ac12FXxQf31QSY3c-WNUJVKfbSYSN58wqYVk4ZyE_IkOT-pI4A3uvkUnKaq-8Xs
Message-ID: <CALMp9eQXkd=3nAaWzg_V4rM2wx=bxyZhXgGLXN4x9CAZG3_O0Q@mail.gmail.com>
Subject: Re: [EARLY RFC] KVM: SVM: Enable AVIC by default from Zen 4
To: mlevitsk@redhat.com
Cc: Sean Christopherson <seanjc@google.com>, "Naveen N Rao (AMD)" <naveen@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2025 at 12:15=E2=80=AFPM <mlevitsk@redhat.com> wrote:
>
>
> I also have nothing against this to be honest, its OK to keep it as is IM=
HO.

I would like to see it enabled by default (when appropriate) so that
we get better coverage. Of course, we should not do this before we
feel the code is ready.

