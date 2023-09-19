Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A32C7A5D59
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 11:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjISJFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 05:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjISJFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 05:05:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A63114;
        Tue, 19 Sep 2023 02:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9Um9xivfZIzOpGAbhiiXrCDCVB724N5qIHjbsLgt4Ac=; b=iZvMDqxgfVG849kaE5gtwfVFMM
        YNYWJLuio+/Rs8inIPe/YyI7Rr6GVuUwmlpiqnStl1uQDFzxqdmU2p6+HsopumMBvl/UZYqGzDhoC
        EQJIEePHbzuHZKCM0DIT/5+E8x8UD6OhQxJRy4A0O77fQ+ej6MIEHr3Q2jSg/WjpDWqdlhG6J/aqq
        q+w8YLveHwMZF8wwmkMRp2cOLKzd8et2daNDzFZT1U9AxOAVfwh+lUE6hsHfdue0cbkfDuPOTc9NE
        1K6YV47tOLe+BdI2tVe0FFQPK/l+GXJqi7PRKo2sqe32njJAfdrpA7lx1hbcpxaJldo0Y5ONJlkNm
        sIQVfavQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qiWf1-00GKUe-4M; Tue, 19 Sep 2023 09:04:47 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id C60CF30042E; Tue, 19 Sep 2023 11:04:46 +0200 (CEST)
Date:   Tue, 19 Sep 2023 11:04:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexander Graf <graf@amazon.de>
Cc:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenz@amazon.es>,
        "Griffoul, Fred" <fgriffo@amazon.com>
Subject: Re: [RFC] KVM: x86: Allow userspace exit on HLT and MWAIT, else
 yield on MWAIT
Message-ID: <20230919090446.GC21729@noisy.programming.kicks-ass.net>
References: <1b52b557beb6606007f7ec5672eab0adf1606a34.camel@infradead.org>
 <63b382bf-d1fb-464f-ab06-4185f796a85f@amazon.de>
 <b3c1a64daa6d265b295aedd6176daa8ab95e273f.camel@infradead.org>
 <db756c13-eee5-414a-a28d-2ce08e7b77d9@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db756c13-eee5-414a-a28d-2ce08e7b77d9@amazon.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 01:59:50PM +0200, Alexander Graf wrote:
> The problem with MWAIT is that you don't really know when it's done.

This isn't really a problem. MWAIT is allowed (expected even) to return
early.

REP;NOP is a valid implementation of MWAIT.

MWAIT must not delay waking (much) after either:

 - write to monitored address
 - interrupt pending

But it doesn't say anything about not waking up sooner.

Now, obviously on real hardware you prefer if MWAIT were to also do the
whole C-state thing and safe your some actual power, but this is virt,
real hardware is not a concern and wakeup-timeliness also not much.


IIRC the ARM64 WFE thing has a 10khz timer or something it wakes from if
nothing else. So I suppose what I'm saying is that: nanosleep(100000)
might be a suitable MWAIT implementation.

It's virt, it sucks anyway :-)
