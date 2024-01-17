Return-Path: <kvm+bounces-6375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5248882FFD6
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 06:31:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06AAA1F25E7A
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 05:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E10749C;
	Wed, 17 Jan 2024 05:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eaENUTWW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2648611A;
	Wed, 17 Jan 2024 05:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705469480; cv=none; b=TQepkqsNCbiLnAEE1Z3tP6pSa6OoQA5iMWnKYkWvXfbhvlkAAV5+ukq3ZRrv2F5rVeGWvpeSNY+FhxFuGAsGVkdamSCxdXSaQ48rpx79kbq9n3wJXIfqgYuLXhiprh1InPgM6V+S6RQyKw/TN1DCt+RwWPqB6w/6ImZItk66gKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705469480; c=relaxed/simple;
	bh=S17QIS9EI5/1cfkmtbqBKT9VDRGfC2Wp2/CKgmW+9Sg=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:User-Agent; b=JPxhwmhCIpdmQ1+MH2GOeXr2/GppY9u1CoovPMwuTzHP9ZSUXPS8zt9NwXDk0+nX8lLr89AkpVWEkKjXPdgk0vKs9v6aIsiF43ErHVv5C/cYZ0SPdC2wHtpHmyXB5NosD16epjKl+1uFYstigugWkTz1BMqZMUJU7dqiNxp4c0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eaENUTWW; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705469478; x=1737005478;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S17QIS9EI5/1cfkmtbqBKT9VDRGfC2Wp2/CKgmW+9Sg=;
  b=eaENUTWW5lcqZseUDniKtWiXY59fYQVVMSo7SLoRuUsV/DSXoJA8cAEh
   2Klpq19i9J64wxqgQEKe1XXsaKUt2GKOBsoEdlrfu4Sg2vWncU3ePgl5w
   cE++s+zP8VCg+uISAj2QYfAA3PM8ebTMxhNJyBSwbyaViTvMUe+6kuCXu
   oT1jxtxWdFcBRtO2F2ts+KD7H+VLozkfAFj/mdCb10FkvRqW/9DzYrVFw
   +WtvyXzybH5yX9zvr2WCwgrYc5ewXQtSK0NeQTjnF+eO1Fg8sRjg78hep
   4jsinf4TQZQzGppOFDPCGE08zzQXWxpGRokfl972LbF3XsEkysfUGzdNH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="7167741"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="7167741"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 21:31:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="903413395"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="903413395"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jan 2024 21:31:14 -0800
Date: Wed, 17 Jan 2024 13:31:14 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"Gao, Chao" <chao.gao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"john.allen@amd.com" <john.allen@amd.com>
Subject: Re: [PATCH v8 22/26] KVM: VMX: Set up interception for CET MSRs
Message-ID: <20240117053114.6ykoke6gjp52ehvz@yy-desk-7060>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <20231221140239.4349-23-weijiang.yang@intel.com>
 <20240115095854.s4smn4ppfjfa2q2z@yy-desk-7060>
 <ee2c5c91-68bd-4f78-aafc-c14093f05342@intel.com>
 <26258c1a-2908-4931-8d6f-fac6754ca2e8@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26258c1a-2908-4931-8d6f-fac6754ca2e8@intel.com>
User-Agent: NeoMutt/20171215

On Wed, Jan 17, 2024 at 09:58:40AM +0800, Yang, Weijiang wrote:
> On 1/17/2024 9:41 AM, Yang, Weijiang wrote:
> > On 1/15/2024 5:58 PM, Yuan Yao wrote:
> > > On Thu, Dec 21, 2023 at 09:02:35AM -0500, Yang Weijiang wrote:
> [...]
> > > Looks this leading to MSR_IA32_INT_SSP_TAB not intercepted
> > > after below steps:
> > >
> > > Step 1. User space set cpuid w/  X86_FEATURE_LM, w/  SHSTK.
> > > Step 2. User space set cpuid w/o X86_FEATURE_LM, w/o SHSTK.
> > >
> > > Then MSR_IA32_INT_SSP_TAB won't be intercepted even w/o SHSTK
> > > on guest cpuid, will this lead to inconsistency when do
> > > rdmsr(MSR_IA32_INT_SSP_TAB) from guest in this scenario ?
> > Yes, theoretically it's possible, how about changing it as below?
> >
> > vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
> > 			  MSR_TYPE_RW,
> > 			  incpt | !guest_cpuid_has(vcpu, X86_FEATURE_LM));
> >
> Oops, should be : incpt || !guest_cpuid_has(vcpu, X86_FEATURE_LM)

It means guest cpuid:

"has X86_FEATURE_SHSTK" + "doesn't have X86_FEATURE_LM"

not sure this is valid combination or not.
If yes it's ok, else just relies on incpt is enough ?

