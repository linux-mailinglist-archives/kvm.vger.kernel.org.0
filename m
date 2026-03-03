Return-Path: <kvm+bounces-72619-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oCWcFjZpp2mghAAAu9opvQ
	(envelope-from <kvm+bounces-72619-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 00:05:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C6C641F8428
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 00:05:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6FE54304CCD0
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 23:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018FF3914E1;
	Tue,  3 Mar 2026 23:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tS3sBFlR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEB838836B;
	Tue,  3 Mar 2026 23:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772579110; cv=none; b=VGrn4NIEWcAGDoR0Ch5HGM4YtKfOSBl9Z1oJkQeVXDrIG9TklB7QpFga/V53OmQtrEv5N2oMA1bNU0a4Yfwe+nTrxRvMV7PZIH5B8x1j2GBN8ize2ra+IqawcJSgA0lRzQeHzxhgqdjtnmpXROm2movca7xUOvGevk1VXbX/CQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772579110; c=relaxed/simple;
	bh=KOP4qA7WnUierSJqpL9kDZ/rKKMSUzpadgiuEhnVpQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWH8jM/53ln7/lj4hOdT8nUD0gVO8Cc/ndKJ3qNmDVEj4EEr56myl6Gow0BwmfRXJ0HRJIGuiClyt+lD2WpXn/p4gCGXFOj1gs/M8Nm/EFBN+mBZUI2Jt1Cs3OI6QlVOh59vZErfx7JsP/Ne5nO6iF2yHOxTjGcp9v04srgttnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tS3sBFlR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF82C116C6;
	Tue,  3 Mar 2026 23:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772579109;
	bh=KOP4qA7WnUierSJqpL9kDZ/rKKMSUzpadgiuEhnVpQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tS3sBFlRLF7hjY8EdsHEkQUDPYSF8vAu2XK1Aq8K9owe6c8wkeNdA8rXlAu13jIUq
	 s7F0YqqhzmFWqknfL876D/F/jembeUEMPMzVSy2LFbJDC7kszIidwrfTIgZpKiL/oj
	 i2DpUvY5JgSUwgpC5GvaoDhBlbqTxSIFSWZQn5ynIpVtj84UPpFH/UYXWOdo3vtGm2
	 Y59KW96u8Ax2zrT8wQIYYLNrL5no5f909CHjbxGvCpBbC4lGa6BW0bLFw83d915guO
	 cUI8mBjCz7qpcOsnR1mtBD/nRGYo5Rbbx3PZ2G0FiLUP1K/a0EemJMPweDIJFYYsq5
	 CGmDMYL5zDtpA==
Date: Tue, 3 Mar 2026 16:05:06 -0700
From: Tycho Andersen <tycho@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Shuah Khan <shuah@kernel.org>
Cc: Kim Phillips <kim.phillips@amd.com>, Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 3/5] crypto/ccp: export firmware supported vm types
Message-ID: <aadpIgn0_UpPddAP@tycho.pizza>
References: <20260303191509.1565629-1-tycho@kernel.org>
 <20260303191509.1565629-4-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303191509.1565629-4-tycho@kernel.org>
X-Rspamd-Queue-Id: C6C641F8428
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-72619-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tycho@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[21];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 12:15:07PM -0700, Tycho Andersen wrote:
> +/*
> + * For CVE-2025-48514 defined in AMD-SB-3023
> + * https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3023.html
> + */
> +#define SNP_MIT_VEC_CVE_2025_48514		BIT(3)

It turns out that the public security bulletin is wrong, and this is
not the right way to check for this. I will respin the series with a
fix.

Tycho

