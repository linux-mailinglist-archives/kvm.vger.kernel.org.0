Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695423DF1A2
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 17:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbhHCPjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 11:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236935AbhHCPjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 11:39:48 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C68C061757
        for <kvm@vger.kernel.org>; Tue,  3 Aug 2021 08:39:37 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id j3so9102865plx.4
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 08:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2sX1mKKrCL8lc1p+n/MM0GDdJIkBlYihGahD2K+Ccl8=;
        b=TFvnWLm9PZnPoUxcmPjeksWlW6a45bHVn2xs4koKJM+KQ9oM+9PefWknC1HiwT6SNC
         /1l95mD17frIgwbeuX0o7Igx53gRV3Vu9A8NiLr+j33935xAE5e2sLDe08RdKr03cA11
         In+ZxccgmFeTY2SUj4n3D/CQnXlqvEGLGEiDRUfIb6CwZUiL6/AbNbY4yz2a9H1ZihT6
         RtPctBf+OJukscPGs48ThDjJGAHIKY+oebLmkudSeCHvhq6/R0LlRXPr2LB4HJUAxrhU
         aGTbdGUGOY/p6ztM0HG72969IkPFiyOMPZLt8uJgq1CdwFb3gNv2W5CLXBYceH/a3yoZ
         r7+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2sX1mKKrCL8lc1p+n/MM0GDdJIkBlYihGahD2K+Ccl8=;
        b=bX8URQLF5qkQXEZED1gk8AxJ+pucjC0DZQhMm/G01cBp3zprOWJN/UEtQUvVmANZAw
         GvfRJyoFU8/jQoFCgvdF3QGYR5ZTWBw7+RSy2BWmJ+4eUEx0W/aK4RHuA2BjeUXYlFy1
         HBebav1I91OyXRgrpQSzeymgBD10KIcnR6U3jcMFfaptS9ap4oVqfT6yLfMNTDEfokg9
         I+//XPjT0SpwijvvZUsvg5MmxVZqbj995RBX9A0wq7kjyEFK91EnCyTT60fpGxEM/A7O
         1a1hvoMyywlgnXD9hzoeryvkUnyti5Jxa8aXgJBiB6SnJgNtDjOeSYYkp5mV8L9MWDUP
         5TIQ==
X-Gm-Message-State: AOAM5337AZpGrrr9C5WxvvhVB9V7B1TJyt0EqsV7zikvt8AMbfG2Yfnm
        M7C8RxGEN804JvOR2MV5O+cUaA==
X-Google-Smtp-Source: ABdhPJzbTpsIiHV6WTUKwsj1FL6VXvZnxrSQwhBUuATXzgUkC4HF26wKX0eARxW+JJ2tFbPYVdg/Ww==
X-Received: by 2002:a63:8c04:: with SMTP id m4mr2351035pgd.89.1628005177069;
        Tue, 03 Aug 2021 08:39:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v7sm14367366pjk.37.2021.08.03.08.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 08:39:36 -0700 (PDT)
Date:   Tue, 3 Aug 2021 15:39:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/37] KVM: VMX: Flush all EPTP/VPID contexts on
 remote TLB flush
Message-ID: <YQljNBBp/EousNBk@google.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-2-sean.j.christopherson@intel.com>
 <CAJhGHyCPyu6BVZwqvySeT2LSr81Xospdv2O=ssvTQv0Rvky0UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyCPyu6BVZwqvySeT2LSr81Xospdv2O=ssvTQv0Rvky0UA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 03, 2021, Lai Jiangshan wrote:
> (I'm replying to a very old email, so many CCs are dropped.)
> 
> On Sat, Mar 21, 2020 at 5:33 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Flush all EPTP/VPID contexts if a TLB flush _may_ have been triggered by
> > a remote or deferred TLB flush, i.e. by KVM_REQ_TLB_FLUSH.  Remote TLB
> > flushes require all contexts to be invalidated, not just the active
> > contexts, e.g. all mappings in all contexts for a given HVA need to be
> > invalidated on a mmu_notifier invalidation.  Similarly, the instigator
> > of the deferred TLB flush may be expecting all contexts to be flushed,
> > e.g. vmx_vcpu_load_vmcs().
> >
> > Without nested VMX, flushing only the current EPTP/VPID context isn't
> > problematic because KVM uses a constant VPID for each vCPU, and
> 
> Hello, Sean
> 
> Is the patch optimized for cases where nested VMX is active?

Well, this patch isn't, but KVM has since been optimized to do full EPT/VPID
flushes only when "necessary".  Necessary in quotes because the two uses can
technically be further optimized, but doing so would incur significant complexity.

Use #1 is remote flushes from the MMU, which don't strictly require a global flush,
but KVM would need to propagate more information (mmu_role?) in order for responding
vCPUs to determine what contexts needs to be flushed.  And practically speaking,
for MMU flushes there's no meaningful difference when using TDP without nested
guests as the common case will be that each vCPU has a single active EPTP and
that EPTP will be affected by the MMU changes, i.e. needs to be flushed.

Use #2 is in VMX's pCPU migration path.  Again, not strictly necessary as KVM could
theoretically track which pCPUs have run a particular vCPU and when that pCPU last
flushed EPT contexts, but fully solving the problem would be quite complex.  Since
pCPU migration is always going to be a slow path, the extra complexity would be
very difficult to justify.

> I think the non-nested cases are normal cases.
> 
> Although the related code has been changed, the logic of the patch
> is still working now, would it be better if we restore the optimization
> for the normal cases (non-nested)?

As above, vmx_flush_tlb_all() hasn't changed, but the callers have.
