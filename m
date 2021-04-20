Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8263A366282
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 01:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhDTXeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 19:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234280AbhDTXeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 19:34:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77BB661417;
        Tue, 20 Apr 2021 23:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618961622;
        bh=8B7pNQVGVPqFq0OWNqhKIFYmTu1o9WldILSo9/Ljz44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ktKbcgcxv4i8AftnZ+aGfR+j9fb32bPnaS8+Fh0aC/sUcA499GxKE/ACuBXcx+VRF
         Kuq+r6oCCf0lN3UOkHLSgQoUN4Y+qltj1eqKl2DDGzfdZ5bY3lYL2esbC+STr5MgpV
         wS6Z9RDUV6PgeP/00Yo+WNbmPCIl7lIGwpmO5ZC5PHG9eQPMV22a3hLYUoquYSGnrl
         coUtdC9rFeSVwLxrARypQm1oZ5dvEcGmSIYS3X9UQTU4R8PaPY5jt74AHKkUpI8fXM
         uBjjqVpW3i/Vl+bkcH+1Awb6nifw58rEuuLvr9jqc/krPgEsjkRPm7gEadtZ5Tb1IP
         vJ8wJGMrlxKbA==
Date:   Wed, 21 Apr 2021 01:33:38 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v3 0/9] KVM: Fix tick-based accounting for x86 guests
Message-ID: <20210420233338.GB8720@lothringen>
References: <20210415222106.1643837-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415222106.1643837-1-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021 at 03:20:57PM -0700, Sean Christopherson wrote:
> This is a continuation of Wanpeng's series[1] to fix tick-based CPU time
> accounting on x86, with my cleanups[2] bolted on top.  The core premise of
> Wanpeng's patches are preserved, but they are heavily stripped down.
> Specifically, only the "guest exit" paths are split, and no code is
> consolidated.  The intent is to do as little as possible in the three
> patches that need to be backported.  Keeping those changes as small as
> possible also meant that my cleanups did not need to unwind much 
> refactoring.
> 
> On x86, tested CONFIG_VIRT_CPU_ACCOUNTING_GEN =y and =n, and with
> CONFIG_DEBUG_ENTRY=y && CONFIG_VALIDATE_STACKS=y.  Compile tested arm64,
> MIPS, PPC, and s390, the latter with CONFIG_DEBUG_ENTRY=y for giggles.
> 
> One last note: I elected to use vtime_account_guest_exit() in the x86 code
> instead of open coding these equivalents:
> 
> 	if (vtime_accounting_enabled_this_cpu())
> 		vtime_guest_exit(current);
> ...
> 	if (!vtime_accounting_enabled_this_cpu())
> 		current->flags &= ~PF_VCPU;
> 
> With CONFIG_VIRT_CPU_ACCOUNTING_GEN=n, this is a complete non-issue, but
> for the =y case it means context_tracking_enabled_this_cpu() is being
> checked back-to-back.  The redundant checks bug me, but open coding the
> gory details in x86 or providing funky variants in vtime.h felt worse.
> 
> Delta from Wanpeng's v2:
> 
>   - s/context_guest/context_tracking_guest, purely to match the existing
>     functions.  I have no strong opinion either way.
>   - Split only the "exit" functions.
>   - Partially open code vcpu_account_guest_exit() and
>     __vtime_account_guest_exit() in x86 to avoid churn when segueing into
>     my cleanups (see above).
> 
> [1] https://lkml.kernel.org/r/1618298169-3831-1-git-send-email-wanpengli@tencent.com
> [2] https://lkml.kernel.org/r/20210413182933.1046389-1-seanjc@google.com
> 
> Sean Christopherson (6):
>   sched/vtime: Move vtime accounting external declarations above inlines
>   sched/vtime: Move guest enter/exit vtime accounting to vtime.h
>   context_tracking: Consolidate guest enter/exit wrappers
>   context_tracking: KVM: Move guest enter/exit wrappers to KVM's domain
>   KVM: x86: Consolidate guest enter/exit logic to common helpers
>   KVM: Move instrumentation-safe annotations for enter/exit to x86 code
> 
> Wanpeng Li (3):
>   context_tracking: Move guest exit context tracking to separate helpers
>   context_tracking: Move guest exit vtime accounting to separate helpers
>   KVM: x86: Defer tick-based accounting 'til after IRQ handling
> 
>  arch/x86/kvm/svm/svm.c           |  39 +--------
>  arch/x86/kvm/vmx/vmx.c           |  39 +--------
>  arch/x86/kvm/x86.c               |   8 ++
>  arch/x86/kvm/x86.h               |  52 ++++++++++++
>  include/linux/context_tracking.h |  92 ++++-----------------
>  include/linux/kvm_host.h         |  38 +++++++++
>  include/linux/vtime.h            | 138 +++++++++++++++++++------------
>  7 files changed, 204 insertions(+), 202 deletions(-)

Please Cc me on any follow-up of this patchset. I have set up a lot of booby
traps on purpose in this cave and I might be able to remember a few on the way.
Should you meet one of the poisoned arrows, rest assured that you were not the
aimed target though.

Thanks.
