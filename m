Return-Path: <kvm+bounces-41653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 37274A6BAFA
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 13:45:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B64AA19C1E37
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 12:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B3E229B16;
	Fri, 21 Mar 2025 12:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="J286fOZ9";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="//HKCAf4"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9E0CA5A;
	Fri, 21 Mar 2025 12:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742561071; cv=none; b=AUnxh3ZEtAkdNwtw/LnBnXRfMqcyUlRNVbmT9GKzH+WQvcdu/G0ALqDKFvAJSEjHsUrUzSRAzoXnLJsPbQCamgBtJATsRazOqgOQZ5q+XdX/HwpVl7zyYkTLruyGzsWnhOoAoZ6sJ0IiQHEwHWZVfaSEpwbjRGtJJ2razxJoKVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742561071; c=relaxed/simple;
	bh=F9wq5b/9Z4dapIc7zXI602s+CF0Jvw8EUgIT8hhy2R4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jvkZ/OvsnfVKppaDOaKJJE4zgGWsvMNcbeHXQKTWf1w5/1pDvwstHb3LFOb92qSVa1Dz7zldOZ9US4E5psC6pcyGiecvQrzKYfk/LF9rATrlz3U7ZTSb3JSHSYcYWdC95DHk95OHzmhqqI8PjF8FHrD32WG/U10Ca9OwDwmpgjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=J286fOZ9; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=//HKCAf4; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742561067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Am601bcXnuFlc/N4uLCf/HWK0YPPJaXK8WE1j4yk+iU=;
	b=J286fOZ9VN5WGsx5h/T6XssjTTBzhwY718WOsyMRF77NVLajGd4GHl3cpyyPPLUUonwXVG
	W6lVUXZtTdFpl9TkMiX+nMDT+REKuB2a6iMtXhJ86umfx14GhI8URiOVitvRrqTLWtE9u8
	BZmjU7k9657UvunRzXPRFtrRBy4KP5Imqv/hrJx+t2dkYtpnlxx9pRXQ3IrdtozrJcWEKr
	psGykefvLNEFBXKF6rjXfijwWxCyGqM34derkWZ6QV3QuQIopp54kU8b1ZD2FtV8JZX4sF
	Ao/ERPPZ8Ee6kGxPGSutTcYW+LxLCZxVnk0ROdKNzYW63Bhyg/QY4r0JyB2a1w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742561067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Am601bcXnuFlc/N4uLCf/HWK0YPPJaXK8WE1j4yk+iU=;
	b=//HKCAf4IS4MMPxsCNmcDmlzn4zZfIf6gE90eO9g92wxxQkvS6PbLjHpb6lEEhP0B/c3mj
	JGkj0qat56ZrB8Ag==
To: Borislav Petkov <bp@alien8.de>, Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
 Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
 hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
Subject: Re: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
In-Reply-To: <20250320155150.GNZ9w5lh9ndTenkr_S@fat_crate.local>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
 <20250320155150.GNZ9w5lh9ndTenkr_S@fat_crate.local>
Date: Fri, 21 Mar 2025 13:44:26 +0100
Message-ID: <87y0wy3651.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Mar 20 2025 at 16:51, Borislav Petkov wrote:
> On Wed, Feb 26, 2025 at 02:35:09PM +0530, Neeraj Upadhyay wrote:
>> +static int x2apic_savic_probe(void)
>> +{
>> +	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
>> +		return 0;
>> +
>> +	if (!x2apic_mode) {
>> +		pr_err("Secure AVIC enabled in non x2APIC mode\n");
>> +		snp_abort();
>> +	}
>> +
>> +	pr_info("Secure AVIC Enabled\n");
>
> That's not necessary.
>
> Actually, you could figure out why that
>
> 	pr_info("Switched APIC routing to: %s\n", driver->name);
>
> doesn't come out in current kernels anymore:
>
> $ dmesg | grep -i "switched apic"
> $
>
> and fix that as a separate patch.
>
> Looks like it broke in 6.10 or so:
>
> $ grep -E "Switched APIC" *
> 10-rc1+:APIC: Switched APIC routing to: physical flat
> 10-rc6+:APIC: Switched APIC routing to: physical flat

It's very simple. Before that the default driver was logical flat.

838ba7733e4e ("x86/apic: Remove logical destination mode for 64-bit")

Removed logical destination mode and defaulted to physical flat.

So if you box does not switch to something else it keeps the default and
does not print. See the first condition in apic_install_driver().

But that SNP thing will switch and print....

Thanks,

        tglx

