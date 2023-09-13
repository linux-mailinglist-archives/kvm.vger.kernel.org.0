Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E21E79F067
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 19:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjIMRaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 13:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjIMRaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 13:30:14 -0400
Received: from out-223.mta1.migadu.com (out-223.mta1.migadu.com [IPv6:2001:41d0:203:375::df])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A00FDC
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 10:30:10 -0700 (PDT)
Date:   Wed, 13 Sep 2023 17:30:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694626209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2jxXuDsdxHjvkm94f22PEQvZk32OEtTjBlaxJsBMLbI=;
        b=c6QvLNV30cJqCkCX7oLBhgkG42dkPQdepaLwLCGf4Nn1+mCXbT8eTbHs5H6L5w5rjL5rJQ
        TxE2q8GVA8+z3twT2/ZJ1iM6czH3S4wEm9kNEbu0wfzZ6aaxafm5AYIh4iMRo4oyQMkGAy
        bNyxYeZyI163al5tNrlTnsuXODecGvk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        zhukeqian1@huawei.com, jonathan.cameron@huawei.com,
        linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 0/8] KVM: arm64: Implement SW/HW combined dirty log
Message-ID: <ZQHxm+L890yTpY91@linux.dev>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On Fri, Aug 25, 2023 at 10:35:20AM +0100, Shameer Kolothum wrote:
> Hi,
> 
> This is to revive the RFC series[1], which makes use of hardware dirty
> bit modifier(DBM) feature(FEAT_HAFDBS) for dirty page tracking, sent
> out by Zhu Keqian sometime back.
> 
> One of the main drawbacks in using the hardware DBM feature for dirty
> page tracking is the additional overhead in scanning the PTEs for dirty
> pages[2]. Also there are no vCPU page faults when we set the DBM bit,
> which may result in higher convergence time during guest migration. 
> 
> This series tries to reduce these overheads by not setting the
> DBM for all the writeable pages during migration and instead uses a
> combined software(current page fault mechanism) and hardware approach
> (set DBM) for dirty page tracking.
> 
> As noted in RFC v1[1],
> "The core idea is that we do not enable hardware dirty at start (do not
> add DBM bit). When an arbitrary PT occurs fault, we execute soft tracking
> for this PT and enable hardware tracking for its *nearby* PTs (e.g. Add
> DBM bit for nearby 64PTs). Then when sync dirty log, we have known all
> PTs with hardware dirty enabled, so we do not need to scan all PTs."

I'm unconvinced of the value of such a change.

What you're proposing here is complicated and I fear not easily
maintainable. Keeping the *two* sources of dirty state seems likely to
fail (eventually) with some very unfortunate consequences.

The optimization of enabling DBM on neighboring PTEs is presumptive of
the guest access pattern and could incur unnecessary scans of the
stage-2 page table w/ a sufficiently sparse guest access pattern.

> Tests with dirty_log_perf_test with anonymous THP pages shows significant
> improvement in "dirty memory time" as expected but with a hit on
> "get dirty time" .
> 
> ./dirty_log_perf_test -b 512MB -v 96 -i 5 -m 2 -s anonymous_thp
> 
> +---------------------------+----------------+------------------+
> |                           |   6.5-rc5      | 6.5-rc5 + series |
> |                           |     (s)        |       (s)        |
> +---------------------------+----------------+------------------+
> |    dirty memory time      |    4.22        |          0.41    |
> |    get dirty log time     |    0.00047     |          3.25    |
> |    clear dirty log time   |    0.48        |          0.98    |
> +---------------------------------------------------------------+

The vCPU:memory ratio you're testing doesn't seem representative of what
a typical cloud provider would be configuring, and the dirty log
collection is going to scale linearly with the size of guest memory.

Slow dirty log collection is going to matter a lot for VM blackout,
which from experience tends to be the most sensitive period of live
migration for guest workloads.

At least in our testing, the split GET/CLEAR dirty log ioctls
dramatically improved the performance of a write-protection based ditry
tracking scheme, as the false positive rate for dirtied pages is
significantly reduced. FWIW, this is what we use for doing LM on arm64 as
opposed to the D-bit implemenation that we use on x86.
       
> In order to get some idea on actual live migration performance,
> I created a VM (96vCPUs, 1GB), ran a redis-benchmark test and
> while the test was in progress initiated live migration(local).
> 
> redis-benchmark -t set -c 900 -n 5000000 --threads 96
> 
> Average of 5 runs shows that benchmark finishes ~10% faster with
> a ~8% increase in "total time" for migration.
> 
> +---------------------------+----------------+------------------+
> |                           |   6.5-rc5      | 6.5-rc5 + series |
> |                           |     (s)        |    (s)           |
> +---------------------------+----------------+------------------+
> | [redis]5000000 requests in|    79.428      |      71.49       |
> | [info migrate]total time  |    8438        |      9097        |
> +---------------------------------------------------------------+

Faster pre-copy performance would help the benchmark complete faster,
but the goal for a live migration should be to minimize the lost
computation for the entire operation. You'd need to test with a
continuous workload rather than one with a finite amount of work.

Also, do you know what live migration scheme you're using here?

-- 
Thanks,
Oliver
