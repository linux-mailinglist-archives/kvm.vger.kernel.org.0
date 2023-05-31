Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5598E718EBA
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 00:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjEaWq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 18:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjEaWqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 18:46:24 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D323107;
        Wed, 31 May 2023 15:46:24 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685573181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XIzF93UFC/GVQtUvE2kmelWoKlJPXu6KUTtN32GYwuQ=;
        b=V4DPu0J+97KAWG7BljWcm9M0WHGm0oFGKQ9g9wUUxSN/LO+zWjV49iPI6Hjj/IGOqwKOzL
        OKMHt/kgS2Fj9wNQS6JZayL1xRB9qL9ZZldaosbz1V1k9FxIHU6k2qLJavO1ixGoKcogJs
        dfZ7awEDuxELHzHUTjUKYb9MF7auj7T+0Arlp4+wGURQesGYcA+i/Gav86bIj4ZeY7uZ65
        eyAMN4aSzumzjtyV2OwLrGFWz++MQrew4U7nnl19oUAf7FzSFj19Bm5tsCKpriSHbOQuyL
        a1u0FiRhzzXZbPsuEmwrEl4gDw/ygdWkCBFUo9xjAi5Hec85szOvFlw1OczFiA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685573181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XIzF93UFC/GVQtUvE2kmelWoKlJPXu6KUTtN32GYwuQ=;
        b=F+YyJiH1yOM9XIjwob6LO4nIlHL224W6az+hPOCyNCD6y/jiPsX75Y75sIr2xcGCLe3HlM
        BEwcjfldmbxSEWDg==
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
Subject: Re: [PATCH v2 08/13] x86/vdso: Fix gettimeofday masking
In-Reply-To: <87r0qwfrm0.ffs@tglx>
References: <20230519102058.581557770@infradead.org>
 <20230519102715.704767397@infradead.org> <87r0qwfrm0.ffs@tglx>
Date:   Thu, 01 Jun 2023 00:46:20 +0200
Message-ID: <87y1l4dsqr.ffs@tglx>
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

On Wed, May 31 2023 at 17:27, Thomas Gleixner wrote:
> On Fri, May 19 2023 at 12:21, Peter Zijlstra wrote:
>> to take wrapping into account, but per all the above, we don't
>> actually wrap on u64 anymore.
>
> Indeed. The rationale was that you need ~146 years uptime with a 4GHz
> TSC or ~584 years with 1GHz to actually reach the wrap around point.
>
> Though I can see your point to make sure that silly BIOSes or VMMs
> cannot cause havoc by accident or malice.
>
> Did anyone ever validate that wrap around on TSC including TSC deadline
> timer works correctly?
>
> I have faint memories of TSC_ADJUST, which I prefer not to bring back to
> main memory :)

It seems my fears have been unjustified.

At least a quick test which sets the TSC to ~ -8min @2.1Ghz the machine
seems to survive without the colourful explosions I expected due to my
early exposure to TSC_ADJUST and TSC_DEADLINE_TIMER :)

Thanks,

        tglx
