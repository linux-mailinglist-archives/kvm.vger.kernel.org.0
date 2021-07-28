Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1EA3D8BE6
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 12:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhG1Kea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 06:34:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231704AbhG1Ke3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 06:34:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627468468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uQGUnjcG8DsiVM58cgajvTX/4fKYZesHKMKhLyJTwIY=;
        b=cnGRZ4m3Fg1wG0Rl1bbeBpo6vaJANaO8tdNdgevqzFRNQWdUZhMin6uLjx/xSKxBMQXxjX
        sfCu9UN85sTS1nnebA+IRCWX3dfRelq3VuUDxvbX/kbrotjZic+3RHustskWAcwFAFQbxI
        kKb+ZvM3F02hyUOlGP+o7jV16+KMhT0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-y6PNLSXhNFyM1DhAHpRRxg-1; Wed, 28 Jul 2021 06:34:26 -0400
X-MC-Unique: y6PNLSXhNFyM1DhAHpRRxg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A743CC73A0;
        Wed, 28 Jul 2021 10:34:23 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D0A2B60C05;
        Wed, 28 Jul 2021 10:34:10 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 961D1416F5D2; Wed, 28 Jul 2021 07:32:53 -0300 (-03)
Date:   Wed, 28 Jul 2021 07:32:53 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Suleiman Souhlal <suleiman@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: Re: [RFC PATCH 0/2] KVM: Support Heterogeneous RT VCPU
 Configurations.
Message-ID: <20210728103253.GB7633@fuller.cnet>
References: <20210728073700.120449-1-suleiman@google.com>
 <YQEQ9zdlBrgpOukj@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQEQ9zdlBrgpOukj@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 10:10:31AM +0200, Peter Zijlstra wrote:
> On Wed, Jul 28, 2021 at 04:36:58PM +0900, Suleiman Souhlal wrote:
> > Hello,
> > 
> > This series attempts to solve some issues that arise from
> > having some VCPUs be real-time while others aren't.
> > 
> > We are trying to play media inside a VM on a desktop environment
> > (Chromebooks), which requires us to have some tasks in the guest
> > be serviced at real-time priority on the host so that the media
> > can be played smoothly.
> > 
> > To achieve this, we give a VCPU real-time priority on the host
> > and use isolcpus= to ensure that only designated tasks are allowed
> > to run on the RT VCPU.
> 
> WTH do you need isolcpus for that? What's wrong with cpusets?
> 
> > In order to avoid priority inversions (for example when the RT
> > VCPU preempts a non-RT that's holding a lock that it wants to
> > acquire), we dedicate a host core to the RT vcpu: Only the RT
> > VCPU is allowed to run on that CPU, while all the other non-RT
> > cores run on all the other host CPUs.
> > 
> > This approach works on machines that have a large enough number
> > of CPUs where it's possible to dedicate a whole CPU for this,
> > but we also have machines that only have 2 CPUs and doing this
> > on those is too costly.
> > 
> > This patch series makes it possible to have a RT VCPU without
> > having to dedicate a whole host core for it.
> > It does this by making it so that non-RT VCPUs can't be
> > preempted if they are in a critical section, which we
> > approximate as having interrupts disabled or non-zero
> > preempt_count. Once the VCPU is found to not be in a critical
> > section anymore, it will give up the CPU.
> > There measures to ensure that preemption isn't delayed too
> > many times.
> > 
> > (I realize that the hooks in the scheduler aren't very
> > tasteful, but I couldn't figure out a better way.
> > SVM support will be added when sending the patch for
> > inclusion.)
> > 
> > Feedback or alternatives are appreciated.
> 
> This is disguisting and completely wrecks the host scheduling. You're
> placing guest over host, that's fundamentally wrong.
> 
> NAK!
> 
> If you want co-ordinated RT scheduling, look at paravirtualized deadline
> scheduling.

Peter, not sure what exactly are you thinking of? (to solve this
particular problem with pv deadline scheduling).

Shouldnt it be possible to, through paravirt locks, boost the priority
of the non-RT vCPU (when locking fails in the -RT vCPU) ?

