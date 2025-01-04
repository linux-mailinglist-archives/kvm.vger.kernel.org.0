Return-Path: <kvm+bounces-34554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33C9CA013F1
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 11:29:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10E86163C9D
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 10:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03C01B2186;
	Sat,  4 Jan 2025 10:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="QUEk8gh1"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6781E507;
	Sat,  4 Jan 2025 10:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735986529; cv=none; b=Wv8Nc+URT7Y5YEQcvsGCTRYSBxwgDmxB7XXFlj351EvxmfgdeQxls1TD9zcEPfiUm/5wgLqzSANCsQtkSrrxbb2WjdWVIvL7M6y3fFvL9CqF8apA0dgq+33H/KFmHBaABHHwJgCGN9WsOFcD2DfE7j2p6aMA7lBJuD3Qx0ERV+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735986529; c=relaxed/simple;
	bh=HP3qbsW87D/czU/pikRnm3xM9eTORn7/FvZMtnOTP10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HCah+vq7OVYnoyD3zjGAV7TJ8zQPIv/Tfs6y8n6r3fBIdaucHym4YKuRdmfFPuICf26sxTtqPYB5+fCMLZfEdZRqyYFESa+dT9SOAVnXy1+ea2ZxBIV3l8uK9wndQLnwjPcUkg3+fMyVoyzYPcPgq9Fpo0gWIFHKDm59jE5Tp24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=QUEk8gh1; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0314B40E021C;
	Sat,  4 Jan 2025 10:28:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Zw_bx9hD-E3t; Sat,  4 Jan 2025 10:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735986519; bh=KYKdFtclxiG2u2EcksDGWyKLHqfEP3rK81fRVDwUvlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QUEk8gh1wURMrMEZLtJWbDalZ/hbwbI2ettYWhZf9GLdA0jwz92tK8WSYR1qVCzdq
	 iNoC4DqD6U0VGSXHYBT72fDJoJVLyEPU7LwCMoqGLHz6Ge0+okti9/aW/w/7x3tDNe
	 o+j0mtGY4KwkdpUewYUinJguH9snuAa4iZVy346ZVV/2lEiMmZd45786BHfE8n+77h
	 pge0gdfNTI9tFdZyoCtFovET5cerBWy+hD9Vvf7T7rTC8EzISeLsTXzohS1Z3EvOVS
	 ZecVJb5qK/FPjNNZ15KMZqVLwRpl+VDthyUCUyLlomimErwSQP5HPTNlvHznkURTAq
	 vl2iwiDQhz8ZiEdBK0ks6ro0m4O/tTz4UaNl0hByuFx/sDh2Ckvd3ncxeX5mAVeLPj
	 iv/SQLTh5WyLgSU3+M1o1SzOjPREx22LotxqYlQ0yENSHoQhZNCaxtYwDwNZ7MAiJ0
	 NaYpjJuOLhE7smdXP/7gCLw4npUzRkJ9n5LEugiBt2JTCQIhvyl5lIN1TN6itUx2bO
	 zWe98KF4AGcfGUoviHA4X7eBE7ttw/Nec1EZr8fZnG8YVTVnKAHTK3eBE0ffyeULix
	 FKLLHaDLOG0bAILNnj0OBOeLMUNxhwOZjxqRbGJa2YwPotlJWexgOMVMzw0AZabsrl
	 b5s6bm3P1Kq3FwEqcb3A6YgY=
Received: from zn.tnic (p200300eA971f93Ba329C23FfFea6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93ba:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EDDE940E015F;
	Sat,  4 Jan 2025 10:28:27 +0000 (UTC)
Date: Sat, 4 Jan 2025 11:28:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: thomas.lendacky@amd.com, linux-kernel@vger.kernel.org, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for
 discovering TSC frequency
Message-ID: <20250104102821.GAZ3kNRWbxFGY-q56N@fat_crate.local>
References: <20241230112904.GJZ3KEAAcU5m2hDuwD@fat_crate.local>
 <343bfd4c-97b2-45f5-8a6a-5dbe0a809af3@amd.com>
 <20250101161537.GCZ3VqKY9GNlVVH647@fat_crate.local>
 <a978259b-355b-4271-ad54-43bb013e5704@amd.com>
 <20250102091722.GCZ3ZZosVREObWSfX_@fat_crate.local>
 <cc8acb94-04e7-4ef3-a5a7-12e62a6c0b3d@amd.com>
 <20250102104519.GFZ3ZuPx8z57jowOWr@fat_crate.local>
 <061b675d-529b-4175-93bc-67e4fa670cd3@amd.com>
 <20250103120406.GBZ3fSNnQ5vnkvkHKo@fat_crate.local>
 <8c3cc8a5-1b85-48b3-9361-523f27fb312a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8c3cc8a5-1b85-48b3-9361-523f27fb312a@amd.com>

On Fri, Jan 03, 2025 at 07:29:10PM +0530, Nikunj A. Dadhania wrote:
> That was my understanding and implementation in v11, where Sean suggested that
> VMs running on CPUs supporting stable and always running TSC, should switch over
> to TSC properly[1] and [2], in a generic way.

Sure, you can do that. But that doesn't get rid of the fact that until the HV
is safely blocked from touching the TSC MSRs, you cannot trust it fully. IOW, only
Secure TSC can give you that, I don't know what provisions TDX has about that.

And then, even if you can get the HV out of the picture, the underlying hw is
not guaranteed either. That's why I keep returning to TSC watchdog disable
logic in check_system_tsc_reliable() - only then you can somewhat trust the
TSC hardware.

> That is not right, if non-secure guest is booted with TscInvariant bit set,
> guest will start using TSC as the clocksource, unfortunately sched clock
> keeps on using kvm-clock :(

Again: you can switch to the TSC as much as you want to but until the
hypervisor is out of the picture, you can't really trust it.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

