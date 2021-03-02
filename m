Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B9C32B595
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381078AbhCCHSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581631AbhCBTBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 14:01:00 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586FCC06178B
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 10:56:26 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id k22so12560402pll.6
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 10:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UakjRFV7I3zgiMcVHz9PtvL5bu+2z3t7UmhBb2UlaRo=;
        b=KOCX7C/n+Giax9CXgQLNaBQzEb8gAwWJ0mMJs148tKVI2Z1/pG4LQoGmsvTtEBGKvr
         yDrvvnI9NjgIE2Mv8gfq2rwz5L7zJpMp4LMG7WCMWuDstbzuIxbz/ZqELiyJVHNMF5w3
         fFTXxk9P6pfeVcjBlbH1WOMAbxAKOAgjnSgPyfyA7qnRRVPShQR46EsMsYM1ORHrSHfB
         xVuSCmvU5xZr2Y34isIfUWccfDO28BXczsobuwbvJGe6pgjPiTShcveau+lWSklRZ3rt
         Ef4uVEn7/4yn76fOPbbCsrLsDfFYpL1lNd9thhIq3UKuwfR0/MNk0hE2xP5263Otab7U
         Mrzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UakjRFV7I3zgiMcVHz9PtvL5bu+2z3t7UmhBb2UlaRo=;
        b=lxcOP+HTG4R2Q2LQ4SBcA37ODbP4cRJ7cchkKO6cQqO2H2jvvjlSNhUpqX41Tv25kw
         wPvhunFTeOK+1yRfVBI/Y3S+hRn+YzowsTtdDDXR00CB8NPueJGbVQ8S77MIBOaIhtOo
         FXF1zvga0fjFyQP3txNIiH12CXLdFzkzdM06HV+Fx3ePgiSs5+B3eIfe6tg1TzIK7Ike
         tqbQ8vtwRiPBqHcIF6+2mwD5+eNTxZeeAPmFZvfi5TWfaYPnVIYqgwSHd0uI2gKwCqHZ
         iuJbFoY4cAlD9BLzB7qVqGUwdHcS/ccSbF5LdEmoiuF5XPqBInyIn8FAxSMWhagQA6Wb
         yhlA==
X-Gm-Message-State: AOAM532H+ry1kuBTRicb4k+QOaWDYvpMTGeppFH+hHX4juQyPG0faQre
        92vhqBza1NTyfoH3JdZfkDYAyQ==
X-Google-Smtp-Source: ABdhPJz/3iWxNd/0QEjau5XG3vSh9x0ae3R/TPebaeYLJJ/xMuUMzOpoGvO+Wy+HJKTG0YdOE1v9gw==
X-Received: by 2002:a17:90a:cd06:: with SMTP id d6mr5755840pju.138.1614711385768;
        Tue, 02 Mar 2021 10:56:25 -0800 (PST)
Received: from google.com ([2620:15c:f:10:805d:6324:3372:6183])
        by smtp.gmail.com with ESMTPSA id z11sm20733810pgc.6.2021.03.02.10.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 10:56:25 -0800 (PST)
Date:   Tue, 2 Mar 2021 10:56:18 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/11] KVM: VMX: Clean up Hyper-V PV TLB flush
Message-ID: <YD6KUoZGE2UASLa5@google.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
 <7ed340f1-f6f7-4682-65be-6bc02f25d612@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ed340f1-f6f7-4682-65be-6bc02f25d612@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 27, 2021, Paolo Bonzini wrote:
> On 27/10/20 22:23, Sean Christopherson wrote:
> > Clean up KVM's PV TLB flushing when running with EPT on Hyper-V, i.e. as
> > a nested VMM.  No real goal in mind other than the sole patch in v1, which
> > is a minor change to avoid a future mixup when TDX also wants to define
> > .remote_flush_tlb.  Everything else is opportunistic clean up.
> > 
> > Patch 1 legitimately tested on VMX (no SVM), everything else effectively
> > build tested only.
> > 
> > v3:
> >    - Add a patch to pass the root_hpa instead of pgd to vmx_load_mmu_pgd()
> >      and retrieve the active PCID only when necessary.  [Vitaly]
> >    - Selectively collects reviews (skipped a few due to changes). [Vitaly]
> >    - Explicitly invalidate hv_tlb_eptp instead of leaving it valid when
> >      the mismatch tracker "knows" it's invalid. [Vitaly]
> >    - Change the last patch to use "hv_root_ept" instead of "hv_tlb_pgd"
> >      to better reflect what is actually being tracked.
> > 
> > v2: Rewrite everything.
> > Sean Christopherson (11):
> >    KVM: x86: Get active PCID only when writing a CR3 value
> >    KVM: VMX: Track common EPTP for Hyper-V's paravirt TLB flush
> >    KVM: VMX: Stash kvm_vmx in a local variable for Hyper-V paravirt TLB
> >      flush
> >    KVM: VMX: Fold Hyper-V EPTP checking into it's only caller
> >    KVM: VMX: Do Hyper-V TLB flush iff vCPU's EPTP hasn't been flushed
> >    KVM: VMX: Invalidate hv_tlb_eptp to denote an EPTP mismatch
> >    KVM: VMX: Don't invalidate hv_tlb_eptp if the new EPTP matches
> >    KVM: VMX: Explicitly check for hv_remote_flush_tlb when loading pgd
> >    KVM: VMX: Define Hyper-V paravirt TLB flush fields iff Hyper-V is
> >      enabled
> >    KVM: VMX: Skip additional Hyper-V TLB EPTP flushes if one fails
> >    KVM: VMX: Track root HPA instead of EPTP for paravirt Hyper-V TLB
> >      flush
> > 
> >   arch/x86/include/asm/kvm_host.h |   4 +-
> >   arch/x86/kvm/mmu.h              |   2 +-
> >   arch/x86/kvm/svm/svm.c          |   4 +-
> >   arch/x86/kvm/vmx/vmx.c          | 134 ++++++++++++++++++--------------
> >   arch/x86/kvm/vmx/vmx.h          |  19 ++---
> >   5 files changed, 87 insertions(+), 76 deletions(-)
> > 
> 
> Queued, thanks.

Looks like this got shadow-banned, I'll send v4.
