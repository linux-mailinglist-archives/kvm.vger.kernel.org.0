Return-Path: <kvm+bounces-35316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8984DA0C167
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 20:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC9903A3D7F
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 19:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE7C51CAA8C;
	Mon, 13 Jan 2025 19:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dU8pHlto"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEA01B21BC;
	Mon, 13 Jan 2025 19:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736796497; cv=none; b=LVKzQ1zMW9/wm905gOiQhvXoQ92Q8RDM6b7YN1eN/YNpUA9bDQDg74Rdey2Xtvd7E8lAtofnkFqmwl/C1glukn4X6BWjI9Ju9bqn870J2VsIEpmucsoZRbhHQFMjWXhGt6mU1t7j/C1KgHMfFHe9eCX1Q/R4wMyB0v4KDLLrx7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736796497; c=relaxed/simple;
	bh=qK/UqylcwZbg+H1qXrkKeVQEmW/bacTD3dMGwHWzRaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=blmSAphbPNh24XttviH1rnsKeBsg9y38pCkDpYBWpqHjzKCrREaAZjZv2XsO+LYsJ6IQQyhGexnSBCKMehN7I5AqzWxUXaipq6y7ps4vqBn1wSxshPD84rJSdAzTW+JeiluOWOxBRT2r1fx7Oq6RRoh7+KQbkELMRdkAnnkVUIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dU8pHlto; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736796495; x=1768332495;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qK/UqylcwZbg+H1qXrkKeVQEmW/bacTD3dMGwHWzRaE=;
  b=dU8pHltoQI+T2Ai0LcTVgG309RKSmghUQGfE6Xf6YeeG/mb7wzc917gb
   jAIeLap7oFodRPL3eZOmR/gsMvOaL5dl8I8f5KWvMoP1pOTmjEqL793vi
   n8hPy3YDN1Abx8nvdIrogZhAgiXXJWonePLY24Whzs75OXK1AbQsuuBkJ
   7YvuIQ5w+kOBV3AaQMKkyvtELN4nUSI9QyS9jLbKA54WkH1qOX9+ra8bl
   4NYloYw4yfPYDOpWAwQd76a6hv3szRdv6hGPZ+DOCcKTR8+VijxQ077E3
   N7eg4k8myGFtYeUfCs+JmtC2Cssmdc2lilh51I9BRXjd/mJ2v14LENrC7
   Q==;
X-CSE-ConnectionGUID: FcgNUrXxQT2CXUdvt4Tesg==
X-CSE-MsgGUID: Q8sjQSGoQIGZ6rImUCMcDg==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="40752798"
X-IronPort-AV: E=Sophos;i="6.12,312,1728975600"; 
   d="scan'208";a="40752798"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 11:28:15 -0800
X-CSE-ConnectionGUID: nTcjnS0ORv6RayhXdkIjJQ==
X-CSE-MsgGUID: WYzs63liSOqC4imFQ+ZYVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,312,1728975600"; 
   d="scan'208";a="104343628"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.16.163])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 11:28:10 -0800
Message-ID: <c88ae590-4930-4d22-988c-60a5eeaad490@intel.com>
Date: Mon, 13 Jan 2025 21:28:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the
 guest TD
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com>
 <a42183ab-a25a-423e-9ef3-947abec20561@intel.com>
 <Z2GiQS_RmYeHU09L@google.com>
 <487a32e6-54cd-43b7-bfa6-945c725a313d@intel.com>
 <Z2WZ091z8GmGjSbC@google.com>
 <96f7204b-6eb4-4fac-b5bb-1cd5c1fc6def@intel.com>
 <Z4Aff2QTJeOyrEUY@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z4Aff2QTJeOyrEUY@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/01/25 21:11, Sean Christopherson wrote:
> My vote would to KVM_BUG_ON() before entering the guest.

I notice if KVM_BUG_ON() is called with interrupts disabled
smp_call_function_many_cond() generates a warning:

WARNING: CPU: 223 PID: 4213 at kernel/smp.c:807 smp_call_function_many_cond+0x421/0x560

static void smp_call_function_many_cond(const struct cpumask *mask,
					smp_call_func_t func, void *info,
					unsigned int scf_flags,
					smp_cond_func_t cond_func)
{
	int cpu, last_cpu, this_cpu = smp_processor_id();
	struct call_function_data *cfd;
	bool wait = scf_flags & SCF_WAIT;
	int nr_cpus = 0;
	bool run_remote = false;
	bool run_local = false;

	lockdep_assert_preemption_disabled();

	/*
	 * Can deadlock when called with interrupts disabled.
	 * We allow cpu's that are not yet online though, as no one else can
	 * send smp call function interrupt to this cpu and as such deadlocks
	 * can't happen.
	 */
	if (cpu_online(this_cpu) && !oops_in_progress &&
	    !early_boot_irqs_disabled)
		lockdep_assert_irqs_enabled();			<------------- here

Do we need to care about that?

