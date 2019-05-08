Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CECE31814B
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 22:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfEHUpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 16:45:35 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:39122 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfEHUpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 16:45:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1557348333; x=1588884333;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=fRktyHK08gAejh+Vv3mW2pCITaJS78+z4dEb3KElo/s=;
  b=ieO3X0C6awEerE746/A5G+h2b5zLI0DTRj0EdqV/7jgO0XYc/C702ndN
   HZdoYP11GxSsGaoXwMcrRpExkTcl8SbAP1qtne+nsj9gEZnT3ekKpAzvZ
   d47tkkRpZ+q04eq+eDJt6TpbvGhOn97fNIBurzpTGAx7iBXJbbVvdLuU6
   0=;
X-IronPort-AV: E=Sophos;i="5.60,447,1549929600"; 
   d="scan'208";a="732337641"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 08 May 2019 20:45:31 +0000
Received: from u7588a65da6b65f.ant.amazon.com (iad7-ws-svc-lb50-vlan3.amazon.com [10.0.93.214])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x48KjRQR075941
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Wed, 8 May 2019 20:45:29 GMT
Received: from u7588a65da6b65f.ant.amazon.com (localhost [127.0.0.1])
        by u7588a65da6b65f.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x48KjPU3013195;
        Wed, 8 May 2019 22:45:25 +0200
Subject: Re: [PATCH 5/6] KVM: x86: Add interface for run-time
 activate/de-activate APIC virtualization
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "joro@8bytes.org" <joro@8bytes.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
References: <20190322115702.10166-1-suravee.suthikulpanit@amd.com>
 <20190322115702.10166-6-suravee.suthikulpanit@amd.com>
From:   =?UTF-8?Q?Jan_H=2e_Sch=c3=b6nherr?= <jschoenh@amazon.de>
Openpgp: preference=signencrypt
Message-ID: <40e77d98-dabd-a478-9848-29f29d0bf185@amazon.de>
Date:   Wed, 8 May 2019 22:45:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190322115702.10166-6-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/2019 12.57, Suthikulpanit, Suravee wrote:
> When activate / deactivate AVIC during runtime, all vcpus has to be
> operating in the same mode. So, introduce new interface to request
> all vCPUs to activate/deactivate APICV.

If we need to switch APICV on and off on all vCPUs of a VM, shouldn't
we have a variable somewhere, that tells us, whether AVIC is
currently activated/deactivated in the VM?

The logic in patch 6/6, that triggers changes of this global state based
on just local information, feels prone to race conditions otherwise.

(Consider, for example, that two vCPUs have to handle ExtINTs at the same
time. Shouldn't we prevent AVIC from getting activated when just one of
the two vCPUs is done? That is, re-enable AVIC only when no vCPU is
handling an ExtINT anymore?)

Also, now that vcpu->apic.apicv_active is dynamic, there are a
few more places, where it must be updated, I think:

a) In kvm_arch_vcpu_init() a newly created vCPU needs to be
   initialized with the correct global state, so that vCPU
   hotplugging does not lead to a mixture of APICV states.

b) At some point during vCPU restore, so that APICV does not end
   up being enabled if there was an ExtINT pending in the VM
   snapshot.

c) Probably during vCPU reset as well, in case the ExtINT is cleared.

Regards
Jan

> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  8 ++++++
>  arch/x86/kvm/x86.c              | 48 +++++++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1906e205e6a3..31dee26a37f2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -79,6 +79,10 @@
>  #define KVM_REQ_HV_STIMER		KVM_ARCH_REQ(22)
>  #define KVM_REQ_LOAD_EOI_EXITMAP	KVM_ARCH_REQ(23)
>  #define KVM_REQ_GET_VMCS12_PAGES	KVM_ARCH_REQ(24)
> +#define KVM_REQ_APICV_ACTIVATE		\
> +	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> +#define KVM_REQ_APICV_DEACTIVATE	\
> +	KVM_ARCH_REQ_FLAGS(26, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  
>  #define CR0_RESERVED_BITS                                               \
>  	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> @@ -1537,6 +1541,10 @@ bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
>  
>  void kvm_make_mclock_inprogress_request(struct kvm *kvm);
>  void kvm_make_scan_ioapic_request(struct kvm *kvm);
> +void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_activate_apicv(struct kvm_vcpu *vcpu);
> +void kvm_make_apicv_activate_request(struct kvm *kvm);
> +void kvm_make_apicv_deactivate_request(struct kvm *kvm);
>  
>  void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  				     struct kvm_async_pf *work);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 65e4559eef2f..1cd49c394680 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -29,6 +29,7 @@
>  #include "cpuid.h"
>  #include "pmu.h"
>  #include "hyperv.h"
> +#include "lapic.h"
>  
>  #include <linux/clocksource.h>
>  #include <linux/interrupt.h>
> @@ -7054,6 +7055,22 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsigned long flags, int apicid)
>  	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
>  }
>  
> +void kvm_vcpu_activate_apicv(struct kvm_vcpu *vcpu)
> +{
> +	if (!lapic_in_kernel(vcpu)) {
> +		WARN_ON_ONCE(!vcpu->arch.apicv_active);
> +		return;
> +	}
> +	if (vcpu->arch.apicv_active)
> +		return;
> +
> +	vcpu->arch.apicv_active = true;
> +	kvm_apic_update_apicv(vcpu);
> +
> +	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
> +}
> +EXPORT_SYMBOL_GPL(kvm_vcpu_activate_apicv);
> +
>  void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
>  {
>  	if (!lapic_in_kernel(vcpu)) {
> @@ -7064,8 +7081,11 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
>  		return;
>  
>  	vcpu->arch.apicv_active = false;
> +	kvm_apic_update_apicv(vcpu);
> +
>  	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
>  }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_deactivate_apicv);
>  
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  {
> @@ -7557,6 +7577,30 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
>  }
>  
> +void kvm_make_apicv_activate_request(struct kvm *kvm)
> +{
> +	int i;
> +	struct kvm_vcpu *v;
> +
> +	kvm_for_each_vcpu(i, v, kvm)
> +		kvm_clear_request(KVM_REQ_APICV_DEACTIVATE, v);
> +
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_ACTIVATE);
> +}
> +EXPORT_SYMBOL_GPL(kvm_make_apicv_activate_request);
> +
> +void kvm_make_apicv_deactivate_request(struct kvm *kvm)
> +{
> +	int i;
> +	struct kvm_vcpu *v;
> +
> +	kvm_for_each_vcpu(i, v, kvm)
> +		kvm_clear_request(KVM_REQ_APICV_ACTIVATE, v);
> +
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_DEACTIVATE);
> +}
> +EXPORT_SYMBOL_GPL(kvm_make_apicv_deactivate_request);
> +
>  static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
>  {
>  	if (!kvm_apic_present(vcpu))
> @@ -7743,6 +7787,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		 */
>  		if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
>  			kvm_hv_process_stimers(vcpu);
> +		if (kvm_check_request(KVM_REQ_APICV_ACTIVATE, vcpu))
> +			kvm_vcpu_activate_apicv(vcpu);
> +		if (kvm_check_request(KVM_REQ_APICV_DEACTIVATE, vcpu))
> +			kvm_vcpu_deactivate_apicv(vcpu);
>  	}
>  
>  	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
> 

