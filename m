Return-Path: <kvm+bounces-65804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C2728CB76EB
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 01:11:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C3579302FA20
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 00:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D0B2772D;
	Fri, 12 Dec 2025 00:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p7mG09sr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322473C0C
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 00:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765498210; cv=none; b=DAtwY4/pgqUWXK/llIBPmg7idPqdyNzCWhwV31Y9CLP4YlzyEszVcIgBd/g6iWqVdxcw9bYxhruaDdxKUO0SRyjNcCK0u7BbdHtTjruOzGN/t8OmP05ck37PRdoy35/ilRd3rs0HoH5OD4KFyNMU5rfyRnlk4zpWrB0lYB2c+tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765498210; c=relaxed/simple;
	bh=FJs+RBlAyiyyQgafk4cnh7FOnP552iwnbEY62gyq610=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LvRHI96U2YWUsHIa5kovqQtNsgLphb5Gw+IFhK/K6+WdH66+MmYbIkvV7j10ipwmfNyK20kjNJtp7rM6N4NV5/O6F12C/GhHweV0ODkZusdkRk/E5EK1c2Kc6EfZYT3XsSSRL3Y5LU9g74X6vBFQ4yEyDwSeLIIS4RWtI5bOCzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p7mG09sr; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7bb2303fe94so674585b3a.3
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 16:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765498208; x=1766103008; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jjUXde3rb7uNgPoaBad26ebGujFjxzQ3pwuIQPIXXcs=;
        b=p7mG09sr3Rx4NmxhOeAav3NcopT0mvpmgTJKEd6gdlqnia00W6OH7vb3HtcoV/Z7hi
         8jxIRkiY7s+XjIxGE9d69/vdpIS7hPMhA04YMjRBZEGf3buAub/FjH9S+jNZAmjF/MZz
         FA9zmgmnRyc1Vk3iJAC0lrlI4SnpW2Uk+SXTdUQTko/B9jxhZsiC2ylpTZZ3tA30omZ8
         5PaVXVzfnckdVDPEr8rwoDErt/lWG3PvNEgpP+MCcDB3w8fXpRj1Vws7oTEs60ejNmaz
         dlHMBXxLHpB8kwvGTu1SsYJoecUyRooHECiteXvHsjDf/jY2WBdknWP9BQQwNKI1qmfZ
         vYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765498208; x=1766103008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jjUXde3rb7uNgPoaBad26ebGujFjxzQ3pwuIQPIXXcs=;
        b=qKcx0J05xZGuvVfMz/u12GiqpzIh15wThjzUS3aqcZuwm0524W9OR75/5d9Aznbx3O
         1AIOhXOAOr6Ov1B61Xh2JPP+IsbuqPhg1Et/9law3P57Sy9Ot9apOGxBQuljufCiz+7L
         qmmbfhXUOXGPqOqOoibYWjxTFsI4b7UNn70uEUyvUJWhevFIcTnhVNNkyqaoy5p+TeWj
         FyVolAxrTtDm8mXJyd97A7WMyFUgFOf1FKso7sI/5UtGS0M+7zeauBA5ooyyk8324Gnk
         sa4MlOaTnqC/MF3GhOtahPeI/yH9lnHLqE2KR5oLacJ1EgDvRTMAgld5/Zr7Twb2c6wZ
         xDrw==
X-Forwarded-Encrypted: i=1; AJvYcCV46OQgJMD0GEDB+eHCkfHAnopn3Q0MJyxu4ik8k0koieenPjXKz84Pu89qo0Op/GahNSw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk2jSJ+6FhM+UkxINdteDdq2oa9n5trYjkCKYFIwGj7c1gec+6
	xkb1ZdBVhR/gI8WtnbU8nqmGPRpKSrgJFvAiwQu6QGsXGNP4zbQEb5HE2DTC6wxk7PTlIWc0H1h
	hqgcFxQ==
X-Google-Smtp-Source: AGHT+IEf4CdLCUN5qKHl0pCARsahDjmvlGSeTODmkIfIWDeGEqqMbpNSYfg0yOBt/F2QMt2CIks4oSsK158=
X-Received: from pfbij11.prod.google.com ([2002:a05:6a00:8ccb:b0:7b8:ba3c:8aeb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:bb84:b0:7e8:4471:8e4
 with SMTP id d2e1a72fcca58-7f66a470cd1mr293793b3a.69.1765498208269; Thu, 11
 Dec 2025 16:10:08 -0800 (PST)
Date: Thu, 11 Dec 2025 16:10:06 -0800
In-Reply-To: <83cf40c6168c97670193340b00d0fe71a35a6c1b.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251211110024.1409489-1-khushit.shah@nutanix.com> <83cf40c6168c97670193340b00d0fe71a35a6c1b.camel@infradead.org>
Message-ID: <aTtdXpV6Lq0wygZd@google.com>
Subject: Re: [PATCH v4] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Khushit Shah <khushit.shah@nutanix.com>, pbonzini@redhat.com, kai.huang@intel.com, 
	mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com, 
	shaju.abraham@nutanix.com, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 12, 2025, David Woodhouse wrote:
> On Thu, 2025-12-11 at 10:59 +0000, Khushit Shah wrote:
> And my intent was that the in-kernel I/O APIC patch gets included as
> *part* of this series, otherwise we're making a semantic change to the
> ENABLE behaviour later.

Hmm, my only concern on that front is that we'd be backporting effectively new
functionality to stable@ kernels that isn't strictly necessary.  But that's
probably fine given that it requires userspace to opt-in.

> Also... how does userspace discover the availability of these flags?

Ugh, yeah, I was reading too fast and overlooked that.  This needs a CAP.

