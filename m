Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5749B679C4A
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 15:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbjAXOpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 09:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbjAXOpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 09:45:35 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE69F1BDB;
        Tue, 24 Jan 2023 06:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eA3jWjQCsaXuex737PYn1zrT0M5qTbaDIBSPCUlVDsw=; b=i0YMl4H0Tpp+J+qXHd3MZ+ZHEI
        hs/7dJiIdRGD0/TiQGg0NFONmko92fDUJ4AubYMGqa6gc0agQlfzopu+pWMdZnnzKxwccufwMIYrU
        ClpQiGyv6OLZGvM7WorTpI/EaX1kSWeiy/6PEw75g19P1+p2e6RSfFbOotaQ06+fX2/cgL/FtfbtZ
        aiAcxPawZOuKyHHRyVYxomM3UzUeqHVNlOnHa7540fgMhqgZs2d7+jxX3LOwTmArB7v7VySuvOcaW
        jCAUeGZxAuKc46C/X36RB0qw19xOwBay+soy3RV1jEhInSalJCtjqI1VOajgawdVUvrJNFvucjDHQ
        zMyhMRrQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pKKXO-0057eL-0Z; Tue, 24 Jan 2023 14:44:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 415DE30036B;
        Tue, 24 Jan 2023 15:44:35 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 26A232C217298; Tue, 24 Jan 2023 15:44:35 +0100 (CET)
Date:   Tue, 24 Jan 2023 15:44:35 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     mingo@kernel.org, will@kernel.org, boqun.feng@gmail.com,
        mark.rutland@arm.com, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, jgross@suse.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, mhiramat@kernel.org, wanpengli@tencent.com,
        vkuznets@redhat.com, boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 3/6] ftrace/x86: Warn and ignore graph tracing when RCU
 is disabled
Message-ID: <Y8/u00WHGElMDjoo@hirez.programming.kicks-ass.net>
References: <20230123205009.790550642@infradead.org>
 <20230123205515.059999893@infradead.org>
 <20230123165304.370121e7@gandalf.local.home>
 <20230123170753.7ac9419e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123170753.7ac9419e@gandalf.local.home>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023 at 05:07:53PM -0500, Steven Rostedt wrote:

> Actually, perhaps we can just add this, and all you need to do is create
> and set CONFIG_NO_RCU_TRACING (or some other name).

Elsewhere I've used CONFIG_ARCH_WANTS_NO_INSTR for this.

Anyway, I took it for a spin and it .... doesn't seems to do the job.

With my patch the first splat is

  "RCU not on for: cpuidle_poll_time+0x0/0x70"

While with yours I seems to get the endless:

  "WARNING: suspicious RCU usage"

thing. Let me see if I can figure out where it goes side-ways.
