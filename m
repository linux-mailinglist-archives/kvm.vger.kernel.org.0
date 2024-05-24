Return-Path: <kvm+bounces-18141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7756E8CE837
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 17:42:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2FA41F221BD
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 15:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB03312DDB5;
	Fri, 24 May 2024 15:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gs7Co7/g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B151DFFC;
	Fri, 24 May 2024 15:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716565356; cv=none; b=J6u8XEh73+a9V7Mnaozmpts6J0ZPmd4PL+uAYpJAClc4en99CBNb35bbmbhrk8pZZBDeJmF/YpOAq4VQlI4KdP99Yag5HIKqypvYGWTihKwu+euGsoCk3LTQbYGTMK0aQ4hgAVpD+hRH0q8vHue4Gz+lUaBLQi9ufmsaL5Qj2ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716565356; c=relaxed/simple;
	bh=k/cPA+LKz5A4pfe0FX/6LwhdaoxIeb1xH5HTKHqZYUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j4vVh2eXLrWsUZM211kVm2vPrI5yne0VJFMnVNun2ZtdoQ7k2xnef31Qlk7SCs2tJkrmjMxxTxqYQHV8kgorxcJHrCeB3M/7vUpdy028KjqPWq2F6qUlEY0nlI2xZr1jWFK1+2pm/ssn9aDKHC2YXI/uYT+ilZZzCshs8OyqpIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gs7Co7/g; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716565355; x=1748101355;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k/cPA+LKz5A4pfe0FX/6LwhdaoxIeb1xH5HTKHqZYUY=;
  b=gs7Co7/gkXsoaoRb/voCcZxgsbU8UE8EDRb7B/q+q2K8NnzjJHzNbLIS
   pIA4VQDNjsCysu1PCUOifjOiqd/I2nHjBqQ319U3LS/QEx3C5nruwXmOg
   xHPsw2Nydjz4DM9iytoYxPPQyJM3rpZpBbOvdeh4FWVq+mhwXz13CrWVN
   Rk2fXeeKllRMIdinOhat+21A4IgbT1g1y+rj7s9rhtziyEz5SvxPV8P/s
   ZdlZ7Ov43xtr+9qNaAV3zHAMN7cOm62h0qEIA+I1Noi76J0mp0uwRBz9x
   VyF1niChZM5ZBW6ACmy4s1Xv1rhc0f1xMGeKdjONVf+5fLF9ErnQPBBxf
   w==;
X-CSE-ConnectionGUID: 2j+FCD2hSDi9oMRmgCEHOQ==
X-CSE-MsgGUID: CWDSrL14TJil7lL8aMse/w==
X-IronPort-AV: E=McAfee;i="6600,9927,11082"; a="23612705"
X-IronPort-AV: E=Sophos;i="6.08,185,1712646000"; 
   d="scan'208";a="23612705"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2024 08:42:34 -0700
X-CSE-ConnectionGUID: emd1RlWyRzGQ+zpqHhgIHA==
X-CSE-MsgGUID: zLT++Fc9RaKw+woc5OgaGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,185,1712646000"; 
   d="scan'208";a="38486696"
Received: from ssuppiah-mobl.gar.corp.intel.com (HELO desk) ([10.209.68.49])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2024 08:42:33 -0700
Date: Fri, 24 May 2024 08:42:26 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	daniel.sneddon@linux.intel.com, tglx@linutronix.de,
	konrad.wilk@oracle.com, peterz@infradead.org, seanjc@google.com,
	andrew.cooper3@citrix.com, dave.hansen@linux.intel.com,
	nik.borisov@suse.com, kpsingh@kernel.org, longman@redhat.com,
	bp@alien8.de, pbonzini@redhat.com
Subject: Re: [PATCH v2] x86/bhi: BHI mitigation can trigger warning in #DB
 handler
Message-ID: <20240524154226.dpwoqjuxhzc47ntk@desk>
References: <20240524070459.3674025-1-alexandre.chartre@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524070459.3674025-1-alexandre.chartre@oracle.com>

On Fri, May 24, 2024 at 09:04:59AM +0200, Alexandre Chartre wrote:
> When BHI mitigation is enabled, if sysenter is invoked with the TF flag
> set then entry_SYSENTER_compat uses CLEAR_BRANCH_HISTORY and calls the
> clear_bhb_loop() before the TF flag is cleared. This causes the #DB
> handler (exc_debug_kernel) to issue a warning because single-step is
> used outside the entry_SYSENTER_compat function.
> 
> To address this issue, entry_SYSENTER_compat() should use
> CLEAR_BRANCH_HISTORY after making sure flag the TF flag is cleared.
> 
> The problem can be reproduced with the following sequence:
> 
>  $ cat sysenter_step.c
>  int main()
>  { asm("pushf; pop %ax; bts $8,%ax; push %ax; popf; sysenter"); }
> 
>  $ gcc -o sysenter_step sysenter_step.c
> 
>  $ ./sysenter_step
>  Segmentation fault (core dumped)
> 
> The program is expected to crash, and the #DB handler will issue a warning.
> 
> Kernel log:
> 
>   WARNING: CPU: 27 PID: 7000 at arch/x86/kernel/traps.c:1009 exc_debug_kernel+0xd2/0x160
>   ...
>   RIP: 0010:exc_debug_kernel+0xd2/0x160
>   ...
>   Call Trace:
>   <#DB>
>    ? show_regs+0x68/0x80
>    ? __warn+0x8c/0x140
>    ? exc_debug_kernel+0xd2/0x160
>    ? report_bug+0x175/0x1a0
>    ? handle_bug+0x44/0x90
>    ? exc_invalid_op+0x1c/0x70
>    ? asm_exc_invalid_op+0x1f/0x30
>    ? exc_debug_kernel+0xd2/0x160
>    exc_debug+0x43/0x50
>    asm_exc_debug+0x1e/0x40
>   RIP: 0010:clear_bhb_loop+0x0/0xb0
>   ...
>   </#DB>
>   <TASK>
>    ? entry_SYSENTER_compat_after_hwframe+0x6e/0x8d
>   </TASK>
> 
> Fixes: 7390db8aea0d ("x86/bhi: Add support for clearing branch history at syscall entry")
> Reported-by: Suman Maity <suman.m.maity@oracle.com>
> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>

Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

