Return-Path: <kvm+bounces-23589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29CF194B3E3
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 01:49:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3CBAB218F4
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 23:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75AC7156676;
	Wed,  7 Aug 2024 23:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="mwRjgUQO";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="yrr2Fp44"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413E384037;
	Wed,  7 Aug 2024 23:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723074554; cv=none; b=msFcSrawcT4HdG+ZMUDQFCF9BW2Dh0HqcWSIWqgPO/gCrvHGfvENWwm81FPnkHyfR+k6ZMuM/8wNZSrmoZrPZUm3aClJ63HuIMYf/nh9rwoW5GDDX4kY7rfN3W8wl8lecuVnSvZuA84k0BMv8/yfEmzY6LUWh/NASldUm+Jzmp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723074554; c=relaxed/simple;
	bh=Nwsz6GxfhCzQJBsLDjoZ5NvjHXq9GtdzHQAIhOWUQTU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PHiX5gul3EFaNdFKqOp9JXxb0CIapMWj9MsKBXobyV8Yzrnt5ESMeEJn8pqipYPKqT5tv+u4XPHRCSY3aPlM5WnZ1sleA78r6EMZG8dfL7n9Z2vYyG0I6oOahMFnYE4ZtwEdLji7x0DYBi35gY4bqO80rc6BNLTcQnXEp0mJ1iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=mwRjgUQO; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=yrr2Fp44; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1723074551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XZRorm74nHrSp8aUrFxSrWt6O0dZkbi/2sfeYCcIX/4=;
	b=mwRjgUQOwBTpo9ycF9ySiJjIpNHINT99aPQxpZAjcbGRFahrx7v1Nr+nslcilZ0BYSvGrw
	w2omUVMNyaKJ26tkzYQqwbO6c94FQfiPaO5I8VlDkEx9LgW6bXpOAmPCkq1XnEllVTR7Eu
	h/JI443aurQ9g51C3fgAcgRCGtRRSXK67lMKdCd/AfYGo8pOCihz01eGqvLJLYBsJwQGhM
	O7BeS6/mLMjOBKnB4yk7HdFmqfCqWESeR/V2lwkwkLkif+r0Ef5G7PwAvKT/0E+jD21bVy
	6mcKjtQJW2z89wSKDcbkCE8opuALDVe2AhWdS/aa8SpJPyHUBU4CR7O9xOGabQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1723074551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XZRorm74nHrSp8aUrFxSrWt6O0dZkbi/2sfeYCcIX/4=;
	b=yrr2Fp44pGNX5majUfSm0gFgYFyG7EGun+xPce5YxfbT397eZbugQcPm0Go+ZRX5mFFxo9
	Apuv8Q+nvQ3IFgDg==
To: Melody Wang <huibo.wang@amd.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Tom Lendacky
 <thomas.lendacky@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, Michael
 Roth <michael.roth@amd.com>, Melody Wang <huibo.wang@amd.com>
Subject: Re: [PATCH 6/6] KVM: SVM: Enable restricted injection for an
 SEV-SNP guest
In-Reply-To: <a3bab644689202150df01442bed43dad45b6852e.1722989996.git.huibo.wang@amd.com>
References: <cover.1722989996.git.huibo.wang@amd.com>
 <a3bab644689202150df01442bed43dad45b6852e.1722989996.git.huibo.wang@amd.com>
Date: Thu, 08 Aug 2024 01:49:10 +0200
Message-ID: <87zfpnzyfd.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Aug 07 2024 at 01:00, Melody Wang wrote:
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index dd4682857c12..ff8466405409 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -446,6 +446,7 @@
>  #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" AMD Secure Encrypted Virtualization - Secure Nested Paging */
>  #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
>  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* AMD hardware-enforced cache coherency */
> +#define X86_FEATURE_RESTRICTED_INJECTION	(19*32+12) /* AMD SEV Restricted Injection */

Please update the XML for this CPUID leaf at:

       https://gitlab.com/x86-cpuid.org/x86-cpuid-db

Thanks,

        tglx

