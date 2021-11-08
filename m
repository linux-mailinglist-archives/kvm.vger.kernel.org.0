Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE7E447E77
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 12:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236794AbhKHLLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 06:11:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21729 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236097AbhKHLLN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 06:11:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636369709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+FXZTOVFFDucQ66qDChcRUIhx5QaG1evjQs4iA4DnzE=;
        b=Y6sY1Sl/6GyuzyNpVZw6t6f0muAVqfBW364jpjuK3hdvRu3qN2JmltxFcRltfUe6uE84PH
        zDvs6l4MRRnAnoZq+v1GeJ0v6BkY4Mzs99Eh6u6OVPEsH6S2/ihzWFh/1gfKuRwM+3Wcxx
        IENXZu5Ggx7QyBYDq6KKKnlxN6mf+o8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-yRBJhWAiOOmMcqtGgOf_aA-1; Mon, 08 Nov 2021 06:08:26 -0500
X-MC-Unique: yRBJhWAiOOmMcqtGgOf_aA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE49A8799E0;
        Mon,  8 Nov 2021 11:08:22 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1378156A86;
        Mon,  8 Nov 2021 11:08:16 +0000 (UTC)
Message-ID: <f93612f54a5cde53fd9342f703ccbaf3c9edbc9c.camel@redhat.com>
Subject: Re: [RFC] KVM: x86: SVM: don't expose PV_SEND_IPI feature with AVIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Kele Huang <huangkele@bytedance.com>
Cc:     chaiwen.cc@bytedance.com, xieyongji@bytedance.com,
        dengliang.1214@bytedance.com, pizhenwei@bytedance.com,
        wanpengli@tencent.com, seanjc@google.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 08 Nov 2021 13:08:15 +0200
In-Reply-To: <a991bbb4-b507-a2f6-ec0f-fce23d4379ce@redhat.com>
References: <20211108095931.618865-1-huangkele@bytedance.com>
         <a991bbb4-b507-a2f6-ec0f-fce23d4379ce@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-11-08 at 11:30 +0100, Paolo Bonzini wrote:
> On 11/8/21 10:59, Kele Huang wrote:
> > Currently, AVIC is disabled if x2apic feature is exposed to guest
> > or in-kernel PIT is in re-injection mode.
> > 
> > We can enable AVIC with options:
> > 
> >    Kmod args:
> >    modprobe kvm_amd avic=1 nested=0 npt=1
> >    QEMU args:
> >    ... -cpu host,-x2apic -global kvm-pit.lost_tick_policy=discard ...
> > 
> > When LAPIC works in xapic mode, both AVIC and PV_SEND_IPI feature
> > can accelerate IPI operations for guest. However, the relationship
> > between AVIC and PV_SEND_IPI feature is not sorted out.
> > 
> > In logical, AVIC accelerates most of frequently IPI operations
> > without VMM intervention, while the re-hooking of apic->send_IPI_xxx
> > from PV_SEND_IPI feature masks out it. People can get confused
> > if AVIC is enabled while getting lots of hypercall kvm_exits
> > from IPI.
> > 
> > In performance, benchmark tool
> > https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com/
> > shows below results:
> > 
> >    Test env:
> >    CPU: AMD EPYC 7742 64-Core Processor
> >    2 vCPUs pinned 1:1
> >    idle=poll
> > 
> >    Test result (average ns per IPI of lots of running):
> >    PV_SEND_IPI 	: 1860
> >    AVIC 		: 1390
> > 
> > Besides, disscussions in https://lkml.org/lkml/2021/10/20/423
> > do have some solid performance test results to this.
> > 
> > This patch fixes this by masking out PV_SEND_IPI feature when
> > AVIC is enabled in setting up of guest vCPUs' CPUID.
> > 
> > Signed-off-by: Kele Huang <huangkele@bytedance.com>
> 
> AVIC can change across migration.  I think we should instead use a new 
> KVM_HINTS_* bit (KVM_HINTS_ACCELERATED_LAPIC or something like that). 
> The KVM_HINTS_* bits are intended to be changeable across migration, 
> even though we don't have for now anything equivalent to the Hyper-V 
> reenlightenment interrupt.

Note that the same issue exists with HyperV. It also has PV APIC,
which is harmful when AVIC is enabled (that is guest uses it instead
of using AVIC, negating AVIC benefits).

Also note that Intel recently posted IPI virtualizaion, which
will make this issue relevant to APICv too soon.

I don't yet know if there is a solution to this which doesn't
involve some management software decision (e.g libvirt or higher).

Best regards,
	Maxim Levitsky

> 
> Paolo
> 
> > ---
> >   arch/x86/kvm/cpuid.c   |  4 ++--
> >   arch/x86/kvm/svm/svm.c | 13 +++++++++++++
> >   2 files changed, 15 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 2d70edb0f323..cc22975e2ac5 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -194,8 +194,6 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >   		best->ecx |= XFEATURE_MASK_FPSSE;
> >   	}
> >   
> > -	kvm_update_pv_runtime(vcpu);
> > -
> >   	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> >   	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
> >   
> > @@ -208,6 +206,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >   	/* Invoke the vendor callback only after the above state is updated. */
> >   	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
> >   
> > +	kvm_update_pv_runtime(vcpu);
> > +
> >   	/*
> >   	 * Except for the MMU, which needs to do its thing any vendor specific
> >   	 * adjustments to the reserved GPA bits.
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index b36ca4e476c2..b13bcfb2617c 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4114,6 +4114,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >   		if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
> >   			kvm_request_apicv_update(vcpu->kvm, false,
> >   						 APICV_INHIBIT_REASON_NESTED);
> > +
> > +		if (!guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) &&
> > +				!(nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))) {
> > +			/*
> > +			 * PV_SEND_IPI feature masks out AVIC acceleration to IPI.
> > +			 * So, we do not expose PV_SEND_IPI feature to guest when
> > +			 * AVIC is enabled.
> > +			 */
> > +			best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> > +			if (best && enable_apicv &&
> > +					(best->eax & (1 << KVM_FEATURE_PV_SEND_IPI)))
> > +				best->eax &= ~(1 << KVM_FEATURE_PV_SEND_IPI);
> > +		}
> >   	}
> >   	init_vmcb_after_set_cpuid(vcpu);
> >   }
> > 


