Return-Path: <kvm+bounces-31474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E979C3FB6
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 14:43:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56707282A11
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1338C19E82A;
	Mon, 11 Nov 2024 13:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="aUqOqgCL"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC0819DF60;
	Mon, 11 Nov 2024 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731332570; cv=none; b=hvOK2+hu6yGFjk0yqrHBjAyotIY+NNkye3P6F7NhAttHrbe/pRpXE0XAdEHbGtdif0hvx2M9PKxD7+FfNyKIW6fT2rSUo6wlT96WEq+phG5mzUOb3fj+cJgTXZl1O1DeNk7tsWzwQcJxj9jfRJNpqUN2QwrwvYvwtFevXPFxbck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731332570; c=relaxed/simple;
	bh=s1YYdvellt/W1b8uGgDKVMZcgsEvpaHGOy8/p221Yuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MxgPGxzTUbrxXYlzOBJcRxGcT5PudPMzBaEQBWeXi9PwjmUqEFJUv7L2bWngm6Mq+lO19Bd68VfCAwXJoB4g/XGzwpXT/nAzVYrZiUC516a7GdDIxy5yfUojyFdsxQEBWkL7AsAFSqbBKZvzY526pv5/EvTNQZcDUguxSPKSoTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=aUqOqgCL; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7682B40E0208;
	Mon, 11 Nov 2024 13:42:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id gAQIJRzUl6Zd; Mon, 11 Nov 2024 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731332555; bh=ilDhgodSaZIDKk0mf6JfvN29uv7dS54lsRmUMaerCKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aUqOqgCLsRUXTo5zeVCKDStRqdfFce9158qwa7UjepLTDl6ae3aV/FmIvhPd7UMH8
	 46igP4RK3H/afzCvxg4yichdSgLnnbi4QJlw8gVC8asUiVGhMyNsXWMWJT84GzTclH
	 It3WP7T88pcVL6bfgIcIDrl/SdKLAZjNiH3tH04o7RfSzolAG4eGCDG5rCciS3xTyY
	 gi8izzomkbZ+3TOeoU9vQKrpJrnAhZQGDcfFpEsSgHPaqfl+dsMFXNOxEd7NkVN9E5
	 fJzJWi4B4i+6gFmo027ndXGLJg3nlCQuzZR/gO9jTTZy/3DYlds2l9vUVgRUd/pOON
	 Zluqsi0g/T37Pf4gIIBxTzEkQW650x0Rhl6sDHRpxBafgvf2+fnKtyk4722grTsp4K
	 XiaN6xjJdfx5Vf5U2Yx84OGDzkwzeNcwKHVZPNGpk9apA3IyeeHW8DfPCcDkdolzIe
	 /UxuDcyp0hatWa1Gp9Jp7yb/T1KM/S5xA6L29gjErj4jLzoJRfzh7PGe4lBABwBiQR
	 tWIN3Xq1ozo3qEOVGlGzmlWS+4+iEUb4U0bYzugWAnvuFNcgMeCw7tt/F0R/OsweN+
	 ykUE1Ip0cZcObnCbqKooofJXP/f3VQPwJrlEGzvVDwApUH1D4qsL66OpNrgtNBx9bO
	 Os1qOzcaIOgJjnKJz3ikXYUE=
Received: from zn.tnic (p200300ea973a31e1329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:973a:31e1:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C7AE940E019C;
	Mon, 11 Nov 2024 13:42:23 +0000 (UTC)
Date: Mon, 11 Nov 2024 14:42:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20241111134215.GBZzIJtw-T0mWVKG5l@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <20241101160019.GKZyT7E6DrVhCijDAH@fat_crate.local>
 <6816f40e-f5aa-1855-ef7e-690e2b0fcd1b@amd.com>
 <4115f048-5032-8849-bb92-bdc79fc5a741@amd.com>
 <20241111105152.GBZzHhyL4EkqJ5z84X@fat_crate.local>
 <df1da11b-6413-8198-1bb0-587212942dbc@amd.com>
 <20241111113054.GAZzHq7m-HqMz9Vqiv@fat_crate.local>
 <0c13ab0e-ee34-5769-2039-32427ec4cf62@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0c13ab0e-ee34-5769-2039-32427ec4cf62@amd.com>

On Mon, Nov 11, 2024 at 05:14:43PM +0530, Nikunj A. Dadhania wrote:
> Memory allocated for the request, response and certs_data is not
> freed and we will clear the mdesc when sev-guest driver calls
> snp_msg_alloc().

Ah, right.

Yeah, this was a weird scheme anyway - a static pointer mdesc but then the
things it points to get dynamically allocated. So yeah, a full dynamic
allocation makes it a much more normal pattern.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

