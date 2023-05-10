Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC196FD8C7
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 09:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236385AbjEJH7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 03:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbjEJH64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 03:58:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F87DDE;
        Wed, 10 May 2023 00:58:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1EBAC1F388;
        Wed, 10 May 2023 07:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683705534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T06RMDj39gQfDe4f9XSCb72BIGFfA58STfsWWVeFeM4=;
        b=ak3e9SQEJZT4WXcnpGYykh1nJYqRLsEh+4hNqfrnDxepqVa/CR2FQtu93O78KfbpHPEmhp
        TUmRaEakKEBTGTfvnfrB9vK51JPWEmivQzLwhcleN93l74RD53mmo4HPSr3BolZqlwtrid
        pvDMEVTJxq2JgsHk5NcaoaDGgPCjhiw=
Received: from suse.cz (dhcp129.suse.cz [10.100.51.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BEA4F2C141;
        Wed, 10 May 2023 07:58:51 +0000 (UTC)
Date:   Wed, 10 May 2023 09:58:51 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     bigeasy@linutronix.de, mark.rutland@arm.com, maz@kernel.org,
        catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
        kernel@xen0n.name, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, longman@redhat.com, boqun.feng@gmail.com,
        senozhatsky@chromium.org, rostedt@goodmis.org,
        john.ogness@linutronix.de, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, jstultz@google.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC][PATCH 1/9] seqlock/latch: Provide
 raw_read_seqcount_latch_retry()
Message-ID: <ZFtOu5dypMeWW9ax@alley>
References: <20230508211951.901961964@infradead.org>
 <20230508213147.448097252@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508213147.448097252@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon 2023-05-08 23:19:52, Peter Zijlstra wrote:
> The read side of seqcount_latch consists of:
> 
>   do {
>     seq = raw_read_seqcount_latch(&latch->seq);
>     ...
>   } while (read_seqcount_latch_retry(&latch->seq, seq));
> 
> which is asymmetric in the raw_ department, and sure enough,
> read_seqcount_latch_retry() includes (explicit) instrumentation where
> raw_read_seqcount_latch() does not.
> 
> This inconsistency becomes a problem when trying to use it from
> noinstr code. As such, fix it by renaming and re-implementing
> raw_read_seqcount_latch_retry() without the instrumentation.
> 
> Specifically the instrumentation in question is kcsan_atomic_next(0)
> in do___read_seqcount_retry(). Loosing this annotation is not a
> problem because raw_read_seqcount_latch() does not pass through
> kcsan_atomic_next(KCSAN_SEQLOCK_REGION_MAX).
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Makes sense:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
