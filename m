Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB033D8C13
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 12:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhG1KnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 06:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbhG1KnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 06:43:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD7AC061757;
        Wed, 28 Jul 2021 03:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=7R5yjuAZV7h7ZNJYhLNiCOJ2xwQvLwhht6jWPGnFfSo=; b=VsmKDQgMENJ0yLSSSNhOjBiyZC
        grY83Qf9cm/3t0LJ02bfR5XrsLg19cA99wWxv2sv3PRJJ0+ldcism1sZKJhdB6Dp3MXuWJGE/QrJv
        PH98HFgkpNEvHfbIL0RsKlVAlFnxHdwYyiHEibYmKRU8+mrZfy/aDKHnxwt7u7DOFbjQ/La4bU+A2
        MwK0D/OF2NSzGNeugaYXLobzxQKJg8KifwEUhNGS4q38C4jFq5iuCRpQwJMY10AbujdEP7dIqrxUc
        2ghUW0vH6OdMwfYYFNUXvnQ7NTdNzW4qhZnte8H01s2peYlwCn5/EVxaWxNO3Gs72Z0szN+APTNkH
        Z9P+XBLA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8gzo-00FxRn-TQ; Wed, 28 Jul 2021 10:41:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D340A30005A;
        Wed, 28 Jul 2021 12:41:03 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 767E82C973647; Wed, 28 Jul 2021 12:41:03 +0200 (CEST)
Date:   Wed, 28 Jul 2021 12:41:03 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     mika.penttila@gmail.com
Cc:     linux-kernel@vger.kernel.org, lirongqing@baidu.com,
        pbonzini@redhat.com, mingo@redhat.com, kvm@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] is_core_idle() is using a wrong variable
Message-ID: <YQE0P9PLd3Uib7eu@hirez.programming.kicks-ass.net>
References: <20210722063946.28951-1-mika.penttila@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210722063946.28951-1-mika.penttila@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 22, 2021 at 09:39:46AM +0300, mika.penttila@gmail.com wrote:
> From: Mika Penttilä <mika.penttila@gmail.com>
> 
> is_core_idle() was using a wrong variable in the loop test. Fix it.
> 
> Signed-off-by: Mika Penttilä <mika.penttila@gmail.com>

Thanks!

---
Subject: sched/numa: Fix is_core_idle()
From: Mika Penttilä <mika.penttila@gmail.com>
Date: Thu, 22 Jul 2021 09:39:46 +0300

From: Mika Penttilä <mika.penttila@gmail.com>

Use the loop variable instead of the function argument to test the
other SMT siblings for idle.

Fixes: ff7db0bf24db ("sched/numa: Prefer using an idle CPU as a migration target instead of comparing tasks")
Signed-off-by: Mika Penttilä <mika.penttila@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210722063946.28951-1-mika.penttila@gmail.com
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1486,7 +1486,7 @@ static inline bool is_core_idle(int cpu)
 		if (cpu == sibling)
 			continue;
 
-		if (!idle_cpu(cpu))
+		if (!idle_cpu(sibling))
 			return false;
 	}
 #endif
