Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7672260E909
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 21:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbiJZTda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 15:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbiJZTdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 15:33:25 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035CB9B859
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 12:33:22 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so3165324pji.0
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 12:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jGjEp8J6XveduvHsdvLy4QcugylDX5h7FyuVeFj9/ag=;
        b=bIJBCxmZ8BtTAakelkNL7MAnGlWTzIee1l87zbz64oAh2qKROAwI8gemqHkXLx8oA6
         /tkgzX7RYgja7idwCJDgCr3u2YnDsw1Rad4YVTWE6psgL4ux4GLoC/BbArA+0gE/EXHa
         GedtvmLeWsTzHHz+g0qYCPVjHpSV2bY4c0jRkHHKlV0pDj61mqSFnel7Qn4Fm325L3zV
         Wb/kPJRMYwopVsA2LH9ibigkenj+uIx7wTy/di5tqLY5os65c0+WIf3Nj/vIi4YIytJU
         W3n93LiGaMKjfxnfoWKDV/cu6D/qFmRCi9g6hI2wkOiyVsiOVfdrLOg4n1dBaAIhZFQ2
         MOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jGjEp8J6XveduvHsdvLy4QcugylDX5h7FyuVeFj9/ag=;
        b=UJ8IsDBpKmIdgH6F/qwDPankM07e0g49WhIM7zfu9eItEIX+zn0ePAtAeOi/XtFCia
         dfKqEEo0PrMC0AEJeKypmvC0I9+uXOI7RinpT8rgjQq4wEsQhkOWzz2e7ThIXmZyjpKL
         rIvYtkA15F3WFITFsSH4WYBZhldWO5Rue+t19gUBeNJFJIBkD7Dy2oXC9fOWAcCT0fiV
         Ad3n0rXhHZOOoTXhdVtnQdpwiT8Pqnb6lbMwDJHfFStnoT6wDQXROODfJIcGQJnViSPN
         VuUlZwx3znZRQZ+qyDn0xTweEHTn1cuMXVdMDpnbfRvtt26EbRjt6983tmcNFQR15eCp
         q/sg==
X-Gm-Message-State: ACrzQf1QuDR+AAAEXB3d5yNZ7i407BMxtJM1uIx1Hs2LiVrcuOdSUDu7
        jDJkvhJDZvHFcoRejSXr7jetqg==
X-Google-Smtp-Source: AMsMyM7kHvUr3Qu7IQj9UH9RHXNJjhGQaQQRIsOwCYdGUP1vF01EPed/asqBzDnhBz4p7Ixb3tcQjw==
X-Received: by 2002:a17:90b:4d0d:b0:1fb:a86d:e752 with SMTP id mw13-20020a17090b4d0d00b001fba86de752mr5948777pjb.120.1666812801340;
        Wed, 26 Oct 2022 12:33:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y4-20020a17090a390400b00212735c8898sm1429389pjb.30.2022.10.26.12.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 12:33:20 -0700 (PDT)
Date:   Wed, 26 Oct 2022 19:33:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Hyper-V VTLs, permission bitmaps and userspace exits (was Re:
 [PATCH 0/4] KVM: API to block and resume all running vcpus in a vm)
Message-ID: <Y1mLfRRKcF5OWZTG@google.com>
References: <20221022154819.1823133-1-eesposit@redhat.com>
 <a2e16531-5522-a334-40a1-2b0e17663800@linux.ibm.com>
 <2701ce67-bfff-8c0c-4450-7c4a281419de@redhat.com>
 <384b2622-8d7f-ce02-1452-84a86e3a5697@linux.ibm.com>
 <Y1cVfECAAfmp5XqA@google.com>
 <5a26c107-9ab5-60ee-0e9c-a9955dfe313d@redhat.com>
 <Y1gG/W/q/VIydpMu@google.com>
 <02c910bb-3ea0-fa84-7a1c-92fb9e8b03de@redhat.com>
 <Y1hsHjPuZfrREulV@google.com>
 <d3e2dd2b-9520-32ef-6785-94164a834adf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3e2dd2b-9520-32ef-6785-94164a834adf@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 26, 2022, Paolo Bonzini wrote:
> On 10/26/22 01:07, Sean Christopherson wrote:
> > > >     - to stop anything else in the system that consumes KVM memslots, e.g. KVM GT
> > > 
> > > Is this true if you only look at the KVM_GET_DIRTY_LOG case and consider it
> > > a guest bug to access the memory (i.e. ignore the strange read-only changes
> > > which only happen at boot, and which I agree are QEMU-specific)?
> > 
> > Yes?  I don't know exactly what "the KVM_GET_DIRTY_LOG case" is.
> 
> It is not possible to atomically read the dirty bitmap and delete a memslot.
> When you delete a memslot, the bitmap is gone.  In this case however memory
> accesses to the deleted memslot are a guest bug, so stopping KVM-GT would
> not be necessary.

If accesses to the deleted memslot are a guest bug, why do you care about pausing
vCPUs?  I don't mean to be beligerent, I'm genuinely confused.

> So while I'm being slowly convinced that QEMU should find a way to pause its
> vCPUs around memslot changes, I'm not sure that pausing everything is needed
> in general.
> 
> > > > And because of the nature of KVM, to support this API on all architectures, KVM
> > > > needs to make change on all architectures, whereas userspace should be able to
> > > > implement a generic solution.
> > > 
> > > Yes, I agree that this is essentially just a more efficient kill().
> > > Emanuele, perhaps you can put together a patch to x86/vmexit.c in
> > > kvm-unit-tests, where CPU0 keeps changing memslots and the other CPUs are in
> > > a for(;;) busy wait, to measure the various ways to do it?
> > 
> > I'm a bit confused.  Is the goal of this to simplify QEMU, dedup VMM code, provide
> > a more performant solution, something else entirely?
> 
> Well, a bit of all of them and perhaps that's the problem.  And while the
> issues at hand *are* self-inflicted wounds on part of QEMU, it seems to me
> that the underlying issues are general.
> 
> For example, Alex Graf and I looked back at your proposal of a userspace
> exit for "bad" accesses to memory, wondering if it could help with Hyper-V
> VTLs too.  To recap, the "higher privileged" code at VTL1 can set up VM-wide
> restrictions on access to some pages through a hypercall
> (HvModifyVtlProtectionMask).  After the hypercall, VTL0 would not be able to
> access those pages.  The hypercall would be handled in userspace and would
> invoke a KVM_SET_MEMORY_REGION_PERM ioctl to restrict the RWX permissions,
> and this ioctl would set up a VM-wide permission bitmap that would be used
> when building page tables.
> 
> Using such a bitmap instead of memslots makes it possible to cause userspace
> vmexits on VTL mapping violations with efficient data structures.  And it
> would also be possible to use this mechanism around KVM_GET_DIRTY_LOG, to
> read the KVM dirty bitmap just before removing a memslot.

What exactly is the behavior you're trying to achieve for KVM_GET_DIRTY_LOG => delete?
If KVM provides KVM_EXIT_MEMORY_FAULT, can you not achieve the desired behavior by
doing mprotect(PROT_NONE) => KVM_GET_DIRTY_LOG => delete?  If PROT_NONE causes the
memory to be freed, won't mprotect(PROT_READ) do what you want even without
KVM_EXIT_MEMORY_FAULT?

> However, external accesses to the regions (ITS, Xen, KVM-GT, non KVM_RUN
> ioctls) would not be blocked, due to the lack of a way to report the exit.

Aren't all of those out of scope?  E.g. in a very hypothetical world where XEN's
event channel is being used with VTLs, if VTL1 makes the event channel inaccessible,
that's a guest and/or userspace configuration issue and the guest is hosed no matter
what KVM does.  Ditto for these case where KVM-GT's buffer is blocked.  I'm guessing
the ITS is similar?

> The intersection of these features with VTLs should be very small (sometimes
> zero since VTLs are x86 only), but the ioctls would be a problem so I'm
> wondering what your thoughts are on this.

How do the ioctls() map to VTLs?  I.e. are they considered VTL0, VTL1, out-of-band?

> Also, while the exit API could be the same, it is not clear to me that the
> permission bitmap would be a good match for entirely "void" memslots used to
> work around non-atomic memslot changes.  So for now let's leave this aside
> and only consider the KVM_GET_DIRTY_LOG case.

As above, can't userspace just mprotect() the entire memslot to prevent writes
between getting the dirty log and deleting the memslot?
