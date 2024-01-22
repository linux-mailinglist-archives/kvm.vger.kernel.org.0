Return-Path: <kvm+bounces-6545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0410B836458
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 14:19:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04AC91C227F0
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 13:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 576CA3CF74;
	Mon, 22 Jan 2024 13:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="K1ufgytb"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B914F3CF42;
	Mon, 22 Jan 2024 13:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705929586; cv=none; b=ZNTbrkBkpUObEbyc5Gp/nEldettYD/ji1xyw3H++rcyI929JJBGEiRMTTC4EQjwz5Fv9gQXkkURPoRoBmOK5GErF4nDVnWV+Fi0f7zFHJ9tDRGHJxQSBh3uN7jzQ07PDc9st1mqnpD8cajm+hX7eGly3Lm3G/SlYFgIzRmGU16c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705929586; c=relaxed/simple;
	bh=mLJ+T9PZQML244q2CvgM8A7x5riW1S4OWUVj5BHSWI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qKhx/OItzZi2bjwnlv86pOZYuQMyVLzYCJLoKvuBre2TuKOhwbYyaGO9g0zObuJjslsuPeve/F6YAuHyFIMKOmM9e9OC8ZM1WS+piaj0t2/GsTB22LGWHAbqYIKJFw//ePvGAwbCl+N67GK7zPuwqz2GIHtqDbim49Nz25ew0fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=K1ufgytb; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0AA1E40E0177;
	Mon, 22 Jan 2024 13:19:42 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id kKFjKwbVE80b; Mon, 22 Jan 2024 13:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705929579; bh=O/+tvyIi7hu2G39Na79EAwIAhYkxG5TR/huFmkNcn9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K1ufgytbqAeKU/bbx1LpJre3vS6601/SVnnwLpFjXNGMTjPY9Nm+A+yHTatEKvsrn
	 jKCRF9Ct9kuq2WaIvEZudPxuW80aQ6sV2DEgv5x5w2nNd1gm+orAggr15hPXn9LnTV
	 cUfVXHwd6vGk+xfoE0ZhIIDM7KLxFhpAn9H/ju/pxuRmHrVBnfrxOWbrue3jllAb9r
	 3Ubo8g5GoprkmY0JAoNQ/3/1gO3n8x/H3xEyXKlDPiMSZqF9LxfuaMxSF9QRFcPajr
	 8NJF5vEyW9gUmzV79jzEDWm0ZuQYIjoELZ3xVbonpik5sMvDXxAiU/QiX8bykQP7Kc
	 Cw2GHvMV759VKo5cDPP2wPZ9ll2LNdCHOaMqMNDZ39c2R8gi0mtu6DPMMNFiHbF3Yp
	 2urrXZCC1l8c5a3GmCU6TZPaFSSWTC+ELzhYkcSE3p4AoKMYNd4y7fjZB858BaEaEz
	 ziUGfyBu2TlOKwvD/W2xUhehBQpzfY5muWbfrm2iSswSPS/3uAfPffHr4k9lTsP+oE
	 BgFJhOWW1jILISG21BWkJnVsw2RiFaruT3nYvvRqjGhOESDcc0WyJIVXXm/ToE0Ynr
	 c28ogu11dMvokRps9/KMY/k6zJnVIxhaJczZEIHBpnsctGH7VtFfXrjrnLe3fXVhLk
	 zJ6/3hP9K7ehKB8eE7xkCFg0=
Received: from zn.tnic (pd953099d.dip0.t-ipconnect.de [217.83.9.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 897B840E01B2;
	Mon, 22 Jan 2024 13:19:16 +0000 (UTC)
Date: Mon, 22 Jan 2024 14:19:10 +0100
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
Subject: Re: [PATCH v13 08/35] x86/fred: Disable FRED by default in its early
 stage
Message-ID: <20240122131910.GRZa5rTpEda4I1YfUX@fat_crate.local>
References: <20231205105030.8698-1-xin3.li@intel.com>
 <20231205105030.8698-9-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231205105030.8698-9-xin3.li@intel.com>

On Tue, Dec 05, 2023 at 02:49:57AM -0800, Xin Li wrote:
>  			Warning: use of this parameter will taint the kernel
>  			and may cause unknown problems.
>  
> +	fred		[X86-64]
> +			Enable flexible return and event delivery

Let's make it accept multiple options from the get-go:

fred=on,disable-when,foo,bar,bla...

in case we need to tweak its behavior.

If it is only "fred" it will propagate this way downstream and it'll
lead to confusion later when people have to update their scripts and
config files when "fred" alone doesn't do what they're expecting
anymore.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

