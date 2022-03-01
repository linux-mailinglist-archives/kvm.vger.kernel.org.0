Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3A04C8773
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 10:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbiCAJMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 04:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbiCAJMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 04:12:50 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05A742A09;
        Tue,  1 Mar 2022 01:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646125930; x=1677661930;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NgjtRylk25ZTUMh3R2WT4rxtndtfzcZH681stWK7pBI=;
  b=l682VA2Tb+faM+wzLhq6/6+w/W7OWLNpw/EiQaEMlyyIqDzhcdwzrSqi
   4VhQlZwc1T2o7ZKdjHsGA+bXfRR7ysGvnOvlKkcO0Yr9pxw4liTa3YRBK
   q8WHtAda4L14grp9+ox3cK3jVcVEEgtPbtvecCmOQy3qTHRttqsPKKr4w
   P3/q4KikpEfRdL9faCvFkVBhzUgKtxFDJlceuwVfs7QJ0r1sHsLdKrlQ8
   8w7SiAsF323JzunBvhRyUWe+6oH36iLay6iLd7vE24H21xk3iVYlu1mQW
   jVnxEWhgOaMU2ZK1cC4rp3nqJSGa7s8MoN822wf54gYXmvnjCaqZeRDms
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="236603173"
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="236603173"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 01:12:10 -0800
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="550634581"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 01:12:05 -0800
Date:   Tue, 1 Mar 2022 17:23:01 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>
Subject: Re: [PATCH v6 9/9] KVM: VMX: Optimize memory allocation for
 PID-pointer table
Message-ID: <20220301092301.GB32619@gao-cwp>
References: <20220225082223.18288-1-guang.zeng@intel.com>
 <20220225082223.18288-10-guang.zeng@intel.com>
 <113db01c73b8fe061b8226e75849317bac7873a5.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <113db01c73b8fe061b8226e75849317bac7873a5.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 07:29:39PM +0200, Maxim Levitsky wrote:
>On Fri, 2022-02-25 at 16:22 +0800, Zeng Guang wrote:
>> Current kvm allocates 8 pages in advance for Posted Interrupt Descriptor
>> pointer (PID-pointer) table to accommodate vCPUs with APIC ID up to
>> KVM_MAX_VCPU_IDS - 1. This policy wastes some memory because most of
>> VMs have less than 512 vCPUs and then just need one page.
>> 
>> If user hypervisor specify max practical vcpu id prior to vCPU creation,
>> IPIv can allocate only essential memory for PID-pointer table and reduce
>> the memory footprint of VMs.
>> 
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
>>  arch/x86/kvm/vmx/vmx.c | 45 ++++++++++++++++++++++++++++--------------
>>  1 file changed, 30 insertions(+), 15 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 0cb141c277ef..22bfb4953289 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -230,9 +230,6 @@ static const struct {
>>  };
>>  
>>  #define L1D_CACHE_ORDER 4
>> -
>> -/* PID(Posted-Interrupt Descriptor)-pointer table entry is 64-bit long */
>> -#define MAX_PID_TABLE_ORDER get_order(KVM_MAX_VCPU_IDS * sizeof(u64))
>>  #define PID_TABLE_ENTRY_VALID 1
>>  
>>  static void *vmx_l1d_flush_pages;
>> @@ -4434,6 +4431,24 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>>  	return exec_control;
>>  }
>>  
>> +static int vmx_alloc_pid_table(struct kvm_vmx *kvm_vmx)
>> +{
>> +	struct page *pages;
>> +
>> +	if(kvm_vmx->pid_table)
>> +		return 0;
>> +
>> +	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO,
>> +			get_order(kvm_vmx->kvm.arch.max_vcpu_id * sizeof(u64)));
>> +
>> +	if (!pages)
>> +		return -ENOMEM;
>> +
>> +	kvm_vmx->pid_table = (void *)page_address(pages);
>> +	kvm_vmx->pid_last_index = kvm_vmx->kvm.arch.max_vcpu_id - 1;
>> +	return 0;
>> +}
>> +
>>  #define VMX_XSS_EXIT_BITMAP 0
>>  
>>  static void init_vmcs(struct vcpu_vmx *vmx)
>> @@ -7159,6 +7174,16 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>>  			goto free_vmcs;
>>  	}
>>  
>> +	if (enable_ipiv && kvm_vcpu_apicv_active(vcpu)) {
>> +		struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
>> +
>> +		mutex_lock(&vcpu->kvm->lock);
>> +		err = vmx_alloc_pid_table(kvm_vmx);
>> +		mutex_unlock(&vcpu->kvm->lock);
>> +		if (err)
>> +			goto free_vmcs;
>> +	}
>
>This could be dangerous. If APICv is temporary inhibited,
>this code won't run and we will end up without PID table.
>
>I think that kvm_vcpu_apicv_active should be just dropped
>from this condition.

Agreed. Will fix it.
