Return-Path: <kvm+bounces-50993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBEF8AEB86D
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 15:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFB6064488A
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 13:05:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5729F2D97B1;
	Fri, 27 Jun 2025 13:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iqTKHExs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D13F2BEFFE;
	Fri, 27 Jun 2025 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751029520; cv=none; b=tjaIoanzLXLmvgGyQqBb4XMQXyPZ5cjXstbcrMqO/oqWwrs8ii/aoJzo1ejidbBSAkxCGxIz7PhIw4C06wErrY/VE8xSq+S4kwYplkWHeljUT88yedM2HYWKPRCS2FgfAULm4u6/yI/Y/WZs5fqzXBlL0iGN/ms9cqOh0oJnMEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751029520; c=relaxed/simple;
	bh=r8wNTmmIIh2s8lvEUVCB9B9mLNpvPUEVLERT88Ta94U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AuhmpmRLRJ2baSF2/BLcte0s51pP3pRgJ0IAgk1Hhk49V2M9SQi3iFAS7FCn1U6EbleI3gQVSQEIJqv0HVKxaovLj6sz5bLu/mCsuRyTnwG7bQba1C6C5hKi+OM5JFj0dgMDibAeF7WTFDBwhp4SWR3s29DbPyq/nIcs4ZvAJ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iqTKHExs; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751029519; x=1782565519;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r8wNTmmIIh2s8lvEUVCB9B9mLNpvPUEVLERT88Ta94U=;
  b=iqTKHExsLYxk9+IuLiu7weKs00Mh8E2xLQ7huepw13igOrq2sdEDq4T9
   2dRXw6dlPJvjb7by2Kti3qjBsOFDRNefjXUTQ1O5+Lh40vl246quSk9fP
   G2S/Wv3Ix91g++F4Hi1GaNagIhJ8yL2BdqKOydQNPmJrycsXCSRCP4PKt
   1//Tb12x7U//D7bQT1D0sPOl7weRk9YGWMXYrIiWxQjO2X6pqI2VC78Jf
   qCfj5nAv5qpBnKZxT0Ys1el0fK9WWLWN45jm6S/NZwe2MUJCcpBQi3uDY
   b1J9eQ4VrQ6omj3+w0LUuWxXgamebVzTOhqsrx9yMcC2KDgSnM4gUes1g
   g==;
X-CSE-ConnectionGUID: 087pGyUUSgOGMuUZLSsV0g==
X-CSE-MsgGUID: pT97r96PQR6+PS/wPQ2wdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11477"; a="70774085"
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="70774085"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 06:05:18 -0700
X-CSE-ConnectionGUID: Dhl3vDvWQ8mSxR0loC60LA==
X-CSE-MsgGUID: 1vMG/J4YQXiyAUN49tBeww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="152324654"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa006.jf.intel.com with ESMTP; 27 Jun 2025 06:05:15 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 52C076A; Fri, 27 Jun 2025 16:05:13 +0300 (EEST)
Date: Fri, 27 Jun 2025 16:05:13 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"Huang, Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Message-ID: <5d7t2zij3dbjszpy5vhg6fuvgku52wpf3v3cjsf5gwp2adqxwy@ucjijezfgqm2>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <643af193b814ae6ab2473562c12a148b31ad608a.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <643af193b814ae6ab2473562c12a148b31ad608a.camel@intel.com>

On Wed, Jun 25, 2025 at 10:49:16PM +0000, Edgecombe, Rick P wrote:
> On Mon, 2025-06-09 at 22:13 +0300, Kirill A. Shutemov wrote:
> > This patchset enables Dynamic PAMT in TDX. Please review.
> > 
> > Previously, we thought it can get upstreamed after huge page support, but
> > huge pages require support on guestmemfd side which might take time to hit
> > upstream. Dynamic PAMT doesn't have dependencies.
> 
> Did you run this through the latest TDX selftests? Specifically Reinette's WIP
> MMU stress test would be real good to test on this. 

I didn't. Will do.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

