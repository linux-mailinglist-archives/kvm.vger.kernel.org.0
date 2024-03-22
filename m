Return-Path: <kvm+bounces-12535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0288875BF
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 00:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BF56B213B9
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 23:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA1782C7E;
	Fri, 22 Mar 2024 23:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ILgiJ2yP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DBD82877;
	Fri, 22 Mar 2024 23:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711150001; cv=none; b=WyPoJDoKeG/Qz1//fApZUPcsw3odMbNgPGfr0A5IiFkokdvsr3d97hO4FZIhDtsvh74i8AkX5EE3ncW/s6a+IyM8N1t2KcSC6xK6bhKE3rSmqD70yy8W+O32wKNC9USpcuKhFdK56yUS0ezesFOlWkc5wDIB2JeQe2d58f1qNes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711150001; c=relaxed/simple;
	bh=yxAt4+KnvSCgWnlDrI9SBPijyXg/Hs6sJq0WjHy72Zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZX7/RhpeMaHjxcKmWifWESmrMStjREomkhSjy47SXS1Fkk+8usBX8hOwZV9WCUqfgnxL4qwKw/LkcsIbGkMsQwDNlGEz2g5N5XGP3OpI0eM0FDX2HxA37IHRJ3VHKmCd2Lsw943hZfb041E/Gz3Tf26BDlwlG+BPg+Bl8VcaZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ILgiJ2yP; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711150000; x=1742686000;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yxAt4+KnvSCgWnlDrI9SBPijyXg/Hs6sJq0WjHy72Zc=;
  b=ILgiJ2yPI94p4p9Su+zRogBllfaGzWe/MU8xsxFUeeg4x+mulIpR/Fr8
   9aCm9J+Qhjek4yn1E3zlzWhgRjQ7W7kg2JcEt1rsBlY4AFHUI3KgX+H0C
   BT+cfGeHgmwAf249jMPJPEdbYjZYwBUZPQG45rAPmzhmrK8ya7Ni+oDHf
   ZinGXUi2z9QXHLe/KBA0qPkveJsuHL8B5WEI7lNKOyeTv0IIf1ybMHfe9
   RNYFtA0zBd0MTK8Mhw9iZnOIIKAPCZ+69t6vR8tEoKCyswOB+2HltvdUE
   eyUAi18nDZ4bLsMn0VhPANG2m+s5qPdUu3xoMD9ZRo1fI35yu7qQuLXlw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="6116775"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="6116775"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 16:26:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="15121586"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 16:26:38 -0700
Date: Fri, 22 Mar 2024 16:26:38 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yao, Yuan" <yuan.yao@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Message-ID: <20240322232638.GF1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
 <579cb765-8a5e-4058-bc1d-9de7ac4b95d1@intel.com>
 <20240320213600.GI1994522@ls.amr.corp.intel.com>
 <46638b78-eb75-4ab4-af7e-b3cad0d00d7b@intel.com>
 <20240322001652.GW1994522@ls.amr.corp.intel.com>
 <5f8aaa652cc112fc61b9b13b6d77b998a2461172.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5f8aaa652cc112fc61b9b13b6d77b998a2461172.camel@intel.com>

On Fri, Mar 22, 2024 at 04:33:21AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > > 
> > > So how about we have some macros:
> > > 
> > > static inline bool is_seamcall_err_kernel_defined(u64 err)
> > > {
> > > 	return err & TDX_SW_ERROR;
> > > }
> > > 
> > > #define TDX_KVM_SEAMCALL(_kvm, _seamcall_func, _fn, _args)	\
> > > 	({				\
> > > 		u64 _ret = _seamcall_func(_fn, _args);
> > > 		KVM_BUG_ON(_kvm, is_seamcall_err_kernel_defined(_ret));
> > > 		_ret;
> > > 	})
> > 
> > As we can move out KVM_BUG_ON() to the call site, we can simply have
> > seamcall() or seamcall_ret().
> > The call site has to check error. whether it is TDX_SW_ERROR or not.
> > And if it hit the unexpected error, it will mark the guest bugged.
> 
> How many call sites are we talking about?
> 
> I think handling KVM_BUG_ON() in macro should be able to eliminate bunch of
> individual KVM_BUG_ON()s in these call sites?

16: custom error check is needed
6: always error

So I'd like to consistently have error check in KVM code, not in macro or
wrapper.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

