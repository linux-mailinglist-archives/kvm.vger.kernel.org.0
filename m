Return-Path: <kvm+bounces-30155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B2539B7745
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 10:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BDDF1C22023
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 09:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A003194C62;
	Thu, 31 Oct 2024 09:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JmqRqo0j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B5A2AE9A;
	Thu, 31 Oct 2024 09:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730366318; cv=none; b=sHeP3jkpzQ5xaA9/pN8eAH5UxYYmRHAaOJsvPdeysLSiDnaAsUAWAE0nD0WoVuDO4ZmWJrP1bTWCzsOo8vUMDgjxotFFJ6nvcKtQ4oHdF/6ErBN8rNo4YU7LOu1Sl6fzk8v8RII0jtH1ZKY+0d0+VM1OHF/d0Rzd8s7roBfbtpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730366318; c=relaxed/simple;
	bh=nnZoIkjjw622a2YDeEvJHG5nJHoFJjgwKOcayU0QwJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q38NYrSBdDUmDSZf0qN3XCtClFNzObynsNzcYbkuzV9GL0dQMmiXn/rxkew5ipGQXgTh07nfAnYv4vmm+iBZZgzLKLxG04XDuSJmhIKH4zMqzs5GujoWrA7Yl8+/C+Xs+9ygtyHB6GxbTcAzYHJgUx4hA4AXWuHYJj+puF8flWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JmqRqo0j; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730366316; x=1761902316;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nnZoIkjjw622a2YDeEvJHG5nJHoFJjgwKOcayU0QwJ8=;
  b=JmqRqo0j/RyoFvmhb+m4oxqvcLMaZUDo+mxTcxwalyFA37gBu/WKp8UJ
   t/D84NQ2iiJQTw02tPNDg3X3g9LCNwroI7TtBJchcAsWBRMj1xoZZ8eDT
   kbk5t8IY1x5IctiD8md/xWRdo+ic63xmTbRR2I5HDFTm0i3P0jWaaIlC1
   IbAW0eMqX09rsceN41uA0PPjOedGTwlbCR+gvys/ButEkbPupo5K48xXX
   TFslgbrHqfzxvvkiTZuaZltI3GCvgRvt1StTcpzhCjBuFwmHpxQSXnDIs
   fUjGjoLxAOMtdNf+3G302h/UnuXgM6H0nskhYfUzCr+ovY1d+7DzUAdpO
   g==;
X-CSE-ConnectionGUID: zlEWCq5IRf+6/Dmqh0F3zQ==
X-CSE-MsgGUID: FyilTmL8R/69k16s3tYhkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="34024457"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="34024457"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 02:18:35 -0700
X-CSE-ConnectionGUID: uI5x9iQDRFK+YhxxJSnFPw==
X-CSE-MsgGUID: /tj7/2fgRyysA9IXUGOEiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="82999572"
Received: from slindbla-desk.ger.corp.intel.com (HELO localhost) ([10.245.246.164])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 02:18:32 -0700
Date: Thu, 31 Oct 2024 11:18:27 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, yan.y.zhao@intel.com, isaku.yamahata@gmail.com,
	kai.huang@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 16/25] KVM: TDX: Get system-wide info about TDX module
 on initialization
Message-ID: <ZyNLYxNlD4WTABvq@tlindgre-MOBL1>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-17-rick.p.edgecombe@intel.com>
 <88ea52ea-df9f-45d6-9022-db4313c324e2@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88ea52ea-df9f-45d6-9022-db4313c324e2@linux.intel.com>

On Thu, Oct 31, 2024 at 05:09:17PM +0800, Binbin Wu wrote:
> 
> 
> 
> On 10/31/2024 3:00 AM, Rick Edgecombe wrote:
> [...]
> > +static u32 tdx_set_guest_phys_addr_bits(const u32 eax, int addr_bits)
> > +{
> > +	return (eax & ~GENMASK(23, 16)) | (addr_bits & 0xff) << 16;
> > +}
> > +
> > +#define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
> > +
> > +static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char idx)
> > +{
> > +	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
> > +
> > +	entry->function = (u32)td_conf->cpuid_config_leaves[idx];
> > +	entry->index = td_conf->cpuid_config_leaves[idx] >> 32;
> > +	entry->eax = (u32)td_conf->cpuid_config_values[idx][0];
> > +	entry->ebx = td_conf->cpuid_config_values[idx][0] >> 32;
> > +	entry->ecx = (u32)td_conf->cpuid_config_values[idx][1];
> > +	entry->edx = td_conf->cpuid_config_values[idx][1] >> 32;
> > +
> > +	if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF)
> > +		entry->index = 0;
> > +
> > +	/* Work around missing support on old TDX modules */
> > +	if (entry->function == 0x80000008)
> > +		entry->eax = tdx_set_guest_phys_addr_bits(entry->eax, 0xff);
> Is it necessary to set bit 16~23 to 0xff?
> It seems that when userspace wants to retrieve the value, the GPAW will
> be set in tdx_read_cpuid() anyway.

Leaving it out currently produces:

qemu-system-x86_64: KVM_TDX_INIT_VM failed: Invalid argument

Regards,

Tony

