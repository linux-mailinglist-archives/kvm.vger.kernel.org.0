Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA83492D05
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 19:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347813AbiARSM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 13:12:57 -0500
Received: from foss.arm.com ([217.140.110.172]:34960 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233793AbiARSM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 13:12:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 320DCD6E;
        Tue, 18 Jan 2022 10:12:56 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.37.52])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97E453F774;
        Tue, 18 Jan 2022 10:12:44 -0800 (PST)
Date:   Tue, 18 Jan 2022 18:12:40 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Sven Schnelle <svens@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, aleksandar.qemu.devel@gmail.com,
        alexandru.elisei@arm.com, anup.patel@wdc.com,
        aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com,
        chenhuacai@kernel.org, dave.hansen@linux.intel.com,
        david@redhat.com, frankja@linux.ibm.com, frederic@kernel.org,
        gor@linux.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        james.morse@arm.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, maz@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, nsaenzju@redhat.com, palmer@dabbelt.com,
        paulmck@kernel.org, paulus@samba.org, paul.walmsley@sifive.com,
        seanjc@google.com, suzuki.poulose@arm.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
Subject: Re: [PATCH 0/5] kvm: fix latent guest entry/exit bugs
Message-ID: <20220118181240.GF17938@C02TD0UTHF1T.local>
References: <ae1a42ab-f719-4a4e-8d2a-e2b4fa6e9580@linux.ibm.com>
 <YeF7Wvz05JhyCx0l@FVFF77S0Q05N>
 <b66c4856-7826-9cff-83f3-007d7ed5635c@linux.ibm.com>
 <YeGUnwhbSvwJz5pD@FVFF77S0Q05N>
 <8aa0cada-7f00-47b3-41e4-8a9e7beaae47@redhat.com>
 <20220118120154.GA17938@C02TD0UTHF1T.local>
 <6b6b8a2b-202c-8966-b3f7-5ce35cf40a7e@linux.ibm.com>
 <20220118131223.GC17938@C02TD0UTHF1T.local>
 <yt9dfsplc9fu.fsf@linux.ibm.com>
 <20220118175051.GE17938@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118175051.GE17938@C02TD0UTHF1T.local>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022 at 05:50:51PM +0000, Mark Rutland wrote:
> On Tue, Jan 18, 2022 at 05:09:25PM +0100, Sven Schnelle wrote:
> > I wonder whether the code in irqentry_enter() should call a function
> > is_eqs() instead of is_idle_task(). The default implementation would
> > be just a
> > 
> > #ifndef is_eqs
> > #define is_eqs is_idle_task
> > #endif
> > 
> > and if an architecture has special requirements, it could just define
> > is_eqs() and do the required checks there. This way the architecture
> > could define whether it's a percpu bit, a cpu flag or something else.
> 
> I had come to almost the same approach: I've added an arch_in_rcu_eqs()
> which is checked in addition to the existing is_idle_thread() check.
> 
> In the case of checking is_idle_thread() and checking for PF_VCPU, I'm
> assuming the compiler can merge the loads of current->flags, and there's
> little gain by making this entirely architecture specific, but we can
> always check that and/or reconsider in future.

FWIW, I've pushed out my WIP to:

 https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=kvm/entry-rework

... and I intend to clean that up and get it out on the list tomorrow.

The new entry/exit helpers are:

  https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/commit/?h=kvm/entry-rework&id=df292ecabba50145849d8c8888cec9153267b31d

The arch_in_rcu_eqs() bit is:

  https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/commit/?h=kvm/entry-rework&id=6e24c5ed7558ee7a4c95dfe62891dfdc51e6c6c4

The s390 changes are:

  https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/commit/?h=kvm/entry-rework&id=ca8daba1809b6e4f1be425ca93f6373a2ea0af6b

I need to clean up the commit messages (including typos, TODOs, and
deleting some stale gunk), and there are some comments to write, but by
and large I think the structure is about right.

Thanks,
Mark.
