Return-Path: <kvm+bounces-15665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF0418AE82A
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 15:29:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8CF5B2426B
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 13:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C065136657;
	Tue, 23 Apr 2024 13:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="HXoWijJF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0440D134723;
	Tue, 23 Apr 2024 13:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713878984; cv=none; b=Qz8RJfks40sxQX10kn/oR07XdnxM+HmQa1BKWj3eBX77s1eMPrPNeY/zUmJQG85OqxRUOZF7kpe5rka/feVFRzxekgfjNVq0O/ClKOIB8pp+1OaQnVh8VpDIV86QyCITZg9SNLCGeB5puiPgYJXqar70wHI0zEmxCGwW0VTY6ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713878984; c=relaxed/simple;
	bh=BnllCTvxOAgMpV/lB4qtbEw0YxUjrEPwe1VzP948acw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FdSKHwJDTQamDSiSPdQ2ZlJExlPyEKxCdnas736QdK6GSEJwGIi7GykE5PAIAtUCRubeOAl+ieuRSWywgJSf8zLAxkEN0nTdeJ97CvqK7ai1Nw/oJhisIQlIR41ClxqN4wdvFJDiAO6Q0fpO6OvmoVwTKeifSW6YwL094nUAB0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=HXoWijJF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A87C440E0192;
	Tue, 23 Apr 2024 13:29:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3JrvJ3CQ8XDt; Tue, 23 Apr 2024 13:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1713878976; bh=ILwRpzuGvY3GuwVIIRdbcMocOO6GKd0BXjkGFp7cJfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HXoWijJFnjXN5ShNpAzQqIDnrzPBJyC1IMN328kNJfqDMZzYAU9pRKbn8DSorfowb
	 oSvINUFp5D8BXBvaSky2bB4bcM4LRWlDWohQkmaQP3ySeuOPoMF8QD5rCbnYvHVEmb
	 9M1EdhxWxCpshTGN6x4ZSgh/R/rWFtspNDeXU5JHm0syMvgE39Oavtt5NeKRF8WWtb
	 /cJfP/kGrmkN5nIXS80mmQrOFbA4HPk2cfs2wFVLeKfvlsqN/Mwhit+TYc9q9K7v1U
	 PGnJTO0CVw9rZQQjOwRLvIfwA2Ukcj6B+aUk/PFNWjq28cKSfn0cNYKBWTb6CkCCRZ
	 fOrGSdxm7B+QfslvgYF9K1ISYNNHhYlZa0ROu34aS3aqS+YA4YKUIzkp2oq1thXyAO
	 M9ZGODfTEZgVh+llmp8QcmsxpdV8V7d05ZTT+h0Hr5zNfIu0CAa9ECNDy+qhjo/Fm9
	 iq2ZI1Cu96BBAXeo4V86yOSfuCW4LUNHEPw1utduTh6+piBu+7hNl+xcB4TPbb3cYD
	 trjFJpEYZejPIq8lnxjE58CkOEj91QQUTcOum1thtYUpSqbOE2r90wk+qnfARBIDGS
	 UK6yL4K7vTkT8nyC0yOy+1C1w0Jk4Tj+hYNmuNJ20tUXyVkaNDSV0UkoU/S4pLyBSZ
	 QLB9aXK2MS4BqkzyuLOibuiY=
Received: from zn.tnic (pd953020b.dip0.t-ipconnect.de [217.83.2.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BA55B40E00B2;
	Tue, 23 Apr 2024 13:29:25 +0000 (UTC)
Date: Tue, 23 Apr 2024 15:29:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 09/16] x86/cpufeatures: Add synthetic Secure TSC bit
Message-ID: <20240423132924.GKZie3tGh7a6XbxJJX@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-10-nikunj@amd.com>
 <20240422132521.GCZiZlQfpu1nQliyYs@fat_crate.local>
 <4109abcf-1826-4332-8abd-070a80ff044c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4109abcf-1826-4332-8abd-070a80ff044c@amd.com>

On Tue, Apr 23, 2024 at 10:10:14AM +0530, Nikunj A. Dadhania wrote:
> 1. https://lore.kernel.org/lkml/20231106130041.gqoqszdxrmdomsxl@box.shutemov.name/

I have no clue what "We have better instrumentation around features."
means and am not convinced.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

