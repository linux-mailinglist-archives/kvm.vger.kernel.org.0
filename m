Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062D1777AC1
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 16:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbjHJO3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 10:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235537AbjHJO3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 10:29:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E201E4B;
        Thu, 10 Aug 2023 07:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691677787; x=1723213787;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yo6Lfzqy2WIB3QzGalEmKlZhegsIaZLYiWJmZDXSayY=;
  b=h7fuzIS6yuifOoH2FrXVjfvXajiFPJjw7bRMDitFXt+X0hzl4vyH64ML
   hYjS355yUuVOx9Rv7gTShQh05PH7WAwl9Mz52XRQFhDFkq+KkZ530eE3D
   SQfpt4Pc6h93INTB/SkjhH7fnVJ/HwSVS/fuOBnHrMDIuoqGKlrUyCkA6
   K9T0+vHKY5g+68TugK0i+qCmwsTQEtumqWYzAEghET4IpycKmMBlU6Fj1
   /AQvmdJLq10pCN8ReaHc7q+otBl4mibO+s7kZX2EWAVEHI1vSB4JZiWlF
   cILU9bZXsUjE2Y4m6Y6/5aabkvFwT+ZCMk2lHqB4EWRTvHKXhhDTQxrm3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="375128942"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="375128942"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 07:29:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="725839099"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="725839099"
Received: from dcastil2-mobl2.amr.corp.intel.com (HELO [10.212.148.36]) ([10.212.148.36])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 07:29:46 -0700
Message-ID: <c871cc44-b6a0-06e3-493b-33ddf4fa6e05@intel.com>
Date:   Thu, 10 Aug 2023 07:29:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
Content-Language: en-US
To:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org,
        pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>
Cc:     Chao Gao <chao.gao@intel.com>, john.allen@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com, binbin.wu@linux.intel.com
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-10-weijiang.yang@intel.com>
 <ZMuMN/8Qa1sjJR/n@chao-email>
 <bfc0b3cb-c17a-0ad6-6378-0c4e38f23024@intel.com>
 <ZM1jV3UPL0AMpVDI@google.com>
 <806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/23 02:29, Yang, Weijiang wrote:
...
> When KVM enumerates shadow stack support for guest in CPUID(0x7, 
> 0).ECX[bit7], architecturally it claims both SS user and supervisor
> mode are supported. Although the latter is not supported in Linux,
> but in virtualization world, the guest OS could be non-Linux system,
> so KVM supervisor state support is necessary in this case.

What actual OSes need this support?

> Two solutions are on the table:
> 1) Enable CET supervisor support in Linux kernel like user mode support.

We _will_ do this eventually, but not until FRED is merged.  The core
kernel also probably won't be managing the MSRs on non-FRED hardware.

I think what you're really talking about here is that the kernel would
enable CET_S XSAVE state management so that CET_S state could be managed
by the core kernel's FPU code.

That is, frankly, *NOT* like the user mode support at all.

> 2) Enable support in KVM domain.
> 
> Problem:
> The Pros/Cons for each solution(my individual thoughts):
> In kernel solution:
> Pros:
> - Avoid saving/restoring 3 supervisor MSRs(PL{0,1,2}_SSP) at vCPU
>   execution path.
> - Easy for KVM to manage guest CET xstate bits for guest.
> Cons:
> - Unnecessary supervisor state xsaves/xrstors operation for non-vCPU
>   thread.

What operations would be unnecessary exactly?

> - Potentially extra storage space(24 bytes) for thread context.

Yep.  This one is pretty unavoidable.  But, we've kept MPX around in
this state for a looooooong time and nobody really seemed to care.

> KVM solution:
> Pros:
> - Not touch current kernel FPU management framework and logic.
> - No extra space and operation for non-vCPU thread.
> Cons:
> - Manually saving/restoring 3 supervisor MSRs is a performance burden to
>   KVM.
> - It looks more like a hack method for KVM, and some handling logic
>   seems a bit awkward.

In a perfect world, we'd just allocate space for CET_S in the KVM
fpstates.  The core kernel fpstates would have
XSTATE_BV[13]==XCOMP_BV[13]==0.  An XRSTOR of the core kernel fpstates
would just set CET_S to its init state.

But I suspect that would be too much work to implement in practice.  It
would be akin to a new lesser kind of dynamic xstate, one that didn't
interact with XFD and *NEVER* gets allocated in the core kernel
fpstates, even on demand.

I want to hear more about who is going to use CET_S state under KVM in
practice.  I don't want to touch it if this is some kind of purely
academic exercise.  But it's also silly to hack some kind of temporary
solution into KVM that we'll rip out in a year when real supervisor
shadow stack support comes along.

If it's actually necessary, we should probably just eat the 24 bytes in
the fpstates, flip the bit in IA32_XSS and move on.  There shouldn't be
any other meaningful impact to the core kernel.

