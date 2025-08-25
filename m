Return-Path: <kvm+bounces-55622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24B9FB344B2
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 16:55:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB018179C13
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 14:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A246F2857FA;
	Mon, 25 Aug 2025 14:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="B+y3ZhTg"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907622FC873;
	Mon, 25 Aug 2025 14:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756133663; cv=none; b=otvkH3fvY103hpxao0csM1QndV7ASj7NPRpVTlGKMahOdYgSwL7iC3+Nla5M68n3iHbcwPF32iAb+/c0MdozCQhw+o+LmYiP4saq9BzxfcXx23Ey4SMA/aGVih0P7ovSbcn5LfBqbE8Wzv1pEeiqDe8vVXh2S8fm8IV9kcmWWHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756133663; c=relaxed/simple;
	bh=27lu/Fxra3OrCCTNVCgoKqZX1LjKOWf5Tbhd/BUiLAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vu5HjsmImHEzLgmf2B7BhFdPURM9AZeXO2LGAtVXaY8sv9eEMema36lmTAgoLM5yoFwQP2PCFtJoHCIfKw1jhuFZXTXL1mxz414YOGQLEX5mcoMbxk5S+WePdbZMuylrkYajBurJU961SNooOo4+XeuqpmbPoDnJtA38XG1UbQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=B+y3ZhTg; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 52F3C40E0286;
	Mon, 25 Aug 2025 14:54:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 2WOTSlRdqRJD; Mon, 25 Aug 2025 14:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756133654; bh=8VV4pEI7u0jKSm7odI+J0qCqX1OEfjTGpTffiSpKExQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B+y3ZhTgSdfhkUGCZ8BE26pW/VKG0rdX9tkLjUb2SSq5rTm4+bBDdHx/+yhWbKXt5
	 uEQrxexcf5HwDVfo3jQiv+Sk+U3d/PPjzqLRbN3lzRAVJ3POxYxtv2EsbAOVv4AYYa
	 /nGDW4KVhUPt+BCQWAtwW3WgTzeV1KvqOlkMicsYmUDWaAZo6pCsWCMmFEnAmraH0l
	 CHRodDCzoy87woQXjTgGTnWTRSs99rYI6lCclajP8NjV1oBmRBDfh5agafsXDscr/y
	 eArKYmonLvgcWo8j1D+y5mzraqqD3SKq770viiths+nSKKGaDUXElRCUMaSFOGI/J3
	 fS9qXqDLsdmmoP6dSQSv2q5SRCVYjAWG0GWQ/WRauoybwk+DixvnWiGlWHyQGecDGQ
	 BYGWSMT3NCINJfGgvk5nJQp+MFvTJUQ783SwCOv5HgWO7K6ifEgHNhj+9Vm5tkxzck
	 LiDhSzvUUk/Z6k1yRVKXwiJ8PUQ8YX6UvLp29hNydQ4LXTu1iwDrKy/eM7fTCTEERO
	 uYz/yu061QsbN1ezGxJ+7hpJqLzjk4ZNtyTrws0+DfE6i49IYbwjkaUAYXZck/HxK+
	 vevVz4FkbQR6NxDPGPJyR3DIpeLF34KVlGlIIYim9z+BpidF2Ha77PxWbEZDQWYZD8
	 QKDmm2nNQaaYisWOhSU6Pki0=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7DBC740E01A1;
	Mon, 25 Aug 2025 14:53:52 +0000 (UTC)
Date: Mon, 25 Aug 2025 16:53:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [PATCH v9 09/18] x86/sev: Initialize VGIF for secondary VCPUs
 for Secure AVIC
Message-ID: <20250825145351.GWaKx4_48rQOqUYvZr@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-10-Neeraj.Upadhyay@amd.com>
 <20250822172820.GSaKiotPxNu-H9rYve@fat_crate.local>
 <a91b5470-33a0-4a23-ac1a-a7f1d4559cc1@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a91b5470-33a0-4a23-ac1a-a7f1d4559cc1@amd.com>

On Mon, Aug 25, 2025 at 11:55:44AM +0530, Upadhyay, Neeraj wrote:
> Ok. Below is the updated description:
> 
> Virtual GIF (VGIF) providing masking capability for when virtual interrupts
> (virtual maskable interrupts, virtual NMIs) can be taken by the guest vCPU.
> Secure AVIC hardware reads VGIF state from the vCPU's VMSA. So, set VGIF for
> secondary CPUs (the configuration for boot CPU is done by the hypervisor),
> to unmask delivery of virtual interrupts  to the vCPU.

Yap.

> I also don't see an explicit mention. I will check on documenting it in the
> APM. However, there are references to virtual interrupts (V_NMI, V_INTR)
> (which requires VGIF support)

Oh, I don't doubt that SAVIC requires VGIF - I just spotted a documentation
hole here so let's start the process of documenting this internally.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

