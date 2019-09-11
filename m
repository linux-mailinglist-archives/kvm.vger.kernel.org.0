Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F08B0187
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 18:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfIKQXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 12:23:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727839AbfIKQXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 12:23:41 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD7A63A206
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 16:23:40 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id m6so1451935wmf.2
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 09:23:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TZa8OCox9HlqM6NUNYP9UkHhCo++a+Y6E6be+FW3znQ=;
        b=ANB4NfbWIKq0YmYWMFcf0KAv05+H/YJIn7Kqiy4vuDMpdRKnJM6HaZqMrN98427s6a
         v429eedpQtXozt1rfs1ot5EFel0vIocgQqeC8fjHLy3lA7SGvOJUo6iCtJaecMqPW4S9
         UxWTkOqcwIRV0YZ3VVxUw3Ji6tcksT/WWgCw2F9EaYAD9OpEdFJ7VTzd9LOq+NV/F6yJ
         Mm9noh8GCcm/nJVXCjT/mybuCHdihc65gTI8RSu27h3F84TMt9Odv3Ex30mmGtEiE6Y8
         72RyagVW1IY/AoXAEppG15f1AdHZ0NcMVdl61dqXegFkUNWzL+C+TbdnaoPOY1+3N4tY
         UNww==
X-Gm-Message-State: APjAAAUzV2fRgu3Cwe85WVDBHPGQX68DnNBU8GyAfXC6QynZNWFIsCcD
        PeNMRJ93VbV6ktbam6sjZyB8CaTcmGURqkU3wdtRVq12skkFITl8+wumznc+yag+7bq4AF7NUlI
        xHGqP1OwYiBHB
X-Received: by 2002:a5d:6951:: with SMTP id r17mr2131563wrw.208.1568219019507;
        Wed, 11 Sep 2019 09:23:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyTkildgBFXFSBSBNWLhnD7vhrtLCBipEHiJTeZt5sfg/aT2mmbRyoOoxzsOmr+6pdGk2psnQ==
X-Received: by 2002:a5d:6951:: with SMTP id r17mr2131543wrw.208.1568219019231;
        Wed, 11 Sep 2019 09:23:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:102b:3795:6714:7df6? ([2001:b07:6468:f312:102b:3795:6714:7df6])
        by smtp.gmail.com with ESMTPSA id r28sm29998141wrr.94.2019.09.11.09.23.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 09:23:38 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86: Fix INIT signal handling in various CPU
 states
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
References: <20190826102449.142687-1-liran.alon@oracle.com>
 <20190826102449.142687-3-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2a36ca45-56fa-5d4e-7b8c-157190f29f82@redhat.com>
Date:   Wed, 11 Sep 2019 18:23:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826102449.142687-3-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/08/19 12:24, Liran Alon wrote:
>  	/*
> -	 * INITs are latched while in SMM.  Because an SMM CPU cannot
> -	 * be in KVM_MP_STATE_INIT_RECEIVED state, just eat SIPIs
> -	 * and delay processing of INIT until the next RSM.
> +	 * INITs are latched while CPU is in specific states.
> +	 * Because a CPU cannot be in these states immediately
> +	 * after it have processed an INIT signal (and thus in
> +	 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
> +	 * and delay processing of INIT until CPU leaves
> +	 * the state which latch INIT signal.
>  	 */
> -	if (is_smm(vcpu)) {
> +	if (kvm_x86_ops->apic_init_signal_blocked(vcpu)) {

I'd prefer keeping is_smm(vcpu) here, since that is not vendor-specific.

Together with some edits to the comments, this is what I got.
Let me know if you prefer to have the latched_init changes
on top, or you'd like to post v2 with everything.

Thanks,

Paolo

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c4f271a9b306..b523949a8df8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1209,6 +1209,8 @@ struct kvm_x86_ops {
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
 
 	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
+
+	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 559e1c4c0832..dbbe4781fbb2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2706,11 +2706,14 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 		return;
 
 	/*
-	 * INITs are latched while in SMM.  Because an SMM CPU cannot
-	 * be in KVM_MP_STATE_INIT_RECEIVED state, just eat SIPIs
-	 * and delay processing of INIT until the next RSM.
+	 * INITs are latched while CPU is in specific states
+	 * (SMM, VMX non-root mode, SVM with GIF=0).
+	 * Because a CPU cannot be in these states immediately
+	 * after it has processed an INIT signal (and thus in
+	 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
+	 * and leave the INIT pending.
 	 */
-	if (is_smm(vcpu)) {
+	if (is_smm(vcpu) || kvm_x86_ops->apic_init_signal_blocked(vcpu)) {
 		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
 		if (test_bit(KVM_APIC_SIPI, &apic->pending_events))
 			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2854aafc489e..d24050b647c7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7170,6 +7170,21 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/*
+	 * TODO: Last condition latch INIT signals on vCPU when
+	 * vCPU is in guest-mode and vmcb12 defines intercept on INIT.
+	 * To properly emulate the INIT intercept, SVM should implement
+	 * kvm_x86_ops->check_nested_events() and call nested_svm_vmexit()
+	 * there if an INIT signal is pending.
+	 */
+	return !gif_set(svm) ||
+		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7306,6 +7321,8 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 	.nested_get_evmcs_version = nested_get_evmcs_version,
 
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
+
+	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ad2453317c4b..6ce83c602e7f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3409,6 +3409,15 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
 	unsigned long exit_qual;
 	bool block_nested_events =
 	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (lapic_in_kernel(vcpu) &&
+		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
+		if (block_nested_events)
+			return -EBUSY;
+		nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
+		return 0;
+	}
 
 	if (vcpu->arch.exception.pending &&
 		nested_vmx_check_exception(vcpu, &exit_qual)) {
@@ -4470,7 +4479,12 @@ static int handle_vmoff(struct kvm_vcpu *vcpu)
 {
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
+
 	free_nested(vcpu);
+
+	/* Process a latched INIT during time CPU was in VMX operation */
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
 	return nested_vmx_succeed(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 99f52f8c969a..73bf9a2e6fb6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7470,6 +7470,11 @@ static bool vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
+{
+	return to_vmx(vcpu)->nested.vmxon;
+}
+
 static __init int hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
@@ -7794,6 +7799,7 @@ static __exit void hardware_unsetup(void)
 	.get_vmcs12_pages = NULL,
 	.nested_enable_evmcs = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
+	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 };
 
 static void vmx_cleanup_l1d_flush(void)
