Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6376A373929
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 13:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhEELTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 07:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbhEELTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 07:19:37 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F02C061761;
        Wed,  5 May 2021 04:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Subject:Cc:To:From:Date:Message-ID:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=0MrMsSt2tV5B1WSdY54KIILEtmSIA0/QggdrXISHTE4=; b=MZs32ecLkErof+HJRhHK+/aqxT
        ABfhxmvOpw0njH5gPfHjW2lHrGvcc3kv+mUEPPbY2F+HheZNlWu0kRIwiBoW7RwYhGmLLpRMXqRzR
        cPxxG085d3SZd00ECa/kuDGbPSWircI2xECvYqh8NtdO2aQX40TwmNjPE4H++aiIkCjlgPFqn6mPL
        mqG28eb7eJ7oxu/1aJKVZOfr/h7H1ovEZ4JJbkOtud4KAIlYwkRYKf31mRdcsKgtn7a154ZqFZc4F
        9q4ORLsAsLSqDUH8o3IaEGIpXo74LmvZrQsOyBuA41Z8ksDb+mqmCanAtSaTsStcewOYuzt046lLE
        0cYcxxCw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1leFXl-0014WF-Hv; Wed, 05 May 2021 11:18:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2B2FE300233;
        Wed,  5 May 2021 13:18:14 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id DBCEF299E9863; Wed,  5 May 2021 13:18:14 +0200 (CEST)
Message-ID: <20210505105940.190490250@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 05 May 2021 12:59:40 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterz@infradead.org, riel@surriel.com, hannes@cmpxchg.org
Subject: [PATCH 0/6] sched,delayacct: Some cleanups
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Due to:

  https://lkml.kernel.org/r/0000000000001d43ac05c0f5c6a0@google.com

and general principle, delayacct really shouldn't be using ktime (pvclock also
really shouldn't be doing what it does, but that's another story). This lead me
to looking at the SCHED_INFO, SCHEDSTATS, DELAYACCT (and PSI) accounting hell.

The rest of the patches are an attempt at simplifying all that a little. All
that crud is enabled by default for distros which is leading to a death by a
thousand cuts.

The last patch is an attempt at default disabling DELAYACCT, because I don't
think anybody actually uses that much, but what do I know, there were no ill
effects on my testbox. Perhaps we should mirror
/proc/sys/kernel/sched_schedstats and provide a delayacct sysctl for runtime
frobbing.

