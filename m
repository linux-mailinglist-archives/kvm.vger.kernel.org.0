Return-Path: <kvm+bounces-48857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A34D8AD430B
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 138E53A4365
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1322E26463B;
	Tue, 10 Jun 2025 19:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zOQqV61y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E129623183E
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584594; cv=none; b=XamHFQMoHVY7O2Pz7jwYRm0ez9a7mV8lrQBjAkiNsnCvRy9VzUbJsgUQz4dCZ5SMiLA/wFMczlI4OS09zsGyZNodQqB1G7L4TyXEMqM+0lSYTk5PIxf2nuo6IhSecIJyW1j8Mq2+YmZPdw48lWARGbY5pV37LH2v4rah7jIJpWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584594; c=relaxed/simple;
	bh=0c4rPH09asJXG7YXXSkO2KJHIE0PX04aAx1QJP866XY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BT8rDGjAXgzzJj+VtqqISMH/445LZJ05thE45ydEW6xgJPkAB9mFwvDvNeJ7Kmj9Jslmqsh41cS5AUypdkEsrXyZ4HGoXhgGHlH9edUgF8vD5O5wJi8gDxwv5UyLs3/9q8yEAjqbFMTV3havm7O41M2h3LBffnDyyz9qsAYhbkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zOQqV61y; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313b0a63c41so132050a91.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749584592; x=1750189392; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hmaECZdQgVpnbqKpacCwmV0F92qLsHmVnXr19AYpNOE=;
        b=zOQqV61yWeKv1s+s+IGF9I+meMHKZCU3R/N1SLuTG3t0bS2r60J1EBQSMKayYzLsFe
         syoF6gdFRMtzcne0CcsMm0VMt67dmdcpxrmnx0fdnuze+7VYBIx62g9U1HQGWveEUX/S
         bTVyvDRS/d+h4nhkE7OjtV9lbZ8FURTgDBMRcWmMVeEp7LV8vVcfOFzSfuw9bVKohTvj
         pSH1COjbMhbf9gppXcAGxacS4JKsZPHma335y8sY1HvPD9Dxl05/43B2KjbYqkRjpO8p
         ch3jho3KgGIMs5WPd2qh/ox7ZJQojU1aypqykC5C0mnbf8W76t7fIOVuYQ/r7nP71qe6
         SoRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749584592; x=1750189392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hmaECZdQgVpnbqKpacCwmV0F92qLsHmVnXr19AYpNOE=;
        b=GvoekaKFUb/gEpo5ckjBdYMVeLz0BvyPz3RuqlglmoMzdwJqQJxmNRiTahpTRb7b3L
         sX0XL2ZU6CEzOm7KDKs/a+Ypd3Wfr1PMamjSMed7KZWOWSCQFdsH32ZGnyHOVN4DIoS4
         SiRzAvDGlBWkaABFwGD4FUROH7rJAWMOgfuJIXzwJpaAtn+6EZr+P3OzUsD4uf/soB1K
         ZFJQZk41clxEvHr+K5o1eRw35ZqOCg02gqWr9scuR1tBGaPTcKfGI7qLLk+Bo1pLFD18
         Yeu0+AR3bIq2SYhpWLOTsKRw9VK6TQwBaHVpX51BNdGLSXHI9bVJEsShNzXhXUJT1wy0
         oSVA==
X-Gm-Message-State: AOJu0Yyx4b5OlX6bnWdhLmQKvFZ54P0Mqmh9HbWCwd1hX8/LLks5sAli
	+kDNuXhObNYaH37XrdiEWaXdAMQmiQkRu+fV4tZkLsR0wk6kka8Dr6Ksde1IbW0pStWqK9bWaX9
	ZIc/J4g==
X-Google-Smtp-Source: AGHT+IGkSoBtHId5C5f6OhGUVmAogJdcd8gv7uyBw7/Kf0Q6iKTX2ZTseGMJj1yn1BC7RDPWdWv/6Cvyd5g=
X-Received: from pjq4.prod.google.com ([2002:a17:90b:5604:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3dc8:b0:312:db8f:9a09
 with SMTP id 98e67ed59e1d1-313af138589mr1116307a91.14.1749584592249; Tue, 10
 Jun 2025 12:43:12 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:42:22 -0700
In-Reply-To: <20250604183623.283300-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250604183623.283300-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <174958166537.103331.16507879982050606724.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/6] x86: FEP related cleanups and fix
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 04 Jun 2025 11:36:17 -0700, Sean Christopherson wrote:
> The ultimate goal of this series is to be able to check for forced emulation
> support in a nVMX test that runs with a garbage IDT (the test currently
> assumed forced emulation is always available, which fails for obvious reasons).
> 
> Getting there is a bit annoying, mostly because the EFI path happens to load
> the IDT after setup_idt().  I _could_ have just tweaked the EFI path, but opted
> for a slightly bigger overhaul, e.g. so that it's easier to see that the BSP is
> responsible for loading the IDT, and so that setup_idt() can _guarantee_ it can
> handle a #UD without exploding.
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/6] x86: Call setup_idt() from start{32,64}(), not from smp_init()
      https://github.com/kvm-x86/kvm-unit-tests/commit/588887078688
[2/6] x86: Drop protection against setup_idt() being called multiple times
      https://github.com/kvm-x86/kvm-unit-tests/commit/3fcc85172af3
[3/6] x86: Move call to load_idt() out of setup_tr_and_percpu macro
      https://github.com/kvm-x86/kvm-unit-tests/commit/27fe927996be
[4/6] x86: Load IDT on BSP as part of setup_idt()
      https://github.com/kvm-x86/kvm-unit-tests/commit/63f9b9871322
[5/6] x86: Cache availability of forced emulation during setup_idt()
      https://github.com/kvm-x86/kvm-unit-tests/commit/486a097c9842
[6/6] nVMX: Force emulation of LGDT/LIDT in iff FEP is available
      https://github.com/kvm-x86/kvm-unit-tests/commit/3d677db42e66

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

