Return-Path: <kvm+bounces-12626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1444188B361
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 23:05:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C00D630561F
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D827175F;
	Mon, 25 Mar 2024 22:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZyX6lYvU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187F56D1C8;
	Mon, 25 Mar 2024 22:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404301; cv=none; b=KDgQSqid7tIrG+gNlp1zT2jjZj9pL3eVH7PU/8t+lfN2hngcKa8M/mCA8lMAw5NgwnvudBycBTXrjY+aXfy2LV9E3+sXp0Yi6AAfmwC9/BcHIFCJaKF6KblZQ0WWnVWainT0wZOJSgBt3Dwt/crU3GxrBLWhZL3OA2yxNqToDbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404301; c=relaxed/simple;
	bh=+ovNKGBLi1gXj1YmUYOIgIN0QJaeJZCivM4A+DNQztk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npuioVY/Z9gyVgcl0uHGkTgkEZpjmJ2Xkf80k7L3nwjSmyR6MWpC16d8alImk3qNaltwOiFG0OxFHzZkORC6YYBrhp2uHxKl70nlU9bLjCjKX6vbeWk3ZOVrJaL5SKpK/OJbwTcBhMZX3zu6LksPL8/Z0lfPwLigjKjlGXNHn0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZyX6lYvU; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711404299; x=1742940299;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+ovNKGBLi1gXj1YmUYOIgIN0QJaeJZCivM4A+DNQztk=;
  b=ZyX6lYvUjE851fFzzkwZAqpTAhonAWVuvhjXJ4OjFtyMD5tIlXwbb9Uw
   M4ISFQL8RuEjzLXIFAuJybNAjV+y30jdV0v3USn4tmmU3OlpmOOYqwU73
   4Vcr5o1xNpJrJFAj62iRXdCxymFo7Fo7HgBwQXG7c+TMEM2NXNvsKpv+n
   7LPge4M60oY1N20B/j6rBYrga1D+0Odo9DsCcJeXYR0xovh5Ni+o4/3ch
   zjgVO7e0N69uqlKxzDnXeEUsUrmX0VjNFpxWY7lzciE/52IdB1kSC9XeM
   QcAfB7+2OuB2Mwb77ugJD4pBOdnuIxu1X1Y/dPka3THRg3pjDd1rEin9U
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="6561311"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="6561311"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 15:04:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="20222690"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 15:04:58 -0700
Date: Mon, 25 Mar 2024 15:04:57 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20240325220457.GN2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <5f0c798cf242bafe9810556f711b703e9efec304.camel@intel.com>
 <20240323012224.GD2357401@ls.amr.corp.intel.com>
 <59fbe690d1765337b4b1785b4cef900415bd5df2.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <59fbe690d1765337b4b1785b4cef900415bd5df2.camel@intel.com>

On Mon, Mar 25, 2024 at 10:39:10AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Fri, 2024-03-22 at 18:22 -0700, Yamahata, Isaku wrote:
> > On Fri, Mar 22, 2024 at 11:20:01AM +0000,
> > "Huang, Kai" <kai.huang@intel.com> wrote:
> > 
> > > On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > > > +struct kvm_tdx_init_vm {
> > > > +	__u64 attributes;
> > > > +	__u64 mrconfigid[6];	/* sha384 digest */
> > > > +	__u64 mrowner[6];	/* sha384 digest */
> > > > +	__u64 mrownerconfig[6];	/* sha384 digest */
> > > > +	/*
> > > > +	 * For future extensibility to make sizeof(struct kvm_tdx_init_vm) = 8KB.
> > > > +	 * This should be enough given sizeof(TD_PARAMS) = 1024.
> > > > +	 * 8KB was chosen given because
> > > > +	 * sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES(=256) = 8KB.
> > > > +	 */
> > > > +	__u64 reserved[1004];
> > > 
> > > This is insane.
> > > 
> > > You said you want to reserve 8K for CPUID entries, but how can these 1004 * 8
> > > bytes be used for CPUID entries since ...
> > 
> > I tried to overestimate it. It's too much, how about to make it
> > 1024, reserved[109]?
> > 
> 
> I am not sure why we need 1024B either.
> 
> IIUC, the inputs here in 'kvm_tdx_init_vm' should be a subset of the members in
> TD_PARAMS.  This IOCTL() isn't intended to carry any additional input besides
> these defined in TD_PARAMS, right?
> 
> If so, then it seems to me you "at most" only need to reserve the space for the
> members excluding the CPUID entries, because for the CPUID entries we will
> always pass them as a flexible array at the end of the structure.
> 
> Based on the spec, the "non-CPUID-entry" part only occupies 256 bytes.  To me it
> seems we have no reason to reserve more space than 256 bytes.

Ok, I'll make it 256 bytes.

The alternative is to use key-value.  The user space loops to set all necessary
parameters.  Something like as follows.

KVM_TDX_SET_VM_PARAM

struct kvm_tdx_vm_param {
        /* TDCS metadata field. */
        __u64 field_id;
        /*
         * value for attributes or data less or qeual to __u64.
         * pointer for sha384, cpuid, or data larger than __u64.
         */
        __u64 value_or_ptr;
};
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

