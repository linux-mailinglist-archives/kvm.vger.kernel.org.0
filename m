Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B2651B946
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 09:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345399AbiEEHmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 03:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242440AbiEEHmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 03:42:06 -0400
X-Greylist: delayed 196 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 May 2022 00:38:28 PDT
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2FF7E48E59
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 00:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651736307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b9rpry9zAS0NImcSGkX84W35fGXZlxRLYAukKDROuGs=;
        b=aKiIYOPqUjRmNxobD/m+ffB9KQQA28EJD4w4iMgARrvzMY9X1yf9GQPH2IjCZIksEsWHpB
        db7YhXDELbTQfoauYLkmj58a3SDALgBkkd+isJEdTNGNzrDSyQSqXL8Q2bO0Qqkpj1KubB
        L1YXgEnZSuy473SEzXVbxoyrfTZTeqk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-ZPodbWEcM76ip_3clU7xFQ-1; Thu, 05 May 2022 03:38:20 -0400
X-MC-Unique: ZPodbWEcM76ip_3clU7xFQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B0A3185A79C;
        Thu,  5 May 2022 07:38:20 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 39E1540CF8FE;
        Thu,  5 May 2022 07:38:18 +0000 (UTC)
Message-ID: <a323749a15c76c32bb7e94a7f65b25de122c4065.camel@redhat.com>
Subject: Re: [PATCH v3 03/14] KVM: SVM: Detect X2APIC virtualization
 (x2AVIC) support
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 05 May 2022 10:38:17 +0300
In-Reply-To: <3af75c05-40e9-2371-b5a9-c702853a974e@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
         <20220504073128.12031-4-suravee.suthikulpanit@amd.com>
         <a883ff438d6202f2dc0458dc4d7c1ab3688f5db8.camel@redhat.com>
         <3af75c05-40e9-2371-b5a9-c702853a974e@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-05-05 at 11:07 +0700, Suravee Suthikulpanit wrote:
> Maxim,
> 
> On 5/4/22 7:12 PM, Maxim Levitsky wrote:
> > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > index a8f514212b87..fc3ba6071482 100644
> > > --- a/arch/x86/kvm/svm/avic.c
> > > +++ b/arch/x86/kvm/svm/avic.c
> > > @@ -40,6 +40,15 @@
> > >   #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
> > >   #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
> > >   
> > > +enum avic_modes {
> > > +	AVIC_MODE_NONE = 0,
> > > +	AVIC_MODE_X1,
> > > +	AVIC_MODE_X2,
> > > +};
> > > +
> > > +static bool force_avic;
> > > +module_param_unsafe(force_avic, bool, 0444);
> > > +
> > >   /* Note:
> > >    * This hash table is used to map VM_ID to a struct kvm_svm,
> > >    * when handling AMD IOMMU GALOG notification to schedule in
> > > @@ -50,6 +59,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
> > >   static u32 next_vm_id = 0;
> > >   static bool next_vm_id_wrapped = 0;
> > >   static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
> > > +static enum avic_modes avic_mode;
> > >   
> > >   /*
> > >    * This is a wrapper of struct amd_iommu_ir_data.
> > > @@ -1077,3 +1087,33 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
> > >   
> > >   	avic_vcpu_load(vcpu);
> > >   }
> > > +
> > > +/*
> > > + * Note:
> > > + * - The module param avic enable both xAPIC and x2APIC mode.
> > > + * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
> > > + * - The mode can be switched at run-time.
> > > + */
> > > +bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
> > > +{
> > > +	if (!npt_enabled)
> > > +		return false;
> > > +
> > > +	if (boot_cpu_has(X86_FEATURE_AVIC)) {
> > > +		avic_mode = AVIC_MODE_X1;
> > > +		pr_info("AVIC enabled\n");
> > > +	} else if (force_avic) {
> > > +		pr_warn("AVIC is not supported in CPUID but force enabled");
> > > +		pr_warn("Your system might crash and burn");
> > I think in this case avic_mode should also be set to AVIC_MODE_X1
> > (Hopefully this won't be needed for systems that have x2avic enabled)
> 
> You are right. My appology :(
> 
> Actually, x2AVIC depends on both CPUID bits (i.e. X86_FEATURE_AVIC and X86_FEATURE_X2AVIC).
> If the force_avic option is only applicable to only the X86_FEATURE_AVIC bit, we would
> need to check for the following condition before enabling x2AVIC support in the driver:
> 
>    if ((X86_FEATURE_AVIC | avic_force) & X86_FEATURE_X2AVIC)
> 	avic_mode = AVIC_MODE_X2

Let it be just for AVIC_MODE_X1, that is

else if (force_avic) {
	pr_warn("AVIC is not supported in CPUID but force enabled");
	pr_warn("Your system might crash and burn");
	avic_mode = AVIC_MODE_X1;

Best regards,
	Maxim Levitsky

> 
> Regards,
> Suravee
> 
> 


