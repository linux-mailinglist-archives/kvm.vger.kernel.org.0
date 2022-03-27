Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902FF4E8853
	for <lists+kvm@lfdr.de>; Sun, 27 Mar 2022 17:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbiC0PIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 11:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbiC0PIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 11:08:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72BB041985
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 08:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648393585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kRrEX4hnlAxo6wDrCfxKsONrmV+bOzrMHx67TeVnS8Q=;
        b=VLsz5liHFxWO96d7IyneEDMzkcazyxigZ8OWpVIscYe2Sxe8q4Ov/aTfL3N15Cm0STV9GJ
        JM3YbyIoNlTtQFiIpdchEAKNspzFyZDU6KZi7TYGH4uCDy6cRlD5wQyrYshDEmQCWRZC3i
        4rxSGkSGRsoFC2m7dUo4mHdho0D5DEw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-rJ7w-bCtNVy_7aZ85C39BA-1; Sun, 27 Mar 2022 11:06:20 -0400
X-MC-Unique: rJ7w-bCtNVy_7aZ85C39BA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EE5F80281D;
        Sun, 27 Mar 2022 15:06:17 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CD081457F13;
        Sun, 27 Mar 2022 15:06:09 +0000 (UTC)
Message-ID: <e605082ac8361c1932bfddfe2055660c7cea5f2b.camel@redhat.com>
Subject: Re: [PATCH 00/21] KVM: x86: Event/exception fixes and cleanups
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Sun, 27 Mar 2022 18:06:07 +0300
In-Reply-To: <YjzjIhyw6aqsSI7Q@google.com>
References: <20220311032801.3467418-1-seanjc@google.com>
         <08548cb00c4b20426e5ee9ae2432744d6fa44fe8.camel@redhat.com>
         <YjzjIhyw6aqsSI7Q@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-24 at 21:31 +0000, Sean Christopherson wrote:
> On Sun, Mar 13, 2022, Maxim Levitsky wrote:
> > On Fri, 2022-03-11 at 03:27 +0000, Sean Christopherson wrote:
> > > The main goal of this series is to fix KVM's longstanding bug of not
> > > honoring L1's exception intercepts wants when handling an exception that
> > > occurs during delivery of a different exception.  E.g. if L0 and L1 are
> > > using shadow paging, and L2 hits a #PF, and then hits another #PF while
> > > vectoring the first #PF due to _L1_ not having a shadow page for the IDT,
> > > KVM needs to check L1's intercepts before morphing the #PF => #PF => #DF
> > > so that the #PF is routed to L1, not injected into L2 as a #DF.
> > > 
> > > nVMX has hacked around the bug for years by overriding the #PF injector
> > > for shadow paging to go straight to VM-Exit, and nSVM has started doing
> > > the same.  The hacks mostly work, but they're incomplete, confusing, and
> > > lead to other hacky code, e.g. bailing from the emulator because #PF
> > > injection forced a VM-Exit and suddenly KVM is back in L1.
> > > 
> > > Everything leading up to that are related fixes and cleanups I encountered
> > > along the way; some through code inspection, some through tests (I truly
> > > thought this series was finished 10 commits and 3 days ago...).
> > > 
> > > Nothing in here is all that urgent; all bugs tagged for stable have been
> > > around for multiple releases (years in most cases).
> > > 
> > I am just curious. Are you aware that I worked on this few months ago?
> 
> Ah, so that's why I had a feeling of deja vu when factoring out kvm_queued_exception.
> I completely forgot about it :-/  In my defense, that was nearly a year ago[1][2], though
> I suppose one could argue 11 == "a few" :-)
> 
> [1] https://lore.kernel.org/all/20210225154135.405125-1-mlevitsk@redhat.com
> [2] https://lore.kernel.org/all/20210401143817.1030695-3-mlevitsk@redhat.com
> 
> > I am sure that you even reviewed some of my code back then.
> 
> Yep, now that I've found the threads I remember discussing the mechanics.
> 
> > If so, could you have had at least mentioned this and/or pinged me to continue
> > working on this instead of re-implementing it?
> 
> I'm invoking Hanlon's razor[*]; I certainly didn't intended to stomp over your
> work, I simply forgot.

Thank you very much for the explanation, and I am glad that it was a honest mistake.

Other than that I am actually very happy that you posted this patch series,
as this gives more chance that this long standing issue will be fixed,
and if your patches are better/simpler/less invasive to KVM and still address the issue, 
I fully support using them instead of mine.
 
Totally agree with you about your thoughts about splitting pending/injected exception,
I also can't say I liked my approach that much, for the same reasons you mentioned.
 
It is also the main reason I put the whole thing on the backlog lately, 
because I was feeling that I am changing too much of the KVM, 
for a relatively theoretical issue.
 
 
I will review your patches, compare them to mine, and check if you or I missed something.

PS:

Back then, I also did an extensive review on few cases when qemu injects exceptions itself,
which it does thankfully rarely. There are several (theoretical) issues there.
I don't remember those details, I need to refresh my memory.

AFAIK, qemu injects #MC sometimes when it gets it from the kernel in form of a signal,
if I recall this correctly, and it also reflects back #DB, when guest debug was enabled
(and that is the reason for some work I did in this area, like the KVM_GUESTDBG_BLOCKIRQ thing)

Qemu does this without considering nested and/or pending exception/etc.
It just kind of abuses the KVM_SET_VCPU_EVENTS for that.

Best regards,
	Maxim Levitsky


> 
> As for the technical aspects, looking back at your series, I strongly considered
> taking the same approach of splitting pending vs. injected (again, without any
> recollection of your work).  I ultimately opted to go with the "immediated morph
> to pending VM-Exit" approach as it allows KVM to do the right thing in almost every
> case without requiring new ABI, and even if KVM screws up, e.g. queues multiple
> pending exceptions.  It also neatly handles one-off things like async #PF in L2.
> 
> However, I hadn't considered your approach, which addresses the ABI conundrum by
> processing pending=>injected immediately after handling the VM-Exit.  I can't think
> of any reason that wouldn't work, but I really don't like splitting the event
> priority logic, nor do I like having two event injection sites (getting rid of the
> extra calls to kvm_check_nested_events() is still on my wish list).  If we could go
> back in time, I would likely vote for properly tracking injected vs. pending, but
> since we're mostly stuck with KVM's ABI, I prefer the "immediately morph to pending
> VM-Exit" hack over the "immediately morph to 'injected' exception" hack.
> 
> [*] https://en.wikipedia.org/wiki/Hanlon%27s_razor
> 


