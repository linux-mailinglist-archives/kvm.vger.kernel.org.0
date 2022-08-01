Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F2F586E19
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 17:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiHAPyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 11:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiHAPyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 11:54:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A288637F9C
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 08:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659369251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bDrzxcK/hdqF7u8DnUOKQqM/ecXSwkQXnfqic59uxkQ=;
        b=fvr0vBXom4gOmnQZyFA3o+5Q7lCG2q0AqnabgG2DsUDk+0TDXXWdHSNqK+Zf/7evgp+Xry
        eJPIsnCRX2JlYu4eK8oYLEUanrDTYtuuikw7kKLfuqFu1vn1ARVVt715s3lOHsDckt6IBv
        xRp+kxvf8Aa0smWHEAc+KC6mFI9L8/o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-9GoOoRyOOP-3kn0drtBscw-1; Mon, 01 Aug 2022 11:54:06 -0400
X-MC-Unique: 9GoOoRyOOP-3kn0drtBscw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF7D4101A586;
        Mon,  1 Aug 2022 15:54:05 +0000 (UTC)
Received: from starship (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D3AB40E80F4;
        Mon,  1 Aug 2022 15:53:59 +0000 (UTC)
Message-ID: <ad3a01ffe9c6f7fa40a4b51ac88d8fad56606435.camel@redhat.com>
Subject: Re: [RFC PATCH v3 04/19] KVM: x86: mmu: allow to enable write
 tracking externally
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Date:   Mon, 01 Aug 2022 18:53:58 +0300
In-Reply-To: <7c4cf32dca42ab84bdb427a9e4862dbf5509f961.camel@redhat.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
         <20220427200314.276673-5-mlevitsk@redhat.com> <YoZyWOh4NPA0uN5J@google.com>
         <5ed0d0e5a88bbee2f95d794dbbeb1ad16789f319.camel@redhat.com>
         <c22a18631c2067871b9ed8a9246ad58fa1ab8947.camel@redhat.com>
         <Yt6/9V0S9of7dueW@google.com>
         <7c4cf32dca42ab84bdb427a9e4862dbf5509f961.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-28 at 10:46 +0300, Maxim Levitsky wrote:
> On Mon, 2022-07-25 at 16:08 +0000, Sean Christopherson wrote:
> > On Wed, Jul 20, 2022, Maxim Levitsky wrote:
> > > On Sun, 2022-05-22 at 13:22 +0300, Maxim Levitsky wrote:
> > > > On Thu, 2022-05-19 at 16:37 +0000, Sean Christopherson wrote:
> > > > > On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> > > > > > @@ -5753,6 +5752,10 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> > > Now for nested AVIC, this is what I would like to do:
> > >  
> > > - just like mmu, I prefer to register the write tracking notifier, when the
> > >   VM is created.
> > > 
> > > - just like mmu, write tracking should only be enabled when nested AVIC is
> > >   actually used first time, so that write tracking is not always enabled when
> > >   you just boot a VM with nested avic supported, since the VM might not use
> > >   nested at all.
> > >  
> > > Thus I either need to use the __kvm_page_track_register_notifier too for AVIC
> > > (and thus need to export it) or I need to have a boolean
> > > (nested_avic_was_used_once) and register the write tracking notifier only
> > > when false and do it not on VM creation but on first attempt to use nested
> > > AVIC.
> > >  
> > > Do you think this is worth it? I mean there is some value of registering the
> > > notifier only when needed (this way it is not called for nothing) but it does
> > > complicate things a bit.
> > 
> > Compared to everything else that you're doing in the nested AVIC code, refcounting
> > the shared kvm_page_track_notifier_node object is a trivial amount of complexity.
> Makes sense.
> 
> > And on that topic, do you have performance numbers to justify using a single
> > shared node?  E.g. if every table instance has its own notifier, then no additional
> > refcounting is needed. 
> 
> The thing is that KVM goes over the list of notifiers and calls them for every write from the emulator
> in fact even just for mmio write, and when you enable write tracking on a page,
> you just write protect the page and add a mark in the page track array, which is roughly 
> 
> 'don't install spte, don't install mmio spte, but just emulate the page fault if it hits this page'
> 
> So adding more than a bare minimum to this list, seems just a bit wrong.
> 
> 
> >  It's not obvious that a shared node will provide better
> > performance, e.g. if there are only a handful of AVIC tables being shadowed, then
> > a linear walk of all nodes is likely fast enough, and doesn't bring the risk of
> > a write potentially being stalled due to having to acquire a VM-scoped mutex.
> 
> The thing is that if I register multiple notifiers, they all will be called anyway,
> but yes I can use container_of, and discover which table the notifier belongs to,
> instead of having a hash table where I lookup the GFN of the fault.
> 
> The above means practically that all the shadow physid tables will be in a linear
> list of notifiers, so I could indeed avoid per vm mutex on the write tracking,
> however for simplicity I probably will still need it because I do modify the page,
> and having per physid table mutex complicates things.
> 
> Currently in my code the locking is very simple and somewhat dumb, but the performance
> is very good because the code isn't executed often, most of the time the AVIC hardware
> works alone without any VM exits.
> 
> Once the code is accepted upstream, it's one of the things that can be improved.
> 
> 
> Note though that I still need a hash table and a mutex because on each VM entry,
> the guest can use a different physid table, so I need to lookup it, and create it,
> if not found, which would require read/write of the hash table and thus a mutex.
> 
> 
> 
> > > I can also stash this boolean (like 'bool registered;') into the 'struct
> > > kvm_page_track_notifier_node',  and thus allow the
> > > kvm_page_track_register_notifier to be called more that once -  then I can
> > > also get rid of __kvm_page_track_register_notifier. 
> > 
> > No, allowing redundant registration without proper refcounting leads to pain,
> > e.g. X registers, Y registers, X unregisters, kaboom.
> > 
> 
> True, but then what about adding a refcount to 'struct kvm_page_track_notifier_node'
> instead of a boolean, and allowing redundant registration? 
> Probably not worth it, in which case I am OK to add a refcount to my avic code.
> 
> Or maybe just scrap the whole thing and just leave registration and activation of the
> write tracking as two separate things? Honestly now that looks like the most clean
> solution.


Kind ping on this. Do you still want me to enable write tracking on the notifier registeration,
or scrap the idea?


Best regards,
	Maxim Levitsky
> 
> Best regards,
> 	Maxim Levitsky


