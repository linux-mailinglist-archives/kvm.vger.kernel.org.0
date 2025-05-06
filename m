Return-Path: <kvm+bounces-45600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2494AAC7CA
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:23:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68F827BF01F
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 14:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 678F12820CD;
	Tue,  6 May 2025 14:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jgy4Ccfq"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E200A15E5DC;
	Tue,  6 May 2025 14:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746541366; cv=none; b=RVFWkHMCs+bQEi1OCxM18agzhFXGbXW9iNtodsQp1uRoSS9fBzXn83AC05XA8iGgiu0Veydk7rYui4P4g4ApuYQy5MbHlZphocDYdsKXJZyrAPPmban7zwRFjy+Qeg4ja3h+Spg2w3sryEv375KFy1zRoOUNW9+96boDQI+ms6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746541366; c=relaxed/simple;
	bh=ZAqSEbsXGwAJha8vmzmKJrQMEo1vB2z12gMphbknyXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rAxsi8HzmUVMu3EKlskCaiOgK+lDCJd+kQDzllpMxIhSQKCGJgGevmxSOzaDL2k/QuPQW3H1qEp6bgyXfc0MY8EAONBP3m+GpE/cMu1G70v2TwOubI7QraxQgvlWyouJLa7tRkrYCN9XT7dXBi47N/gefVCQY2iYolFQQUX5OAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jgy4Ccfq; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A843E40E01FA;
	Tue,  6 May 2025 14:22:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TiIS_12gnCY9; Tue,  6 May 2025 14:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1746541356; bh=5uG7iiLE/nm+bAeu3HWka2R0/ZZ5zJHcClr8b2IHgEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jgy4Ccfq++xcOxmjJLbUEZ4rJHlPPJ3lk+Gg+us2KYdtTVsHpWovEsbtbd6k6FJVL
	 L2YLUvFnqGSljRsgqAbdLZMJ/gwy1v7zHyAKhpne5arDBdqvr1d98vNmSrgH+F8dXK
	 PTwBhWFO50eZXk19+yybwuS/mStjQ1i8bIVCe3o/Sw0t10ryFaa8SDR1AdMFiCzqfz
	 /OZDK4Nyz9bX5qAUDPXCxO3vL4otM2JI400kFdZaqPAjN0qAENOCkWcG7NDbdFELZW
	 FImdVZWxn7tH20Kjdg7z7AY4n2ZyrQhlcCgui8dpt0rs3vAtI/9b5MECEVHGhGkv2w
	 4wWDbV3Lp5bvCuvMvC1LXxgr74X5m7KUNhrBD0injdQphPC/xoF36mdtZqEDyW9Jv4
	 c0163OmAR/71QhQsT4DPuR7yVRSdwKIszLns49IhQLoqwgE9ZXbmsytYj+eL01iF4d
	 c9faQlBiUVFVIp7/rwBFW9MUmVaLHiCdRKYgM3t2k2kk+uDUdolihFI+uEb1eyDAMb
	 PMKu8EsEt49gPDOeEUMkEnIiEosaMAChnTpUnP12kXciQDos6GBgxMAlYiX+LEw8Vw
	 Elz17G8uUtqX2FeJAvy1F/85Y0i/0P2DLpuueohINd1mxlZGb3zTHBvpcQOxdg5eSv
	 IjnHgxFXnOj9zRZ19FxI3U48=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3BBC040E0196;
	Tue,  6 May 2025 14:22:31 +0000 (UTC)
Date: Tue, 6 May 2025 16:22:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Larabel <Michael@michaellarabel.com>
Subject: Re: [PATCH v2] KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1
 VM count transitions
Message-ID: <20250506142230.GFaBobJucboX7ZWnxi@fat_crate.local>
References: <20250505180300.973137-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250505180300.973137-1-seanjc@google.com>

On Mon, May 05, 2025 at 11:03:00AM -0700, Sean Christopherson wrote:
> Set the magic BP_SPEC_REDUCE bit to mitigate SRSO when running VMs if and
> only if KVM has at least one active VM.  Leaving the bit set at all times
> unfortunately degrades performance by a wee bit more than expected.
> 
> Use a dedicated spinlock and counter instead of hooking virtualization
> enablement, as changing the behavior of kvm.enable_virt_at_load based on
> SRSO_BP_SPEC_REDUCE is painful, and has its own drawbacks, e.g. could
> result in performance issues for flows that are sensitive to VM creation
> latency.
> 
> Defer setting BP_SPEC_REDUCE until VMRUN is imminent to avoid impacting
> performance on CPUs that aren't running VMs, e.g. if a setup is using
> housekeeping CPUs.  Setting BP_SPEC_REDUCE in task context, i.e. without
> blasting IPIs to all CPUs, also helps avoid serializing 1<=>N transitions
> without incurring a gross amount of complexity (see the Link for details
> on how ugly coordinating via IPIs gets).
> 
> Link: https://lore.kernel.org/all/aBOnzNCngyS_pQIW@google.com
> Fixes: 8442df2b49ed ("x86/bugs: KVM: Add support for SRSO_MSR_FIX")

I guess

Cc: <stable@kernel.org>

as the above is in 6.14.

> Reported-by: Michael Larabel <Michael@michaellarabel.com>
> Closes: https://www.phoronix.com/review/linux-615-amd-regression
> Cc: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

LGTM, seems to work too on my machine.

Tested-by: Borislav Petkov (AMD) <bp@alien8.de>

Thx for sticking with this and improving it!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

