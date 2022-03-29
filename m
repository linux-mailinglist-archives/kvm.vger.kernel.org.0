Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6094EAB90
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 12:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbiC2KrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 06:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235356AbiC2KrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 06:47:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D8322493CA
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 03:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648550738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J+6tAWF50PNYT7IFibtEUgHYGifAIptyBmiDWytebUU=;
        b=gakbVGx9Bi8Xq2nFcAjlYXePl1YZUJVeWG1Zmgl2CZrGDvlErIQ8gnueVgEK04Fw7rgeyt
        Wejb5PZijFSWB+TnVTtxPkP+nLTR4JOvZqo94hHMrjiPeLZ69VasE0QOIQa+GYsG6RrenQ
        TWavPwzD0PcnZgcwIZBl8BbWPss3OZU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-vSigWF_dMvuUTkzw0jAApA-1; Tue, 29 Mar 2022 06:45:34 -0400
X-MC-Unique: vSigWF_dMvuUTkzw0jAApA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B7F185A5A8;
        Tue, 29 Mar 2022 10:45:34 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C4A840CFD02;
        Tue, 29 Mar 2022 10:45:31 +0000 (UTC)
Message-ID: <05378896d9179b1b8652c8d838c764d22aeca2fe.camel@redhat.com>
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
Date:   Tue, 29 Mar 2022 13:45:30 +0300
In-Reply-To: <YkH1e2kyFlQN3Hl9@google.com>
References: <20220311032801.3467418-1-seanjc@google.com>
         <08548cb00c4b20426e5ee9ae2432744d6fa44fe8.camel@redhat.com>
         <YjzjIhyw6aqsSI7Q@google.com>
         <e605082ac8361c1932bfddfe2055660c7cea5f2b.camel@redhat.com>
         <YkH1e2kyFlQN3Hl9@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-03-28 at 17:50 +0000, Sean Christopherson wrote:
> On Sun, Mar 27, 2022, Maxim Levitsky wrote:
> > Other than that I am actually very happy that you posted this patch series,
> > as this gives more chance that this long standing issue will be fixed,
> > and if your patches are better/simpler/less invasive to KVM and still address the issue, 
> > I fully support using them instead of mine.
> 
> I highly doubt they're simpler or less invasive, but I do hope that the approach
> wil be easier to maintain.
>   
> > Totally agree with you about your thoughts about splitting pending/injected exception,
> > I also can't say I liked my approach that much, for the same reasons you mentioned.
> >  
> > It is also the main reason I put the whole thing on the backlog lately, 
> > because I was feeling that I am changing too much of the KVM, 
> > for a relatively theoretical issue.
> >  
> >  
> > I will review your patches, compare them to mine, and check if you or I missed something.
> > 
> > PS:
> > 
> > Back then, I also did an extensive review on few cases when qemu injects exceptions itself,
> > which it does thankfully rarely. There are several (theoretical) issues there.
> > I don't remember those details, I need to refresh my memory.
> > 
> > AFAIK, qemu injects #MC sometimes when it gets it from the kernel in form of a signal,
> > if I recall this correctly, and it also reflects back #DB, when guest debug was enabled
> > (and that is the reason for some work I did in this area, like the KVM_GUESTDBG_BLOCKIRQ thing)
> > 
> > Qemu does this without considering nested and/or pending exception/etc.
> > It just kind of abuses the KVM_SET_VCPU_EVENTS for that.
> 
> I wouldn't call that abuse, the ioctl() isn't just for migration.  Not checking for
> a pending exception is firmly a userspace bug and not something KVM should try to
> fix.

yes, but to make the right decision, the userspace has to know if there is a pending
exception, and if there is, then merge it (which might even involve triple fault),

On top of that it is possible that pending excpetion is not intercepted by L1,
but merged result is, so injecting the exception will cause nested VMexit,
which is something that is hard for userspace to model.

I think that the cleanest way to do this is to add new ioctl, KVM_INJECT_EXCEPTION,
which can do the right thing in the kernel, but I am not sure that it is worth it,
knowing that thankfully userspace doesn't inject exceptions much.



> 
> For #DB, I suspect it's a non-issue.  The exit is synchronous, so unless userspace
> is deferring the reflection, which would be architecturally wrong in and of itself,
> there can never be another pending exception. 
Could very be, but still there could be corner cases. Like what if you set data fetch
breakpoint on a IDT entry of some exception? I guess during delivery of that exception
there might be #DB, but I am not 100% expert on when and how #DB is generated, so
I can't be sure. Anyway #DB isn't a big deal because qemu only re-injects it when
guest debug is enabled and that is broken anyway, and does worse things like leaking EFLAGS.TF
to the guest stack and such.


> 
> For #MC, I think the correct behavior would be to defer the synthesized #MC if there's
> a pending exception and resume the guest until the exception is injected.  E.g. if a
> different task encounters the real #MC, the synthesized #MC will be fully asynchronous
> and may be coincident with a pending exception that is unrelated to the #MC.  That
> would require to userspace to enable KVM_CAP_EXCEPTION_PAYLOAD, otherwise userspace
> won't be able to differentiate between a pending and injected exception, e.g. if the
> #MC occurs during exception vectoring, userspace should override the injected exception
> and synthesize #MC, otherwise it would likely soft hang the guest.
Something like that, I don't remember all the details.

Best regards,
	Maxim Levitsky

> 


