Return-Path: <kvm+bounces-33410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF3A9EB08D
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 13:12:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0992161037
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 12:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B5F1A3AB8;
	Tue, 10 Dec 2024 12:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="MswdCLup"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F93C1A2543;
	Tue, 10 Dec 2024 12:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733832714; cv=none; b=OJN6IxSz8q8s2gctaZ6Q+RwDFpEsys9HlBj54NimVgz821zb+3NQTQcqHiLI85JvIngDbqOncJTntfZ4IxGMpUJRWBxTMK6/QxAfdJD+/abYqs9PCeJ1IiMk8f90xa23W/pjoSbisKIViZ3mrJ9voeRbfY3iJDlWiiBst3cZ9oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733832714; c=relaxed/simple;
	bh=g1NX+UaHYsK6+AS0s/2UNjJ7a94oKsYs9nC815dM1OM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2k6ag9WOb9ha9xEyhzoQ+iQe9obW0MN+XSak8Eg44ZghYLRWPTVpW2XrvZQX19GZIrgyC6aogI7dYTj97XH0mznQxwNjIAkcbRNm6Ok3wEM72xIhm+98WOySI3VqGs/hRkxy9dnYEQwWlcjaCgHeQrdBABN8l2OdVRL9NAztjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=MswdCLup; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4429E40E0288;
	Tue, 10 Dec 2024 12:11:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id llGAsyoEd3LA; Tue, 10 Dec 2024 12:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733832706; bh=i/3yRVyHYMrtGKIn725golo/qtHHQO1tJKcxTjhXisk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MswdCLupvdWATuCg9v7NVayAuqvfr7wZW9FvvVhw3Ydskr3ziwXEXsLJKWbghGLku
	 txQcelmcJ498z7sWwlkvlI0hJDA2ihS6x4ElodThpZEYw8Cwpb50PmqGm3JjzQTYF5
	 YA7GTWJUUl0127LoGB1Sh46+OWIjx3btfGxOD1a0muE7y0V6+UCGDfjXTpZx/j04KT
	 WV5JGTE13ccbqVHCWuBmwBAnxPcJIrgZXdDJxBVlZDvuWTf/T2YdHiIHx7rurur/+s
	 W+FDcI4J8L/BeQLufY/pDbdUjyxululDXYSw04yNFz/BM++g2zVu9AHMxB/NFLJRmW
	 6qbbR1NESTNiz0ykA/oYYnpYJuQ03MaFK8L9t2MWVkkdlcQZ0v2rq7MHx49i5MNX2g
	 CHrGRqFbWHxFdqywOCe0VLKkUpdvhj/eOF1wDtVqNM+5oRuo0jCMkhYPm//OVFpuJx
	 WvVOZLj8js6/s2C1gPrlhMZezhhtI3gENkk9cxsZk00uVvtUbOnWSO78Sj5hyuWyJX
	 nqPJlbbPVE6FxCJ+L0walVXg6O0G982/BlIEKVCDa5Gkgy0AI3Qc3TEj8BR/hJBRnN
	 C1Yg0AFNPjfmJ9iFthGSdl8h5lAExKIrPATY9XJ/YVkQPOgHVIdbINfysYM5JdGUxf
	 q2ya2/v8fOFp/rLqFVO5vgUw=
Received: from zn.tnic (p200300ea971f930C329c23FfFeA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:930c:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 23F2E40E028B;
	Tue, 10 Dec 2024 12:11:35 +0000 (UTC)
Date: Tue, 10 Dec 2024 13:11:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
Message-ID: <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-7-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241203090045.942078-7-nikunj@amd.com>

On Tue, Dec 03, 2024 at 02:30:38PM +0530, Nikunj A Dadhania wrote:
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index af28fb962309..59c5e716fdd1 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -1473,6 +1473,14 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>  	if (regs->cx == MSR_IA32_TSC && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
>  		return __vc_handle_msr_tsc(regs, write);
>  
> +	/*
> +	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
> +	 * enabled. Terminate the SNP guest when the interception is enabled.
> +	 */
> +	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
> +		return ES_VMM_ERROR;
> +
> +

If you merge this logic into the switch-case, the patch becomes even easier
and the code cleaner:

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 050170eb28e6..35d9a3bb4b06 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1446,6 +1446,13 @@ static enum es_result __vc_handle_msr_tsc(struct pt_regs *regs, bool write)
 	if (!(sev_status & MSR_AMD64_SNP_SECURE_TSC))
 		goto read_tsc;
 
+	/*
+	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 */
+	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ)
+		return ES_VMM_ERROR;
+
 	if (write) {
 		WARN_ONCE(1, "TSC MSR writes are verboten!\n");
 		return ES_UNSUPPORTED;
@@ -1472,6 +1479,7 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	case MSR_SVSM_CAA:
 		return __vc_handle_msr_caa(regs, write);
 	case MSR_IA32_TSC:
+	case MSR_AMD64_GUEST_TSC_FREQ:
 		return __vc_handle_msr_tsc(regs, write);
 	default:
 		break;

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

