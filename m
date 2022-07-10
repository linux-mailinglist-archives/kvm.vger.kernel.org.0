Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E421D56CFF1
	for <lists+kvm@lfdr.de>; Sun, 10 Jul 2022 18:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiGJQHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Jul 2022 12:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJQHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Jul 2022 12:07:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2A6D5F7D
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 09:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657469253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7cDiMFRwcLb3xRy42jRsEfwAfDPcPQNVS/oizbo1jZ0=;
        b=V+Jntkw8/WAj6wOxyMqNBCGm9DF7wFjALG85NymfDTtYp4jPWQWxXYlfJ3U49k8gMEQqMW
        9YhEtFK16hp93iTKskS7SE2zFGlmnOyCoBQfgBmFkqjVq7QC/yz7HUGaN+fiIY2/tbperq
        Frh8JkGblCowqSLY3zWo+F5gmYlHPnI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-WYrWyNiINXiQSzsq-MwwhQ-1; Sun, 10 Jul 2022 12:07:27 -0400
X-MC-Unique: WYrWyNiINXiQSzsq-MwwhQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35322101AA47;
        Sun, 10 Jul 2022 16:07:27 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7474492CA2;
        Sun, 10 Jul 2022 16:07:24 +0000 (UTC)
Message-ID: <670ce789f6139143f781bdd5ebfead79d5a4fadb.camel@redhat.com>
Subject: Re: [PATCH 5/7] KVM: SVM: Add VNMI support in inject_nmi
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Shukla, Santosh" <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 10 Jul 2022 19:07:23 +0300
In-Reply-To: <0981fd1c-b4b4-84ad-27e9-babcfa2524db@amd.com>
References: <20220602142620.3196-1-santosh.shukla@amd.com>
         <20220602142620.3196-6-santosh.shukla@amd.com>
         <dfc2ce68a10181b1ac6c07ca3927d474e13ca973.camel@redhat.com>
         <0981fd1c-b4b4-84ad-27e9-babcfa2524db@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-17 at 20:35 +0530, Shukla, Santosh wrote:
> 
> On 6/7/2022 6:44 PM, Maxim Levitsky wrote:
> > On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
> > > Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
> > > will clear V_NMI to acknowledge processing has started and will keep the
> > > V_NMI_MASK set until the processor is done with processing the NMI event.
> > > 
> > > Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> > > ---
> > >  arch/x86/kvm/svm/svm.c | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index a405e414cae4..200f979169e0 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -3385,11 +3385,16 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
> > >  {
> > >         struct vcpu_svm *svm = to_svm(vcpu);
> > >  
> > > +       ++vcpu->stat.nmi_injections;
> > > +       if (is_vnmi_enabled(svm->vmcb)) {
> > > +               svm->vmcb->control.int_ctl |= V_NMI_PENDING;
> > > +               return;
> > > +       }
> > Here I would advice to have a warning to check if vNMI is already pending.
> > 
> Yes, in v2.
> 
> > Also we need to check what happens if we make vNMI pending and get #SMI,
> > while in #NMI handler, or if #NMI is blocked due to interrupt window.
> > 
> 
> V_NMI_MASK should be saved as 1 in the save area and
> hypervisor will resume the NMI handler after handling the SMI.


Answering my own question, because I did some homework in this area while
working on that SMI int shadow bug:

Actually what will happen (now I checked) is that we have a special KVM host state flag
(called X86EMUL_SMM_MASK, and HF_SMM_INSIDE_NMI_MASK), and what we do is that if we
receive SMI while in NMI handler, we don't mask the NMI again, on RSM we don't unmask NMI.

Also, as I found out the hard way recently, the NMI is not blocked by the interrupt shadow.

I don't think that anything is saved to the SMRAM in this case.

Best regards,
	Maxim Levitsky

> 
> Thanks,
> Santosh
>  
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 
> > > +
> > >         svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
> > >         vcpu->arch.hflags |= HF_NMI_MASK;
> > >         if (!sev_es_guest(vcpu->kvm))
> > >                 svm_set_intercept(svm, INTERCEPT_IRET);
> > > -       ++vcpu->stat.nmi_injections;
> > >  }
> > >  
> > >  static void svm_inject_irq(struct kvm_vcpu *vcpu)


