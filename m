Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7682364D990
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 11:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiLOKaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 05:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiLOKaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 05:30:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF7A2B637
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 02:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671100175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+b33YidOzkUiisCIlUSR3ymMkkTJ/Mkj17LYCbl/uXA=;
        b=CwZqX5NSkK7jbh6Rgq9DLir3cjOEys5el8XeCZBVe52lCxydEoXZSFejL50z134GWoekZO
        urYGIZRQTDcodULhvpUpURUh8EJ/eWcJiHoD6F6q2XL1WVVeBhsVIn01QGLa/q5SdiQrUW
        I8cyeBmBl5FdEnHwKW2dlSYPrygaN1s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-R8Rrq4qWPrSBnkmQUVkURg-1; Thu, 15 Dec 2022 05:29:33 -0500
X-MC-Unique: R8Rrq4qWPrSBnkmQUVkURg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3284F811E6E;
        Thu, 15 Dec 2022 10:29:33 +0000 (UTC)
Received: from starship (ovpn-192-71.brq.redhat.com [10.40.192.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B91C14171BE;
        Thu, 15 Dec 2022 10:29:32 +0000 (UTC)
Message-ID: <0d0ee4ff7e57996342e3eaa3bb714a43d8fa6628.camel@redhat.com>
Subject: Re: RFC: few questions about hypercall patching in KVM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date:   Thu, 15 Dec 2022 12:29:31 +0200
In-Reply-To: <Y5pv+/58UBDAfP19@google.com>
References: <9c7d86d5fd56aa0e35a9a1533a23c90853382227.camel@redhat.com>
         <Y5pv+/58UBDAfP19@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-12-15 at 00:53 +0000, Sean Christopherson wrote:
> On Wed, Dec 14, 2022, Maxim Levitsky wrote:
> > Hi!
> > 
> > 
> > Recently I had to debug a case of KVM's hypercall patching failing in a
> > special case of running qemu under valgrind.
> >  
> > In nutshell what is happening is that qemu uses 'cpuid' instruction to gather
> > some info about the host and some of it is passed to the guest cpuid, and
> > that includes the vendor string.
> >  
> > Under valgrind it emulates the CPU (aka TCG), so qemu sees virtual cpu, with
> > virtual cpuid which has hardcoded vendor string the 'GenuineIntel', so when
> > your run qemu with KVM on AMD host, the guest will see Intel's vendor string
> > regardless of other '-cpu' settings (even -cpu host)
> >  
> > This ensures that the guest uses the wrong hypercall instruction (vmcall
> > instead of vmmcall), and sometimes it will use it after the guest kernel
> > write protects its memory.  This will lead to a failure of the hypercall
> > patching as the kvm writes to the guest memory as if the instruction wrote to
> > it, and this checks the permissions in the guest paging.
> > 
> > So the VMCALL instruction gets totally unexpected #PF.
> 
> Yep, been there, done that :-)
> 
> > 1. Now I suggest that when hypercall patching fails, can we do
> > kvm_vm_bugged() instead of forwarding the hypercall?  I know that vmmcall can
> > be executed from ring 3 as well, so I can limit this to hypercall patching
> > that happens when guest ring is 0.
> 
> And L1.  But why?  It's not a KVM bug per se, it's a known deficiency in KVM's
> emulator.  What to do in response to the failure should be up to userspace.  The
> real "fix" is to disable the quirk in QEMU.

Yes, and L1, you are right - I thought about nested case, that maybe it is possible
to eliminate it, but you are right, it can't be eliminated.

My reasoning for doing kvm_vm_bugged() (or returning X86EMUL_UNHANDLEABLE even better maybe,
to give userspace a theoretical chance of dealing with it) 

is to make the error at least a bit more visible. 
(I for example thought for a while that there is some memory corrupion in the guest caused by valgrind,
which cause that #PF)


> 
> > 2. Why can't we just emulate the VMCALL/VMMCALL instruction in this case
> > instead of patching? Any technical reasons for not doing this?  Few guests
> > use it so the perf impact should be very small.
> 
> Nested is basically impossible to get right[1][2].  IIRC, calling into
> kvm_emulate_hypercall() from the emulator also gets messy (I think I tried doing
> exactly this at some point).

It could very well be, however if L0's KVM starts to emulate both VMMCALL and VMCALL
instructions (when the quirk is enabled) then it will be the closest to what KVM always did,
and it will not overwrite the guest memory.

About calling into kvm_emulate_hypercall I can expect trouble, but I would be very happy
if you recall which problems did you face.


Note that at least for a nested guest, we can avoid patching right away because both VMMCALL and VMCALL
that are done in nested guest will never need to call kvm_emulate_hypercall().

VMCALL is always intercepted by L1 as defined by VMX spec, while VMMCALL if not intercepted causes #UD
in the guest.

In those cases emulation is very simple.

As for L1, we already have a precedent: #GP is sometimes
emulated as SVM instruction due to the AMD's errata.


Look at gp_interception:

You first decode the instruciton, and if it is VMCALL, then call the kvm_emulate_hypercall()
This way there is no recursive emulator call.

What do you think?



Best regards,
	Maxim Levitsky


> 
> [1] https://lore.kernel.org/all/Yjyt7tKSDhW66fnR@google.com 
> [2] https://lore.kernel.org/all/YEZUhbBtNjWh0Zka@google.com
> 


