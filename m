Return-Path: <kvm+bounces-51265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2206DAF0D97
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 10:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A9534E0B1E
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 08:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0266C236454;
	Wed,  2 Jul 2025 08:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="adcXFF4R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89572211F
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 08:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751443990; cv=none; b=d+rxX+caMiSVaz0AdRDiCt4qeErZrBuhzk2R92nDAEbjiytOiBD+sqo/+cqNI/syCqCY+00USH2dxbVWe80HI7zAcEKWLACclLiYRo7jFUnLQlPQyWXu0s7Q3byHMvyqv2VeaDisbu1v+QpL2OtjTB0L2q5fieeRF9YQZh5Mp6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751443990; c=relaxed/simple;
	bh=pqKQoXF566I3jN7jBYoVqec+bIUayudHtA0Prhir1Lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aSCt57CBymTdPKFkw+SkQDwjTOgTAPbwbqdWCK6tiXsL1Ort+07KNyBWjsG5MDij1Nxr24OnhLKXNonyRheWyJ9n6ZmwZiGxeVCT8xqskyEAf+KUfTMxPuCR9/XDXVTVBAwRI5HOuk6ESXaubXJTXd0u8lhoTj4AgP3F8+2g+a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=adcXFF4R; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751443989; x=1782979989;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pqKQoXF566I3jN7jBYoVqec+bIUayudHtA0Prhir1Lk=;
  b=adcXFF4RQw7mOaYpONs2Qit57o400Ya7ASOC136XJp8UPSnwhW8ItUkk
   izoWBKsu4tF+/CcHvm9W7hgy8BB+IJg1jKBh2lR2yqtUnkZn3FlFCq5VX
   MfvSdJQiwdjsYA9w2a8dBcU/0PEw3ZJTxxzuxsyyhtpjtc3ZN/qcy+OFT
   qOihB6cT+TGWz3n4WcPERmMYzAgfsVSptmW4j9DSrBXINJ4yqo2EGddrB
   xdL5wxEiaVU5rE9R/NhjO5QGN2mcZOGxyjAl9IHPq5PAfBbA4tyEEqW2q
   l3i5kyXMSrGBeG76+/4DIlpwkVNIdCzkbFuqu5VY7PLR4wOFflCXH7ZgF
   g==;
X-CSE-ConnectionGUID: XBjtXw5nSBq73RlsytYrTg==
X-CSE-MsgGUID: hJMeNtnNTyqKd8XWNtOgDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="53821378"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="53821378"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 01:13:08 -0700
X-CSE-ConnectionGUID: 6z/xjzRbToaDXZD/mBpeLw==
X-CSE-MsgGUID: G+Ui2uqNQlmmGX/qhD8vzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="159524773"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa004.fm.intel.com with ESMTP; 02 Jul 2025 01:13:04 -0700
Date: Wed, 2 Jul 2025 16:34:29 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	qemu-devel@nongnu.org, pbonzini@redhat.com, qemu-stable@nongnu.org,
	boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
Message-ID: <aGTvFbqLKcG1wLqO@intel.com>
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com>
 <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
 <aGPWW/joFfohy05y@intel.com>
 <20250701150500.3a4001e9@fedora>
 <aGQ-ke-pZhzLnr8t@char.us.oracle.com>
 <aGS9E6pT0I57gn+e@intel.com>
 <f1d53417-4dce-43e8-a647-74fbc5c378cb@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1d53417-4dce-43e8-a647-74fbc5c378cb@intel.com>

> I think we need firstly aligned on what the behavior of the Windows that hit
> "unsupported processor" is.
> 
> My understanding is, the Windows is doing something like
> 
> 	if (is_AMD && CPUID(arch_capabilities))
> 		error(unsupported processor)

This is just a guess; it's also possible that Windows checked this MSR
and found the necessary feature missing. Windows 11 has very strict
hardware support requirements.

> And I think this behavior is not correct.
> 
> However, it seems not the behavior of the Windows from your understanding.
> So what's the behavior in you mind?

Guessing and discussing what Windows' code actually does is unlikely to
yield results. It's closed-source, and even if someone knows the answer,
he probably won't disclose it due to contractual restrictions.

Thanks,
Zhao


