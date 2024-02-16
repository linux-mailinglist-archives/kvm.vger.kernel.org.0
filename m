Return-Path: <kvm+bounces-8916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 497A8858982
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 00:00:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCCBC1F23EB9
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 23:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D39451487C5;
	Fri, 16 Feb 2024 23:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="WxQ9ewr/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CC41CF81
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 23:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708124433; cv=none; b=cV/TouzKuZQdKbfT4gpR4bGP+OFucEF27BjkMYidQkxwepp3Cm2UZyDYoU2k52bf8LL1/e30KY5Xz8S+T8BE3aZGRV8lywRcHZL9M0qSxID0KqXGetpL5AcLvQ/OHZsyn4enXDmTCYhD5t3UoeSndKYUPZO/MFutmmrC+ucctSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708124433; c=relaxed/simple;
	bh=L/6pue76t+6bV8etRbJ/+JrByK34gEKlyYW7HOqcgIQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=etWhkS8R05bA4imU+N7vstSVP49U+z1hNzFFvMgnGBfnhewJMiAW7TR4iYDrFahYN7O+iapOWi0FyBATSFxK4ri1g9NAHivizSGXzNF1/tgy8zbWPATcNVH3KMNK9C3aoX0V92kXGzIua0tv8FhkTz+8a+t4iIZoaCTuIXw27pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=WxQ9ewr/; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d228a132acso3224901fa.0
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 15:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1708124428; x=1708729228; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/6pue76t+6bV8etRbJ/+JrByK34gEKlyYW7HOqcgIQ=;
        b=WxQ9ewr/KAU7FJ3rjnLbX6gK4Axam3W7lNGF5R8u3M0HnoMlapmeyTXBKUoPakuGzk
         Nwfms+Yj7H/09cz+pUaA8u9ADZ+ZgyhmUHwGSZg8eiJWrHIeZ7qojALYz5b9bGqfpyNQ
         TEdIKJ/m1eP5UUcjPH/IcpQsm5AC6For6YFucYQkuaFY0XZpFRJp5NftCaWogy/qg9Ks
         MI/dGOm+fMvK5Im3vzcKPprq66c7Hq5udwHB0LyuRuVKjJHiDOB8UA1r0WBp7VVMVIqB
         nbxZhgvOQ9kMgm9Cs9WUFYur1FAExp+ctpMl8sMT4mSqeH8MOGFgodO16k4KQltfw+Nl
         DJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708124428; x=1708729228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/6pue76t+6bV8etRbJ/+JrByK34gEKlyYW7HOqcgIQ=;
        b=jjQoLx8vGTczu2st8fwcK3ynR6gisoEy3E6lYPBSC68BUy33MPjclhqAJFeXjSwqP2
         UOUqRL6F4iaSn5a6PFRxkyAW5IZAOvRTsUIaaNiRDRtf6UaFseooCQrlS6VxoVjmpZTh
         XAqBHSYHWUllocUZjeFw0BnVFgx9dlm2fd4sm7d2wOQ3tkiAsvnZsECYXleCQ2wQKlla
         q6xBX4OTvUD7yPJTDydRjpaMJBHPH+fUOw37iAfq42AJaRq6VSnNNLC2YNxrt8DZs1V8
         Ai3lphR//HvvYX1MUQC1WIba/kAAYgaYDFbq9Qn9ONpmkmC/mpDe90WHeHrQdFhL7Yze
         iiGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNKc2FJsoVNQy2rSBHMIeRV2rOJOy1okoqVXBg22tW2YzUZxpVr83xrTGzjgrvSbV+LFOJSYk/K72FOkdE8Rw02k3e
X-Gm-Message-State: AOJu0YzVwk9rk9H+gtKMzyQqYfZ0z9QY/gJOzEsBhasxfboUUnW+HFNH
	6DxKdQQAQ1M/nc0PCxJW5ySfBEDSkwNgbxqPFt4+abvwGc2QDFjVUR5ph9D+s6odh/0yXezh4tR
	1Hze00EGa4iE3mMWyFGFDqjDmx/M/dOCsmefEcg==
X-Google-Smtp-Source: AGHT+IEOZcOwZIFZjSELq39TRPKSsU03mDvfP+/A3CI44D/4utD/scQXzIoLEolaupxeC0YOENEhksY63FGtN0BdNKw=
X-Received: by 2002:a05:651c:807:b0:2d2:933:4165 with SMTP id
 r7-20020a05651c080700b002d209334165mr3997245ljb.11.1708124428664; Fri, 16 Feb
 2024 15:00:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215133631.136538-1-max.kellermann@ionos.com>
 <Zc5sMmT20kQmjYiq@google.com> <a61b113c-613c-41df-80a5-b061889edfdf@zytor.com>
 <5a332064-0a26-4bb9-8a3e-c99604d2d919@redhat.com> <87ttm8axrq.ffs@tglx>
In-Reply-To: <87ttm8axrq.ffs@tglx>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Sat, 17 Feb 2024 00:00:17 +0100
Message-ID: <CAKPOu+9sbWwZhbexQHwqZ6nMfg6dau7oYEzzgQ5qx+JiEcdmXQ@mail.gmail.com>
Subject: Re: [PATCH] arch/x86/entry_fred: don't set up KVM IRQs if KVM is disabled
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xin Li <xin@zytor.com>, 
	Sean Christopherson <seanjc@google.com>, hpa@zytor.com, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 16, 2024 at 10:45=E2=80=AFPM Thomas Gleixner <tglx@linutronix.d=
e> wrote:
> #ifdeffing out the vector numbers is silly to begin with because these
> vector numbers stay assigned to KVM whether KVM is enabled or not.

There could be one non-silly use of this: if the macros are not
defined in absence of the feature, any use of it will lead to a
compiler error, which is good, because it may reveal certain kinds of
bugs.
(Though I agree that this isn't worth the code ugliness. I prefer to
avoid the preprocessor whenever possible. I hate how much the kernel
uses macros instead of inline functions.)

