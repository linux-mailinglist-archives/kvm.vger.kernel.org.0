Return-Path: <kvm+bounces-70299-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YDPZFT0xhGl90gMAu9opvQ
	(envelope-from <kvm+bounces-70299-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 06:57:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 18ADBEED45
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 06:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7F604301BA4E
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 05:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E037932AAD8;
	Thu,  5 Feb 2026 05:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ohqlmu5Z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8C0329C6A;
	Thu,  5 Feb 2026 05:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770271022; cv=none; b=jtm4jmPkkpf4fACmf1gIVlVhZR7QKFgLhGybcAYGmYjzI6ItQdsEQ2azkQcG71wr8lh9+dP0nps8fIMB+z3YRASVjTOcKZ7K3868LqTYDtCwQVat3oqUh1YQ+XdoHT3bggubb0xU8WlNB0zqK+jHGoJ+l8+8XzBpg1Vyo8lbI2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770271022; c=relaxed/simple;
	bh=n5SIu0nXoa7VR6V4FPWdvX37h929ikBYRa/KDVa3i6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Za+RAS26Bo/+4WWQ7m7S5GL2WLrHyt2PaggWG7R0LBAPfqFb3bAfdcIGMkdHS3V8qKuRg6Rj6h+j4fzpOJ7Ok29dBn0uBtxux+iy2F+Dox/9eIEhlm+p1H047QiQE6geA/Sm2fVY7pGhTJMVWeS0bXWCeHU5HNgRNNrdzehItB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ohqlmu5Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D19C4CEF7;
	Thu,  5 Feb 2026 05:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770271021;
	bh=n5SIu0nXoa7VR6V4FPWdvX37h929ikBYRa/KDVa3i6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ohqlmu5Zb9gy96u/NgVA/QZC0cRT87lvKaa0OcnddFEoq9+1oTmbFP2pW+3iEUx8j
	 Uhtv9De2w0jSBb4hv3ICMfXP2aUFqRih+9m3+obydrSDanUVAnx0eeyElfkej2Osis
	 Foo82RLZyWr+pfb+pHltD5r8grD8Jk+9q72YIX+s=
Date: Thu, 5 Feb 2026 06:56:59 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, bp@alien8.de,
	thomas.lendacky@amd.com, tglx@kernel.org, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, xin@zytor.com,
	seanjc@google.com, pbonzini@redhat.com, x86@kernel.org,
	jon.grimm@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
Message-ID: <2026020515-immovably-pacifism-2176@gregkh>
References: <20260205051030.1225975-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205051030.1225975-1-nikunj@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70299-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 18ADBEED45
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 05:10:30AM +0000, Nikunj A Dadhania wrote:
> @@ -70,6 +67,17 @@ void cpu_init_fred_exceptions(void)
>  	/* Use int $0x80 for 32-bit system calls in FRED mode */
>  	setup_clear_cpu_cap(X86_FEATURE_SYSFAST32);
>  	setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
> +
> +	/*
> +	 * For secondary processors, FRED bit in CR4 gets enabled in cr4_init()
> +	 * and FRED MSRs are not configured till the end of this function. For
> +	 * SEV-ES and SNP guests, any console write before the FRED MSRs are
> +	 * setup will cause a #VC and cannot be handled. Move the pr_info to
> +	 * the end of this function.
> +	 *
> +	 * When FRED is enabled by default, remove this log message
> +	 */
> +	pr_info("Initialized FRED on CPU%d\n", smp_processor_id());

Did you forget to fix this up?

Also, when the kernel is working properly, it is quiet, so why is this
log message needed?

thanks,

greg k-h

