Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F47A5A8528
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 20:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbiHaSNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 14:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbiHaSMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 14:12:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3557EA926E
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 11:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661969448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HtanDUyn5fWOiylnSZSGqVRKIcfPLDAAzDH/PpQv72s=;
        b=RKgoJBhe+VKO8HSA8XRTytJT50ZAhAZ3To6MW3HV9NBl76ZJy3SRIi1PJNsmH5iUEHhPUU
        FFU0qyXf29ha1fS5wNnct3e9NOegH0AHFfFbbxMHOud2DxSXzaYO++r1wfiXgLc4+jw5cm
        UEB/A9hz8O3gFwBzjhF+4zrKNrb8Rzg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-EmCRBavSNBKEoWM3mp6aNw-1; Wed, 31 Aug 2022 14:10:45 -0400
X-MC-Unique: EmCRBavSNBKEoWM3mp6aNw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B292101036A;
        Wed, 31 Aug 2022 18:10:44 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B831340C1421;
        Wed, 31 Aug 2022 18:10:42 +0000 (UTC)
Message-ID: <3e51ca310ccd1f2f075d29972e6b55520fac2796.camel@redhat.com>
Subject: Re: [PATCH 07/19] KVM: SVM: Drop buggy and redundant AVIC "single
 logical dest" check
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 21:10:41 +0300
In-Reply-To: <Yw+OUa3l1Rg036fb@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-8-seanjc@google.com>
         <dd8c92855762258d87486f719bf7e52e36169ef2.camel@redhat.com>
         <Yw+OUa3l1Rg036fb@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 16:37 +0000, Sean Christopherson wrote:
> On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> > > Use the already-calculated-and-sanity-checked destination bitmap when
> > > processing a fast AVIC kick in logical mode, and drop the logical path's
> > > flawed logic.  The intent of the check is to ensure the bitmap is a power
> > > of two, whereas "icrh != (1 << avic)" effectively checks that the bitmap
> > > is a power of two _and_ the target cluster is '0'.
> > > 
> > > Note, the flawed check isn't a functional issue, it simply means that KVM
> > > will go down the slow path if the target cluster is non-zero.
> > > 
> > > Fixes: 8c9e639da435 ("KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible")
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/svm/avic.c | 10 +---------
> > >  1 file changed, 1 insertion(+), 9 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > index 3c333cd2e752..14f567550a1e 100644
> > > --- a/arch/x86/kvm/svm/avic.c
> > > +++ b/arch/x86/kvm/svm/avic.c
> > > @@ -411,15 +411,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
> > >  			 * Instead, calculate physical ID from logical ID in ICRH.
> > >  			 */
> > >  			int cluster = (icrh & 0xffff0000) >> 16;
> > > -			int apic = ffs(icrh & 0xffff) - 1;
> > > -
> > > -			/*
> > > -			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0])
> > > -			 * contains anything but a single bit, we cannot use the
> > > -			 * fast path, because it is limited to a single vCPU.
> > > -			 */
> > > -			if (apic < 0 || icrh != (1 << apic))
> > > -				return -EINVAL;
> > > +			int apic = ffs(bitmap) - 1;
> > >  
> > >  			l1_physical_id = (cluster << 4) + apic;
> > >  		}
> > 
> > Oh, I didn't notice this bug. However isn't removing the check is wrong as well?
> > 
> > What if we do have multiple bits set in the bitmap? After you remove this code,
> > we will set IPI only to APIC which matches the 1st bit, no?
> 
> The common code (out of sight here) already ensures the bitmap has exactly one bit set:
> 
>                 if (unlikely(!bitmap))
>                         /* guest bug: nobody to send the logical interrupt to */
>                         return 0;
> 
>                 if (!is_power_of_2(bitmap))
>                         /* multiple logical destinations, use slow path */
>                         return -EINVAL;
> 
>                 logid_index = cluster + __ffs(bitmap);
> 
Ah right, but again because the patch that added x2apic logic after I already added should not
be added. I vote again to just revert it.

Best regards,
	Maxim Levitsky

