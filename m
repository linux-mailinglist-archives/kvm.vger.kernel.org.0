Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C675A297C4
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 14:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391244AbfEXMDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 08:03:30 -0400
Received: from smtp.lucina.net ([62.176.169.44]:40170 "EHLO smtp.lucina.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390961AbfEXMDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 08:03:30 -0400
Received: from nodbug.lucina.net (78-141-76-187.dynamic.orange.sk [78.141.76.187])
        by smtp.lucina.net (Postfix) with ESMTPSA id 2A5B6122804
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 14:03:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lucina.net;
        s=dkim-201811; t=1558699408;
        bh=fFUupT0iEXqH8UsQtw78287xS4QbHQN1O6NxwwOK0aU=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=WkpJ2CM7ZrsZc4Hj5o6ao851hlWjLcoTb9WPGrQl4hsN6P+cqAPnGT9xqf7jmTXyK
         LBrYYE/CovlxZxNtPLV4tfr2/0UAAGl3100UvyT46W7UE8MQWoFDzoYwn1pjNOH56R
         z/0c5I3Jtt7/deWDQ/Dd9OORrI5VWZUaSIkRd2qLtUrdGPRnJ2+PwC5VoaD72UWbQL
         TK+C/k/ibAa20+1Dq0hvD8rOkFxlWJZL/8MavZ135nkDFDnjAUYlv/m6GCYO8EisEO
         I/uXG1m8FMuw4XyaxBJSp3/8L9uNaCBf7ps8sxjW1moOJ0D1FBBhgktnOqGCq4DdjM
         ZRtEEz+XBpepg==
Received: by nodbug.lucina.net (Postfix, from userid 1000)
        id 0C46B2684378; Fri, 24 May 2019 14:03:28 +0200 (CEST)
Date:   Fri, 24 May 2019 14:03:28 +0200
From:   Martin Lucina <martin@lucina.net>
To:     kvm@vger.kernel.org
Subject: Re: Interaction between host-side mprotect() and KVM MMU
Message-ID: <20190524120328.y2xjg64xg7mr5ymy@nodbug.lucina.net>
Mail-Followup-To: kvm@vger.kernel.org
References: <20190521072434.p4rtnbkerk5jqwh4@nodbug.lucina.net>
 <20190521140238.GA22089@linux.intel.com>
 <20190523092703.ddze6zcfsm2cj6kc@nodbug.lucina.net>
 <20190523145312.GB12078@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190523145312.GB12078@linux.intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, 23.05.2019 at 07:53, Sean Christopherson wrote:
> > > > c. In order to enforce W^X both ways I'd like to have case (2) also fail
> > > > with EFAULT, is this possible?
> > > 
> > > Not without modifying KVM and the kernel (if you want to do it through
> > > mprotect()).
> > 
> > Hooking up the full EPT protection bits available to KVM via mprotect()
> > would be the best solution for us, and could also give us the ability to
> > have execute-only pages on x86, which is a nice defence against ROP attacks
> > in the guest. However, I can see now that this is not a trivial
> > undertaking, especially across the various MMU models (tdp, softmmu) and
> > architectures dealt with by the core KVM code.
> > 
> > N.B. We also have tender implementations for bhyve and OpenBSD vmm, and at
> > least in the OpenBSD case some community contributors are looking into
> > developing an "ept_mprotect" for precisely this use-case, though their vmm
> > code is much simpler (and does less) compared to KVM.
> > 
> > I take it there's no other way to mark a range of pages as NX by the guest
> > from the host side, so if we want this without modifying KVM and the
> > kernel, the only way to get it would be to set up "real" page tables inside
> > the guest ...?
> 
> Correct, KVM does currently support marking pages NX from the host.  But
> note that when EPT is enabled, KVM does not intercept writes to CR3, i.e.
> the guest can configure and load its own page page tables to bypass the
> restrictions of the tender, which may or may not be an issue.

I'm aware of that. I've considered various options over time, including
running untrusted guest code in Ring 3, but that would require quite a bit
more work on the the loader side to provide Ring 0 infrastructure in the
guest (e.g. exception reporting), which complicates the architecture and
"supply chain".

> On the other hand, modifying KVM to support NX via mprotect() in a limited
> capacity might be a relatively low effort option, e.g. support it as a
> per-module opt-in feature only when using TDP (EPT or NPT).

That would be an interesting feature, especially if it would also enable
marking guest pages as execute-only on a TDP host. Why the opt-in? To avoid
breaking existing userspace relying on the existing mprotect() behaviour?
Do you think it could be implemented as a run-time opt-in, e.g. via a
new KVM_CAP_*?

Martin
