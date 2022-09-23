Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2356A5E7827
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 12:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiIWKUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 06:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiIWKTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 06:19:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20FB33A17
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 03:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663928387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ksQMzxdrDPsw0jGNkhgl8yC/KbcSjpBi/Hlg1X5QUJQ=;
        b=ObKA2FGAWryxIlXRBzjljMLhi8M2t5XF67vsTC+BIgx2JOawy0lQHnqKWrHtIWWm5t57cH
        SK98kP7Z+0y0D8cQ7AU6GBEu1e9s+pAqqqoFSOtPA2e0FQaEhlxi2vq1ORD6UhW9yRYz4h
        4Ro1+LXzl1faLiaHDt4U2hG0qFdg+fI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-GcCQKTb4OhGHNXiL6bYCnQ-1; Fri, 23 Sep 2022 06:19:36 -0400
X-MC-Unique: GcCQKTb4OhGHNXiL6bYCnQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0B8583B9DE;
        Fri, 23 Sep 2022 10:19:35 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5807F49BB61;
        Fri, 23 Sep 2022 10:19:34 +0000 (UTC)
Message-ID: <fad04012ae80a6a7cd5a159e4ced867a7810994d.camel@redhat.com>
Subject: Re: [PATCH v2 04/23] KVM: x86: Inhibit AVIC SPTEs if any vCPU
 enables x2APIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Fri, 23 Sep 2022 13:19:33 +0300
In-Reply-To: <Yyngcg3ainoD0fNc@google.com>
References: <20220903002254.2411750-1-seanjc@google.com>
         <20220903002254.2411750-5-seanjc@google.com>
         <8a24c36efebfa4fb302587a74e3bc1e088e17be8.camel@redhat.com>
         <Yyngcg3ainoD0fNc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-09-20 at 15:46 +0000, Sean Christopherson wrote:
> On Tue, Sep 20, 2022, Maxim Levitsky wrote:
> > On Sat, 2022-09-03 at 00:22 +0000, Sean Christopherson wrote:
> > > Reintroduce APICV_INHIBIT_REASON_X2APIC as a "partial" inhibit for AMD
> > > to fix a bug where the APIC access page is visible to vCPUs that have
> > > x2APIC enabled, i.e. shouldn't be able to "see" the xAPIC MMIO region.
> > > 
> > > On AMD, due to its "hybrid" mode where AVIC is enabled when x2APIC is
> > > enabled even without x2AVIC support, the bug occurs any time AVIC is
> > > enabled as x2APIC is fully emulated by KVM.  I.e. hardware isn't aware
> > > that the guest is operating in x2APIC mode.
> > > 
> > > Opportunistically drop the "can" while updating avic_activate_vmcb()'s
> > > comment, i.e. to state that KVM _does_ support the hybrid mode.  Move
> > > the "Note:" down a line to conform to preferred kernel/KVM multi-line
> > > comment style.
> > > 
> > > Leave Intel as-is for now to avoid a subtle performance regression, even
> > > though Intel likely suffers from the same bug.  On Intel, in theory the
> > > bug rears its head only when vCPUs share host page tables (extremely
> > > likely) and x2APIC enabling is not consistent within the guest, i.e. if
> > > some vCPUs have x2APIC enabled and other does do not (unlikely to occur
> > > except in certain situations, e.g. bringing up APs).
> > 
> > Are you sure about this?
> 
> Ah, no.  The key on Intel is the separate VMCS control for virtualizing xAPIC
> accesses.  As you note below, KVM will provide memory semantics, which is technically
> wrong.
> 
> > This is what I am thinking will happen, I might be wrong but I am not sure:
> 
> ...
> 
> > 3. guest accesses the 0xfee00xxx, assuming APICv/x2avic, the hardware won't redirect
> > the access to apic backing page, but will instead just use that SPTE and let the guest
> > read/write the private page that we mapped in the range, which is wrong.
> > 
> > Am I missing something?
> 
> No, I don't believe so.  I'm still hesitant to add the effetive inhibit to Intel,
> though that's probably just pure paranoia at this point.  Probably makes sense to
> just do it and verify that x2APIC virtualization still works.
> 
> > Also I somewhat doen't like the partial inhibit - it is to some extent
> > misleading.  I don't have a very strong option on using the inhibit, but its
> > meaning just feels a bit overloaded.
> > 
> > So why not to do it this way:
> > 
> > 1. zap the SPTE always when switching apic mode (e.g move the code in 
> > __kvm_set_or_clear_apicv_inhibit to a common funtion)
> > 
> > 2. make kvm_faultin_pfn check a flag 'any vcpu enabled x2apic' and refuse
> > to re-install that spte?
> > 
> > Something like that (only compile tested, and likely misses memory barriers):
> 
> Actually, since this is "sticky", we can go even further and just delete the
> memslot.  Deleting the memslot is slightly complicated by the need to drop SRCU
> if kvm_lapic_set_base() enables x2APIC during KVM_RUN, but that's enough enough
> to handled by putting the disabling logic in vcpu_run() and using KVM_REQ_UNBLOCK
> to ensure the memslot is deleted before the vCPU re-enters the guest.

Yes, that is the elephant in the room - deleting the memslot makes all of the sense,
and I thought about doing it, except that it has a chance of letting 
the genie out of its bottle again - remember that mess we had with the fact that
the memslots are rcu protected?
 
If it works, I 100% support the idea.
 
Also I think you want to remove the KVM_REQ_UNBLOCK, in the other patch series
you just posted?
 
Best regards,
	Maxim Levitsky

> 
> Testing now...
> 


