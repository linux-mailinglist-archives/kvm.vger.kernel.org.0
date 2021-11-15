Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7506D451FF2
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 01:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347933AbhKPAqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 19:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357058AbhKPAoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 19:44:08 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69277C0337F2
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 14:59:59 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so511261pjc.4
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 14:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2VrYG3Dlsxy7gGTJGr6SI0PayHCY3dbMzY/abN0SyfQ=;
        b=NTq13NgBCam5Y+/2k8IsZoip4gBoVXiCLjKNE2qaLOliUShWn4M84UyPnM8c7wcB5H
         5vnRH/XUQMGitRdPCNt3mthfKbcR5E30LFMy9NiswknoJ2nDf9+JayzgpuxPwIcuFA0A
         1R8tpq+LszrMWz+u3Tvqk2DSaRNZYMvf4kF1oPLNSFP4+oV34l/MXugexo+07u5e+vlj
         MpnHn6cgSgbEQuRNrb184aj8mUlsQ+Np0jfvU66zDqu9k2WPzJmJ1AN5HigoVJh1EDNk
         OFEMDGwAniKxIw4ntVB8drJGP3VcMavpCjOSbZ5frkMzP9+qaj9fEYN3sJHAsnKjnOUz
         Zsrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2VrYG3Dlsxy7gGTJGr6SI0PayHCY3dbMzY/abN0SyfQ=;
        b=1xPu7fTLDQI0pi21v1dwmVhuHL+lTkSHqHunv5WXx6nZk7vaXqeT+cmVFxlkuNShTn
         8AOhv5ZHuRRJc3lPDoO/R5tB/wUfMZhCyr/KPpZyr4SdrDNeDEXi4AcaEKsShEvf/suH
         z0cZJdjpEV/3bRerJ4eN3uV0Zdbl6MwzDQbN8FDT9rS1gcSZjMVWpMnxd8GedHmLDGjp
         B7nQu97LeofJQrjzepVOHRwLVHE9c+QZYM6lWPSIS8PZrkUOLqjMYzFqY2yRqZ+3nkQS
         1rfciBJWVUVWufEQ41dlkPaj471rsDmwvagoBuovs+Zz5O1/bILAeOK32avHlVr5nCxS
         HFiQ==
X-Gm-Message-State: AOAM531AyB7bP0YNBQevE/ayyK6fHmF762V8qijFGxFiaUR5c3vAjCAt
        Hqz/PmP4jjg8zPzLU7VFTJZOpffzNWL42Q==
X-Google-Smtp-Source: ABdhPJzHON0elrmvCuhO4iFeQh7O+C1oKWbYWbSKOx73TXV2qOMZL8h/XdevyICk+5DX8KzOjmIJtQ==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr68356071pjb.157.1637017198798;
        Mon, 15 Nov 2021 14:59:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m19sm12831366pgh.75.2021.11.15.14.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 14:59:58 -0800 (PST)
Date:   Mon, 15 Nov 2021 22:59:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
Subject: Re: [RFC PATCH 0/11] Rework gfn_to_pfn_cache
Message-ID: <YZLmapmzs7sLpu/L@google.com>
References: <2b400dbb16818da49fb599b9182788ff9896dcda.camel@infradead.org>
 <32b00203-e093-8ffc-a75b-27557b5ee6b1@redhat.com>
 <28435688bab2dc1e272acc02ce92ba9a7589074f.camel@infradead.org>
 <4c37db19-14ed-46b8-eabe-0381ba879e5c@redhat.com>
 <537fdcc6af80ba6285ae0cdecdb615face25426f.camel@infradead.org>
 <7e4b895b-8f36-69cb-10a9-0b4139b9eb79@redhat.com>
 <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
 <3a2a9a8c-db98-b770-78e2-79f5880ce4ed@redhat.com>
 <2c7eee5179d67694917a5a0d10db1bce24af61bf.camel@infradead.org>
 <537a1d4e-9168-cd4a-cd2f-cddfd8733b05@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537a1d4e-9168-cd4a-cd2f-cddfd8733b05@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021, Paolo Bonzini wrote:
> On 11/15/21 20:11, David Woodhouse wrote:
> > > Changing mn_memslots_update_rcuwait to a waitq (and renaming it to
> > > mn_invalidate_waitq) is of course also a possibility.
> > I suspect that's the answer.
> > 
> > I think the actual*invalidation*  of the cache still lives in the
> > invalidate_range() callback where I have it at the moment.

Oooh!  [finally had a lightbulb moment about ->invalidate_range() after years of
befuddlement].

Two things:

  1. Using _only_ ->invalidate_range() is not correct.  ->invalidate_range() is
     required if and only if the old PFN needs to be _unmapped_.  Specifically,
     if the protections are being downgraded without changing the PFN, it doesn't
     need to be called.  E.g. from hugetlb_change_protection():

	/*
	 * No need to call mmu_notifier_invalidate_range() we are downgrading
	 * page table protection not changing it to point to a new page.
	 *
	 * See Documentation/vm/mmu_notifier.rst
	 */

     x86's kvm_arch_mmu_notifier_invalidate_range() is a special snowflake because
     the APIC access page's VMA is controlled by KVM, i.e. is never downgraded, the
     only thing KVM cares about is if the PFN is changed, because that's the only
     thing that can change.

     In this case, if an HVA is downgraded from RW=R, KVM may not invalidate the
     cache and end up writing to memory that is supposed to be read-only.

     I believe we could use ->invalidate_range() to handle the unmap case if KVM's
     ->invalidate_range_start() hook is enhanced to handle the RW=>R case.  The
     "struct mmu_notifier_range" provides the event type, IIUC we could have the
     _start() variant handle MMU_NOTIFY_PROTECTION_{VMA,PAGE} (and maybe
     MMU_NOTIFY_SOFT_DIRTY?), and let the more precise unmap-only variant handle
     everything else.

  2. If we do split the logic across the two hooks, we should (a) do it in a separate
     series and (b) make the logic common to the gfn_to_pfn cache and to the standard
     kvm_unmap_gfn_range().  That would in theory shave a bit of time off walking
     gfn ranges (maybe even moreso with the scalable memslots implementation?), and
     if we're lucky, would resurrect the mostly-dead .change_pte() hook (see commit
     c13fda237f08 ("KVM: Assert that notifier count is elevated in .change_pte()")).

> > But making the req to the affected vCPUs can live in
> > invalidate_range_start(). And then the code which*handles*  that req can
> > wait for the mmu_notifier_count to reach zero before it proceeds. Atomic
> > users of the cache (like the Xen event channel code) don't have to get
> > involved with that.
> > 
> > > Also, for the small requests: since you are at it, can you add the code
> > > in a new file under virt/kvm/?
> > 
> > Hm... only if I can make hva_to_pfn() and probably a handful of other
> > things non-static?
> 
> Yes, I think sooner or later we also want all pfn stuff in one file
> (together with MMU notifiers) and all hva stuff in another; so for now you
> can create virt/kvm/hva_to_pfn.h, or virt/kvm/mm.h, or whatever color of the
> bikeshed you prefer.

Preemptive bikeshed strike... the MMU notifiers aren't strictly "pfn stuff", as
they operate on HVAs.  I don't know exactly what Paolo has in mind, but kvm/mm.h
or kvm/kvm_mm.h seems like it's less likely to become stale in the future.
