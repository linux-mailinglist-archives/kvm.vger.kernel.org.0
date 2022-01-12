Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D41648CDCD
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 22:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbiALVcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 16:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiALVcG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 16:32:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6ABC06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 13:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TPJ/eK2xAwtL4wYg0Q5syP0sFbfETOESHGlGODOKb88=; b=dAKQo5lLf445EL7DRL9y3dX/OU
        KDcVfaBGmp95xBQvx7UllK7OI9/j7Biapy8yUP1ej7+lA+YQv51+ksshqxSyPhgPSAeIBqq4ARnB6
        nyos0hWBOY15glqgzmq1vJwXdrJHHXhHfIslb+NNW8ntZCwqSISG1nGAiCEoj2Mv3Us53uQAK4EZ4
        f/J/t0xGffLpuAxnpPKFciERE11NaeUcNU0fE48YcnomySkGnWnpzOhbJdts01jbHtHd+jE4ZLDo2
        wG+xX99SS2Mq7zOSojiZ4DiKoqKmWAmoUvI3bsEpZ2vp20KUCX9m+5gIugRZnJ5SXr05JBMFHfRpF
        Mwuzr4hA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7lDP-004Q3Z-FO; Wed, 12 Jan 2022 21:31:31 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 77E499862BC; Wed, 12 Jan 2022 22:31:29 +0100 (CET)
Date:   Wed, 12 Jan 2022 22:31:29 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, bp@alien8.de, x86@kernel.org,
        kvm@vger.kernel.org, joro@8bytes.org
Subject: Re: [PATCH] KVM: X86: set vcpu preempted only if it is preempted
Message-ID: <20220112213129.GO16608@worktop.programming.kicks-ass.net>
References: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
 <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net>
 <Yd8QR2KHDfsekvNg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd8QR2KHDfsekvNg@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 05:30:47PM +0000, Sean Christopherson wrote:
> On Wed, Jan 12, 2022, Peter Zijlstra wrote:
> > On Wed, Jan 12, 2022 at 08:02:01PM +0800, Li RongQing wrote:
> > > vcpu can schedule out when run halt instruction, and set itself
> > > to INTERRUPTIBLE and switch to idle thread, vcpu should not be
> > > set preempted for this condition
> > 
> > Uhhmm, why not? Who says the vcpu will run the moment it becomes
> > runnable again? Another task could be woken up meanwhile occupying the
> > real cpu.
> 
> Hrm, but when emulating HLT, e.g. for an idling vCPU, KVM will voluntarily schedule
> out the vCPU and mark it as preempted from the guest's perspective.  The vast majority,
> probably all, usage of steal_time.preempted expects it to truly mean "preempted" as
> opposed to "not running".

No, the original use-case was locking and that really cares about
running.

If the vCPU isn't running, we must not busy-wait for it etc..

Similar to the scheduler use of it, if the vCPU isn't running, we should
not consider it so. Getting the vCPU task scheduled back on the CPU can
take a 'long' time.

If you have pinned vCPU threads and no overcommit, we have other knobs
to indicate this I tihnk.
