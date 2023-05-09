Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7B86FC178
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 10:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbjEIIN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 04:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjEIIN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 04:13:26 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDDC19F;
        Tue,  9 May 2023 01:13:23 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1683620001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xVv4rfLO7xw6sqAWJDUtooVryD59aLxpHrjjHESoCv4=;
        b=UYr2e1+gFJj75hLTU6wulu/To8fs/3NLSTT1O/4A/dFoPk1Mwvn+4on1C/mSGDw9X/b3/G
        mIrECPfYYeTbNUw3RoQIQUfrX5mnUofAMMxQNDUqI/AFoku3cF86gPwsybPzPHVKburTU2
        zIr0TgMHNijQocNFUxjJnyzNJxEtcDTEmpbWlG997sTpM54qRhns7zh+pzonEy1oTjzFW3
        14DPxxumcT1F8fbLdgqmUfKwr1kDGuB7WZ/9BKC89wkrCBiBsaJdRO/mqxk7qcZj7+AStQ
        AZ4wyuPb6bKPM7xPxIBgHHgQsRIzp0+N70d65avjQFf8REYtlxwaUJECG0mXag==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1683620001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xVv4rfLO7xw6sqAWJDUtooVryD59aLxpHrjjHESoCv4=;
        b=9wiCNSXeePGKC5dkLze/Mvp1SnJ8hPA6OqZF+Gp+ghyrguRljiC5BokrInr2EL8X9l+0Yk
        ytnJfUjVGEIWI7CA==
To:     Peter Zijlstra <peterz@infradead.org>, bigeasy@linutronix.de
Cc:     mark.rutland@arm.com, maz@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, chenhuacai@kernel.org, kernel@xen0n.name,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jgross@suse.com,
        boris.ostrovsky@oracle.com, daniel.lezcano@linaro.org,
        kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, rafael@kernel.org, peterz@infradead.org,
        longman@redhat.com, boqun.feng@gmail.com, pmladek@suse.com,
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
In-Reply-To: <20230508213147.448097252@infradead.org>
References: <20230508211951.901961964@infradead.org>
 <20230508213147.448097252@infradead.org>
Date:   Tue, 09 May 2023 10:13:20 +0200
Message-ID: <871qjp3otb.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 08 2023 at 23:19, Peter Zijlstra wrote:
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

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
