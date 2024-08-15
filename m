Return-Path: <kvm+bounces-24294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17AC3953766
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5613283E29
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40EF81AD9D9;
	Thu, 15 Aug 2024 15:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="3ErciNwy";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="y8SN6SIe"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149A019DFBF;
	Thu, 15 Aug 2024 15:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723736185; cv=none; b=dqwQI7FXt4W+lHKGiN2uj70OPSo8kmG37hZM1AxWLzyFcaogCJ1m+gQfNfOKOyvRllb+4YY8kjnamm/fucDavKe49esorwdAD+APjQoKY3WWoDbhqEVPh6nYGhXrLSsgqaaI1hdHAY4GYx/stqHXGmVil73H4E7/5ojs14tyAb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723736185; c=relaxed/simple;
	bh=GOrcWSBGiHfxM5jTSRxcdVTqhLOXrjKH1YH/qODAfzg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Bndcbz++1vBf8K2QmjLPMajIJ0LmtedA34SoTo06n4pH8v8hEWp8Jvod36Lde5rVdveL+t6Y4iHqKHyD56uCfr+MiOj2p2/UyN9h/gZ0FuRt5aBuUEPSZZx1rQo8UKU2g3MYUtZR09G/nB1Ux9f53uA1vhzIS2SmmVWp0rMG8lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=3ErciNwy; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=y8SN6SIe; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1723736181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GOrcWSBGiHfxM5jTSRxcdVTqhLOXrjKH1YH/qODAfzg=;
	b=3ErciNwyC3RcUZ2XrJCQ+5cAApNAZmaFCfdniDypV1oE+80iym83GC4uPI6R8doA1e13Xd
	1uSVojJF7k2Gcxr9D45P6ptxdVT3RlauVBynUhSVhOVRC2AhNa6MHfZD7Yo9viibiAyoyx
	q7kMp6Y95WOhU7SE4yey4dUj0Qecc8xLMFlwjeI0DTyFXeaqnYooSF7M0gkMfN/t7qSpFY
	8a1xWVFXXxKfLSMsxBiORwOUcWih1uWBtgHMnXkKwBuzdZqT1CacPxUqan8Ge3j49AUIKk
	IkjabPYJUppQeyp4AYAwaXZVx7iBuPIeFmxF+eoj4150OmpROSoavFWIG4cnig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1723736181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GOrcWSBGiHfxM5jTSRxcdVTqhLOXrjKH1YH/qODAfzg=;
	b=y8SN6SIe3gMUmsrAmKE0PcvEIU9w2rK7dyf3QixJXfcWQzHFwXeIM0HQ1039oxJTGbE/XN
	AzBglGhNZFmFQdCw==
To: Sean Christopherson <seanjc@google.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Xiaoyao Li
 <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, Jim Mattson
 <jmattson@google.com>, Shan Kang <shan.kang@intel.com>, Xin Li
 <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v8 02/10] x86/cpu: KVM: Move macro to encode PAT value
 to common header
In-Reply-To: <20240605231918.2915961-3-seanjc@google.com>
References: <20240605231918.2915961-1-seanjc@google.com>
 <20240605231918.2915961-3-seanjc@google.com>
Date: Thu, 15 Aug 2024 17:36:21 +0200
Message-ID: <878qwxn6h6.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Jun 05 2024 at 16:19, Sean Christopherson wrote:
> Move pat/memtype.c's PAT() macro to msr-index.h as PAT_VALUE(), and use it
> in KVM to define the default (Power-On / RESET) PAT value instead of open
> coding an inscrutable magic number.
>
> No functional change intended.
>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

