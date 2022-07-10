Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FA556CFF9
	for <lists+kvm@lfdr.de>; Sun, 10 Jul 2022 18:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiGJQJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Jul 2022 12:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJQJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Jul 2022 12:09:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDF74D107
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 09:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657469368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wdSrLJUe8HRiEYJS8sVSl06FmRcHnl70HlnTlR1T4Aw=;
        b=HPsVtEZAKLrNX0lPxlk6p/e8GFTf/u4ndsMpzFfoLBaBoxRCaGDSt+HpDcOEn4+sEErIry
        b34sMtGr6gOgPOK+CP/8pRxAbZ182W+LpgDxc38sJgrTcLniz30v6pq/NRVpkeamzmhwer
        P5QAgszHBdq/Ypi14YvZQNgiOMTVajw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-XU9og5guMeGtdD1y62b8Hw-1; Sun, 10 Jul 2022 12:09:11 -0400
X-MC-Unique: XU9og5guMeGtdD1y62b8Hw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7689A811E80;
        Sun, 10 Jul 2022 16:09:11 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 333892166B26;
        Sun, 10 Jul 2022 16:09:09 +0000 (UTC)
Message-ID: <a0970f50d5de92917dee44c6d23dce87ad49d862.camel@redhat.com>
Subject: Re: [PATCH 3/7] KVM: SVM: Add VNMI support in get/set_nmi_mask
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Shukla, Santosh" <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 10 Jul 2022 19:09:08 +0300
In-Reply-To: <fcf79616-ccbe-1137-6080-57d00773ff83@amd.com>
References: <20220602142620.3196-1-santosh.shukla@amd.com>
         <20220602142620.3196-4-santosh.shukla@amd.com>
         <d3f2da59b5afd300531ae428174c1f91d731e655.camel@redhat.com>
         <91c551a2-11fc-202f-2a8f-75b6374286b6@amd.com>
         <fcf79616-ccbe-1137-6080-57d00773ff83@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-17 at 20:18 +0530, Shukla, Santosh wrote:
> 
> On 6/17/2022 8:15 PM, Shukla, Santosh wrote:
> > 
> > On 6/7/2022 6:37 PM, Maxim Levitsky wrote:
> > > On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
> > > > VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
> > > > NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK as
> > > > read-only in the hypervisor and do not populate set accessors.
> > > > 
> > > > Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> > > > ---
> > > >  arch/x86/kvm/svm/svm.c | 20 +++++++++++++++++++-
> > > >  1 file changed, 19 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > index 860f28c668bd..d67a54517d95 100644
> > > > --- a/arch/x86/kvm/svm/svm.c
> > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > @@ -323,6 +323,16 @@ static int is_external_interrupt(u32 info)
> > > >         return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
> > > >  }
> > > >  
> > > > +static bool is_vnmi_enabled(struct vmcb *vmcb)
> > > > +{
> > > > +       return vnmi && (vmcb->control.int_ctl & V_NMI_ENABLE);
> > > > +}
> > > 
> > > Following Paolo's suggestion I recently removed vgif_enabled(),
> > > based on the logic that vgif_enabled == vgif, because
> > > we always enable vGIF for L1 as long as 'vgif' module param is set,
> > > which is set unless either hardware or user cleared it.
> > > 
> > Yes. In v2, Thanks!.
> > 
> > > Note that here vmcb is the current vmcb, which can be vmcb02,
> > > and it might be wrong
> > > 
> > > > +
> > > > +static bool is_vnmi_mask_set(struct vmcb *vmcb)
> > > > +{
> > > > +       return !!(vmcb->control.int_ctl & V_NMI_MASK);
> > > > +}
> > > > +
> > > >  static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
> > > >  {
> > > >         struct vcpu_svm *svm = to_svm(vcpu);
> > > > @@ -3502,13 +3512,21 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
> > > >  
> > > >  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
> > > >  {
> > > > -       return !!(vcpu->arch.hflags & HF_NMI_MASK);
> > > > +       struct vcpu_svm *svm = to_svm(vcpu);
> > > > +
> > > > +       if (is_vnmi_enabled(svm->vmcb))
> > > > +               return is_vnmi_mask_set(svm->vmcb);
> > > > +       else
> > > > +               return !!(vcpu->arch.hflags & HF_NMI_MASK);
> > > >  }
> > > >  
> > > >  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> > > >  {
> > > >         struct vcpu_svm *svm = to_svm(vcpu);
> > > >  
> > > > +       if (is_vnmi_enabled(svm->vmcb))
> > > > +               return;
> > > 
> > > What if the KVM wants to mask NMI, shoudn't we update the 
> > > V_NMI_MASK value in int_ctl instead of doing nothing?
> > > 
> 
> V_NMI_MASK is cpu controlled meaning HW sets the mask while processing
> event and clears right after processing, so in away its Read-only for hypervisor.

And yet, svm_set_nmi_mask is called when KVM wants to explicitly mask NMI
without injecting a NMI, it does this when entering (emulated) SMI.

So the KVM has to set V_NMI_MASK here, becaue no real NMI is injected,
and thus the CPU will not set this bit itself.

Best regards,
	Maxim Levitsky
> 
> > > Best regards,
> > > 	Maxim Levitsky
> > > 
> > > 
> > > > +
> > > >         if (masked) {
> > > >                 vcpu->arch.hflags |= HF_NMI_MASK;
> > > >                 if (!sev_es_guest(vcpu->kvm))


