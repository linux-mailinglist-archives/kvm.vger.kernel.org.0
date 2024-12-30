Return-Path: <kvm+bounces-34414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D3C69FE957
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 18:05:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD648161344
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 17:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2ED41ACEDF;
	Mon, 30 Dec 2024 17:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cE2BrNWm"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C9533C9;
	Mon, 30 Dec 2024 17:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735578322; cv=none; b=PLaFAVVAgnIXtcMot1y0j6Lu95tYrlea7pZw85AglkfX/WnS+amoIUxxDiSzArrkTN09+b3Hu0Wc+yIf8qzMtFH3g3+k3j4X3Nb0Sq3gApv86dPAGc0liPgg7sHqHRFQBGZNtTerbrbiqg9izdfGqA4F+xH0LjTdav7PXjw7cC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735578322; c=relaxed/simple;
	bh=YFXlJ8TPHvpk7Wpcpd2POrH7any0wx+iPgUzOMNZgfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mrCrGxgVIDp8gjVr7Jb5e2QihvVt05oXMXmaSQm444T8Q09goyWyLHe6JHqqWTd8Ueik4U/tY+9CtGxrHPVj4QPqNG64hO8m+ZYCrFuoNS/SCSTJ8C43/JtlpiYxlApZGQSkZUE04HErzvpOFAyRR55UmzInB11DgiOfWGRR2FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cE2BrNWm; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A9D6240E0266;
	Mon, 30 Dec 2024 17:05:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id W6SVJr85_Uuh; Mon, 30 Dec 2024 17:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735578313; bh=xv6cXaOYuLb9VTHT6jtpP6pWUGRVRwxk3B4YsspGCCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cE2BrNWmJdqb5YT/V1EAnvosos0IsY/1TCujEtCebfcOkdQKPn2fgYA5nHZAPxnF5
	 dip7hI9xquQFxWrUlAsFTWTfRmpJjtuktk6We0VQzuT4ngowcXKwPD3EGoc6v2CSAB
	 ln8kvHPVSQ7xIwGTlQpK26deuI+LItE5TBSYJ3M8rD+fD5wb0kO2BKH1PM5nucLNwW
	 9q1Tajf88ICd/+wXsn2sYe5TLDNxeoq67WU2VQuQ42O5TfXG2wLDx5Edohp6KppIEl
	 QRwKOXaY0cphwYVroFVoG9gIFLSq4breKRIs2oHPRW3eG6M+ItMZQ5ky6NVBTaGYbp
	 CR9wOd87tTIKztEBlckpUL2n62LOwf3mgLErG+kyTL5/Mii6AhisnNQPLqyvcazpxp
	 HB/d3lATqeAIi9syDjQlsRanf+t0D2tDtH3Cai6TDKqC7mW9lUnejiJBD5YlkWaCFb
	 EhwEixMj3pZRzfp4Q1Qc/a1qQ3dkhnbt3/F1fcXoPDV9fuF5gyTchxRPD6XoUDGLOS
	 2l6zQ+fYzRsPwEm48m1c0UEhqABfICSJHkOWoFo5ByNUN3PED1a4m5MygH15DBETYY
	 lUwcA8DcXPRH1NP6kdn1skEqG1hpuXNX518h3t6D0XkdREyVmWf+PA5ka67X1NRKYb
	 j4jkppoxgCPFK8lPNtietI6E=
Received: from zn.tnic (pd953008e.dip0.t-ipconnect.de [217.83.0.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CBA6F40E02C0;
	Mon, 30 Dec 2024 17:05:01 +0000 (UTC)
Date: Mon, 30 Dec 2024 18:04:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 12/13] x86/kvmclock: Abort SecureTSC enabled guest
 when kvmclock is selected
Message-ID: <20241230170453.GLZ3LStTw_bXGeiLnR@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-13-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241203090045.942078-13-nikunj@amd.com>

On Tue, Dec 03, 2024 at 02:30:44PM +0530, Nikunj A Dadhania wrote:
> SecureTSC enabled guests should use TSC as the only clock source, terminate
> the guest with appropriate code when clock source switches to hypervisor
> controlled kvmclock.

This looks silly. Why not prevent kvm_register_clock() from succeeding simply
on a secure-TSC guest?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

