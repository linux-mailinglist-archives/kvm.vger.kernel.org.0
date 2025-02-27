Return-Path: <kvm+bounces-39544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38A84A476D5
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 08:49:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BE2016D9E6
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 07:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50DC2225768;
	Thu, 27 Feb 2025 07:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="j1XjA1dW";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="8ISW4tf/"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7DF223308;
	Thu, 27 Feb 2025 07:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740642543; cv=none; b=HavFXeV30B1hMbmXYvH0zQLzSoHAJVFPkdzrx1eWybl/q4FNNcD0bBc5JV0ioNUWNJb2ccoB3Gb6El2NXau274rUIDG4PzUBrFMsU5Jvl5f3w59vcTBcZz/NcQhs6ZnrSZ3+Aton+TrH4cY6Im52LtprN0BTo3OwEAPRqdSnZ3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740642543; c=relaxed/simple;
	bh=8xHwxb7DULW5yuedeqj1TqfqkEO+Z4YwLcQFV1stEpA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nXE3cNIYmMg396/yEdsk79Ryvgw1Guv1mzwlJoUqabCGh6JktN6zsN+tjQ9UGFTZG31Qz5T7zRiRiSEqKuw08sghEfPPWZvxACh4A3jE0BUm+kzJsYwwaEUkPWyUOqkoWvMCjo12RHeD1JI6ho7fI/flRUDTvEKbBHJijPnjuvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=j1XjA1dW; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=8ISW4tf/; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1740642533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z/FiwpGgcFsUVJIrAAggZ118vbyRdPHUpVwLgvzzG6g=;
	b=j1XjA1dW4vnGkpn5Ci9y75c6Hdtwk4+Ny32gBE+duhCt1GqH+SXgRR8OpfDqAuGbWuEt1h
	5EJbYwhnGxs5hjLOxbM+6Emv5CZEuK3td6X14YzCv3acdSA9qJBj39CKJLgzNXURkKDViy
	0iBhoMl/MyKy3kGACfuxeLZzn/9ezs2VF+nelJPTcZFERUxRkA/Z16PYeh4FqaYt+wCxMI
	aXjwKb4z5MkbSu3pyzx965lwDghTQomZT81AkpHNuj9pZSh7BpG6U82ffo9q/wb1pqAdJA
	tKWZyeKKyru4urnzo1wUAlcKzsUWT7XqFBVJHaYqHguCn3LQgZ2m5ojNvENTqw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1740642533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z/FiwpGgcFsUVJIrAAggZ118vbyRdPHUpVwLgvzzG6g=;
	b=8ISW4tf/hrqDpFSd37qm+hMBh7bnHgcoCCi0Z02YB2HvefWAxjbmeiVp57WxbL7NKjJPKI
	kpAAcrCDeSx49VDA==
To: Sean Christopherson <seanjc@google.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Juergen Gross <jgross@suse.com>, "K. Y. Srinivasan"
 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu
 <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Ajay Kaher
 <ajay.kaher@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>, John Stultz
 <jstultz@google.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, virtualization@lists.linux.dev,
 linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, Tom Lendacky
 <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH v2 24/38] timekeeping: Resume clocksources before
 reading persistent clock
In-Reply-To: <20250227021855.3257188-25-seanjc@google.com>
References: <20250227021855.3257188-1-seanjc@google.com>
 <20250227021855.3257188-25-seanjc@google.com>
Date: Thu, 27 Feb 2025 08:48:53 +0100
Message-ID: <87r03jeska.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Feb 26 2025 at 18:18, Sean Christopherson wrote:

> When resuming timekeeping after suspend, restore clocksources prior to
> reading the persistent clock.  Paravirt clocks, e.g. kvmclock, tie the
> validity of a PV persistent clock to a clocksource, i.e. reading the PV
> persistent clock will return garbage if the underlying PV clocksource
> hasn't been enabled.  The flaw has gone unnoticed because kvmclock is a
> mess and uses its own suspend/resume hooks instead of the clocksource
> suspend/resume hooks, which happens to work by sheer dumb luck (the
> kvmclock resume hook runs before timekeeping_resume()).
>
> Note, there is no evidence that any clocksource supported by the kernel
> depends on a persistent clock.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

