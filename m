Return-Path: <kvm+bounces-68560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B5BD3C13A
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 08:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1D9D2443464
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 07:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F023B8D73;
	Tue, 20 Jan 2026 07:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="IGABEqSc"
X-Original-To: kvm@vger.kernel.org
Received: from out198-4.us.a.mail.aliyun.com (out198-4.us.a.mail.aliyun.com [47.90.198.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A606A3B8BAA;
	Tue, 20 Jan 2026 07:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768895727; cv=none; b=OCQi/0z/CqBAABWy4NU4b8nVnVQLZucwZyOz6yfy8fM0qa7gN1v572NeObcEFhX9q2Wvd1eV0Aw5ww+qDvD6xf2SYfMiCi5isFRYH71RAZcJvSyMT2MYJAL72Mfvnxhj5ujrs3UbkneRvnOgKq6UWhIi5Djmj8Jvp0CdkKAbAgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768895727; c=relaxed/simple;
	bh=QZk29FQQO3YS6jEtFv67ohyBqxW15m2DvSYWc1T4lJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GsWO/XPM24rhWdCWFJvFHcwr8LhpzXhCaxwhEha34DVesAyIjg4C5eyLcMhuyypgVc7VXyyc0PSPCm7M9I0Vv8+AwkgA9u+bwh8otRkWhM0eVSXjlNGSq/ylcqzMtQXLRwRuSiGfBkRm2z5kCftLh8rFVUbUvGKzyKsIhjY+DH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=IGABEqSc; arc=none smtp.client-ip=47.90.198.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1768895707; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=QoGvGTXjK6AKDlLAnRuGsw6WtbNkZWYFCP32dBqHB7U=;
	b=IGABEqScJT6NDOwGKiqZUe8W/oz0y0V4ShAWDlkw5D+WyK4yTMri0gGEKtfJAiUqlNqIfcaVh1jEUE6GTfp3RMFlUvU33i7OyxjplLGbHC5A0DUMcSGaRe5P8zcNRfbwrVSM3836w7kQqJr11z9tYQGTZ0AY+LKpBYop11QxtGg=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.gAwfoa6_1768894767 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 20 Jan 2026 15:39:28 +0800
Date: Tue, 20 Jan 2026 15:39:27 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: linux-kernel@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH RESEND v2] x86/xen/pvh: Enable PAE mode for 32-bit guest
 only when CONFIG_X86_PAE is set
Message-ID: <20260120073927.GA119722@k08j02272.eu95sqa>
References: <d09ce9a134eb9cbc16928a5b316969f8ba606b81.1768017442.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d09ce9a134eb9cbc16928a5b316969f8ba606b81.1768017442.git.houwenlong.hwl@antgroup.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

+kvm, I'm not sure whether it is needed.

On Sat, Jan 10, 2026 at 12:00:08PM +0800, Hou Wenlong wrote:
> The PVH entry is available for 32-bit KVM guests, and 32-bit KVM guests
> do not depend on CONFIG_X86_PAE. However, mk_early_pgtbl_32() builds
> different pagetables depending on whether CONFIG_X86_PAE is set.
> Therefore, enabling PAE mode for 32-bit KVM guests without
> CONFIG_X86_PAE being set would result in a boot failure during CR3
> loading.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> Reviewed-by: Juergen Gross <jgross@suse.com>
> ---
> I resend this because I encountered the 32-bit KVM guest PVH booting failure again. I
> hope this can be fixed.
> original v2:
> https://lore.kernel.org/all/0469c27833be58aa66471920aa77922489d86c63.1713873613.git.houwenlong.hwl@antgroup.com
> ---
>  arch/x86/platform/pvh/head.S | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/platform/pvh/head.S b/arch/x86/platform/pvh/head.S
> index 344030c1a81d..53ee2d53fcf8 100644
> --- a/arch/x86/platform/pvh/head.S
> +++ b/arch/x86/platform/pvh/head.S
> @@ -91,10 +91,12 @@ SYM_CODE_START(pvh_start_xen)
>  
>  	leal rva(early_stack_end)(%ebp), %esp
>  
> +#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
>  	/* Enable PAE mode. */
>  	mov %cr4, %eax
>  	orl $X86_CR4_PAE, %eax
>  	mov %eax, %cr4
> +#endif
>  
>  #ifdef CONFIG_X86_64
>  	/* Enable Long mode. */
> 
> base-commit: b7dccac786071bba98b0d834c517fd44a22c50f9
> prerequisite-patch-id: 590fa7e96c6bb8e0b9d15017cfa5ce1eb314957a
> -- 
> 2.31.1
> 
> 

