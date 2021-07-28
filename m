Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AAF3D8982
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 10:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbhG1IL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 04:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbhG1IL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 04:11:28 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C4DC061757;
        Wed, 28 Jul 2021 01:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vTbuxttj0FFIwn1FK4YowH8wGy2ge1M6WiA+RdlzqII=; b=i+ONwuTrrfD7jE9yjOnbb2LvR6
        bJo1sHq5YTn7t+rCxdt6RZbLulxiEtk+iriCQlzGHwRVDz6JS2v+h73lXg5zVXfr7qms+77zhwJtt
        IQjf4hr+D0RAbjEnkWWawxP873c3mcAA+d0bvcM2Yv0vsA6auGdCxnNUmcdttsWgndrRBY8jhCJGE
        qfrjKr4+CMuSXSmFMwwF6DvLibv78aGEQXWrzkBuRhDXHVAkrzVD+l4Js8xOBIWavG1xs+24OzWTg
        KA9PR9XZto4yjSLUpNmt3OnVX6W9d7sQa3DXGJ/Y4qhF96bS6hCHxfcwgKFgP8JI69QGdc1IaPBGy
        xhNfqhMA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8eeA-003ewE-Mv; Wed, 28 Jul 2021 08:10:34 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CB7CC30005A;
        Wed, 28 Jul 2021 10:10:31 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id ACFB921396EA6; Wed, 28 Jul 2021 10:10:31 +0200 (CEST)
Date:   Wed, 28 Jul 2021 10:10:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Suleiman Souhlal <suleiman@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        ssouhlal@freebsd.org, joelaf@google.com, senozhatsky@chromium.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] KVM: Support Heterogeneous RT VCPU
 Configurations.
Message-ID: <YQEQ9zdlBrgpOukj@hirez.programming.kicks-ass.net>
References: <20210728073700.120449-1-suleiman@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728073700.120449-1-suleiman@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 04:36:58PM +0900, Suleiman Souhlal wrote:
> Hello,
> 
> This series attempts to solve some issues that arise from
> having some VCPUs be real-time while others aren't.
> 
> We are trying to play media inside a VM on a desktop environment
> (Chromebooks), which requires us to have some tasks in the guest
> be serviced at real-time priority on the host so that the media
> can be played smoothly.
> 
> To achieve this, we give a VCPU real-time priority on the host
> and use isolcpus= to ensure that only designated tasks are allowed
> to run on the RT VCPU.

WTH do you need isolcpus for that? What's wrong with cpusets?

> In order to avoid priority inversions (for example when the RT
> VCPU preempts a non-RT that's holding a lock that it wants to
> acquire), we dedicate a host core to the RT vcpu: Only the RT
> VCPU is allowed to run on that CPU, while all the other non-RT
> cores run on all the other host CPUs.
> 
> This approach works on machines that have a large enough number
> of CPUs where it's possible to dedicate a whole CPU for this,
> but we also have machines that only have 2 CPUs and doing this
> on those is too costly.
> 
> This patch series makes it possible to have a RT VCPU without
> having to dedicate a whole host core for it.
> It does this by making it so that non-RT VCPUs can't be
> preempted if they are in a critical section, which we
> approximate as having interrupts disabled or non-zero
> preempt_count. Once the VCPU is found to not be in a critical
> section anymore, it will give up the CPU.
> There measures to ensure that preemption isn't delayed too
> many times.
> 
> (I realize that the hooks in the scheduler aren't very
> tasteful, but I couldn't figure out a better way.
> SVM support will be added when sending the patch for
> inclusion.)
> 
> Feedback or alternatives are appreciated.

This is disguisting and completely wrecks the host scheduling. You're
placing guest over host, that's fundamentally wrong.

NAK!

If you want co-ordinated RT scheduling, look at paravirtualized deadline
scheduling.
