Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C03719DEC6
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 09:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfH0HaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 03:30:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfH0HaC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 03:30:02 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 31D94793EC
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 07:30:01 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id k14so10967411wrv.2
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 00:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=tzpaUY3y3WH17cKjGn22YzRpbIG1ICBw0KXuiHmJ9MQ=;
        b=LWpVyYgw5YWjUcp7QIhJ6YqY56ZoB8XAuUNWrFaAHz08VrLq75Qi5eSkfpXD0b0HKb
         9ZDwoPU6oT7lZt/li99i7oVP86oEYIIPnRAX5qKhY416RjrA0H6KeEzwmgIcMCj3lQHt
         7kbHGzewzSmwODTXjUNFCghZF3RnG2TtCRI3p/G89Ql0wBjMReEa5d778B3/g+MeKkO4
         YhhMQQ610rwzPmrC+kgiBxRYMaAaQEm+5y9nOEYlnr4Kv3OfbHgO5pOgAanUDU8Qbbye
         /PfjqXBWCYICSGACanURM583KYPY6ZooF82OHBUr7T8jmcDHt/g44CPBQAVb1e58sP3w
         gmBw==
X-Gm-Message-State: APjAAAXYjSwSqPVQ2j6NWBhUG2rVEGYCWtNVp1I0zQBCc6hxnFeAdHEG
        q+P+RHGpLVANi69OtpuJ33kh/L2tnjO9b8puBlUv2mstORvorPPLf8Orlmr8km2i/h1hMdlqyOq
        eiV0C65ahP0w3
X-Received: by 2002:a05:600c:54c:: with SMTP id k12mr26425294wmc.117.1566890999891;
        Tue, 27 Aug 2019 00:29:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzpHlqI1rpHzpEO2s5ZEDjABIR0jLoTKWEy56u3icHhCCHLrLgzKnNdg5r6QuBK4RfEyuULng==
X-Received: by 2002:a05:600c:54c:: with SMTP id k12mr26425276wmc.117.1566890999609;
        Tue, 27 Aug 2019 00:29:59 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-161-20.net.upcbroadband.cz. [89.176.161.20])
        by smtp.gmail.com with ESMTPSA id e11sm38902526wrc.4.2019.08.27.00.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 00:29:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Suthikulpanit\, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar\@redhat.com" <rkrcmar@redhat.com>,
        "joro\@8bytes.org" <joro@8bytes.org>,
        "graf\@amazon.com" <graf@amazon.com>,
        "jschoenh\@amazon.de" <jschoenh@amazon.de>,
        "karahmed\@amazon.de" <karahmed@amazon.de>,
        "rimasluk\@amazon.com" <rimasluk@amazon.com>,
        "Grimm\, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit\, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH v2 06/15] kvm: x86: Add support for activate/de-activate APICv at runtime
In-Reply-To: <1565886293-115836-7-git-send-email-suravee.suthikulpanit@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com> <1565886293-115836-7-git-send-email-suravee.suthikulpanit@amd.com>
Date:   Tue, 27 Aug 2019 09:29:58 +0200
Message-ID: <877e6zm5ft.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com> writes:

> Certain runtime conditions require APICv to be temporary deactivated.
> However, current implementation only support permanently deactivate
> APICv at runtime (mainly used when running Hyper-V guest).
>
> In addtion, for AMD, when activate / deactivate APICv during runtime,
> all vcpus in the VM has to be operating in the same APICv mode, which
> requires the requesting (main) vcpu to notify others.
>
> So, introduce interfaces to request all vcpus to activate/deactivate
> APICv.
>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  9 +++++
>  arch/x86/kvm/x86.c              | 76 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 85 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 04d7066..dfb7c3d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -76,6 +76,10 @@
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
> @@ -1089,6 +1093,7 @@ struct kvm_x86_ops {
>  	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
>  	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
>  	bool (*get_enable_apicv)(struct kvm *kvm);
> +	void (*pre_update_apicv_exec_ctrl)(struct kvm_vcpu *vcpu, bool activate);
>  	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
>  	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
>  	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
> @@ -1552,6 +1557,10 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>  
>  void kvm_make_mclock_inprogress_request(struct kvm *kvm);
>  void kvm_make_scan_ioapic_request(struct kvm *kvm);
> +void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_activate_apicv(struct kvm_vcpu *vcpu);
> +void kvm_make_apicv_activate_request(struct kvm_vcpu *vcpu);
> +void kvm_make_apicv_deactivate_request(struct kvm_vcpu *vcpu, bool disable);
>  
>  void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  				     struct kvm_async_pf *work);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f9c3f63..40a20bf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -26,6 +26,7 @@
>  #include "cpuid.h"
>  #include "pmu.h"
>  #include "hyperv.h"
> +#include "lapic.h"
>  
>  #include <linux/clocksource.h>
>  #include <linux/interrupt.h>
> @@ -7163,6 +7164,22 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsigned long flags, int apicid)
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
> @@ -7173,8 +7190,11 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
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
> @@ -7668,6 +7688,58 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
>  }
>  
> +void kvm_make_apicv_activate_request(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +	struct kvm_vcpu *v;
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	mutex_lock(&kvm->arch.apicv_lock);
> +	if (kvm->arch.apicv_state != APICV_DEACTIVATED) {
> +		mutex_unlock(&kvm->arch.apicv_lock);
> +		return;
> +	}
> +
> +	kvm_for_each_vcpu(i, v, kvm)
> +		kvm_clear_request(KVM_REQ_APICV_DEACTIVATE, v);
> +
> +	if (kvm_x86_ops->pre_update_apicv_exec_ctrl)
> +		kvm_x86_ops->pre_update_apicv_exec_ctrl(vcpu, true);
> +
> +	kvm->arch.apicv_state = APICV_ACTIVATED;
> +
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_ACTIVATE);
> +
> +	mutex_unlock(&kvm->arch.apicv_lock);
> +}
> +EXPORT_SYMBOL_GPL(kvm_make_apicv_activate_request);
> +
> +void kvm_make_apicv_deactivate_request(struct kvm_vcpu *vcpu, bool disable)
> +{
> +	int i;
> +	struct kvm_vcpu *v;
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	mutex_lock(&kvm->arch.apicv_lock);
> +	if (kvm->arch.apicv_state == APICV_DEACTIVATED) {
> +		mutex_unlock(&kvm->arch.apicv_lock);
> +		return;
> +	}
> +
> +	kvm_for_each_vcpu(i, v, kvm)
> +		kvm_clear_request(KVM_REQ_APICV_ACTIVATE, v);

Could you please elaborate on when we need to eat the
KVM_REQ_APICV_ACTIVATE request here (and KVM_REQ_APICV_DEACTIVATE in
kvm_make_apicv_activate_request() respectively)? To me, this looks like
a possible source of hard-to-debug problems in the future.

> +
> +	if (kvm_x86_ops->pre_update_apicv_exec_ctrl)
> +		kvm_x86_ops->pre_update_apicv_exec_ctrl(vcpu, false);
> +
> +	kvm->arch.apicv_state = disable ? APICV_DISABLED : APICV_DEACTIVATED;
> +
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_DEACTIVATE);
> +
> +	mutex_unlock(&kvm->arch.apicv_lock);
> +}
> +EXPORT_SYMBOL_GPL(kvm_make_apicv_deactivate_request);
> +
>  static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
>  {
>  	if (!kvm_apic_present(vcpu))
> @@ -7854,6 +7926,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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

-- 
Vitaly
