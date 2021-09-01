Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609893FDE9B
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 17:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343746AbhIAP02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 11:26:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343727AbhIAP0Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 11:26:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630509928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aPK/WRSDF8QrZ8XSCsCWCd7jM/z+l8eT9+5P3Qag9/8=;
        b=Zu27jAa/t5NuAH6IBiZXlmFjO6ipGoh1tKBWzeDA0uZG3FaeWW1W0xxdKI25iqsxeCn+PZ
        FZXy2/0W5BiiMdIDY6d9E3cPPdYS3rsVpuoZmFcz0GR5IXkOFdQTfLX+s7fF8SeATmUs1u
        GK5EH0sNPreRlv1b9855x0ifP0Gpy2I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-VcxYa_cGOyyUtktu9xjr2g-1; Wed, 01 Sep 2021 11:25:26 -0400
X-MC-Unique: VcxYa_cGOyyUtktu9xjr2g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E303018460E4;
        Wed,  1 Sep 2021 15:25:25 +0000 (UTC)
Received: from localhost (unknown [10.22.8.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAAFC19C79;
        Wed,  1 Sep 2021 15:25:25 +0000 (UTC)
Date:   Wed, 1 Sep 2021 11:25:25 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] kvm: x86: Increase MAX_VCPUS to 710
Message-ID: <20210901152525.g5fnf5ketta3fjhl@habkost.net>
References: <20210831204535.1594297-1-ehabkost@redhat.com>
 <87sfyooh9x.fsf@vitty.brq.redhat.com>
 <20210901111326.2efecf6e@redhat.com>
 <87ilzkob6k.fsf@vitty.brq.redhat.com>
 <20210901153615.296486b5@redhat.com>
 <875yvknyrj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <875yvknyrj.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 04:42:08PM +0200, Vitaly Kuznetsov wrote:
> Igor Mammedov <imammedo@redhat.com> writes:
> 
> > On Wed, 01 Sep 2021 12:13:55 +0200
> > Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >
> >> Igor Mammedov <imammedo@redhat.com> writes:
> >> 
> >> > On Wed, 01 Sep 2021 10:02:18 +0200
> >> > Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >> >  
> >> >> Eduardo Habkost <ehabkost@redhat.com> writes:
> >> >>   
> >> >> > Support for 710 VCPUs has been tested by Red Hat since RHEL-8.4.
> >> >> > Increase KVM_MAX_VCPUS and KVM_SOFT_MAX_VCPUS to 710.
> >> >> >
> >> >> > For reference, visible effects of changing KVM_MAX_VCPUS are:
> >> >> > - KVM_CAP_MAX_VCPUS and KVM_CAP_NR_VCPUS will now return 710 (of course)
> >> >> > - Default value for CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000005)].EAX
> >> >> >   will now be 710
> >> >> > - Bitmap stack variables that will grow:
> >> >> >   - At kvm_hv_flush_tlb()  kvm_hv_send_ipi():
> >> >> >     - Sparse VCPU bitmap (vp_bitmap) will be 96 bytes long
> >> >> >     - vcpu_bitmap will be 92 bytes long
> >> >> >   - vcpu_bitmap at bioapic_write_indirect() will be 92 bytes long
> >> >> >     once patch "KVM: x86: Fix stack-out-of-bounds memory access
> >> >> >     from ioapic_write_indirect()" is applied
> >> >> >
> >> >> > Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> >> >> > ---
> >> >> >  arch/x86/include/asm/kvm_host.h | 4 ++--
> >> >> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >> >> >
> >> >> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >> >> > index af6ce8d4c86a..f76fae42bf45 100644
> >> >> > --- a/arch/x86/include/asm/kvm_host.h
> >> >> > +++ b/arch/x86/include/asm/kvm_host.h
> >> >> > @@ -37,8 +37,8 @@
> >> >> >  
> >> >> >  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
> >> >> >  
> >> >> > -#define KVM_MAX_VCPUS 288
> >> >> > -#define KVM_SOFT_MAX_VCPUS 240
> >> >> > +#define KVM_MAX_VCPUS 710    
> >> >> 
> >> >> Out of pure curiosity, where did 710 came from? Is this some particular
> >> >> hardware which was used for testing (weird number btw). Should we maybe
> >> >> go to e.g. 1024 for the sake of the beauty of powers of two? :-)

710 wasn't tested with real VMs yet due to userspace limitations
that still need to be addressed (specifically, due to SMBIOS 2.1
table size limits).

I would be more than happy to set it to 1024 or 2048 if the KVM
maintainers agree.  :)

For reference, RHEL-8.4 is compiled with KVM_MAX_VCPUS=2048, but
userspace enforces a 710 VCPU limit.

> >> >>   
> >> >> > +#define KVM_SOFT_MAX_VCPUS 710    
> >> >> 
> >> >> Do we really need KVM_SOFT_MAX_VCPUS which is equal to KVM_MAX_VCPUS?
> >> >> 
> >> >> Reading 
> >> >> 
> >> >> commit 8c3ba334f8588e1d5099f8602cf01897720e0eca
> >> >> Author: Sasha Levin <levinsasha928@gmail.com>
> >> >> Date:   Mon Jul 18 17:17:15 2011 +0300
> >> >> 
> >> >>     KVM: x86: Raise the hard VCPU count limit
> >> >> 
> >> >> the idea behind KVM_SOFT_MAX_VCPUS was to allow developers to test high
> >> >> vCPU numbers without claiming such configurations as supported.
> >> >> 
> >> >> I have two alternative suggestions:
> >> >> 1) Drop KVM_SOFT_MAX_VCPUS completely.
> >> >> 2) Raise it to a higher number (e.g. 2048)

I will send a RFC later proposing we make KVM_MAX_VCPUS
configurable by Kconfig, and dropping KVM_SOFT_MAX_VCPUS.

> >> >>   
> >> >> >  #define KVM_MAX_VCPU_ID 1023    
> >> >> 
> >> >> 1023 may not be enough now. I rememeber there was a suggestion to make
> >> >> max_vcpus configurable via module parameter and this question was
> >> >> raised:
> >> >> 
> >> >> https://lore.kernel.org/lkml/878s292k75.fsf@vitty.brq.redhat.com/
> >> >> 
> >> >> TL;DR: to support EPYC-like topologies we need to keep
> >> >>  KVM_MAX_VCPU_ID = 4 * KVM_MAX_VCPUS  

1024 seems to be enough on all the CPU topologies I have seen,
but I can happily implement the 4x rule below, just to be sure.

> >> >
> >> > VCPU_ID (sequential 0-n range) is not APIC ID (sparse distribution),
> >> > so topology encoded in the later should be orthogonal to VCPU_ID.  
> >> 
> >> Why do we even have KVM_MAX_VCPU_ID which is != KVM[_SOFT]_MAX_VCPUS
> >> then?
> > I'd say for compat reasons (8c3ba334f85 KVM: x86: Raise the hard VCPU count limit)
> >
> > qemu warns users that they are out of recommended (tested) limit when
> > it sees requested maxcpus over soft limit.
> > See soft_vcpus_limit in qemu.
> >
> 
> That's the reason why we have KVM_SOFT_MAX_VCPUS in addition to
> KVM_MAX_VCPUS, not why we have KVM_MAX_VCPU_ID :-)
> 
> >
> >> KVM_MAX_VCPU_ID is only checked in kvm_vm_ioctl_create_vcpu() which
> >> passes 'id' down to kvm_vcpu_init() which, in its turn, sets
> >> 'vcpu->vcpu_id'. This is, for example, returned by kvm_x2apic_id():
> >> 
> >> static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> >> {
> >>         return apic->vcpu->vcpu_id;
> >> }
> >> 
> >> So I'm pretty certain this is actually APIC id and it has topology in
> >> it.
> > Yep, I mixed it up with cpu_index on QEMU side,
> > for x86 it fetches actual apic id and feeds that to kvm when creating vCPU.
> >
> > It looks like KVM_MAX_VCPU_ID (KVM_SOFT_MAX_VCPUS) is essentially
> > MAX_[SOFT_]APIC_ID which in some places is treated as max number of vCPUs,
> > so actual max count of vCPUs could be less than that (in case of sparse APIC
> > IDs /non power of 2 thread|core|whatever count/).
> 
> Yes. To avoid the confusion, I'd suggest we re-define KVM_MAX_VCPU_ID as
> something like:
> 
> #define KVM_MAX_VCPU_ID_TO_MAX_VCPUS_RATIO 4
> #define KVM_MAX_VCPU_ID (KVM_MAX_VCPUS * KVM_MAX_VCPU_ID_TO_MAX_VCPUS_RATIO)
> 
> and add a comment about sparse APIC IDs/topology.

I will submit a new version of this patch with a rule like the
above.

A 4x ratio is very generous, but the only impact of a large
KVM_MAX_VCPU_ID is a larger struct kvm_ioapic.  Changing
KVM_MAX_VCPU_ID from 1024 to 4096 will make struct kvm_ioapic
grow from 1628 bytes to 5084 bytes, which I assume is OK.

-- 
Eduardo

