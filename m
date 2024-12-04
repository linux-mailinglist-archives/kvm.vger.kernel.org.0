Return-Path: <kvm+bounces-33088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A168C9E4587
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 21:20:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C9F2284E6A
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 20:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15ED31F5403;
	Wed,  4 Dec 2024 20:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fw1uDtY+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E771F03C8;
	Wed,  4 Dec 2024 20:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733343635; cv=none; b=cYGRQ7994tB/rsTmAFPLyFhR5odxj/q7zrd+z3u/sUS6aclZ46Upao84LDJ7bWAj72Yq7xUwDfJmLgK+HDBMOx7ZW3mMurPBqNfF7jUx6EknqvBYxgS+aGHtlrrGOvLYgaevNvFkLj2pMlSPzxF8zqaDtWVTxPfq9ShaPWgblww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733343635; c=relaxed/simple;
	bh=yo6EtDWVHUd5FCAyyRe7L7iIDz6NFD5b/APFoPLQ8VM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZL7rMQ+PTofImoDsYjull2z2bNumYiOZ/JQF6BXG4z4z3d1qxa/rdZn57s9g2rH7xAphUrhgQaKyG568/I2Ay+TC4ZsWCO+WTB4MoLXrwZk22IC3aGH542/yPEXc85PPx2tg+6Gi2tEdBHdk12+pmQHNUC8mXuPewn6cv/dDGOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=fw1uDtY+; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A81A240E0277;
	Wed,  4 Dec 2024 20:20:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id x8U3PAyMSI_4; Wed,  4 Dec 2024 20:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733343628; bh=89gpJFTRhK4OzFFFmpfpddKSMWkPNoCxmv+qM7Ghr64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fw1uDtY+O92tbynXthPC4713JG+xzSn+sIdI2tMFduUOna7i0YXvJ1eZ4vCRzZbrM
	 +3OQIj7HNcnRkOGhkUU9N+IhAqX/Jbha9fKQSfmwoF46Bp7X4ajbtWp/xURNXk+5cC
	 KXhvjQ+X0dw7DCMsdiNOpFU/lGQGVsyu0CssxE4wrYXPIaSSYpN67ss+HqnNvARch4
	 UovI1syRC2m4xtgrk9pY0C5bZoOLgBVoKRxz91UgwiaMGZ+HFvsYU9kGzddOj5h7UZ
	 VdxmjMW11MWgpw2YwdZmiUwE39UvwmSEjQ5y4MHoPbGcFq1ApYdpqpzC8l3z5fCvc7
	 7Hq2mK1rfY+XQdkCRKTWf9Psz+QNOON1Ea8lVR4hjzsMiVuX+jVQFjrnPXMuESpBHY
	 x7bN6icKjJjCWKScH51sjUlZy7moymfQyxqsGV/9aE5yYdES9C68RuarWNaKWlO5u2
	 XMZi3v1YIkJVLlA2jORDCldLLhsK8F8WuURO/nExNPvYeqk0GuTA8aV6xIaYwZ32hY
	 nIpGTL/ZRp/yADYWLtFB0rJUptLIYgBpudPRdYwpLiJ3c1OVKxghydytPn5CYuIysw
	 bPg3bHYbZQrqVQup7K6S7oeN1/0mCKg0YZQ3ZYmpX61mnOJhtHxAVsicNLcgVvdsXQ
	 j3ZmDUgwfXZZs0jKVCYttY8E=
Received: from zn.tnic (p200300ea9736a14b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9736:a14b:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DD3EE40E0269;
	Wed,  4 Dec 2024 20:20:16 +0000 (UTC)
Date: Wed, 4 Dec 2024 21:20:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 02/13] x86/sev: Relocate SNP guest messaging routines
 to common code
Message-ID: <20241204202010.GBZ1C5ehNbXTyCdtpr@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-3-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241203090045.942078-3-nikunj@amd.com>

On Tue, Dec 03, 2024 at 02:30:34PM +0530, Nikunj A Dadhania wrote:
> +	rc = verify_and_dec_payload(mdesc, req);
> +	if (rc) {
> +		pr_alert("Detected unexpected decode failure from ASP. rc: %d\n", rc);
> +		snp_disable_vmpck(mdesc);
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(snp_send_guest_request);
> +

Applying: x86/sev: Relocate SNP guest messaging routines to common code
.git/rebase-apply/patch:376: new blank line at EOF.
+
warning: 1 line adds whitespace errors.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

