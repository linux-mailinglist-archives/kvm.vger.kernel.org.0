Return-Path: <kvm+bounces-26187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 439EC9728A9
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 06:57:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 765FA1C23DD7
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 04:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA4516A92E;
	Tue, 10 Sep 2024 04:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UM1YMoIy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BEC745F2
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 04:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725944211; cv=none; b=NJALNR06HYeYsZsJHve1EG5q2U+VRFqo4AsxheFCHHAX65tQQP8RW+DooCFYpbwZ6lUPxTgH9Eet3Fe57cr5etqR3nhEmhKW3HnrJ2AWY8CUpF5G27WwDJlvy91wjNJsTDuNB/oksfRguiVWsiwKeauA4FGdKOBIsTKKRAwc4Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725944211; c=relaxed/simple;
	bh=juCf2R0p1ORyD3x1UAE2XxSlfmLi96DIvVEcl9Evl/I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gtpYF2kuAHSRNqum+vF/K574Zjym9QG71E6Jljmju95jxjXxQ5dRMkNVDeGKQpJiFqWbVnOlW5OnyClH9INPWYbAujj3aI57gzJneB2G5X3I0NEpI1ZHlI/V8fTGlFf7ABQ7Xh+k9Yt7ehedZr87VhiLVMyWoKRGGVwtjQ6KzSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UM1YMoIy; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d5fccc3548so106767137b3.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 21:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725944209; x=1726549009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K/XYg61hIXxY5ogTBVcq32zREuSNxjhSfJ6hVBl71PI=;
        b=UM1YMoIy9rKo0FN6lS1Ves5s40KHHNjL1wrNRCweYuZuwHVeuckPWjnEqY78GFqMXO
         l/QJEbiYuG9UJyj/sdcrQEsEerMfYqGy37cfHe/5LWjdr8g/RIOsqujVU3+k2ibHSmBN
         MtB2zjIB8T/Q0J8YN8jTVU5qPi57aeuFgH5fp0e9wMso1Pqd/jY/1MIZXF7xT2+wjss9
         D14UyvGT10e9Ze0Howohl8BkLrv2+k2NzIwPazrW4NRaTa+F6O7kW2ty3g84j0u5waVK
         xrOH1uqi4mRfiybQKLgO2GEr3N6qPDSzZaXFonHIFHhA9Q+dK8hb/dKGhBXuS/GHzPbT
         BKGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725944209; x=1726549009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K/XYg61hIXxY5ogTBVcq32zREuSNxjhSfJ6hVBl71PI=;
        b=sNG1kYVMthkbLx5SAUQODl7rK5/C71xKkLpdIsu86d4c+hVThZ5fF5BnUe9nX/iU7z
         Nf2tBKYCnVQtcSYjsZ4lFFJTjfhU6kBoYbaUSPp/J82kkIcEy3NEcDKQKdyRQT8i3uwg
         bha7GQzQwEmg0pusUSmi+JSAmeSbhpsMU2G/OozlWFb69rsym6ZBHjYo0rzbl30euIq2
         CiI8kWGmpQ9GMQHWXm+ZShkyB8ID1swovdsv/sWUg9k2l89OFexe4p55fFCDdm0qlTgS
         n0kHZ+NOZhBlIKBYYBAmNv4b6fNHYfCMQJ1vTYb4uPTxM0QnE/uu7E0/m+9m4QBL5eYg
         /mNg==
X-Gm-Message-State: AOJu0Yx8+vdPnMLC2ZKdkAKdX0Vvu/0S3enaVEOyA1MJMfrXb0wwfyAY
	EG8IL9rhVfDPxvH4P37d8T9SJxJUOvF0LXRkSDUiZPRwV4HOwXHYHOq4eMnP7zl4G95sZBbH+Hs
	dBg==
X-Google-Smtp-Source: AGHT+IEcHnWZ0cNYb9EfF6L3Bvf7Uqo3vEevZaQ0b6wgm6HG4/KKQpFGaY1BOWy6fF6vdUVdsAbTY0BbcKs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:e907:0:b0:6d9:d865:46c7 with SMTP id
 00721157ae682-6db95342e65mr521627b3.2.1725944208756; Mon, 09 Sep 2024
 21:56:48 -0700 (PDT)
Date: Mon,  9 Sep 2024 21:56:26 -0700
In-Reply-To: <20240829191413.900740-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240829191413.900740-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <172594248786.1552336.13895527580291152046.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: Fix a lurking bug in kvm_clear_guest()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zyr_ms@outlook.com
Content-Type: text/plain; charset="utf-8"

On Thu, 29 Aug 2024 12:14:11 -0700, Sean Christopherson wrote:
> Fix a bug in kvm_clear_guest() where it would write beyond the target
> page _if_ handed a gpa+len that would span multiple pages.  Luckily, the
> bug is unhittable in the current code base as all users ensure the
> gpa+len is bound to a single page.
> 
> Patch 2 hardens the underlying single page APIs to guard against a bad
> offset+len, e.g. so that bugs like the one in kvm_clear_guest() are noisy
> and don't escalate to an out-of-bounds access.
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/2] KVM: Write the per-page "segment" when clearing (part of) a guest page
      https://github.com/kvm-x86/linux/commit/ec495f2ab122
[2/2] KVM: Harden guest memory APIs against out-of-bounds accesses
      https://github.com/kvm-x86/linux/commit/025dde582bbf

--
https://github.com/kvm-x86/linux/tree/next

