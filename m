Return-Path: <kvm+bounces-16144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B3C8B5310
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 10:23:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24ECCB2196D
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 08:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A92F17582;
	Mon, 29 Apr 2024 08:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jzo93wXN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263FB1427E
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 08:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714379022; cv=none; b=FRYUV08BfGIDw9XyYbZXMsTrfOzowd2yz/qb3LYnX1yILqF0eA/KHtx8sdFSPUltGOcn7UPLja5Uemt/O9geo1vwyDuU+3/zCbZw0DoQi1zyZBVqxfIOgVdkvxOL4z6psaVVvxzeV4Qf4KHMC4IO5VL7SRH7LpgxO+Hu1FLLGnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714379022; c=relaxed/simple;
	bh=9DatA6zU8c8IdQyZJn//UhzdMLNvF8LMizb09EGt6kY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D6G2m1vJjc7GuoN2KqYNQsi/ULzPVOwul4SRL/t5nxkgtrwkR9CmYYHLuustchj4MDw9XYYb2nTX+AfexeGuczEetfhywygR20jvC6xBGLXEaLU10nFyDDO7SBSJxQUu+6/tmou0Ldtg/3qWA0boAXf1+MDr7sC4tnVuojN/FLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jzo93wXN; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714379021; x=1745915021;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9DatA6zU8c8IdQyZJn//UhzdMLNvF8LMizb09EGt6kY=;
  b=jzo93wXNi3RhIZ8NQg49Pa4nWxmC51pHvLtF9S0q3/zOhzFvXBwOcGQn
   VJnx7DNsNw4+0IZPZYaRkOoX+Jc8OofTH0AQH7L7Fu969HESYKA3ow+of
   uT2b1eOxOb8ROHyxsq0X6doMmmLt0FqQxibVOPo3MKd7k9a7SR4wnZIXV
   JQtA5frlBIO04u6SERYo9eWblBO4oFQlxNvBSu7gSFbhLx+z45Or4NVlY
   /kpt/7ns7+TS0UixjZzwjgVwYFUCoA6tCtiHhX7xj/psze2JcSQz0mYUk
   8qJCXYB/QS3vEo/WHDH7JqzriLfgFZ+7/Xrd2BkIOsluy+M+q5NbMvUkl
   A==;
X-CSE-ConnectionGUID: vC401ulUQ26F3Gduf6GPNQ==
X-CSE-MsgGUID: H+gqGnYyTgShKPCRjuHqpw==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="21438554"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="21438554"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 01:23:40 -0700
X-CSE-ConnectionGUID: xK9GJWpfSt2322EA1rfKWQ==
X-CSE-MsgGUID: scNYlZV2TeSpmMXHqtOkMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26147909"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmviesa006.fm.intel.com with ESMTP; 29 Apr 2024 01:23:39 -0700
Date: Mon, 29 Apr 2024 16:23:38 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Yao Yuan <yuan.yao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/1] x86/apic: Fix
 test_apic_timer_one_shot() random failure
Message-ID: <20240429082338.45dtke2ekt2aami7@yy-desk-7060>
References: <20240428022906.373130-1-yuan.yao@intel.com>
 <9ed124f0-9006-4166-921b-135c3c2c84fd@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ed124f0-9006-4166-921b-135c3c2c84fd@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Apr 29, 2024 at 03:40:20PM +0800, Xiaoyao Li wrote:
> On 4/28/2024 10:29 AM, Yao Yuan wrote:
> > Explicitly clear TMICT to avoid test_apic_timer_one_shot()
> > negative failure.
> >
> > Clear TMICT to disable any enabled but masked local timer.
> > Otherwise timer interrupt may occur after lvtt_handler() is
> > set as handler and **before** TDCR or TIMCT is set to new
> > value, lead this test failure. Log comes from UEFI mode:
>
> The exact reason is that the new value written to APIC_LVTT unmasks the
> timer interrupt and if TMICT has non-zero and small value configured before
> (by firmware or whatever) it may get an additional one-shot timer interrupt
> before new TMICT being programmed.

How about:

Clear TMICT to disable any enabled but masked local timer.
Local timer interrupt is unmasked when configure APIC_LVTT
for the testing, it may get an additional one-shot timer
interrupt if TMICT has non-zero and small value configured
before (by fimrware or whatever) new TMICT being programmed.

>
> > PASS: PV IPIs testing
> > PASS: pending nmi
>
> > Got local timer intr before write to TDCR / TMICT
> > old tmict:0x989680 old lvtt:0x30020 tsc2 - tsc1 = 0xb68
> >            ^^^^^^^^          ^^^^^^^
>
> It took me a while to figure out the above 2 two lines are added for debug
> yourself.
> > FAIL: APIC LVT timer one shot
> >
> > Fixes: 9f815b293961 ("x86: apic: add LVT timer test")
> > Signed-off-by: Yao Yuan <yuan.yao@intel.com>
> > ---
> >   x86/apic.c | 7 +++++++
> >   1 file changed, 7 insertions(+)
> >
> > diff --git a/x86/apic.c b/x86/apic.c
> > index dd7e7834..2052e864 100644
> > --- a/x86/apic.c
> > +++ b/x86/apic.c
> > @@ -480,6 +480,13 @@ static void test_apic_timer_one_shot(void)
> >   	uint64_t tsc1, tsc2;
> >   	static const uint32_t interval = 0x10000;
> > +	/*
> > +	 * clear TMICT to disable any enabled but masked local timer.
> > +	 * Otherwise timer interrupt may occur after lvtt_handler() is
> > +	 * set as handler and **before** TDCR or TIMCT is set to new value,
> > +	 * lead this test failure.
> > +	 */
> > +	apic_write(APIC_TMICT, 0);
> >   #define APIC_LVT_TIMER_VECTOR    (0xee)
> >   	handle_irq(APIC_LVT_TIMER_VECTOR, lvtt_handler);
> >
> > base-commit: 9cab58249f98adc451933530fd7e618e1856eb94
>

