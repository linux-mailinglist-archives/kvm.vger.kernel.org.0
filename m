Return-Path: <kvm+bounces-5743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F091F825AFD
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 20:13:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBC591C235EE
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 19:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5120736090;
	Fri,  5 Jan 2024 19:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DTF6IjL8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF7D35F11
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 19:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5eb6dba1796so36863677b3.1
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 11:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704482000; x=1705086800; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eg/8mKksjoiQYmouE2QXUDAfddgsPyrpn2yVTAfF/gA=;
        b=DTF6IjL83TxpWDdsRJEYo+guuDdTCxMhNxs04t/lmo+yP92MBPClRS0otefqFaxSK4
         ylFbArCkpsq8T5jk9sg/Vm8OjP7l0yAv1eLHNGN9YamJCMebzJ5IydZ7fEUuu6ZPZ2S8
         n7kyxVewGipoCcttxuE6dfQcwdC1WaPoYz83PkizyK9VSKmSFInYnHd9Ow5A0+33H8s8
         f7qGaar+oDa19yqXaIRNNhZZ8HUFHqv2NbWAemAHi34qYFEGYWhn2nwOx55fugWLjxvv
         nim7UskvJluPNz4pV7wJuN6TEBT530doxtVPlOYh9p+EUAyKl0yKpSgkvUuKfOVZBX9K
         zqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704482000; x=1705086800;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eg/8mKksjoiQYmouE2QXUDAfddgsPyrpn2yVTAfF/gA=;
        b=ATktSsbqGwJGfcH86Oj7/S3dxn3doMVZXLcXZdiK0XRk9/H4fUDQJV4BjUpCuCO5ny
         9RH2MvGxwq46m6rr3TUXICypR1tiPC1Dm+EUsREpcK4kxm6o/vvMmk92AnesMVBcJPg2
         sFAT1Mk5+Zr8WxB2SlT7w17YajPoPh+qyXXimAad1EP6HNyepat/7d5YrxhTuKFhBo2I
         aveLKRsivraH+Yg2zw+ePQyMNqZtP7YjpyN4mJPxDi5qbdT4SP+xQ7nERD0BA8rAgjdn
         4nSqg12lLL1EhJu15lXR+5S2C64YqB0qq6P+o7stKpXIHpM1KqtXSro5GdpUrfjLA4eb
         Lj8A==
X-Gm-Message-State: AOJu0YzW5iM2Z6pFYDixKQqg5jf4nGWKyYg2hAuqSpvEH8KPuc7x6bxd
	JpTUWfdijwyeyd/VvruJjjs8WFCnBBxxG4uppA==
X-Google-Smtp-Source: AGHT+IEaTot1n7nLi163gKqTqYkZGdlfHzsCjeQ9tUC4ijcwyR4yrRoYlol1X/E1P23+dVxTEf19w+uXH8k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:350a:b0:5e6:bcea:df68 with SMTP id
 fq10-20020a05690c350a00b005e6bceadf68mr1332014ywb.8.1704482000216; Fri, 05
 Jan 2024 11:13:20 -0800 (PST)
Date: Fri, 5 Jan 2024 11:13:18 -0800
In-Reply-To: <20240104205959.4128825-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240104205959.4128825-1-pbonzini@redhat.com> <20240104205959.4128825-2-pbonzini@redhat.com>
Message-ID: <ZZhUzm9r5Z5l567Z@google.com>
Subject: Re: [PATCH 1/4] KVM: introduce CONFIG_KVM_COMMON
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, ajones@ventanamicro.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 04, 2024, Paolo Bonzini wrote:
> CONFIG_HAVE_KVM is currently used by some architectures to either
> enabled the KVM config proper, or to enable host-side code that is
> not part of the KVM module.  However, the "select" statement in
> virt/kvm/Kconfig corresponds to a third meaning, namely to
> enable common Kconfigs required by all architectures that support
> KVM.
> 
> These three meanings can be replaced respectively by an
> architecture-specific Kconfig, by IS_ENABLED(CONFIG_KVM), or by
> a new Kconfig symbol that is in turn selected by the
> architecture-specific "config KVM".
> 
> Start by introducing such a new Kconfig symbol, CONFIG_KVM_COMMON.
> Unlike CONFIG_HAVE_KVM, it is selected by CONFIG_KVM, not by
> architecture code.

Why?  I don't get it, just have code that cares do IS_ENABLED(CONFIG_KVM).  Except
for the MIPS usage of HAVE_KVM that you solved by adding CPU_SUPPORTS_VZ, I got
all the way there using just CONFIG_KVM[*].

Ah, and so does this series for the most part, the only usage of CONFIG_KVM_COMMON
is in scripts/gdb/linux/constants.py.in.  Honestly, adding a Kconfig just so that
VMX's posted interrupts that arrive in the host can be printed when KVM is built
as a module is a waste of a Kconfig.

[*] https://lore.kernel.org/all/20230916003118.2540661-12-seanjc@google.com

