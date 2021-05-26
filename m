Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D5D39141E
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 11:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbhEZJz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 05:55:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30206 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233330AbhEZJz4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 05:55:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622022865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mnuvu4co2BY5mdQTK1o0OB5Zu/eHYl39GSuGwurEgmk=;
        b=cUU90ImmtbnmrJQaBXEkXdz1W2wv2Pe0npqmnUjIde2KYJuypmQ2mPXZRpoojYob8xwdE9
        u6sum5xo8a//3uIhMiDPb3pMqo+yYErxam5l/qI+cyikNHsjfSe6nbOCzmFWDgett1kc7h
        OZgm/UOfSAfwxNHYKSf0PEiNv8NfrwE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-lfITmb-7M_eoaAFcGRPGOA-1; Wed, 26 May 2021 05:54:18 -0400
X-MC-Unique: lfITmb-7M_eoaAFcGRPGOA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEDBA801107;
        Wed, 26 May 2021 09:54:16 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52F8769FB5;
        Wed, 26 May 2021 09:54:14 +0000 (UTC)
Message-ID: <2409eb8593804eb879ae6fb961a709ca8c20f329.camel@redhat.com>
Subject: Re: [PATCH v2 0/5] KVM: x86: hyper-v: Conditionally allow SynIC
 with APICv/AVIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Date:   Wed, 26 May 2021 12:54:13 +0300
In-Reply-To: <20210518144339.1987982-1-vkuznets@redhat.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-18 at 16:43 +0200, Vitaly Kuznetsov wrote:
> Changes since v1 (Sean):
> - Use common 'enable_apicv' variable for both APICv and AVIC instead of 
>  adding a new hook to 'struct kvm_x86_ops'.
> - Drop unneded CONFIG_X86_LOCAL_APIC checks from VMX/SVM code along the
>  way.
> 
> Original description:
> 
> APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
> SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
> however, possible to track whether the feature was actually used by the
> guest and only inhibit APICv/AVIC when needed.
> 
> The feature can be tested with QEMU's 'hv-passthrough' debug mode.
> 
> Note, 'avic' kvm-amd module parameter is '0' by default and thus needs to
> be explicitly enabled.
> 
> Vitaly Kuznetsov (5):
>   KVM: SVM: Drop unneeded CONFIG_X86_LOCAL_APIC check for AVIC
>   KVM: VMX: Drop unneeded CONFIG_X86_LOCAL_APIC check from
>     cpu_has_vmx_posted_intr()
>   KVM: x86: Use common 'enable_apicv' variable for both APICv and AVIC
>   KVM: x86: Invert APICv/AVIC enablement check
>   KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in
>     use
> 
>  arch/x86/include/asm/kvm_host.h |  5 ++++-
>  arch/x86/kvm/hyperv.c           | 27 +++++++++++++++++++++------
>  arch/x86/kvm/svm/avic.c         | 16 +++++-----------
>  arch/x86/kvm/svm/svm.c          | 24 +++++++++++++-----------
>  arch/x86/kvm/svm/svm.h          |  2 --
>  arch/x86/kvm/vmx/capabilities.h |  4 +---
>  arch/x86/kvm/vmx/vmx.c          |  2 --
>  arch/x86/kvm/x86.c              |  9 ++++++---
>  8 files changed, 50 insertions(+), 39 deletions(-)
> 

I tested this patch set and this is what I found.

For reference,
First of all, indeed to make AVIC work I need to:
 
1. Disable SVM - I wonder if I can make this on demand
too when the guest actually uses a nested guest or at least
enables nesting in IA32_FEATURE_CONTROL.
I naturally run most of my VMs with nesting enabled,
thus I tend to not have avic enabled due to this.
I'll prepare a patch soon for this.
 
2. Disable x2apic, naturally x2apic can't be used with avic.
In theory we can also disable avic when the guest switches on
the x2apic mode, but in practice the guest will likely to pick the x2apic
when it can.
 
3. (for hyperv) Disable 'hv_vapic', because otherwise hyper-v
uses its own PV APIC msrs which AVIC doesn't support.

This HV enlightment turns on in the CPUID both the 
HV_APIC_ACCESS_AVAILABLE which isn't that bad 
(it only tells that we have the VP assist page),
and HV_APIC_ACCESS_RECOMMENDED which hints the guest
to use HyperV PV APIC MSRS and use PV EOI field in 
the APIC access page, which means that the guest 
won't use the real apic at all.

4. and of course enable SynIC autoeoi deprecation.

Otherwise indeed windows enables autoeoi.

hv-passthrough indeed can't be used to test this
as it both enables autoeoi depreciation and *hv-vapic*. 
I had to use the patch that you posted
in 'About the performance of hyper-v' thread.
 
In addition to that when I don't use the autoeoi depreciation patch,
then the guest indeed enables autoeoi, and this triggers a deadlock.
 
The reason is that kvm_request_apicv_update must not be called with
srcu lock held vcpu->kvm->srcu (there is a warning about that
in kvm_request_apicv_update), but guest msr writes which come
from vcpu thread do hold it.
 
The other place where we disable AVIC on demand is svm_toggle_avic_for_irq_window.
And that code has a hack to drop this lock and take 
it back around the call to kvm_request_apicv_update.
This hack is safe as this code is called only from the vcpu thread.
 
Also for reference the reason for the fact that we need to
disable AVIC on the interrupt window request, or more correctly
why we still need to request interrupt windows with AVIC,
is that the local apic can act sadly as a pass-through device 
for legacy PIC, when one of its LINTn pins is configured in ExtINT mode.
In this mode when such pin is raised, the local apic asks the PIC for
the interrupt vector and then delivers it to the APIC
without touching the IRR/ISR.

The later means that if guest's interrupts are disabled,
such interrupt can't be queued via IRR to VAPIC
but instead the regular interrupt window has to be requested, 
but on AMD, the only way to request interrupt window
is to queue a VIRQ, and intercept its delivery,
a feature that is disabled when AVIC is active.
 
Finally for SynIC this srcu lock drop hack can be extended to this gross hack:
It seems to work though:


diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index bedd9b6cc26a..925b76e7b45e 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -85,7 +85,7 @@ static bool synic_has_vector_auto_eoi(struct kvm_vcpu_hv_synic *synic,
 }
 
 static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
-				int vector)
+				int vector, bool host)
 {
 	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
 	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
@@ -109,6 +109,9 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 
 	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
 
+	if (!host)
+		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+
 	/* Hyper-V SynIC auto EOI SINTs are not compatible with APICV */
 	if (!auto_eoi_old && auto_eoi_new) {
 		printk("Synic: inhibiting avic %d %d\n", auto_eoi_old, auto_eoi_new);
@@ -121,6 +124,10 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 			kvm_request_apicv_update(vcpu->kvm, true,
 						 APICV_INHIBIT_REASON_HYPERV);
 	}
+
+	if (!host)
+		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+
 }
 
 static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
@@ -149,9 +156,9 @@ static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
 
 	atomic64_set(&synic->sint[sint], data);
 
-	synic_update_vector(synic, old_vector);
+	synic_update_vector(synic, old_vector, host);
 
-	synic_update_vector(synic, vector);
+	synic_update_vector(synic, vector, host);
 
 	/* Load SynIC vectors into EOI exit bitmap */
 	kvm_make_request(KVM_REQ_SCAN_IOAPIC, hv_synic_to_vcpu(synic));


Assuming that we don't want this gross hack,  
I wonder if we can avoid full blown memslot 
update when we disable avic, but rather have some 
smaller hack like only manually patching its
NPT mapping to have RW permissions instead 
of reserved bits which we use for MMIO. 

The AVIC spec says that NPT is only used to check that
guest has RW permission to the page, 
while the HVA in the NPT entry itself is ignored.

Best regards,
	Maxim Levitsky





