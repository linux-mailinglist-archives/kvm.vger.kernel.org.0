Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5DC4358B8
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 04:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhJUCuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 22:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhJUCux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 22:50:53 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B73AC061749
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 19:48:38 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id g184so24247527pgc.6
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 19:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ujSZ0sBQWBy7DoFnbDi/cP1giiBFvyPhc9wOnIG/WgY=;
        b=l5nYw0eb/GADT7fKkzcnPjKKB+3Qugv9ImeITw0P40SFhdILQ+PkAtU9g9zITGCmX7
         vA5g6T1LHStfVnJcOHDk6g461NnPiCrk5Pvb3EE0tI+9VaRZ0G2YCVMZth3aJAkD1weM
         os33Wz9kz+x9swPLOIikiqmi60nI5af5tSiCw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ujSZ0sBQWBy7DoFnbDi/cP1giiBFvyPhc9wOnIG/WgY=;
        b=qu8rmA0hqs69fd8EVbydNq071DOzm4ptw5ZDXp9sOT+OLyiIaKqF4971O1fanxwYsu
         N1idrtIShoGpHKFyrAJat+uSG6JMhem3nebUFmJ0JFb+nlHqxoFge5vWGSaNVEYCfJ1j
         G8L9LiBLcIMncVzDEuDfSa10bq97YEPIIw/isst6VTigWIvNndYkIK+tLzxQm/LIi0HE
         3T92B7CfbSDVjk1e7kMAm/h5U4NLJC+fkxsCOan7BWSB/jiN8yFLmpB8nGv41/YC9+Te
         MK1IWowNq8iiM0sMtVwxwwD1V8Gs59s8YkCgJRhuemLdvNZgJuAJanj+PtV/onrDpjJx
         0tzQ==
X-Gm-Message-State: AOAM532hIElb0EB8C8CQXefm1ynebW29N6/jrhGHK6yCSxLn1ueowqOs
        vZQGXj6af/BniV5lY+G+D+d7+g==
X-Google-Smtp-Source: ABdhPJwTCQ5wR4AuDidI/tFXGKkPoOhlTTYBmvV1OYOnbX9Vk690VCv+2xHFt7QEL5gYFHAFu0d/9g==
X-Received: by 2002:a62:ab17:0:b0:44c:f727:98cd with SMTP id p23-20020a62ab17000000b0044cf72798cdmr2632689pff.35.1634784517488;
        Wed, 20 Oct 2021 19:48:37 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:3bbb:903f:245c:8335])
        by smtp.gmail.com with ESMTPSA id c11sm7131016pji.38.2021.10.20.19.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 19:48:36 -0700 (PDT)
Date:   Thu, 21 Oct 2021 11:48:31 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     David Matlack <dmatlack@google.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suleiman Souhlal <suleiman@google.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHV2 1/3] KVM: x86: introduce kvm_mmu_pte_prefetch structure
Message-ID: <YXDU/xXkWGuDJ/id@google.com>
References: <20211019153214.109519-1-senozhatsky@chromium.org>
 <20211019153214.109519-2-senozhatsky@chromium.org>
 <CALzav=cLXXZYBSH6iJifkqVijLAU5EvgVg2W4HKhqke2JBa+yg@mail.gmail.com>
 <YW9vqgwU+/iVooXj@google.com>
 <CALzav=c1LXXWSi-Z0_X35HCyQtv1rh0p2YmJ289J51SHy0DRxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=c1LXXWSi-Z0_X35HCyQtv1rh0p2YmJ289J51SHy0DRxg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On (21/10/20 08:56), David Matlack wrote:
> > > The spinlock is overkill. I'd suggest something like this:
> > > - When VM-ioctl is invoked to update prefetch count, store it in
> > > kvm_arch. No synchronization with vCPUs needed.
> > > - When a vCPU takes a fault: Read the prefetch count from kvm_arch. If
> > > different than count at last fault, re-allocate vCPU prefetch array.
> > > (So you'll need to add prefetch array and count to kvm_vcpu_arch as
> > > well.)
> > >
> > > No extra locks are needed. vCPUs that fault after the VM-ioctl will
> > > get the new prefetch count. We don't really care if a prefetch count
> > > update races with a vCPU fault as long as vCPUs are careful to only
> > > read the count once (i.e. use READ_ONCE(vcpu->kvm.prefetch_count)) and
> > > use that. Assuming prefetch count ioctls are rare, the re-allocation
> > > on the fault path will be rare as well.
> >
> > So reallocation from the faul-path should happen before vCPU takes the
> > mmu_lock?
> 
> Yes. Take a look at mmu_topup_memory_caches for an example of
> allocating in the fault path prior to taking the mmu lock.
> 
> > And READ_ONCE(prefetch_count) should also happen before vCPU
> > takes mmu_lock, I assume, so we need to pass it as a parameter to all
> > the functions that will access prefetch array.
> 
> Store the value of READ_ONCE(prefetch_count) in struct kvm_vcpu_arch
> because you also need to know if it changes on the next fault. Then
> you also don't have to add a parameter to a bunch of functions in the
> fault path.
> 
> >
> > > Note: You could apply this same approach to a module param, except
> > > vCPUs would be reading the module param rather than vcpu->kvm during
> > > each fault.
> > >
> > > And the other alternative, like you suggested in the other patch, is
> > > to use a vCPU ioctl. That would side-step the synchronization issue
> > > because vCPU ioctls require the vCPU mutex. So the reallocation could
> > > be done in the ioctl and not at fault time.
> >
> > One more idea, wonder what do you think:
> >
> > There is an upper limit on the number of PTEs we prefault, which is 128 as of
> > now, but I think 64 will be good enough, or maybe even 32. So we can always
> > allocate MAX_PTE_PREFETCH_NUM arrays in vcpu->arch and ioctl() will change
> > ->num_ents only, which is always in (0, MAX_PTE_PREFETCH_NUM - 1] range. This
> > way we never have to reallocate anything, we just adjust the "maximum index"
> > value.
> 
> 128 * 8 would be 1KB per vCPU. That is probably reasonable, but I
> don't think the re-allocation would be that complex.

128 is probably too large. What I'm thinking is "32 * 8" per-VCPU.
Then it can even be something like:

---

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5271fce6cd65..b3a436f8fdf5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -607,6 +607,11 @@ struct kvm_vcpu_xen {
        u64 runstate_times[4];
 };
 
+struct kvm_mmu_pte_prefetch {
+       u64 ents[32];
+       unsigned int num_ents;  /* max prefetch value for this vCPU */
+};
+
 struct kvm_vcpu_arch {
        /*
         * rip and regs accesses must go through
@@ -682,6 +687,8 @@ struct kvm_vcpu_arch {
        struct kvm_mmu_memory_cache mmu_gfn_array_cache;
        struct kvm_mmu_memory_cache mmu_page_header_cache;
 
+       struct kvm_mmu_pte_prefetch mmu_pte_prefetch;
+
        /*
         * QEMU userspace and the guest each have their own FPU state.
         * In vcpu_run, we switch between the user and guest FPU contexts.

---

> >
> > > Taking a step back, can you say a bit more about your usecase?
> >
> > We are looking at various ways of reducing the number of vm-exits. There
> > is only one VM running on the device (a pretty low-end laptop).
> 
> When you say reduce the number of vm-exits, can you be more specific?
> Are you trying to reduce the time it takes for vCPUs to fault in
> memory during VM startup?

VM Boot is the test I'm running, yes, and I see some improvements with
pte-prefault == 16.

> I just mention because there are likely other techniques you can apply
> that would not require modifying KVM code (e.g. prefaulting the host
> memory before running the VM, using the TDP MMU instead of the legacy
> MMU to allow parallel faults, using hugepages to map in more memory
> per fault, etc.)

THP would be awesome. We have THP enabled on devices that have 8-plus
gigabytes of RAM; but we don't have THP enabled on low end devices, that
only have 4 gigabytes of RAM. On low end devices KVM with THP causes host
memory regression, that we cannot accept, hence for 4 gig devices we try
various "other solutions".

We are using TDP. And somehow I never see (literally never) async PFs.
It's always either hva_to_pfn_fast() or hva_to_pfn_slow() or
__direct_map() from tdp_page_fault().
