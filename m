Return-Path: <kvm+bounces-67804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE63D14725
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:43:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 758C4301B102
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AA8E376BDD;
	Mon, 12 Jan 2026 17:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UkbZAQgT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA096374176
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239662; cv=none; b=otVyFOxQpX2KhcVqoIb/ULabI2gBwIcH+2RHU/3quyig1T91/2BVS7MM6JxBcYU4Ro2MmhQ0RU/OXmHEfApfaxIrazhlnfPE/d1Qo9ZPujCBnyQujvcKptV0FXx2gUZFYPWP1jqWvan+EJMCXNzz2Ul9M2qJ4Qf4zPB7crgh7gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239662; c=relaxed/simple;
	bh=i6y/xW8JZjpTrRKnZ13Y6DixUs9nnjzLnsnXAENI5T4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qlrAkDhljZdc4bfTJ3b57TfhmvBoPj78OJQ46Tak7veQgSapATzjaMZnDG02ahR67H4MMIF+1vxWCQfd5Vo5u0mTE53AtmD0irTFCv/n19MhhgqzK6nl5v5eXKSxRh7OFDc2bVLAzfb3bEgiVfc1fx3rgnZizuv9EYPg6VK0RDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UkbZAQgT; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ea5074935so6435303a91.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239660; x=1768844460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9qaWJfkCMEyAoUQAzN2rDC87xL97AfctNGKLRuM2/oE=;
        b=UkbZAQgTZgMv3AER864AW0BPC7n5leuFz7/bfaltj15C1a1TYgDghhP0Z3cfxmWbxU
         QuignJw02vPRWSYG87k5DzrBprqHmTd1wp5vWgnkB9A0wrbQqn4HLmUpmo0smXxSq5PO
         5b3nMsX1eI9ObXDprjvGssTfbQv8LQ5JsVt8WTcTw52eanZ9Oi3i4oJqcfDyYaQNKq9Q
         zbmctKMEiZdHOM4JOzdB0JSNrDKRneYeZ/RWa3IUBKgMPhcc/+gFhm5pLaJ5cPPIAipE
         2Ry0p1k+dCpWhVhLcaTP6d6cSv5Hz8wQeTFvx4dJii5N3IzfjKTYkRVvu0bfpqUbYQwF
         bd9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239660; x=1768844460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9qaWJfkCMEyAoUQAzN2rDC87xL97AfctNGKLRuM2/oE=;
        b=YZuyAaVUT5ugQmgTOhTjO7l5llRIwhedPWYXkaxqISkKOWxMJ5FwP1lGMJTdQbAWzx
         R6rnQit1VO8OUNtM/rquPFIJR+/OKA6DuoLKxoI32/13Vf9i49UWNmaF6P2ODeQUm3Dr
         BaDHuAPyxgiNI/ds4h2IcZ2Ub21e3IBZ4lqOYnS61SK0NvIvk/dDO8b/V5youBoTMWIR
         +jKeJaapBAJl1e3gONMu+QkszMQi6HH3k7jXIU0sj1ujZ6IqAp1KNxYjMlIOHMlox1/p
         6rrYSQsRvN2QK7GexRt9A2267Zg59wU1VqnkI+QOR45oAmN8DkMccdw4YiFR3A6Gio+D
         DYzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUr44f6R2mx47OfI2p8ws0XifMMNjWhRM7ZyazAPQw+CDDm4nol0Oe8o/3HuE2pIK//9v4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7qQ+5d+95UpORISIRDz8GEdYiFOjhhx4ktjauKH7JfSa+HWux
	1vrgBESFqn8sYVXNVTQqmTb/YcVImpXxHOXpswYNwCEg+loI+jcVcvcIqgOuPd4KDCqRF+MNO/Q
	O30KAZg==
X-Google-Smtp-Source: AGHT+IFLp/98pk5R3YNhnGDED198MYUha3D/aQztds2iS2t8rz4tXHTf+NF/DVDaNwMXAHSOi2PDVAUlEPc=
X-Received: from pjbdt6.prod.google.com ([2002:a17:90a:fa46:b0:340:bd8e:458f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5287:b0:34a:8c77:d37b
 with SMTP id 98e67ed59e1d1-34f68c502a3mr18857238a91.16.1768239660360; Mon, 12
 Jan 2026 09:41:00 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:48 -0800
In-Reply-To: <20251222174207.107331-1-mj@pooladkhay.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251222174207.107331-1-mj@pooladkhay.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823878891.1368899.400639654569804512.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Fix sign extension bug in get_desc64_base()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	MJ Pooladkhay <mj@pooladkhay.com>
Cc: shuah@kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 22 Dec 2025 17:42:07 +0000, MJ Pooladkhay wrote:
> The function get_desc64_base() performs a series of bitwise left shifts on
> fields of various sizes. More specifically, when performing '<< 24' on
> 'desc->base2' (which is a u8), 'base2' is promoted to a signed integer
> before shifting.
> 
> In a scenario where base2 >= 0x80, the shift places a 1 into bit 31,
> causing the 32-bit intermediate value to become negative. When this
> result is cast to uint64_t or ORed into the return value, sign extension
> occurs, corrupting the upper 32 bits of the address (base3).
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Fix sign extension bug in get_desc64_base()
      https://github.com/kvm-x86/linux/commit/7fe9f5366bd5

--
https://github.com/kvm-x86/linux/tree/next

