Return-Path: <kvm+bounces-25140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 828A896091D
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 13:42:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AD461F244BB
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 11:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DEE1A38C3;
	Tue, 27 Aug 2024 11:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="NlO+s9jv"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432C01A2C26;
	Tue, 27 Aug 2024 11:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724758871; cv=none; b=RQlmjKznH+KOpC/v/Rj62HB8H0qb8F1PbVJN1pINohzJn0ceUvmTNj2oKNXq0CGtocKrqUzU4aX9E8lO2ECHojGa+b/hYvSTbuLbgQf895iCtgEhFTlUQxpYPwpfBLKLqZ3xNZ1lv8SVQs/x0OVtl99Is8EPWeqAEX/yGeBOcZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724758871; c=relaxed/simple;
	bh=4qXVfER7X5jg1UYDsI8GY1Do2GP3/aEPXZ80KDKXsn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZ3fnjCk6G4/Igm93+qQnucJvgoKOgZqXC9vNVsnisSEOzxg45IcCAr2CKrtgD5u2/2jrplYZdgBWJ6c+2JIpV3U9eccKIC5IIssIgvF82pY2chWMtNR9+HCRbL5TKkQNa6t0EmXJcBlypEJc/gxDx7bAINkKmYiLJ5WQgzhn2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=NlO+s9jv; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7CACE40E01C5;
	Tue, 27 Aug 2024 11:32:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id MnoEU6ZdDyzp; Tue, 27 Aug 2024 11:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1724758365; bh=wabY74DxrFZTKqWmiI9YeG1gKoQ+Qr0O+p15+2rFGe0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NlO+s9jvtLba11mx9toZJOvALKWjRdXMhC/BlLUITXiLTzP6fkv1U5mkm2vhzYdjH
	 qWMReHJf/uhgYEdftX/kPFK6MUCiogdzzfiDnCUd50kUEnCKlEf+dxWXEwSCb/t9fT
	 BucU2XPyVNSxbxHKyO2SwxwE/Hzv1VWprqKI7PXv0DBRgRnEEsfDurKqqE3COgkLWw
	 mp9oYaUKXaOt7YMEdltn0L9lKGNQTVQ7M8R7046rD9Zlk2qLnavz4KU+OLiyC+/AUc
	 xTqUER0gf+RwUyzNQip06FljIY5RzV2YOrMZIKUXA0mC1yj/DKQoFLz/FwiYj4fPj7
	 q4yWkI+9OlyeSPQ5Vwykd4ZY12+GiyGYcU74JO2PVehoWxHCvtEQluA7/D3r7B7SVq
	 gLER6J6xZLJ+RwoRvpMr8WnrsLHhliHej/wxJT2lDqUH/R8s/SkgKmocjj78l7+VH7
	 sKTk/tsfo66+M2MCviCAxZ4Ln1aC6wxK/V73pXdShIfTwri7vxkQxqCRKNxWXoEgh6
	 iYTgtuJGxhl2J3/NwmV69Qs/MGkdqSFyNSOnhN3dvtRNv2dNEPcdmKrJ0Pvk693scL
	 pTjOvtpSHJ653JD6GHmBvWZbNtxNWXls5Q9GLkEtJIdG3tApVUDBwFVJR8DElCaFDN
	 EPuXtWLZfIutSsn2E4j0v66U=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 51A1540E01A2;
	Tue, 27 Aug 2024 11:32:34 +0000 (UTC)
Date: Tue, 27 Aug 2024 13:32:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v11 06/20] x86/sev: Handle failures from snp_init()
Message-ID: <20240827113227.GAZs25S8Ubep1CDYr8@fat_crate.local>
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-7-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240731150811.156771-7-nikunj@amd.com>

On Wed, Jul 31, 2024 at 08:37:57PM +0530, Nikunj A Dadhania wrote:
> Address the ignored failures from snp_init() in sme_enable(). Add error
> handling for scenarios where snp_init() fails to retrieve the SEV-SNP CC
> blob or encounters issues while parsing the CC blob.

Is this a real issue you've encountered or?

> This change ensures

Avoid having "This patch" or "This commit" or "This <whatever>" in the commit
message. It is tautologically useless.

Also, do

$ git grep 'This patch' Documentation/process

for more details.

> that SNP guests will error out early, preventing delayed error reporting or
> undefined behavior.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/mm/mem_encrypt_identity.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
> index ac33b2263a43..e83b363c5e68 100644
> --- a/arch/x86/mm/mem_encrypt_identity.c
> +++ b/arch/x86/mm/mem_encrypt_identity.c
> @@ -535,6 +535,13 @@ void __head sme_enable(struct boot_params *bp)
>  	if (snp && !(msr & MSR_AMD64_SEV_SNP_ENABLED))
>  		snp_abort();
>  
> +	/*
> +	 * The SEV-SNP CC blob should be present and parsing CC blob should
> +	 * succeed when SEV-SNP is enabled.
> +	 */
> +	if (!snp && (msr & MSR_AMD64_SEV_SNP_ENABLED))
> +		snp_abort();

Any chance you could combine the above and this test?

Perhaps look around at the code before adding your check - there might be some
opportunity for aggregation and improvement...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

