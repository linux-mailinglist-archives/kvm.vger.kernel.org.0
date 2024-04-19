Return-Path: <kvm+bounces-15371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B82F8AB62C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 22:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5E71B2245D
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 20:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D6632BB05;
	Fri, 19 Apr 2024 20:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bIvJC1+R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D93F2837B
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 20:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713560261; cv=none; b=RaC352NsOwcMTr0zsvIvdPomFw5YqsJ594J8rIzF7O3Wl07aCh26+Jb3e1/i/4kQwuN0VgV2bFAnlTgsvkiwprmEnJ1Y1WBEnMG9GXLNLCVAxAekYPkvRPRv1G5TIFUzYkDbwLFFE93JoodVPEaIEwz0mLs9T/L55GE1lVYEbUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713560261; c=relaxed/simple;
	bh=qoLj+dJYefPcd1d7d+sMJMQdz9RnEJbXZl0KVW0Sv7A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rndZ6TIclX4MyHgwC4H7HPph9sosvmLxgSICptOF5VQVyX3MeayepvBikl+b4p7aKFkQvC1hLhGEPJg7GNk9r5iRIh+/tFXwPgeMXNW011VtdoFxsP6nDhm2loFuJONrSOS8lHDwvNnjKsVIw9G9prxblTQfRZC1jzEfjUfBG6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bIvJC1+R; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4348110e888so25771cf.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713560259; x=1714165059; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qoLj+dJYefPcd1d7d+sMJMQdz9RnEJbXZl0KVW0Sv7A=;
        b=bIvJC1+R3l4JY1IjLi1i2qjIPkdcw1M0BDoDpmUnAzVDcXvFIwbYzCnjVavqScyI7E
         ybbj7/QAn8VFcJ7O8TaTUUeNLnvnAsrasmyXbRu3++moUdatkuONWxykT6O0hFtWo1gR
         j9BQlBwWGkckSvilPNLv/ejXeSXjUQELWU9osotAHvCtoZSyxrwxcNp89MfpsGHKUzla
         29pY8bLfvkyD5Uqj+DXKcGuVy3m+ZsdqmLbszulu5Xxf8LoX+6mjVLky3KXbIjZnN1hX
         md0n4Riq/dKDZUbJxOP95JK9THJ3gRcHXPUY2gh79+CzIp+/4BrsMObus80sfe6HHZDy
         3fYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713560259; x=1714165059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qoLj+dJYefPcd1d7d+sMJMQdz9RnEJbXZl0KVW0Sv7A=;
        b=PMAei8S432QPaUl+k1itS+gu8j/hQE6OIsNlFJ9qYeJKjx6Za3fLCYQDVwBUdsQOJg
         KgRMl59GB4zkkpH4OmyRBS0ik2vb9ncBXMhBomaLHC8kxlYJKJ30XTvgiSHdBWJDFDVx
         lgOa0+wDzXSdIe1gyuczHVswrxhJki7ElnvPFeYnzHwgEAfgwuVZMQo7/zNFm3yepdT6
         tFd/AeXIKWnKWdNSOSBoNyljY+8bm4q8DIh7Xr6Miu0HylHjP85E7imOauPGBm2QUYW0
         X4Jiclkw5MQHzasYPd09WMPVkDfoodjAqHzCBBFC0tO5jMC3knpwIpk3i52qvR0bF1c+
         GNEQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5HFaPj036zVa9JKzSrAw8FYVqU/C8MwkRPKtdqYYpa+O09YDrafPgLgUtU1dHG9JnPOVuOLeB9rL58zlqIZFtzu9D
X-Gm-Message-State: AOJu0YyA3u7Zv1uLb2+bJqg9lc12+tIIpIz4uQO1wDemT5GC9k7L0TA9
	P8LM7oPDCRIikBAuO+9Y11Q2JdEbEdsXmATW+7kum/JD5k0LctNdfVWYkW1K/eMnhMXOiXbh9+R
	aR80UlsZuxl5N/d4kkvnORJrpIGWG0rknxItV
X-Google-Smtp-Source: AGHT+IFv1QNbGHT+roZmsKKDk+4PrHigHuJTamLsAWVaJCEFFb06VO4JQpFPHTrcY52wz67cbMD5ADs0MVUpOaV74QM=
X-Received: by 2002:ac8:729a:0:b0:437:b99c:dbf7 with SMTP id
 v26-20020ac8729a000000b00437b99cdbf7mr13893qto.11.1713560259365; Fri, 19 Apr
 2024 13:57:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com> <ZhmAR1akBHjvZ9_4@google.com>
In-Reply-To: <ZhmAR1akBHjvZ9_4@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 19 Apr 2024 13:57:03 -0700
Message-ID: <CADrL8HW+4Yq-wBr1+DzJvSwRRL_hqt5RaCCLgOQndPGUqoX+Rg@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] mm/kvm: Improve parallelism for access bit harvesting
To: David Matlack <dmatlack@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 12, 2024 at 11:41=E2=80=AFAM David Matlack <dmatlack@google.com=
> wrote:
>
> On 2024-04-01 11:29 PM, James Houghton wrote:
> > This patchset adds a fast path in KVM to test and clear access bits on
> > sptes without taking the mmu_lock. It also adds support for using a
> > bitmap to (1) test the access bits for many sptes in a single call to
> > mmu_notifier_test_young, and to (2) clear the access bits for many ptes
> > in a single call to mmu_notifier_clear_young.
>
> How much improvement would we get if we _just_ made test/clear_young
> lockless on x86 and hold the read-lock on arm64? And then how much
> benefit does the bitmap look-around add on top of that?

I don't have these results right now. For the next version I will (1)
separate the series into the locking change and the bitmap change, and
I will (2) have performance data for each change separately. It is
conceivable that the bitmap change should just be considered as a
completely separate patchset.

