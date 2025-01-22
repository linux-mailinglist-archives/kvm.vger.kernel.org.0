Return-Path: <kvm+bounces-36233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A92A18DFF
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 10:01:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 337431882961
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 09:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856491C3C0F;
	Wed, 22 Jan 2025 09:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G2dHyrP9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D81A1FAA
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 09:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737536471; cv=none; b=hswjad8uoGsoOJOPFvX/S7insHUk/LdszqTH7acMkgC//MGlRx490PH2F+N8M8jbvaG4j4usEYKl28UPoI3sUBHLtXv0f5jC8r8iKkGA1B7fBtmkxwx408bciwpCyGl8wYffRQWO6LIxxbZh/7Wid4+ffKTkKtU9F3BUVtFmNnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737536471; c=relaxed/simple;
	bh=yJoB/l2zgEIpfda+tllzxi0+NYyzT021Y/mneEU8K/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lz97XScsy2QFavgPGsfEFD3voTDQ84Sh5yKtEQxKwF+uPSgjxfTD925QTmA60DvyxDeam5gdLYnsWcDt6yglNOuVu2d7yhsFrSHdwaK4W8jogXt22SrRbuzgoBqJ2VkpxRFbl1m6c/40aZ6WnEMiZVLJ6Wql/OkzahcIWgHKpHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G2dHyrP9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737536468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kOGyU/Qv4F7f+lvHaCoz7+BlEq7z6iiiqFtyrBdQXfg=;
	b=G2dHyrP9L5aQ6bU4F7ue3UH4s8A8uika6b2lg0m+zCt/PzU6X3vNSHL01+FrLwAz0HF1Ln
	1l05f7So+6WOFmqWChAeC3DR2gFv3AY3XIZF76apmvnKEqEz8OwPhtACESWtP25zYz6F/g
	+seuuIiJSflgQ5wBnknb+3WDdKx7xj4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-60TglZLcMcuP1o0jklmWHQ-1; Wed, 22 Jan 2025 04:01:06 -0500
X-MC-Unique: 60TglZLcMcuP1o0jklmWHQ-1
X-Mimecast-MFC-AGG-ID: 60TglZLcMcuP1o0jklmWHQ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361fc2b2d6so36372705e9.3
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 01:01:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737536465; x=1738141265;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kOGyU/Qv4F7f+lvHaCoz7+BlEq7z6iiiqFtyrBdQXfg=;
        b=E5CtI2n4q7YaFHf6mnWigFVGTApjh7opYCqiu9b0FG4Q68qAc0Kl6Wjyzqtm1tChYd
         pd6vrSOzmCmzj7uRzTOxV1nFlHZY8ThzMD5xOqrrBOIvi/88jzc8bYdGqw1FovmrU2KK
         TAhy6ZnEYZaIk0aEl6BJ08j8r6XbPkytEmZFHoqezWCFcTvY2yGiRudIrcy9e0BoBZ5F
         hhnt3NxtB8GWwRmLK+t8sswUoJtiS0TY/xWdNHt8MWhISIoVP2XxGNs0+RU9rUX56eyi
         PGkIygzyyJ3ENRPvbkDnToQCjVgK6fI2Kamz3lXoiWIlvo42b2SsDz8pQKJyOG/k8T5O
         h+tw==
X-Forwarded-Encrypted: i=1; AJvYcCV3clbweCayrm9AF85J03fMx3Jo8eHgAUTiwg8BxGZnh4tSmnyikUEECQZPIKLICavRalE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhC88PvOhiQ9F00UzDuwk8jvoBxxVrL4jvgv1nsG20aw2baDr/
	6b36tf1ondhwdYO6cER/XMjmctUrNVRvxniNMAHwxTB3VunXpf8xEehnMrXE29cn8qV1GqdSson
	rMfPO4d8FdrsnIgsRS65f3S2RZ/nZ6tgurN4kgzdxbqu5dAL4SEFiXB3YWhboOEBEZkC9p9Sot1
	wImu1o5Ec9GzmLrfUFNM6JoNB2
X-Gm-Gg: ASbGnctonWduQ9YIRUDYiJSA+pV4GslXyL1bGEaFh+8/Q5TSGqiJFtZ7NWvmMauoP0n
	20WXN8I2iJXS7QLrUTwIhCUppdYnlNvOqHbJUmEnycQtrhiCXN1UQ
X-Received: by 2002:adf:fb4c:0:b0:38b:f03c:5bb8 with SMTP id ffacd0b85a97d-38bf5662030mr16121347f8f.14.1737536465535;
        Wed, 22 Jan 2025 01:01:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFWjdwPpVQ3zPjUUiH1aNCGKKGyYEP97TYXiGa5cXMLop9c6nFdf2G8dk6wg3yiP0oRfFEHPGYuO+en6oEBAdw=
X-Received: by 2002:adf:fb4c:0:b0:38b:f03c:5bb8 with SMTP id
 ffacd0b85a97d-38bf5662030mr16121313f8f.14.1737536465152; Wed, 22 Jan 2025
 01:01:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANDhNCq5_F3HfFYABqFGCA1bPd_+xgNj-iDQhH4tDk+wi8iZZg@mail.gmail.com>
In-Reply-To: <CANDhNCq5_F3HfFYABqFGCA1bPd_+xgNj-iDQhH4tDk+wi8iZZg@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 22 Jan 2025 10:00:52 +0100
X-Gm-Features: AbW1kvbw2R4ISKjYteP0eYoglR2pZPe62sGfrIdFcRReEPnxwI3UtrKTTtD-BjU
Message-ID: <CABgObfbWqcorZC+1Hjh7SQtn69LE-Wng-wBKOq=tqh00_3R6dw@mail.gmail.com>
Subject: Re: BUG: Occasional unexpected DR6 value seen with nested
 virtualization on x86
To: John Stultz <jstultz@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm <kvm@vger.kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Frederic Weisbecker <fweisbec@gmail.com>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Jim Mattson <jmattson@google.com>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, 
	"Team, Android" <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"

Il mer 22 gen 2025, 07:07 John Stultz <jstultz@google.com> ha scritto:
>
> I then cut down and ported the bionic test out so it could build under
> a standard debian environment:
> https://github.com/johnstultz-work/bionic-ptrace-reproducer
>
> Where I was able to reproduce the same problem in a debian VM (after
> running the test in a loop for a short while).


Thanks, that's nice to have.

> Now, here's where it is odd. I could *not* reproduce the problem on
> bare metal hardware, *nor* could I reproduce the problem in a virtual
> environment.  I can *only* reproduce the problem with nested
> virtualization (running the VM inside a VM).

Typically in that case the best thing to do is turn it into a
kvm-unit-test or selftest (though that's often an endeavor of its own,
as it requires distilling the Linux kernel and userspace code into a
guest that runs without an OS). But what you've done is already a good
step.

> I have reproduced this on my intel i12 NUC using the same v6.12 kernel
> on metal + virt + nested environments.  It also reproduced on the NUC
> with v5.15 (metal) + v6.1 (virt) + v6.1(nested).

Good that you can use a new kernel. Older kernels are less reliable
with nested virt (especially since the one that matters the most is
the metal one).

Paolo

> I've tried to do some tracing in the arch/x86/kvm/x86.c logic, but
> I've not yet directly correlated anything on the hosts to the point
> where we read the zero DR6 value in the nested guest.
>
> But I'm not very savvy around virtualization or ptrace watchpoints or
> low level details around intel DB6 register, so I wanted to bring this
> up on the list to see if folks had suggestions or ideas to further
> narrow this down?  Happy to test things as it's pretty simple to
> reproduce here.
>
> Many thanks to Alex Bennee and Jim Mattson for their testing
> suggestions to help narrow this down so far.
>
> thanks
> -john
>


