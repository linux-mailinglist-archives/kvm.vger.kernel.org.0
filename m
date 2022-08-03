Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D030D5892CE
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 21:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbiHCTfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 15:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiHCTe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 15:34:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCC30E5E
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 12:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659555295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ol5/DqxddFZ4BAtkyhBvW+y2rS0eKBcgrLEzGa8qNys=;
        b=dZLqyr9gxUedtBk5bKJJNhTq2VvtoAtMhWZhCHPoz7Gf2lL332SzmJBbADVPHFc0BmB1R6
        CV+3+3xdvrI1+yGyVZs9NfMzklLCoqvrB/tXBAHUng/+p9Ot7EUMpdE7JsIvV83kLPhkoE
        9N80pfSJ1rtfg4ofW2zME4E/mmKQJyI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-gOk7WubEMHGqo2gqfqE9rA-1; Wed, 03 Aug 2022 15:34:52 -0400
X-MC-Unique: gOk7WubEMHGqo2gqfqE9rA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 375958032F1;
        Wed,  3 Aug 2022 19:34:52 +0000 (UTC)
Received: from starship (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C1F41121314;
        Wed,  3 Aug 2022 19:34:49 +0000 (UTC)
Message-ID: <17505e309d02cf5a96e33f75ccdd6437a8c79222.camel@redhat.com>
Subject: Re: [PATCH 1/5] KVM: x86: Get vmcs12 pages before checking pending
 interrupts
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Date:   Wed, 03 Aug 2022 22:34:48 +0300
In-Reply-To: <CAL715WLQa5yz7SWAfOBUzQigv2JG1Ao+rwbeSJ++rKccVoZeag@mail.gmail.com>
References: <20220802230718.1891356-1-mizhang@google.com>
         <20220802230718.1891356-2-mizhang@google.com>
         <b03adf94-5af2-ff5e-1dbb-6dd212790083@redhat.com>
         <CAL715WLQa5yz7SWAfOBUzQigv2JG1Ao+rwbeSJ++rKccVoZeag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-03 at 10:51 -0700, Mingwei Zhang wrote:
> On Wed, Aug 3, 2022 at 10:18 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > On 8/3/22 01:07, Mingwei Zhang wrote:
> > > +     /*
> > > +      * We must first get the vmcs12 pages before checking for interrupts
> > > +      * that might unblock the guest if L1 is using virtual-interrupt
> > > +      * delivery.
> > > +      */
> > > +     if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> > > +             /*
> > > +              * If we have to ask user-space to post-copy a page,
> > > +              * then we have to keep trying to get all of the
> > > +              * VMCS12 pages until we succeed.
> > > +              */
> > > +             if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
> > > +                     kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> > > +                     return 0;
> > > +             }
> > > +     }
> > > +
> > 
> > I think request handling (except for KVM_REQ_EVENT) could be more
> > generically moved from vcpu_enter_guest() to vcpu_run().
> 
> Yeah, sounds good to me. I can come up with an updated version. At
> least, I will remove the repeat request here.


Now it all makes sense. I do think that KVM_REQ_GET_NESTED_STATE_PAGES processing
when the vCPU is halted is indeed missing.

This reminds me that I would be *very* happy to remove the KVM_REQ_GET_NESTED_STATE_PAGES,
if by any chance there is an agreement to do so upstream.
This is yet another reason to do so to be honest.
Just my 0.2 cents of course.


Best regards,
	Maxim Levitsky



PS:
This also reminded me of an related issue:
https://lore.kernel.org/lkml/20220427173758.517087-1-pbonzini@redhat.com/T/
Any update on it?

> 
> > Paolo
> > 


