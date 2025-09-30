Return-Path: <kvm+bounces-59101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 29B6ABABF28
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75404189F43F
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF2E2F3636;
	Tue, 30 Sep 2025 08:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DrI5KCDD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752212C0F87;
	Tue, 30 Sep 2025 08:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759219436; cv=none; b=SUugwy/DNRUCGt6vBja/a+QQQ13qixQE3Gri27gTtJG8CAD3UYbZiOuWoeuv7YSybI0vEPml2f3jrG3Uh7qF/+CscIXa4i+xzlL/4awrkccUVVx0A0LGYIwUUu7V198PvPFga7VL26P9lCcgTdDg/p8jru91DyrHVt2BSDpyxa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759219436; c=relaxed/simple;
	bh=blP+1aXofxiRorje2aYnseFkYVpT/JKUFVCD4egWEjQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PORJFYA0cAu0Wd+pEhfKkS9ZLoT2lnDGx13Fu3f/jEgOtFl5yx04k+b3FRJQdO4SdgMAm5o1l3N1q4BnbX5LhOakagpER9Himzuvb69+COhW2WGN6qylNCYJ9gLnmVJQs04pKBYBgoEo45coF6E8aAmTt5pd9Q27ciehsg6bBVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DrI5KCDD; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759219435; x=1790755435;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=blP+1aXofxiRorje2aYnseFkYVpT/JKUFVCD4egWEjQ=;
  b=DrI5KCDDJ5PhMMRhrMoxkxUWqfKbthekQmGf1YPOnXi2hX2G5s5MHXca
   LtCvIUckkUXFUNSULuioI4U7ZTuEKzznhseMaJUCqop03RPoTcvALOJId
   oFrw01q2DlH8IoNP+zomNEt87777T87ZBVOolNwPE/DYamcCtIZcQ0wTO
   8SCHac1nkDzBpwCkfGofR3Iz9HV5+25ujW6SzlzIe4Z21e2+FqaPN3tFs
   yPGyQCz7eez/VDxK+RN4IvAjy9ceeDGpbNskNC8DHltNgBxETxL/pcOur
   EJSfapmIasCt5cAos5QXiOCaB8YwpiRkWO3HNuXmZBAj/XhMHM8T9FgFR
   g==;
X-CSE-ConnectionGUID: fqHyHg0CQWOvuMK81lHjXw==
X-CSE-MsgGUID: 9GAHwSOHRhydYJaCj9ltTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="61513026"
X-IronPort-AV: E=Sophos;i="6.18,303,1751266800"; 
   d="scan'208";a="61513026"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 01:03:51 -0700
X-CSE-ConnectionGUID: Kj2Zd/VZQyyjrU7daZGOAA==
X-CSE-MsgGUID: NGO99cVCSIqbreozRJzEQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,303,1751266800"; 
   d="scan'208";a="182877217"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.232.209]) ([10.124.232.209])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 01:03:48 -0700
Message-ID: <25af94f5-79e3-4005-964e-e77b1320a16e@linux.intel.com>
Date: Tue, 30 Sep 2025 16:03:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: REGRESSION on linux-next (next-20250919)
To: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
 seanjc@google.com
Cc: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
 "intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>,
 "Kurmi, Suresh Kumar" <suresh.kumar.kurmi@intel.com>,
 "Saarinen, Jani" <jani.saarinen@intel.com>, lucas.demarchi@intel.com,
 linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
References: <70b64347-2aca-4511-af78-a767d5fa8226@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <70b64347-2aca-4511-af78-a767d5fa8226@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 9/30/2025 1:30 PM, Borah, Chaitanya Kumar wrote:
> Hello Sean,
>
> Hope you are doing well. I am Chaitanya from the linux graphics team in 
> Intel.
>
> This mail is regarding a regression we are seeing in our CI runs[1] on
> linux-next repository.
>
> Since the version next-20250919 [2], we are seeing the following regression
>
> `````````````````````````````````````````````````````````````````````````````````
> <4>[   10.973827] ------------[ cut here ]------------
> <4>[   10.973841] WARNING: arch/x86/events/core.c:3089 at 
> perf_get_x86_pmu_capability+0xd/0xc0, CPU#15: (udev-worker)/386
> ...
> <4>[   10.974028] Call Trace:
> <4>[   10.974030]  <TASK>
> <4>[   10.974033]  ? kvm_init_pmu_capability+0x2b/0x190 [kvm]
> <4>[   10.974154]  kvm_x86_vendor_init+0x1b0/0x1a40 [kvm]
> <4>[   10.974248]  vmx_init+0xdb/0x260 [kvm_intel]
> <4>[   10.974278]  ? __pfx_vt_init+0x10/0x10 [kvm_intel]
> <4>[   10.974296]  vt_init+0x12/0x9d0 [kvm_intel]
> <4>[   10.974309]  ? __pfx_vt_init+0x10/0x10 [kvm_intel]
> <4>[   10.974322]  do_one_initcall+0x60/0x3f0
> <4>[   10.974335]  do_init_module+0x97/0x2b0
> <4>[   10.974345]  load_module+0x2d08/0x2e30
> <4>[   10.974349]  ? __kernel_read+0x158/0x2f0
> <4>[   10.974370]  ? kernel_read_file+0x2b1/0x320
> <4>[   10.974381]  init_module_from_file+0x96/0xe0
> <4>[   10.974384]  ? init_module_from_file+0x96/0xe0
> <4>[   10.974399]  idempotent_init_module+0x117/0x330
> <4>[   10.974415]  __x64_sys_finit_module+0x73/0xe0
> ...
> `````````````````````````````````````````````````````````````````````````````````
> Details log can be found in [3].
>
> After bisecting the tree, the following patch [4] seems to be the first 
> "bad" commit
>
> `````````````````````````````````````````````````````````````````````````````````````````````````````````
>  From 51f34b1e650fc5843530266cea4341750bd1ae37 Mon Sep 17 00:00:00 2001
>
> From: Sean Christopherson <seanjc@google.com>
>
> Date: Wed, 6 Aug 2025 12:56:39 -0700
>
> Subject: KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities
>
> Take a snapshot of the unadulterated PMU capabilities provided by perf so
> that KVM can compare guest vPMU capabilities against hardware capabilities
> when determining whether or not to intercept PMU MSRs (and RDPMC).
> `````````````````````````````````````````````````````````````````````````````````````````````````````````
>
> We also verified that if we revert the patch the issue is not seen.
>
> Could you please check why the patch causes this regression and provide 
> a fix if necessary?

Hi Chaitanya,

I suppose you found this warning on a hybrid client platform, right? It
looks the warning is triggered by the below WARN_ON_ONCE() in
perf_get_x86_pmu_capability() function.

  if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) ||
        !x86_pmu_initialized()) {
        memset(cap, 0, sizeof(*cap));
        return;
    }

The below change should fix it (just building, not test it). I would run a
full scope vPMU test after I come back from China national day's holiday.
Thanks.

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index cebce7094de8..6d87c25226d8 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -108,8 +108,6 @@ void kvm_init_pmu_capability(struct kvm_pmu_ops *pmu_ops)
        bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
        int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;

-       perf_get_x86_pmu_capability(&kvm_host_pmu);
-
        /*
         * Hybrid PMUs don't play nice with virtualization without careful
         * configuration by userspace, and KVM's APIs for reporting supported
@@ -120,6 +118,8 @@ void kvm_init_pmu_capability(struct kvm_pmu_ops *pmu_ops)
                enable_pmu = false;

        if (enable_pmu) {
+               perf_get_x86_pmu_capability(&kvm_host_pmu);
+
                /*
                 * WARN if perf did NOT disable hardware PMU if the number of
                 * architecturally required GP counters aren't present, i.e. if


>
> Thank you.
>
> Regards
>
> Chaitanya
>
> [1]
> https://intel-gfx-ci.01.org/tree/linux-next/combined-alt.html?
> [2] 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20250919
> [3]
> https://intel-gfx-ci.01.org/tree/linux-next/next-20250919/bat-arlh-2/boot0.txt
> [4] 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20250919&id=51f34b1e650fc5843530266cea4341750bd1ae37
>

