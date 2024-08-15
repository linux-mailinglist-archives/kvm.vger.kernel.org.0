Return-Path: <kvm+bounces-24228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D63D9528E2
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 07:20:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C059F1C2105D
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 05:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06AC149C4E;
	Thu, 15 Aug 2024 05:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X5Jpr7ub"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AAF145B2C;
	Thu, 15 Aug 2024 05:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723699246; cv=none; b=uDfECrRBp/o+urtYMfEB0b9ElrxmWpWj9AJBy/h2dxz8uWe9nKFhirBTb3pnjMj6EME4dZgZON7CBzTB/HetBHM5bxa/kAXQdR9nm2slDt38uPaNXoNc2QA91NMNLv9Kya2jQuFZxC4OUvlpK6kKD/MGh1aM2epyXtI3TWLsWXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723699246; c=relaxed/simple;
	bh=cbOxyBCYg/0XIqa4Xoo62kk5EfvRKFQpcBXampyLLmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yghh0IWOAVY6Uu/ZvJIXSELU7lhh2v/tuJWEDCq1hijJLbCaOgPEnRKaPk9OpN5NNAxZJSo0TmuQzi3vwOOPwClUPEhA2emTqRPg5Wrk6KmAYvAhbwtbZMx0EbKFB0sSKKtiWtX7IcsdW8Da7Lnjdb/QhF3Il6vl4IYR2JxNSvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X5Jpr7ub; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723699245; x=1755235245;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=cbOxyBCYg/0XIqa4Xoo62kk5EfvRKFQpcBXampyLLmk=;
  b=X5Jpr7ubmxJdoUj20UFFQmPM70BNWyWbGxafQCdhl6O2ifVG1xSS7rSw
   qOt/N2bUosPCL6Ot7vXtkNV4J2GnGAIiNVSFHdM3n/+zucQtccep33jDc
   KEc1akMjN8sIoEKTg+uSwVFt+9xwi4ePSSo9s9fJJ0C3DKB6UM/HGcHTv
   0qds6kjNJYx8YatXdGFVF8yqoeq41aZcO2Xv7f7qTFl/cbznmzoBoAEvE
   EU/FZ+9x6cKRQoUd8gguXIMDkrmTi957vOGQ35KbtMfWEa/ibBRHn4gwC
   QYrc66OG28ElkQWetEipalN11fE0nSPRKeoAz2DAY2wyLIlipU3LX87wC
   g==;
X-CSE-ConnectionGUID: BuePdEAURTKZ2MIJ9Iw42A==
X-CSE-MsgGUID: aXgg7jX6SZCn3MUSj7WFug==
X-IronPort-AV: E=McAfee;i="6700,10204,11164"; a="22114601"
X-IronPort-AV: E=Sophos;i="6.10,147,1719903600"; 
   d="scan'208";a="22114601"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 22:20:44 -0700
X-CSE-ConnectionGUID: BWBMMAy4RiaQVkMYeDSWCw==
X-CSE-MsgGUID: XkciGCvfTXuy6EnNve/Qqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,147,1719903600"; 
   d="scan'208";a="82451005"
Received: from ncintean-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.134])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 22:20:40 -0700
Date: Thu, 15 Aug 2024 08:20:35 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kai.huang@intel.com, isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/25] TDX vCPU/VM creation
Message-ID: <Zr2QI_JKj6gs1K3e@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>

Hi,

On Mon, Aug 12, 2024 at 03:47:55PM -0700, Rick Edgecombe wrote:
> The problem with this solution is that using, effectively
> KVM_GET_SUPPORTED_CPUID internally, is not an effective way to filter the
> CPUID bits. In practice, the spots where TDX support does the filtering
> needed some adjustments. See the log of “Add CPUID bits missing from
> KVM_GET_SUPPORTED_CPUID” for more information.

We can generate a TDX suitable default CPUID configuration by adding
KVM_GET_SUPPORTED_TDX_CPUID. This would handled similar to the existing
KVM_GET_SUPPORTED_CPUID and KVM_GET_SUPPORTED_HV_CPUID.

Or are there some reasons to avoid adding this?

Regards,

Tony

