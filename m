Return-Path: <kvm+bounces-71502-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4GwXMvqFnGm7IwQAu9opvQ
	(envelope-from <kvm+bounces-71502-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:53:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D7A417A2D1
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:53:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C50523029A6A
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2610B31A7F6;
	Mon, 23 Feb 2026 16:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QxwElzQB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2301C30ACE6;
	Mon, 23 Feb 2026 16:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864848; cv=none; b=DkQwt8ge6G8iXSrJG+S4Ak/WKY4YRqaLSX7ZlzGSuW46Z3/P++b3wmd+NNJxB/ST6wps7OlG7zfPfB0PBniFsLSnMwpou/CGuatX7CZB7+Lg82L3/Te3mc/Y+kAutf6gxhuWedyZSe9fZHF008WEGSg6dpjVdyGM8ePXQwibeLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864848; c=relaxed/simple;
	bh=DHzusBLHS1PKE5rCYY+8SAh4a8JwXvDMvJdyfDxw7xE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HNPMyDPWMrdakSF1pcIloFJS43gZURBjuSfg2Ao4PWOLLqeu4MpOfV2JqpNw7SdqxCQmJTouS6DF9ktvjI13UL1zzwXukQVCEoPpCEchh4bSfEs0qadO+Da3rEqmv9RpbF8kYTgWAWf6k5pAXPzZntbAaTk2AebMdo1D7lqKvMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QxwElzQB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCC7C116D0;
	Mon, 23 Feb 2026 16:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771864847;
	bh=DHzusBLHS1PKE5rCYY+8SAh4a8JwXvDMvJdyfDxw7xE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QxwElzQBqMD9lQ4CrGHf9wUEEaA8D0KGxvTimJPuTn2YwFcPZL/sIyQupvw5y17ZZ
	 pdwfA+IGdr3CbN0Jdz3Z+FiZxxxK0oRPYP/ONH0J6RXdsSyIM5qfvfFxNXFYHvNUWx
	 fCyBa51y70VozM46WXjL2fZXUniLAUpwFt15nqnqP9xC5QWNvYpI+3kAor8ffARXXY
	 VtD1pWS+j4CdE4Krcbg9OtetjPciJUEaVdRS54+ULrdzid4usIL851Ur31TcL/kZOM
	 OwtDkxXOWmy3pQCWLiStlWXL4ZYc7Gr4CjebaJxWac6BmvLWaudWPG2J5klXaTztMK
	 dcvXcyeRMdZ4A==
Date: Mon, 23 Feb 2026 22:08:03 +0530
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
Message-ID: <aZx_VsnmWLx96AeY@blrnaveerao1>
References: <20260210064621.1902269-1-gal@nvidia.com>
 <20260210064621.1902269-2-gal@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210064621.1902269-2-gal@nvidia.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71502-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naveen@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9D7A417A2D1
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 08:46:20AM +0200, Gal Pressman wrote:
>  
> +static int avic_param_get(char *buffer, const struct kernel_param *kp)
> +{
> +	int val = *(int *)kp->arg;
> +
> +	if (val == AVIC_AUTO_MODE)
> +		return sysfs_emit(buffer, "auto\n");

My preference would be to return 'N' here, so that this continues to 
return a boolean value when read.


- Naveen


