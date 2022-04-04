Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628344F1255
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 11:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354731AbiDDJwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 05:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354715AbiDDJwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 05:52:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0E633A73E
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 02:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649065853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UnGPjnMk0HWFLFp7dnhS2WarhT53NPNrXRrJQZdc19E=;
        b=XyKvPrT20gFXl4Jt3GiFN4LhG7LSA8kjCcbnCWke5fSTdl7hXTUUUChr8s/caoKMUihePq
        c176Dl0IIL7I7IIvlM+xRYRUZ2J3RlNcX4MvDbcD1h0IkGS4INVKv9gYo04soevK8Z78l1
        5RCUcTRkzTFzeNCoAqFL67vE1O0RmmM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-hwBMZr7cPFq81Zbfr0yabA-1; Mon, 04 Apr 2022 05:50:48 -0400
X-MC-Unique: hwBMZr7cPFq81Zbfr0yabA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA0813C14CC3;
        Mon,  4 Apr 2022 09:50:47 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DBCB2156732;
        Mon,  4 Apr 2022 09:50:44 +0000 (UTC)
Message-ID: <c28620cdf5d1ce37b30e39355631fda0f3e6324a.camel@redhat.com>
Subject: Re: [PATCH 1/5] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jon Grimm <Jon.Grimm@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 04 Apr 2022 12:50:43 +0300
In-Reply-To: <Ykdz4GVF4C+S/LGg@google.com>
References: <cover.1646944472.git.maciej.szmigiero@oracle.com>
         <19c757487eeeff5344ff3684fe9c090235b07d05.1646944472.git.maciej.szmigiero@oracle.com>
         <YkdFSuezZ1XNTTfx@google.com>
         <ff29e77c-f16d-d9ef-9089-0a929d3c2fbf@maciej.szmigiero.name>
         <Ykdz4GVF4C+S/LGg@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-04-01 at 21:51 +0000, Sean Christopherson wrote:
> On Fri, Apr 01, 2022, Maciej S. Szmigiero wrote:
> > On 1.04.2022 20:32, Sean Christopherson wrote:
> > > On Thu, Mar 10, 2022, Maciej S. Szmigiero wrote:
> > > > +	/* The return address pushed on stack by the CPU for some injected events */
> > > > +	svm->vmcb->control.next_rip            = svm->nested.ctl.next_rip;
> > > 
> > > This needs to be gated by nrips being enabled _and_ exposed to L1, i.e.
> > > 
> > > 	if (svm->nrips_enabled)
> > > 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> > 
> > It can be done, however what if we run on a nrips-capable CPU,
> > but don't expose this capability to the L1?
> 
> Oh, right, because the field will be populated by the CPU on VM-Exit.  Ah, the
> correct behavior is to grab RIP from vmcb12 to emulate nrips=0 hardware simply
> not updating RIP.  E.g. zeroing it out would send L2 into the weeds on IRET due
> the CPU pushing '0' on the stack when vectoring the injected event.
> 
> 	if (svm->nrips_enabled)
> 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> 	else if (boot_cpu_has(X86_FEATURE_NRIPS))
> 		vmcb02->control.next_rip    = vmcb12_rip;
> 
> > The CPU will then push whatever value was left in this field as
> > the return address for some L1 injected events.

This makes sense.

Note that even AMD's PRM has a note about this:

"
15.20 Event Injection
...
Software interrupts cannot be properly injected if the processor does not support the NextRIP field.
Support is indicated by CPUID Fn8000_000A_EDX[NRIPS] = 1. Hypervisor software should
emulate the event injection of software interrupts if NextRIP is not supported
"



> > 
> > Although without nrips feature the L1 shouldn't even attempt event
> > injection, copying this field anyway will make it work if L1 just
> > expects this capability based on the current CPU model rather than
> > by checking specific CPUID feature bits.

The guest really ought to check CPUID bits. Plus the CPU model is also
usually virtualized (for named machine types in Qemu for example).

> 
> L1 may still inject the exception, it just advances the RIP manually.  As above,
> the really messy thing is that, because there's no flag to say "don't use NextRIP!",
> the CPU will still consume NextRIP and push '0' on the stack for the return RIP
> from the INTn/INT3/INTO.  Yay.
> 
> I found that out the hard way (patch in-progress).  The way to handle event
> injection if KVM is loaded with nrips=0 but nrips is supported in hardware is to
> stuff NextRIP on event injection even if nrips=0, otherwise the guest is hosed.
> 
> > > > +	u64 next_rip;
> > > >   	u64 nested_cr3;
> > > >   	u64 virt_ext;
> > > >   	u32 clean;
> > > 
> > > I don't know why this struct has
> > > 
> > > 	u8 reserved_sw[32];
> > > 
> > > but presumably it's for padding, i.e. probably should be reduced to 24 bytes.
> > 
> > Apparently the "reserved_sw" field stores Hyper-V enlightenments state -
> > see commit 66c03a926f18 ("KVM: nSVM: Implement Enlightened MSR-Bitmap feature")
> > and nested_svm_vmrun_msrpm() in nested.c.
> 
> Argh, that's a terrible name.  Thanks for doing the homework, I was being lazy.


That was added around the commit 

1183646a67d01 ("KVM: SVM: hyper-v: Direct Virtual Flush support")

Seems to be used by HV to store 'struct hv_enlightenments',
but I don't know 100% if that is the only thing that can be stored
in this area.



Best regards,
	Maxim Levitsky


> 


