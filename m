Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632DD718EBF
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 00:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjEaWq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 18:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjEaWq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 18:46:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205449F;
        Wed, 31 May 2023 15:46:55 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685573213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=62QRYD2JYjhVXeJKvz+pkD9g/8yVOTlXBJz91bvypxw=;
        b=ZTWkydXm1wNQ5gZo7CxsTSYajGsGC0YzS9sTU6T0bztRYTaCYcG4H1U3UDnry+Xjkis7Jp
        6fOrB6YPGVEJzXsuW7GxphBGncPYvXN46XMFtnnv7mVsef7vsxag6/w3hWi4RXXQw3oCHY
        li9vZ/7OWEQYIqM66VfG0bdZxDoFxZBM1IaSB1DUD+vW13gy5Gldyow7yebpO1LCgr5mUe
        +Dqpv9jKYYpBqVbgPS9TC6KBvRnjNNCPC8zFtFkwez2l+u17rkwcVT/HcNpPOLZyv8U0W4
        sYSBQnoj9ZIY8QSSztGefOgtfRouphsL8ECMjEKeKj8XDW8VtbsqJjMsgUVPzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685573213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=62QRYD2JYjhVXeJKvz+pkD9g/8yVOTlXBJz91bvypxw=;
        b=OYdOVBuwhy9HPaq+iyeB6G5qd5KyWyZQl82e4O7qqtpxPvSA9guQpP5TjHmcz8Ah9suApN
        d3qCwR44gPP8BVCw==
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
Date:   Thu, 01 Jun 2023 00:46:52 +0200
Message-ID: <87v8g8dspv.ffs@tglx>
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
> to take wrapping into account, but per all the above, we don't
> actually wrap on u64 anymore.
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Tested-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
