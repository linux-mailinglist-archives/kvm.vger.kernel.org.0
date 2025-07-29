Return-Path: <kvm+bounces-53589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC2BB1454C
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 02:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B0633A5E3D
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 00:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7991EAF6;
	Tue, 29 Jul 2025 00:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IuZCEYh4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881813C26
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 00:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753748397; cv=none; b=B97UHFqAqcWMoFULvmpQ32WIvtinW5fECjFFyM25JmU4yG/JV6opmWAbDK+Oz31dCC2SbWnRJJENz0TV88Fek8Z32eIOoHU/XAFiiATsbvwqUawPojC4sYbFqdKA4RXvZf7jgc63l/pIPeNyNE16AM26TbM9KdDBvfoOoMWgqTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753748397; c=relaxed/simple;
	bh=Ltl2zX+6d4jn4+SNiecloXuOhL+aAakR77QdlUu2/4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZXWpmExIGAZjAoI2xh61oN4MiojcZCq9W7Ohqf05nmmcmAi6Lk2PWiCJ3qZ+trf34xxNj7e3WEpd0F5ZxwRxO40Obe112cWHIcta7UMA08ilRVNnlKix2cgvHDNXuWgBE98zWD+PSXlYhtdyv1gzbZZ1FvDi0n1FYGHj3dk7AHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IuZCEYh4; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e8e226c3255so727292276.3
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 17:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753748394; x=1754353194; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ns+jOKj3ePiSkamR9ZiPL6yGBf8VxECwOfrYabjb7vc=;
        b=IuZCEYh4JmSzUhRGmC+gSNIrkVFuH0mlDkGAyRs7zN9XLMzQ5co3C47/IqF+7Z31kn
         maInCrLEz5bVXCkbMrlkMJENXqpsa2UCj0QdWRBLYl8B1/mrVJU2gS4a8ROpAjAAqr80
         fF1x8dxuG/D5eWgdIGveHzoJQRhhiGiFavZZLjfwWLAjjj1+lqobbBkPEO7yawAQFaKk
         RQIcrttW63cJe1GeJJBnov3ko+tfIKxbCaDUqNqilHntth5nmzZY+PwSlEbBuf/P948L
         8irT085cgYSeZ5bkDdibsKznsOJEexlSI0vKPJmAR0GhwdmxDlWOW4IcX4R0LpsHjnrq
         v/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753748394; x=1754353194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ns+jOKj3ePiSkamR9ZiPL6yGBf8VxECwOfrYabjb7vc=;
        b=btT/Rg5G9igTWI860MMM2Od3+lxohm6OVMBWz3Ku1njkis/DTfSGpZBd4dFbV27hmD
         KTFQuYxbBpGCOapeaqhrxGtgD814qTTT6kizIH8om2T1lMySBVBy48J/tf63gm3FSP1X
         9ryrwlZna+zI8mDXKRZLqUPDL3YMhrxqFP4WWj9CZOZamH9cqqwHn0OJ3Ae6QYwjFuAd
         t/pBomD2ohEaxu6NFB1ABnPaQ2LQlsACHqUKVVrigf0X5yVmVuuRrO/hnYg6VZQ2R+46
         tQHaoZr84V1LCinam4I+FdL6/sGXRYyHm9a9gajS4BczZn+nX9z6mYMxsHBFhjUUlzHl
         5l5A==
X-Forwarded-Encrypted: i=1; AJvYcCX/3M4BTRWhkPQN6RddYnTjUI+ymn+7iXlhsII4UsHDinvXHmmnkE2G+6e82QU2gmtfAtU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHzgpfAIBL38OAulfkMUXm6QSJdDjzOHR2i+uKRf2pCyhurIps
	+kw7UzxkhQoAo215vHva9MS3UIQ+W3RkqJXe0pbXFTTwEpYEwm+awp9AYhGfp3Q86pQOrIKGKQM
	sq2IoCmAO7eSe/g782kjLKDFRW9Syiel3EflQGL9P
X-Gm-Gg: ASbGncs0cl3oNEFsDf0SqwiFRuy0jxEm0YnD1OPdgyDWgLCsoBKZEsiqiF7zC6HTp8d
	RisD2JcgOt7l4r43P5VGCxjrR3KvSeOh0kGnBToN9p/sGldGOzqGIG3vED0mzCe/ry4oK3tcxkV
	DBZM21sKBwGUBQHb1DQEuP4CPaqF8AxlYcDNOFc1GAM8v4NBHQxlssaVLQdLBey2h8lbFr5qGYr
	AxxzljxJEkC12RNf5BRjXhzQSjc58378mR74Njo4IOZlNc=
X-Google-Smtp-Source: AGHT+IHDe49xBiWLPDxPkbcKw2j/I2J1CIgJv9DX7+7Uv+/UcTlFKQNOgZ23ID3H2fDDlmmr5qGtav5j0AieL029dvQ=
X-Received: by 2002:a05:6902:1403:b0:e8d:b7be:b7ea with SMTP id
 3f1490d57ef6-e8df1159084mr13244312276.7.1753748394110; Mon, 28 Jul 2025
 17:19:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com> <aIFJsLFjyngleQ7S@google.com>
In-Reply-To: <aIFJsLFjyngleQ7S@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 28 Jul 2025 17:19:18 -0700
X-Gm-Features: Ac12FXyd-D-Pmm0BbCyXt9t5LLwdGCSUomWA7gqCsnVCIueVkqUlXtePHYs3SwU
Message-ID: <CADrL8HUB9Nhtqu+b1HhfG33Wt6wkp3LYkxSa7Nv1GbX5+Vj=vQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] KVM: x86/mmu: Run TDP MMU NX huge page recovery
 under MMU read lock
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2025 at 1:44=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 07, 2025, James Houghton wrote:
> > David Matlack (1):
> >   KVM: selftests: Introduce a selftest to measure execution performance
> >
> > James Houghton (3):
> >   KVM: x86/mmu: Only grab RCU lock for nx hugepage recovery for TDP MMU
> >   KVM: selftests: Provide extra mmap flags in vm_mem_add()
> >   KVM: selftests: Add an NX huge pages jitter test
> >
> > Vipin Sharma (3):
> >   KVM: x86/mmu: Track TDP MMU NX huge pages separately
> >   KVM: x86/mmu: Rename kvm_tdp_mmu_zap_sp() to better indicate its
> >     purpose
> >   KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU read lock
>
> The KVM changes look good, no need for a v5 on that front (I'll do minor =
fixup
> when applying, which will be a few weeks from now, after 6.17-rc1) .  Sti=
ll
> working through the selftests.

Thanks!

