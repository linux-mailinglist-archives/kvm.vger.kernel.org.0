Return-Path: <kvm+bounces-57710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D0A5B593C3
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 12:32:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDAE03A42DE
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ADBB306B1C;
	Tue, 16 Sep 2025 10:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="MVeI0605"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3879A306D37;
	Tue, 16 Sep 2025 10:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758018478; cv=none; b=AgoDyABI9NV7/VDiP7Hvs71YJTMdDIb/WwRk8fiDwZM0fHa6Tzh+ZHQOcO6Vf352tHayVF8VZ0jy0uFi4YOAY1IEgnUkPAe2NyexTDdBij1mNU2gMa1ljE8iC6St5C+ON7U6giqQ6qAB2Omf+FM5vETU2kw8nmQctDK/x+sHYDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758018478; c=relaxed/simple;
	bh=x8864fL2rsCgbtb7BNsJIcvHgIQvCkrr/qraPxd1Ap8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2yK0aPsQojwbnTS2mJyHEyAxKK+jdObiz94NxnfYSYcMKXLkWyp4OGLdanqSZbCr2dniNJGTC/Dupoj6sq/JVKMKInOyQXl96aX6EzqFSVx6Sn/gTa4qL7wy2nS5FqaKaU0Nuz/CXihdz8SzoxltePCG0SEb5zk01+tLAghGjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=MVeI0605; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 93CAB40E00DD;
	Tue, 16 Sep 2025 10:27:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id p8DPS2BkjEHU; Tue, 16 Sep 2025 10:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1758018467; bh=MLHBzU/IL0t3K/IxXbjyO41jBmgmXdlDgQyTym/XGog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MVeI06058g7cLyvrIwBTAsJR9wFbryyo0W2kIbuhbcZVrSn6Rmgo1vTneH6Bc2skV
	 EjCLDhMDcIh1u7PYJUFo5DIH9qcDcrwto4Y0D+onOExPWgDwvYNfyLWpvMShwYDRID
	 krnbMnij+M3tDEjhVx7wAvt2gofakC0HQeOJmdiEiWk8wFuxbGFMTy78WVBqH0y6BI
	 RFEEaPHP6uxtEmGhMWDUoSNWOKcFUw6jWoDVX5Aor8TauK44husRAxHa75vrCans6e
	 YPrXF34SNEvXPENdoG/ZK7TJgBsSWysk2aqcxJBW7FzWsDBrus4xT/WFLOS6WltkXO
	 9hefSvy5d1BSD5pN68ez4SrRNeCBQYEb+IpBzDjD9l/af05iGNv+nOxqbFg7PAaV1i
	 +NS3wjysPjXT4p1yCDZ8FUo24h/ghTXRbHgmm2V+KpOrYrHPFP2pGSbnMik36GA2He
	 KeEs05inLyK5y5Klr5ab1unXh9SE6Rm88q3uSf/HGKhfcWW3UqAOZAmHoUfK0TZcRY
	 f4e/Bp0fOaMU7AjnUUyCCUFrUh55xZSc97A8EfqUOHFN3Bo47qO/xoxaVZBNRnA6Ss
	 AqDEAMSSWr9LPMC10ckdkxND++fHwfvnOUHm8m9jYewllH5NSiS1JIGli+68C7Zg1O
	 gEJngU0XnNn1RO1TiRzxXj5s=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 7430A40E0176;
	Tue, 16 Sep 2025 10:27:27 +0000 (UTC)
Date: Tue, 16 Sep 2025 12:27:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sean Christopherson <seanjc@google.com>,
	Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
	nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org,
	john.allen@amd.com, michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
Message-ID: <20250916102721.GBaMk7iWGfxX1nf3BR@fat_crate.local>
References: <cover.1757543774.git.ashish.kalra@amd.com>
 <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>
 <20250912155852.GBaMRDPEhr2hbAXavs@fat_crate.local>
 <aMRnxb68UTzId7zz@google.com>
 <20250913105528.GAaMVNoJ1_Qwq8cfos@fat_crate.local>
 <aMje1_nDBX-VWCXZ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aMje1_nDBX-VWCXZ@gondor.apana.org.au>

On Tue, Sep 16, 2025 at 11:51:51AM +0800, Herbert Xu wrote:
> You can take those two patches directly with my ack:
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Cool, thanks Herbert.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

