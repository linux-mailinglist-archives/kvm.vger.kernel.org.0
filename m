Return-Path: <kvm+bounces-45699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4714AAAD9C1
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 10:11:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABAF0505319
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 08:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94AF3221FB6;
	Wed,  7 May 2025 08:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="U9OJdnun";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="2mJssq9n"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2B821147F;
	Wed,  7 May 2025 08:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746605334; cv=none; b=HQy5a+aVngF9QwTlbbinTMd2v9vmzqO6DRiGXeVIFg5c4EF5eXCv4GQDifSRJI5SLolJbzOff7grETroLWORQDem1guCwprIe9p4RCpZum14mpVNoY1Iez5pyDBLQ63e6QPFLdiv83Dml6Ec8Mx4bPHUi8kysr9TPgkMzeMbZ/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746605334; c=relaxed/simple;
	bh=DJOvH8mDWrpwPpnJ49SB0pWorTULYK1h+RYw8ATbCk0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=sMB95DroPexRqeEQo82T6WFIwlz/8dpAGl3yHJT+Adlfgb4vYWyKzB9rYyHjWRBo1eIOQdlX/bkbxLpCwAw/J0H9xzmLksDDf2w5SBY2yjzajaJXOxyFd983tMIJHRDoORW5e19UXJr64wASHGmLaIDzGj4D2RqXyHa5KaJAYQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=U9OJdnun; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=2mJssq9n; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1746605331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DJOvH8mDWrpwPpnJ49SB0pWorTULYK1h+RYw8ATbCk0=;
	b=U9OJdnunMdz1+EI/1y8j9I1Jx+Y3/gfks0KmWt+U22PsHeNsUM6qkIQaHAPZ1KLAM6Ywdr
	uQ+9Nhr/tErKIW1mqmNSgUJoCnrM3lPLXtTRIIUbsYu1hSneVo/8sps7pAroFsaAQpUA8Q
	ur72fL/sWsWzuOXC/9yiWIPQ013MR4kvcv/LOcUNBYwZ+iPWYe5dgtR/lJ3vgMPs20e4ZC
	USavLlpCm/CYNusrMVkypR0+ZmQWB9p81rHIVdcGyfNGW6F0M6N68sDp1vo9LDWmAA1JzK
	tVuqqzBchveuSKHz9Xu6XyVf5jcqMV9xu8MgYw+U28B/ZgSf9ICzHEjXMcGCqg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1746605331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DJOvH8mDWrpwPpnJ49SB0pWorTULYK1h+RYw8ATbCk0=;
	b=2mJssq9nO/iunEuhDHcY5B91/WvQI4fJ38yBn2SyFZS7A1bcin2QdJERIQNgixfs1iwm/u
	p0R51ADOwYQiPhBA==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v5 02/20] x86: apic: Move apic_update_irq_cfg() calls to
 apic_update_vector()
In-Reply-To: <20250429061004.205839-3-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
 <20250429061004.205839-3-Neeraj.Upadhyay@amd.com>
Date: Wed, 07 May 2025 10:08:50 +0200
Message-ID: <87r010n8q5.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 29 2025 at 11:39, Neeraj Upadhyay wrote:

$Subject: x86/apic: .....

> All callers of apic_update_vector() also call apic_update_irq_cfg()
> after it. So, simplify code by moving all such apic_update_irq_cfg()

..simplify the code...


