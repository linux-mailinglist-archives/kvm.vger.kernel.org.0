Return-Path: <kvm+bounces-29959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C629B4EB4
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 16:58:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C5AE1F2376B
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 15:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55F8F196D8F;
	Tue, 29 Oct 2024 15:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="h8WAM8ke"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFB91917F9;
	Tue, 29 Oct 2024 15:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730217488; cv=none; b=Z+viNLmM16TCDZO9I+i5cc9IVanHZIPDOQ1QwdlauCm2mcDIn3IPrTzB2UZ9OenaZqMiXciiNBsljnt8H8hRxySQVT9aZvtcFLfybYSUIXKcG2jZ1wdrX/vsO3Mj6Y8m8O+YynNhWFptklvYKcfBIieb/tRyCu53yXeGi2Qxtog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730217488; c=relaxed/simple;
	bh=XR9+om4ScVOdEArtXJ+HMBDzmeQKqanXDaij5mePADg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/tGl3UB2D4+s/ZOBmXcrwwr4N11rOl6UUEBJJ5gHqJ87AvRpxoxJthomoj7WiTjiGTqFc3KDhiNvidEsNn66UTOM1fzj57xDTGevhaMDm/39thVgx2bOvSuDHCTn9dYC6bJ2xx0dWi2Z8L/mHdadQmKVrQvkJ0ts+IxsqNJGWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=h8WAM8ke; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3F60640E0192;
	Tue, 29 Oct 2024 15:58:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ldU0KY-akd8y; Tue, 29 Oct 2024 15:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730217477; bh=E1Eu7/CBiDK5On1k+8E/px28Z45wOChcdzeICfvDRzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h8WAM8keOTA41hoTZsaqP2W9fPo3U+SuC88JgXDHD3V1sXgn9xTakKxxcl95U7juT
	 fXpmYMCp4qvHwHQgCki9OXTKURBxFfCCZzS+DQF7f5A26OAfowweresr6iIBq2BOj+
	 RaJ3qaUP2BFK5SyUZl2p7niObXa2A+4xwPuvxwnsPF+66E+eEIJSZU0pfQBeDqLABO
	 7EgvNMCm1/V+fxdd+Kc2Numu4Iob3LJzOAT6OyQJn0EemUZ9nnBokXvmon2kBhLep0
	 z2tnPetKyt+hEwMXdL9Ne54gvtjDvL1MzdX40UKGSs/w281XTCq7tm6cmhkDA1Rdhb
	 8yiDJ/a8w6HuW1JreIveP+yIN81AxxaRqNNDKgpky714vMQ0nDGynOu5dJx0xprUO7
	 uwZl7kUGcfpNPG5BEOfwfQ2iKb6ZhFNbejGnLmEMcA5aOgH6BaO4AfM2vzwFuNnEVl
	 47eY+qsIFikmdI70RUGzTwFSoCjmdd/WuJtLTXTZBMoquY/D3pd5sFuuVTK9WOBwU1
	 eA+tOHx0G8e0Dw0SpEjaTM/9/O6tjeZ+7yOAQ+WzebZ1mEFQBcthMoSgF0rbZEUX+1
	 G5LUj3M/ynVzJ1P5QAbv/YUgReYGviCHiuLnuExD9o6x89E8O+jwZNZj+5wXpLrkQt
	 qa35yR9r7HmqoKXOKtfq28OU=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0078F40E0198;
	Tue, 29 Oct 2024 15:57:44 +0000 (UTC)
Date: Tue, 29 Oct 2024 16:57:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20241029155739.GNZyEF88OV1m-tU94h@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <3ea9cbf7-aea2-4d30-971e-d2ca5c00fb66@intel.com>
 <56ce5e7b-48c1-73b0-ae4b-05b80f10ccf7@amd.com>
 <3782c833-94a0-4e41-9f40-8505a2681393@intel.com>
 <20241029142757.GHZyDw7TVsXGwlvv5P@fat_crate.local>
 <ef4f1d7a-cd5c-44db-9da0-1309b6aeaf6c@intel.com>
 <20241029150327.GKZyD5P1_tetoNaU_y@fat_crate.local>
 <59084476-e210-4392-b73b-1038a2956e31@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <59084476-e210-4392-b73b-1038a2956e31@intel.com>

On Tue, Oct 29, 2024 at 11:14:29PM +0800, Xiaoyao Li wrote:
> However, how secure TSC related to memory encryption?

Are you kidding me?

Secure TSC is a SNP feature.

I don't think you're getting it so lemme elaborate:

mem_encrypt.c is only *trying* to be somewhat generic but there is stuff like:

        if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
                snp_fixup_e820_tables();

for example.

Both TDX and SEV/SNP need to call *something* at different times during boot
for various reasons.

We could aim for generalizing things by doing per-vendor early init functions,
which is ok, but hasn't been the main goal so far. So far the goal is to do
the proper init/setup calls at the right time during boot and not allow the
code to grow into an unmaintainable mess while doing so.

But both vendors need to do different things at different times during the
lifetime of the kernel depending on what they need/want to support.

IOW, the memory encryption code is still shaping up...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

