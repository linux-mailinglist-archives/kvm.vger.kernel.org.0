Return-Path: <kvm+bounces-14330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F1B8A2063
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 22:46:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5C631F23EBB
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFC2286AC;
	Thu, 11 Apr 2024 20:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O9Avea6b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0A5205E15;
	Thu, 11 Apr 2024 20:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712868393; cv=none; b=OpD9u/CFwOfqKl9hCY6tTc8sRjafSKV8d4IHHCbqes+GK66+so/PGn/F17PuVXx/I3mYyJVqLBfQEKg6GbIPkFl0fWqD6jUfgPUq1ZwlFQWpDwWTfdQ8nEJzH66e6agVUux4R3yM5F30RHvClMwGRsgstxoU9/BbOrRqgBSBPr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712868393; c=relaxed/simple;
	bh=xGjifG/Meb0EpxZ/+JCL9Kf4LMpK0B5P9WfvNR35+u8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sf1iOd7kjTQIXXaL+Py9YDoOO1afPjgkt9L6mx4mW8S96jkguhpckPy4Okq1RybVuTIwBJRj7gbUraJJSBIFWFjNs7ClSCg1vypLiquljt9qShu14AQdWXOY9tFg98Rl1hsjo+TRDrcNjtIIxehldghQErxOX89ND6ViCV0XYUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O9Avea6b; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712868391; x=1744404391;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=xGjifG/Meb0EpxZ/+JCL9Kf4LMpK0B5P9WfvNR35+u8=;
  b=O9Avea6boRo3L+tlxSe8hIQk07Ynl9eVyo6IBH1ENeatHqYekqPGIyLx
   Ozh0YMVTzLy0TAUx2hxPKf4Kglr/JsIcIkgVuLCWQotXxAHVmucjv9zsY
   cMgsJzanj/dm9asK3HzuBb1P2//IAiPv7AMV53q1fS9iJN0tZGJ4CrKsa
   CmSUmTyg0nQRaGswP5tLnmdKX/b7mbihWqqJD3IzLYWC5/2c11u6hZiU1
   redtS6d7I8YASZ/jqtJDHJeP+NQkFcrzOk5uQBMDXbn5JiUP0jILBrqth
   i2CxmwGT4/YoKaqJSanIgAt2bxlvvKAAR4cWauunNj8SVi/LIy/rr+7dO
   w==;
X-CSE-ConnectionGUID: JnfJG2JNQCyLsUsAWCHwZg==
X-CSE-MsgGUID: uu84z/UWTM6XXhWjvNMkIQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="30787199"
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="30787199"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 13:46:30 -0700
X-CSE-ConnectionGUID: RjUis6vlRqybWBBjNCgJLg==
X-CSE-MsgGUID: +A9NZ8A3TNCJ0HcqBEr0mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="25488117"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 13:46:29 -0700
Date: Thu, 11 Apr 2024 13:46:29 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20240411204629.GF3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <c11cd64487f8971f9cfa880bface2076eb5b8b6d.camel@intel.com>
 <20240411192645.GE3039520@ls.amr.corp.intel.com>
 <54f933223d904871d6e10ef8a6c7c5e9c3ab0122.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54f933223d904871d6e10ef8a6c7c5e9c3ab0122.camel@intel.com>

On Thu, Apr 11, 2024 at 07:51:55PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Thu, 2024-04-11 at 12:26 -0700, Isaku Yamahata wrote:
> > > 
> > > So this enables features based on xss support in the passed CPUID, but these
> > > features are not
> > > dependent xsave. You could have CET without xsave support. And in fact
> > > Kernel IBT doesn't use it. To
> > > utilize CPUID leafs to configure features, but diverge from the HW meaning
> > > seems like asking for
> > > trouble.
> > 
> > TDX module checks the consistency.  KVM can rely on it not to re-implement it.
> > The TDX Base Architecture specification describes what check is done.
> > Table 11.4: Extended Features Enumeration and Execution Control
> 
> The point is that it is an strange interface. Why not take XFAM as a specific
> field in struct kvm_tdx_init_vm?

Now I see your point. Yes, we can add xfam to struct kvm_tdx_init_vm and
move the burden to create xfam from the kernel to the user space.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

