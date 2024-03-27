Return-Path: <kvm+bounces-12748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 30C5488D564
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 05:15:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 72AF7B2241C
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 04:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6717249ED;
	Wed, 27 Mar 2024 04:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q5bA11QD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA041F606;
	Wed, 27 Mar 2024 04:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711512923; cv=none; b=uNQzGXlRxZ13T+80uYNY5sNPTlWmeY6j44Oz0E4y5m74mTicQr/Rn7Vq/Pk+4Hdwrtn/MwBadwIZGWFIJ75dKqsdVEoW+aZt+VNUtZRglSq0cNNGeVOuOvJRtTl6Tu4GUOY4yN296cXcBJOUCLgLUmQfRksplRRttDmTVAKGwT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711512923; c=relaxed/simple;
	bh=qB/KEL44AGHMfXjIlk8PCDDNe1jhwM4n+f9N6et7kDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kkXASn+W3GdcS/ojxpF5Eotf2ctiArkQ03+hcy6Obe1IQuyFcF+RkKoxwIgnUrj3JCEFUu6LWv/lIrefyxul0G6Z/kYpMGVmNVRw4uz4UXgC/TiS2lhjX46qF+6nlV/kyoibVddf784lZanc0BzmeMoCniJ3uuJh2ujrieK4nLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q5bA11QD; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711512921; x=1743048921;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qB/KEL44AGHMfXjIlk8PCDDNe1jhwM4n+f9N6et7kDk=;
  b=Q5bA11QDEUFWH1u5KsRUPxC9bVhhXyVjqhb5f7K66TVriSXnhRatwg1K
   MWgjajyeLlEJqTgu13aEBjx+QC9KyFinc6KLfo3t8oCRdL43ImTKPlF02
   HwwhjdR1YS4Sspcfb0nm53e/KSQTSN8oe147x4F/D0MHaEuIdKvd7Rda7
   8OdDIZcYAIR737XVC/CkaU2kiv3+giCnZKdCuvWpBLqwRU9LSiZvy0Gje
   xHArvJtzn5P9F8lk6wkymJ5ogNEh177J9oBKbSrsd6lydlfNhZ5WxkZQd
   1xbgRXslZ1/xPjZPLgc059iHX5y/jpt5McKGmJtVnXX22+o0aN+NKniwU
   A==;
X-CSE-ConnectionGUID: RPj1Og3HSHesU9lzgFkQ9A==
X-CSE-MsgGUID: XktGjLIJSjOugUKM/MDRmg==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="6457968"
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="6457968"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 21:15:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="20891413"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 21:15:19 -0700
Date: Tue, 26 Mar 2024 21:15:19 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Yin, Fengwei" <fengwei.yin@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v8 00/14] KVM TDX: TDP MMU: large page support
Message-ID: <20240327041519.GD2444378@ls.amr.corp.intel.com>
References: <cover.1708933624.git.isaku.yamahata@intel.com>
 <8f7735aa-517f-4bb3-8e33-d58a27c2a822@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8f7735aa-517f-4bb3-8e33-d58a27c2a822@intel.com>

On Wed, Mar 27, 2024 at 08:53:50AM +0800,
"Yin, Fengwei" <fengwei.yin@intel.com> wrote:

> Hi Isaku,
> 
> On 2/26/2024 4:29 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > This patch series is based on "v19 KVM TDX: basic feature support".  It
> > implements large page support for TDP MMU by allowing populating of the large
> > page and splitting it when necessary.
> To test the hugepage for TDX guest, we need to apply Qemu patch
> from Xiaoyao:
> https://lore.kernel.org/qemu-devel/20231115071519.2864957-4-xiaoyao.li@intel.com/
> 
> According to Xiaoyao, it's still under discussion. So he didn't
> send updated version patch. For folks want to try this series,
> it may be better to mention above link in this cover letter?

Makes sense.  Let me include it from the next versions.


> Test in my side showed several benchmarks got 10+% performance
> gain which is really nice. So:

So nice.

> Tested-by: Yin Fengwei <fengwei.yin@intel.com>

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

