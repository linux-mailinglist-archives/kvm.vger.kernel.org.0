Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D1A718652
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 17:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbjEaP2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 11:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234542AbjEaP2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 11:28:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCE8107;
        Wed, 31 May 2023 08:27:53 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685546872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J/AAE9ZGPs36fIX5clcov8ewvgNxaRXgiAw5owj43/k=;
        b=dgIZbWn0Ffwl39MVqBYxhPk2zpqPDivTmcf41Fwe6BiycAhlt0CQ23s3y9g+opc388aIX1
        KMxYZ759atp4cXI4qOTYG11J1QP7M4cOEdXucffb0LttwWfoAe0n4Wa7Zd20QcC8oOfxgj
        96/yB9GLCeaI3pr7pfguXpIhv/df5PM/paQIV4bgjljfkr3mhLev75vrgdvAzRBUk1NLEZ
        ywkKRdkJ9R7LTx37n2x1qjKWFtrMbxL4AWvlDsLppwCiClDZTRU3KXx1jbWVf908rNmO4K
        ljHAUO2sUBOI0cgVUtSNDz+PiJ6CkZvm8VEAwx773h+T43k7b9R5cW2Sg+KGmw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685546872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J/AAE9ZGPs36fIX5clcov8ewvgNxaRXgiAw5owj43/k=;
        b=siix7a116hO8Xmv/CgUCeR0LA9Ni9RJTtUSvmYgfIbz3coXXR2G04VhnPcGIBu6HbqOjaw
        b571t2+jaB3FtuDg==
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
In-Reply-To: <20230519102715.704767397@infradead.org>
References: <20230519102058.581557770@infradead.org>
 <20230519102715.704767397@infradead.org>
Date:   Wed, 31 May 2023 17:27:51 +0200
Message-ID: <87r0qwfrm0.ffs@tglx>
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

On Fri, May 19 2023 at 12:21, Peter Zijlstra wrote:
> Because of how the virtual clocks use U64_MAX as an exception value
> instead of a valid time, the clocks can no longer be assumed to wrap
> cleanly. This is then compounded by arch_vdso_cycles_ok() rejecting
> everything with the MSB/Sign-bit set.
>
> Therefore, the effective mask becomes S64_MAX, and the comment with
> vdso_calc_delta() that states the mask is U64_MAX and isn't optimized
> out is just plain silly.
>
> Now, the code has a negative filter -- to deal with TSC wobbles:
>
> 	if (cycles > last)
>
> which is just plain wrong, because it should've been written as:
>
> 	if ((s64)(cycles - last) > 0)
>
> to take wrapping into account, but per all the above, we don't
> actually wrap on u64 anymore.

Indeed. The rationale was that you need ~146 years uptime with a 4GHz
TSC or ~584 years with 1GHz to actually reach the wrap around point.

Though I can see your point to make sure that silly BIOSes or VMMs
cannot cause havoc by accident or malice.

Did anyone ever validate that wrap around on TSC including TSC deadline
timer works correctly?

I have faint memories of TSC_ADJUST, which I prefer not to bring back to
main memory :)

Thanks,

        tglx
