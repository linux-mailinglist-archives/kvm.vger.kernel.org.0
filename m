Return-Path: <kvm+bounces-3721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 573D680759F
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:47:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6757B20F03
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC24487BB;
	Wed,  6 Dec 2023 16:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="WsdGjuy9";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zPV2A6Xb"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C070D4B;
	Wed,  6 Dec 2023 08:47:10 -0800 (PST)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1701881229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mlX5bK9jkIYszrItVZG6UIm+wb2FCPZ+a8JRRZLLJgw=;
	b=WsdGjuy92AUUgDroYMjxG/jjQokVwKuBpSRYKmbmKd27tnW+EBxywajIZvVmMvunJYDut4
	M2fMiafaRNRQcbDPDENTfDlngU58oPWHlVrZLQhbs1lmLofnIfQkT4nT92HdAAZZyWKmj3
	zNOxPPB7VpkCECybOIPIh/crjw4zw6mE++bZVhud7B0edKXPaPQJoBQ4QlMykz8v3onevb
	NEwo+F1UuzDn6eKT/tBpsvFpnfohbwDfWdzSwcd9uJozVzAjV3ZiMXgoDI5vyGH3UMD/tc
	MJ+tjGfpaCJHM3P+zKxiYs3amK88NsnldNObPA4su6OduYftUH+8F4oBTX3bDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1701881229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mlX5bK9jkIYszrItVZG6UIm+wb2FCPZ+a8JRRZLLJgw=;
	b=zPV2A6Xb8rPOnsnoIaveB7SGyrLEQWwOdtoG9FO9qLV1E8eJ37cjtSbqMixexg8DdTdt57
	m8XIQJFOQhX5BBAg==
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
 <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
Cc: Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, peterz@infradead.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH RFC 03/13] x86: Reserved a per CPU IDT vector for posted
 MSIs
In-Reply-To: <20231112041643.2868316-4-jacob.jun.pan@linux.intel.com>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
 <20231112041643.2868316-4-jacob.jun.pan@linux.intel.com>
Date: Wed, 06 Dec 2023 17:47:07 +0100
Message-ID: <87r0jzuvlg.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sat, Nov 11 2023 at 20:16, Jacob Pan wrote:

$Subject: x86/vector: Reserve ...

> Under posted MSIs, all device MSIs are multiplexed into a single CPU

Under?

> notification vector. MSI handlers will be de-multiplexed at run-time by
> system software without IDT delivery.
>
> This vector has a priority class below the rest of the system vectors.

Why?

> Potentially, external vector number space for MSIs can be expanded to
> the entire 0-256 range.

Don't even mention this. It's wishful thinking and has absolutely
nothing to do with the patch at hand.

> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  arch/x86/include/asm/irq_vectors.h | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
> index 3a19904c2db6..077ca38f5a91 100644
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -99,9 +99,22 @@
>  
>  #define LOCAL_TIMER_VECTOR		0xec
>  
> +/*
> + * Posted interrupt notification vector for all device MSIs delivered to
> + * the host kernel.
> + *
> + * Choose lower priority class bit [7:4] than other system vectors such
> + * that it can be preempted by the system interrupts.

That's future music and I'm not convinced at all that we want to allow
nested interrupts with all their implications. Stack depth is the least
of the worries here. There are enough other assumptions about interrupts
not nesting in Linux.

> + * It is also higher than all external vectors but it should not matter
> + * in that external vectors for posted MSIs are in a different number space.

This whole priority muck is pointless. The kernel never used it and will
never use it.

> + */
> +#define POSTED_MSI_NOTIFICATION_VECTOR	0xdf

So this just wants to go into the regular system vector number space
until there is a conclusion whether we can and want to allow nested
interrupts. Premature optimization is just creating more confusion than
value.

Thanks,

        tglx

