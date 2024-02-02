Return-Path: <kvm+bounces-7863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CFA6847473
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 17:15:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2CC71C25F5A
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 16:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B330D1474D4;
	Fri,  2 Feb 2024 16:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="IdoCnj6F"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B764322085;
	Fri,  2 Feb 2024 16:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706890526; cv=none; b=knO/PdmtuKK4TTCqMIsvGYYPLzhBQ54eeTzPHFvXvwvek+VJ6XNyEZdVGUYj33nrugVRRYdliMMZYv4kaikcNxQao7bxNQADKJ6RNzm6//zIMGc0Dl8kxV0SPM2EqUqhVjjGZ+zjVJyOZu+Q8zSQkpXn9DKXi87haX0DExbApLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706890526; c=relaxed/simple;
	bh=1oJizMCHG1hlosutpk4RpqLBX0WXRZQW0RTvwcRGebw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=se+YUTJ/Y+qy/Hpl8/QqycCg1zWjkxg5tx2Ub9py2CRX9hC8B2+MhNAJS/T+mnz9571C0AvAHaFevY0OLCBoZK2sVEMjMtEZMvmkRkeQa+l2SrQ3RAcr7+kf/aItIbr52IDuAyQZwfb6cgLcufxdSnuWRT/NmxBJg37yDvkSwMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=IdoCnj6F; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5045440E01A9;
	Fri,  2 Feb 2024 16:15:15 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4X56FUvCTb6l; Fri,  2 Feb 2024 16:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706890512; bh=FqNdTzwizpTxcThi22pmlOatH0Ownz2aial+W3Sb/Ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IdoCnj6F9k+/LwGWIsZ3DTPyhBqANUizcPQ3M3LzX/M84nEhPMLjFcCfDsl6Al+k+
	 DDLS2foLI8Ga7QbSOUjddBn0TNsfCHdJ5hxCrBYWhEF4kCckFdkG/f5iS9jDgv6AC5
	 Wxwivo5npZ75Fh/0N3AjasxpQ7+HH+Vb9bS35OfsFK5Fuln6QEcrIPeV7rLnDlNoa8
	 4B6dLkKuB3GiIcx/tga4dqtYvz6fyVWYRJKpz7AY0LbqTgxrHupRdbiFYZpdtTlPcy
	 fnVpnnRsNW63Ob++n3AhH80K2CUpZrZ5ioBtb5uIMeGBmKNt41Kgly6ZEN/YCjBWN5
	 9QS1Mew7fNJW2aAmCxumM8kmLu/uOdSgLGY4TVpJ4DTT/456O9fcgUyrBtvlyWJyhR
	 Qof9k4AAlgWm3lRiFSDtdJA59jHqqNAH45t+ltmkESdZF0J3ZcCRB2v4fxzSkGI5cX
	 ux2ganjQTsrYXNbbwy7qZ8jH9p7OGXeObQ2WGLcOUrC0Qgfv4+T3pqhImPED2ZByhe
	 5974L2QMtlLz8T4LCyfhK8hjBO3244oXIXqQWpu9WFDqZwuSo77ojcVS0/lm/U+DxE
	 O/j4AoGfgRNeeo28D9lCvBycTByKLYHSN+5SebYaQ48LAx2yXAGn68VGxN6xbEkMpR
	 eaC2fog6UfDdSI55JI09roHg=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A369840E00C5;
	Fri,  2 Feb 2024 16:15:00 +0000 (UTC)
Date: Fri, 2 Feb 2024 17:14:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, dionnaglaze@google.com,
	pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v7 03/16] virt: sev-guest: Add SNP guest request structure
Message-ID: <20240202161455.GCZb0U_9jckCT8loBc@fat_crate.local>
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-4-nikunj@amd.com>
 <20240125115952.GXZbJNOGfxfuiC5WRT@fat_crate.local>
 <03719b26-9b59-4e88-9e7e-60c6f2617565@amd.com>
 <20240201102946.GCZbtymsufm3j2KI85@fat_crate.local>
 <98b23de9-48e4-4599-9e7f-0736055893fc@amd.com>
 <20240201140727.GDZbuln8aOnCn1Hooz@fat_crate.local>
 <408e40b4-4428-4bef-bb96-8009194a9633@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <408e40b4-4428-4bef-bb96-8009194a9633@amd.com>

On Fri, Feb 02, 2024 at 09:20:22AM +0530, Nikunj A. Dadhania wrote:
> I have opportunistically moved the header in this patch as I was
> adding guest request structure. Movement of rest of the functions
> implementation from sev-guest.c => kernel/sev.c is done in patch 7/16.

And kernel/sev.c has a corresponding header arch/x86/include/asm/sev.h
which is kinda *begging* to collect all the stuff that sev.c is
using instead of introducing a sev-guest.h thing which doesn't make
a lot of sense, TU-wise.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

