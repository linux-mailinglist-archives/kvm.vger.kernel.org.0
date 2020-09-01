Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74FA259FFA
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 22:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgIAU3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 16:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgIAU3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 16:29:44 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBEDC061244
        for <kvm@vger.kernel.org>; Tue,  1 Sep 2020 13:29:43 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f2so2296440qkh.3
        for <kvm@vger.kernel.org>; Tue, 01 Sep 2020 13:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JnUIDoUYpN+YzxHLoztItAayCf2d7HL+a6fptLt5Lr8=;
        b=M2V0O0kDMPoD/RYjMnlauMz6r1HXrKHU5GdMmNXaxLmv90dfOE0CNWOERcjmqnvb4A
         Bl9DUr9wpFFf5hJ5JxNKIK2G6pgHC3+gzEH/fH4Rw1acv3w4p46ddBfVUNVV7MxBHWPo
         b+O96M0VfFgL4tq+ZAcFFnuc9RWRvdXzJPivEOxOkeyNpJig0jZRy1v/S2gBpYdHec7+
         SWYCyrTpPg6SBiNXmGL2WQLqFNj3q2qZo+71X3J9uEsM8nY6UalE6psNtUydMuC8crHG
         A60Cuzw4ym1zhS8+wQpa571mpIfC7pFMfNS2zgyEIR+cAyS7N6JBF10+18iKj2USEwso
         AcRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JnUIDoUYpN+YzxHLoztItAayCf2d7HL+a6fptLt5Lr8=;
        b=dapSTR39yTZ4pL04esk2OI8L87XNyibKFOtaCBewEJRpIamJzfxGKgTzSgL1ikaW14
         5SexUBZM4ta1HOtnavsOJ79/PH8aAmYUQ5FXeAL/CjZL+iybBPi6+ysy5LCAg4nirfWL
         mhbHe/Pe4WLJTqRTnVxrswBfe9zFnH7448fKMcE30hUx0s9GLcCp3bGyLtNB3lEhW2iw
         d8tcGWkc7fyk1Yx9HsHbZM7+k2DgboeGy/Drsv08mxMmBugYBRDJeI+uJjMtb14PZQF5
         QzzlEBBlH/8wchlCc0cgQR2O05dn389Ayw16cE7UVgyQqA/SXe/Lmcz58eZ2rzMvD+98
         +5BQ==
X-Gm-Message-State: AOAM532bnukhY5KRAaqt9B7kYo2jJrTFMfn68eyx6Uph44rWjeTmCVdu
        T1iO1qkolWUV6mqjBd1X5gSeeAdW7qyg1KbfmRRHxA==
X-Google-Smtp-Source: ABdhPJwPVYRN/6spHYgzgBXviPJXrSojq3akxbh/sWIlKihsLKt8XxMiXvDZU/axVRnLC2j47e/bEnQYJsBlfAwKAAk=
X-Received: by 2002:a37:b6c6:: with SMTP id g189mr3770065qkf.491.1598992182533;
 Tue, 01 Sep 2020 13:29:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200820230545.2411347-1-pshier@google.com> <20200822032518.GB4769@sjchrist-ice>
In-Reply-To: <20200822032518.GB4769@sjchrist-ice>
From:   Peter Shier <pshier@google.com>
Date:   Tue, 1 Sep 2020 13:29:31 -0700
Message-ID: <CACwOFJT3iin6c5vDKdY59eLkh1Kts4nequkr2we6CF7zGWCCJw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: nVMX: Update VMCS02 when L2 PAE PDPTE updates detected
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21, 2020 at 8:25 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Aug 20, 2020 at 04:05:45PM -0700, Peter Shier wrote:
> > When L2 uses PAE, L0 intercepts of L2 writes to CR0/CR3/CR4 call
> > load_pdptrs to read the possibly updated PDPTEs from the guest
> > physical address referenced by CR3.  It loads them into
> > vcpu->arch.walk_mmu->pdptrs and sets VCPU_EXREG_PDPTR in
> > vcpu->arch.regs_dirty.
> >
> > At the subsequent assumed reentry into L2, the mmu will call
> > vmx_load_mmu_pgd which calls ept_load_pdptrs. ept_load_pdptrs sees
> > VCPU_EXREG_PDPTR set in vcpu->arch.regs_dirty and loads
> > VMCS02.GUEST_PDPTRn from vcpu->arch.walk_mmu->pdptrs[]. This all works
> > if the L2 CRn write intercept always resumes L2.
> >
> > The resume path calls vmx_check_nested_events which checks for
> > exceptions, MTF, and expired VMX preemption timers. If
> > vmx_check_nested_events finds any of these conditions pending it will
> > reflect the corresponding exit into L1. Live migration at this point
> > would also cause a missed immediate reentry into L2.
> >
> > After L1 exits, vmx_vcpu_run calls vmx_register_cache_reset which
> > clears VCPU_EXREG_PDPTR in vcpu->arch.regs_dirty.  When L2 next
> > resumes, ept_load_pdptrs finds VCPU_EXREG_PDPTR clear in
> > vcpu->arch.regs_dirty and does not load VMCS02.GUEST_PDPTRn from
> > vcpu->arch.walk_mmu->pdptrs[]. prepare_vmcs02 will then load
> > VMCS02.GUEST_PDPTRn from vmcs12->pdptr0/1/2/3 which contain the stale
> > values stored at last L2 exit. A repro of this bug showed L2 entering
> > triple fault immediately due to the bad VMCS02.GUEST_PDPTRn values.
> >
> > When L2 is in PAE paging mode add a call to ept_load_pdptrs before
> > leaving L2. This will update VMCS02.GUEST_PDPTRn if they are dirty in
> > vcpu->arch.walk_mmu->pdptrs[].
> >
> > Tested:
> > kvm-unit-tests with new directed test: vmx_mtf_pdpte_test.
> > Verified that test fails without the fix.
> >
> > Also ran Google internal VMM with an Ubuntu 16.04 4.4.0-83 guest running a
> > custom hypervisor with a 32-bit Windows XP L2 guest using PAE. Prior to fix
> > would repro readily. Ran 14 simultaneous L2s for 140 iterations with no
> > failures.
> >
> > Signed-off-by: Peter Shier <pshier@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > ---
>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

Ping. Thx
