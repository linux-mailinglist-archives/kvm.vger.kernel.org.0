Return-Path: <kvm+bounces-71798-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sMJGKD6YnmnXWQQAu9opvQ
	(envelope-from <kvm+bounces-71798-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:35:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C70192679
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:35:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4CB9530216DC
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C792F9DB5;
	Wed, 25 Feb 2026 06:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7nIlhpF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447402FFF9D;
	Wed, 25 Feb 2026 06:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772001337; cv=none; b=DF0VHcJ36hj3nZCQ9p5vrDocESjqcjh3EsJDhwOipC4rctih5HuzZnYPXkK2U7qOFVG0D8b3GQkTeBGNadl+bf+wTxyNLrOgL8ZcubGnenptDufss7Ue1VP0gYinRwVcKKYjC6ukeCxW4j866uePqhIZkGYY3Q0ipEj+q5+M8Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772001337; c=relaxed/simple;
	bh=h6dr89KEhxof2arPqXBV/Rs0i1sa+TNZF8FEXFKzfuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=baqV20QNfGYu9LEoGBvzZG/ZbEMCSyyJKNoL58Hbn/qDAu8tWFm1eWnUNUPakw8wH72EhxqLoVmOynp0M3uxvlkxZjJhktSKPPaXGquERdzmCyB4uu5DrrjSif5rDomRcuml/Gad4iiZTtcD+ZUsETQBiuzNL8Y1eOtr9bmwzD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7nIlhpF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF86BC19422;
	Wed, 25 Feb 2026 06:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772001336;
	bh=h6dr89KEhxof2arPqXBV/Rs0i1sa+TNZF8FEXFKzfuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F7nIlhpFTbaW6blmoE7gYdmGL/pYWifZLyDDKj51JNkOAUlcO9vRI7YEJ/UXsuQPj
	 cbrNrECyTRChS5fnU642oGz1cNm3yTQiTqWXncxeCCqxwb9Vcw5S3CHJep/hWSdH59
	 J7LtBQ5lekXwCotktCvCNCXdV1Azy7PvYpHhbZ0kDhKQ2RURQLDIPrwjQe5ru7lZ6y
	 VHebQ2l2CERIfxjSZO289Cs2Ha9cesauepiDC145WM1+FSLt+/HQ45NkQpCEElQncX
	 BPjDpSug5LoFuvNWogGETpj+7W1htCVodXReLgD5NfCM8+D3SGzXY1x7QuhdRNSbdG
	 i/rzpNrXB+0mA==
Date: Wed, 25 Feb 2026 11:57:03 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Gal Pressman <gal@nvidia.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix UBSAN warning when reading avic
 parameter
Message-ID: <aZ6UJyaBr6XExhsv@blrnaveerao1>
References: <20260210064621.1902269-1-gal@nvidia.com>
 <20260210064621.1902269-2-gal@nvidia.com>
 <aZx_VsnmWLx96AeY@blrnaveerao1>
 <3c2969a9-c58a-4935-9d53-f3d6f3343b21@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c2969a9-c58a-4935-9d53-f3d6f3343b21@nvidia.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71798-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naveen@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D4C70192679
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 11:18:01AM +0200, Gal Pressman wrote:
> On 23/02/2026 18:38, Naveen N Rao wrote:
> > On Tue, Feb 10, 2026 at 08:46:20AM +0200, Gal Pressman wrote:
> >>  
> >> +static int avic_param_get(char *buffer, const struct kernel_param *kp)
> >> +{
> >> +	int val = *(int *)kp->arg;
> >> +
> >> +	if (val == AVIC_AUTO_MODE)
> >> +		return sysfs_emit(buffer, "auto\n");
> > 
> > My preference would be to return 'N' here, so that this continues to 
> > return a boolean value when read.
> 
> I guess the boolean conversion used to return 'Y' before this patch, why
> is 'N' better?

Because that would reflect the state of AVIC more accurately:
- in the case of kvm-amd module still being loaded, AVIC has not yet 
  been enabled, and
- in the case of a non-AMD system, AVIC is not enabled and is not 
  active.

Also, note that AVIC used to default to 'N' until recently.


- Naveen


