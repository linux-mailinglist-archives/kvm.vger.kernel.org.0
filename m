Return-Path: <kvm+bounces-44496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A98C5A9E0E7
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 10:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC8F4175C2D
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 08:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D10A2472BD;
	Sun, 27 Apr 2025 08:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MGNoqQBM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCCE19D06A
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 08:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745742837; cv=none; b=Yecuu/jviyi5UCe09PE88vPD2i8zdTaZOl4oxrJ6N5mQhwxrjXYzLvTj+t2DPYZoZ96YUy4xc4ZX7Bi+74yKttv9xsRfr6wMFVdEoA5ENvodBNdC8gr34Zs9g2WLPsRq59c9KVRtfwalE05OsePHIwkPEx6u/+zePDlsRsxrr/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745742837; c=relaxed/simple;
	bh=4rGlzdu8He8ClHKNopue69zlaCk1VKVz+yGQua4n6FQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IW1OIvmeED0TZl37KkuCDvXeCgDLOgZEv+10EAURpD9VW0jXHihAG5DWGxyFYUwPy9aPs6Di99V9Q+NHEbtTL9ChJSCWeegoJ2sXgSc9DjHNALEGbsfoBTUb1wHGRdukbb7PfaXUYi73MYLfQhbaOeTqID4p/G+yLrzKX5UY370=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MGNoqQBM; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745742835; x=1777278835;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4rGlzdu8He8ClHKNopue69zlaCk1VKVz+yGQua4n6FQ=;
  b=MGNoqQBMIjVCbt81irkEd9AjrzvPsb8YUKDvyszHh6I4aZ6oEQM0UbD8
   hHLX4m1L9glv9WqJh/qYJb5sS/6w6sRS5FRDtB+M01zT6fd+ce6SU/qCH
   XG+2hzmKA/E4sBt8in52S4h2uLQbDJ0UFb8XQqI1Ggdu480mYTKhfPHsM
   ias+omrch2oc9deJ3zlrlkwGUr8NsZXc5YJCJ7ZSq/JK/+UZ5us3Dv9vO
   lhsT14HHA8S1LfseiYyig7GmpC7gptCCVPOORpNTbzaCh/nsWleZV6qCK
   qizAGjTxcuiKKggw/fCSEuNPzJLzqIKo2dIjFeZD4f+kQNidCrBFBqiDM
   Q==;
X-CSE-ConnectionGUID: Oowz/ypbT7GpvuYpQvuO1A==
X-CSE-MsgGUID: cHowd1ZYSWuioQjLe1s1Ew==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="57995098"
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="57995098"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 01:33:54 -0700
X-CSE-ConnectionGUID: Qcy2UMLbRIaepBdyJ083tw==
X-CSE-MsgGUID: CFL9Pbq7TRmRVanh/NT93w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="133782755"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa007.jf.intel.com with ESMTP; 27 Apr 2025 01:33:51 -0700
Date: Sun, 27 Apr 2025 16:54:48 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Mingwei Zhang <mizhang@google.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [PATCH 3/3] target/i386: Support
 VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL
Message-ID: <aA3w2PiRuNOMKwdM@intel.com>
References: <20250324123712.34096-1-dapeng1.mi@linux.intel.com>
 <20250324123712.34096-4-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324123712.34096-4-dapeng1.mi@linux.intel.com>

> @@ -4212,7 +4213,8 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>              VMX_VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
>              VMX_VM_EXIT_ACK_INTR_ON_EXIT | VMX_VM_EXIT_SAVE_IA32_PAT |
>              VMX_VM_EXIT_LOAD_IA32_PAT | VMX_VM_EXIT_SAVE_IA32_EFER |
> -            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER,
> +            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER |
> +            VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
>          .features[FEAT_VMX_MISC] =
>              MSR_VMX_MISC_STORE_LMA | MSR_VMX_MISC_ACTIVITY_HLT |
>              MSR_VMX_MISC_VMWRITE_VMEXIT,
> @@ -4368,7 +4370,8 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>              VMX_VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
>              VMX_VM_EXIT_ACK_INTR_ON_EXIT | VMX_VM_EXIT_SAVE_IA32_PAT |
>              VMX_VM_EXIT_LOAD_IA32_PAT | VMX_VM_EXIT_SAVE_IA32_EFER |
> -            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER,
> +            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER |
> +            VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
>          .features[FEAT_VMX_MISC] =
>              MSR_VMX_MISC_STORE_LMA | MSR_VMX_MISC_ACTIVITY_HLT |
>              MSR_VMX_MISC_VMWRITE_VMEXIT,
> @@ -4511,7 +4514,8 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>              VMX_VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
>              VMX_VM_EXIT_ACK_INTR_ON_EXIT | VMX_VM_EXIT_SAVE_IA32_PAT |
>              VMX_VM_EXIT_LOAD_IA32_PAT | VMX_VM_EXIT_SAVE_IA32_EFER |
> -            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER,
> +            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER |
> +            VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
>          .features[FEAT_VMX_MISC] =
>              MSR_VMX_MISC_STORE_LMA | MSR_VMX_MISC_ACTIVITY_HLT |
>              MSR_VMX_MISC_VMWRITE_VMEXIT,

Instead of modifying SPR's CPU model directly, we should introduce a new
version (SapphireRapids-v4), like Skylake-Server-v4 enables
"vmx-eptp-switching".


