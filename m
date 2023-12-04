Return-Path: <kvm+bounces-3382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F003803946
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 16:55:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 802251C20B30
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D38F2D048;
	Mon,  4 Dec 2023 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gQpqaiFZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4CBA9
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 07:55:48 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1d053953954so17834075ad.2
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 07:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701705347; x=1702310147; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cecZouhBWGt/EiQ/BWaOcGVIY9+Efnff7UOIt4tvjVY=;
        b=gQpqaiFZvwjF5lML5pOBG3hzEY5fPSxeti7yiKg9RP4QeNItmvK+wMfwJ8dnlxdMm4
         lz61qnxgsmQQwHxncM+OOyIrv7q5ofLHdANnTuQbN4sWX+ErSan+80V6DIl/mqD/AKYo
         zHoIxnLNdt2397TO4q5zz/vFhQ5NKJMJJu1IZmcRad7G6rSoQUb9Y7YcZsfvj+jHxxQi
         PnhZPv42js7jfdw8yqtuy6p0qWg5lZE41MMh2rHy6XuOFu0M+7u1nPmue74ESu7PB/gc
         i13t4eCMGbC9MI0lqf3kq6i0wP0GmRKDVkrujF8iJM6E1zWPC9EafLQhj7uIMPom5rm6
         7pjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701705347; x=1702310147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cecZouhBWGt/EiQ/BWaOcGVIY9+Efnff7UOIt4tvjVY=;
        b=lvwtkIJtk3xtrZyqSUWD2COO5+nBg4hw/itEfvb68FYgHa8GrbUu1jsFcYsWkUrN0j
         TFy4R8RUU8RseXHeUIgj0cpvRM0J+8jR4xmihqcPgkgQvzbW02GExumNzb1Mw9ja9q0w
         gtSaXAkMUNsI9ECC/LlUlxECfigL+ALVkkXlBynoy6yEfEAC/wnt1TXk2HcZcsczz+v8
         z6ntILzLbbfPdiMjkzbY15/O3dgIneKqdBGnVS43PfkG2TFXrweF44qeUQOCskFBceVK
         ask7Be5QPS1oX+RjCEE5MVArvV3PndTUjxgTenZzJFN1E1TUHQlAtkYcaOKGVuZ5todl
         mH/Q==
X-Gm-Message-State: AOJu0YzIY/uZm9x4DHDAEw9lugJacAUEuzxPM4dV5k/u8YwwWJEqQEOu
	AJtRJDkoNeZxTEMGcLOvs1L1Cpzeoa0=
X-Google-Smtp-Source: AGHT+IHT4+rKE00OMxlkVtbzFGfm42rAMwZxQGGjiqdlMrT/HQOS0qnitbvkIE3fzrfrjz38aunT4qZzoAA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2581:b0:1d0:737b:2850 with SMTP id
 jb1-20020a170903258100b001d0737b2850mr129810plb.11.1701705347469; Mon, 04 Dec
 2023 07:55:47 -0800 (PST)
Date: Mon, 4 Dec 2023 07:55:45 -0800
In-Reply-To: <20231204074535.9567-1-likexu@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231204074535.9567-1-likexu@tencent.com>
Message-ID: <ZW32geNb18p9ibrR@google.com>
Subject: Re: [PATCH] KVM: x86/intr: Explicitly check NMI from guest to
 eliminate false positives
From: Sean Christopherson <seanjc@google.com>
To: Like Xu <like.xu.linux@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 04, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Explicitly checking the source of external interrupt is indeed NMI and not
> other types in the kvm_arch_pmi_in_guest(), which prevents perf-kvm false
> positive samples generated after vm-exit but before kvm_before_interrupt()
> from being incorrectly labelled as guest samples:

...

> Fixes: 73cd107b9685 ("KVM: x86: Drop current_vcpu for kvm_running_vcpu + kvm_arch_vcpu variable")

The behavior is deliberate, and was added by commit dd60d217062f ("KVM: x86: Fix
perf timer mode IP reporting").  *If* we want to undo that, then the best "fix"
would be to effective reverting that commit by dropping the IRQ usage of
kvm_before_interrupt() and renaming the helpers kvm_{before,after}_nmi().  But
my understanding is that the behavior is necessary for select PMU usage.

