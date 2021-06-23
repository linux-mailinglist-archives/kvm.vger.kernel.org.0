Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F573B11DA
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 04:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhFWCpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 22:45:52 -0400
Received: from mga05.intel.com ([192.55.52.43]:7462 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhFWCpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 22:45:52 -0400
IronPort-SDR: JWbxcMQvoGWOBHW4rJe2xi7k0LcYD2Y6C6pSAW1JQzmdXrNHuBdKNTPgjldMe8vV0KX3J437ts
 xHDdBsgyeW2A==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="292807421"
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="292807421"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 19:43:35 -0700
IronPort-SDR: 1Jn0cVScKUkzWJZxyGhyBcDnK+RdTRvQIGWQ5I8kg0xwq8hmgQJqH6Mh8WOIIfJnRUZGjZgUWb
 PoG6G2aWE46A==
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="452858380"
Received: from unknown (HELO [10.239.13.111]) ([10.239.13.111])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 19:43:33 -0700
Subject: Re: [PATCH] KVM: nVMX: Handle split-lock #AC exceptions that happen
 in L2
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210622172244.3561540-1-seanjc@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <5196d26a-abb5-7ec9-70b1-69912a45ecd7@intel.com>
Date:   Wed, 23 Jun 2021 10:43:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622172244.3561540-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/2021 1:22 AM, Sean Christopherson wrote:
> Mark #ACs that won't be reinjected to the guest as wanted by L0 so that
> KVM handles split-lock #AC from L2 instead of forwarding the exception to
> L1.  Split-lock #AC isn't yet virtualized, i.e. L1 will treat it like a
> regular #AC and do the wrong thing, e.g. reinject it into L2.
> 
> Fixes: e6f8b6c12f03 ("KVM: VMX: Extend VMXs #AC interceptor to handle split lock #AC in guest")
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 3 +++
>   arch/x86/kvm/vmx/vmcs.h   | 5 +++++
>   arch/x86/kvm/vmx/vmx.c    | 4 ++--
>   arch/x86/kvm/vmx/vmx.h    | 1 +
>   4 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 183fd9d62fc5..fa3f50f0a3fa 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5833,6 +5833,9 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
>   		else if (is_breakpoint(intr_info) &&
>   			 vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
>   			return true;
> +		else if (is_alignment_check(intr_info) &&
> +			 !vmx_guest_inject_ac(vcpu))
> +			return true;

Why choose to check in nested_vmx_l0_wants_exit, not in 
nested_vmx_l1_wants_exit()?

>   		return false;
>   	case EXIT_REASON_EXTERNAL_INTERRUPT:
>   		return true;
