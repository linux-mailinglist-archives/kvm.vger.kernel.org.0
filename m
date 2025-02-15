Return-Path: <kvm+bounces-38214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DB4CA36A1C
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:52:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6EFE170B57
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 00:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1C1433AB;
	Sat, 15 Feb 2025 00:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ITZVA4hE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24515EACE
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580735; cv=none; b=b4ywr+FgFk4CnIfTsZjcrBZwPiDUJQszDokn4Bpo15TBpWseRp5qjIkOAdItSMRWgVtczklSQrxLo8HyIvSp0ME9JItsFrxW30EkA+xAF07KAi33ENqrrWOiUJ09tQkvrzmtZNVcH1ppQ/vtmIfQm0UFeROJsX3u6rXMImxxlBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580735; c=relaxed/simple;
	bh=C270t9vOE8Jd+0AZ0H/d/kXPNITGhRctKxTbG4yjY1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IuaoByp8ZxWidx8pxqkwr32FVbHmwvgdKh3crWFQsYbOLepyE3MC6SZSsd28gfpV+3pVEzcVTuwK6voGjilsVhf4QQWRASZG8a100oK2dsxWgSmk116V5EeSAtzhGa6aFXMf77jd66wgZieFHCDyR/nnB6LLuMKVdLWCHD55J1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ITZVA4hE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1a4c14d4so4660076a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580733; x=1740185533; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L/w+c2CabV0dIn4w6RFieU1p5sEx0QasW8TYiOxAj4U=;
        b=ITZVA4hEQbj8DbTd6VLOe83i48HN4WVhK92t66ZBvgIkSYEKaYG3ukG6BkMcVnZauY
         0KJ031TlqMgrvVZHA4BJ9eUZbtDVTFkI+G4MYN2PKLGD6XwWKVfOTVz/QQ3yYCpnMiSh
         EHVh7vADuBlvZ3MlCo109d66BAEh+najNQFtGJqx77TQK+m9g/6PGioQUhs/lVpHF5D1
         nQpIWoy3wQwBD4tQ1+HV2b1l6Z7kXJpXbYSGhEGnpBriNqeqzhojKlxSncQoYffk1/To
         mtgHo/k+liTc5+tlr9OZcOEjTTgsjyo8gijiKuFJfeVS587obGLlNIHi0pEYRSWXtTHL
         YMfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580733; x=1740185533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L/w+c2CabV0dIn4w6RFieU1p5sEx0QasW8TYiOxAj4U=;
        b=omKtNwscLy8tzX87fV5I+k5Qk47LCQxEdC1jY5B7+50m72L8BJgyr3UvDBrfKRq83C
         MVv/60j93S3VwyeKnIc98D3qWvYk1u3a6HMsLHj2WgbBk1LvaxnfLmLYf+wU6hgk/wta
         PpNaCTRsH35Uy5JK8YCgrw+KTcllalmHPews1YwnR7c4gyh3zR6Qlj9lSs2TkjGq1p6g
         XGAV88ttwOCqLrSo7MfZDPi6AywkGPrquCUYPJGH9omNbDCoYJPiAanEalcSDbr82UUm
         dzpWImvrkighMhMjopT+8s5kmtWNKAD0cVkzo0TgE2akM6v0+BK9pKQMtnfDJnjlzoez
         vCrg==
X-Forwarded-Encrypted: i=1; AJvYcCVnclWLWaeTpRA6Ymed8WwCF+pkuLeaGn12V0g1ShgmoQUE9CBuy016kNCPeBZUibwDDGk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh0EpugOCgNMorqEggRwpL6xgXOMpyiOiXIDqOmJxo4ow2CWEf
	C46SMS4wmbvqm3YyC7ALtDm5AsJsTvN3OU/JmaMRBIvcuHaiEJKPI0aoR6WleAZYaKeJ8Rwn4E7
	e9w==
X-Google-Smtp-Source: AGHT+IEzoM1kxytohJPzZiUBujM5HphgBOfWYDv5T6Prq7S8s2l8rylIt6ug7wHW06IQB/WPGcFyCMxgDYU=
X-Received: from pjuw7.prod.google.com ([2002:a17:90a:d607:b0:2fc:2ee0:d38a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c0c:b0:2f6:d266:f45e
 with SMTP id 98e67ed59e1d1-2fc40d14fcemr1771692a91.2.1739580733408; Fri, 14
 Feb 2025 16:52:13 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:12 -0800
In-Reply-To: <20250127013837.12983-1-haifeng.zhao@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250127013837.12983-1-haifeng.zhao@linux.intel.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958023920.1189103.10850075100042366704.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86/cpuid: add type suffix to decimal const 48
 fix building warning
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, hpa@zytor.com, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, Ethan Zhao <haifeng.zhao@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	joro@8bytes.org, jmattson@google.com, wanpengli@tencent.com, 
	pbonzini@redhat.com, etzhao@outlook.com
Content-Type: text/plain; charset="utf-8"

On Mon, 27 Jan 2025 09:38:37 +0800, Ethan Zhao wrote:
> The default type of a decimal constant is determined by the magnitude of
> its value. If the value falls within the range of int, its type is int;
> otherwise, if it falls within the range of unsigned int, its type is
> unsigned int. This results in the constant 48 being of type int. In the
> following min call,
> 
> g_phys_as = min(g_phys_as, 48);
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86/cpuid: add type suffix to decimal const 48 fix building warning
      https://github.com/kvm-x86/linux/commit/a11128ce1636

--
https://github.com/kvm-x86/linux/tree/next

