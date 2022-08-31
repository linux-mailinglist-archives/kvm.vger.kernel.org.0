Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886B85A7A6A
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 11:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiHaJnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 05:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiHaJni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 05:43:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330AAD0229
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 02:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661939014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1/RPC3U8/B6XhFjkMnHWjczBI3bfZVPLGSzFqMJ48tc=;
        b=c8hyh2Xh6dYwmdevg/6XoYqX3cWldwGHKCrMZ1rvBCNO0cgznbvPzJYt+HkqfmbnBOpnGU
        oNzADi3o9L8hRAgAe9Ywr4l0IxHahSKTAAkbZuIzw6AOUpRHwhp5eU99W5CQIcJUMVNHdK
        G40VKuz6GiQn9koBBw9WEQUuSItCY0w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-Ql1lswLhOi2iFE_xz4Xl3Q-1; Wed, 31 Aug 2022 05:43:28 -0400
X-MC-Unique: Ql1lswLhOi2iFE_xz4Xl3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4246C85A589;
        Wed, 31 Aug 2022 09:43:28 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1BB94010FA0;
        Wed, 31 Aug 2022 09:43:26 +0000 (UTC)
Message-ID: <b660f600ff5f6c107d899ced46c04de3b99c425f.camel@redhat.com>
Subject: Re: [PATCH 06/19] KVM: SVM: Get x2APIC logical dest bitmap from
 ICRH[15:0], not ICHR[31:16]
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 12:43:24 +0300
In-Reply-To: <7a7827ec2652a8409fccfe070659497df229211b.camel@redhat.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-7-seanjc@google.com>
         <7a7827ec2652a8409fccfe070659497df229211b.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 09:09 +0300, Maxim Levitsky wrote:
> On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> > When attempting a fast kick for x2AVIC, get the destination bitmap from
> > ICR[15:0], not ICHR[31:16].  The upper 16 bits contain the cluster, the
> > lower 16 bits hold the bitmap.
> > 
> > Fixes: 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
> > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/avic.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 3ace0f2f52f0..3c333cd2e752 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -368,7 +368,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
> >  
> >  		if (apic_x2apic_mode(source)) {
> >  			/* 16 bit dest mask, 16 bit cluster id */
> > -			bitmap = dest & 0xFFFF0000;
> > +			bitmap = dest & 0xFFFF;
> >  			cluster = (dest >> 16) << 4;
> >  		} else if (kvm_lapic_get_reg(source, APIC_DFR) == APIC_DFR_FLAT) {
> >  			/* 8 bit dest mask*/
> 
> I swear I have seen a patch from Suravee Suthikulpanit fixing this my mistake, I don't know why it was not
> accepted upstream.

This is the patch, which I guess got forgotten.

https://www.spinics.net/lists/kernel/msg4417427.html

Since it is literaly the same patch, you can just add credit to Suravee Suthikulpanit.

So with the credit added:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

