Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059B9389487
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 19:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347529AbhESRRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 13:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242519AbhESRRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 13:17:43 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC33CC06175F
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 10:16:23 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x18so6057636pfi.9
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 10:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r1ngnkmbEmDP+5wIQP+kgtBtTwe/w78V+ekQhBkRKac=;
        b=obef2vjSaRBvgqL3fgNo4a3W1HEa8M7kvtaS2omCZAyIV0iN04Yk8fxArmKrBFwE3h
         c6b+zNSHbO/f7hzctch2qXU8fn9Ais2LdEF+OfF8GekZjhj+iz4y3P+rsqH02+PCdfh1
         JWgrRhgcgqXfoL0u3ve61HgYMJG7eJ9T/fvULQCCflbR78rkosTzdYyaGyDDiR8LDZuQ
         ab3xq/CTlmBESZJglaGhRWpqDyOBLau6WtwxR38POX+qxvm6TytG7Q0hoJVPhPuUVKLC
         /Z9ulI4NsA/Me1wovATA1nZ5mD5BP2Y5o/knYTr0S47RNTXc48EgFqNFhi/7h0emfhg8
         4vlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r1ngnkmbEmDP+5wIQP+kgtBtTwe/w78V+ekQhBkRKac=;
        b=EiC0K5KF4mRpWVx46lEbSdc2Oroh1k3nseAVjk67HEKknOODdr7OeDDNKxmzyJSeVg
         Gou4Mt0KL5Aa2K8pstFEy/TISPOvf5GaUcqIjo1/KrLderEg9W0TloauE7vb5ZkAQHnz
         CdN71+OZsxuBeUxhnnSkOa5yVWKT7xvMaM0EeeBMuMEN4IOrLDUuBy3WEAPSGTbtI7xA
         +lJB3zAlevRUTVk5WIxRHyE1RqSeT7Z+7HPcDY6+dMeAb8yc/bOT6D3uzQK71vddQLOD
         dWiz+8aUFI188Vo/WQ7a8gvq5R28V5++JDH4vXcAv5tyo09ZGAMlfnZ9eOoQ4IGPc3d/
         d3CQ==
X-Gm-Message-State: AOAM531OYAVneJa2zq9ps86Tmi5/dbvXC9QHIRfo2+cIftewiddxI1RN
        zVczT/kXMfOvaSI9ZDKQR4Lk/Q==
X-Google-Smtp-Source: ABdhPJzyQvuu6vDjOl3MRXMOVcuyk2L+CDlAAHs9tqL7B7OirEHuOcpH/dgDufp7v9fRBddMSf7MJw==
X-Received: by 2002:a63:1e64:: with SMTP id p36mr158146pgm.105.1621444583048;
        Wed, 19 May 2021 10:16:23 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id j4sm4035537pjv.7.2021.05.19.10.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 10:16:22 -0700 (PDT)
Date:   Wed, 19 May 2021 17:16:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/43] KVM: x86: Properly reset MMU context at vCPU
 RESET/INIT
Message-ID: <YKVH4mzdAa+H9ROJ@google.com>
References: <20210424004645.3950558-1-seanjc@google.com>
 <20210424004645.3950558-7-seanjc@google.com>
 <CAAeT=FzS0bP_7_wz6G6cL8-7pudTD7fhavLCVsOE0KnPXf99dQ@mail.gmail.com>
 <YKQiTlDG1sZ4Zd2E@google.com>
 <CAAeT=FzsXFNiteMB3sjskM401Ty4Ry_w80YcYB4ZYcZn0dqv5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FzsXFNiteMB3sjskM401Ty4Ry_w80YcYB4ZYcZn0dqv5Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 18, 2021, Reiji Watanabe wrote:
> > > > +       if (kvm_cr0_mmu_role_changed(old_cr0, kvm_read_cr0(vcpu)) ||
> > > > +           kvm_cr4_mmu_role_changed(old_cr4, kvm_read_cr4(vcpu)))
> > > > +               kvm_mmu_reset_context(vcpu);
> > > >  }
> > >
> > > I'm wondering if kvm_vcpu_reset() should call kvm_mmu_reset_context()
> > > for a change in EFER.NX as well.
> >
> > Oooh.  So there _should_ be no need.   Paging has to be enabled for EFER.NX to
> > be relevant, and INIT toggles CR0.PG 1=>0 if paging was enabled and so is
> > guaranteed to trigger a context reset.  And we do want to skip the context reset,
> > e.g. INIT-SIPI-SIPI when the vCPU has paging disabled should continue using the
> > same MMU.
> >
> > But, kvm_calc_mmu_role_common() neglects to ignore NX if CR0.PG=0, and so the
> > MMU role will be stale if INIT clears EFER.NX without forcing a context reset.
> > However, that's benign from a functionality perspective because the context
> > itself correctly incorporates CR0.PG, it's only the role that's borked.  I.e.
> > KVM will fail to reuse a page/context due to the spurious role.nxe, but the
> > permission checks are always be correct.
> >
> > I'll add a comment here and send a patch to fix the role calculation.
> 
> Thank you so much for the explanation !
> I understand your intention and why it would be benign.
> 
> Then, I'm wondering if kvm_cr4_mmu_role_changed() needs to be
> called here.  Looking at the Intel SDM, in my understanding,
> all the bits kvm_cr4_mmu_role_changed() checks are relevant
> only if paging is enabled.  (Or is my understanding incorrect ??)

Duh, yes.  And it goes even beyond that, CR0.WP is only relevant if CR0.PG=1,
i.e. INIT with CR0.PG=0 and CR0.WP=1 will incorrectly trigger a MMU reset with
the current logic.

Sadly, simply omitting the CR4 check puts us in an awkward situation where, due
to the MMU role CR4 calculations not accounting for CR0.PG=0, KVM will run with
a stale role.

The other consideration is that kvm_post_set_cr4() and kvm_post_set_cr0() should
also skip kvm_mmu_reset_context() if CR0.PG=0, but again that requires fixing
the role calculations first (or at the same time).

I think I'll throw in those cleanups to the beginning of this series.  The result
is going to be disgustingly long, but I really don't want to introduce code that
knowingly leaves KVM in an inconsistent state, nor do I want to add useless
checks on CR4 and EFER.
