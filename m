Return-Path: <kvm+bounces-34758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D101EA05599
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 09:44:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD7383A5D87
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 08:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 595911EB9F8;
	Wed,  8 Jan 2025 08:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="XJlkRvVq"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986691A76BC;
	Wed,  8 Jan 2025 08:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736325856; cv=none; b=OzBwNJQwRMO4F+x85T+h2KNV9nWHA1O1GeqLsOqDdwNRfS6FtC/qO1IQkPbXDaqKNmQ5eNoAzeUldocZvoQykG72CWdVlLFAh8KvvKvqRaIJPbZLNcvW1QOsemeK8voC2f0RIZOl6t9mZ4ITk2nw4GkLNgLThfutxy2ivTQe3qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736325856; c=relaxed/simple;
	bh=hSX9bW701ffn/cgu2ANi9/YHUMsAo/1FIt5CT2hiH6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VtiRzQwOH3g493AhjEG7HnkYP+V+mr6D/nvC7qixB52z9Ckc2jCIbaa8pVeaTA4nRfS8cngU34WBd3VaR7jRkULq+6BeKAb011FD0RaIM7Rxicw45eTYk0y4ad46X2F5Q3o3Z7TdKrs12rjaGrqT6DOx8O4ohrDlrBlNWr8357c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=XJlkRvVq; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4C34E40E0267;
	Wed,  8 Jan 2025 08:44:12 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id f99tEHstFaqM; Wed,  8 Jan 2025 08:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736325849; bh=jrLWKltJLJZ/MbwwGv+7EcvXMyTn5kcHgJb6K5CyMcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XJlkRvVqG17u2NEGr4ARB0jmuMGrVRJNYclhi5x4T4/VHiopMxq8ckOBPNnnOy+N9
	 hDP/H1I0gtv677RH2DS4dXJoZ00X5nezv+Evf0ug1sXW6FVH6ZV0F1gj+PcF/lpRed
	 h9cx56FphZumGXuRsSJNOY9JuWH2Ub8wzGJIKBxeXaJCIROcul2reth8XEg4DiZP5p
	 ByI7jld6FSdtBjdo3d2+NdQYFRpT563QduqcX7nq+GCZbALte8e28rrDD0UPUJOMrD
	 QWYPB9/yRo3ZoB2mxm70aZ7g4nAeorRfQdIDSVzfag0rP3L+6IX2WwiXSpaNzdPGFJ
	 weW4fy5ZmtAnR8IimUJXmA4r72LlnSJhxgya/wq5vYHSHrFwYf3Aij392WEsIu3SGi
	 ZFwOHBFn2Dqc/ZNP59/DHGqSaPjQwbLwICI1F+tx4QNYwXg7ZO41plx1vFIO4ifavu
	 vFVi/CEyps5eVzZhmt8nK+ilLsepESVNikS50y9uVJLGeU5GRpa/gIT+1eh/eM8IXw
	 OsnUC3eckPKLbi6as5hc3Mz/mRskAVfFJUiadPDWain4aIiZCu39PBHZwtPjyMSDuo
	 V7wO4mahyjoLRdBvu50lHyyIueLjtH9g8mqBNHBEY5PYD2kv549WXUXinmt7YqeD3l
	 mRjHRO8a4X0YAEzAsmbdWkwU=
Received: from zn.tnic (p200300ea971f9314329c23fFFea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9314:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 14E9C40E01C5;
	Wed,  8 Jan 2025 08:43:57 +0000 (UTC)
Date: Wed, 8 Jan 2025 09:43:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, pgonda@google.com,
	seanjc@google.com, pbonzini@redhat.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v16 05/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20250108084351.GCZ346x1QvK-gqj4sm@fat_crate.local>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-6-nikunj@amd.com>
 <20250107104227.GEZ30FE1kUWP2ArRkD@fat_crate.local>
 <465c5636-d535-453b-b1ea-4610a0227715@amd.com>
 <20250107123711.GEZ30f9_OzOcJSF10o@fat_crate.local>
 <32359d64-357b-2104-59e8-4d3339a2197c@amd.com>
 <20250107191817.GFZ319-V7lsrjBU8Tj@fat_crate.local>
 <c7165d80-ab7f-425b-8323-3f759e1e41a6@amd.com>
 <20250108080515.GAZ34xuwMjbrSYFcHN@fat_crate.local>
 <f1c97e8a-1a35-42c9-9ff9-e056d48c80d6@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f1c97e8a-1a35-42c9-9ff9-e056d48c80d6@amd.com>

On Wed, Jan 08, 2025 at 02:07:07PM +0530, Nikunj A. Dadhania wrote:
> >>  void __init snp_secure_tsc_prepare(void)
> >>  {
> >> -	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> >> +	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP) ||
> >> +	    !cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> > 
> > So how is moving the CC_ATTR_GUEST_SEV_SNP check here make any sense?
> 
> In the comment that you gave here[1], I understood that this check has 
> to be pushed to snp_secure_tsc_prepare().

The check should be pushed there but you should not check
CC_ATTR_GUEST_SEV_SNP *and* CC_ATTR_GUEST_SNP_SECURE_TSC if all you wanna do
is check if you're running a STSC guest. That was the whole point.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

