Return-Path: <kvm+bounces-43101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80F06A84BCA
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 20:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B08983BF581
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 18:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CEA928D85A;
	Thu, 10 Apr 2025 18:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="T/NEBtnU"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7074503B;
	Thu, 10 Apr 2025 18:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744308296; cv=none; b=CJQF2fi+dR/hjl6ERgaVH/1EUjAcPBICMnxQIsmRmny8v+fnw7BBnsoQqBIuMYlU4J3AVW5MZZ/zmGSXvktYKU3C4Nt2eAQLe+efIM2dXLkMyiFuq6fZWM4zJ6kggBWyNtZQ3EQyaUcGnAw3a98w+ldMUyuiExFUAH1qW89U31k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744308296; c=relaxed/simple;
	bh=z83e24EXZXzO/WD1/0r9O8FYFA5h0oiMF3g5G7kUKGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SvvrX53/9jFO2gPThXXfFpntvg3SoWFSKZJW/1MkPvRpCytb5fa9nDpGTvH2Y85cpNPpXVzh1nyjV6m95/PAcBJuRFEmgNF3gcDyORGSNBJkYt5Kx2x2JyCoUB+dlWfUGJgyRgbgePgRxxn01XMfxFl64X37ov9B1LfpE07qlS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=T/NEBtnU; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 79B2D40E023A;
	Thu, 10 Apr 2025 18:04:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JXdT9jIyi7CG; Thu, 10 Apr 2025 18:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1744308285; bh=dmpqOyaZhcwuVKfqnNJtxv2ffyIR8B91VbRYC30cTj4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T/NEBtnUfmBPg8cWBujCicfh+OeUP7lNkRdXpzJqr07K8m3DYqERP+ZIUsndCjfc7
	 Cs1O6WBN3CTR5cst19ipBQWn7ZJ41Zv+OYsR7DUNTDwmNLPmaLdY2Uot6vqLuGKb/Y
	 MFKkIcZYQf1c5N4rHX/+/SFMIxUv5AjtKqbRUMzZmdyZV5Wt7xULCg+4I2AO8ivsxq
	 8/Y4ZOpyWvHLnhozcGfQ9n/mSggVEBAZn2FQ3G6KFYwANZEjdXhKdkoVI7uHJ9owi0
	 cktYsUf0D6f/IrTOtCdECcwZz6sZ1axuturSgsB0SJeHklPtmPhDLroW9xs8Tamv3Y
	 rFDKFKCd8Ht8H+VU+K/MpM6rwtee7bnGpYhMm39NUQmVxOaa/6D2cMudXIOUT5TSYv
	 3d+thN3xgoIJ/qsZI1zxAsU2uEGRp7YtTQX79L+F9QIQ6syflFF3lZZAhhyHGwUn1T
	 Opw7jzbEWnqR4Jl09zMnVPNMROfDxsd/gIZB8CAm7Ub/UEs8lun7sDCSo//HJH/eGN
	 mmK8T0riingCxGw+ywwIZ1DXeid1pLhp4oRKAuGFcV8NR1M0ErbvJwaFKczfOzbuvo
	 h8BcvIjAI6GaQLN69mFef9WWJJBnn2A3/BEV9frPyFg6QZ0AP3+RSAEL147WVvJ6RO
	 eRYFPfR3nIunWkkRrHlAamo0=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5898940E0242;
	Thu, 10 Apr 2025 18:04:38 +0000 (UTC)
Date: Thu, 10 Apr 2025 20:04:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] x86/bugs/mmio: Rename mmio_stale_data_clear to
 cpu_buf_vm_clear
Message-ID: <20250410180433.GGZ_gIMYnnKcHw4J5D@fat_crate.local>
References: <20250410-mmio-rename-v1-1-fd4b2e7fc04e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250410-mmio-rename-v1-1-fd4b2e7fc04e@linux.intel.com>

On Thu, Apr 10, 2025 at 10:49:51AM -0700, Pawan Gupta wrote:
> The static key mmio_stale_data_clear controls the KVM-only mitigation for
> MMIO Stale Data vulnerability. Rename it to reflect its purpose.
> 
> No functional change.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>  arch/x86/include/asm/nospec-branch.h |  2 +-
>  arch/x86/kernel/cpu/bugs.c           | 16 ++++++++++------
>  arch/x86/kvm/vmx/vmx.c               |  2 +-
>  3 files changed, 12 insertions(+), 8 deletions(-)

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

