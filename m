Return-Path: <kvm+bounces-50684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3566AE8497
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:26:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98F7B5A6726
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 13:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9AB2620CB;
	Wed, 25 Jun 2025 13:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OZ1zo4/M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A9125C80E;
	Wed, 25 Jun 2025 13:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750857915; cv=none; b=GdQrehEaDQDmzVMCdgk4qP7d/PzXcdOu9k8FKu/F589anV+3H5BvPhy8iRHeAXUr11HBdDBvTwALibJJW8o1OGVAPzJSuwBLFiRsIJjQQebTlxD7mSwVad08NVA8S7DautUwcdNvqkhXwIyXKHP94pD35RkLG6Summ6/OZSdJVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750857915; c=relaxed/simple;
	bh=CgjkwNyjutbzFFdoJJ6nWB/tOECmuxW1AW8rPbD0mxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iHma6wcn73+3BeKLV1jIZIHl3GFNGsHxvBSPAdInYoKKzpqVyq/iyUiou7ARrpatCsOFSoGvve0UOc/QZzl5GatG/VEm0adlqPuwyeCuGr6/fBe0SDdzpwMjBJLHHvt5LNEK8a4pUDsr1NsEAACZvFT017u7d86G+uRVUB7aqZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OZ1zo4/M; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750857914; x=1782393914;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CgjkwNyjutbzFFdoJJ6nWB/tOECmuxW1AW8rPbD0mxQ=;
  b=OZ1zo4/Mt+CSjRYmPLt2EWNNUfHOsAUNrNqKiiqFNNqSJkv2mx0c7CXD
   stlGSuaZSuFI4WYXNW4gl8uFj+9AUCLCGLtXtqMaNm/+yxfm1Rozxe07S
   WRggNB/7P/91iP023Dd9Ya59HsXYlXWxQemY6sepYgecgw+vEEodUXH4n
   AE2XA2yQsFPIkwTGuut3FoUvGxe8AZyEGT/IW8Bkx4GkosirCT3HfpL9u
   ZNtWDW8XDsabkGbVRDaVCo5PCb2vTEOCqGbZZJSF3JMy7MfAkUkUIhQ/9
   zhzlcvRcupnrf94NkyMK8TYZigNFDdIKk6dddE1Sn5RCYtPGOjDIjTLpw
   w==;
X-CSE-ConnectionGUID: VGcuRNJYRQuTqWyFceGyIA==
X-CSE-MsgGUID: qbYnv29XQqCBtuYv1itFgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="63388911"
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="63388911"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 06:25:13 -0700
X-CSE-ConnectionGUID: gcQC5+leQg6cvBKP+YOH/g==
X-CSE-MsgGUID: 0sKks64lQtKjjcRols2Hpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="151641419"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa010.jf.intel.com with ESMTP; 25 Jun 2025 06:25:10 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 082CA27C; Wed, 25 Jun 2025 16:25:07 +0300 (EEST)
Date: Wed, 25 Jun 2025 16:25:07 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com, seanjc@google.com, dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, 
	kai.huang@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, kvm@vger.kernel.org, x86@kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Message-ID: <c4p2eecoo25n2ndamtpx4xwis66ujjczg7kjbii4chsknf33v4@pikwhzsu3m5y>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>

On Mon, Jun 09, 2025 at 10:13:28PM +0300, Kirill A. Shutemov wrote:
> This patchset enables Dynamic PAMT in TDX. Please review.

Gentle ping?

The patchset is crucial to get TDX adopted. The upfront memory cost of
enabling TDX for the machine is too high, especially if you don't know in
advance if the machine will run TDX guests.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

