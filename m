Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A396FDEF5
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 15:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbjEJNoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 09:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbjEJNoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 09:44:34 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEE8D076;
        Wed, 10 May 2023 06:43:57 -0700 (PDT)
Date:   Wed, 10 May 2023 15:43:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1683726202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NQciRSGKu3CpEpEOItv2J2B2egVEp+o8R6SOKr+6u3M=;
        b=D4jYstQQCw5CHCX1vuaurDYoezXSf7Ap0xjmBX/g+weqI3B5nWfSsWYp9FqKZBjMtYNpMu
        PGLA8wTK0wXWG9Nme5X3eLqeQij8/VaK5spqu3LPf7B/2ji7NS3GPQ/C8PWOALV1yaqdQ4
        b67fY48HtekEj8fvZa7cxMqcPhVeyGjpseFgK4ckAauZ7xsaSwIjkWl1oewhGlOx6oFb1L
        OsxwKFWTupe+SAt2ax3GuRxOKJJT0WqGq9cS3rQq2iYhaMvd9xHPHcVGkA5vS7MdqGiOwF
        WaKyD1Mp1xmJSOmp/Jmic2P4G9S7vjiXPSonfux037q5sn+31Wucu6ZbMHNizA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1683726202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NQciRSGKu3CpEpEOItv2J2B2egVEp+o8R6SOKr+6u3M=;
        b=U9Te/SCktc7jgMh7oqKS+mV9MZMk18GChWdhQTZlvutbdlrgmh8jGGv5LnpP/KvqRA38iO
        L16mlF6IXYecbeAg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mark.rutland@arm.com, maz@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, chenhuacai@kernel.org, kernel@xen0n.name,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, longman@redhat.com, boqun.feng@gmail.com,
        pmladek@suse.com, senozhatsky@chromium.org, rostedt@goodmis.org,
        john.ogness@linutronix.de, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, jstultz@google.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC][PATCH 0/9] local_clock() vs noinstr
Message-ID: <20230510134319.qzNQqC-s@linutronix.de>
References: <20230508211951.901961964@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230508211951.901961964@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-05-08 23:19:51 [+0200], Peter Zijlstra wrote:
> Hi all!
Hi Peter,

> Compile tested only on x86_64/s390/arm64 -- I've just fed it to the
Thanks, this works.

Sebastian
