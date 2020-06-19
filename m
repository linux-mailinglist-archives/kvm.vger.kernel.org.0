Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01B72005F0
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 12:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732289AbgFSKDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 06:03:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:18257 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729195AbgFSKDE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 06:03:04 -0400
IronPort-SDR: 4to/IEYMSY4TSEg8MNW5daXTpjaVgP77zPtvTdeoRcO9Z8dm/3CMsb+y43+5tdEdYZhZ1CdUTs
 JcIaO1c3buvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="161013894"
X-IronPort-AV: E=Sophos;i="5.75,254,1589266800"; 
   d="scan'208";a="161013894"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2020 03:03:04 -0700
IronPort-SDR: pwydFauFi3ZcSoRd+Qs3/m0yEZWFELl3NTmx7KYbU/AoEPSaxRPCc/8RFYTX3fvpI1Z8Ts6Is7
 i+MMANSk4MzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,254,1589266800"; 
   d="scan'208";a="263307868"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.173.249]) ([10.249.173.249])
  by orsmga007.jf.intel.com with ESMTP; 19 Jun 2020 03:03:01 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH RFC] Revert "KVM: VMX: Micro-optimize vmexit time when not
 exposing PMU"
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20200619094046.654019-1-vkuznets@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <2c7d6849-7fac-b9f6-7bcb-5509863564f3@intel.com>
Date:   Fri, 19 Jun 2020 18:03:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200619094046.654019-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/6/19 17:40, Vitaly Kuznetsov wrote:
> Guest crashes are observed on a Cascade Lake system when 'perf top' is
> launched on the host, e.g.
Interesting, is it specific to Cascade Lake?

Would you mind sharing the output of
"cpuid -r -l 1 -1" and "cat /proc/cpuinfo| grep microcode | uniq" with us ?

Thanks,
Like Xu
>
>   BUG: unable to handle kernel paging request at fffffe0000073038
>   PGD 7ffa7067 P4D 7ffa7067 PUD 7ffa6067 PMD 7ffa5067 PTE ffffffffff120
>   Oops: 0000 [#1] SMP PTI
>   CPU: 1 PID: 1 Comm: systemd Not tainted 4.18.0+ #380
> ...
>   Call Trace:
>    serial8250_console_write+0xfe/0x1f0
>    call_console_drivers.constprop.0+0x9d/0x120
>    console_unlock+0x1ea/0x460
>
> Call traces are different but the crash is imminent. The problem was
> blindly bisected to the commit 041bc42ce2d0 ("KVM: VMX: Micro-optimize
> vmexit time when not exposing PMU"). It was also confirmed that the
> issue goes away if PMU is exposed to the guest.
>
> With some instrumentation of the guest we can see what is being switched
> (when we do atomic_switch_perf_msrs()):
>
>   vmx_vcpu_run: switching 2 msrs
>   vmx_vcpu_run: switching MSR38f guest: 70000000d host: 70000000f
>   vmx_vcpu_run: switching MSR3f1 guest: 0 host: 2
>
> The current guess is that PEBS (MSR_IA32_PEBS_ENABLE, 0x3f1) is to blame.
> Regardless of whether PMU is exposed to the guest or not, PEBS needs to
> be disabled upon switch.
>
> This reverts commit 041bc42ce2d0efac3b85bbb81dea8c74b81f4ef9.
>
> Reported-by: Maxime Coquelin <maxime.coquelin@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> - Perf/KVM interractions are a mystery to me, thus RFC.
> ---
>   arch/x86/kvm/vmx/vmx.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 36c771728c8c..b1a23ad986ff 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6728,8 +6728,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	pt_guest_enter(vmx);
>   
> -	if (vcpu_to_pmu(vcpu)->version)
> -		atomic_switch_perf_msrs(vmx);
> +	atomic_switch_perf_msrs(vmx);
>   	atomic_switch_umwait_control_msr(vmx);
>   
>   	if (enable_preemption_timer)

