Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F775A8555
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 20:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbiHaSRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 14:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiHaSRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 14:17:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5BB9F744
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 11:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661969582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uE4KJW14kc3gE1qAWoSUzP1OSr0PXZymBaEjR1U5HqE=;
        b=LLmPDOBpYVBtKbCnX69zoyIN6aHaKoayTNiwS2yuYhDq/RIrFv9DqWO/sRl1b5bP99D67v
        1JNzfQ9dr+PLl51ns0Sk4Au3XdrMmwUI+rXj7WA8Ew89XmctJ4C/SdD/RIHI4TPuUjtMq5
        xh1oys23RO1buJfieGbNXAD4k5eLGB0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-VTVB-NxDP2irnQSeEC6Fww-1; Wed, 31 Aug 2022 14:12:59 -0400
X-MC-Unique: VTVB-NxDP2irnQSeEC6Fww-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C6348037AA;
        Wed, 31 Aug 2022 18:12:59 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC7DAC15BB3;
        Wed, 31 Aug 2022 18:12:57 +0000 (UTC)
Message-ID: <eac344b89e16721a0c2ac5e25dad78b4826d67d6.camel@redhat.com>
Subject: Re: [PATCH 11/19] KVM: SVM: Add helper to perform final AVIC "kick"
 of single vCPU
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 21:12:56 +0300
In-Reply-To: <Yw95XR59VQSbVlY9@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-12-seanjc@google.com>
         <9144c9921bd46ba7c2b2e9427d053b1fc5abccf7.camel@redhat.com>
         <Yw95XR59VQSbVlY9@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 15:08 +0000, Sean Christopherson wrote:
> On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> > > @@ -455,13 +461,8 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
> > >  	 */
> > >  	kvm_for_each_vcpu(i, vcpu, kvm) {
> > >  		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
> > > -					dest, icrl & APIC_DEST_MASK)) {
> > > -			vcpu->arch.apic->irr_pending = true;
> > > -			svm_complete_interrupt_delivery(vcpu,
> > > -							icrl & APIC_MODE_MASK,
> > > -							icrl & APIC_INT_LEVELTRIG,
> > > -							icrl & APIC_VECTOR_MASK);
> > > -		}
> > > +					dest, icrl & APIC_DEST_MASK))
> > > +			avic_kick_vcpu(vcpu, icrl);
> > >  	}
> > >  }
> > >  
> > 
> > I don't know what I think about this, sometimes *minor* code duplication
> > might actually be a good thing, as it is easier to read the code, but I don't
> > have much against this as well.
> > 
> > I am not sure if before or after this code is more readable.
> 
> I don't have a strong opinion either.  I think I prefer having the helper, but
> have no objection to leaving things as is.  Originally I was thinking there was
> going to be a third call site, but that didn't happen.
> 

Yep - when something is duplicated 3 times, it is really rare to not want to have a helper,
Anyway I don't have a strong opinion about this either.

I mostly was unsure about the fact that helper receives icrl and not icrh, kind of wierd,
but anyway let it be.

Best regards,
	Maxim Levitsky

