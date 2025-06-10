Return-Path: <kvm+bounces-48855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 52CA9AD4309
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:43:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 740951897EC4
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 066AB264634;
	Tue, 10 Jun 2025 19:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lm/HMCf7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE46264630
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584579; cv=none; b=WyHcevmtrgIl+FN7bBcXIqWkZ8a4D9FUjEGoe4akrO85E5wT88GOfemrD3/mM4AU9Nvcf9Pdpwn/+17LOwTJoxYUCSiSWMHtS1KwYKW7YA163dnm0vInkoaWZnDupRjypxOpekbt84IaDRBsAIasC2Ly/WkTa3HoMWa+ElFKGQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584579; c=relaxed/simple;
	bh=9YkBVxUtVEzf2g1l+3bgcHOa0H7naeg11KxKDKi9ITM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SMZ7eAuEYj4ht7R/vWx7TUGeX0v1sOwlIAB+2eY/Y+IAwPSJVclclBoqg8Q8YJGDfLo7TMSvmlQL0UdPjfnmnDirosReHJmRlxtWqc0l55gJjTgI8R7ru4BcngIEP1eovr58nhdxRxR+a8iHO86ZkXs5GEe26GU+zmdWelGbnrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lm/HMCf7; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b115383fcecso3374983a12.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749584577; x=1750189377; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oDALznD/3c9MVqTY3u+MwmZHInHphiU0CPL0RvaHEeA=;
        b=Lm/HMCf78V4tnhNLad87rPhOl+vMHJIhrwdUz28m3EYTlCrvPz1FXt/BOVVB9W84ts
         9kNfnLGj11T0y9LAYxY4TIYYWAsZFbVFy6olP4urmx6VPDvasI9vJjODZACraJT+OlrM
         J1fWMjRLwyCd2B+6A5tk1/QVQoV+f8nWhn5nyu2k5iWfCd4dBpVx8haOFr3MfPFVTZPT
         YxsxtN+g7JJhGkInAbXUYKl/k5G9XeZNlknKN/js4wZuDhkgg1Ciiv7oJEUFFcAh9CIs
         2bCAnweAAXJirVH91jPKgE9DS0trw0zkfImkayyTM/ezp5cUb4c6V39hBXbk2Uo8DfVK
         erHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749584577; x=1750189377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oDALznD/3c9MVqTY3u+MwmZHInHphiU0CPL0RvaHEeA=;
        b=gtcYf5qyYHBfvOe7Z71mlflFgUhTs5isixn+C/xuYE1vUUg2sRXwZ773LIzAuBQ/7U
         W3jqV3bq71IbkvS/ghbFqA4VARfIsaIxfsLLkVBrwKvlmv+mknrDhVL0WHOfj8S6+1un
         Wk3lC7LIoQLhPrVzt50d8dKnVfO2N4qIqMTebZp/skpg+DbgPld8u54VZn3C84BrVor5
         BCsGjw6f52nVL96wpqp1Vn2blIjYq4z/BiCdUG3nfWVAtzAPz6+yGeB1AEz6YW59aI2y
         0T66KbCNPduRAYZuglbOOPQbTK7DWrC0NqWcmEfk+ec6HEoXCSbQ0EVXnszywhE360lb
         aw/g==
X-Forwarded-Encrypted: i=1; AJvYcCVbBrgfFtgSoEAFCWvvG9Moqu7UEW6m1MnvtMQw7dhP6zO9Nul9T1DQMppDGxZy5v7oiHk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4QgzPZeXTdHiOFOk20gLnJ4/UQdJSx/cmKfY9P9WrGZvKjIgx
	jjeuJmzxdyxNggah52oLOJcojiOet5mAVkQCkn+V4gJGqhGmJwYF7hVBl1jTjjPHKKN0hls510O
	3aBvpug==
X-Google-Smtp-Source: AGHT+IFcAOO3RSRtE5/jK1DkybZihifw/RBRr2CZFZLIL3K3lAfdD4oPG0LZgY/dzFkx0SmxXZyKAYsG10A=
X-Received: from pfbhe19.prod.google.com ([2002:a05:6a00:6613:b0:746:19fc:f077])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1703:b0:736:6ecd:8e32
 with SMTP id d2e1a72fcca58-7486cdfcc3amr980353b3a.21.1749584576971; Tue, 10
 Jun 2025 12:42:56 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:42:18 -0700
In-Reply-To: <20250529221929.3807680-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529221929.3807680-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <174958127087.101429.2266783610076724411.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 00/16] x86: Add CPUID properties, clean up
 related code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	"=?UTF-8?q?Nico=20B=C3=B6hr?=" <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 29 May 2025 15:19:13 -0700, Sean Christopherson wrote:
> Copy KVM selftests' X86_PROPERTY_* infrastructure (multi-bit CPUID
> fields), and use the properties to clean up various warts.  The SEV code
> is particular makes things much harder than they need to be (I went down
> this rabbit hole purely because the stupid MSR_SEV_STATUS definition was
> buried behind CONFIG_EFI=y, *sigh*).
> 
> The first patch is a common change to add static_assert() as a wrapper
> to _Static_assert().  Forcing code to provide an error message just leads
> to useless error messages.
> 
> [...]

To avoid spamming non-x86 folks with noise, applied patch 1 to kvm-x86 next.
I'll send a v2 for the rest.

[01/16] lib: Add and use static_assert() convenience wrappers
        https://github.com/kvm-x86/kvm-unit-tests/commit/863e0b90fb88

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

