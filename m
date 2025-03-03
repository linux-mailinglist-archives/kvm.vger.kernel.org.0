Return-Path: <kvm+bounces-39884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49BA5A4C2EC
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 15:11:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66E7B1640C5
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 14:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B5E2139A4;
	Mon,  3 Mar 2025 14:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="RWV4zZ1f"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53A220E03C;
	Mon,  3 Mar 2025 14:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741011073; cv=none; b=KxG/7/pGcVBEylmxQGV5q8i4vrMUSQoIjxW3dldi3W3OSAykoo5yQWe+bSTl0togcrP5IuHD3n6g/QWmRpA3hgHB9EnKjisRkgwZ6/54d41eXYe95VGRndORVooBROLYzMwol63UJpoGj3tyBq1rtfGGUotlBelZ96MrrnubmrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741011073; c=relaxed/simple;
	bh=7Cs8+xD0eyRv5jjLhLfMj+HmulqJJeMsFqQidfj0T9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmvKrmywOWlxW0DLYsxHDvq4MvmmsR3DQpV2J6U8M44Ye4qZhDJd2F+dEKvzRTsH9Xl+Ao9o4o8nFvTTPDRyDrfwcVkhBxDtcEH+xWyj+h2Aszxpd+ijbUMYQwkWT4hREu56eGOWJz+mYCOAth+svK+ODXQkn0PK2ieGIIgw2C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=RWV4zZ1f; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7373440E0216;
	Mon,  3 Mar 2025 14:11:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id GDnUHKTQ8ZrC; Mon,  3 Mar 2025 14:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1741011064; bh=4Z1HILAtOOSuw4f8u0TuP4N4mKWHdFYqQRdroELwqAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RWV4zZ1fQc16+fz4gY0XAhbqJbDgyYexDEzCsnztJHL0C7CklpquuRcKK3WyemQCj
	 +PTVkUFWXIBLbG6EPlcWiD4jvDUHpgBtqBVzOZd7G55cwo912sNUAW3M7lT5k6Zafk
	 yS0H2MkwJekqJD2hEFTFh8gWgGuABGtxvohaJGdfy59NeDmUOKoRfbZHvGtcz8FK2n
	 RJ022mX6FbsuDg7Fem5oaj3vsRx4VSEptDLXcs/dOco7CH+NMtT1ruCUWiXSOkmSS5
	 6kPWn3pXXku5onTI9lCUrGlLzbwLWNCwbRGBj3kwfQWa9mPHPtNI15NuMroF0yaafM
	 eFnutA245v5BqPxuCPrNzKMaKzA66+Y6lvWnO1k046J1j1sECSAwzuPa/EduHXtJzB
	 rMAp4sF+LligfjSGYYrK0YHMoXlZ+sNPVtsemoAGvLkarpEXYq0UE1UHQHUdxbu8aG
	 aSwNVi1B1umgqQY1ABCGhID9fwy6Ub5qMDLYlxhu5DPZF/EQW0izmU+xeJc48B/P83
	 LcDiCf1N0X2NKd8Mz1IrfBTNdAvOYTzbcisd/q7fLs8K94z6WULLtFBx5ht9lqrrn+
	 YSKRcTpxJSq3g0bbHenlgB+DtBynbj5yzeQWbJtcdmSJnwfomqmGzFOtaaJGAQidg9
	 tuKEIMCceB0P7PgyJyuobaec=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0E3C740E01D1;
	Mon,  3 Mar 2025 14:10:51 +0000 (UTC)
Date: Mon, 3 Mar 2025 15:10:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Patrick Bellasi <derkling@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>,
	David Kaplan <David.Kaplan@amd.com>
Subject: Re: [PATCH final?] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250303141046.GHZ8W4ZrPEdWA7Hb-b@fat_crate.local>
References: <20250226184540.2250357-1-derkling@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250226184540.2250357-1-derkling@google.com>

On Wed, Feb 26, 2025 at 06:45:40PM +0000, Patrick Bellasi wrote:
> +
> +	case SRSO_CMD_BP_SPEC_REDUCE:
> +		if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
> +bp_spec_reduce:
> +			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");

Probably not needed anymore as that will be in srso_strings which is issued
later.

> +			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
> +			break;
> +		} else {
> +			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE_NA;
> +			pr_warn("BP_SPEC_REDUCE not supported!\n");
> +		}

This is the part I'm worried about: user hears somewhere "bp-spec-reduce" is
faster, sets it but doesn't know whether the hw even supports it. Machine
boots, warns which is a single line and waaay buried in dmesg and continues
unmitigated.

So *maybe* we can make this a lot more subtle and say:

srso=__dont_fall_back_to_ibpb_on_vmexit_if_bp_spec_reduce__

(joking about the name but that should be the gist of what it means)

and then act accordingly when that is specified along with a big fat:

WARN_ON(..."You should not use this as a mitigation option if you don't know
what you're doing")

along with a big fat splat in dmesg.

Hmmm...?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

