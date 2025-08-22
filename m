Return-Path: <kvm+bounces-55501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34AA2B31A65
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 15:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BDE7B0124A
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 13:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7783043BC;
	Fri, 22 Aug 2025 13:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DfOfzRux"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FC12737E8;
	Fri, 22 Aug 2025 13:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755870901; cv=none; b=GTvrlBfSQCqI5igoNn893Ht/cgHoE9r4CTJhdwNQDrjtpFxhpVscma8hDPnlvGXYx55Ax+gDxk4jln/4tYorfwoDPo5ePBjmYVlvzvSRpW3mqKgb7/qqjewY+SGtVKi1I06x2r90YnHCbbuLW7/kJcr+FqQhIp58ZtDu5C1n9cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755870901; c=relaxed/simple;
	bh=YPBaPR65gbIgfuU8DW5Zf1H4Ulj1k8A4IlsO2yYtJQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxDXOG2t/LBnAp3keZ5EXj/8JNIXFZIF/VAufbz5tTkVYJGMLO8CUNZNtOsRYDBWufzRhM3yYgywhp9yqQNo6u4pyGbhXA5NCMqBGmUs+bG+BxL2Ludwdx1EBzvRn9DpVb4rQczDe2tYLtjJP5hBpRjGtRpVWJ8HgBmuXTwrb3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=DfOfzRux; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 17A2240E00DD;
	Fri, 22 Aug 2025 13:54:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Hbz-VzBCVrbN; Fri, 22 Aug 2025 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755870893; bh=cU+sFi2Tg32hg70nWhILQn8eC9PUNjpsUYNCBZ+GafU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DfOfzRuxgYlcwqZnoaEl1AzLwMJkuUVYTiUt8RQbuLH1hudWdZLCbnBSbvUR0nhgG
	 YwAHrAucKQEL975VYGM68CsOR5awgv6QCTyT48fIW+cXtQrxNDFM+GKRiLqd5tsjV/
	 0li0Ytex1dpN+JUMEum5M8jMsJmCXvI7UFoHIFj6Mubv6b53t4+zUzAF9HpwMscsrT
	 lgzBVjI8A3LuOS0eO6sEUoMaXHjjkCTgtctBWlmgddheNoBRmuvI5QDREfcuKVsW3W
	 bgafxAebZDSmCt+l82xU0byrE3vP9dj/4/pIlYhgi/+zemmLp4uIBwSH0gkA9mNVcY
	 oplldDek4otdnPnGqYZLzpaTmGt7jSuWqWAa8Nt9LxmdANNV6Rex2zsrabvQ5QuXWS
	 EBo4vF/aOKKXEImXRCRrLn5sana9yZYDUhFlZqKCzAMJtVcBLRZVjPQ0yz8SpYYUzi
	 CNqDIccTz24al3Z+dMsTw1cp91dw6kPtiMV+CaDsI+PUkAKKVZANShTkEbYfOv9MV9
	 0g/8qKU50bEpRolNXlqLfaxH7TXbcUKBazHClX9HmW1hNVR4kBylzGhy8dCbOOipVG
	 K9+jNh9NJbExx4giYa6iUrJaNc6IoUYCMbYV0Q2R/U2/U/7pfZBZXCwxdVuq752pdp
	 sMRuPR3OGibsoeSzqBXambRM=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 01F3640E0163;
	Fri, 22 Aug 2025 13:54:27 +0000 (UTC)
Date: Fri, 22 Aug 2025 15:54:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, vannapurve@google.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, kai.huang@intel.com,
	reinette.chatre@intel.com, xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
	ira.weiny@intel.com, isaku.yamahata@intel.com,
	Fan Du <fan.du@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>,
	yan.y.zhao@intel.com, chao.gao@intel.com
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
Message-ID: <20250822135422.GDaKh2jhb5ooQ6QOe9@fat_crate.local>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819213247.GJaKTtf1er-Ced_mzP@fat_crate.local>
 <10587d02-1133-45fa-9ec8-2288a8868b68@intel.com>
 <20250821132521.GDaKceQXfEWHVwrlxV@fat_crate.local>
 <441aaf76-977f-487e-9db8-80edcda6078f@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <441aaf76-977f-487e-9db8-80edcda6078f@intel.com>

On Fri, Aug 22, 2025 at 10:57:36AM +0300, Adrian Hunter wrote:
> Not exactly.  I just want to fix the bug whereby the mce handler fails
> to mark the affected page as poisoned because it does not remove the KeyID
> from the address before looking-up the page.

Lemme ask this differently then: are you ever going to need KeyID in mci_addr?

> No one expects to find non-address bits in struct mce addr,

You're preaching to the choir - I don't know whose idea it was to shove
a key ID in an address value... it sure sounds silly.

> However, it is allowed to extend struct mce, so adding KeyID or raw MCI ADDR
> later is quite possible.

Why would you want to do that? Do you have a use case?

If not, you can drop that whole angle about adding KeyID later. If yes, let's
hear it.

Just this hypothetically, maybe we'd need it, maybe not, it might be a good
idea ... bla is muddying the water unnecessarily. So let's focus pls and
address *only* the issue(s) at hand.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

