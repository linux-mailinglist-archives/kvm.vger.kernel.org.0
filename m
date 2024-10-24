Return-Path: <kvm+bounces-29657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D64B99AEAFA
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 17:45:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13E211C21E1C
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 15:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC5D1D63E5;
	Thu, 24 Oct 2024 15:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s50vYbHV"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25D11EC012
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 15:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729784706; cv=none; b=ixLLjgHSKhhUY0SQFBkaBuN2nr42iVpo8wdzKnawTVmy23j3Aa/pyLrfIUS+R9Spf4kk85ebJwYP9tekhZSgcRjFoI0I6Kz9aPaLZ36dJT+mEBT+UuTtnEovvvorWgTHR7oQmBGCLzY39mG6enEv3wYZuZWDB6aIR9O3JRRYq3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729784706; c=relaxed/simple;
	bh=6I8qbzz7ximcghGIEO2unZUAhIwsriatLvIqpMrCiVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BwQKVaeJ4/GvSoJMifvkyCG8tVLNVo5rR6PNHcd5DkkkDYMhRaErWXwOs4VZ/1ylWiPC20ZcnLBXDeyFbbnwDd4lEdXxq9A0LxVGl4x7zgIm6T2bx3eqCMCKNvK7Osb7nv76RbwBqLbhhP1VEp3U/h4lMOBr3O7o603VkLMJBaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s50vYbHV; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 24 Oct 2024 08:44:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729784699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xk+d7Z4LZ/1qTUjGCbC24ANWAiUATci3sfG2VV3bTQI=;
	b=s50vYbHVxKPriUbyijJqut9CFyImL7JtJpvwDxKnlDeEWu3JMYeEzlCBWWd7ZMruwnOqpB
	VvDIZ8L5egp9CDD+dEudN1zYCjKmiTOapnHBxzklWRdAQEN0aLLfETohBS6o3AAwYopM35
	7GdUuWw1gJcZCYJU/S3qn5AlPO0oBdg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Miguel Luis <miguel.luis@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
	Shuah Khan <shuah@kernel.org>, David Woodhouse <dwmw@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	Francesco Lavra <francescolavra.fl@gmail.com>
Subject: Re: [PATCH v6 6/6] arm64: Use SYSTEM_OFF2 PSCI call to power off for
 hibernate
Message-ID: <ZxprcWDe2AXuLhD_@linux.dev>
References: <20241019172459.2241939-1-dwmw2@infradead.org>
 <20241019172459.2241939-7-dwmw2@infradead.org>
 <23C91005-7304-4312-A5E0-F5E6C05B3209@oracle.com>
 <ECD0CA58-2C3B-48F3-AF12-95E37CB0FC48@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ECD0CA58-2C3B-48F3-AF12-95E37CB0FC48@infradead.org>
X-Migadu-Flow: FLOW_OUT

Hi,

On Thu, Oct 24, 2024 at 03:48:26PM +0200, David Woodhouse wrote:
> On 24 October 2024 14:54:41 CEST, Miguel Luis <miguel.luis@oracle.com> wrote:
> >Perhaps spec. F.b. could be accommodated by first invoking SYSTEM_OFF2 with
> >PSCI_1_3_OFF_TYPE_HIBERNATE_OFF and checking its return value in case of a
> >fallback to an invocation with 0x0 ?

This already complies with F.b.

The PSCI implementation is required to accept either 0 or 1 for
HIBERNATE_OFF. Using 0 seems like a good choice for compatibility since ...

> I wasn't aware there was any point. Are there any hypervisors which actually implemented it that way? Amazon Linux and Ubuntu guests already just use zero.
> 
> We could add it later if such a hypervisor (now in violation of F.b) turns up, I suppose?

IIUC, you're really wanting to 0x0 because there are hypervisors out
there that violate the final spec and *only* accept this value.

That's perfectly fine, but it'd help avoid confusion if the supporting
comment was a bit more direct:

	/*
	 * If no hibernate type is specified SYSTEM_OFF2 defaults to
	 * selecting HIBERNATE_OFF.
	 *
	 * There are hypervisors in the wild that violate the spec and
	 * reject calls that explicitly provide a hibernate type. For
	 * compatibility with these nonstandard implementations, pass 0
	 * as the type.
	 */
	 if (system_entering_hibernation())
		invoke_psci_fn(PSCI_FN_NATIVE(1_3, SYSTEM_OFF2), 0 , 0, 0);

Thoughts?

-- 
Thanks,
Oliver

