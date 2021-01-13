Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECDE2F42E8
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 05:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbhAMENd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 23:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbhAMENc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 23:13:32 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8831CC061786;
        Tue, 12 Jan 2021 20:12:52 -0800 (PST)
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 10D4A3aN012275;
        Wed, 13 Jan 2021 04:12:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=OzBnbT3IipsUayNk40s71YKWo1M4VfIXRFpPOdBBVCc=;
 b=KtgEl1/bOjQpIw+uK0tJk4nILNqtfMbWHp9SE36POfFClInNU1DA89YxlNLsMvkEfxxN
 Qhd5jWJYXYUIa9i9NkFEhrwT1t39nngJKAv7n+f9C8HeY2iTiafhRgaoCvNcHy4SaZvV
 MGqak/cBhC7haWRvHW6+PmZ4nkv5eM+mxw+rHNd7MF12pYBKJJWL+z+ccinw2U/BtStf
 NpleO5yLoIcCwGaBUjUOjWFEb+EiH18jyy4pd5MQgmQEAa6BJ2bT/TttTAjkzSKHTn/+
 a3kKTx1gWyCk4q/fGMZuyeN4Q3eDxhGKzmLz3vEMfC2aSsAyFB1ij64adiznn4HAf/9y Cg== 
Received: from prod-mail-ppoint4 (a72-247-45-32.deploy.static.akamaitechnologies.com [72.247.45.32] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 35yq228yvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:12:22 +0000
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10D453vJ017950;
        Tue, 12 Jan 2021 23:12:22 -0500
Received: from prod-mail-relay18.dfw02.corp.akamai.com ([172.27.165.172])
        by prod-mail-ppoint4.akamai.com with ESMTP id 35y8q3e9kq-1;
        Tue, 12 Jan 2021 23:12:22 -0500
Received: from [0.0.0.0] (unknown [172.27.119.138])
        by prod-mail-relay18.dfw02.corp.akamai.com (Postfix) with ESMTP id 63927503;
        Wed, 13 Jan 2021 04:12:21 +0000 (GMT)
Subject: Re: [PATCH 1/2] KVM: x86: introduce definitions to support static
 calls for kvm_x86_ops
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, peterz@infradead.org,
        aarcange@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
References: <cover.1610379877.git.jbaron@akamai.com>
 <ce483ce4a1920a3c1c4e5deea11648d75f2a7b80.1610379877.git.jbaron@akamai.com>
 <X/4q/OKvW9RKQ+gk@google.com>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <1784355c-e53e-5363-31e3-faeba4ba9e8f@akamai.com>
Date:   Tue, 12 Jan 2021 23:12:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <X/4q/OKvW9RKQ+gk@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_02:2021-01-12,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=742
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130021
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_02:2021-01-12,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxscore=0 clxscore=1011 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=647 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130022
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.32)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/21 6:04 PM, Sean Christopherson wrote:
> On Mon, Jan 11, 2021, Jason Baron wrote:
>> Use static calls to improve kvm_x86_ops performance. Introduce the
>> definitions that will be used by a subsequent patch to actualize the
>> savings.
>>
>> Note that all kvm_x86_ops are covered here except for 'pmu_ops' and
>> 'nested ops'. I think they can be covered by static calls in a simlilar
>> manner, but were omitted from this series to reduce scope and because
>> I don't think they have as large of a performance impact.
>>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Signed-off-by: Jason Baron <jbaron@akamai.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h | 65 +++++++++++++++++++++++++++++++++++++++++
>>   arch/x86/kvm/x86.c              |  5 ++++
>>   2 files changed, 70 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 3ab7b46..e947522 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1087,6 +1087,65 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
>>   	return dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
>>   }
>>   
>> +/*
>> + * static calls cover all kvm_x86_ops except for functions under pmu_ops and
>> + * nested_ops.
>> + */
>> +#define FOREACH_KVM_X86_OPS(F) \
>> +	F(hardware_enable); F(hardware_disable); F(hardware_unsetup);	       \
>> +	F(cpu_has_accelerated_tpr); F(has_emulated_msr);		       \
>> +	F(vcpu_after_set_cpuid); F(vm_init); F(vm_destroy); F(vcpu_create);    \
>> +	F(vcpu_free); F(vcpu_reset); F(prepare_guest_switch); F(vcpu_load);    \
>> +	F(vcpu_put); F(update_exception_bitmap); F(get_msr); F(set_msr);       \
>> +	F(get_segment_base); F(get_segment); F(get_cpl); F(set_segment);       \
>> +	F(get_cs_db_l_bits); F(set_cr0); F(is_valid_cr4); F(set_cr4);	       \
>> +	F(set_efer); F(get_idt); F(set_idt); F(get_gdt); F(set_gdt);	       \
>> +	F(sync_dirty_debug_regs); F(set_dr7); F(cache_reg); F(get_rflags);     \
>> +	F(set_rflags); F(tlb_flush_all); F(tlb_flush_current);		       \
>> +	F(tlb_remote_flush); F(tlb_remote_flush_with_range); F(tlb_flush_gva); \
>> +	F(tlb_flush_guest); F(run); F(handle_exit);			       \
>> +	F(skip_emulated_instruction); F(update_emulated_instruction);	       \
>> +	F(set_interrupt_shadow); F(get_interrupt_shadow); F(patch_hypercall);  \
>> +	F(set_irq); F(set_nmi); F(queue_exception); F(cancel_injection);       \
>> +	F(interrupt_allowed); F(nmi_allowed); F(get_nmi_mask); F(set_nmi_mask);\
>> +	F(enable_nmi_window); F(enable_irq_window); F(update_cr8_intercept);   \
>> +	F(check_apicv_inhibit_reasons); F(pre_update_apicv_exec_ctrl);	       \
>> +	F(refresh_apicv_exec_ctrl); F(hwapic_irr_update); F(hwapic_isr_update);\
>> +	F(guest_apic_has_interrupt); F(load_eoi_exitmap);		       \
>> +	F(set_virtual_apic_mode); F(set_apic_access_page_addr);		       \
>> +	F(deliver_posted_interrupt); F(sync_pir_to_irr); F(set_tss_addr);      \
>> +	F(set_identity_map_addr); F(get_mt_mask); F(load_mmu_pgd);	       \
>> +	F(has_wbinvd_exit); F(write_l1_tsc_offset); F(get_exit_info);	       \
>> +	F(check_intercept); F(handle_exit_irqoff); F(request_immediate_exit);  \
>> +	F(sched_in); F(slot_enable_log_dirty); F(slot_disable_log_dirty);      \
>> +	F(flush_log_dirty); F(enable_log_dirty_pt_masked);		       \
>> +	F(cpu_dirty_log_size); F(pre_block); F(post_block); F(vcpu_blocking);  \
>> +	F(vcpu_unblocking); F(update_pi_irte); F(apicv_post_state_restore);    \
>> +	F(dy_apicv_has_pending_interrupt); F(set_hv_timer); F(cancel_hv_timer);\
>> +	F(setup_mce); F(smi_allowed); F(pre_enter_smm); F(pre_leave_smm);      \
>> +	F(enable_smi_window); F(mem_enc_op); F(mem_enc_reg_region);	       \
>> +	F(mem_enc_unreg_region); F(get_msr_feature);			       \
>> +	F(can_emulate_instruction); F(apic_init_signal_blocked);	       \
>> +	F(enable_direct_tlbflush); F(migrate_timers); F(msr_filter_changed);   \
>> +	F(complete_emulated_msr)
> What about adding a dedicated .h file for this beast?  Then it won't be so
> painful to do one function per line.  As is, updates to kvm_x86_ops will be
> messy.
Hi,

I'm fine moving it to a new header. I had put it right above
'struct kvm_x86_ops' in arch/x86/include/asm/kvm_host.h, such
that it would be updated along with kvm_x86_ops changes. But
I can put a big comment there to update the new header.

>
> And add yet another macro layer (or maybe just tweak this one?) so that the
> caller controls the line ending?  I suppose you could also just use a comma, but
> that's a bit dirty...
>
> That would also allow using this to declare vmx_x86_ops and svm_x86_ops, which
> would need a comma insteat of a semi-colon.  There have a been a few attempts to
> add a bit of automation to {vmx,svm}_x86_ops, this seems like it would be good
> motivation to go in a different direction and declare/define all ops, e.g. the
> VMX/SVM code could simply do something like:
>
> #define DECLARE_VMX_X86_OP(func) \
> 	.func = vmx_##func
>
> static struct kvm_x86_ops vmx_x86_ops __initdata = {
> 	.vm_size = sizeof(struct kvm_vmx),
> 	.vm_init = vmx_vm_init,
>
> 	.pmu_ops = &intel_pmu_ops,
> 	.nested_ops = &vmx_nested_ops,
>
> 	FOREACH_KVM_X86_OPS(DECLARE_VMX_X86_OP)
> };
>
Looking at the vmx definitions I see quite a few that don't
match that naming. For example:

hardware_unsetup,
hardware_enable,
hardware_disable,
report_flexpriority,
update_exception_bitmap,
enable_nmi_window,
enable_irq_window,
update_cr8_intercept,
pi_has_pending_interrupt,
cpu_has_vmx_wbinvd_exit,
pi_update_irte,
kvm_complete_insn_gp,

So I'm not sure if we want to extend these macros to
vmx/svm.

Thanks,

-Jason
