Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3315E487AA9
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 17:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348346AbiAGQrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 11:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbiAGQrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 11:47:01 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36082C061574
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 08:47:01 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id iy13so5641209pjb.5
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 08:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4HKnywQuY4VwXKVwYl3w2RNebnD31WyuWWzy9wpaOH0=;
        b=BvLHGD7cj4995fLzUhgyy1Xt/a0cC76PQB/jGLGJEKa0b6OFwQ+DrOKU3TYZkymmgS
         BTeAsvkfWAWnUq1WOqL4vGteu6O2Ld4y5+snVVc5+sU0KjMB4RAAFBkX0HWdnx62O14E
         jXbutV6k0H84XcWhw++JJI5F1Nykk+sTfnUcCqMOLs4SQ/KBXxWdpyS9MdxgF/KY3KDS
         NI7p9R4ex+SK8+H2DJkfxklNuGpN9luOoCDx6fhzHrgPfyvFEB+F/9bW9SWvCCoRzQkR
         jsQqJJLcmMM9F3cF1zM9nzl4zZhWBQy2welvXJT1dZZkyc8P8JLHKlmMJs79hca+JweA
         XDNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4HKnywQuY4VwXKVwYl3w2RNebnD31WyuWWzy9wpaOH0=;
        b=N85oVZFdOOIJm+8l1hlwUorOiErHa+zCLBYK8vZSEoKnteJWdD4Ocx8QOidH9xd7sL
         hhhKSyfMLhs9KAVD+mPbS6z5WbL1PFYXWLHLV0M9Er/YZnWz10FIReQXr0UOq50AvwoN
         t4eBYQGLO9WW5bzxuI+nILh+RzBtGK50XwmqIkvBjl68ECFGiwZIUFvy/s6cGOUk4qNf
         QLbOUqY6yvcVNKaNGZ9RbAsLFA8rsm1mVyzEb+Pkk7/Bea5YnYOiNvqzQoQZ+r44TFOa
         MiIBBQZeut+bRK2K4kMJOmHgv+vdKyFu4ujaIWQ8DEhyRPw5ip3ExgJWDyZLchqaifbt
         /M0A==
X-Gm-Message-State: AOAM532C7/daOc2cgKpwLlshNUn5EI/vG0SA7e7eV7a9cY14j2UnpPgJ
        EW8O+Zg0GvAUboNixhBcXS/6YQ==
X-Google-Smtp-Source: ABdhPJwaWYhBGl15DwbN2c5wYPK8kkGXVkvmKvrtvOqisVVfVfKIeJNZMfFu1VFmjZmU/W5QC8QKVg==
X-Received: by 2002:a17:90b:88e:: with SMTP id bj14mr16748325pjb.183.1641574020470;
        Fri, 07 Jan 2022 08:47:00 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d3sm6735893pfv.192.2022.01.07.08.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 08:47:00 -0800 (PST)
Date:   Fri, 7 Jan 2022 16:46:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Chia-I Wu <olv@chromium.org>
Subject: Re: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
Message-ID: <YdhugJ6h76JLHTjT@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-5-stevensd@google.com>
 <Yc4G23rrSxS59br5@google.com>
 <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
 <YdXrURHO/R82puD4@google.com>
 <YdXvUaBUvaRPsv6m@google.com>
 <CAD=HUj736L5oxkzeL2JoPV8g1S6Rugy_TquW=PRt73YmFzP6Jw@mail.gmail.com>
 <YdcpIQgMZJrqswKU@google.com>
 <CAD=HUj5v37wZ9NuNC4QBDvCGO2SyNG2KAiTc9Jxfg=R7neCuTw@mail.gmail.com>
 <Ydhq5aHW+JFo15UF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ydhq5aHW+JFo15UF@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 07, 2022, Sean Christopherson wrote:
> On Fri, Jan 07, 2022, David Stevens wrote:
> > > > These are the type of pages which KVM is currently rejecting. Is this
> > > > something that KVM can support?
> > >
> > > I'm not opposed to it.  My complaint is that this series is incomplete in that it
> > > allows mapping the memory into the guest, but doesn't support accessing the memory
> > > from KVM itself.  That means for things to work properly, KVM is relying on the
> > > guest to use the memory in a limited capacity, e.g. isn't using the memory as
> > > general purpose RAM.  That's not problematic for your use case, because presumably
> > > the memory is used only by the vGPU, but as is KVM can't enforce that behavior in
> > > any way.
> > >
> > > The really gross part is that failures are not strictly punted to userspace;
> > > the resulting error varies significantly depending on how the guest "illegally"
> > > uses the memory.
> > >
> > > My first choice would be to get the amdgpu driver "fixed", but that's likely an
> > > unreasonable request since it sounds like the non-KVM behavior is working as intended.
> > >
> > > One thought would be to require userspace to opt-in to mapping this type of memory
> > > by introducing a new memslot flag that explicitly states that the memslot cannot
> > > be accessed directly by KVM, i.e. can only be mapped into the guest.  That way,
> > > KVM has an explicit ABI with respect to how it handles this type of memory, even
> > > though the semantics of exactly what will happen if userspace/guest violates the
> > > ABI are not well-defined.  And internally, KVM would also have a clear touchpoint
> > > where it deliberately allows mapping such memslots, as opposed to the more implicit
> > > behavior of bypassing ensure_pfn_ref().
> > 
> > Is it well defined when KVM needs to directly access a memslot?
> 
> Not really, there's certainly no established rule.
> 
> > At least for x86, it looks like most of the use cases are related to nested
> > virtualization, except for the call in emulator_cmpxchg_emulated.
> 
> The emulator_cmpxchg_emulated() will hopefully go away in the nearish future[*].

Forgot the link...

https://lore.kernel.org/all/YcG32Ytj0zUAW%2FB2@hirez.programming.kicks-ass.net/

> Paravirt features that communicate between guest and host via memory is the other
> case that often maps a pfn into KVM.
> 
> > Without being able to specifically state what should be avoided, a flag like
> > that would be difficult for userspace to use.
> 
> Yeah :-(  I was thinking KVM could state the flag would be safe to use if and only
> if userspace could guarantee that the guest would use the memory for some "special"
> use case, but hadn't actually thought about how to word things.
> 
> The best thing to do is probably to wait for for kvm_vcpu_map() to be eliminated,
> as described in the changelogs for commits:
> 
>   357a18ad230f ("KVM: Kill kvm_map_gfn() / kvm_unmap_gfn() and gfn_to_pfn_cache")
>   7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status")
> 
> Once that is done, everything in KVM will either access guest memory through the
> userspace hva, or via a mechanism that is tied into the mmu_notifier, at which
> point accessing non-refcounted struct pages is safe and just needs to worry about
> not corrupting _refcount.
