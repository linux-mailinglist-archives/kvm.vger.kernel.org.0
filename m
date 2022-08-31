Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9A55A7701
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 09:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiHaHDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 03:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiHaHDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 03:03:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78345BB01F
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 00:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661929429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F4hkpM3t1SPDuL+oYdpd1nLRpbIa0E4FQzXvygiJGl0=;
        b=bs6t5ctzhPWN31Jxh82uC74a/U4xDdOd5WRSsGLu9Z4+tTCbF0pyEsIFCcwUfYYgl+9An0
        K/kGkh5GKwLan800O8ngEYrKplZbDQuMOq8IRpAeV9HUoYIK2ayug0CZK4ogSYN1cBwR2k
        tLK7fElFWmSr8DZUFngTlzW4dr/3yvA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-kCVIJ8jZOO-kl_vEArdlUg-1; Wed, 31 Aug 2022 03:03:46 -0400
X-MC-Unique: kCVIJ8jZOO-kl_vEArdlUg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 134EC3C0CD3C;
        Wed, 31 Aug 2022 07:03:46 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EED84010E3C;
        Wed, 31 Aug 2022 07:03:44 +0000 (UTC)
Message-ID: <ad4986e64a02fbd75d4b3f0199fae546e2cea2c6.camel@redhat.com>
Subject: Re: [PATCH 19/19] Revert "KVM: SVM: Do not throw warning when
 calling avic_vcpu_load on a running vcpu"
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 10:03:43 +0300
In-Reply-To: <fd349966a87ef3cb93fe1670e91cf6d2142ed442.camel@redhat.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-20-seanjc@google.com>
         <fd349966a87ef3cb93fe1670e91cf6d2142ed442.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 09:07 +0300, Maxim Levitsky wrote:
> On Wed, 2022-08-31 at 00:35 +0000, Sean Christopherson wrote:
> > Turns out that some warnings exist for good reasons.  Restore the warning
> > in avic_vcpu_load() that guards against calling avic_vcpu_load() on a
> > running vCPU now that KVM avoids doing so when switching between x2APIC
> > and xAPIC.  The entire point of the WARN is to highlight that KVM should
> > not be reloading an AVIC.
> > 
> > Opportunistically convert the WARN_ON() to WARN_ON_ONCE() to avoid
> > spamming the kernel if it does fire.
> > 
> > This reverts commit c0caeee65af3944b7b8abbf566e7cc1fae15c775.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/avic.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index b2033a56010c..3c300113d40b 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -1080,6 +1080,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  		return;
> >  
> >  	entry = READ_ONCE(*(svm->avic_physical_id_cache));
> > +	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
> >  
> >  	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
> >  	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
> 
> Note that this warning was removed because it would trigger wheh x2avic code would switch
> between xapic and x2apic.
> 
> I do agree 100% that this warning is useful.

Ah I see that you fixed the apic reloading to not trigger this code,
need more coffee - in this case this patch makes lot of sense.

I'll review it again when I review rest of the patches in the patch series.

Best regards,
	Maxim Levitsky
> 
> Best regards,
> 	Maxim Levitsky


