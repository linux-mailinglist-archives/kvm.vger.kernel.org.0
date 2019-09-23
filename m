Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8ED6BB81A
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 17:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732021AbfIWPh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 11:37:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43380 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbfIWPh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 11:37:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HwVxnNpp1n9OA+fVGYRWNY81ByHgzbvYySZmkNsPir4=; b=DUU3BOMoLfS6XyZ4vX2N30p+5
        1mukSx1t4eKaeRVjA11BqrRKFTAlUXc6iPM1lGEnOcBsGGRb9LxT4dtUNab93sI0CVTrvWbrmecj8
        JvyhmaWm42JOLJOghiqYdNSduNLUY/bcsr58hqmrU8X8zdcWdWV5865p6WY9RDN/DByZ59VpNst0p
        s91gLm8STVZ8OnfqvYIK0mAN8fNGL9eSf1OnhI5EaKN22egfHntF5r1fPf4g+I3ghGdz3rhy6CxHs
        FDuuofPY1UKSOCs+kmQ0sWOD03ad93lH8Kj/eAwX/ZTPWB7rEHrgtqN6+fUpVhgAI1GqAfba7Ey6I
        k+Lqh8JSg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iCQOp-0004me-Ea; Mon, 23 Sep 2019 15:37:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C0037303DFD;
        Mon, 23 Sep 2019 17:36:28 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F0CB020D80D44; Mon, 23 Sep 2019 17:37:13 +0200 (CEST)
Date:   Mon, 23 Sep 2019 17:37:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH 2/3] KVM: x86: hyper-v: set NoNonArchitecturalCoreSharing
 CPUID bit when SMT is impossible
Message-ID: <20190923153713.GF2369@hirez.programming.kicks-ass.net>
References: <20190916162258.6528-1-vkuznets@redhat.com>
 <20190916162258.6528-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916162258.6528-3-vkuznets@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 16, 2019 at 06:22:57PM +0200, Vitaly Kuznetsov wrote:
> Hyper-V 2019 doesn't expose MD_CLEAR CPUID bit to guests when it cannot
> guarantee that two virtual processors won't end up running on sibling SMT
> threads without knowing about it. This is done as an optimization as in
> this case there is nothing the guest can do to protect itself against MDS
> and issuing additional flush requests is just pointless. On bare metal the
> topology is known, however, when Hyper-V is running nested (e.g. on top of
> KVM) it needs an additional piece of information: a confirmation that the
> exposed topology (wrt vCPU placement on different SMT threads) is
> trustworthy.
> 
> NoNonArchitecturalCoreSharing (CPUID 0x40000004 EAX bit 18) is described in
> TLFS as follows: "Indicates that a virtual processor will never share a
> physical core with another virtual processor, except for virtual processors
> that are reported as sibling SMT threads." From KVM we can give such
> guarantee in two cases:
> - SMT is unsupported or forcefully disabled (just 'disabled' doesn't work
>  as it can become re-enabled during the lifetime of the guest).
> - vCPUs are properly pinned so the scheduler won't put them on sibling
> SMT threads (when they're not reported as such).
> 
> This patch reports NoNonArchitecturalCoreSharing bit in to userspace in the
> first case. The second case is outside of KVM's domain of responsibility
> (as vCPU pinning is actually done by someone who manages KVM's userspace -
> e.g. libvirt pinning QEMU threads).

This is purely about guest<->guest MDS, right? Ie. not worse than actual
hardware.
