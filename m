Return-Path: <kvm+bounces-6544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F6DC836403
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 14:09:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81AB11C22720
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 13:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D61D43CF50;
	Mon, 22 Jan 2024 13:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="e6wfFtqi"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5271A3CF40;
	Mon, 22 Jan 2024 13:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705928956; cv=none; b=pR2vDwoPTZzclHNQF1zaGJeL08jUuKbZrnz3zE4hhjnvEnwuXw+0IdlsFCcRoDHb9colVTw1RSKRjSKkA8MfnCAJKhRAQhVLcBcG8y1DkgAK6qrqaxxtwlaq99+tOUFcunGZISYV//tcOym+CUg/f0GXTGNJLJtp1Ed88/6Hf8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705928956; c=relaxed/simple;
	bh=nBX1nAzCypBFAArWSdJUpcpURFil3TuK0uaA2ujkDzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rc8PwpMnmqvnyqwk6Gg9P++YiE4ygSAUrSWsvk6YqjLOMQw1s87GHnw8kavkwu8j/QeM85GS45FeMjEpFDXNQsOgwFvdK9ayhRFmK2f8q2zD/aehO9sFJMBb0KI0zGUSRXBpTbjWXvu8IRjoACoXF4SMcWW5iCat6AfCSOv8t8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=e6wfFtqi; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 85FBE40E01BB;
	Mon, 22 Jan 2024 13:09:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id eLLUWNaX3eQF; Mon, 22 Jan 2024 13:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705928940; bh=eTf0G+nsoYXpQyGDiFAXKjszCHpf9NvYJlgyMa5r3LQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e6wfFtqitOlRYEO36RZo5CKnIlncNgICpDDk58+bdJ+2vSZnopKKWVngmLzJPdvnd
	 PgVERWwlK9f15OX3gI7Q6CwH5TS2+DzskSmgzVCtKyoqgIVR53JxG4Doxit35vgBcr
	 cR9pb5s0l4t4aPPss1i7RMMXhKlYDbiKqB1Cs502753r9tSXlOM4KHSCWHv3Xm9M/x
	 KYo3qhCRyXTZIapgX63a3gIXI8awEZRwlWBWkty3jIaZ40Cc6jb7ioHwcMcXIOsHvc
	 SQGPOqdsWAzItp/P/V3rJi0gK8hybmypxw9iVR84Y2yv1uizcVN7EgfiKI6etPN27k
	 1B4q7qm3z+GNqfnBkyMPgffLc4vE3v358b0pdMKddE//bw0gKugu7SYS+yKq98aWqv
	 yc9eH2BQXULkjmI7940CALRu1OCsdCgD1aa8hASVyUxAaWwuP6ntdCKI7wxMwsZmFW
	 9/XXTkzpq0w0uNGDxzqLEpDMJ4zQ3pGlsafEWidbF6ooCpgbCD2kZxeyt11sjdb1CP
	 92WMKyBt3wOHiiiw8ia1DZaLo3qAYFzONvwIkiF9KbhVRYldEPxcq0aqx5p7pfczAr
	 O/iRhs84IdZOa0vbNQ4DUcEnAodPN3pzCKYdJqookoTLJQXIM1PFfvLH6ppQAZqjGl
	 0kltp+3VBkgXFIvUP6z1Dh3o=
Received: from zn.tnic (pd953099d.dip0.t-ipconnect.de [217.83.9.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1EFF040E0196;
	Mon, 22 Jan 2024 13:08:37 +0000 (UTC)
Date: Mon, 22 Jan 2024 14:08:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xin Li <xin3.li@intel.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org, pbonzini@redhat.com,
	seanjc@google.com, peterz@infradead.org, jgross@suse.com,
	ravi.v.shankar@intel.com, mhiramat@kernel.org,
	andrew.cooper3@citrix.com, jiangshanlai@gmail.com,
	nik.borisov@suse.com, shan.kang@intel.com
Subject: Re: [PATCH v13 07/35] x86/fred: Disable FRED support if
 CONFIG_X86_FRED is disabled
Message-ID: <20240122130827.GQZa5oy4OZHRFEqbsr@fat_crate.local>
References: <20231205105030.8698-1-xin3.li@intel.com>
 <20231205105030.8698-8-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231205105030.8698-8-xin3.li@intel.com>

On Tue, Dec 05, 2023 at 02:49:56AM -0800, Xin Li wrote:
> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
> 
> Add CONFIG_X86_FRED to <asm/disabled-features.h> to make
> cpu_feature_enabled() work correctly with FRED.
> 
> Originally-by: Megha Dey <megha.dey@intel.com>
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
> 
> Changes since v10:
> * FRED feature is defined in cpuid word 12, not 13 (Nikolay Borisov).
> ---
>  arch/x86/include/asm/disabled-features.h       | 8 +++++++-
>  tools/arch/x86/include/asm/disabled-features.h | 8 +++++++-
>  2 files changed, 14 insertions(+), 2 deletions(-)

Whoever applies this: this one and the previous one can be merged into
one patch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

