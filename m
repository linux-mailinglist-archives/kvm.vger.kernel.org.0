Return-Path: <kvm+bounces-67375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 16E63D04823
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 17:45:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8D8E63132C97
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 15:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C53C47CE9A;
	Thu,  8 Jan 2026 13:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mS3i+UKQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA97D47C1AA;
	Thu,  8 Jan 2026 13:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767877861; cv=none; b=D2e9A+7x9pgzFcKvx1rIB43q1rk2tGCPWpBzAx7pJfKv8E28Rvjdnypu0QvXf35ZHH+NnZ8//oLe9BFL/BWawUjwlDk4BKfmG9rBDn3LFGuQUO1G8HEQlogYPu/sIGY61zVKl5a5yQQcFTpX84LzXkQ+5rF1+wnwx+r/rSyNHVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767877861; c=relaxed/simple;
	bh=PMdn4Wd/BqB96x3BjnhD0uwTnnWjh6uBR87FBMt3ykA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CaRTyO2kWVBw669UcrpA6sadL/qAvKArGZ+PN727bVERLIVbSCiJbQaWAeyBCjBMvPLPAXMos9oKjnei/h5rc200rHnhgxTIqmiBr+6EpA24uj5IcUNDVF+QUPKuRTamZ+gIx1XMXgawwW28Zwi2eJnIHw17m06u/gOAw5P7TfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mS3i+UKQ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767877860; x=1799413860;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PMdn4Wd/BqB96x3BjnhD0uwTnnWjh6uBR87FBMt3ykA=;
  b=mS3i+UKQtXkAzFQrMCddxJ2K3Uq8FWRA0E4dlPnPwmEexRA2EDBEM/AF
   TDr03wjcTYrwa9apefI3AsMWvHCy8bMuqgh8B/gxqlDdS2OietTSEQLLy
   OEVrVDCox9r5mGgoS410meZN7DXC2pDXd7r3nXWahVcNLF3tFREF0ZBvj
   XYNgI0wujQTwn/XiU5csmPtSck3C7q5G9TmJ2IkTA0zOuK8SgVaCT78ck
   BwtE1d9icaCYzV96oyjTqvcZxp4QOWDcOBWT44ZWUVg5/1KTKLA/Rinnw
   xAL0KYG5+6nQV9JTAUZK2YplYy+ENPXBFtmkzaYk8MPRhJDI25yk+evqD
   g==;
X-CSE-ConnectionGUID: oteY3RjWQbaj6rR36PcRxA==
X-CSE-MsgGUID: vJ2l6su8SOikWpnKlVh24w==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="94723648"
X-IronPort-AV: E=Sophos;i="6.21,210,1763452800"; 
   d="scan'208";a="94723648"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 05:10:59 -0800
X-CSE-ConnectionGUID: yjOpwlTRQBSODh4MdsGzlQ==
X-CSE-MsgGUID: DY6f9GcjSaaFPlqxvTh6ZA==
X-ExtLoop1: 1
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa003.fm.intel.com with ESMTP; 08 Jan 2026 05:10:54 -0800
Date: Thu, 8 Jan 2026 20:53:41 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Message-ID: <aV+o1VOTxt8hU4ou@yilunxu-OptiPlex-7050>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-5-rick.p.edgecombe@intel.com>
 <aUut+PYnX3jrSO0i@yilunxu-OptiPlex-7050>
 <0734a6cc7da3d210f403fdf3e0461ffba6b0aea0.camel@intel.com>
 <aVyJG+vh9r/ZMmOG@yilunxu-OptiPlex-7050>
 <94b619208022ee29812d871eeacab4f979e51d85.camel@intel.com>
 <aV32uDSqEDOgYp6L@yilunxu-OptiPlex-7050>
 <44fb20f8cfaa732eb34c3f5d3a3ff0c22c713939.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44fb20f8cfaa732eb34c3f5d3a3ff0c22c713939.camel@intel.com>

On Wed, Jan 07, 2026 at 02:41:44PM +0000, Edgecombe, Rick P wrote:
> On Wed, 2026-01-07 at 14:01 +0800, Xu Yilun wrote:
> > > I do think this is a good area for cleanup, but let's not overhaul
> > > it
> > > just to get a small incremental benefit. If we need a new interface
> > > in
> > 
> > Agree. I definitely don't want a new TDX module interface for now.
> 
> No, I was suggesting to think about a new TDX module interface if that
> is what it takes to really simplify it. For example, something like a
> consistent TDH.SYS.RDALL. For TDX module changes to be available in the

I actually don't understand why a RDALL seamcall could eliminate
the check "if (some_optional_feature_exists) read_it;". IIUC, The check
exists because kernel doesn't trust TDX Module so kernel wants to verify
the correctness/consistency of the data, otherwise we could accept
whatever TDX Module tells us, do the below for each field:

  static int read_sys_metadata_field(u64 field_id, u64 *data)
  {
	...
	ret = seamcall(TDH_SYS_RD, &args);
	if (ret == TDX_SUCCESS) {
		*data = args.r8;
		return 0;
	}

	/* The field doesn't exist */
	if (ret == TDX_METADATA_FIELD_ID_INCORRECT) {
		*data = 0;
		return 0;
	}

	...

	/* Real reading error */
	return -EFAULT;
  }

The trustness doesn't change no matter how kernel retrieves these data,
by a series of RD or a RDALL.

Thanks,
Yilun

> future (for example at the time of the other optional metadata), we
> actually need to start the process now.

