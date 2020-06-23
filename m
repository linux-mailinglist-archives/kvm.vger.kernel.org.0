Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA392046AB
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 03:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731866AbgFWBVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 21:21:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:46212 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731572AbgFWBVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 21:21:36 -0400
IronPort-SDR: IbRy4fJK4+YNZ70Y9w7GpQ6wQpsHZDZlGMCAdMRWxMxX1qn7faro/jFlaQ/fMYyqf6o/PwyPhC
 uU/Qr4L5jIqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142981585"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="142981585"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 18:21:33 -0700
IronPort-SDR: NJCoHCZ+AMJML+u+hGRiDYyfdvwTNoPe1ZJ4e13d6brq6k3Yk1liOi0KKov6DaPssxFSQpxlwQ
 nwwB8i83hJQQ==
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="452039604"
Received: from unknown (HELO [10.239.13.99]) ([10.239.13.99])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 18:21:30 -0700
Subject: Re: [PATCH] KVM: VMX: Stop context switching MSR_IA32_UMWAIT_CONTROL
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>,
        Tao Xu <tao3.xu@intel.com>
References: <20200623005135.10414-1-sean.j.christopherson@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <7e840f1c-d8e2-3374-5009-f2ab41a87386@intel.com>
Date:   Tue, 23 Jun 2020 09:21:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200623005135.10414-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/2020 8:51 AM, Sean Christopherson wrote:
> Remove support for context switching between the guest's and host's
> desired UMWAIT_CONTROL.  Propagating the guest's value to hardware isn't
> required for correct functionality, e.g. KVM intercepts reads and writes
> to the MSR, and the latency effects of the settings controlled by the
> MSR are not architecturally visible.
> 
> As a general rule, KVM should not allow the guest to control power
> management settings unless explicitly enabled by userspace, e.g. see
> KVM_CAP_X86_DISABLE_EXITS.  E.g. Intel's SDM explicitly states that C0.2
> can improve the performance of SMT siblings.  A devious guest could
> disable C0.2 so as to improve the performance of their workloads at the
> detriment to workloads running in the host or on other VMs.
> 
> Wholesale removal of UMWAIT_CONTROL context switching also fixes a race
> condition where updates from the host may cause KVM to enter the guest
> with the incorrect value.  Because updates are are propagated to all
> CPUs via IPI (SMP function callback), the value in hardware may be
> stale with respect to the cached value and KVM could enter the guest
> with the wrong value in hardware.  As above, the guest can't observe the
> bad value, but it's a weird and confusing wart in the implementation.
> 
> Removal also fixes the unnecessary usage of VMX's atomic load/store MSR
> lists.  Using the lists is only necessary for MSRs that are required for
> correct functionality immediately upon VM-Enter/VM-Exit, e.g. EFER on
> old hardware, or for MSRs that need to-the-uop precision, e.g. perf
> related MSRs.  For UMWAIT_CONTROL, the effects are only visible in the
> kernel via TPAUSE/delay(), and KVM doesn't do any form of delay in
> vcpu_vmx_run(). 

>Using the atomic lists is undesirable as they are more
> expensive than direct RDMSR/WRMSR.

Do you mean the extra handling of atomic list facility in kvm? Or just 
mean vm-exit/-entry MSR-load/save in VMX hardware is expensive than 
direct RDMSR/WRMSR instruction?

