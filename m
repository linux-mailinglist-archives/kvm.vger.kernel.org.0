Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A478583C95
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 12:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbiG1K5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 06:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbiG1K5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 06:57:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9693A5C340
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 03:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659005823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=djWSv5fPHi2jGbQNYrbYdl4FpksrNeE6qDghXEwlg5c=;
        b=Hz565EgczNAVMGWGWPvAG0phJfKx9p4otVZWriyf1ZENw9A5nPz1gh3BnpO7HDW+wJayxY
        imxFBTYdrKBRj4j47Pj/AUTE6MQOefwyYTD8C3zY7EaL25gPeVIKdVi0nJZ9fiIEP49Z++
        RX3akfA8Eo59Lg4eDjpEpiSH1K79+7g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-6D5_Hst4ObOy2JZHUrSn7g-1; Thu, 28 Jul 2022 06:57:02 -0400
X-MC-Unique: 6D5_Hst4ObOy2JZHUrSn7g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE78B8037AC;
        Thu, 28 Jul 2022 10:57:01 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59DE1401473;
        Thu, 28 Jul 2022 10:57:00 +0000 (UTC)
Message-ID: <43d7341341a3211a2f16ce1b9ab376c3de35608e.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Do not virtualize MSR accesses for APIC LVTT
 register
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, jon.grimm@amd.com
Date:   Thu, 28 Jul 2022 13:56:59 +0300
In-Reply-To: <257483ff-0224-ad67-614e-2c9e6c9d99a3@amd.com>
References: <20220725033428.3699-1-suravee.suthikulpanit@amd.com>
         <6c1596d7203b7044a628c10b97eb076ad0ae525f.camel@redhat.com>
         <257483ff-0224-ad67-614e-2c9e6c9d99a3@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-28 at 15:55 +0700, Suravee Suthikulpanit wrote:
> Maxim,
> 
> On 7/28/22 2:38 PM, Maxim Levitsky wrote:
> > On Sun, 2022-07-24 at 22:34 -0500, Suravee Suthikulpanit wrote:
> > > AMD does not support APIC TSC-deadline timer mode. AVIC hardware
> > > will generate GP fault when guest kernel writes 1 to bits [18]
> > > of the APIC LVTT register (offset 0x32) to set the timer mode.
> > > (Note: bit 18 is reserved on AMD system).
> > > 
> > > Therefore, always intercept and let KVM emulate the MSR accesses.
> > > 
> > > Fixes: f3d7c8aa6882 ("KVM: SVM: Fix x2APIC MSRs interception")
> > > Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> > > ---
> > >   arch/x86/kvm/svm/svm.c | 9 ++++++++-
> > >   1 file changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index aef63aae922d..3e0639a68385 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -118,7 +118,14 @@ static const struct svm_direct_access_msrs {
> > >   	{ .index = X2APIC_MSR(APIC_ESR),		.always = false },
> > >   	{ .index = X2APIC_MSR(APIC_ICR),		.always = false },
> > >   	{ .index = X2APIC_MSR(APIC_ICR2),		.always = false },
> > > -	{ .index = X2APIC_MSR(APIC_LVTT),		.always = false },
> > > +
> > > +	/*
> > > +	 * Note:
> > > +	 * AMD does not virtualize APIC TSC-deadline timer mode, but it is
> > > +	 * emulated by KVM. When setting APIC LVTT (0x832) register bit 18,
> > > +	 * the AVIC hardware would generate GP fault. Therefore, always
> > > +	 * intercept the MSR 0x832, and do not setup direct_access_msr.
> > > +	 */
> > >   	{ .index = X2APIC_MSR(APIC_LVTTHMR),		.always = false },
> > >   	{ .index = X2APIC_MSR(APIC_LVTPC),		.always = false },
> > >   	{ .index = X2APIC_MSR(APIC_LVT0),		.always = false },
> > 
> > LVT is not something I would expect x2avic to even try to emulate, I would expect
> > it to dumbly forward the write to apic backing page (garbage in, garbage out) and then
> > signal trap vmexit?
> > 
> > I also think that regular AVIC works like that (just forwards the write to the page).
> 
> The main difference b/w AVIC and x2AVIC is the MSR interception control, which needs to
> not-intercept x2APIC MSRs for x2AVIC (allowing HW to virtualize MSR accesses).
> However, the hypervisor can decide which x2APIC MSR to intercept and emulate.


> 
> > I am asking because there is a remote possibility that due to some bug the guest got
> > direct access to x2apic registers of the host, and this is how you got that #GP.
> > Could you double check it?
> 
> I have verified this behavior with the HW designer and requested them to document
> this in the next AMD programmers manual that will include x2AVIC details.

I guess this implies that when guest has direct access to LVTT msr, x2avic redirection
happens after microcode already checked some things, like reserved bits.

You are also welcome to check vs hardware team, how all other apic msrs behave - there could be similar
cases, maybe even some msrs which don't go through x2avic flow.

Assuming that this it is really the case (I am just very afraid of CVEs),
then this patch is all right.

So with all that said:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> > We really need x2avic (and vNMI) spec to be published to know exactly how all of this
> > is supposed to work.
> 
> I have raised the concern to the team responsible for publishing the doc.
> 
> Best Regards,
> Suravee
> 


