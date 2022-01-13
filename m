Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2D548D9D6
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 15:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbiAMOmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 09:42:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233740AbiAMOmF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 09:42:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642084924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bI1J+F/xPUtTeAmv7i8RngLz7AnC9Brnx+j8BC+IvkI=;
        b=Ev2HJ4QFGOWp5XuKJp1rGAbxIqUe0kA+caczAnhcGEPS0FfGgH7EdPzsDfWMi4WvOKsyuh
        sJ+Gk9BD/LXOFXbU8zqoJhMKLpW2eZV4H8QTHBX0qnf7Ncmj31b6zs0NGkaGCujQqFjAXL
        qy/yHgT+F5fTpsn0qf6evYr/YQoJU5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-1ZYmFKY5OtKKDv5B7LzIEA-1; Thu, 13 Jan 2022 09:42:01 -0500
X-MC-Unique: 1ZYmFKY5OtKKDv5B7LzIEA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A73AF1016781;
        Thu, 13 Jan 2022 14:41:59 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B199374EA6;
        Thu, 13 Jan 2022 14:41:55 +0000 (UTC)
Message-ID: <6ae7e64c53727f9f00537d787e9612c292c4e244.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Thu, 13 Jan 2022 16:41:54 +0200
In-Reply-To: <87zgnzn1nr.fsf@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
         <20211122175818.608220-3-vkuznets@redhat.com>
         <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
         <20211227183253.45a03ca2@redhat.com>
         <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
         <87mtkdqm7m.fsf@redhat.com> <20220103104057.4dcf7948@redhat.com>
         <875yr1q8oa.fsf@redhat.com>
         <ceb63787-b057-13db-4624-b430c51625f1@redhat.com>
         <87o84qpk7d.fsf@redhat.com> <877dbbq5om.fsf@redhat.com>
         <5505d731-cf87-9662-33f3-08844d92877c@redhat.com>
         <20220111090022.1125ffb5@redhat.com> <87fsptnjic.fsf@redhat.com>
         <50136685-706e-fc6a-0a77-97e584e74f93@redhat.com>
         <87bl0gnfy5.fsf@redhat.com>
         <7e7c7e22f8b1b1695d26d9e19a767b87c679df93.camel@redhat.com>
         <87zgnzn1nr.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-01-13 at 15:36 +0100, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Thu, 2022-01-13 at 10:27 +0100, Vitaly Kuznetsov wrote:
> > > Paolo Bonzini <pbonzini@redhat.com> writes:
> > > 
> > > > On 1/12/22 14:58, Vitaly Kuznetsov wrote:
> > > > > -	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
> > > > > +	best = cpuid_entry2_find(entries, nent, 0xD, 1);
> > > > >   	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> > > > >   		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> > > > >   		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> > > > >   
> > > > > -	best = kvm_find_kvm_cpuid_features(vcpu);
> > > > > +	best = __kvm_find_kvm_cpuid_features(vcpu, vcpu->arch.cpuid_entries,
> > > > > +					     vcpu->arch.cpuid_nent);
> > > > >   	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> > > > 
> > > > I think this should be __kvm_find_kvm_cpuid_features(vcpu, entries, nent).
> > > > 
> > > 
> > > Of course.
> > > 
> > > > > +		case 0x1:
> > > > > +			/* Only initial LAPIC id is allowed to change */
> > > > > +			if (e->eax ^ best->eax || ((e->ebx ^ best->ebx) >> 24) ||
> > > > > +			    e->ecx ^ best->ecx || e->edx ^ best->edx)
> > > > > +				return -EINVAL;
> > > > > +			break;
> > > > 
> > > > This XOR is a bit weird.  In addition the EBX test is checking the wrong 
> > > > bits (it checks whether 31:24 change and ignores changes to 23:0).
> > > 
> > > Indeed, however, I've tested CPU hotplug with QEMU trying different
> > > CPUs in random order and surprisingly othing blew up, feels like QEMU
> > > was smart enough to re-use the right fd)
> > > 
> > > > You can write just "(e->ebx & ~0xff000000u) != (best->ebx ~0xff000000u)".
> > > > 
> > > > > +		default:
> > > > > +			if (e->eax ^ best->eax || e->ebx ^ best->ebx ||
> > > > > +			    e->ecx ^ best->ecx || e->edx ^ best->edx)
> > > > > +				return -EINVAL;
> > > > 
> > > > This one even more so.
> > > 
> > > Thanks for the early review, I'm going to prepare a selftest and send
> > > this out.
> > > 
> > I also looked at this recently (due to other reasons) and I found out that
> > qemu picks a parked vcpu by its vcpu_id which is its initial apic id,
> > thus apic id related features should not change.
> > 
> > Take a look at 'kvm_get_vcpu' in qemu source.
> > Maybe old qemu versions didn't do this?
> 
> I took Igor's word on this, I didn't check QEMU code :-)
> 
> In the v1 I've just sent [L,x2]APIC ids are allowed to change. This
> shouldn't screw the MMU (which was the main motivation for forbidding
> KVM_SET_CPUID{,2} after KVM_RUN in the first place) but maybe we don't
> really need to be so permissive.
> 

For my nested AVIC work I would really want the APIC ID of a VCPU to be read-only
and be equal to vcpu_id.

That simplifies lot of things, and in practice it is hightly likely that no guests
change their APIC id, and likely that qemu doesn't as well.

Best regards,
	Maxim Levitsky




