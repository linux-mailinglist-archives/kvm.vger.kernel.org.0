Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F033D4294FC
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 18:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbhJKRBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 13:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbhJKRAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 13:00:21 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450DBC06161C
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 09:58:12 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so416262pjb.5
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 09:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0oMDbqZanSN//u1YMMcYEHCKj6g0nLAVOuw5cGVcceo=;
        b=m8gbXWoAVXa/JjiFComPc0rji8sI+d/NO/gBKBgbCH/+p4LnD5k4+IisJwJQ8FJVns
         sJKWn1Bfe4E8Jp1bydvjv0T1X7wEhxnyZbCY2Jq6eGZ/AoOezzf2vbjy934dHeU/rnFO
         k6e5YiNkaSiYpzRAMjIV4jfi6z0SbbVvv1GJVJNsFUnkWwQpKwoWkb84AGLLmYAEh/x2
         whdoBBve2yaiYaUUR0f9t7fYs6tISIOjkZP4EMzui5cwHUzsYB3fovSP3XMkOcmEyGcD
         U6EBytNSkPOJKObCtV7dyZswCsdWqLY56G5eAvtAaSVT7v0yriCpardtvWHrv1OdS7fK
         GBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0oMDbqZanSN//u1YMMcYEHCKj6g0nLAVOuw5cGVcceo=;
        b=LOA8DaS2+486qaKo1U7/k4JLWa5SuYr/YVf9iV1al5wFny8hXE3OdGcY1Wq3M6y2lF
         jO5/ZnbWL7Xi72X+I9Xo6eEHy3GmWXt0oWlzZ7K9w4ZwnRkY3vdpQjHfehpjU9taB3B4
         UAA0hAZGdHIo25VzFoOshCjyD61fri12xPKqFsegoXo7lFTMSVUv36GbjIhOiZ4GXqAu
         HnXFSWZrFKmTQMIl3DOk0/0sgtEg+JO/XMSZhLjViOEJhLsFDqWzxbq9qItaM8qhvHBX
         tICe1Bt1HdxENYNxec6ToJl73Opl/cff7o0eMqXtQbCBPc3ffturJ5/oiSuooH7hba9N
         whew==
X-Gm-Message-State: AOAM531WN37wJWEoaQv3i/sdjm/QZPIlJejq4SlCVRhtqwojg2DmPf0N
        ExD+w/dIRCIxM/VoFIYvL1FHmQ==
X-Google-Smtp-Source: ABdhPJyduaDSKyDvGGfH6PY8n/ji7sbA6BOQJz0CESFtO9SMfqt4coGFjXkHS6luOeR3tVjaqXQDkg==
X-Received: by 2002:a17:902:7c8d:b0:13a:768b:d6c0 with SMTP id y13-20020a1709027c8d00b0013a768bd6c0mr25735191pll.83.1633971491519;
        Mon, 11 Oct 2021 09:58:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z71sm7046957pfc.19.2021.10.11.09.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 09:58:10 -0700 (PDT)
Date:   Mon, 11 Oct 2021 16:58:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86: Fix and cleanup for recent AVIC changes
Message-ID: <YWRtHmAUaKcbWEzH@google.com>
References: <20211009010135.4031460-1-seanjc@google.com>
 <9e9e91149ab4fa114543b69eaf493f84d2f33ce2.camel@redhat.com>
 <YWRJwZF1toUuyBdC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWRJwZF1toUuyBdC@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021, Sean Christopherson wrote:
> On Sun, Oct 10, 2021, Maxim Levitsky wrote:
> > On Fri, 2021-10-08 at 18:01 -0700, Sean Christopherson wrote:
> > > Belated "code review" for Maxim's recent series to rework the AVIC inhibit
> > > code.  Using the global APICv status in the page fault path is wrong as
> > > the correct status is always the vCPU's, since that status is accurate
> > > with respect to the time of the page fault.  In a similar vein, the code
> > > to change the inhibit can be cleaned up since KVM can't rely on ordering
> > > between the update and the request for anything except consumers of the
> > > request.
> > > 
> > > Sean Christopherson (2):
> > >   KVM: x86/mmu: Use vCPU's APICv status when handling APIC_ACCESS
> > >     memslot
> > >   KVM: x86: Simplify APICv update request logic
> > > 
> > >  arch/x86/kvm/mmu/mmu.c |  2 +-
> > >  arch/x86/kvm/x86.c     | 16 +++++++---------
> > >  2 files changed, 8 insertions(+), 10 deletions(-)
> > > 
> > 
> > Are you sure about it? Let me explain how the algorithm works:
> > 
> > - kvm_request_apicv_update:
> > 
> > 	- take kvm->arch.apicv_update_lock
> > 
> > 	- if inhibition state doesn't really change (kvm->arch.apicv_inhibit_reasons still zero or non zero)
> > 		- update kvm->arch.apicv_inhibit_reasons
> > 		- release the lock
> > 
> > 	- raise KVM_REQ_APICV_UPDATE
> > 		* since kvm->arch.apicv_update_lock is taken, all vCPUs will be
> > 		kicked out of guest mode and will be either doing someing in
> > 		the KVM (like page fault) or stuck on trying to process that
> > 		request the important thing is that no vCPU will be able to get
> > 		back to the guest mode.
> > 
> > 	- update the kvm->arch.apicv_inhibit_reasons
> > 		* since we hold vm->arch.apicv_update_lock vcpus can't see the new value
> 
> This assertion is incorrect, kvm_apicv_activated() is not guarded by the lock.
> 
> > 	- update the SPTE that covers the APIC's mmio window:
> 
> This won't affect in-flight page faults.
> 
> 
>    vCPU0                               vCPU1
>    =====                               =====
>    Disabled APICv
>    #NPT                                Acquire apicv_update_lock
>                                        Re-enable APICv
>    kvm_apicv_activated() == false

Doh, that's supposed to be "true".

>    incorrectly handle as regular MMIO
>                                        zap APIC pages
>    MMIO cache has bad entry

Argh, I forgot the memslot is still there, so the access won't be treated as MMIO
and thus won't end up in the MMIO cache.

So I agree that the code is functionally ok, but I'd still prefer to switch to
kvm_vcpu_apicv_active() so that this code is coherent with respect to the APICv
status at the time the fault occurred.

My objection to using kvm_apicv_activated() is that the result is completely
non-deterministic with respect to the vCPU's APICv status at the time of the
fault.  It works because all of the other mechanisms that are in place, e.g.
elevating the MMU notifier count, but the fact that the result is non-deterministic
means that using the per-vCPU status is also functionally ok.

At a minimum, I'd like to add a blurb in the kvm_faultin_pfn() comment to call out
the reliance on mmu_notifier_seq.

E.g. if kvm_zap_gfn_range() wins the race to acquire mmu_lock() after APICv is
inhibited/disabled by __kvm_request_apicv_update(), then direct_page_fault() will
retry the fault due to the change in mmu_notifier_seq.  If direct_page_fault()
wins the race, then kvm_zap_gfn_range() will zap the freshly-installed SPTEs.
For the uninhibit/enable case, at worst KVM will emulate an access that could have
been accelerated by retrying the instruction.
