Return-Path: <kvm+bounces-40065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 601EAA4EA7C
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 19:06:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F9AC1898DC6
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 18:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B7029617A;
	Tue,  4 Mar 2025 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S1AETnw5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFF127D79C
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741109991; cv=none; b=H7qgL4FDFrFuyYiLSoN1LfirvkgS4vuSDQfUvw1GBHuqwtRTgzMsuBBW3qtLqjAyHnutNh1Fk9qkz/weuYRY0dzhtZzWekSGl7NBQDqNO7c52cvNFn+i2dIeFROJqIg7zlrCVwr5dQn3oW2ZQ83+jQAz6/IAhR/cZokqQR7sgsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741109991; c=relaxed/simple;
	bh=i50rufOwf6vwyAuooSNBHw4J8VhV9XZ8F0ZF8cluBGI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EPeLMhTXH5S18Fbk9WKkt5YaZinrEiQAIot/+T++39VAQmGlz2AjiHBA0wJVVhNrHTDsPCYJjuUHKq0blKPmJKYvXJwzMkC1hSYfOkmS4NucPj1JXjdCe1zdKVR+Y80c379iAu4RKBw3oQoAzgHAxkDAjM7K57g3eE/1eqLlRI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S1AETnw5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2feb47c6757so9622891a91.3
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 09:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741109989; x=1741714789; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TI3FoVeE0Ra2glCU+l7ZrrB58ecOTFnnVt+cs3oYhCA=;
        b=S1AETnw51w0WuOIgCd7ijY4cpBbnjkCH28O29UXQu3oR8WFMcQgAIGPsI5rVuF82U/
         M32QftimTnv0VZWK527Xk/qCS7ON3xukIkuPSrw33nclYI9VohbEX2qQ4ZaQCTy0xa3b
         CAXxmNBg9sG4y2bEeEoIvMDkj2zXcJ8MBqd3tULM7NO/fO2Gwlf51e5Zkkn0oenofbqE
         mndhv5BXCt0QcgtgL+9XnTImnv1QS2EsX4uj4EuuoElioCnCTzPxqxE64C+RS2MG4zyU
         /QuY/NkZJaGXbnPYskJ3y13LG5s4pF/OYPaScAya5ZuduK2pR/k3Crku6mo1VJ5oE3VQ
         Dydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741109989; x=1741714789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TI3FoVeE0Ra2glCU+l7ZrrB58ecOTFnnVt+cs3oYhCA=;
        b=wYMpqHs+l6xMC8yaV2mG7+YF8z7T+0EZkbyxfjGg0SKAg73XxAh1olgxtRd518WJQC
         3dDYeAd9HkxieJRJChRbIZJrdUbUOBEGn+nBGNCeyrb14dic0LnfSwVMdbeyAI4wO8Aj
         MfjnJMp1wxIrmeiPfgJkBiS1V+1ZEU9R/1YQNDYW63Rz5GC+Nd+ZFSpv7367kzvb8SF8
         9GPJ/NAYKNj22FxgDHkSVM+VhaMjIC3Ij9wukRJv/zBsmZ9NNlZeLKqMVE2y7DA+R6JH
         6fJPoVZEzjdN5QdVgt0kiOQE5bkgy2uTbdXVbGiyGK8Ijw4bBp1+wH2gLA4GKw9UBSOI
         OSZw==
X-Forwarded-Encrypted: i=1; AJvYcCUu7vIxUkdAxI3c3KlZGxpKjij/dmSG+U/RK1SVNgclQSSr4LIlZ8+KIUWnZlhIPDBTa0U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjVa1RiAV5bNC7Mu/yQ3SDDkIIeV/SNyLGXzmCWJcuJedWbG90
	B4xobI4zCIP9CKQp/6shUhJT5ZMd4wtN7qLcLARyjzhd3QbX34CjB9jTkez2TSWLURbPZzxGpS7
	s6g==
X-Google-Smtp-Source: AGHT+IGZddoSY2oyJ60dCyqtZiF8YnS+v36sYEMEslkao7NI/8RRXlf38IKWdXRybiMidO4JcJg+/iNohU8=
X-Received: from pfbfw3.prod.google.com ([2002:a05:6a00:61c3:b0:730:76c4:7144])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:734b:b0:1ee:d418:f758
 with SMTP id adf61e73a8af0-1f2f4cdb421mr28532451637.17.1741109988705; Tue, 04
 Mar 2025 09:39:48 -0800 (PST)
Date: Tue, 4 Mar 2025 09:39:47 -0800
In-Reply-To: <SN6PR02MB41576973AC66F8515F6C81F0D4C82@SN6PR02MB4157.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com> <20250227021855.3257188-9-seanjc@google.com>
 <SN6PR02MB41576973AC66F8515F6C81F0D4C82@SN6PR02MB4157.namprd02.prod.outlook.com>
Message-ID: <Z8c641D3AuWNXGVB@google.com>
Subject: Re: [PATCH v2 08/38] clocksource: hyper-v: Register sched_clock
 save/restore iff it's necessary
From: Sean Christopherson <seanjc@google.com>
To: Michael Kelley <mhklinux@outlook.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Juergen Gross <jgross@suse.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, 
	John Stultz <jstultz@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, 
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 04, 2025, Michael Kelley wrote:
> From: Sean Christopherson <seanjc@google.com> Sent: Wednesday, February 26, 2025 6:18 PM
> > 
> > Register the Hyper-V timer callbacks or saving/restoring its PV sched_clock
> 
> s/or/for/
> 
> > if and only if the timer is actually being used for sched_clock.
> > Currently, Hyper-V overrides the save/restore hooks if the reference TSC
> > available, whereas the Hyper-V timer code only overrides sched_clock if
> > the reference TSC is available *and* it's not invariant.  The flaw is
> > effectively papered over by invoking the "old" save/restore callbacks as
> > part of save/restore, but that's unnecessary and fragile.
> 
> The Hyper-V specific terminology here isn't quite right.  There is a
> PV "Hyper-V timer", but it is loaded by the guest OS with a specific value
> and generates an interrupt when that value is reached.  In Linux, it is used
> for clockevents, but it's not a clocksource and is not used for sched_clock.
> The correct Hyper-V term is "Hyper-V reference counter" (or "refcounter"
> for short).  The refcounter behaves like the TSC -- it's a monotonically
> increasing value that is read-only, and can serve as the sched_clock.
> 
> And yes, both the Hyper-V timer and Hyper-V refcounter code is in a
> source file with a name containing "timer" but not "refcounter". But
> that seems to be the pattern for many of the drivers in
> drivers/clocksource. :-)

Heh, wading through misleading naming is basically a right of passage in the kernel.

Thanks for the reviews and testing!  I'll fixup all the changelogs.

