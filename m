Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0029F52BD61
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbiERMrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 08:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238493AbiERMrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 08:47:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54F221BDADB
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 05:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652877931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q7e2eynh2lki6aaMuNiuQ3yDCBpivZWLlTQmPRG6dxE=;
        b=RffSnrpAkoT3RDMNovoGaSPCyEst4bv1oEV79VAX4xI8Y6+4saznV36/jhQM+lf57AEwJY
        KdBSynuK1LDaO5do94qRlu0VKnwQfMQT/Xp/nM0pVzTyh1qxEgPkjL4ARCAxGGGOeGrWZI
        tZ9VI0BWEtQ2xREIV9AWFVYpHj0CRWw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-cnRowkt-PIydbbyHKJWn5A-1; Wed, 18 May 2022 08:45:24 -0400
X-MC-Unique: cnRowkt-PIydbbyHKJWn5A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 996B9100DDF4;
        Wed, 18 May 2022 12:45:23 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 609EA4010E4E;
        Wed, 18 May 2022 12:45:21 +0000 (UTC)
Message-ID: <aabc24621b95f627d3f8a8875074c06097f4ec8e.camel@redhat.com>
Subject: Re: [PATCH v3 13/34] KVM: nSVM: Keep track of Hyper-V
 hv_vm_id/hv_vp_id
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 18 May 2022 15:45:20 +0300
In-Reply-To: <874k1nuiw8.fsf@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-14-vkuznets@redhat.com>
         <30b0e63c0a2d3c3c40edb47af6d80e452f1e69fa.camel@redhat.com>
         <874k1nuiw8.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-18 at 14:25 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
> > > Similar to nSVM, KVM needs to know L2's VM_ID/VP_ID and Partition
> > > assist page address to handle L2 TLB flush requests.
> > > 
> > > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > ---
> > >  arch/x86/kvm/svm/hyperv.h | 16 ++++++++++++++++
> > >  arch/x86/kvm/svm/nested.c |  2 ++
> > >  2 files changed, 18 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> > > index 7d6d97968fb9..8cf702fed7e5 100644
> > > --- a/arch/x86/kvm/svm/hyperv.h
> > > +++ b/arch/x86/kvm/svm/hyperv.h
> > > @@ -9,6 +9,7 @@
> > >  #include <asm/mshyperv.h>
> > >  
> > >  #include "../hyperv.h"
> > > +#include "svm.h"
> > >  
> > >  /*
> > >   * Hyper-V uses the software reserved 32 bytes in VMCB
> > > @@ -32,4 +33,19 @@ struct hv_enlightenments {
> > >   */
> > >  #define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
> > >  
> > > +static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > +	struct hv_enlightenments *hve =
> > > +		(struct hv_enlightenments *)svm->nested.ctl.reserved_sw;
> > 
> > Small nitpick:
> > 
> > Can we use this as an opportunity to rename the 'reserved_sw' to \
> > 'hv_enlightenments' or something, because that is what it is?
> > 
> > Also the reserved_sw is an array, which is confusing, since from first look,
> > it looks like we have a pointer dereference here.
> > 
> 
> Well, that's what it is in Hyper-V world and so far we didn't give it
> another meaning in KVM but in theory it is not impossible, e.g. we can
> use this area to speed up nested KVM on KVM.
> 
> AMD calls this "Reserved for Host usage" so we can probably rename it to 
> 'reserved_host' but I'm not sure it's worth the hassle...

This is a very good piece of information. If AMD calls it like that,
than let it be.

It is probably not worth it to rename the field then, but I think it
is might be worth it to add this info as a comment to the KVM.

Also it might be worth it to add some wrapper function for
'struct hv_enlightenments *hve = (struct hv_enlightenments *)svm->nested.ctl.reserved_sw;'
(+ check if this area is valid - currently it is copied only when 'kvm_hv_hypercall_enabled == true').

Both would be a very low priority items to be honest.

Thanks,
Best regards,
	MaxiMm Levitsky


> 
> > 
> > > +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> > > +
> > > +	if (!hv_vcpu)
> > > +		return;
> > > +
> > > +	hv_vcpu->nested.pa_page_gpa = hve->partition_assist_page;
> > > +	hv_vcpu->nested.vm_id = hve->hv_vm_id;
> > > +	hv_vcpu->nested.vp_id = hve->hv_vp_id;
> > > +}
> > > +
> > >  #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index bed5e1692cef..2d1a76343404 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -826,6 +826,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
> > >  
> > >  	svm->nested.nested_run_pending = 1;
> > >  
> > > +	nested_svm_hv_update_vm_vp_ids(vcpu);
> > > +
> > >  	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
> > >  		goto out_exit_err;
> > >  
> > 
> > That won't work after migration, since this won't be called
> > if we migrate with nested guest running.
> > 
> > 
> > I think that nested_svm_hv_update_vm_vp_ids should be called 
> > from enter_svm_guest_mode.
> > 
> 
> Oh that's a good one, thanks! This could've been a hard to debug issue.
> 


