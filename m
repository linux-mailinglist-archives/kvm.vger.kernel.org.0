Return-Path: <kvm+bounces-13345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5221E894BDC
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 08:53:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6614282CAD
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 06:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5C1A3308A;
	Tue,  2 Apr 2024 06:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gc52YStr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D33B2C689;
	Tue,  2 Apr 2024 06:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712040778; cv=none; b=QkmIxn2zOH8OmQN0XRyO1B7/8aplc2Hmp2ghO0KzOGmF7OsiKsJV9JM07wOsiQCwD5rcceyqXMPvNeni4dSnPWBW1uL6rW5DFznE2t1AY2dvQdNS90pzlXp1d5sbOkqPFWxQoN2xnb/1bFMCAaSq7kO5zwfld0UUVxVFrzbMkCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712040778; c=relaxed/simple;
	bh=8U+o5ZPPyeR6k/u71wLfHh1u9kvqRkSFl8fCN0tDQ0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sisbg8bK/xwsuZNbhfnXdVv5EcSw3xHiDebjj4hwjn7CoCRWCOX80p96cdxR95H21Oj3G5fv/B/ye+5Fu1zgW5VDF3jxjWGzXJOwoQzqP20kgvwhMb8NzbH1TmSoTJM6Et62BA1UsAdrl+ZgxX4Aiufb2zGsq8Al4LX9tFvNj7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gc52YStr; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712040775; x=1743576775;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8U+o5ZPPyeR6k/u71wLfHh1u9kvqRkSFl8fCN0tDQ0s=;
  b=Gc52YStrdzIIIEeUgDrpxBK8ktSVfvANZCcH9jlco4zGRv+WnLXRtVaB
   4JFrYdxwvwhisChcYrACnLgNyQOF6/2xzO/qi01zkK6gj0YVPDGRyajSW
   xahiHX4mfSadQRHwKtCqk+dH+dF4XBRweOKDHQXam2m5lj22oHb57WC6V
   IQKl3iT5DiHVoD77z0IHw8uFmgJ5dvYyCws3g8TnKvQJyxubjf6BRHxpr
   y9KKgNAoDs9JWFZmCAYc5a2ZZe+vQVV7uRl75qnv0ZGb4cL7oeYPxhQDK
   cBIwq1YHDetanHVf05Ukik9IXKPdnC3Mem36vScgwe7LRU4HRTcTkLb7S
   Q==;
X-CSE-ConnectionGUID: uleWtztsRvac2Q32WZWFEQ==
X-CSE-MsgGUID: 5XhIILKkQZy15smCwQVA+w==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="7095788"
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="7095788"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:52:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="22409021"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:52:54 -0700
Date: Mon, 1 Apr 2024 23:52:54 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 093/130] KVM: TDX: Implements vcpu
 request_immediate_exit
Message-ID: <20240402065254.GY2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <3fd2824a8f77412476b58155776e88dfe84a8c73.1708933498.git.isaku.yamahata@intel.com>
 <ZgYfPAPToxbgGZLp@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZgYfPAPToxbgGZLp@chao-email>

On Fri, Mar 29, 2024 at 09:54:04AM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Mon, Feb 26, 2024 at 12:26:35AM -0800, isaku.yamahata@intel.com wrote:
> >From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> >Now we are able to inject interrupts into TDX vcpu, it's ready to block TDX
> >vcpu.  Wire up kvm x86 methods for blocking/unblocking vcpu for TDX.  To
> >unblock on pending events, request immediate exit methods is also needed.
> 
> TDX doesn't support this immediate exit. It is considered as a potential
> attack to TDs. TDX module deploys 0/1-step mitigations to prevent this.
> Even KVM issues a self-IPI before TD-entry, TD-exit will happen after
> the guest runs a random number of instructions.
> 
> KVM shouldn't request immediate exits in the first place. Just emit a
> warning if KVM tries to do this.

0ec3d6d1f169
("KVM: x86: Fully defer to vendor code to decide how to force immediate exit")
removed the hook.  This patch will be dropped and tdx_vcpu_run() will ignore
force_immediate_exit.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

