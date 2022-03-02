Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3144C9DD4
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 07:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbiCBGfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 01:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiCBGfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 01:35:53 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3940C5F8C4;
        Tue,  1 Mar 2022 22:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646202908; x=1677738908;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZgpAzsRRmmqaeIEgyxC5au07eT1Knh2iifyDRqim7xk=;
  b=Z94En1SWgzIBVy5nvrxkPo+R8H0vx44PaWWuVM2iox0r0l6BV05W5dlI
   3lG/gwlHHKLK00389UK7kW7xnk45B3r+LsSVBH8zanL5FWMM6QNPH/UiG
   emVSr+8Cp6hV4RIXOWlIHJ1GdBzSu7byS7HSi3OayHU7g/V5oRIOVxfOh
   PHKm2ELDk4mg9IGX+pYGyR1cMkEP4E32I/DSJyhyJi/toSPtfaR52VFxV
   4KmfEEwplIuGS0l9r7h86OUbeXDpjULF0bBgfUqXXFLFBhuGWI1MK4ib7
   29u4AH/HYN/HANJrvvyqGiQ2vHGg9rzrhGBZ3eqALO4rs/Yiq3lMFz6lt
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="253517439"
X-IronPort-AV: E=Sophos;i="5.90,148,1643702400"; 
   d="scan'208";a="253517439"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 22:35:07 -0800
X-IronPort-AV: E=Sophos;i="5.90,148,1643702400"; 
   d="scan'208";a="508091341"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 22:35:01 -0800
Date:   Wed, 2 Mar 2022 14:45:57 +0800
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
Subject: Re: [PATCH v6 7/9] KVM: VMX: enable IPI virtualization
Message-ID: <20220302064556.GA18820@gao-cwp>
References: <20220225082223.18288-1-guang.zeng@intel.com>
 <20220225082223.18288-8-guang.zeng@intel.com>
 <0e9a22e90256ed289d90956f720f36d870c92d2a.camel@redhat.com>
 <20220301092144.GA32619@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301092144.GA32619@gao-cwp>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>>  static void init_vmcs(struct vcpu_vmx *vmx)
>>>  {
>>> +	struct kvm_vcpu *vcpu = &vmx->vcpu;
>>> +	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
>>> +
>>>  	if (nested)
>>>  		nested_vmx_set_vmcs_shadowing_bitmap();
>>>  
>>> @@ -4431,7 +4460,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>>>  	if (cpu_has_tertiary_exec_ctrls())
>>>  		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
>>>  
>>> -	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
>>> +	if (kvm_vcpu_apicv_active(vcpu)) {
>>
>>here too (pre-existing), I also not 100% sure that kvm_vcpu_apicv_active
>>should be used. I haven't studied APICv code that much to be 100% sure.
>

On second thoughts, I think you are correct. Below VMCS fields 
(i.e, EIO_EXIT_BITMAP0/1/2, POSTED_INTR_NV/DESC_ADDR) should be configured as
long as the VM can enable APICv, particularly considering
vmx_refresh_apicv_exec_ctrl() doesn't configure these VMCS fields when APICv
gets activated.

This is a latent bug in KVM. We will fix it with a separate patch.

>I think kvm_vcpu_apicv_active is better.
>
>The question is: If CPU supports a VMX feature (APICv), but it isn't enabled
>now, is it allowed to configure VMCS fields defined by the feature?  Would CPU
>ignore the values written to the fields or retain them after enabling the
>feature later?

This concern is invalid. SDM doesn't mention any ordering requirement about
configuring a feature's vm-execution bit and other VMCS fields introduced for
the feature. Please disregard my original remark.

>
>Personally, KVM shouldn't rely on CPU's behavior in this case. So, It is better
>for KVM to write below VMCS fields only if APICv is enabled.
>
>>
>>
>>>  		vmcs_write64(EOI_EXIT_BITMAP0, 0);
>>>  		vmcs_write64(EOI_EXIT_BITMAP1, 0);
>>>  		vmcs_write64(EOI_EXIT_BITMAP2, 0);
>>> @@ -4441,6 +4470,13 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>>>  
>>>  		vmcs_write16(POSTED_INTR_NV, POSTED_INTR_VECTOR);
>>>  		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
>>> +
>>> +		if (enable_ipiv) {
>>> +			WRITE_ONCE(kvm_vmx->pid_table[vcpu->vcpu_id],
>>> +				__pa(&vmx->pi_desc) | PID_TABLE_ENTRY_VALID);
>>> +			vmcs_write64(PID_POINTER_TABLE, __pa(kvm_vmx->pid_table));
>>> +			vmcs_write16(LAST_PID_POINTER_INDEX, kvm_vmx->pid_last_index);
>>> +		}
>>>  	}
