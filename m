Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8703A48E67C
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 09:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiANI30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 03:29:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240304AbiANI2N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 03:28:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642148893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Toq/pcDDykYr7QxIBUh+EwJlcrNHxSEe3MwKZ5YvLWg=;
        b=DTyx72UzrYm6yISFDzK2LwUOoUelU+t9CJmIsnisms+GFGKNy4d1PoyLQHRkNKsLwoinFm
        4km0sx7JbBV/4IOe83ejL47ieUqi0ewVRIv9Mvoj2/HDN/4D16Ocb8sEdbfudeUz1xAKNv
        E++s8gtH4VNQvcmJ595rEgUtTDHl8C4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-wTWZ0GwMOOOwT6gfIkH5GQ-1; Fri, 14 Jan 2022 03:28:10 -0500
X-MC-Unique: wTWZ0GwMOOOwT6gfIkH5GQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7A5E1019983;
        Fri, 14 Jan 2022 08:28:08 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAA586E1EF;
        Fri, 14 Jan 2022 08:28:01 +0000 (UTC)
Message-ID: <5b516b51f81874fe7cafe8ce6846bc9936d83cc7.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Igor Mammedov <imammedo@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Fri, 14 Jan 2022 10:28:00 +0200
In-Reply-To: <YeCowpPBEHC6GJ59@google.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
         <20211122175818.608220-3-vkuznets@redhat.com>
         <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
         <20211227183253.45a03ca2@redhat.com>
         <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
         <87mtkdqm7m.fsf@redhat.com> <20220103104057.4dcf7948@redhat.com>
         <YeCowpPBEHC6GJ59@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-01-13 at 22:33 +0000, Sean Christopherson wrote:
> On Mon, Jan 03, 2022, Igor Mammedov wrote:
> > On Mon, 03 Jan 2022 09:04:29 +0100
> > Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > 
> > > Paolo Bonzini <pbonzini@redhat.com> writes:
> > > 
> > > > On 12/27/21 18:32, Igor Mammedov wrote:  
> > > > > > Tweaked and queued nevertheless, thanks.  
> > > > > it seems this patch breaks VCPU hotplug, in scenario:
> > > > > 
> > > > >    1. hotunplug existing VCPU (QEMU stores VCPU file descriptor in parked cpus list)
> > > > >    2. hotplug it again (unsuspecting QEMU reuses stored file descriptor when recreating VCPU)
> > > > > 
> > > > > RHBZ:https://bugzilla.redhat.com/show_bug.cgi?id=2028337#c11
> > > > >   
> > > > 
> > > > The fix here would be (in QEMU) to not call KVM_SET_CPUID2 again. 
> > > > However, we need to work around it in KVM, and allow KVM_SET_CPUID2 if 
> > > > the data passed to the ioctl is the same that was set before.  
> > > 
> > > Are we sure the data is going to be *exactly* the same? In particular,
> > > when using vCPU fds from the parked list, do we keep the same
> > > APIC/x2APIC id when hotplugging? Or can we actually hotplug with a
> > > different id?
> > 
> > If I recall it right, it can be a different ID easily.
> 
> No, it cannot.  KVM doesn't provide a way for userspace to change the APIC ID of
> a vCPU after the vCPU is created.  x2APIC flat out disallows changing the APIC ID,
> and unless there's magic I'm missing, apic_mmio_write() => kvm_lapic_reg_write()
> is not reachable from userspace.

So after all, it is true that vcpu_id == initial APIC_ID,
and if we don't let guest change it, it will be always like that? 


You said that its not true in the other mail in the thread. 
I haven't checked it in the code yet, as I never was much worried about userspace changing,
but I will check it soon.

I did a quick look and I see that at least the userspace can call 'kvm_apic_set_state' and it 
contains snapshot of all apic registers, including apic id.
However it would be very easy to add a check
there and fail if userspace attempts to
set APIC_ID != vcpu_id.


Best regards,
	Maxim Levitsky
> 
> The only way for userspace to set the APIC ID is to change vcpu->vcpu_id, and that
> can only be done at KVM_VCPU_CREATE.
> 
> So, reusing a parked vCPU for hotplug must reuse the same APIC ID.  QEMU handles
> this by stashing the vcpu_id, a.k.a. APIC ID, when parking a vCPU, and reuses a
> parked vCPU if and only if it has the same APIC ID.  And because QEMU derives the
> APIC ID from topology, that means all the topology CPUID leafs must remain the
> same, otherwise the guest is hosed because it will send IPIs to the wrong vCPUs.
> 
>   static int do_kvm_destroy_vcpu(CPUState *cpu)
>   {
>     struct KVMParkedVcpu *vcpu = NULL;
> 
>     ...
> 
>     vcpu = g_malloc0(sizeof(*vcpu));
>     vcpu->vcpu_id = kvm_arch_vcpu_id(cpu); <=== stash the APIC ID when parking
>     vcpu->kvm_fd = cpu->kvm_fd;
>     QLIST_INSERT_HEAD(&kvm_state->kvm_parked_vcpus, vcpu, node);
> err:
>     return ret;
>   }
> 
>   static int kvm_get_vcpu(KVMState *s, unsigned long vcpu_id)
>   {
>     struct KVMParkedVcpu *cpu;
> 
>     QLIST_FOREACH(cpu, &s->kvm_parked_vcpus, node) {
>         if (cpu->vcpu_id == vcpu_id) {  <=== reuse if APIC ID matches
>             int kvm_fd;
> 
>             QLIST_REMOVE(cpu, node);
>             kvm_fd = cpu->kvm_fd;
>             g_free(cpu);
>             return kvm_fd;
>         }
>     }
> 
>     return kvm_vm_ioctl(s, KVM_CREATE_VCPU, (void *)vcpu_id);
>   }
> 


