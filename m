Return-Path: <kvm+bounces-33113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B9A59E4F46
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 09:07:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDB30288138
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 08:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DEDE1CF5C6;
	Thu,  5 Dec 2024 08:07:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C403A1B87DC;
	Thu,  5 Dec 2024 08:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733386030; cv=none; b=si1+R6EDAXi9qhHz50/xxEAW9KPPi0xIQB17aQsqZpXb9o3KeH/Jehq65bagoR6+oupLKLc4Tt+KsaPITeoh69JcbFqzcILLjQHoGm1G1qJrB139Eu72qiYe+yBVhVW9KKT1kZ/f6KCrR4VhE2ley8xvzo0n5BHN2HOY5Lp4aIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733386030; c=relaxed/simple;
	bh=GFHqPZbo0/NA/L2ml+i6T5YC4rkPldSeMoAYKTyRU/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cxHdIXp1OVcNwASfJNGbqt1NSe1cDllVBBP8Zpb2+wm8LJsiKseH/aWuob+LsOf4Jb1Qd9IZXTOwfY1SPlMYIGmKHeIrUKGd6AhUDV6PSbc0Z7fSfwsrklHrazAYm16mCE++T83qm7Yv3YTXbRDMvGERFFutnxaEriUt99+g2pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=fail smtp.mailfrom=kernel.org; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.org
X-CSE-ConnectionGUID: dXJhZ/lbQsK43zijRXe30w==
X-CSE-MsgGUID: i65gn/oFTRWOIIzimQ8E6w==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="33600148"
X-IronPort-AV: E=Sophos;i="6.12,209,1728975600"; 
   d="scan'208";a="33600148"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 00:07:09 -0800
X-CSE-ConnectionGUID: Zl4gqpLcQumHxlE34u2i+A==
X-CSE-MsgGUID: Z5+nbN91QbGUzTlsbE5FPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,209,1728975600"; 
   d="scan'208";a="98091259"
Received: from smile.fi.intel.com ([10.237.72.154])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 00:07:05 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andy@kernel.org>)
	id 1tJ6t3-000000041OF-29CP;
	Thu, 05 Dec 2024 10:07:01 +0200
Date: Thu, 5 Dec 2024 10:07:01 +0200
From: Andy Shevchenko <andy@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
	x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Message-ID: <Z1FfJbA2UY0OlhVj@smile.fi.intel.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
 <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com>
 <d189f1a1-40d4-4f19-b96e-8b5dd4b8cefe@app.fastmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d189f1a1-40d4-4f19-b96e-8b5dd4b8cefe@app.fastmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Dec 04, 2024 at 08:43:35PM +0100, Arnd Bergmann wrote:
> On Wed, Dec 4, 2024, at 19:10, Linus Torvalds wrote:

...

> I guess the other side of it is that the current selection
> between pentium4/core2/k8/bonnell/generic is not much better,
> given that in practice nobody has any of the
> pentium4/core2/k8/bonnell variants any more.

Just booted Bonnell device a day ago (WeTab), pity that it has old kernel
and I have no time to try anything recent on it...

(Just saying :-)

-- 
With Best Regards,
Andy Shevchenko



