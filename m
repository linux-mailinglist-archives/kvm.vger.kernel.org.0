Return-Path: <kvm+bounces-7711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D80C8459A4
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:08:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BDF01F22ACC
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 14:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CEFE5D48B;
	Thu,  1 Feb 2024 14:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Qv3Bg8AR"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE6A5D46C;
	Thu,  1 Feb 2024 14:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706796479; cv=none; b=Avb3HzIwomDFxm71eu3iI0EAb2++yDobQWLYMhMd0TjHkB8EsxjQnNeCEdmWDDFj4DhFjTTne/3ThbyQQKJiyzRn3uDKvDFGHwFXOkWp066at270CaQjcIy9vwy01FJVtrxJjI7Q448PS2TjhXQct8VVVAkQNnxiPVG19wkUHyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706796479; c=relaxed/simple;
	bh=RFK1cE+5ObwzpAjjnfwA9MPybq9eJ/nkSA+Mhwoa63o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hVuEpR6yDG/Gfd43vuP7TuzWH/AWBJDPC9/q5joIRt0/9wmgE3tF/tPobS23crs/beo/A0NCkg1Oq6+0CoqbWJUMWXJ7rwVAQEoZ05r2zoZUwTclwyrFTmzkr4XcrtY7ITP/vlH7m7lqFTu5OyDuyRVZRnSVq0cR+D1rIRaZB8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Qv3Bg8AR; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B56CA40E00C5;
	Thu,  1 Feb 2024 14:07:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id HQaWOEFqV8rJ; Thu,  1 Feb 2024 14:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706796465; bh=txwLVxJFuWD9kOFeeEz3gmIZDcwDNdXFNnPyVu02/tY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qv3Bg8ARM6aMcVBBEe1InvXiEHrLH9++f06I7zdRFXQizrfKg69STKJkibbqy+mhb
	 PONeKPBjlC+v1Bl9IieSLqrlXaxtu9L0PNV1Ptnq1QAdJCIZiy4hOyMwcUvUh5ID1Z
	 3T23b+oAAOCFU5CNxvTAW4d1Vbx7SXS/ibRY9sq50SI/+XHMsWpRQz3dCfh4isV6RF
	 t/1BE0WOLEo8MfpGt8Ty3PQrc18YwQx2EeSKPa8QUUmKiBSslzOIZRIJMfEHkv5/TA
	 gOsDBtmhDxeY1ODmwSPZlBkWD/27lRG5rpBo2TN5NNJe3hL//Xc+Xf4HPT3JtCU7rW
	 +l4TKoguSodNapZtBB2VDtzqftT6Q+HudkQ2yK5oSy1WJTV4D8yQFv8KyoSDvjeXvH
	 u9O85GjXskYYKNXPohor5LXvEmDIQbSnmVVTCFMiibaJXIZY1pvcDXO1Jmtwq1dxJN
	 zeyieBePalTHGpjD19WIe5viQ/UldbHT7ZLQeisO+MQt4QsKyEld1t6R97nf2yigGa
	 TFhGfaVKBFZMA0gGK0TNjsYICqQiL3gjo2dVuKaTToEAhmzxJt4L4CnSHVzf1khZrq
	 X+xDL9PeZzGMbcMAMoeadp6IZSq5A8a1hrNImNlCQmwBExrqfCG2ADSiTd298yiaq0
	 rzncRNPoggx7WM7aS/FNqNao=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 52CC140E01A9;
	Thu,  1 Feb 2024 14:07:33 +0000 (UTC)
Date: Thu, 1 Feb 2024 15:07:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, dionnaglaze@google.com,
	pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v7 03/16] virt: sev-guest: Add SNP guest request structure
Message-ID: <20240201140727.GDZbuln8aOnCn1Hooz@fat_crate.local>
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-4-nikunj@amd.com>
 <20240125115952.GXZbJNOGfxfuiC5WRT@fat_crate.local>
 <03719b26-9b59-4e88-9e7e-60c6f2617565@amd.com>
 <20240201102946.GCZbtymsufm3j2KI85@fat_crate.local>
 <98b23de9-48e4-4599-9e7f-0736055893fc@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <98b23de9-48e4-4599-9e7f-0736055893fc@amd.com>

On Thu, Feb 01, 2024 at 04:40:10PM +0530, Nikunj A. Dadhania wrote:
> I will move it to arch/x86/coco/sev, do we need a separate "include" directory ?

I still don't understand why you need to move it at all?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

