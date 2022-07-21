Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540C957CA1F
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 13:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiGUL5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 07:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbiGUL5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 07:57:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01FD610B1
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 04:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658404630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E0E6tU6gY5NO+RqEHYg9V7mVYbdn26+2ozaiEoyYI8s=;
        b=G681fT6Ar3RIteVNdNaibi3G7cQ003TBdkf9VvamYvrsxowEXkLo7AcAm/BDZKdtxlOHzb
        auTjLdBNmwQWSEt9/i2a3UD7bpPZ0zDr6dSLaRHoBgihf3oPl/gqXAdJ/JW5/jEpactqKR
        944w16ze5QaZJjyIT/8x4xuVI5o6N+o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-neNqakEbPvqBw9t7gQb52g-1; Thu, 21 Jul 2022 07:56:58 -0400
X-MC-Unique: neNqakEbPvqBw9t7gQb52g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84A34802D2C;
        Thu, 21 Jul 2022 11:56:57 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37D6A2026985;
        Thu, 21 Jul 2022 11:56:55 +0000 (UTC)
Message-ID: <44938d77b4ee62b69ad3ff88be30c942282a05d7.camel@redhat.com>
Subject: Re: [PATCH 4/7] KVM: SVM: Report NMI not allowed when Guest busy
 handling VNMI
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Shukla, Santosh" <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 21 Jul 2022 14:56:54 +0300
In-Reply-To: <ca108529-9252-5f1d-cbd1-51a43b476ce9@amd.com>
References: <20220602142620.3196-1-santosh.shukla@amd.com>
         <20220602142620.3196-5-santosh.shukla@amd.com>
         <da6e0e9375d1286d3d9d4b6ab669d234850261eb.camel@redhat.com>
         <45e9ccafcdb48c7521b697b41e849dab98a7a76c.camel@redhat.com>
         <ac67da62-a0c0-27a4-df81-90734382ffdf@amd.com>
         <76e007d7fc7af0629279f2563f8d0c48274bc774.camel@redhat.com>
         <ca108529-9252-5f1d-cbd1-51a43b476ce9@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-21 at 15:01 +0530, Shukla, Santosh wrote:
> 
> On 7/10/2022 9:38 PM, Maxim Levitsky wrote:
> > On Fri, 2022-06-17 at 20:29 +0530, Shukla, Santosh wrote:
> > > On 6/7/2022 6:42 PM, Maxim Levitsky wrote:
> > > > On Tue, 2022-06-07 at 16:10 +0300, Maxim Levitsky wrote:
> > > > > On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
> > > > > > In the VNMI case, Report NMI is not allowed when the processor set the
> > > > > > V_NMI_MASK to 1 which means the Guest is busy handling VNMI.
> > > > > > 
> > > > > > Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> > > > > > ---
> > > > > >  arch/x86/kvm/svm/svm.c | 6 ++++++
> > > > > >  1 file changed, 6 insertions(+)
> > > > > > 
> > > > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > > > index d67a54517d95..a405e414cae4 100644
> > > > > > --- a/arch/x86/kvm/svm/svm.c
> > > > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > > > @@ -3483,6 +3483,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
> > > > > >         struct vmcb *vmcb = svm->vmcb;
> > > > > >         bool ret;
> > > > > >  
> > > > > > +       if (is_vnmi_enabled(vmcb) && is_vnmi_mask_set(vmcb))
> > > > > > +               return true;
> > > > > 
> > > > > How does this interact with GIF? if the guest does clgi, will the
> > > > > CPU update the V_NMI_MASK on its own If vGIF is enabled?
> > > > > 
> > > Yes.
> > > 
> > > > > What happens if vGIF is disabled and vNMI is enabled? KVM then intercepts
> > > > > the stgi/clgi, and it should then update the V_NMI_MASK?
> > > > > 
> > > No.
> > > 
> > > For both case - HW takes the V_NMI event at the boundary of VMRUN instruction.
> > 
> > How that is possible? if vGIF is disabled in L1, then L1 can't execute STGI/CLGI - 
> > that means that the CPU can't update the V_NMI, as it never sees the STGI/CLGI
> > beeing executed.
> > 
> 
> If vGIF is disabled then HW will take the vnmi event at the boundary of vmrun instruction.


I think I understand now, if vGIF is enabled, and V_NMI_MASK is set, and the guest does STGI, then nothing
new should be injected.

If V_NMI_MASK is not set, then svm_nmi_blocked will respect the HF_GIF_MASK, and on STGI interception,
the new NMI will be injected on VM entry by setting the V_NMI_PENDING.

So looks like it should work.

Thanks,
	Best regards,
		Maxim Levitsky


> 
> Thanks,
> Santosh
> 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > > > > 
> > > > > > +
> > > > > >         if (!gif_set(svm))
> > > > > >                 return true;
> > > > > >  
> > > > > > @@ -3618,6 +3621,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> > > > > >  {
> > > > > >         struct vcpu_svm *svm = to_svm(vcpu);
> > > > > >  
> > > > > > +       if (is_vnmi_enabled(svm->vmcb) && is_vnmi_mask_set(svm->vmcb))
> > > > > > +               return;
> > > > > 
> > > > > This might have hidden assumption that we will only enable NMI window when vNMI is masked.
> > > > 
> > > > Also what if vNMI is already pending?
> > > > 
> > > If V_NMI_MASK set, that means V_NMI is pending, if so then inject another V_NMI in next VMRUN.
> > > 
> > > Thanks,
> > > Santosh
> > > 
> > > > Best regards,
> > > > 	Maxim Levitsky
> > > > > 
> > > > > > +
> > > > > >         if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
> > > > > >                 return; /* IRET will cause a vm exit */
> > > > > >  
> > > > > 
> > > > > Best regards,
> > > > >         Maxim Levitsky


