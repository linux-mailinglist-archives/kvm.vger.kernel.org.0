Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810FE36D43A
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 10:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbhD1Isn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 04:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237552AbhD1Isl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 04:48:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68E9C061574;
        Wed, 28 Apr 2021 01:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kfPSQurt6Bc5u58DqRYZKABmqX9iTn1lw4a/TJR3JbA=; b=SSirg/LuehTe26W+39fkeZ5BFj
        sV2rVItwkO092ybCX0GnQhdT39OdTIyzQGeKnfgFpdlAcwQ/oJsJ1Jhcfd89qJMkl7k0Oxjq07XnG
        MOgMBnxBIolWP+T49UWyn76C32aaCeB1BB3FkWeiwewInYJywjEM7+R26QAPTzv5eAgYp9ifnifQz
        0d1+1a1QogoINM8sJfmWcearn7cwHkdx/wGfUOi2FIXoOAEIPQXNaHt+LeVoJNh1bbWmVizOpwd7d
        JHHfuVSVXOyjSTotGN2i05dAq6dmBJJVhkUXttuT2v1bTAia//7uRctaOphcgVQ+xFIu1fd7QJeU5
        DFddzqMg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lbfpf-0083bX-1Q; Wed, 28 Apr 2021 08:46:16 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8448830003A;
        Wed, 28 Apr 2021 10:46:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5B2102BF7B844; Wed, 28 Apr 2021 10:46:05 +0200 (CEST)
Date:   Wed, 28 Apr 2021 10:46:05 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     bristot@redhat.com, bsegall@google.com, dietmar.eggemann@arm.com,
        greg@kroah.com, gregkh@linuxfoundation.org, joshdon@google.com,
        juri.lelli@redhat.com, linux-kernel@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        rostedt@goodmis.org, valentin.schneider@arm.com,
        vincent.guittot@linaro.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: sched: Move SCHED_DEBUG sysctl to debugfs
Message-ID: <YIkgzUWEPaXQTCOv@hirez.programming.kicks-ass.net>
References: <20210412102001.287610138@infradead.org>
 <20210427145925.5246-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427145925.5246-1-borntraeger@de.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 04:59:25PM +0200, Christian Borntraeger wrote:
> Peter,
> 
> I just realized that we moved away sysctl tunabled to debugfs in next.
> We have seen several cases where it was benefitial to set
> sched_migration_cost_ns to a lower value. For example with KVM I can
> easily get 50% more transactions with 50000 instead of 500000. 
> Until now it was possible to use tuned or /etc/sysctl.conf to set
> these things permanently. 
> 
> Given that some people do not want to have debugfs mounted all the time
> I would consider this a regression. The sysctl tunable was always 
> available.
> 
> I am ok with the "informational" things being in debugfs, but not
> the tunables. So how do we proceed here?

It's all SCHED_DEBUG; IOW you're relying on DEBUG infrastructure for
production performance, and that's your fail.

I very explicitly do not care to support people that poke random values
into those 'tunables'. If people wants to do that, they get to keep any
and all pieces.

The right thing to do here is to analyze the situation and determine why
migration_cost needs changing; is that an architectural thing, does s390
benefit from less sticky tasks due to its cache setup (the book caches
could be absorbing some of the penalties here for example). Or is it
something that's workload related, does KVM intrinsically not care about
migrating so much, or is it something else.

Basically, you get to figure out what the actual performance issue is,
and then we can look at what to do about it so that everyone benefits,
and not grow some random tweaks on the interweb that might or might not
actually work for someone else.
