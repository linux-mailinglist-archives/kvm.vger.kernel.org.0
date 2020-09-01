Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB8D258630
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 05:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgIAD1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 23:27:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:53807 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgIAD1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 23:27:34 -0400
IronPort-SDR: 0Pruk1rPlL5Xawopc32WgO2aPCqCoS9bJRm5hObjHCLNHWI+XnpW0WhgCgdZA9xC8B7n5BUJHg
 uUZE7gMrjvZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9730"; a="154612718"
X-IronPort-AV: E=Sophos;i="5.76,377,1592895600"; 
   d="scan'208";a="154612718"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 20:27:33 -0700
IronPort-SDR: 5WXqUEtZhL4BvBIKLysmny32nVeoJfptYzJtDvuRr3H1p1Wea83NefoFITmEa4O39xr6bAA5gw
 TM9iiTYL8syg==
X-IronPort-AV: E=Sophos;i="5.76,377,1592895600"; 
   d="scan'208";a="477021534"
Received: from kblgvt-desktop.sh.intel.com (HELO [10.239.13.113]) ([10.239.13.113])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 20:27:31 -0700
Subject: Re: [PATCH 1/5] KVM: nVMX: Fix VMX controls MSRs setup when nested
 VMX enabled
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200828085622.8365-1-chenyi.qiang@intel.com>
 <20200828085622.8365-2-chenyi.qiang@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <be1a078a-8107-3d51-b52a-76ac2372333b@intel.com>
Date:   Tue, 1 Sep 2020 11:27:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200828085622.8365-2-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/28/2020 4:56 PM, Chenyi Qiang wrote:
> KVM supports the nested VM_{EXIT, ENTRY}_LOAD_IA32_PERF_GLOBAL_CTRL and
> VM_{ENTRY_LOAD, EXIT_CLEAR}_BNDCFGS, but they doesn't expose during
> the setup of nested VMX controls MSR.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/vmx/nested.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 23b58c28a1c9..6e0e71f4d45f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6310,7 +6310,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>   #ifdef CONFIG_X86_64
>   		VM_EXIT_HOST_ADDR_SPACE_SIZE |
>   #endif
> -		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT;
> +		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
> +		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
>   	msrs->exit_ctls_high |=
>   		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
>   		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
> @@ -6329,7 +6330,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>   #ifdef CONFIG_X86_64
>   		VM_ENTRY_IA32E_MODE |
>   #endif
> -		VM_ENTRY_LOAD_IA32_PAT;
> +		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
> +		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>   	msrs->entry_ctls_high |=
>   		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
>   
> 

