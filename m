Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A89D5A84CE
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 19:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiHaRyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 13:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbiHaRyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 13:54:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4984CDF098
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 10:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661968440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=83UeBlTXkZlPfDjGH2tInHwryedeCfsq3pruEuPg7pU=;
        b=G+qO0I4XbzDPO6pmoVDT35qF1Nd52Nyl0dmOopwEzA0H+RkwSVYdZyRlQ6EE8S7FRihlgs
        jWYwiYmKBc/gpm1Vkb7KutLgT8Bmis4Pa8K6O+oBQthRplbfGMQxZUjHhupvBjo0Pu7rSQ
        AHcn74GJPfWuGaojscMh/kc5gaDSFcM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-W5dFUaQbPmKxvdc2-PLgIw-1; Wed, 31 Aug 2022 13:53:54 -0400
X-MC-Unique: W5dFUaQbPmKxvdc2-PLgIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53494185A7B2;
        Wed, 31 Aug 2022 17:53:54 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B177F1415117;
        Wed, 31 Aug 2022 17:53:52 +0000 (UTC)
Message-ID: <510a641f6393ff11c00277df58c1d2a7b6e9a696.camel@redhat.com>
Subject: Re: [PATCH 16/19] KVM: x86: Explicitly track all possibilities for
 APIC map's logical modes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 20:53:51 +0300
In-Reply-To: <Yw+Sz+5rB+QNP2Z9@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-17-seanjc@google.com>
         <8d3569a8b2d1563eb3ff665118ffc5c8d7e1e2f2.camel@redhat.com>
         <Yw+Sz+5rB+QNP2Z9@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 16:56 +0000, Sean Christopherson wrote:
> On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 8209caffe3ab..3b6ef36b3963 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -168,7 +168,12 @@ static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
> > >  
> > >  static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
> > >  		u32 dest_id, struct kvm_lapic ***cluster, u16 *mask) {
> > > -	switch (map->mode) {
> > > +	switch (map->logical_mode) {
> > > +	case KVM_APIC_MODE_SW_DISABLED:
> > > +		/* Arbitrarily use the flat map so that @cluster isn't NULL. */
> > > +		*cluster = map->xapic_flat_map;
> > > +		*mask = 0;
> > > +		return true;
> > Could you explain why this is needed? I probably missed something.
> 
> If all vCPUs leave their APIC software disabled, or leave LDR=0, then the overall
> mode will be KVM_APIC_MODE_SW_DISABLED.  In this case, the effective "mask" is '0'
> because there are no targets.  And this returns %true because there are no targets,
> i.e. there's no need to go down the slow path after kvm_apic_map_get_dest_lapic().

I guess this case doesn't need optimization (although maybe some OSes do leave all LDRs to 0,
if they don't use logical addressing, don't know)

Anyway thanks, that makes sense.

> 
> > > @@ -993,7 +1011,7 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
> > >  {
> > >  	if (kvm->arch.x2apic_broadcast_quirk_disabled) {
> > >  		if ((irq->dest_id == APIC_BROADCAST &&
> > > -				map->mode != KVM_APIC_MODE_X2APIC))
> > > +		     map->logical_mode != KVM_APIC_MODE_X2APIC))
> > >  			return true;
> > >  		if (irq->dest_id == X2APIC_BROADCAST)
> > >  			return true;
> > 
> > To be honest I would put that patch first, and then do all the other patches,
> > this way you would avoid all of the hacks they do and removed here.
> 
> I did it this way so that I could test this patch for correctness.  Without the
> bug fixes in place it's not really possible to verify this patch is 100% correct.
> 
> I completely agree that it would be a lot easier to read/understand/review if
> this came first, but I'd rather not sacrifice the ability to easily test this patch.
> 

I am not 100% sure about this, but I won't argue about it, let it be.

Best regards,
	Maxim Levitsky

