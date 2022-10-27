Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED1760F4B2
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 12:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiJ0KQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 06:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiJ0KQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 06:16:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65D3C696C
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 03:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666865785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EU/MMifXjM0vxwrjsl2DM4iBCID/WyK1HlEX+rO/CiY=;
        b=OE0CcDP5G78TXJBO6m60TUT0ukfh7f13V1qPeYw9ij8K9o5wNK1hTH/049rwlKM/FhX8l0
        JipIhkmGPtHqjw9UmO8VaPNei2/uRDDDvVVmyZaGmjL8Uw9Z5hXuatgzMnOT600ODLQi5m
        +t3pxdgDa8o+KoY1xYTwjJdoRvSt9Bs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-eoQ5tkw9PHyGHxeFYrj7aA-1; Thu, 27 Oct 2022 06:16:24 -0400
X-MC-Unique: eoQ5tkw9PHyGHxeFYrj7aA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3262B811E84;
        Thu, 27 Oct 2022 10:16:24 +0000 (UTC)
Received: from starship (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00C6640C2065;
        Thu, 27 Oct 2022 10:16:22 +0000 (UTC)
Message-ID: <35223fa0e5f09b33180ba161e1b2e16ce0d0669f.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 01/16] x86: make irq_enable avoid the
 interrupt shadow
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 27 Oct 2022 13:16:21 +0300
In-Reply-To: <Y1cWfiKayXy5xvji@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-2-mlevitsk@redhat.com> <Y1GNE9YdEuGPkadi@google.com>
         <a52dfb9b126354f0ec6a3f6cb514cc5e426b22ae.camel@redhat.com>
         <Y1cWfiKayXy5xvji@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-10-24 at 22:49 +0000, Sean Christopherson wrote:
> On Mon, Oct 24, 2022, Maxim Levitsky wrote:
> > On Thu, 2022-10-20 at 18:01 +0000, Sean Christopherson wrote:
> > > On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > > > Tests that need interrupt shadow can't rely on irq_enable function anyway,
> > > > as its comment states,  and it is useful to know for sure that interrupts
> > > > are enabled after the call to this function.
> > > > 
> > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > ---
> > > >  lib/x86/processor.h       | 9 ++++-----
> > > >  x86/apic.c                | 1 -
> > > >  x86/ioapic.c              | 1 -
> > > >  x86/svm_tests.c           | 9 ---------
> > > >  x86/tscdeadline_latency.c | 1 -
> > > >  x86/vmx_tests.c           | 7 -------
> > > >  6 files changed, 4 insertions(+), 24 deletions(-)
> > > > 
> > > > diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> > > > index 03242206..9db07346 100644
> > > > --- a/lib/x86/processor.h
> > > > +++ b/lib/x86/processor.h
> > > > @@ -720,13 +720,12 @@ static inline void irq_disable(void)
> > > >         asm volatile("cli");
> > > >  }
> > > >  
> > > > -/* Note that irq_enable() does not ensure an interrupt shadow due
> > > > - * to the vagaries of compiler optimizations.  If you need the
> > > > - * shadow, use a single asm with "sti" and the instruction after it.
> > > > - */
> > > >  static inline void irq_enable(void)
> > > >  {
> > > > -       asm volatile("sti");
> > > > +       asm volatile(
> > > > +                       "sti \n\t"
> > > 
> > > Formatting is odd.  Doesn't really matter, but I think this can simply be:
> > > 
> > > static inline void sti_nop(void)
> > > {
> > >         asm volatile("sti; nop");
> > 
> > "\n\t" is what gcc manual recommends for separating the assembly lines as you
> > know from the gcc manual:
> > https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html "You may place multiple
> > assembler instructions together in a single asm string, separated by  the
> > characters normally used in assembly code for the system. A combination that
> > works in  most places is a newline to break the line, plus a tab character to
> > move to the instruction  field (written as ‘\n\t’). Some assemblers allow
> > semicolons as a line separator.  However, note that some assembler dialects
> > use semicolons to start a comment"
> > 
> > Looks like gnu assembler does use semicolon for new statements and hash for comments 
> > but some assemblers do semicolon for comments.
> > 
> > I usually use just "\n", but the safest is "\n\t".
> 
> I'm pretty sure we can ignore GCC's warning here and maximize readability.  There
> are already plenty of asm blobs that use a semicolon.

IMHO this is corner cutting and you yourself said that this is wrong.

The other instances which use semicolon should be fixed IMHO.

Best regards,
	Maxim Levitsky


> 


