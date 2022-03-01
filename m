Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE35B4C8770
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 10:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbiCAJLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 04:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiCAJLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 04:11:37 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFC842A08;
        Tue,  1 Mar 2022 01:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646125856; x=1677661856;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gOJiA9z7fHS2Yo0M8c+wiWR9d2su9qM5cyve0xvlK2w=;
  b=mAsJkdIE3MOWTYWqQmVN0h9oL7QDHap/3d97TTK8KYIS7fWM2kxsqi0x
   Sx6EFqFMh3Bt3o1x3RdZtTtatgjhWeLXD2GcNKtWNgKbpaURPJWQKq3Lb
   iiNVNmhlt4UiqRLvq+ZFrhHzY8mzrktNx07ZcmDzt6TYttBxdhRI5po+S
   Rd2yp6iVdQoacuy46EnJVz13OG6CG1R1Jq6bvnNI9PTKZHjDQjGv9lDsN
   oT1xhZliHIfO6qSeNRrlT2xoUZMbkrztqNwK6g53HHuz3pllvt18s2AZz
   HmaANdUhCeBV3nSYRi/Xi0qsR4dgl4JyUUi1EpsWERVlMM7JX/3pW6zlU
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="339526804"
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="339526804"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 01:10:56 -0800
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="534818793"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 01:10:50 -0800
Date:   Tue, 1 Mar 2022 17:21:46 +0800
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
Message-ID: <20220301092144.GA32619@gao-cwp>
References: <20220225082223.18288-1-guang.zeng@intel.com>
 <20220225082223.18288-8-guang.zeng@intel.com>
 <0e9a22e90256ed289d90956f720f36d870c92d2a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e9a22e90256ed289d90956f720f36d870c92d2a.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> +static bool vmx_can_use_ipiv_pi(struct kvm *kvm)
>> +{
>> +	return irqchip_in_kernel(kvm) && enable_ipiv;
>> +}
>> +
>> +static bool vmx_can_use_posted_interrupts(struct kvm *kvm)
>> +{
>> +	return vmx_can_use_ipiv_pi(kvm) || vmx_can_use_vtd_pi(kvm);
>
>It took me a while to figure that out.
> 
>vmx_can_use_vtd_pi returns true when the VM can be targeted by posted
>interrupts from the IOMMU, which leads to
> 
>1. update of the NV vector and SN bit on vcpu_load/vcpu_put to let
>IOMMU knows where the vCPU really runs.
> 
>2. in vmx_pi_update_irte to configure the posted interrupts.
> 
> 
>Now IPIv will also use the same NV vector and SN bit for IPI virtualization,
>thus they have to be kept up to date on vcpu load/put.
> 
>I would appreciate a comment about this in vmx_can_use_posted_interrupts
>because posted interrupts can mean too many things, like a host->guest
>posted interrupt which is sent by just interrupt.
> 
>Maybe also rename the function to something like
> 
>vmx_need_up_to_date_nv_sn(). Sounds silly to me so
>maybe something else.

It makes sense.

Will add a comment and rename the function.

>
>> @@ -4219,14 +4229,21 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>>  
>>  	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
>>  	if (cpu_has_secondary_exec_ctrls()) {
>> -		if (kvm_vcpu_apicv_active(vcpu))
>> +		if (kvm_vcpu_apicv_active(vcpu)) {
>>  			secondary_exec_controls_setbit(vmx,
>>  				      SECONDARY_EXEC_APIC_REGISTER_VIRT |
>>  				      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
>> -		else
>> +			if (cpu_has_tertiary_exec_ctrls() && enable_ipiv)
>> +				tertiary_exec_controls_setbit(vmx,
>> +						TERTIARY_EXEC_IPI_VIRT);
>> +		} else {
>>  			secondary_exec_controls_clearbit(vmx,
>>  					SECONDARY_EXEC_APIC_REGISTER_VIRT |
>>  					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
>> +			if (cpu_has_tertiary_exec_ctrls())
>> +				tertiary_exec_controls_clearbit(vmx,
>> +						TERTIARY_EXEC_IPI_VIRT);
>> +		}
>
>Why check for cpu_has_tertiary_exec_ctrls()? wouldn't it be always true
>(enable_ipiv has to be turned to false if CPU doesn't support IPIv,
>and if it does it will support tertiary exec controls).

yes. Checking enable_ipiv in two if()s above is enough.

>
>I don't mind this as a precaution + consistency with other code.
>
>
>>  	}
>>  
>>  	vmx_update_msr_bitmap_x2apic(vcpu);
>> @@ -4260,7 +4277,16 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
>>  
>>  static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
>>  {
>> -	return vmcs_config.cpu_based_3rd_exec_ctrl;
>> +	u64 exec_control = vmcs_config.cpu_based_3rd_exec_ctrl;
>> +
>> +	/*
>> +	 * IPI virtualization relies on APICv. Disable IPI
>> +	 * virtualization if APICv is inhibited.
>> +	 */
>> +	if (!enable_ipiv || !kvm_vcpu_apicv_active(&vmx->vcpu))
>> +		exec_control &= ~TERTIARY_EXEC_IPI_VIRT;
>
>I am not 100% sure, but kvm_vcpu_apicv_active might not be the
>best thing to check here, as it reflects per-cpu dynamic APICv inhibit.
>
>It probably works, but it might be better to use enable_apicv
>here and rely on normal APICv inhibit, and there inibit IPIv  as well
>as you do in vmx_refresh_apicv_exec_ctrl/
>

What's the difference between normal and per-cpu dynamic APICv inhibit?

>
>
>> +
>> +	return exec_control;
>>  }
>>  
>>  /*
>> @@ -4412,6 +4438,9 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>>  
>>  static void init_vmcs(struct vcpu_vmx *vmx)
>>  {
>> +	struct kvm_vcpu *vcpu = &vmx->vcpu;
>> +	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
>> +
>>  	if (nested)
>>  		nested_vmx_set_vmcs_shadowing_bitmap();
>>  
>> @@ -4431,7 +4460,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>>  	if (cpu_has_tertiary_exec_ctrls())
>>  		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
>>  
>> -	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
>> +	if (kvm_vcpu_apicv_active(vcpu)) {
>
>here too (pre-existing), I also not 100% sure that kvm_vcpu_apicv_active
>should be used. I haven't studied APICv code that much to be 100% sure.

I think kvm_vcpu_apicv_active is better.

The question is: If CPU supports a VMX feature (APICv), but it isn't enabled
now, is it allowed to configure VMCS fields defined by the feature?  Would CPU
ignore the values written to the fields or retain them after enabling the
feature later?

Personally, KVM shouldn't rely on CPU's behavior in this case. So, It is better
for KVM to write below VMCS fields only if APICv is enabled.

>
>
>>  		vmcs_write64(EOI_EXIT_BITMAP0, 0);
>>  		vmcs_write64(EOI_EXIT_BITMAP1, 0);
>>  		vmcs_write64(EOI_EXIT_BITMAP2, 0);
>> @@ -4441,6 +4470,13 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>>  
>>  		vmcs_write16(POSTED_INTR_NV, POSTED_INTR_VECTOR);
>>  		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
>> +
>> +		if (enable_ipiv) {
>> +			WRITE_ONCE(kvm_vmx->pid_table[vcpu->vcpu_id],
>> +				__pa(&vmx->pi_desc) | PID_TABLE_ENTRY_VALID);
>> +			vmcs_write64(PID_POINTER_TABLE, __pa(kvm_vmx->pid_table));
>> +			vmcs_write16(LAST_PID_POINTER_INDEX, kvm_vmx->pid_last_index);
>> +		}
>>  	}
>>  
>>  	if (!kvm_pause_in_guest(vmx->vcpu.kvm)) {
>> @@ -4492,7 +4528,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>>  		vmcs_write16(GUEST_PML_INDEX, PML_ENTITY_NUM - 1);
>>  	}
>>  
>> -	vmx_write_encls_bitmap(&vmx->vcpu, NULL);
>> +	vmx_write_encls_bitmap(vcpu, NULL);
>
>I might have separated the refactoring of using vcpu instead of &vmx->vcpu
>in a separate patch, but I don't mind that that much.
>
>>  
>>  	if (vmx_pt_mode_is_host_guest()) {
>>  		memset(&vmx->pt_desc, 0, sizeof(vmx->pt_desc));
>> @@ -4508,7 +4544,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>>  
>>  	if (cpu_has_vmx_tpr_shadow()) {
>>  		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, 0);
>> -		if (cpu_need_tpr_shadow(&vmx->vcpu))
>> +		if (cpu_need_tpr_shadow(vcpu))
>>  			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
>>  				     __pa(vmx->vcpu.arch.apic->regs));
>>  		vmcs_write32(TPR_THRESHOLD, 0);
>> @@ -7165,6 +7201,18 @@ static int vmx_vm_init(struct kvm *kvm)
>>  			break;
>>  		}
>>  	}
>> +
>> +	if (enable_ipiv) {
>> +		struct page *pages;
>> +
>> +		pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, MAX_PID_TABLE_ORDER);
>> +		if (!pages)
>> +			return -ENOMEM;
>> +
>> +		to_kvm_vmx(kvm)->pid_table = (void *)page_address(pages);
>> +		to_kvm_vmx(kvm)->pid_last_index = KVM_MAX_VCPU_IDS - 1;
>> +	}
>> +
>>  	return 0;
>>  }
>>  
>> @@ -7756,6 +7804,14 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
>>  	return supported & BIT(bit);
>>  }
>>  
>> +static void vmx_vm_destroy(struct kvm *kvm)
>> +{
>> +	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
>> +
>> +	if (kvm_vmx->pid_table)
>> +		free_pages((unsigned long)kvm_vmx->pid_table, MAX_PID_TABLE_ORDER);
>
>Maybe add a warning checking that ipiv was actually enabled.

Do you mean ipiv was enabled on one of vCPU or just enable_ipiv is true?

The former will lead to false positives if qemu creates a VM and destroys the
vm without creating any vCPUs.

>Maybe this is overkill.
>
>
>> +}
>> +
>>  static struct kvm_x86_ops vmx_x86_ops __initdata = {
>>  	.name = "kvm_intel",
>>  
>> @@ -7768,6 +7824,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>>  
>>  	.vm_size = sizeof(struct kvm_vmx),
>>  	.vm_init = vmx_vm_init,
>> +	.vm_destroy = vmx_vm_destroy,
>>  
>>  	.vcpu_create = vmx_create_vcpu,
>>  	.vcpu_free = vmx_free_vcpu,
>> @@ -8022,6 +8079,9 @@ static __init int hardware_setup(void)
>>  	if (!enable_apicv)
>>  		vmx_x86_ops.sync_pir_to_irr = NULL;
>>  
>> +	if (!enable_apicv || !cpu_has_vmx_ipiv())
>> +		enable_ipiv = false;
>> +
>>  	if (cpu_has_vmx_tsc_scaling()) {
>>  		kvm_has_tsc_control = true;
>>  		kvm_max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index d4a647d3ed4a..e7b0c00c9d43 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -365,6 +365,9 @@ struct kvm_vmx {
>>  	unsigned int tss_addr;
>>  	bool ept_identity_pagetable_done;
>>  	gpa_t ept_identity_map_addr;
>> +	/* PID table for IPI virtualization */
>> +	u64 *pid_table;
>> +	u16 pid_last_index;
>>  };
>>  
>>  bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
>
>
>I might have missed something, but overall looks good.

Thanks.
