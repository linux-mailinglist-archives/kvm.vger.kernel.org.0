Return-Path: <kvm+bounces-25365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1BC69648BE
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:40:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13F0A1C22FE9
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB241B1405;
	Thu, 29 Aug 2024 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="KrQt/TTK"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5381B012B;
	Thu, 29 Aug 2024 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724942427; cv=none; b=prny2jRZOjFYFprMEVhEhuth7fdN/kFiZNdCUPDUN4DBOUa473IbE0j10gHWS4KY+gh2cYaP/IeljRXRDh/n26wXySM84DvQcXlBYobIlycI4H6XZkczjtht0EMXYbdP+tyri7F9F/JKoBoAjUHiRNMqed5cFdmCTHw8+Q4Ry24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724942427; c=relaxed/simple;
	bh=SftxwWbrNtKMd6oLF3bxnCEKIRmPXlUrJT8NF+wAbyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IyepONauUtWZdeSNtnR+MFAjpZ0qnw7HNBAC4022xGMfgtLRWn6fSc+NaI6GiaQCQlOhrIGlMiu3JDUV+FAHxD+BAijzpOEauuPcAxcIuMmG7sCeLlvE+szFQNJJ7bUH7+bYv4b84gcXIqT2bPTKDJSvJ+JwWoDxao+cDirSC2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=KrQt/TTK; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 00B1E40E0263;
	Thu, 29 Aug 2024 14:40:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3hXt4QUD73xh; Thu, 29 Aug 2024 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1724942419; bh=O+zT3c7g+nfKFQAW3i4+B/E3z+UfHpqlnaQDYR4t32M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KrQt/TTKNoCpQHk2xRfjBqK9rKn51MYIr8I1+xIowVrI2boDzmwCkumG7l/zyqJ0e
	 ESMb6z6FFJgR4A16DFBZlVAYVtuwdC4g53+7h34kQb5uB1D6w+XGX3JIPYJYfmVCl1
	 RXh11BQqK6PhVrwwI+ZH/T3lWtAC8DhL44q+AOleZLvj/iqHZQrnMBd8QpTa+/J0sK
	 LlvEW/wE9pz5msT+IHcKGL5saORL9vmYl1E3sTjlF+dVvwuRlChi98R4J0E5VO7d3x
	 A4iQBwjJKrAIpJGiszhdX3V6AZPVxeIQx/Qmkn/kENjUoW326hCQ8skxev2AjefTpi
	 n9qoJOH38XejXTV2J1LzFAsgHgxJTsHEtyCxa/cV+ZbehQs5wD/K0G1ve11LG1ukbo
	 D7uBGiLnWJmRx1Y/JA/LxjNqE4Z+G8Zc87SySDJnZvMSx6wH95ErfS38+24Kfo0eak
	 oe0GSKGZ92BhtEqKwaGxW6r/qmFfDECa8p8N+JXFHyqNs7KqckhG3jHQV5od6WxgTN
	 LoMv42wtInDDhPjPxDJ2Xr/xgT4wK/GlLWcxnXJmS6uT5w3e9ybtPX7UJykwUruYsG
	 vrN2tprPA86Xy5HrRi8bUizUCN3ERroYvdKnQM6emkfOXQT4FJ/h1+80j7cX295Pou
	 uyWEpmimBIadQhdJdYaQ2MIg=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 64D8B40E0275;
	Thu, 29 Aug 2024 14:40:04 +0000 (UTC)
Date: Thu, 29 Aug 2024 16:40:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, dave.hansen@linux.intel.com,
	tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, thomas.lendacky@amd.com, michael.roth@amd.com,
	kexec@lists.infradead.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH] x86/sev: Fix host kdump support for SNP
Message-ID: <20240829144003.GFZtCIQzK6SCrZsgyE@fat_crate.local>
References: <20240827203804.4989-1-Ashish.Kalra@amd.com>
 <87475131-856C-44DC-A27A-84648294F094@alien8.de>
 <3f887fb7-e30e-41f4-8ac1-bd245e707ccc@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3f887fb7-e30e-41f4-8ac1-bd245e707ccc@amd.com>

On Thu, Aug 29, 2024 at 09:30:54AM -0500, Kalra, Ashish wrote:
> Hello Boris,
> 
> On 8/29/2024 3:34 AM, Borislav Petkov wrote:
> > On August 27, 2024 10:38:04 PM GMT+02:00, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >> From: Ashish Kalra <ashish.kalra@amd.com>
> >>
> >> With active SNP VMs, SNP_SHUTDOWN_EX invoked during panic notifiers causes
> >> crashkernel boot failure with the following signature:
> > Why would SNP_SHUTDOWN be allowed *at all* if there are active SNP guests and there's potential to lose guest data in the process?!
> 
> If SNP_SHUTDOWN is not done,

Read my question again pls.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

