Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E193759FF0
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 22:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjGSUhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 16:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjGSUhQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 16:37:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E701734;
        Wed, 19 Jul 2023 13:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ct4x5skzs8PALPBz8qK2ftN+HGVLNPB6AD5V5+AkyPY=; b=E76vkvNezGst4usz/FoC67Y/mF
        Hz/T5KV5GXFZzTizzlUf5x0Isr9Aus4wrC9yP/x131xgzlCj7k9TUiTHLj4XWDOsSKKBWKJdaWJva
        6hsVg5P2ko5ub7M3j2d5+36+FBCHZKc9wYSGhT8tKF7msGf/nLTj+EvGX6Db26CRnGeZGIzEWL5W8
        DWlLsz79KeRQOxAqsDuqnqWlSgKGUl5eC499RVxCrUlPtFGN58i2NkAjG3dkpUwhv6gx/0ofErnfH
        gA8nt3DAiupyGI6SbCG+GwTLo0szhgwd/VGq0OabuN8Ste94x26acNPKhCAWAI6cNUiQICRnBvzvo
        FmcBfIiA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qMDuu-006Rr1-CA; Wed, 19 Jul 2023 20:37:01 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 228C830049E;
        Wed, 19 Jul 2023 22:36:59 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0D2E326AA535C; Wed, 19 Jul 2023 22:36:59 +0200 (CEST)
Date:   Wed, 19 Jul 2023 22:36:58 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Weijiang Yang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
        binbin.wu@linux.intel.com, rick.p.edgecombe@intel.com,
        john.allen@amd.com, Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
Message-ID: <20230719203658.GE3529734@hirez.programming.kicks-ass.net>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com>
 <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com>
 <c438b5b1-b34d-3e77-d374-37053f4c14fa@intel.com>
 <ZJYF7haMNRCbtLIh@google.com>
 <e44a9a1a-0826-dfa7-4bd9-a11e5790d162@intel.com>
 <ZLg8ezG/XrZH+KGD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLg8ezG/XrZH+KGD@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 12:41:47PM -0700, Sean Christopherson wrote:

> My understanding is that PL[0-2]_SSP are used only on transitions to the
> corresponding privilege level from a *different* privilege level.  That means
> KVM should be able to utilize the user_return_msr framework to load the host
> values.  Though if Linux ever supports SSS, I'm guessing the core kernel will
> have some sort of mechanism to defer loading MSR_IA32_PL0_SSP until an exit to
> userspace, e.g. to avoid having to write PL0_SSP, which will presumably be
> per-task, on every context switch.
> 
> But note my original wording: **If that's necessary**
> 
> If nothing in the host ever consumes those MSRs, i.e. if SSS is NOT enabled in
> IA32_S_CET, then running host stuff with guest values should be ok.  KVM only
> needs to guarantee that it doesn't leak values between guests.  But that should
> Just Work, e.g. KVM should load the new vCPU's values if SHSTK is exposed to the
> guest, and intercept (to inject #GP) if SHSTK is not exposed to the guest.
> 
> And regardless of what the mechanism ends up managing SSP MSRs, it should only
> ever touch PL0_SSP, because Linux never runs anything at CPL1 or CPL2, i.e. will
> never consume PL{1,2}_SSP.

To clarify, Linux will only use SSS in FRED mode -- FRED removes CPL1,2.
