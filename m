Return-Path: <kvm+bounces-63886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E4E5C7583F
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:01:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6ACAD34CB7B
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EC8736BCF6;
	Thu, 20 Nov 2025 16:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mih06Jqs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC04626E71E;
	Thu, 20 Nov 2025 16:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763657830; cv=none; b=F/TXM7aSTreWbEmvsrMOkZD4UGGJecjzGmSm8GO7nKIqQatqQgbCnkGwzBfKNNpw5xS7SWqyfWQuxXBWv80gQcu5FYve/WkOb1BQTA6DlH8qSxXXLLHJFUn7CmnSvWaKhiGb9VAmdvBdCfIkzsd/F3uGT+aI6wf/UYGa1HCXzTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763657830; c=relaxed/simple;
	bh=vXTflFtt777xE+RSdswfKqSj6CxMdZ5UWuoHvGSAB1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iRjW7W+HGQ3WY8L9lrqy5N/aMycjGdgUze4N/tE4OCeVt4TVZIIhg7KkXtsmDVjqQnS2kia6C0GQrAsCcEzypebYM5RSBNOP5P9b3LTEeseD5AOOy1gz6MGCEslFyqoHV3Zk/nLPKtV8LBde9+wwWK/Dw2hE1QwIbhAWWieWgA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mih06Jqs; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763657829; x=1795193829;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vXTflFtt777xE+RSdswfKqSj6CxMdZ5UWuoHvGSAB1s=;
  b=Mih06JqsjdEJwIcpUi33FhUJVq8olHFFmu5SUodpb73Rwsu/1Z6Lk6Pg
   vuSylAjJ+QowUWPNlzGVg6G5g/K49UQ+uklgtKR2rzKl1Py99ZQWsBDux
   dl9WIga4fQVgLwzaQodwObYg6qjw40sU28IHsZypVyhFxDHdXvn3p8xf1
   vl8COuXu4yUZ4dAhGOFpfPeTAvLdJGiWNMj1dup/V9JuQm/fAbWktMkk3
   VF29JX/xVJ6rVEIuxdwmqGL8eQn8yNXBa4xsv99VEoNkzPHtn2xkgBvOO
   Xa3a8wX8QmA/wJpngFDV/79DbiV59oQH52v1zqoES1ArVxUi2HuGJidtn
   g==;
X-CSE-ConnectionGUID: niQMRJJXRCq1DLDXfeftTQ==
X-CSE-MsgGUID: PWF6TPbuTSqfj9Pd4v5aMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="83358565"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="83358565"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 08:57:08 -0800
X-CSE-ConnectionGUID: MnU1VIeQQ3SzItRQ+548Pg==
X-CSE-MsgGUID: WbSVl/OWTNGmSsZ03f0isA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="191229107"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 08:57:08 -0800
Date: Thu, 20 Nov 2025 08:57:02 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v4 02/11] x86/bhi: Move the BHB sequence to a macro for
 reuse
Message-ID: <20251120165702.a6ktnsry5zkupp4g@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-2-1adad4e69ddc@linux.intel.com>
 <f7a380bb-88fa-4dd2-ba75-977b2e22bbb0@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7a380bb-88fa-4dd2-ba75-977b2e22bbb0@suse.com>

On Thu, Nov 20, 2025 at 06:28:51PM +0200, Nikolay Borisov wrote:
> 
> 
> On 11/20/25 08:18, Pawan Gupta wrote:
> > In preparation to make clear_bhb_loop() work for CPUs with larger BHB, move
> > the sequence to a macro. This will allow setting the depth of BHB-clearing
> > easily via arguments.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

Thanks.

