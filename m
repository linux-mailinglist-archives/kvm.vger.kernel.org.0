Return-Path: <kvm+bounces-12914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C398688F369
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05238298833
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14C7CBE55;
	Thu, 28 Mar 2024 00:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YCZfPsFH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAAF8BE2;
	Thu, 28 Mar 2024 00:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711584378; cv=none; b=T6rm55V31RvQWm7PC17T0fxnSx4NmDq9mbJTinQigfE7kGBHiFLFBPxON1KrAx/Ki7VzRorgft0xFwwDaijpgZJriuVu89YrvPwbJy07kwNe+E6HroQQ3/apaP9lf2uxtd/a2aRLUVqR1TImizjUgweTlqlUC2WH8l5Xr/hFvr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711584378; c=relaxed/simple;
	bh=pRLS2DCZN5I+ZZ+IhNPfBauVbFYzP3ERVdibBb6qDKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A32DfR0gKMW+qfzLqkiduxA+r5W7mjv9HghnaCrxFulFaTP8k1pCfsCFYj6EMbr2rn3xA+AGFQu4UtIP7sGc6T6x1WqTgsJ9SfRxy8MMhkFxENExtIa8m5YT31a+42mQ5lmoOycJw3/3f46Uggw3wxuiyjSFA2mgTkDUjmpkD6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YCZfPsFH; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711584376; x=1743120376;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=pRLS2DCZN5I+ZZ+IhNPfBauVbFYzP3ERVdibBb6qDKg=;
  b=YCZfPsFHqEXsKue0K8aOEz9Ec4U+C33pNR49wRdkX/06epCsvJRUdgqr
   L4zQcar7blz/QhEsiJVu7zsuZ2YDC/tYnW+xsakU5Z68uNZk5Rngwm6h3
   sbPXMZl//PKCXm7GnQZkhQQOEC4coejggZRIochGjeMKZXtcnVebewMDX
   J7kd2XQoHkSXAurGxmGSWgPXj0t6fauUCCR/Ave5lwah0PbZH6aGs9ets
   FjeDW8G7krd+cJISq5waC6kYovKe3ufUjs0Uafx5yXz9ZNYuh6FFObXhk
   8xuWHQ4fGQv3DRPkJEsdP5wO9fjGfXUg/sQs6hc+e1XfWWZYPsqFUsXEo
   Q==;
X-CSE-ConnectionGUID: zqCg8kZlSXaHZ6INnZ3ihQ==
X-CSE-MsgGUID: 27JB/c6zTOiUXmiIVBaWRg==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6937198"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6937198"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:06:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16406929"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:06:15 -0700
Date: Wed, 27 Mar 2024 17:06:14 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <20240328000614.GK2444378@ls.amr.corp.intel.com>
References: <20240325221836.GO2357401@ls.amr.corp.intel.com>
 <20240325231058.GP2357401@ls.amr.corp.intel.com>
 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
 <ZgIzvHKobT2K8LZb@chao-email>
 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
 <ZgKt6ljcmnfSbqG/@chao-email>
 <20240326174859.GB2444378@ls.amr.corp.intel.com>
 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
 <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>

On Wed, Mar 27, 2024 at 05:36:07PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Wed, 2024-03-27 at 10:54 +0800, Xiaoyao Li wrote:
> > > > If QEMU doesn't configure the msr filter list correctly, KVM has to handle
> > > > guest's MTRR MSR accesses. In my understanding, the suggestion is KVM zap
> > > > private memory mappings. But guests won't accept memory again because no one
> > > > currently requests guests to do this after writes to MTRR MSRs. In this case,
> > > > guests may access unaccepted memory, causing infinite EPT violation loop
> > > > (assume SEPT_VE_DISABLE is set). This won't impact other guests/workloads on
> > > > the host. But I think it would be better if we can avoid wasting CPU resource
> > > > on the useless EPT violation loop.
> > > 
> > > Qemu is expected to do it correctly.  There are manyways for userspace to go
> > > wrong.  This isn't specific to MTRR MSR.
> > 
> > This seems incorrect. KVM shouldn't force userspace to filter some 
> > specific MSRs. The semantic of MSR filter is userspace configures it on 
> > its own will, not KVM requires to do so.
> 
> I'm ok just always doing the exit to userspace on attempt to use MTRRs in a TD, and not rely on the
> MSR list. At least I don't see the problem.

KVM doesn't force it.  KVM allows QEMU to use the MSR filter for TDX.
(v19 doesn't allow it.) If QEMU chooses to use the MSR filter, QEMU has to
handle the MSR access correctly.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

