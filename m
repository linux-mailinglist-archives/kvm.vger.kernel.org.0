Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381DD60F4C2
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 12:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbiJ0KT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 06:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbiJ0KTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 06:19:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DE3DEFF
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 03:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666865992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7LiGwVV7Z/rSRvoDEmBeon+fRe0OXwYSf4QjAKFz5xk=;
        b=Dq/ksgxM9qb5VctyPNrhiQHWskWxUNOPvPuQjoZXY5GPkylVZ6RkIoDIKrWhHjDWC09pZU
        VcW61uz1eRhZTbbQZQrCLVt9p4qidIKhv+jaZeQGAyoAioKBysFxw2r9i+1cXzttQNg2Ok
        pplSBIPK50J0HimOklwJprMerfVyrtY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-MlAHeA1-PjW7g7iEAfJDog-1; Thu, 27 Oct 2022 06:19:49 -0400
X-MC-Unique: MlAHeA1-PjW7g7iEAfJDog-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7F201C08797;
        Thu, 27 Oct 2022 10:19:48 +0000 (UTC)
Received: from starship (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B73151415117;
        Thu, 27 Oct 2022 10:19:47 +0000 (UTC)
Message-ID: <b006eda72356d75b5ee308c3a91bf3359bb6e9ab.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 02/16] x86: add few helper functions for
 apic local timer
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 27 Oct 2022 13:19:46 +0300
In-Reply-To: <Y1a49abli07rqyww@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-3-mlevitsk@redhat.com> <Y1GeEoC7qMz40QDc@google.com>
         <de3d97ff23cc401e916b15b47207b45514446e4d.camel@redhat.com>
         <Y1a49abli07rqyww@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-10-24 at 16:10 +0000, Sean Christopherson wrote:
> On Mon, Oct 24, 2022, Maxim Levitsky wrote:
> > On Thu, 2022-10-20 at 19:14 +0000, Sean Christopherson wrote:
> > > On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > > > +       // ensure that a pending timer is serviced
> > > > +       irq_enable();
> > > 
> > > Jumping back to the "nop" patch, I'm reinforcing my vote to add sti_nop().  I
> > > actually starting typing a response to say this is broken before remembering that
> > > a nop got added to irq_enable().
> > 
> > OK, although, for someone that doesn't know about the interrupt shadow (I
> > guess most of the people that will look at this code), the above won't
> > confuse them, in fact sti_nop() might confuse someone who doesn't know about
> > why this nop is needed.
> 
> The difference is that sti_nop() might leave unfamiliar readers asking "why", but
> it won't actively mislead them.  And the "why" can be easily answered by a comment
> above sti_nop() to describe its purpose.  A "see also safe_halt()" with a comment
> there would be extra helpful, as "safe halt" is the main reason the STI shadow is
> even a thing.
> 
> On the other hand, shoving a NOP into irq_enable() is pretty much guaranteed to
> cause problems for readers that do know about STI shadows since there's nothing
> in the name "irq_enable" that suggests that the helper also intentionally eats the
> interrupt shadow, and especically because the kernel's local_irq_enable() distills
> down to a bare STI.

I still don't agree with you on this at all. I would like to hear what other KVM developers
think about it.

safe_halt actually is a example for function that abstacts away the nop - just what I want to do.

A comment in irq_enable() about that nop also is fine to have.

Best regards,
	Maxim Levitsky


> 


