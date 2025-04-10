Return-Path: <kvm+bounces-43074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A4E4A83C17
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 10:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 223033ACE1E
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 08:05:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44201EB5F6;
	Thu, 10 Apr 2025 08:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d4zbEXAZ"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318FF381A3;
	Thu, 10 Apr 2025 08:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744272310; cv=none; b=p9S3Ad2UYxr44JJ3IOOm29TfZimAK9y/fAPxKXcHfiAywVaTS9Ruuh6fqXc6tz+b+Cf4LWMC7VBrLf3c0k9aVNrYleTlio5oxH0sxRV/91ouye/p3oLoUf51QRdudl0MTtzVLYLdqi1zVff721SRq9DpzrQuBmlL7lmCksrKpng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744272310; c=relaxed/simple;
	bh=IxulY4YfJFvqSV0YcsQj0eRPgqF4sDaqNqzwMhtD+DE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q/lU1qeQE1ZTTjLb+eWi+VV8PWUKyXJ3o71W4V4c66/NO6FLKyFnw3wBv1jO6tFCQu9kV0PeDfLzdhMgnMsPrH0BvEd6w4HWffD6ZfE4PCkg0d3Ctafhou2bJfAT+fH9lWIck5wz87AMCQWrvTdbGHUFlacjgNgQC15UmIgHMFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d4zbEXAZ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IxulY4YfJFvqSV0YcsQj0eRPgqF4sDaqNqzwMhtD+DE=; b=d4zbEXAZ3d/QRC8bB/J3SExnty
	QEX5mVTXHvr3hTke0gOWXdwujtWBsMo2SO9ZAcp+fejjIioku3evoFzJNDHQFBr8TpZ2Deg8TmOJH
	HXOgTQv24RyAQs4XcI8iC3uoPRUjvN3nETceXW5QHkxtJORwYrc0f7Y5vGtrH4fSTtdbtdKHBNydq
	XYY++T3RSc57LMajsKWy++nyiOzLKGxOXHeTTNljJFtjBpZpoaPpGIPJGZwI5qM2RtMooEhlNcCdb
	AorRjWui1N49jKz1r7D7uzAmJ5m5pTqlT3kO08GCw4jrjexs/Fq4/GpZOnRJoXUnSsSArSx/cwRkt
	jpwjaypw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u2mu6-00000008mGw-3557;
	Thu, 10 Apr 2025 08:04:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 49F433003FF; Thu, 10 Apr 2025 10:04:54 +0200 (CEST)
Date: Thu, 10 Apr 2025 10:04:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Alexander Potapenko <glider@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm-riscv@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jing Zhang <jingzhangos@google.com>,
	Waiman Long <longman@redhat.com>, x86@kernel.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Boqun Feng <boqun.feng@gmail.com>, Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
	Borislav Petkov <bp@alien8.de>, Alexandre Ghiti <alex@ghiti.fr>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Randy Dunlap <rdunlap@infradead.org>, Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	linux-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>, Ingo Molnar <mingo@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 1/4] locking/mutex: implement mutex_trylock_nested
Message-ID: <20250410080454.GW9833@noisy.programming.kicks-ass.net>
References: <20250409014136.2816971-1-mlevitsk@redhat.com>
 <20250409014136.2816971-2-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409014136.2816971-2-mlevitsk@redhat.com>

On Tue, Apr 08, 2025 at 09:41:33PM -0400, Maxim Levitsky wrote:
> Allow to specify the lockdep subclass in mutex_trylock
> instead of hardcoding it to 0.

We disable a whole bunch of checks for trylock, simply because they do
not wait, therefore they cannot deadlock.

But I can't remember if they disable all the cases required to make
subclasses completely redundant -- memory suggests they do, but I've not
verified.

Please expand this Changelog to include definite proof that subclasses
make sense with trylock.

