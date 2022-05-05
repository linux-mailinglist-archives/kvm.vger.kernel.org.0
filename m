Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB4A51B959
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 09:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345650AbiEEHpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 03:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345527AbiEEHpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 03:45:43 -0400
X-Greylist: delayed 303 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 May 2022 00:42:04 PDT
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 734281C901
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 00:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651736523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VLRlNqVxUT2J8rpKP9C1tMXllHlMCc2mtFE3UdmkF1o=;
        b=ANme/2kUU5M7JshotflJC6kkKiABEn9g1Q4ANKtIRkIKCjtK9Pcf8rWzmXYKUj+rInedLF
        /DCD5Jx6wdXRMDOzh6PK9KD6XgBUeHCVESZRytqcjaq4snGm5s08PAz3eo7L4J/QOH7XJ/
        tl0mEFmF5ad4HK0xG6mBhjioAikVuWw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-H4NCAMwpMLKptHmppoGcfw-1; Thu, 05 May 2022 03:35:01 -0400
X-MC-Unique: H4NCAMwpMLKptHmppoGcfw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73A0C86B8AB;
        Thu,  5 May 2022 07:35:00 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5141640D2820;
        Thu,  5 May 2022 07:34:58 +0000 (UTC)
Message-ID: <c5cb5f62818a0d5aa03bd730312b93541cdeb97d.camel@redhat.com>
Subject: Re: [PATCH v3 08/14] KVM: SVM: Update AVIC settings when changing
 APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 05 May 2022 10:34:57 +0300
In-Reply-To: <f308ae5c-968d-eab4-2caa-29517e5ac982@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
         <20220504073128.12031-9-suravee.suthikulpanit@amd.com>
         <ff67344c0efe06d1422aa84e56738a0812c69bfc.camel@redhat.com>
         <f308ae5c-968d-eab4-2caa-29517e5ac982@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-05-05 at 08:38 +0700, Suravee Suthikulpanit wrote:
> Maxim,
> 
> On 5/4/22 7:19 PM, Maxim Levitsky wrote:
> > On Wed, 2022-05-04 at 02:31 -0500, Suravee Suthikulpanit wrote:
> > > Update and refresh AVIC settings when guest APIC mode is updated
> > > (e.g. changing between disabled, xAPIC, or x2APIC).
> > > 
> > > Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
> > > ---
> > >   arch/x86/kvm/svm/avic.c | 16 ++++++++++++++++
> > >   arch/x86/kvm/svm/svm.c  |  1 +
> > >   2 files changed, 17 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > index 3ebeea19b487..d185dd8ddf17 100644
> > > --- a/arch/x86/kvm/svm/avic.c
> > > +++ b/arch/x86/kvm/svm/avic.c
> > > @@ -691,6 +691,22 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
> > >   	avic_handle_ldr_update(vcpu);
> > >   }
> > >   
> > > +void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > +
> > > +	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
> > > +		return;
> > > +
> > > +	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
> > > +		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
> > > +		return;
> > > +	}
> > > +
> > > +	kvm_vcpu_update_apicv(&svm->vcpu);
> > Why to have this call? I think that all that is needed is only to call the
> > avic_refresh_apicv_exec_ctrl.
> 
> When APIC mode is updated on each vCPU, we need to check and update
> vcpu->arch.apicv_active accordingly, which happens in the kvm_vcpu_update_apicv()

This makes sense, but IMHO it would be better then to call kvm_vcpu_update_apicv
from the common code when apic mode changes then, because this logic should apply
to APICv as well.

In fact that logic of not activating AVIC was added in patch 12 
(and on second thought I think it  should be split to a separate patch), 
was added to common code, thus calling kvm_vcpu_update_apicv when the condition
of 'apic is disabled on this vCPU' should also be done by the common code.

Best regards,
	Maxim Levitsky

> 
> One test case that would fail w/o the kvm_vcpu_update_apicv() is when
> we boot a Linux guest w/ guest kernel option _nox2apic_, which Linux forces APIC
> mode of vCPUs with APIC ID 255 and higher to disable. W/o this line of code, the VM
> would not boot w/ more than 255 vCPUs.
> 
> Regards,
> Suravee
> 


