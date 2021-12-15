Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E0547638E
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 21:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbhLOUlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 15:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236341AbhLOUlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 15:41:14 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9C9C061574
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 12:41:13 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so246013pjc.4
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 12:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yMgBXvgKKU2b6VJ67VrE2wCrD66ET53f3SS4a00jXR4=;
        b=CtU+HeWuvURbdsPqB5TyPZVmIJrq6qOffd0OgCERU7qmBEva3Ik6NReX+24GUGmLwg
         sf7nykeQxaw6zKu8XjFoydeJif9Hbwge/X3ada9ofYbuCdZ4IpGQqf2B2uWvf9FjmyrO
         7mDCOFozYehd35eW0PQYkboW44+PfLkbxXXO1mjjsOPEimhGKPKdrQmQN6oOEBuDBO4/
         fk+4nMKmS2p3fY1FDjVlX8QtDxtnQBlL7PPquVhHiQXlyfByUFbgfPrx7Nnd9TV1YAXE
         332JzqX8l4F9ON9LKc1IdrlRZm9OuBgtvUQIPvTYQpeOJXCGt2i57t089fm/PvSlZwHs
         yugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yMgBXvgKKU2b6VJ67VrE2wCrD66ET53f3SS4a00jXR4=;
        b=uDd9OTpX1H0hPWYXIow0PbpLThaNV8SXzlmFx18tAxCSC1Yaq26fWUrxkFRvxssD3D
         FGqT7uH9b2fU/UC8DX1AMJ6avzWsL9cKrW2OISDynemlqn1Sg+zkDuALRSIDRUiD6PYJ
         yB8OUEHjl3Q3tq6LBY8ufeyTNqg4EDjH8l4BfEZQ3XDlrXTHLGEwKvo0Wfrc4vH+toNv
         hMlv6w8mGpNddSzAW20hcVVBD2fnxIVM+wIjaOz28LZvR6rPZnN+7aNvP6lOzEHtbRED
         kAWdUQJqWuC7b1/CTl59JbMEQHTzbVbO4fndJk18yFFs+KixYqxr0iC0U0kGAO0Gp6zW
         Ybaw==
X-Gm-Message-State: AOAM5329eL+ID+juiXSUbuMWgTC9mulXxS24CUCwed7fHBx5h5xkc93A
        65GbvNdsVDs8Ksw/hlM1NnowYg==
X-Google-Smtp-Source: ABdhPJyQ7BM5/gy9nkcFRjuXhuKVKlNYJu9dP9aAvDVwoc/LTWfJLDZioD+CP3SnYLYxEbIYALEczg==
X-Received: by 2002:a17:902:ea07:b0:148:8b23:5258 with SMTP id s7-20020a170902ea0700b001488b235258mr12333357plg.51.1639600873318;
        Wed, 15 Dec 2021 12:41:13 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h1sm3495376pfi.217.2021.12.15.12.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 12:41:12 -0800 (PST)
Date:   Wed, 15 Dec 2021 20:41:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 0/4] KVM: x86/mmu: Zap invalid TDP MMU roots when
 unmapping
Message-ID: <YbpS5UZdC/a5PgoO@google.com>
References: <20211215011557.399940-1-seanjc@google.com>
 <b4295e77-aaf1-f0f5-cfd5-2a4fda923fb4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4295e77-aaf1-f0f5-cfd5-2a4fda923fb4@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 15, 2021, Paolo Bonzini wrote:
> On 12/15/21 02:15, Sean Christopherson wrote:
> > Patches 01-03 implement a bug fix by ensuring KVM zaps both valid and
> > invalid roots when unmapping a gfn range (including the magic "all" range).
> > Failure to zap invalid roots means KVM doesn't honor the mmu_notifier's
> > requirement that all references are dropped.
> > 
> > set_nx_huge_pages() is the most blatant offender, as it doesn't elevate
> > mm_users and so a VM's entire mm can be released, but the same underlying
> > bug exists for any "unmap" command from the mmu_notifier in combination
> > with a memslot update.  E.g. if KVM is deleting a memslot, and a
> > mmu_notifier hook acquires mmu_lock while it's dropped by
> > kvm_mmu_zap_all_fast(), the mmu_notifier hook will see the to-be-deleted
> > memslot but won't zap entries from the invalid roots.
> > 
> > Patch 04 is cleanup to reuse the common iterator for walking _only_
> > invalid roots.
> > 
> > Sean Christopherson (4):
> >    KVM: x86/mmu: Use common TDP MMU zap helper for MMU notifier unmap
> >      hook
> >    KVM: x86/mmu: Move "invalid" check out of kvm_tdp_mmu_get_root()
> >    KVM: x86/mmu: Zap _all_ roots when unmapping gfn range in TDP MMU
> >    KVM: x86/mmu: Use common iterator for walking invalid TDP MMU roots
> > 
> >   arch/x86/kvm/mmu/tdp_mmu.c | 116 +++++++++++++++++--------------------
> >   arch/x86/kvm/mmu/tdp_mmu.h |   3 -
> >   2 files changed, 53 insertions(+), 66 deletions(-)
> > 
> 
> Queued 1-3 for 5.16 and 4 for 5.17.

Actually, can you please unqueue patch 4?  I think we can actually kill off
kvm_tdp_mmu_zap_invalidated_roots() entirely.  I don't know if that code will be
ready for 5.17, but if it is then this patch is unnecesary.  And if not, it
shouldn't be difficult to re-queue this a bit later.

Thanks!
