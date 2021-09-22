Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1E7413F2B
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 04:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhIVCCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 22:02:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:29359 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230302AbhIVCCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 22:02:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="203655062"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="203655062"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 19:00:32 -0700
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="557180586"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.29.180]) ([10.255.29.180])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 19:00:29 -0700
Subject: Re: [PATCH v2] KVM: nVMX: Fix nested bus lock VM exit
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210914095041.29764-1-chenyi.qiang@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <dc6235ff-3d93-0a1c-a5d6-c242809de5d5@intel.com>
Date:   Wed, 22 Sep 2021 10:00:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210914095041.29764-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/2021 5:50 PM, Chenyi Qiang wrote:
> Nested bus lock VM exits are not supported yet. If L2 triggers bus lock
> VM exit, it will be directed to L1 VMM, which would cause unexpected
> behavior. Therefore, handle L2's bus lock VM exits in L0 directly.
> 
> Fixes: fe6b6bc802b4 ("KVM: VMX: Enable bus lock VM exit")
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
> Change log
> v1->v2
> - Because nested bus lock VM exit is not supported and how nested
>    support would operate is uncertain. Add a brief comment to state that this
>    feature is never exposed to L1 at present. (Sean)
> - v1: https://lore.kernel.org/lkml/20210827085110.6763-1-chenyi.qiang@intel.com/
> ---
>   arch/x86/kvm/vmx/nested.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bc6327950657..5646cc1e8d4c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5873,6 +5873,12 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
>   	case EXIT_REASON_VMFUNC:
>   		/* VM functions are emulated through L2->L0 vmexits. */
>   		return true;
> +	case EXIT_REASON_BUS_LOCK:
> +		/*
> +		 * At present, bus lock VM exit is never exposed to L1.
> +		 * Handle L2's bus locks in L0 directly.
> +		 */
> +		return true;
>   	default:
>   		break;
>   	}
> 

