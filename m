Return-Path: <kvm+bounces-2170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 610707F29BA
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 11:04:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD0C3B21137
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 10:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA4503C6AA;
	Tue, 21 Nov 2023 10:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I4u0HnMQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EEFF5;
	Tue, 21 Nov 2023 02:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700561070; x=1732097070;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8gnQy3DoUBVgZgIiqzEiYYxsRhdFMGruPTOBwuYMfzo=;
  b=I4u0HnMQTlw4HC94zXwdobiAT4g/1y/y4fEkq3B8NEJ1MKxz8AgVGGcA
   WUowDY4GQsZsFdOrGI7bXRyHM7Io3yIWP0BVdBh1BHuRtDp3azu4cSW1n
   YZrx/lkyEqX0gTlat7TS6T6asJUBynJ5CF50BHur0F4sZ99ax/dABXOYU
   qTYrdOWpTKaJZ7jCtI925UfqSlaFjRd6lJ0+Kb1w7TCyv2Am9l//V9aIM
   u3i1AzYYOL6Ueef7j63DT2Kw4ne+yguSAG0q2Lc1CtfTq9WQQbtp0aoRx
   9zZ4fXkOzPEBl/7PVMWBkTJecUXsaIiAoXzSf3WfBma0hbkHKnH+nH2gN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="376842924"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="376842924"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 02:04:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="770212819"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="770212819"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 02:04:18 -0800
Date: Tue, 21 Nov 2023 02:04:18 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v6 08/16] KVM: TDX: Pin pages via get_page() right before
 ADD/AUG'ed to TDs
Message-ID: <20231121100418.GF1109547@ls.amr.corp.intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <c8d8b880963cc6799b681f7905a956022e47f16f.1699368363.git.isaku.yamahata@intel.com>
 <c62e8f7e-46ed-47e3-b7ff-231bd1f343e5@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c62e8f7e-46ed-47e3-b7ff-231bd1f343e5@linux.intel.com>

On Mon, Nov 20, 2023 at 07:05:39PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 11/7/2023 11:00 PM, isaku.yamahata@intel.com wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > When kvm_faultin_pfn(), it doesn't have the info regarding which page level
> > will the gfn be mapped at. Hence it doesn't know to pin a 4K page or a
> > 2M page.
> > 
> > Move the guest private pages pinning logic right before
> > TDH_MEM_PAGE_ADD/AUG() since at that time it knows the page level info.
> This patch looks strange, the code has nothing to do with the shortlog.
> It seems that the change of this patch has already been covered by 06/16.
> 
> Something went wrong when formatting the patch?

Oh, right. This patch doesn't make sense any more. I''ll drop this patch.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

