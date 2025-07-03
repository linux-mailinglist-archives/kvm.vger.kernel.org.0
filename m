Return-Path: <kvm+bounces-51501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BA4D0AF7DFF
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 18:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89E78189AC2F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 16:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F26B1258CF8;
	Thu,  3 Jul 2025 16:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dO/jpjrG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9310B30100;
	Thu,  3 Jul 2025 16:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751560507; cv=none; b=pwUNnl8KoPRFdMxLoL14Oe42c43qdqt805Yq0f8cq+QN0A86X9uUtLjfoAGZGHD7OBLovzkfNJaMgXAMD9/+KB9FOL7dzVP7fIdyLfMs+IJ4cxHdWFqchbaqvPWJK3oXTjILZGF8wL3mNCwg6aKeAXjS+HuGVMAHhmKA1EznD6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751560507; c=relaxed/simple;
	bh=+pQ6axBZKWYNlTIA7weqahAS0QG8cyQTNtl6Daqtpx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gp9mZPxHaKZSHlD5LIjudvZ4O8RBKi08tWlY3bHp9ageIUqtV1Zb6nBMW13S654gubXp04dh1oIEhS4wqa6HyWfjxSEHUKUxk4WaDMCgLE4uZugBIOYgd/7YEfx4igKlxlhVdURMU7h1+wJKiGdyY+qRGEGlEYu7dDzpuFsLWhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dO/jpjrG; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751560505; x=1783096505;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+pQ6axBZKWYNlTIA7weqahAS0QG8cyQTNtl6Daqtpx0=;
  b=dO/jpjrGc5iWCTYwMQeqY2Jrjd0HcGKizx5nyh1HHMBb9+3sRuqIAzGJ
   D+ZyYXljRp6TEIHs7wEIZbHaAnccqMfU9XPyupjJm1gNKQqviSdJzJA2U
   ypa85LzX+VfF2OXHE3E2rlpiDi/f1NUb5gW1lZG8PSjKDGuIU4sYa5CMH
   CyfQXoNrgPi06mrbnljlcS79ni7StEA1O+eqr7qg4Yp4Nmy1I4Em617Z/
   visMjpier3/J18M7K/oa7q960pTBRE629U8i1s9zmwNrUAZtiOPJl3NJG
   Xh3L77QUSIYLVKlw5zM0FCipQDscaEg0Rt+cNNABrf8D2HpBF3cRCXoBz
   w==;
X-CSE-ConnectionGUID: E9b2SjYIRSahTrqRjg/5uQ==
X-CSE-MsgGUID: L4nQbGh6RQmDZD14uzTUXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="64947458"
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="64947458"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 09:35:05 -0700
X-CSE-ConnectionGUID: Va9y2BfrR9qHBuxzouOn8A==
X-CSE-MsgGUID: qWvihJ2JSKubCt8+NmgX7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="158770553"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa003.jf.intel.com with ESMTP; 03 Jul 2025 09:35:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 7E0641E0; Thu, 03 Jul 2025 19:34:58 +0300 (EEST)
Date: Thu, 3 Jul 2025 19:34:58 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com, 
	seanjc@google.com, vannapurve@google.com, Tony Luck <tony.luck@intel.com>, 
	Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org, H Peter Anvin <hpa@zytor.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, isaku.yamahata@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com
Subject: Re: [PATCH V2 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Message-ID: <7qncvhwxodim4pjpmnpe4ib2pzkppkgves3jfh72tmxli66rur@fiu2danzib7a>
References: <20250703153712.155600-1-adrian.hunter@intel.com>
 <20250703153712.155600-2-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703153712.155600-2-adrian.hunter@intel.com>

On Thu, Jul 03, 2025 at 06:37:11PM +0300, Adrian Hunter wrote:
> tdx_clear_page() and reset_tdx_pages() duplicate the TDX page clearing
> logic.  Rename reset_tdx_pages() to tdx_quirk_reset_paddr() and use it
> in place of tdx_clear_page().
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

