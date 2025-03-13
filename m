Return-Path: <kvm+bounces-40947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE84A5FA23
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:39:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFC351889C5F
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 15:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BCBF26869C;
	Thu, 13 Mar 2025 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="CAtPMP+N"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA9835966
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 15:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741880331; cv=none; b=dpZV6504kNCulK26Ka8RdcKhWdWh5kjyjnvQMkxWlZvN7s9yyvbMNjoGk1pkifUG6xV5QKmF48v4Ip+BrUGspPE0TAGbOypr0MKazajjYDB0BsqJn6tt7M/Ap7Wdej2pLt0JivFRGYRW1mj/9c0Wp6TboJU6fb9wqs/KVNiJgcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741880331; c=relaxed/simple;
	bh=GysdnbCK4s2pMB+USzpXYLT/KXbSq4/APftQNpF11ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yf9IfLCmqZ2wcvPZpzC2c3B57nka9QbksvTDJqxVehAlYshadY0vV9C2xNs1FRoQTneL/XAEwVwVpFD0U5aMybyV6FClQSWo0syNKnhcecmQTaUMRCGQRsb1/HMqhRlpA0JsZE+Tcou0mjWpjoGmfZtC9z0fXNqgyFo0W7tTbjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=CAtPMP+N; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 915F940E0219;
	Thu, 13 Mar 2025 15:38:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id USX3RhScKhse; Thu, 13 Mar 2025 15:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1741880319; bh=G9I6iPpUsdtO6XtOfZxS/0uOeMdWvTOiHDb22KYFY74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CAtPMP+NC7s21FOoicKlIM6Fr+uRwKngFeHaUnY2gF2weok1hM3O4nOi5Yzl/+pss
	 2nH1fDJXJzYRcIdg7S3yJ5Oip4hPJO/M7DGr9aDaU0tJMXOD9oHMdYg7PYOSdN0Ncl
	 aQJ+CquOD1UfJEoVY9vh2Bsd6enh3lmNWzHMhRNbvEQeNM0zQpno+Q3my5YNsvzbJl
	 Z1Jnji+c38fQI1N5AVq7cQq5GGlJv6JBVLb5u8uGGwWzTQB/tfpnXtA+jcH5OorbLp
	 Ul76GmD4BJB8AIqXEKQGzH3VY7pUS94g/PiTBv+dl50GipdHNULVAAcgx9jcFxceTD
	 c3ctOiTTN09ZhFIMbFFHwAAdLgxPh5lYRPfvw1AfdaelGL6vnncFFjeg24kwS8jkp/
	 DFc0mKDjThDt6RbqiiVer5BfNIXCin4qAWs1dVbeOviCDoIp+gkEvXZkAt6oI5xYUc
	 79Pz57LJ4qGKVUYqNsEgtoN+U6mPdr4vBtzNuHAQjoQ7/3kaA30OteOMLjWj5v+nKV
	 fYLkGaom/+Gh7XBELaf/t4FsKDFhWqZUBjRGrU+HM9gN65af3epoQ62SBL7YzqH3VK
	 rILOOCTWOvmMrO2EsLnN0mXM57/Cx/L3EzRKq5Zzjy9Y/lxLIS7LXsqsvG46Sfwe9c
	 0y+2/68fHNmxSFfU8KuvTGwU=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9896740E01AC;
	Thu, 13 Mar 2025 15:38:31 +0000 (UTC)
Date: Thu, 13 Mar 2025 16:38:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vaishali Thakkar <vaishali.thakkar@suse.com>
Cc: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com,
	santosh.shukla@amd.com, isaku.yamahata@intel.com
Subject: Re: [PATCH v4 1/5] x86/cpufeatures: Add SNP Secure TSC
Message-ID: <20250313153823.GCZ9L774MuRQ3ZhArk@fat_crate.local>
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064347.13986-1-nikunj@amd.com>
 <63bc72ee-4959-4f08-8db4-2bf6634dc1a6@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <63bc72ee-4959-4f08-8db4-2bf6634dc1a6@suse.com>

On Thu, Mar 13, 2025 at 04:15:14PM +0100, Vaishali Thakkar wrote:
> I think it'll be nice to add this as a flag for /proc/cpuinfo.

Documentation/arch/x86/cpuinfo.rst

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

