Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CB22F340E
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 16:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390917AbhALPTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 10:19:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37981 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732317AbhALPTD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 10:19:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610464656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i9PZ2KBarh0d5dg5lYI6TnFzj15ldlohM7VpMuOy86E=;
        b=XPqOziaDusXVLo/uzD5EsNBFdJAhGV8QT//O7Pl7io4VLcd3Dp+t2vfX8TqyBYXRDvDx6h
        eUOYdpuKGK3ALS7I0+p+QRhsc+98LSfSQIAK6fDMJ1uQd4hT/0MuAcSa6/BdtMO0aigjbP
        SKze0UP/oQ7erXTkIjRG0OM+8HAC3Qk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-A9xCNsojNu-t9Z3M04SRng-1; Tue, 12 Jan 2021 10:17:33 -0500
X-MC-Unique: A9xCNsojNu-t9Z3M04SRng-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CFBE196632F;
        Tue, 12 Jan 2021 15:17:31 +0000 (UTC)
Received: from starship (unknown [10.35.206.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E5C6722C0;
        Tue, 12 Jan 2021 15:17:21 +0000 (UTC)
Message-ID: <9f3b8e3dca453c13867c5c6b61645b9b58d68f61.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered
 by VM instructions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com
Date:   Tue, 12 Jan 2021 17:17:21 +0200
In-Reply-To: <130DAF1C-06FC-4335-97AD-691B39A2C847@amacapital.net>
References: <87eeiq8i7k.fsf@vitty.brq.redhat.com>
         <130DAF1C-06FC-4335-97AD-691B39A2C847@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-12 at 07:11 -0800, Andy Lutomirski wrote:
> > On Jan 12, 2021, at 4:15 AM, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > 
> > ﻿Wei Huang <wei.huang2@amd.com> writes:
> > 
> > > From: Bandan Das <bsd@redhat.com>
> > > 
> > > While running VM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
> > > CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
> > > before checking VMCB's instruction intercept. If EAX falls into such
> > > memory areas, #GP is triggered before VMEXIT. This causes problem under
> > > nested virtualization. To solve this problem, KVM needs to trap #GP and
> > > check the instructions triggering #GP. For VM execution instructions,
> > > KVM emulates these instructions; otherwise it re-injects #GP back to
> > > guest VMs.
> > > 
> > > Signed-off-by: Bandan Das <bsd@redhat.com>
> > > Co-developed-by: Wei Huang <wei.huang2@amd.com>
> > > Signed-off-by: Wei Huang <wei.huang2@amd.com>
> > > ---
> > > arch/x86/include/asm/kvm_host.h |   8 +-
> > > arch/x86/kvm/mmu.h              |   1 +
> > > arch/x86/kvm/mmu/mmu.c          |   7 ++
> > > arch/x86/kvm/svm/svm.c          | 157 +++++++++++++++++++-------------
> > > arch/x86/kvm/svm/svm.h          |   8 ++
> > > arch/x86/kvm/vmx/vmx.c          |   2 +-
> > > arch/x86/kvm/x86.c              |  37 +++++++-
> > > 7 files changed, 146 insertions(+), 74 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 3d6616f6f6ef..0ddc309f5a14 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1450,10 +1450,12 @@ extern u64 kvm_mce_cap_supported;
> > >  *                 due to an intercepted #UD (see EMULTYPE_TRAP_UD).
> > >  *                 Used to test the full emulator from userspace.
> > >  *
> > > - * EMULTYPE_VMWARE_GP - Set when emulating an intercepted #GP for VMware
> > > + * EMULTYPE_PARAVIRT_GP - Set when emulating an intercepted #GP for VMware
> > >  *            backdoor emulation, which is opt in via module param.
> > >  *            VMware backoor emulation handles select instructions
> > > - *            and reinjects the #GP for all other cases.
> > > + *            and reinjects #GP for all other cases. This also
> > > + *            handles other cases where #GP condition needs to be
> > > + *            handled and emulated appropriately
> > >  *
> > >  * EMULTYPE_PF - Set when emulating MMIO by way of an intercepted #PF, in which
> > >  *         case the CR2/GPA value pass on the stack is valid.
> > > @@ -1463,7 +1465,7 @@ extern u64 kvm_mce_cap_supported;
> > > #define EMULTYPE_SKIP            (1 << 2)
> > > #define EMULTYPE_ALLOW_RETRY_PF        (1 << 3)
> > > #define EMULTYPE_TRAP_UD_FORCED        (1 << 4)
> > > -#define EMULTYPE_VMWARE_GP        (1 << 5)
> > > +#define EMULTYPE_PARAVIRT_GP        (1 << 5)
> > > #define EMULTYPE_PF            (1 << 6)
> > > 
> > > int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
> > > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > > index 581925e476d6..1a2fff4e7140 100644
> > > --- a/arch/x86/kvm/mmu.h
> > > +++ b/arch/x86/kvm/mmu.h
> > > @@ -219,5 +219,6 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
> > > 
> > > int kvm_mmu_post_init_vm(struct kvm *kvm);
> > > void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
> > > +bool kvm_is_host_reserved_region(u64 gpa);
> > 
> > Just a suggestion: "kvm_gpa_in_host_reserved()" maybe? 
> > 
> > > #endif
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 6d16481aa29d..c5c4aaf01a1a 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -50,6 +50,7 @@
> > > #include <asm/io.h>
> > > #include <asm/vmx.h>
> > > #include <asm/kvm_page_track.h>
> > > +#include <asm/e820/api.h>
> > > #include "trace.h"
> > > 
> > > extern bool itlb_multihit_kvm_mitigation;
> > > @@ -5675,6 +5676,12 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
> > > }
> > > EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
> > > 
> > > +bool kvm_is_host_reserved_region(u64 gpa)
> > > +{
> > > +    return e820__mbapped_raw_any(gpa-1, gpa+1, E820_TYPE_RESERVED);
> > > +}
> > 
> > While _e820__mapped_any()'s doc says '..  checks if any part of the
> > range <start,end> is mapped ..' it seems to me that the real check is
> > [start, end) so we should use 'gpa' instead of 'gpa-1', no?
> 
> Why do you need to check GPA at all?
> 
To reduce the scope of the workaround.

The errata only happens when you use one of SVM instructions
in the guest with EAX that happens to be inside one
of the host reserved memory regions (for example SMM).

So it is not expected for an SVM instruction with EAX that is a valid host
physical address to get a #GP due to this errata. 

Best regards,
	Maxim Levitsky

> 


