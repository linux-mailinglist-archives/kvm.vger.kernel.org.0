Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570A52C8648
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 15:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgK3ONY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 09:13:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbgK3ONY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 09:13:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606745517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2zv6+ucodm/xfDYyg+Sh6U/WzFb0IF6DwZNXabv7t90=;
        b=G315h/fZ/ofSBt7PEJzLhRaHHtIKY8r2jwFeK7Ht6YwEhz4/xpPyXyZHp2CHUY52rVbdz+
        wHUUO8Eyv87stFbWbL01PUkdBZ9XRaQnQTYZMOc/UZAhGZnf101MjPO8L4H66rdetyf8vG
        5dlDcm63U3SUnYtzM7SA1A/xaLyO/Fs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-ZXWjAzGHO5eKzT-pFkIYUA-1; Mon, 30 Nov 2020 09:11:55 -0500
X-MC-Unique: ZXWjAzGHO5eKzT-pFkIYUA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 098EF807357;
        Mon, 30 Nov 2020 14:11:53 +0000 (UTC)
Received: from starship (unknown [10.35.206.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFB0063B8C;
        Mon, 30 Nov 2020 14:11:45 +0000 (UTC)
Message-ID: <638a2919cf7c11c55108776beecafdd8e2da2995.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86: introduce KVM_X86_QUIRK_TSC_HOST_ACCESS
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        open list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Mon, 30 Nov 2020 16:11:43 +0200
In-Reply-To: <c093973e-c8da-4d09-11f2-61cc0918f55f@redhat.com>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
         <20201130133559.233242-3-mlevitsk@redhat.com>
         <c093973e-c8da-4d09-11f2-61cc0918f55f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-11-30 at 14:54 +0100, Paolo Bonzini wrote:
> On 30/11/20 14:35, Maxim Levitsky wrote:
> > This quirk reflects the fact that we currently treat MSR_IA32_TSC
> > and MSR_TSC_ADJUST access by the host (e.g qemu) in a way that is different
> > compared to an access from the guest.
> > 
> > For host's MSR_IA32_TSC read we currently always return L1 TSC value, and for
> > host's write we do the tsc synchronization.
> > 
> > For host's MSR_TSC_ADJUST write, we don't make the tsc 'jump' as we should
> > for this msr.
> > 
> > When the hypervisor uses the new TSC GET/SET state ioctls, all of this is no
> > longer needed, thus leave this enabled only with a quirk
> > which the hypervisor can disable.
> > 
> > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> This needs to be covered by a variant of the existing selftests testcase 
> (running the same guest code, but different host code of course).
Do you think that the test should go to the kernel's kvm unit tests,
or to kvm-unit-tests project?

Best regards,
	Maxim Levitsky

> 
> Paolo
> 
> > ---
> >   arch/x86/include/uapi/asm/kvm.h |  1 +
> >   arch/x86/kvm/x86.c              | 19 ++++++++++++++-----
> >   2 files changed, 15 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 8e76d3701db3f..2a60fc6674164 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -404,6 +404,7 @@ struct kvm_sync_regs {
> >   #define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	   (1 << 2)
> >   #define KVM_X86_QUIRK_OUT_7E_INC_RIP	   (1 << 3)
> >   #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
> > +#define KVM_X86_QUIRK_TSC_HOST_ACCESS      (1 << 5)
> >   
> >   #define KVM_STATE_NESTED_FORMAT_VMX	0
> >   #define KVM_STATE_NESTED_FORMAT_SVM	1
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 4f0ae9cb14b8a..46a2111d54840 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3091,7 +3091,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >   		break;
> >   	case MSR_IA32_TSC_ADJUST:
> >   		if (guest_cpuid_has(vcpu, X86_FEATURE_TSC_ADJUST)) {
> > -			if (!msr_info->host_initiated) {
> > +			if (!msr_info->host_initiated ||
> > +			    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TSC_HOST_ACCESS)) {
> >   				s64 adj = data - vcpu->arch.ia32_tsc_adjust_msr;
> >   				adjust_tsc_offset_guest(vcpu, adj);
> >   			}
> > @@ -3118,7 +3119,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >   		vcpu->arch.msr_ia32_power_ctl = data;
> >   		break;
> >   	case MSR_IA32_TSC:
> > -		if (msr_info->host_initiated) {
> > +		if (msr_info->host_initiated &&
> > +		    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TSC_HOST_ACCESS)) {
> >   			kvm_synchronize_tsc(vcpu, data);
> >   		} else {
> >   			u64 adj = kvm_compute_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
> > @@ -3409,17 +3411,24 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >   		msr_info->data = vcpu->arch.msr_ia32_power_ctl;
> >   		break;
> >   	case MSR_IA32_TSC: {
> > +		u64 tsc_offset;
> > +
> >   		/*
> >   		 * Intel SDM states that MSR_IA32_TSC read adds the TSC offset
> >   		 * even when not intercepted. AMD manual doesn't explicitly
> >   		 * state this but appears to behave the same.
> >   		 *
> > -		 * On userspace reads and writes, however, we unconditionally
> > +		 * On userspace reads and writes, when KVM_X86_QUIRK_SPECIAL_TSC_READ
> > +		 * is present, however, we unconditionally
> >   		 * return L1's TSC value to ensure backwards-compatible
> >   		 * behavior for migration.
> >   		 */
> > -		u64 tsc_offset = msr_info->host_initiated ? vcpu->arch.l1_tsc_offset :
> > -							    vcpu->arch.tsc_offset;
> > +
> > +		if (msr_info->host_initiated &&
> > +		    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TSC_HOST_ACCESS))
> > +			tsc_offset = vcpu->arch.l1_tsc_offset;
> > +		else
> > +			tsc_offset = vcpu->arch.tsc_offset;
> >   
> >   		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + tsc_offset;
> >   		break;
> > 


