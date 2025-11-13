Return-Path: <kvm+bounces-63015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B32BCC57E6A
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 15:22:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C614D352F30
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 14:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F4C529C327;
	Thu, 13 Nov 2025 14:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="CMQdT9nS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4788C283FCF;
	Thu, 13 Nov 2025 14:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763043636; cv=none; b=UMtynqANIP6M0fpHYVQ/OGElEChqp0LANpTV2UMjoMwpumd5psBlDGnMhklGk3B1Vi0nJQZDYC3o37dFW3uDrr4qBAEZgCidZUmVUomuF85M3kNGAr7wOMclsu/7/yktNZTj9XhIWs1rn/C/iUM3v7rx/aX4e0r/2dLPkyHp1v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763043636; c=relaxed/simple;
	bh=Ez21oCeR/D7jOAfKfYGFyt8PVi8WJ2ggvy6jPsX1oMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O1McEc0tfY7+AiNxPHLTh+aIUxbLEHw/9tn8iOgKb5n0VnyziiIeh3hybPip5uqxumvtmDVUuN7hV852JnIZJdBiwodCIrfjbrS9dmhRsTYcmlPonMjhHSnTYCuKkkdLhw7iBIBXoNIKTiL9NG4XwIfSCseCsEP0y1O7MVt4JOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=CMQdT9nS; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 570E040E016E;
	Thu, 13 Nov 2025 14:20:23 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id fGZ6EuzSPpOF; Thu, 13 Nov 2025 14:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1763043617; bh=yBzDk8Y1rtJ2oZzF/4QRQXF4ByKuuVzrVG5wq9b+gAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CMQdT9nStbhDl+Fg4qKoojRC8T5/QoDz6Gfw49dSrU1chL+ZyoUgeFxTwI4a9alau
	 VhT7l/fPm5TvbTKmzr5hzmHvakmiKS7bHDuBVb+znxOUPQpgWDWMV4puVCz4+hCQM6
	 mEE8XT95I2HYZ9yldSZBKCl2K8vXIIzAyTlNDgJvcIptJWyRwPig54NfkhoE6oOhgs
	 +iJm/l8luYk8adDIMnnul3xgFOYVakMkw+JvhHG9OSeWS4QHd5DUKfJdxORv03wKUK
	 s0lBEBwY+NAXmLkRKpq4HGw4NNZOmFMwW0ODgHsEwefPz4g6Mh2wro6QGIHXPcOwlJ
	 YcYVWrpMmbphWqss6jLXlcJID53iea/SIAQdYGQQeza+vKRCJFSnaooFSK9Q49HGJO
	 7g2FKJjoRt18TC+zhwqt5NY4hJ/tZIolUl5Q5gmBSi4/9StAPEHIiiXX7puugx3hao
	 gTPISERwFQQCzwNRHEv5HesEv11W0SJdc1jkytFX06+y1jWaFddsgWzvJjmwVBtxUD
	 pTRnmPIj0DByt7gfaCMtx2HdRSSxggpXJLriBzmep9kRCWZbzSKzfVcF+L6yu0D27X
	 HT7czSgttzUwp1lbsuIMUD5UmflCw8Q01Xp9SwiHmyPIOJP5AbF/t5T31Gm6X1q247
	 MMuvvBhFclDB/mHIWbRe/wjk=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id C13B740E0219;
	Thu, 13 Nov 2025 14:20:07 +0000 (UTC)
Date: Thu, 13 Nov 2025 15:20:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
Message-ID: <20251113142000.GAaRXpEKHh1oQgN65e@fat_crate.local>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-5-seanjc@google.com>
 <20251112164144.GAaRS4yKgF0gQrLSnR@fat_crate.local>
 <aRTAlEaq-bI5AMFA@google.com>
 <20251112183836.GBaRTULLaMWA5hkfT9@fat_crate.local>
 <aRTubGCENf2oypeL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aRTubGCENf2oypeL@google.com>

On Wed, Nov 12, 2025 at 12:30:36PM -0800, Sean Christopherson wrote:
> They're set based on what memory is mapped into the KVM-controlled page tables,
> e.g. into the EPT/NPT tables, that will be used by the vCPU for that VM-Enter.
> root->has_mapped_host_mmio is per page table.  vcpu->kvm->arch.has_mapped_host_mmio
> exists because of nastiness related to shadow paging; for all intents and purposes,
> I would just mentally ignore that one.

And you say they're very dynamic because the page table will ofc very likely
change before each VM-Enter. Or rather, as long as the fact that the guest has
mapped host MMIO ranges changes. Oh well, I guess that's dynamic enough...

> Very lightly tested at this point, but I think this can all be simplified to
> 
> 	/*
> 	 * Note, ALTERNATIVE_2 works in reverse order.  If CLEAR_CPU_BUF_VM is
> 	 * enabled, do VERW unconditionally.  If CPU_BUF_VM_MMIO is enabled,
> 	 * check @flags to see if the vCPU has access to host MMIO, and do VERW
> 	 * if so.  Else, do nothing (no mitigations needed/enabled).
> 	 */
> 	ALTERNATIVE_2 "",									  \
> 		      __stringify(testl $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, WORD_SIZE(%_ASM_SP); \
> 				  jz .Lskip_clear_cpu_buffers;					  \
> 				  VERW;								  \
> 				  .Lskip_clear_cpu_buffers:),					  \

And juse because that label is local to this statement only, you can simply
call it "1" and reduce clutter even more.

> 		      X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO,					  \
> 		      __stringify(VERW), X86_FEATURE_CLEAR_CPU_BUF_VM
> 
> 	/* Check if vmlaunch or vmresume is needed */
> 	testl $VMX_RUN_VMRESUME, WORD_SIZE(%_ASM_SP)
> 	jz .Lvmlaunch

Yap, that's as nice as it gets. Looks much more straight-forward and
contained.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

