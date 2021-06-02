Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEB6397F55
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 05:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhFBDOs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 23:14:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:23489 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229643AbhFBDOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 23:14:48 -0400
IronPort-SDR: QX8CuHbXo5RVCNrAiKfjAHImT8vDh8dr3+9eJqsV0Xt2LsY9VaRq1r0gJcxap3r3qbpO3Radh4
 OzT6FHQplbNQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="200679968"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="200679968"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 20:13:02 -0700
IronPort-SDR: dyyeZw49guuAigrqkJqmyBroJS791eCzerRZ5Fbk6raBsrF3FTCC0YrXzEyzTkHJPOZADegvuC
 VgMW3QS1YZCg==
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="479529872"
Received: from unknown (HELO [10.238.130.133]) ([10.238.130.133])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 20:12:59 -0700
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Subject: Re: [PATCH RFC 2/7] kvm: x86: Introduce XFD MSRs as passthrough to
 guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-3-jing2.liu@linux.intel.com>
 <YKwd5OTXr97Fxfok@google.com>
Message-ID: <16ae7bbe-4831-8699-b610-e1b4ba64fe52@linux.intel.com>
Date:   Wed, 2 Jun 2021 11:12:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YKwd5OTXr97Fxfok@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/25/2021 5:43 AM, Sean Christopherson wrote:
> On Sun, Feb 07, 2021, Jing Liu wrote:
>> Passthrough both MSRs to let guest access and write without vmexit.
> Why?  Except for read-only MSRs, e.g. MSR_CORE_C1_RES, passthrough MSRs are
> costly to support because KVM must context switch the MSR (which, by the by, is
> completely missing from the patch).
>
> In other words, if these MSRs are full RW passthrough, guests with XFD enabled
> will need to load the guest value on entry, save the guest value on exit, and
> load the host value on exit.  That's in the neighborhood of a 40% increase in
> latency for a single VM-Enter/VM-Exit roundtrip (~1500 cycles => >2000 cycles).
>
> I'm not saying these can't be passhthrough, but there needs to be strong
> justification for letting the guest read/write them directly.
For IA32_XFD, it's per task and switched during task switch(if 
different). Meanwhile,
hardware uses IA32_XFD to prevent any instruction per task touching AMX 
state at the
first time and generate #NM. This means if vcpu running with AMX 
enabled, hardware
IA32_XFD should keep a guest value, and once guest #NM handler finished, 
the bit
should not be set anymore for this task.
No matter passthrough or not, IA32_XFD need be restored to guest value 
when vm-enter,
and load host value on exit (or load zero to prevent losing guest AMX in 
use state).
And passthrough makes guest IA32_XFD switch during task switch without 
trapped.

For IA32_XFD_ERR, hardware automatically set the bit once #NM fault. #NM 
handler
detect and clear the bit.
No matter passthrough or not, KVM doesn't know if guest has #NM, it need 
read and save
IA32_XFD_ERR when vmexit to prevent preemption task from clearing bit.
Emulating need not restore guest non-zero IA32_XFD_ERR when vmenter and 
effort is guest
#NM handler takes extra trap(s). But restoring a non-zero IA32_XFD_ERR 
only occurs for
the vmexit case: between task's first AMX instruction(causing #NM) and 
end of clearing
in guest #NM handler.

Thanks,
Jing

