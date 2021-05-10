Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02199378DCE
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 15:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346443AbhEJMyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 08:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343725AbhEJMOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 08:14:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D76C07E5EA;
        Mon, 10 May 2021 05:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Tlx1qmZEuB4Dgft4iU2Cydg4vhsTAOBmcNiAra7tAbo=; b=D+55aHw6TTq71o9sBnj7hnihHn
        pmeZ+ANEAJEQPdBU/eqy9MR/X0ha806fz3h7gdlQLsG7ZfFoKemx4TXqa2I9pXWH6HjazgUt47qJf
        Z4V0pWmy8dhPEx0qY+odsKKBOlj7CZjrYs23ONwJ6+yujUsBgnHsTc8b3DTMQve0L9k8YllpttLpL
        3qyyOVSGSG/OESeEfZ7oYAw5kpkMnmHjmbCVMmbVdOXoktlXBXQ1/WlE+SPOly6U0gaMNXSn/OQTf
        4CJTKPaN5IqstPcEbGAgMZzvuueBdz1MlhleLwzF718XNnRnzG+YeGkLA7KVFEaWswLskJK+dfk4O
        434VFJAQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lg4g3-0065oE-LP; Mon, 10 May 2021 12:06:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C57B23002C4;
        Mon, 10 May 2021 14:06:22 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B647F201F6C6A; Mon, 10 May 2021 14:06:22 +0200 (CEST)
Date:   Mon, 10 May 2021 14:06:22 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 7/6] delayacct: Add sysctl to enable at runtime
Message-ID: <YJkhvk1xoU6IBJ1s@hirez.programming.kicks-ass.net>
References: <20210505105940.190490250@infradead.org>
 <YJkhebGJAywaZowX@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJkhebGJAywaZowX@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 02:05:13PM +0200, Peter Zijlstra wrote:
> 
> Just like sched_schedstats, allow runtime enabling (and disabling) of
> delayacct. This is useful if one forgot to add the delayacct boot time
> option.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  Documentation/accounting/delay-accounting.rst |    6 ++--
>  kernel/delayacct.c                            |   36 ++++++++++++++++++++++++--
>  kernel/sysctl.c                               |   12 ++++++++
>  3 files changed, 50 insertions(+), 4 deletions(-)

*sigh*, the below hunk went missing..


--- a/include/linux/delayacct.h
+++ b/include/linux/delayacct.h
@@ -65,6 +65,10 @@ DECLARE_STATIC_KEY_FALSE(delayacct_key);
 extern int delayacct_on;	/* Delay accounting turned on/off */
 extern struct kmem_cache *delayacct_cache;
 extern void delayacct_init(void);
+
+extern int sysctl_delayacct(struct ctl_table *table, int write, void *buffer,
+			    size_t *lenp, loff_t *ppos);
+
 extern void __delayacct_tsk_init(struct task_struct *);
 extern void __delayacct_tsk_exit(struct task_struct *);
 extern void __delayacct_blkio_start(void);
