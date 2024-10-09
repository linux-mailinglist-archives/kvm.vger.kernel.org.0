Return-Path: <kvm+bounces-28224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B94D99677C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 12:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C67BB27B71
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B82190045;
	Wed,  9 Oct 2024 10:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="gUmMrRtD"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3763518E779;
	Wed,  9 Oct 2024 10:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728470333; cv=none; b=MVCwNagy3kbUYkVYIyon775+sP8RzXJ2pixHbWA5F3w4ZbUjiHySu5EKhn0Qj4amy4TjHuF9fXZRbHjMFY784MfXIE6ednNMPzgYODeyq1GYyM1wRsg1iJyNJb7cOaU1qlLj4uShKnjHkdaJiK6iwwZOTxdp4fLJfB9PRR69fxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728470333; c=relaxed/simple;
	bh=wxMFvAdDX0uHWtMZrgpWuEE2pLlU4FTWe4P2KTWWAV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZBQEmq1Q7gQ41HcjCZMuHOTNjlX+p1jM4OqbbJiRYkI+6ikKOO4kkJqqgvfloaO6y1dKuy65cyuBVZ24yCIxBk3RZ+2CnDzh/ZepLJRszgRRujYHD72aaWgkfbCGQ2hS03KrOwZU8EopzW5W6JFqh3slS92dZgbHdbn6+9zPYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=gUmMrRtD; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 02A8740E0163;
	Wed,  9 Oct 2024 10:38:49 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ygVfspruDksy; Wed,  9 Oct 2024 10:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1728470325; bh=1AOv5qV0vwnw07PJQNH+GRr3t33WnsXNEi9bcra/9wE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gUmMrRtDWbXvFRsxWpLUVrbormKMscY2hBDLWN1wqygXt6jmOzIujaf1V4FjkiQhF
	 vhk9tl/3BmIb81dcPEVtJ3NvzoqQrOAxEMquEMMg6m3ROheoKvOa9ryEWeP7Ptdi7p
	 95Jz1/4SilH1zGydAfJt6JaJdvORKvu1FRaF69Pantw9kYGxreR62UTu7yCfj489Sq
	 fqjicyUEOUFSh/wjnlty3vfs16xjruRBencflYYgKGaWb2GSIZ+k0EeMkMtcAiehgw
	 6hc9CfYhSJr/Reld7jd5uJzZf8TYwCQTs88FzZSGjPHeCZYxtpucLOGAe7Uw7s81+3
	 Wb2f/r4ReD3kNWXESXO3XfPcISMbPw+yPSK/Oj54LBH1CNPT2Njn9GMen9FBYAVeSY
	 LARjvPD/CQwWTg2p1CP0NsEsBWnnlJaKUpsFtQ2hH93VFg6YWTxP4lG7h2jTBGKrww
	 HuMhcPcZHLjpZIFt9l2tT6l8qvOlm0nfSB3ORGmwQHyO6lQeQMBnXdORoxPEugkdFn
	 AJFAcK93jHs9mwhI2kLVwiBh1DhSbCG1DC60c1DNPn63cWVDStApis/1QinCb9gf+o
	 JcIOsM8HhRNWZnQ5tvY1O5juPCE4RELQ+oRq4CS5BqLYSzoA9Em3cpQ999KpzykdLl
	 jAITZMdMs6x1AcIzmVoRh2X0=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E045A40E0263;
	Wed,  9 Oct 2024 10:38:27 +0000 (UTC)
Date: Wed, 9 Oct 2024 12:38:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <20241009103821.GEZwZdHeZlUjBjKQZ5@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <20241008191556.GNZwWE7EsxceGh4HM4@fat_crate.local>
 <8d0f9d2c-0ae4-442c-9ee4-288fd014599f@amd.com>
 <20241009052336.GAZwYTWDLWfSPtZe5b@fat_crate.local>
 <a1b2eba5-243c-4c7c-9ebd-3fce6cd4c973@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a1b2eba5-243c-4c7c-9ebd-3fce6cd4c973@amd.com>

On Wed, Oct 09, 2024 at 11:31:07AM +0530, Neeraj Upadhyay wrote:
> Before this patch, if hypervisor enables Secure AVIC  (reported in sev_status), guest would
> terminate in snp_check_features().

We want the guest to terminate at this patch too.

The only case where the guest should not terminate is when the *full* sAVIC
support is in. I.e., at patch 14.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

