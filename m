Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF8EDF111A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 09:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731477AbfKFIcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 03:32:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47640 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730271AbfKFIcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 03:32:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GGL1v+c1ltlTqawzPHu/3IiNRPhlH8S8qHZKrdhagc8=; b=Fmf5NiRHFmpiEsnYT7W3L8dUB
        fjHSATuLCvcX3stZRtGuJ76Q1zhXzKbASr1NDuJlt467yL8PbFD6g9idJs9v3rt5+SuKCMIb8zHhN
        dNqa1k5wKfWZgXAaGDF4wIK7xRuzSb8kIVrQ3ai4oXxaJVMYYvBHsz01Kek6tGoUhE1RJFoLDq8jn
        VG0yNPUV33BDNvP879ae8Zmw4XIwiQ+5s+C1Qucd6jVbuE17FXTJYSSIpzhIeTeS+yEiu98kTJsu3
        9rJWADESIAsRwirz4FWOkElJZMOT41aq3zDr6qGq9dxc9+onGHhkI3JG02Bli1ZesnNis/QljDPzH
        YLNhACftw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSGk1-0004S3-B7; Wed, 06 Nov 2019 08:32:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B456C303DDD;
        Wed,  6 Nov 2019 09:31:31 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BAD032020D8FD; Wed,  6 Nov 2019 09:32:35 +0100 (CET)
Date:   Wed, 6 Nov 2019 09:32:35 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
Message-ID: <20191106083235.GP4131@hirez.programming.kicks-ass.net>
References: <20191105161737.21395-1-vkuznets@redhat.com>
 <20191105200218.GF3079@worktop.programming.kicks-ass.net>
 <20191105232528.GF23297@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105232528.GF23297@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 05, 2019 at 03:25:28PM -0800, Sean Christopherson wrote:
> On Tue, Nov 05, 2019 at 09:02:18PM +0100, Peter Zijlstra wrote:
> > On Tue, Nov 05, 2019 at 05:17:37PM +0100, Vitaly Kuznetsov wrote:
> > > Virtualized guests may pick a different strategy to mitigate hardware
> > > vulnerabilities when it comes to hyper-threading: disable SMT completely,
> > > use core scheduling, or, for example, opt in for STIBP. Making the
> > > decision, however, requires an extra bit of information which is currently
> > > missing: does the topology the guest see match hardware or if it is 'fake'
> > > and two vCPUs which look like different cores from guest's perspective can
> > > actually be scheduled on the same physical core. Disabling SMT or doing
> > > core scheduling only makes sense when the topology is trustworthy.
> > > 
> > > Add two feature bits to KVM: KVM_FEATURE_TRUSTWORTHY_SMT with the meaning
> > > that KVM_HINTS_TRUSTWORTHY_SMT bit answers the question if the exposed SMT
> > > topology is actually trustworthy. It would, of course, be possible to get
> > > away with a single bit (e.g. 'KVM_FEATURE_FAKE_SMT') and not lose backwards
> > > compatibility but the current approach looks more straightforward.
> > 
> > The only way virt topology can make any sense what so ever is if the
> > vcpus are pinned to physical CPUs.
> >
> > And I was under the impression we already had a bit for that (isn't it
> > used to disable paravirt spinlocks and the like?). But I cannot seem to
> > find it in a hurry.
> 
> Yep, KVM_HINTS_REALTIME does what you describe.

*sigh*, that's a pretty shit name for it :/
