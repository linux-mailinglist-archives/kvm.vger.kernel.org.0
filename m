Return-Path: <kvm+bounces-56607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A58BCB40961
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 17:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03AD3542427
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 15:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44FA32A82A;
	Tue,  2 Sep 2025 15:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="2zZ8Oasy";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="CbELGlnz"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632F2324B1A;
	Tue,  2 Sep 2025 15:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756827702; cv=none; b=ngdEmKhoBoXNC/EYzkszhEPsQyytkoeQ03r7t8b7swheMGTVFu3RqooVIChgPiLTQg9Y1O/Mb9WTQYbuFiabSb203vBOGBZHF/TtrLUk/DJEheBRkgL0QD8W7+hA0A2b8ic8eMnsRsg6CQ5muPy1DPR9SVZ9aMSpZvtaNcuJvZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756827702; c=relaxed/simple;
	bh=x33XkRQZmTF0t4JK6plAC/PahprcBBIFiMnsKSn2e9A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eKaRptLwEsTGACD/QsqgUSiNJuIIogVHDe/iZRnO6E/cNU9uiUtlaTJG42O5doYUhuWTZ2hoQZVcyPIskbN4pWdUnHgc/Qopgd25OWco2eoIYzpPKz7LsXdq6AoJ0ZfcX5at+OKoP6ZhW4djqDYc9qe5lATpWrBhFEmXS1Y5AqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=2zZ8Oasy; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=CbELGlnz; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1756827699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pGwYTKhGfWnlBOKIJz2ymmNYWDHnVcRdnTi9w0My2J4=;
	b=2zZ8Oasydxmvlshi+0hPu1sllPKmuKAIhq/xyqKhr/ICLKxEbNE0Y8arXmULIhFseyznbC
	NlsSLx1j+NShWRw4gbfZYL8ad5Y7lWn8tb1mtzBcqKCgFv1WeUGKNq+n7XQhESEv6T34k/
	n78/Em8081lAQ+c0FZDT1a52G86GycH2kX6jzJhFFVWxLjuPwg8RTepS8e7qQA3UHoxMNI
	+IpQnlz/nMshQLJtN/61G6QO6p2VGZrRfWPs6kIiw2HVPD/gE0RaT4ds+sXRt+9jlzH+BL
	fwA1t27rhnwV3uIP1p5Z+Vmh74rHjoSwepM5Lm9+8N4mVvRUU07myiLH1ff+xg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1756827699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pGwYTKhGfWnlBOKIJz2ymmNYWDHnVcRdnTi9w0My2J4=;
	b=CbELGlnz4Ygw+ApxTHhD0Wzrjj/QAZbjUecQqluEnw1bvfySdSmzQUCOWm89MgF184XaOn
	VBamn8Ys02TYr6Bw==
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
Subject: Re: [PATCH v2 4/7] entry/kvm: KVM: Move KVM details related to
 signal/-EINTR into KVM proper
In-Reply-To: <20250828000156.23389-5-seanjc@google.com>
References: <20250828000156.23389-1-seanjc@google.com>
 <20250828000156.23389-5-seanjc@google.com>
Date: Tue, 02 Sep 2025 17:41:37 +0200
Message-ID: <87wm6gzwsu.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Aug 27 2025 at 17:01, Sean Christopherson wrote:
> Move KVM's morphing of pending signals into userspace exits into KVM
> proper, and drop the @vcpu param from xfer_to_guest_mode_handle_work().
> How KVM responds to -EINTR is a detail that really belongs in KVM itself,
> and invoking kvm_handle_signal_exit() from kernel code creates an inverted
> module dependency.  E.g. attempting to move kvm_handle_signal_exit() into
> kvm_main.c would generate an linker error when building kvm.ko as a module.
>
> Dropping KVM details will also converting the KVM "entry" code into a more
> generic virtualization framework so that it can be used when running as a
> Hyper-V root partition.
>
> Lastly, eliminating usage of "struct kvm_vcpu" outside of KVM is also nice
> to have for KVM x86 developers, as keeping the details of kvm_vcpu purely
> within KVM allows changing the layout of the structure without having to
> boot into a new kernel, e.g. allows rebuilding and reloading kvm.ko with a
> modified kvm_vcpu structure as part of debug/development.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

