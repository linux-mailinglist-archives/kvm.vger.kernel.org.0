Return-Path: <kvm+bounces-14795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26DBD8A7158
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:28:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57DE91C218B1
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58760132493;
	Tue, 16 Apr 2024 16:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FH+yTqMC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7500F43AA5;
	Tue, 16 Apr 2024 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713284913; cv=none; b=s98UsKO0O7L8fmn0P9J9bA0D7cjmNSpvJH7ksXP8ohpIxvfhoG6hSSgtpJvwEjcCPHVe5S2zo989TTySVXJ+gdBp5CAYKN7PMDffyZicTsfAjBFn9hfphZCYGQdHRcDdE0VhbnFayUXWi7x/HiHPwflJCeLe2JgwatFr0T3eQGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713284913; c=relaxed/simple;
	bh=T/abZooFugAj5fz0p2vl9vQhNez0p7OvvM+rxDxJ2ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hDqXKMIR/eiptbWtCRAxcRCkhLd0jGr8Gce2crBdsVmFhS1FRmSU+CRtU9uz1GxcS5PrnxRGeWQSGqiLI6OrLZ5Y8g8Rc3zyMwIkrBb7u0yUfetoG1nodu351LRQc0gEVaoDT1Jin4nrqNW/jep4YO7job7BP0na5sfkBndzmsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FH+yTqMC; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713284912; x=1744820912;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T/abZooFugAj5fz0p2vl9vQhNez0p7OvvM+rxDxJ2ac=;
  b=FH+yTqMCDvf8koO7XPBGBsxwKMrjuxaaJO/BwpmzYkQcYFYjIZWBGrQA
   9M1Ra+YUhKT3mZuKUUjy34t61kkEX14bhSMlB8ifpFw12iTTLM3gS9+HW
   tT9UWRL4B07dtP97NFlEVwAZoMxOPl8Dr0UP5WLHUqISUIgEMrQYLwEz7
   ZxCEJpqTj8uZ9b6y2LcWgU5D/kQBnZ8HIaDMVIv5XmyXffOErcmHK9fLs
   HywKaTEhFE8DM2+I2I9p4OPAavT1vvBaOyMm3w+/3VrrE0PL0ADfY5lZT
   PCLK8OtEIoKY3ICTGG3dNME5Q9cxM6Gbles1Anfv4IIvueuH4ASqisWB5
   g==;
X-CSE-ConnectionGUID: nuVlL5YyTkW9qR9EFMHXRQ==
X-CSE-MsgGUID: BPBa/PxVRauZUJnK9DCcuQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19340694"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="19340694"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 09:28:30 -0700
X-CSE-ConnectionGUID: ybFrKtxWSpC4MSyQ4EzKyQ==
X-CSE-MsgGUID: 3nxJX9YSRPaX5zL3yFj1wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="22384243"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 09:28:30 -0700
Date: Tue, 16 Apr 2024 09:28:29 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v19 027/130] KVM: TDX: Define TDX architectural
 definitions
Message-ID: <20240416162829.GX3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
 <ZeGC64sAzg4EN3G5@yzhao56-desk.sh.intel.com>
 <20240305082138.GD10568@ls.amr.corp.intel.com>
 <34d64c12-9ed5-4c63-8465-29f7fdce20dc@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <34d64c12-9ed5-4c63-8465-29f7fdce20dc@intel.com>

On Tue, Apr 16, 2024 at 12:55:33PM +1200,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> 
> On 5/03/2024 9:21 pm, Isaku Yamahata wrote:
> > On Fri, Mar 01, 2024 at 03:25:31PM +0800,
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > 
> > > > + * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
> > > > + */
> > > > +#define TDX_MAX_VCPUS	(~(u16)0)
> > > This value will be treated as -1 in tdx_vm_init(),
> > > 	"kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);"
> > > 
> > > This will lead to kvm->max_vcpus being -1 by default.
> > > Is this by design or just an error?
> > > If it's by design, why not set kvm->max_vcpus = -1 in tdx_vm_init() directly.
> > > If an unexpected error, may below is better?
> > > 
> > > #define TDX_MAX_VCPUS   (int)((u16)(~0UL))
> > > or
> > > #define TDX_MAX_VCPUS 65536
> > 
> > You're right. I'll use ((int)U16_MAX).
> > As TDX 1.5 introduced metadata MAX_VCPUS_PER_TD, I'll update to get the value
> > and trim it further. Something following.
> > 
> 
> [...]
> 
> > +	u16 max_vcpus_per_td;
> > +
> 
> [...]
> 
> > -	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
> > +	kvm->max_vcpus = min3(kvm->max_vcpus, tdx_info->max_vcpus_per_td,
> > +			     TDX_MAX_VCPUS);
> 
> [...]
> 
> > -#define TDX_MAX_VCPUS	(~(u16)0)
> > +#define TDX_MAX_VCPUS	((int)U16_MAX)
> 
> Why do you even need TDX_MAX_VCPUS, given it cannot exceed U16_MAX and you
> will have the 'u16 max_vcpus_per_td' anyway?
> 
> IIUC, in KVM_ENABLE_CAP(KVM_CAP_MAX_VCPUS), we can overwrite the
> kvm->max_vcpus to the 'max_vcpus' provided by the userspace, and make sure
> it doesn't exceed tdx_info->max_vcpus_per_td.
> 
> Anything I am missing?

With the latest TDX 1.5 module, we don't need TDX_MAX_VCPUS.

The metadata MD_FIELD_ID_MAX_VCPUS_PER_TD was introduced at the middle version
of TDX 1.5. (I don't remember the exact version.), the logic was something
like as follows.  Now if we fail to read the metadata, disable TDX.

read metadata MD_FIELD_ID_MAX_VCPUS_PER_TD;
if success
  tdx_info->max_vcpu_per_td = the value read metadata
else
  tdx_info->max_vcpu_per_td = TDX_MAX_VCPUS;

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

