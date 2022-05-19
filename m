Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111C552D3EE
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbiESN2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiESN2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:28:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36C31CC15A
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652966893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=chcH0p5yUvxNOuMG6xpUSYUYVPOIVaBK57Vn0yWf5ZY=;
        b=IVGg9dBBk6ahhouYwbpcQIbZYlWCIC4jNy/lT0idJXsWwypI3/wdPukOcqWzXzvVPQmGDt
        bAZsBlyd74chYOxLemRN5ZxsAiyDb+5XKxMOaabhNWfkp/n/aJbzDHyYnZjMW59WZhuAed
        cOA9+1UiGsX7Zx07E+H3BlFkVmq0xa4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-u1DynL4UM6W4pJ-h8IxAYQ-1; Thu, 19 May 2022 09:28:10 -0400
X-MC-Unique: u1DynL4UM6W4pJ-h8IxAYQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D237E811E81;
        Thu, 19 May 2022 13:28:09 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88B94492CA2;
        Thu, 19 May 2022 13:28:07 +0000 (UTC)
Message-ID: <cb54921d6834ff2b4eda61b78c423125ca315d7d.camel@redhat.com>
Subject: Re: [PATCH v3 17/34] KVM: x86: hyper-v: Introduce fast
 kvm_hv_l2_tlb_flush_exposed() check
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 19 May 2022 16:28:06 +0300
In-Reply-To: <877d6hu012.fsf@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-18-vkuznets@redhat.com>
         <3a4199c0b7ba7cf82c4eadf2881e24be609c2f0d.camel@redhat.com>
         <877d6hu012.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-05-19 at 15:25 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
> > > Introduce a helper to quickly check if KVM needs to handle VMCALL/VMMCALL
> > > from L2 in L0 to process L2 TLB flush requests.
> > > 
> > > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h | 1 +
> > >  arch/x86/kvm/hyperv.c           | 6 ++++++
> > >  arch/x86/kvm/hyperv.h           | 7 +++++++
> > >  3 files changed, 14 insertions(+)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index ce62fde5f4ff..168600490bd1 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -616,6 +616,7 @@ struct kvm_vcpu_hv {
> > >  		u32 enlightenments_eax; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EAX */
> > >  		u32 enlightenments_ebx; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EBX */
> > >  		u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
> > > +		u32 nested_features_eax; /* HYPERV_CPUID_NESTED_FEATURES.EAX */
> > >  	} cpuid_cache;
> > >  
> > >  	struct kvm_vcpu_hv_tlb_flush_ring tlb_flush_ring[HV_NR_TLB_FLUSH_RINGS];
> > > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > > index 79aabe0c33ec..68a0df4e3f66 100644
> > > --- a/arch/x86/kvm/hyperv.c
> > > +++ b/arch/x86/kvm/hyperv.c
> > > @@ -2281,6 +2281,12 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
> > >  		hv_vcpu->cpuid_cache.syndbg_cap_eax = entry->eax;
> > >  	else
> > >  		hv_vcpu->cpuid_cache.syndbg_cap_eax = 0;
> > > +
> > > +	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_NESTED_FEATURES, 0);
> > > +	if (entry)
> > > +		hv_vcpu->cpuid_cache.nested_features_eax = entry->eax;
> > > +	else
> > > +		hv_vcpu->cpuid_cache.nested_features_eax = 0;
> > >  }
> > >  
> > >  int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)
> > > diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> > > index f593c9fd1dee..d8cb6d70dbc8 100644
> > > --- a/arch/x86/kvm/hyperv.h
> > > +++ b/arch/x86/kvm/hyperv.h
> > > @@ -168,6 +168,13 @@ static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
> > >  	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
> > >  }
> > >  
> > > +static inline bool kvm_hv_l2_tlb_flush_exposed(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> > > +
> > > +	return hv_vcpu && (hv_vcpu->cpuid_cache.nested_features_eax & HV_X64_NESTED_DIRECT_FLUSH);
> > > +}
> > 
> > Tiny nipick (feel free to ignore): maybe use 'supported' instead of 'exposed',
> > as we don't use this term in KVM often.
> > 
> 
> Indeed we don't. Basically, this is guest_cpuid_has() but for a Hyper-V
> bit. I don't quite like 'supported' because we don't actually check
> whether KVM or even L1 guest 'support' this feature or not, we check
> whether the feature was 'exposed' to L1 so it can actually use it. I'm
> going to rename this to
> 
>  guest_hv_cpuid_has_l2_tlb_flush()
Sounds perfect!

Best regards,
	Maxim Levitsky

> 
> then.
> 
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> > 
> 
> Thanks!
> 


