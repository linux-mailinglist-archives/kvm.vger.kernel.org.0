Return-Path: <kvm+bounces-17609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF3FB8C8819
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:32:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5CA01F25D72
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 14:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC2E8BE7;
	Fri, 17 May 2024 14:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZPafAyJg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C62E28FF;
	Fri, 17 May 2024 14:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715956333; cv=none; b=bTDPB1F4VJrALjrDQcZDp/TDSxqOR+WQzZjCyYFSd8O8/6jCQhgrfiit/NUgrvu7CAg6d7lPmhmjtHGMZr0ul25SjNHMseJ6szFkLDV1KiUON+uCz3EhOd+UiGmGYXZpLX5GKpNmUoYlbFW6KXuqlBRxXsHC0HBd2CHHFIt0YOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715956333; c=relaxed/simple;
	bh=+aLRNa4yOp0ylfObvM77jP/z9GCYIpiglc9Gsv9Qu1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8Fq6PZVdric0ZVJKVAfZAx6iav1IC1S+VMEsjpOC7bnIpQjrOPazKE7Jk0QC4cf+Zt3uGJKyda/HEfYU6wwx1d6foCMB4XW5Ls8CAYVf/JR/lg8Q2dESpAXNRrzmusLAxfS5s0KirWrCfE80A5Gvm3i9lINNtustsv3aAsTUG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZPafAyJg; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715956332; x=1747492332;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+aLRNa4yOp0ylfObvM77jP/z9GCYIpiglc9Gsv9Qu1o=;
  b=ZPafAyJgbTDkIxC3AuY+F0THkXLrJJWJX9Xjgrbznfy6AROnyRS83xHd
   7PStvhl1Rzqp8WJLAbbBO7eHyVCYPMPQCNtD7Qiux8wWOhRS8QFYCJto9
   Y5/ilXQDXDxH18ycbHcZicUQAabmv/x+5Ir6CIbiYEMVpkQ7ao6oDxCwf
   lI8CeCQGs/pU0nqWO4V/4kXpn8ZKu06+oyuxfnqZmxp63f8zDqmOtuWD0
   xsfd8Wd4h+74Il89UTZDt2TG+tRoMj7H0itXKtxbZ/SuxWQkMHhf1bnb6
   FzrzDOg/720AnNZG9Tqn//XlL57shQTtMI1VD8jH0/Fo5fl3KVC4ZdQ2U
   w==;
X-CSE-ConnectionGUID: yIUb6zbpTYCBMCL+/Ms2sg==
X-CSE-MsgGUID: 9TRvF2lUS2qjcb8DzHN2gQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="11976826"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="11976826"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 07:32:11 -0700
X-CSE-ConnectionGUID: L7CyFOoMR1mh2UCbouDRzg==
X-CSE-MsgGUID: 7WE9tLshR9Czrld1/fPBMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="31820082"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa009.fm.intel.com with ESMTP; 17 May 2024 07:32:09 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id AA84619E; Fri, 17 May 2024 17:32:07 +0300 (EEST)
Date: Fri, 17 May 2024 17:32:07 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sean Christopherson <seanjc@google.com>, Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, 
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <46mh5hinsv5mup2x7jv4iu2floxmajo2igrxb3haru3cgjukbg@v44nspjozm4h>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>

On Mon, Feb 26, 2024 at 12:25:41AM -0800, isaku.yamahata@intel.com wrote:
> @@ -725,6 +967,17 @@ static int __init tdx_module_setup(void)
>  
>  	tdx_info->nr_tdcs_pages = tdcs_base_size / PAGE_SIZE;
>  
> +	/*
> +	 * Make TDH.VP.ENTER preserve RBP so that the stack unwinder
> +	 * always work around it.  Query the feature.
> +	 */
> +	if (!(tdx_info->features0 & MD_FIELD_ID_FEATURES0_NO_RBP_MOD) &&
> +	    !IS_ENABLED(CONFIG_FRAME_POINTER)) {

I think it supposed to be IS_ENABLED(CONFIG_FRAME_POINTER). "!" shouldn't
be here.

> +		pr_err("Too old version of TDX module. Consider upgrade.\n");
> +		ret = -EOPNOTSUPP;
> +		goto error_out;
> +	}
> +
>  	return 0;
>  

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

