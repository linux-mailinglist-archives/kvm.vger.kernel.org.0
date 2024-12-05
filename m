Return-Path: <kvm+bounces-33111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8AAF9E4F0A
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 08:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49BA21881DE7
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 07:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C71BB1C3318;
	Thu,  5 Dec 2024 07:59:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDF61C07C0;
	Thu,  5 Dec 2024 07:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733385571; cv=none; b=hVlfHlv586hc9h55qkHZ8vwp2RZQho9IuQbrQLsIUkKCN6SJsBE31YWCfNO247MslmxPCCLQ9ga4OZaz6DRKMbJw+GYLmh+9VPAPI9qomG5EZ08Xqzr/UPSyYjy3ZIqwRaV5jgTdxgJBdqz/5YjouqoCoQIAniyLWcuBbPz+XZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733385571; c=relaxed/simple;
	bh=+Kfe35p1h0mIRKJFisZYqKQ5qOz5tMN0HE760IaIWEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lzsUilCgNED/PLD0AiHgG9CNkYOqWMeGKEM/g9QfqlJkFsBvVfwnL53GppNClH8qQun8z0aKhUngepI7EvRejGpsfANqUyJOwq+5qgAcez3bbEAweyq3xcqu7f7mmn6XnabYSUibhtJ6dh+xsoRlci6PSQ0zZ5g7ls/vwc7XSWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
X-CSE-ConnectionGUID: t1ggzOYoRcSD8ttc/3R+Ow==
X-CSE-MsgGUID: Te1BAz3nQwmaswrFJ4iMOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="51216585"
X-IronPort-AV: E=Sophos;i="6.12,209,1728975600"; 
   d="scan'208";a="51216585"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 23:59:29 -0800
X-CSE-ConnectionGUID: CvPtWnjlTNiQ9yP9Miql3A==
X-CSE-MsgGUID: FKonspnPRkGmQGaO0f6esA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,209,1728975600"; 
   d="scan'208";a="131457772"
Received: from smile.fi.intel.com ([10.237.72.154])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 23:59:26 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andy.shevchenko@gmail.com>)
	id 1tJ6ld-000000041Gm-43sk;
	Thu, 05 Dec 2024 09:59:21 +0200
Date: Thu, 5 Dec 2024 09:59:21 +0200
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
	x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 06/11] x86: drop SWIOTLB and PHYS_ADDR_T_64BIT for PAE
Message-ID: <Z1FdWZHa79OH2b9F@smile.fi.intel.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-7-arnd@kernel.org>
 <CAHp75VcQcDD3gbfc6UzH3wYgge6EqSBEyWWOQ_dTkz8Eo+XgFw@mail.gmail.com>
 <d84fc2e4-ca81-42b1-ae44-292d0b32c7ed@app.fastmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d84fc2e4-ca81-42b1-ae44-292d0b32c7ed@app.fastmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Dec 04, 2024 at 09:52:01PM +0100, Arnd Bergmann wrote:
> On Wed, Dec 4, 2024, at 19:41, Andy Shevchenko wrote:
> > On Wed, Dec 4, 2024 at 12:31 PM Arnd Bergmann <arnd@kernel.org> wrote:

...

> >>                 pr_warn_once("%s: Cannot satisfy [mem %#010llx-%#010llx] with a huge-page mapping due to MTRR override.\n",
> >> -                            __func__, addr, addr + PMD_SIZE);
> >> +                            __func__, (u64)addr, (u64)addr + PMD_SIZE);
> >
> > Instead of castings I would rather:
> > 1) have addr and size (? does above have off-by-one error?) or end;
> > 2) use struct resource / range with the respective %p[Rr][a] specifier
> > or use %pa.
> 
> Changed as below now. I'm still not sure whether the mtrr_type_lookup
> end argument is meant to be inclusive or exclusive, so I've left
> that alone, but the printed range should be correct now.

Yep, thanks!

-- 
With Best Regards,
Andy Shevchenko



