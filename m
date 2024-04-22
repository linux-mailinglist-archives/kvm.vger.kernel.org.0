Return-Path: <kvm+bounces-15501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F9F8ACDA2
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB51D1F20F49
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8E0514F9D5;
	Mon, 22 Apr 2024 13:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jE9sZ4l8"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7632C14F122;
	Mon, 22 Apr 2024 13:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713790845; cv=none; b=XBGdOxVQVdafijTw8+CU7kJfTFg9guj4HUqt0psPq0TipVFywsHq4j8OPGxJIAIAp6vKurFfR4mFhyOeRoIXpoypFavZSJ3+HsV/j/u2Rb3q+AhsZixyWWXdMnGsaBJwETYLnj5JQkRuOEFrnn/vmbSA/BFqNo2jVHDEjDKxxrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713790845; c=relaxed/simple;
	bh=iETkUvyaaIplvnaSBNoV8Wvwia4mTtvh1JmWeUWBlg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kHnotzNjbFgj8gi8R5svYs0VZkqSVDgRUn9tULcUkOu72wBrmDDKIexiemQVSLtLyUXJQbqOvLmeBjo/8NN4A7Tl0mbf+DCDRYCCyIFSXbi+98QY716tp08gGe/uE8bzPdQG9DeQ7BJTc1riWvZ6RnJFd0Bwgu4ReiERQb2ADxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jE9sZ4l8; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DB2A640E0240;
	Mon, 22 Apr 2024 13:00:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 0lZQlEM3nRtm; Mon, 22 Apr 2024 13:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1713790834; bh=4ZyktgLFRsNIXjDm7Mz1wlAPtu+JYmmQ12NOnDr62JU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jE9sZ4l8NBSgDAedIGM72lkyzcPoP+7JNg9QKXdxranXa2QC2FZdx5VsbsarXMv7S
	 Fm8Ag/gbHGbaavFId7PQuZIb5E46Hi+XZ4kL8sNuMCqP1cqFwWA7Vb3D6LjtfuI+7a
	 DrCKZh23HC28uwKxmWBIXMM5q4WUxBS5hgaieTV5fHXpP5lFVn3ODIbKxNdcMlnsW+
	 E76/ypmYySguL0+oMsk7XDJ7wTx0P9j870WQx+EWTMTr7jL1HXGElCfQdERaqgB8sC
	 GibT7Eo2vDfQYtLG4AmxE34EWyd8DeuZLAI7Ew+foWt8aKpNiLus36lJ5QJypeUuEc
	 ub+lbdzixjpPNdZww/+lhxxZmkRAMr3ry5pP74SbpYlhlHmpCA9EsH79KFs+EXHew3
	 bpR9wG1MVeSQmhrgAVujIezOl8DwZEmrLNDHI0QoDmtSs74KSlSg96X7z2Ft0xvLWg
	 nqS6l6ucSz1q6vdx22/SgVkfQ3ZKQrjVRsqS7KG+Eo1e9Xj0OJBhUERBz16c6K844G
	 EZ0NRIXDKGIllL1cojNKQBcFNoXJFG3bMCPgIKsIV7zTkryGMGPb7xHcEjXGF5FHsT
	 qHETvQIQL1i1npwKoCtCmYsvkWJtHpGlGqjJ8IYyCfXY2n5euBL5KU69tkMUkqztNP
	 8WomUEjATwsI/5nh4kLCON9A=
Received: from nazgul.tnic (unknown [IPv6:2a02:3038:209:d596:9e4e:36ff:fe9e:77ac])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 17F0640E0249;
	Mon, 22 Apr 2024 13:00:22 +0000 (UTC)
Date: Mon, 22 Apr 2024 15:00:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 06/16] virt: sev-guest: Move SNP Guest command mutex
Message-ID: <20240422130012.GAZiZfXM5Z2yRvw7Cx@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-7-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240215113128.275608-7-nikunj@amd.com>

On Thu, Feb 15, 2024 at 05:01:18PM +0530, Nikunj A Dadhania wrote:
> SNP command mutex is used to serialize the shared buffer access, command
> handling and message sequence number races. Move the SNP guest command
> mutex out of the sev guest driver and provide accessors to sev-guest

And why in the hell are we doing this?

Always, *ALWAYS* make sure a patch's commit message answers *why*
a change is done. This doesn't explain why so I'm reading "just because"
and "just because" doesn't fly.

> driver. Remove multiple lockdep check in sev-guest driver, next patch adds
> a single lockdep check in snp_send_guest_request().

The concept of "next patch" is meaningless once the patch is in git.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

