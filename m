Return-Path: <kvm+bounces-33121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EEF679E51D1
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 11:13:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A94152834BB
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 10:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0281DE8B0;
	Thu,  5 Dec 2024 10:01:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A651DD0E1;
	Thu,  5 Dec 2024 10:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733392905; cv=none; b=cSRlKZfYGZ2laAlC2TFi33wvRFcVn4gxYghQHl6MZr6TZMRmrgwVF3yTLBL1i+zWYGpIMNnMLULPFqGyMLcmP4Srwh10oAnLV5tjsq7YRoiIbB1udB21K7Y2vaPg/wrL3HRs+5NNvL7ZEhuI/iadWDeZZsQpF2kXq7WqQ8vRhFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733392905; c=relaxed/simple;
	bh=EzD36BPk1VbJF9ybvfWC8jAXoylXlbjsVSvCcIwAPbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fbX5uPHjefpcvDZkbe5yL2+nMjqtoRBT/LofhFbS8oKeJ7NEMG42AhJXmK44Y8KTliRK52R72vb8wBurkk5jA1N3n+97o2HiO2OEnZ/CbfpkODeecPt3evHgGReg/iEZYgRx2jSgiwHIFxYRRmvvzVgYxMdi+ODLJIlZu4nBGHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=fail smtp.mailfrom=kernel.org; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.org
X-CSE-ConnectionGUID: 6hQCuTmoQjiTPWS+K5E49w==
X-CSE-MsgGUID: /9pMUYu8TbiA89rB826BTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="33940069"
X-IronPort-AV: E=Sophos;i="6.12,210,1728975600"; 
   d="scan'208";a="33940069"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 02:01:44 -0800
X-CSE-ConnectionGUID: UgUVTmBTTVuDOvGLCY3YGg==
X-CSE-MsgGUID: LDL4sI8aS1C3mG+nBOD+hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,210,1728975600"; 
   d="scan'208";a="124863533"
Received: from smile.fi.intel.com ([10.237.72.154])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 02:01:40 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andy@kernel.org>)
	id 1tJ8fw-00000004346-1y7A;
	Thu, 05 Dec 2024 12:01:36 +0200
Date: Thu, 5 Dec 2024 12:01:36 +0200
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
Message-ID: <Z1F6AIjZdjv7igVp@smile.fi.intel.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
 <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com>
 <d189f1a1-40d4-4f19-b96e-8b5dd4b8cefe@app.fastmail.com>
 <CAHk-=wji1sV93yKbc==Z7OSSHBiDE=LAdG_d5Y-zPBrnSs0k2A@mail.gmail.com>
 <66fefc5a-8cd9-4e6f-971d-0efc9810851b@app.fastmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66fefc5a-8cd9-4e6f-971d-0efc9810851b@app.fastmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Dec 05, 2024 at 10:46:25AM +0100, Arnd Bergmann wrote:
> On Thu, Dec 5, 2024, at 00:33, Linus Torvalds wrote:
> > On Wed, 4 Dec 2024 at 11:44, Arnd Bergmann <arnd@arndb.de> wrote:

...

> I did come across a remaining odd problem with this, as Crusoe and
> GeodeLX both identify as Family 5 but have CMOV.  Trying to use
> a CONFIG_M686+CONFIG_X86_GENERIC on these runs fails with a boot
> error "This kernel requires a 686 CPU but only detected a 586 CPU".

It might be also that Intel Quark is affected same way.

> As a result, the Debian 686 kernel binary gets built with
> CONFIG_MGEODE_LX , which seems mildly wrong but harmful enough
> to require a change in how we handle the levels.

-- 
With Best Regards,
Andy Shevchenko



