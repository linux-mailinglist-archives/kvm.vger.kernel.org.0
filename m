Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEBCF1118
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 09:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731405AbfKFIco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 03:32:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47612 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729951AbfKFIcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 03:32:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JQcWfG3124w8lNoztrGuavAOXYtN6kCwqs+HotAy+So=; b=EgpPWSF8eMk3N3qqPjbk4Jt+E
        SxjSom1p1GGu+dLQgS/BgYBczHGQ+p511sCdvLqyGafRJJ3MewDobDhoOoP/iu/f1hupBJn7Viylt
        5SmKD5yKloD2DnB0SRnD1QD9956xOIjtGzztvF54GV9+JigeAgpM0y8s0OwQyQiWbPhB8a0jNbOul
        H1wTz4VDTNU2OdiWY9t/KRa04hsmhYy/8wc3kzg/MXvQ5tQxZNhYm8Jxw5fD1pY0Zx+YrsEhdroIC
        3OMA9Apo5UMREI2WNL8wVJjWkxr16RFRMQL8kMSC6JL4fE5HHvO5ud0e1R6nd9vhad47eakOmeV2E
        0Ht94iGTA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSGjg-0004RW-JA; Wed, 06 Nov 2019 08:32:16 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C9090301747;
        Wed,  6 Nov 2019 09:31:08 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C85132020D8FD; Wed,  6 Nov 2019 09:32:12 +0100 (CET)
Date:   Wed, 6 Nov 2019 09:32:12 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
Message-ID: <20191106083212.GO4131@hirez.programming.kicks-ass.net>
References: <20191105161737.21395-1-vkuznets@redhat.com>
 <20191105200218.GF3079@worktop.programming.kicks-ass.net>
 <51c9fe0c-0bda-978c-27f7-85fe7e59e91d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51c9fe0c-0bda-978c-27f7-85fe7e59e91d@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 12:51:30AM +0100, Paolo Bonzini wrote:
> On 05/11/19 21:02, Peter Zijlstra wrote:
> > On Tue, Nov 05, 2019 at 05:17:37PM +0100, Vitaly Kuznetsov wrote:
> >> Virtualized guests may pick a different strategy to mitigate hardware
> >> vulnerabilities when it comes to hyper-threading: disable SMT completely,
> >> use core scheduling, or, for example, opt in for STIBP. Making the
> >> decision, however, requires an extra bit of information which is currently
> >> missing: does the topology the guest see match hardware or if it is 'fake'
> >> and two vCPUs which look like different cores from guest's perspective can
> >> actually be scheduled on the same physical core. Disabling SMT or doing
> >> core scheduling only makes sense when the topology is trustworthy.
> >>
> >> Add two feature bits to KVM: KVM_FEATURE_TRUSTWORTHY_SMT with the meaning
> >> that KVM_HINTS_TRUSTWORTHY_SMT bit answers the question if the exposed SMT
> >> topology is actually trustworthy. It would, of course, be possible to get
> >> away with a single bit (e.g. 'KVM_FEATURE_FAKE_SMT') and not lose backwards
> >> compatibility but the current approach looks more straightforward.
> > 
> > The only way virt topology can make any sense what so ever is if the
> > vcpus are pinned to physical CPUs.
> 
> This is a subset of the requirements for "trustworthy" SMT.  You can have:
> 
> - vCPUs pinned to two threads in the same core and exposed as multiple
> cores in the guest

Why the .... would one do anything like that?

> - vCPUs from different guests pinned to two threads in the same core
> 
> and that would be okay as far as KVM_HINTS_REALTIME is concerned, but
> would still allow exploitation of side-channels, respectively within the
> VM and between VMs.

Hardly, RT really rather would not have SMT. SMT is pretty crap for
determinism.
