Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAE6205AA2
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 20:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387520AbgFWS30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 14:29:26 -0400
Received: from mga17.intel.com ([192.55.52.151]:45799 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387476AbgFWS3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 14:29:12 -0400
IronPort-SDR: xMEBZiOUvMMmBLBG3ZIR9MeYDLHTeTJVBNxpumNDavVhsI7QV0E7nwuW7wY9CfkbzW3GmwZ2uv
 gfvXHpVv3b1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="124427886"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="124427886"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 11:29:11 -0700
IronPort-SDR: BPpIr7ZbUhLbIiM0sqnLbwkHOmTPNLMCVvSPxNbsbwcsxhJyV4o8yFG8nykExF0PsDu6EYhB1l
 7BNQd69uXl3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="275431860"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 23 Jun 2020 11:29:10 -0700
Date:   Tue, 23 Jun 2020 11:29:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.huang2@amd.com,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Chai Wen <chaiwen@baidu.com>, Jia Lina <jialina01@baidu.com>
Subject: Re: [PATCH] KVM: X86: Emulate APERF/MPERF to report actual VCPU
 frequency
Message-ID: <20200623182910.GA24107@linux.intel.com>
References: <20200623063530.81917-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623063530.81917-1-like.xu@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 02:35:30PM +0800, Like Xu wrote:
> The aperf/mperf are used to report current CPU frequency after 7d5905dc14a
> "x86 / CPU: Always show current CPU frequency in /proc/cpuinfo". But guest
> kernel always reports a fixed VCPU frequency in the /proc/cpuinfo, which
> may confuse users especially when turbo is enabled on the host.
> 
> Emulate guest APERF/MPERF capability based their values on the host.
> 
> Co-developed-by: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Reviewed-by: Chai Wen <chaiwen@baidu.com>
> Reviewed-by: Jia Lina <jialina01@baidu.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---

...

> @@ -8312,7 +8376,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		dm_request_for_irq_injection(vcpu) &&
>  		kvm_cpu_accept_dm_intr(vcpu);
>  	fastpath_t exit_fastpath;
> -
> +	u64 enter_mperf = 0, enter_aperf = 0, exit_mperf = 0, exit_aperf = 0;
>  	bool req_immediate_exit = false;
>  
>  	if (kvm_request_pending(vcpu)) {
> @@ -8516,8 +8580,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
>  	}
>  
> +	if (unlikely(vcpu->arch.hwp.hw_coord_fb_cap))
> +		get_host_amperf(&enter_mperf, &enter_aperf);
> +
>  	exit_fastpath = kvm_x86_ops.run(vcpu);
>  
> +	if (unlikely(vcpu->arch.hwp.hw_coord_fb_cap)) {
> +		get_host_amperf(&exit_mperf, &exit_aperf);
> +		vcpu_update_amperf(vcpu, get_amperf_delta(enter_aperf, exit_aperf),
> +			get_amperf_delta(enter_mperf, exit_mperf));
> +	}
> +

Is there an alternative approach that doesn't require 4 RDMSRs on every VMX
round trip?  That's literally more expensive than VM-Enter + VM-Exit
combined.

E.g. what about adding KVM_X86_DISABLE_EXITS_APERF_MPERF and exposing the
MSRs for read when that capability is enabled?
