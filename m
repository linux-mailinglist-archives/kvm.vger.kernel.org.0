Return-Path: <kvm+bounces-49847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51A2EADEA60
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE7D97AE6BA
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 722A02EA729;
	Wed, 18 Jun 2025 11:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y8j0QseC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC912BEC21;
	Wed, 18 Jun 2025 11:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246331; cv=none; b=E2jk0GsG455E5U/t98Iv2KSr9l0OIz1YbC9ohg4nFMJ/qvw7bVXu1l3510uVIBJdMBYzbMXOJFKJLFmYh/zCGsCko+tBsZMU5IMuc5aVOMCm+1dnLQyKmKWWnx7hluht0gFv69DXN1wE/58VRKFv5lUtX2HSTDLrBNrcDr8r2PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246331; c=relaxed/simple;
	bh=1Q62XCd+mKVDENxAu1dlLXxpwURTSGhH8mlqrTlw7rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WCoWsTTB0ZHL+pSl+14Zu6gdrT6yWZpXpt6YaWKz72ZaeL1RvOpPEZegNNlFkg6GV7XofseXOTaP0ILxl6eECx4MhkRt9Iz1XPJiNGS2IAQSkzVuOp0WJPvayW2kA9FlTpr+IS0xUwTs0YItCG1ZpsyeaVlDaCiHTqa6ALOzmqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y8j0QseC; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750246330; x=1781782330;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1Q62XCd+mKVDENxAu1dlLXxpwURTSGhH8mlqrTlw7rU=;
  b=Y8j0QseCNDE2OHsagCdIoVm4rMrXOM9LaV4waJ/2AGnTSPa0IdZ6PgAO
   1+aHea9AoaRmd643fSZd0pPyjrJbMaR2IP0hhItc8QEzI28mCucvKM85X
   0/Zq09MPmq4QULpnTOhVQ+5RC4Ant4kJ2ihMEYbMd/saPFwlD1im+GJ89
   gHwM5wSSanW7BygurMNKhRn9EsNX5ANrarW7TuMGeNISowuF4Z5qy6uDk
   QevIr37Xmc8eqSTWJuou+Pjhtrl7WKtuOl8tWSb/Ip86d7iattqQ+ebbk
   czWzF7uy03hGS24O7zVrAdqg8F3CW1eWt2L0GllbWo5RgjTTNRceuE0hA
   Q==;
X-CSE-ConnectionGUID: Wloct7wmRmOjvic/HDE5Gw==
X-CSE-MsgGUID: UEnTY+D8TXae8p8+6uLw+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="62735794"
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="62735794"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 04:32:10 -0700
X-CSE-ConnectionGUID: XAJqijlFS+W7awRLDilDvA==
X-CSE-MsgGUID: 1Y82ZDqoRiSya2JPRLt0cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="149314915"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa007.fm.intel.com with ESMTP; 18 Jun 2025 04:32:04 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 36FB815B; Wed, 18 Jun 2025 14:32:02 +0300 (EEST)
Date: Wed, 18 Jun 2025 14:32:02 +0300
From: "Shutemov, Kirill" <kirill.shutemov@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com" <tabba@google.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <t6z42jxmbskbtiruoz2hj67d7dwffu6sgpsfcvkwl6mpysgx2b@5ssfh35xckyr>
References: <aEt0ZxzvXngfplmN@google.com>
 <4737093ef45856b7c1c36398ee3d417d2a636c0c.camel@intel.com>
 <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
 <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
 <aEyj_5WoC-01SPsV@google.com>
 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
 <803d857f730e205f0611ec97da449a9cf98e4ffb.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <803d857f730e205f0611ec97da449a9cf98e4ffb.camel@intel.com>

On Wed, Jun 18, 2025 at 04:22:59AM +0300, Edgecombe, Rick P wrote:
> On Tue, 2025-06-17 at 08:52 +0800, Yan Zhao wrote:
> > > hopefully is just handling accepting a whole range that is not 2MB aligned.
> > > But
> > > I think we need to verify this more.
> > Ok.
> 
> In Linux guest if a memory region is not 2MB aligned the guest will accept the
> ends at 4k size. If a memory region is identical to a memslot range this will be
> fine. KVM will map the ends at 4k because it won't let huge pages span a
> memslot. But if several memory regions are not 2MB aligned and are covered by
> one large memslot, the accept will fail on the 4k ends under this proposal. I
> don't know if this is a common configuration, but to cover it in the TDX guest
> may not be trivial.
> 
> So I think this will only work if guests can reasonably "merge" all of the
> adjacent accepts. Or of we declare a bunch of memory/memslot layouts illegal.
> 
> Kirill, how difficult would it be for TDX Linux guest to merge all 2MB adjacent
> accepts?

Hm. What do you mean by merging?

Kernel only accepts <4k during early boot -- in EFI stub. The bitmap we
use to track unaccepted memory tracks the status in 2M granularity and
all later accept requests will be issues on 2M pages with fallback to 4k.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

