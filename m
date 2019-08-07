Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3728440D
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 07:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbfHGF4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 01:56:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:41058 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbfHGF4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 01:56:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 22:56:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,356,1559545200"; 
   d="scan'208";a="325857009"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by orsmga004.jf.intel.com with ESMTP; 06 Aug 2019 22:56:50 -0700
Message-ID: <5D4A697D.3030604@intel.com>
Date:   Wed, 07 Aug 2019 14:02:37 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, peterz@infradead.org, pbonzini@redhat.com
CC:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, jannh@google.com, arei.gonglei@huawei.com,
        jmattson@google.com
Subject: Re: [PATCH v8 13/14] KVM/x86/vPMU: check the lbr feature before entering
 guest
References: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com> <1565075774-26671-14-git-send-email-wei.w.wang@intel.com>
In-Reply-To: <1565075774-26671-14-git-send-email-wei.w.wang@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2019 03:16 PM, Wei Wang wrote:
> The guest can access the lbr related msrs only when the vcpu's lbr event
> has been assigned the lbr feature. A cpu pinned lbr event (though no such
> event usages in the current upstream kernel) could reclaim the lbr feature
> from the vcpu's lbr event (task pinned) via ipi calls. If the cpu is
> running in the non-root mode, this will cause the cpu to vm-exit to handle
> the host ipi and then vm-entry back to the guest. So on vm-entry (where
> interrupt has been disabled), we double confirm that the vcpu's lbr event
> is still assigned the lbr feature via checking event->oncpu.
>
> The pass-through of the lbr related msrs will be cancelled if the lbr is
> reclaimed, and the following guest accesses to the lbr related msrs will
> vm-exit to the related msr emulation handler in kvm, which will prevent
> the accesses.
>
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> ---
>   arch/x86/kvm/pmu.c           |  6 ++++++
>   arch/x86/kvm/pmu.h           |  3 +++
>   arch/x86/kvm/vmx/pmu_intel.c | 35 +++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/x86.c           | 13 +++++++++++++
>   4 files changed, 57 insertions(+)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index afad092..ed10a57 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -339,6 +339,12 @@ bool kvm_pmu_lbr_enable(struct kvm_vcpu *vcpu)
>   	return false;
>   }
>   
> +void kvm_pmu_enabled_feature_confirm(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_x86_ops->pmu_ops->enabled_feature_confirm)
> +		kvm_x86_ops->pmu_ops->enabled_feature_confirm(vcpu);
> +}
> +
>   void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
>   {
>   	if (lapic_in_kernel(vcpu))
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index f875721..7467907 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -30,6 +30,7 @@ struct kvm_pmu_ops {
>   	int (*is_valid_msr_idx)(struct kvm_vcpu *vcpu, unsigned idx);
>   	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
>   	bool (*lbr_enable)(struct kvm_vcpu *vcpu);
> +	void (*enabled_feature_confirm)(struct kvm_vcpu *vcpu);
>   	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
>   	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
>   	void (*sched_in)(struct kvm_vcpu *vcpu, int cpu);
> @@ -126,6 +127,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
>   
>   bool is_vmware_backdoor_pmc(u32 pmc_idx);
>   
> +void kvm_pmu_enabled_feature_confirm(struct kvm_vcpu *vcpu);
> +
>   extern struct kvm_pmu_ops intel_pmu_ops;
>   extern struct kvm_pmu_ops amd_pmu_ops;
>   #endif /* __KVM_X86_PMU_H */
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 5580f1a..421051aa 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -781,6 +781,40 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>   	intel_pmu_free_lbr_event(vcpu);
>   }
>   
> +void intel_pmu_lbr_confirm(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +	/*
> +	 * Either lbr_event being NULL or lbr_used being false indicates that
> +	 * the lbr msrs haven't been passed through to the guest, so no need
> +	 * to cancel passthrough.
> +	 */
> +	if (!pmu->lbr_event || !pmu->lbr_used)
> +		return;
> +
> +	/*
> +	 * The lbr feature gets reclaimed via IPI calls, so checking of
> +	 * lbr_event->oncpu needs to be in an atomic context. Just confirm
> +	 * that irq has been disabled already.
> +	 */
> +	lockdep_assert_irqs_disabled();
> +
> +	/*
> +	 * Cancel the pass-through of the lbr msrs if lbr has been reclaimed
> +	 * by the host perf.
> +	 */
> +	if (pmu->lbr_event->oncpu != -1) {

A mistake here,  should be "pmu->lbr_event->oncpu == -1".
(It didn't seem to affect the profiling result, but generated
more vm-exits due to mistakenly cancelling the passthrough)

Best,
Wei
