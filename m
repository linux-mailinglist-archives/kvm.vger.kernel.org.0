Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815775A8569
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 20:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiHaSXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 14:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbiHaSWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 14:22:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A084107C49
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 11:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661969899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wMtbO1FbesK3cKbZsffWEHVIk034aLkgY1xkmc6yWxs=;
        b=D9KY6GM0rTWXSOyQAH/af08rnEzQwZDc5Pu7V2/bVeyAc/drn700RfV34Mg5uwGSEODwlR
        4o81T84T9mRDZNKqXDOqpBtJFX/Jefhr2QOZyR1DToh7imgKUbcC2eRTsyItioBoVJky7k
        1pcXIj5TJpWqXzAatI68JY8olG8WQyw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-pI-tEFw6MQqpS3Wk6-nY5g-1; Wed, 31 Aug 2022 14:18:16 -0400
X-MC-Unique: pI-tEFw6MQqpS3Wk6-nY5g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4584C1C004E6;
        Wed, 31 Aug 2022 18:18:16 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4E0E1121314;
        Wed, 31 Aug 2022 18:18:14 +0000 (UTC)
Message-ID: <2543befdf757fca54d1b56b6a980159e16e1d5a6.camel@redhat.com>
Subject: Re: [PATCH 06/19] KVM: SVM: Get x2APIC logical dest bitmap from
 ICRH[15:0], not ICHR[31:16]
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 21:18:13 +0300
In-Reply-To: <Yw+N1BdfSansWh8h@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-7-seanjc@google.com>
         <7a7827ec2652a8409fccfe070659497df229211b.camel@redhat.com>
         <b660f600ff5f6c107d899ced46c04de3b99c425f.camel@redhat.com>
         <Yw+N1BdfSansWh8h@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 16:35 +0000, Sean Christopherson wrote:
> On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > On Wed, 2022-08-31 at 09:09 +0300, Maxim Levitsky wrote:
> > > On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> > > > When attempting a fast kick for x2AVIC, get the destination bitmap from
> > > > ICR[15:0], not ICHR[31:16].  The upper 16 bits contain the cluster, the
> > > > lower 16 bits hold the bitmap.
> > > > 
> > > > Fixes: 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
> > > > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  arch/x86/kvm/svm/avic.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > > index 3ace0f2f52f0..3c333cd2e752 100644
> > > > --- a/arch/x86/kvm/svm/avic.c
> > > > +++ b/arch/x86/kvm/svm/avic.c
> > > > @@ -368,7 +368,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
> > > >  
> > > >  		if (apic_x2apic_mode(source)) {
> > > >  			/* 16 bit dest mask, 16 bit cluster id */
> > > > -			bitmap = dest & 0xFFFF0000;
> > > > +			bitmap = dest & 0xFFFF;
> > > >  			cluster = (dest >> 16) << 4;
> > > >  		} else if (kvm_lapic_get_reg(source, APIC_DFR) == APIC_DFR_FLAT) {
> > > >  			/* 8 bit dest mask*/
> > > 
> > > I swear I have seen a patch from Suravee Suthikulpanit fixing this my mistake, I don't know why it was not
> > > accepted upstream.
> > 
> > This is the patch, which I guess got forgotten.
> > 
> > https://www.spinics.net/lists/kernel/msg4417427.html
> 
> Ah, we just missed it, doubt there's anything more than that to the story.

100% sure about it.

BTW there another minor bug I need to fix which was pointed to me by Suravee Suthikulpanit,
just so that I don't forget about it:

My code which inhibits APIC when APIC_ID != vcpu_id has a bug in regard that
when we have more that 255 vCPUs, this condition becames always true, but it is
to some extent wrong to inhibit the AVIC always in this case - there is a use case
when the guest uses only 255 vCPUs, then AVIC will work.

The relaxed condition for inhibit should be that APIC_ID == (vcpu_id & 0xFF), and it AVIC
is actually used on vCPU > 255, then it will be inhibited ( I need to check if the code
for this exists).

Best regards,
	Maxim Levitsky



> 
> > Since it is literaly the same patch, you can just add credit to Suravee Suthikulpanit.
> > 
> > So with the credit added:
> > 
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> I'll grab Suravee's patch and added your review.  Thanks!
> 


