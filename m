Return-Path: <kvm+bounces-56608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB9CB4094A
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 17:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E907189C38F
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 15:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FD0132ED25;
	Tue,  2 Sep 2025 15:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="VyVrqjW0";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="XeTuImc3"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E822DECA7;
	Tue,  2 Sep 2025 15:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756827722; cv=none; b=q4UV3j/5KPPOg+B9raSaLTUT2o0n3Uhy7CLPXkU7zU9xqd+iORpJX+4DcFQB0lTAtlK5XGm2NM2zA2pXiS2n5L3Jrl2SDU+ZNbl3q6U+vbWThodDe0pYnz9p7OhxQBbpkXjbdzzF0PR/HAGxqmCr0k8asRBrqkMseIYeZ+Hf+WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756827722; c=relaxed/simple;
	bh=rf+ayoYQtVHqsKr2ntB4r4DzbWqKRRg+TboWe56AIXU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iyzzDacnDDVfrk3q9DmMHWsFK5vd9fG/csWJn7G+w/gDSoBlUYRqlFKAv9KmQCSA5hYWFNjWmUetcAjDsctABHN2q8WDCANN9aJPmXHJXQnPHAmBtBNoBvVc10/NvgX6PB1NXe50DIbMwS0uEZowDtU2EG31bXtySTkOjj0+LDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=VyVrqjW0; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=XeTuImc3; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1756827718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rf+ayoYQtVHqsKr2ntB4r4DzbWqKRRg+TboWe56AIXU=;
	b=VyVrqjW0oc/fP+VCKsD3TZex6rjJTdvqEjBbH5z6EsBNG953f0Fzf4PsBLH1Iiftc3v7WN
	CVQNm9FcgNUB+JrhE/mu04u/vIebOAvvq8RqV6ZDA5IGposMcV7KxFRc1aiHWirp0LluXy
	vhygRapmmmZGz3XMSq+BCtyIyzwQkQFEKViJIYIz5c6P9CrMFJHaUTr9RyXF0k8ARF/5E7
	6kptr1XsL31+izs4LBrRZqkEHUrl7DsmstoUK4pi+jTMHucOCz761eW7ADzy3lkncCpG6E
	gXoMmu6HNzjaVxzwYDWWNfJoqlxefgWu+TfvebWun1Yl2hMVr3CcDpI8uJFBVQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1756827718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rf+ayoYQtVHqsKr2ntB4r4DzbWqKRRg+TboWe56AIXU=;
	b=XeTuImc3Eni7pqznmTyTILIYsXS7DICrATsX80L6vLacqVWb1h+AZnM5XFgxp53qCetuNB
	Ck94LmHJhvb+YXDg==
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Huacai Chen
 <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang
 <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
 <decui@microsoft.com>, Peter Zijlstra <peterz@infradead.org>, Andy
 Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-hyperv@vger.kernel.org, rcu@vger.kernel.org, Nuno Das Neves
 <nunodasneves@linux.microsoft.com>, Mukesh R <mrathor@linux.microsoft.com>
Subject: Re: [PATCH v2 5/7] entry: Rename "kvm" entry code assets to "virt"
 to genericize APIs
In-Reply-To: <20250828000156.23389-6-seanjc@google.com>
References: <20250828000156.23389-1-seanjc@google.com>
 <20250828000156.23389-6-seanjc@google.com>
Date: Tue, 02 Sep 2025 17:41:57 +0200
Message-ID: <87tt1kzwsa.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Aug 27 2025 at 17:01, Sean Christopherson wrote:
> Rename the "kvm" entry code files and Kconfigs to use generic "virt"
> nomenclature so that the code can be reused by other hypervisors (or
> rather, their root/dom0 partition drivers), without incorrectly suggesting
> the code somehow relies on and/or involves KVM.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

