Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27E33F985E
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 13:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244986AbhH0LOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 07:14:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:45354 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234172AbhH0LOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 07:14:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="278954581"
X-IronPort-AV: E=Sophos;i="5.84,356,1620716400"; 
   d="scan'208";a="278954581"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 04:13:53 -0700
X-IronPort-AV: E=Sophos;i="5.84,356,1620716400"; 
   d="scan'208";a="538054362"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.172.200]) ([10.249.172.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 04:13:50 -0700
Subject: Re: [PATCH] KVM: nVMX: Fix nested bus lock VM exit
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210827085110.6763-1-chenyi.qiang@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <ae887305-378f-3ef1-7e74-8ae11e962671@intel.com>
Date:   Fri, 27 Aug 2021 19:13:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210827085110.6763-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/27/2021 4:51 PM, Chenyi Qiang wrote:
> Nested bus lock VM exits are not supported yet. If L2 triggers bus lock
> VM exit, it will be directed to L1 VMM, which would cause unexpected
> behavior. Therefore, handle L2's bus lock VM exits in L0 directly.
> 
> Fixes: fe6b6bc802b4 ("KVM: VMX: Enable bus lock VM exit")
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bc6327950657..754f53cf0f7a 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5873,6 +5873,8 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
>   	case EXIT_REASON_VMFUNC:
>   		/* VM functions are emulated through L2->L0 vmexits. */
>   		return true;
> +	case EXIT_REASON_BUS_LOCK:
> +		return true;
>   	default:
>   		break;
>   	}
> 
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
