Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EBB37BBFB
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 13:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhELLls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 07:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhELLlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 07:41:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC1EC061574;
        Wed, 12 May 2021 04:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hfpiF6M7gD0zv0WKuJyv2m+M6IsU8UI95/eFQuGgu0c=; b=cqybAHBnHGa7VYS1KWnAIjqRbz
        gs9rJ56mJD0juvKQQXZWweMK7GN0n6rj0SLu1aRsjlkkkdKDwEpwfworFPum7WVo7R9QKUUqw+qxZ
        rOEmhftRvA3iktdWOJBViKYPdR1XwZTzDeESI/QkjkXP1et0Rad9Ye5n+NwtbwySaAFORwDpV5LYA
        FfURIykhTRfwfWtYAFrFytQfCKgpTAwyHvrDiSUcNvfMKqMI1zf7oK7syrCfdehJAqUanyhYFVRpu
        KvvkUhLdkDJuqifNGrVI39R99ndUyoUbr5DViph62fYNPujCg93A0bRf1jTSkWHCKst/SeUH1tPLc
        mU6gZTpw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lgnBh-008E6B-0N; Wed, 12 May 2021 11:38:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6905F300242;
        Wed, 12 May 2021 13:38:00 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4A14420C6A1CF; Wed, 12 May 2021 13:38:00 +0200 (CEST)
Date:   Wed, 12 May 2021 13:38:00 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mel Gorman <mgorman@suse.de>
Cc:     Balbir Singh <bsingharora@gmail.com>, tglx@linutronix.de,
        mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        pbonzini@redhat.com, maz@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        Paul Wise <pabs3@bonedaddy.net>
Subject: Re: [PATCH 0/6] sched,delayacct: Some cleanups
Message-ID: <YJu+GPHYmRf5Y/Br@hirez.programming.kicks-ass.net>
References: <20210505105940.190490250@infradead.org>
 <20210505222940.GA4236@balbir-desktop>
 <YJOzUAg30LZWSHcI@hirez.programming.kicks-ass.net>
 <20210507123810.GB4236@balbir-desktop>
 <20210512113419.GF3672@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512113419.GF3672@suse.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 12:34:19PM +0100, Mel Gorman wrote:
> > I don't disagree, we've had these around for a while and I know of users
> > that use these stats to find potential starvation. I am OK with default
> > disabled. I suspect distros will have the final say.
> > 
> 
> I think default disabled should be fine. At worst when dealing with a bug
> there would be a need to either reboot or enable at runtime with patch
> 7 included and add that instruction to the bug report when requesting
> iotop data. At worst, a distro could revert the patch if iotop generated
> too many bug reports or patch iotop in the distro package.
> 
> Alternatively, I've added Paul Wise to the cc who is the latest
> committer to iotop.  Maybe he knows who could add/commit a check for
> sysctl.sched_delayacct and if it exists then check if it's 1 and display
> an error suggesting corrective action (add delayacct to the kernel command
> line or sysctl sched.sched_delayacct=1). iotop appears to be in maintenance
> mode but gets occasional commits even if it has not had a new version
> since 2013 so maybe it could get a 0.7 tag if such a check was added.

In the final commit I made the knob be known as task_delayacct. I
figured that was a slightly better name.

But yes, a check in iotop, if that really is the sole user of all this,
would be very nice.

Thanks!
