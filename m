Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B2C7B5C57
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 23:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjJBVGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 17:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjJBVGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 17:06:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029538E;
        Mon,  2 Oct 2023 14:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HT4Of1+X1yKj/8pLirh9ddEXBkDEXoVnZ8KqD5D1+QI=; b=qojeZTPLl+3aOQCYq8Fi0QEyxv
        6riOdedQrghS+/Py2Tm5OJesgiGLZ0r8pr5Fm0u3qgXyM3kB+toQDLrUJl8aopKtyspxV2pJlZssh
        58yhsA8lqfOeiDHkItF62zY2skio0683QENT1J9s/L8C0KNzYRl3ANFTSEG5ilvGp8nYXCN9jZ+ZE
        xH05Lun90yRCv3rTKdVg7QdiWr8WxxCdQeKyE6E0Sh8FMXXDtUMQjFpBIo89tOBgmaMtw+L3dT2f1
        GaSdRhK54L5sEy3Gj2uFkV6qqOrR1XWGYd6V0j2PYO1gktazKVgjBZt59srtHyg56tmHR9w2gUrfV
        voEO6ohw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qnQ7D-00BAdw-ER; Mon, 02 Oct 2023 21:06:07 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1FED9300454; Mon,  2 Oct 2023 23:06:07 +0200 (CEST)
Date:   Mon, 2 Oct 2023 23:06:07 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
Message-ID: <20231002210607.GD27267@noisy.programming.kicks-ass.net>
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com>
 <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com>
 <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com>
 <a8479764-34a1-334f-3865-c01325d772d9@oracle.com>
 <ZRsJiuKdXtWos_Xh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRsJiuKdXtWos_Xh@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023 at 11:18:50AM -0700, Sean Christopherson wrote:
> +PeterZ
> 
> Thomas and Peter,
> 
> We're trying to address an issue where KVM's paravirt kvmclock drifts from the
> host's TSC-based monotonic raw clock because of historical reasons (at least, AFAICT),
> even when the TSC is constant.  Due to some dubious KVM behavior, KVM may sometimes
> re-sync kvmclock against the host's monotonic raw clock, which causes non-trivial
> jumps in time from the guest's perspective.
> 
> Linux-as-a-guest demotes all paravirt clock sources when the TSC is constant and
> nonstop, and so the goofy KVM behavior isn't likely to affect the guest's clocksource,
> but the guest's sched_clock() implementation keeps using the paravirt clock.
> 
> Irrespective of if/how we fix the KVM host-side mess, using a paravirt clock for
> the scheduler when using a constant, nonstop TSC for the clocksource seems at best
> inefficient, and at worst unnecessarily complex and risky.
> 
> Is there any reason not to prefer native_sched_clock() over whatever paravirt
> clock is present when the TSC is the preferred clocksource? 

I see none, that whole pv_clock thing is horrible crap.

> Assuming the desirable
> thing to do is to use native_sched_clock() in this scenario, do we need a separate
> rating system, or can we simply tie the sched clock selection to the clocksource
> selection, e.g. override the paravirt stuff if the TSC clock has higher priority
> and is chosen?

Yeah, I see no point of another rating system. Just force the thing back
to native (or don't set it to that other thing).
