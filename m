Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4535357CA3C
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 14:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbiGUMF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 08:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbiGUMF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 08:05:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C92019037
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 05:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658405156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8+OSAHFKj8ZkhrxUMotDyCGFpaPNNUdkm2ihrb2xFQE=;
        b=N/BK4G6g3xwo0IlEEW9qq7LtSVrcl7S4FR+RgBegLHPpYMPj4fjFX+Gq/Ujgxi3iBaSzjR
        zKxb+n8JLmjIzay+HIBgOwaCR/MBlYxWpDV1/9w6EIMRTXhN4tLtOIuR8HfSx3DD466eXU
        crCkeLL2YBmwsI71VfFWxUqhMv2H7qo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-cPk2_nM5PySQjQgILGmMhA-1; Thu, 21 Jul 2022 08:05:53 -0400
X-MC-Unique: cPk2_nM5PySQjQgILGmMhA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE27C3801F55;
        Thu, 21 Jul 2022 12:05:52 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B229492C3B;
        Thu, 21 Jul 2022 12:05:50 +0000 (UTC)
Message-ID: <c5acc3ac2aec4b98f9211ca3f4100c358bf2f460.camel@redhat.com>
Subject: Re: [PATCHv2 4/7] KVM: SVM: Report NMI not allowed when Guest busy
 handling VNMI
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 21 Jul 2022 15:05:49 +0300
In-Reply-To: <Yth5hl+RlTaa5ybj@google.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
         <20220709134230.2397-5-santosh.shukla@amd.com>
         <Yth5hl+RlTaa5ybj@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-20 at 21:54 +0000, Sean Christopherson wrote:
> On Sat, Jul 09, 2022, Santosh Shukla wrote:
> > In the VNMI case, Report NMI is not allowed when the processor set the
> > V_NMI_MASK to 1 which means the Guest is busy handling VNMI.
> > 
> > Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> > ---
> > v2:
> > - Moved vnmi check after is_guest_mode() in func _nmi_blocked().
> > - Removed is_vnmi_mask_set check from _enable_nmi_window().
> > as it was a redundent check.
> > 
> >  arch/x86/kvm/svm/svm.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 3574e804d757..44c1f2317b45 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3480,6 +3480,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
> >  	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
> >  		return false;
> >  
> > +	if (is_vnmi_enabled(svm) && is_vnmi_mask_set(svm))
> > +		return true;
> > +
> >  	ret = (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
> >  	      (vcpu->arch.hflags & HF_NMI_MASK);
> >  
> > @@ -3609,6 +3612,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vcpu_svm *svm = to_svm(vcpu);
> >  
> > +	if (is_vnmi_enabled(svm))
> > +		return;
> 
> Ugh, is there really no way to trigger an exit when NMIs become unmasked?  Because
> if there isn't, this is broken for KVM.
> 
> On bare metal, if two NMIs arrive "simultaneously", so long as NMIs aren't blocked,
> the first NMI will be delivered and the second will be pended, i.e. software will
> see both NMIs.  And if that doesn't hold true, the window for a true collision is
> really, really tiny.
> 
> But in KVM, because a vCPU may not be run a long duration, that window becomes
> very large.  To not drop NMIs and more faithfully emulate hardware, KVM allows two
> NMIs to be _pending_.  And when that happens, KVM needs to trigger an exit when
> NMIs become unmasked _after_ the first NMI is injected.


This is how I see this:

- When a NMI arrives and neither NMI is injected (V_NMI_PENDING) nor in service (V_NMI_MASK)
  then all it is needed to inject the NMI will be to set the V_NMI_PENDING bit and do VM entry.

- If V_NMI_PENDING is set but not V_NMI_MASK, and another NMI arrives we can make the
  svm_nmi_allowed return -EBUSY which will cause immediate VM exit,

  and if hopefully vNMI takes priority over the fake interrupt we raise, it will be injected,
  and upon immediate VM exit we can inject another NMI by setting the V_NMI_PENDING again,
  and later when the guest is done with first NMI, it will take the second.

  Of course if we get a nested exception, then it will be fun....

  (the patches don't do it (causing immediate VM exit), 
  but I think we should make the svm_nmi_allowed, check for the case for 
  V_NMI_PENDING && !V_NMI_MASK and make it return -EBUSY).


- If both V_NMI_PENDING and V_NMI_MASK are set, then I guess we lose an NMI.
 (It means that the guest is handling an NMI, there is a pending NMI, and now
 another NMI arrived)

 Sean, this is the problem you mention, right?

Best regards,
	Maxim Levitsky

> 
> > +
> >  	if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
> >  		return; /* IRET will cause a vm exit */
> >  
> > -- 
> > 2.25.1
> > 


