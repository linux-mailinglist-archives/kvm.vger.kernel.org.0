Return-Path: <kvm+bounces-10138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4399B86A073
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:48:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA0EC283A3C
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C863B1482F3;
	Tue, 27 Feb 2024 19:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="JRmQXmkH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2289376;
	Tue, 27 Feb 2024 19:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709063285; cv=none; b=B6yo5ACl49GWfC94Rauz+TedT1Is7ppx4/sCKcQ3jPGwqxyXE0h/eEinS46qRWLSXCd+qMO47MuJKDE79V1MMmRzSi5QJH/kThR9JRFz2gY/xU6pBlazfQWgAs0K88f0HOtxQxPBhAXPqtG1sOWCyQ2xSfIcVl5Vi2KPv+gfYVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709063285; c=relaxed/simple;
	bh=cQSTUu5LkB56EjEev4yXhVQ+5usKXvWwwDpoqGek2iE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UoZ1NpG+uEjCW/fSv0E7DpK69nOsz5FD5dpgUi5R34/4sKVUbci5QHecaHzTrbHoI2EE2+JppY+y8e3L5jTvJt88zZjnMObO7ao5+D/MMscYf7ofX9Lv2RrE7K3rwUWmMHc0+uMa5VWdsqZlr5B3klk/CRxq2/r8jalvq/iQn6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=JRmQXmkH; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 72B4D40E016B;
	Tue, 27 Feb 2024 19:48:01 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TEX1hY_PYP_v; Tue, 27 Feb 2024 19:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1709063278; bh=iXEaBzgpa8zPzF57Rt7KVzOuTB1RAKm+nxEDYvsotJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JRmQXmkH0yeZlAWsRr+M9KuVO+ov/E1YblREoeaE7TA93DJ5DIqvwmZS6HXb7cYCP
	 LnkMV0YS7Ld08EmOL7FxlqAlAy9tHoA9YZpfREec4EQljVGFccaMQylfbDKe9P8HgL
	 DDsCE8LwjOb88oytyLNPDhrR4IaRbes1qe1jUNnpU1MArDUhvsKm7r4iM/OWvEKhiZ
	 DGYVGJynXZNBaC3ZAFVIc2AwZBsKWNOGoZZ67YpP724NxkRiqz4pDBfUZYoNiVjrZO
	 nWby0J2W4zkH7LZ2jKCAsxhsMpmJjB6rjMa14iJxwcZE6eA5d8bQi6wrd6UOnU7Hxj
	 KJzRz348hE3Xy3cBBkphdBh/ND9yri17XFgs9K+q/+PMoaFwMqq3MRjXTDQtXQ4elg
	 V29JxYyiDuSg47KZODu2QSLtwa7UTBvsxxCjVGV0UcKLWlPs9DzkknTKaI6aGzSXtE
	 ry49Gcmb3Ul/CojZfbmCLN/dmki+AiNiOjiQihocZKetKISDVajuIiYXVUV5KJgMZW
	 17/hAFCyybNrzxew1arvI5jmi3CK1FRKhM+uqQbdsln3q2EGFWfTpYyo5Y3vwB13cU
	 344rPAGnrF1los60656EE4YgDX2UsMV8vrDrLt8Uu86KX13n2H+HMuyKePlgJ+Ve0J
	 8ZAGMKgNGrJSdZc/8rvJDmF0=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 62A8A40E016C;
	Tue, 27 Feb 2024 19:47:48 +0000 (UTC)
Date: Tue, 27 Feb 2024 20:47:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, weijiang.yang@intel.com,
	rick.p.edgecombe@intel.com, seanjc@google.com,
	thomas.lendacky@amd.com, pbonzini@redhat.com, mlevitsk@redhat.com,
	linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 7/9] x86/sev-es: Include XSS value in GHCB CPUID
 request
Message-ID: <20240227194747.GFZd48Y6dzDY0dVObV@fat_crate.local>
References: <20240226213244.18441-1-john.allen@amd.com>
 <20240226213244.18441-8-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240226213244.18441-8-john.allen@amd.com>

On Mon, Feb 26, 2024 at 09:32:42PM +0000, John Allen wrote:
> When a guest issues a cpuid instruction for Fn0000000D_x0B
> (CetUserOffset), the hypervisor may intercept and access the guest XSS
> value. For SEV-ES, this is encrypted and needs to be included in the
> GHCB to be visible to the hypervisor.  The rdmsr instruction needs to be
> called directly as the code may be used in early boot in which case the
> rdmsr wrappers should be avoided as they are incompatible with the
> decompression boot phase.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
> v2:
>   - Use raw_rdmsr instead of calling rdmsr directly.
> ---
>  arch/x86/kernel/sev-shared.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 1d24ec679915..10ac130cc953 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -966,6 +966,13 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
>  		/* xgetbv will cause #GP - use reset value for xcr0 */
>  		ghcb_set_xcr0(ghcb, 1);
>  
> +	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd && regs->cx <= 1) {
> +		struct msr m;
> +
> +		raw_rdmsr(MSR_IA32_XSS, &m);
> +		ghcb_set_xss(ghcb, m.q);
> +	}
> +
>  	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
>  	if (ret != ES_OK)
>  		return ret;
> -- 

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

