Return-Path: <kvm+bounces-1062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93BA57E4932
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 944DC1C20BF5
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E5836AF6;
	Tue,  7 Nov 2023 19:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MK2Njfou"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373C23589F
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 19:29:34 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8A110A;
	Tue,  7 Nov 2023 11:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699385374; x=1730921374;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D5XMBSia48bo54cdD5bOasUKS2z4JH41hv+JBv6hmwE=;
  b=MK2NjfouffDmwgpAmHFu6ZnbfI5mLpvlVXgi1iLq589mRK5hXH94dzrr
   sBDomYcV89O9W7nvRoPB+EhPRsfyPvhaaLS6NOaJ3BaIoDr4M3HqOFutp
   kQyA7l/sWd94HRQ0JwmxKEs5UKyArNQPcYMpL4L3mcQghJ7VsJVUGbQTg
   hYml71KYs6cc92cm1FeBCPuyPL/WqZnVHFlHij4IE34IqVse77dv84GQX
   sjTw4LTG07yI2SwPhEM406s+NM1HT3fsiCm856+WY0hsQsjAG0Y601RM+
   PZFzuAAmaUKIaSaCt24Xaoqo7B+DQTP/eZrAbZ5KvGrFmMeb9Sc5D172x
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="369787114"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="369787114"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 11:29:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="936267163"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="936267163"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 11:29:33 -0800
Date: Tue, 7 Nov 2023 11:29:33 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	isaku.yamahata@linux.intel.com
Subject: KVM: X86: Make bus clock frequency for vapic timer (bus lock -> bus
 clock) (was Re: [PATCH 0/2] KVM: X86: Make bus lock frequency for vapic
 timer) configurable
Message-ID: <20231107192933.GA1102144@ls.amr.corp.intel.com>
References: <cover.1699383993.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1699383993.git.isaku.yamahata@intel.com>

I meant bus clock frequency, not bus lock. Sorry for typo.

On Tue, Nov 07, 2023 at 11:22:32AM -0800,
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add KVM_CAP_X86_BUS_FREQUENCY_CONTROL capability to configure the core
> crystal clock (or processor's bus clock) for APIC timer emulation.  Allow
> KVM_ENABLE_CAPABILITY(KVM_CAP_X86_BUS_FREUQNCY_CONTROL) to set the
> frequency.  When using this capability, the user space VMM should configure
> CPUID[0x15] to advertise the frequency.
> 
> TDX virtualizes CPUID[0x15] for the core crystal clock to be 25MHz.  The
> x86 KVM hardcodes its freuqncy for APIC timer to be 1GHz.  This mismatch
> causes the vAPIC timer to fire earlier than the guest expects. [1] The KVM
> APIC timer emulation uses hrtimer, whose unit is nanosecond.
> 
> There are options to reconcile the mismatch.  1) Make apic bus clock frequency
> configurable (this patch).  2) TDX KVM code adjusts TMICT value.  This is hacky
> and it results in losing MSB bits from 32 bit width to 30 bit width.  3). Make
> the guest kernel use tsc deadline timer instead of acpi oneshot/periodic timer.
> This is guest kernel choice.  It's out of control of VMM.
> 
> [1] https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@google.com/
> 
> Isaku Yamahata (2):
>   KVM: x86: Make the hardcoded APIC bus frequency vm variable
>   KVM: X86: Add a capability to configure bus frequency for APIC timer
> 
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/hyperv.c           |  2 +-
>  arch/x86/kvm/lapic.c            |  6 ++++--
>  arch/x86/kvm/lapic.h            |  4 ++--
>  arch/x86/kvm/x86.c              | 16 ++++++++++++++++
>  include/uapi/linux/kvm.h        |  1 +
>  6 files changed, 26 insertions(+), 5 deletions(-)
> 
> -- 
> 2.25.1
> 

-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

