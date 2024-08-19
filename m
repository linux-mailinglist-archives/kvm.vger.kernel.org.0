Return-Path: <kvm+bounces-24479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 353889560EB
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 03:38:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C63FAB21A31
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 01:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C6DC1C69A;
	Mon, 19 Aug 2024 01:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="diuUOI+u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E029460;
	Mon, 19 Aug 2024 01:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724031512; cv=none; b=JRmbfJs3hYoejRCy+EgK3hJDn0aV2Di6q5VGhIt9XSEk1nxSLNpie1gTBdKKIXi+u5YRVoVMXd2rRdJGdmWXNdXNsdzecKc5xH7OajelabjwZqE8XAdfp5EA3cgVqChJgjrpH7DZ57oAM943gCa64QZgKB8k4CEi398b6d8S4sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724031512; c=relaxed/simple;
	bh=u7fpHHFmP0e1iiPZvEY3LKtGRRObLIXWoQwQXIBn8yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8/396bJCLhnamMZgEdfAJhJDK0xa3pSUi0uiLGFUpbTrmsYmiRxX9D7PJe6XT67YFCQTHCokj7BPHgkskgld5BVFOYJ2eYkLTqhkkVsFQdaHKGL0G40nxvVisf2wJFQP2X5WdOE7xC6HsgBOQMExwX2n//GX5WKEIvhm03RPGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=diuUOI+u; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724031510; x=1755567510;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=u7fpHHFmP0e1iiPZvEY3LKtGRRObLIXWoQwQXIBn8yc=;
  b=diuUOI+uR3ulIGTm5gEF7T6EdkZP+MwQdXjQHSxTvF16A/5gqCVfpkjI
   t4jPPfacA1Jx+VGcWNmUL8y8NTiHMPURSyTectKL9axhJaMEdzBpMekDc
   P/cKdXXOEMR5H+YKXMGWitFp0KRRReLswvF+o/53iXwi5QyzUuV9iMRHf
   R3YP1kVvBngyoxiSPzCCB59aStGOF+oP4lbSod+lTZ4kyb5PqgxsO4kI3
   siB8Qc6PDi0GwKR6qXFFJtAQvyFV3AwGQThA06OZg9SPmfg3vLzsDL3hk
   UVuvx8xaIi7+5dT6SWcsBurAOQ/94SUoo3tHNiZ0R5gaT8evyu3E/fxDw
   w==;
X-CSE-ConnectionGUID: d8PCqb8NS0yT85T4ooofPw==
X-CSE-MsgGUID: kBKfXyfJSMOicEO7onxYrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="22136065"
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="22136065"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2024 18:38:29 -0700
X-CSE-ConnectionGUID: Mom4W+8LTueY2uDfqnbU5A==
X-CSE-MsgGUID: l87ExLGsTCG+zi7WFiBmtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="60500615"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2024 18:38:27 -0700
Date: Mon, 19 Aug 2024 09:33:13 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kai.huang@intel.com, isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Message-ID: <ZsKg2fIjo41T0VTH@linux.bj.intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-11-rick.p.edgecombe@intel.com>

On Mon, Aug 12, 2024 at 03:48:05PM -0700, Rick Edgecombe wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> While TDX module reports a set of capabilities/features that it
> supports, what KVM currently supports might be a subset of them.
> E.g., DEBUG and PERFMON are supported by TDX module but currently not
> supported by KVM.
> 
> Introduce a new struct kvm_tdx_caps to store KVM's capabilities of TDX.
> supported_attrs and suppported_xfam are validated against fixed0/1
> values enumerated by TDX module. Configurable CPUID bits derive from TDX
> module plus applying KVM's capabilities (KVM_GET_SUPPORTED_CPUID),
> i.e., mask off the bits that are configurable in the view of TDX module
> but not supported by KVM yet.
> 

But this mask is not implemented in this patch, which should be in patch24?

> KVM_TDX_CPUID_NO_SUBLEAF is the concept from TDX module, switch it to 0
> and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the concept of KVM.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

[...]

