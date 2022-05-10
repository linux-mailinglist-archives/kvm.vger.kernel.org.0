Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223295221D1
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 18:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346891AbiEJQ7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 12:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbiEJQ7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 12:59:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CABE27E3E6;
        Tue, 10 May 2022 09:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qChzNactocCEZRqMf2gnDNoVYP3f9TniXLt5wRF3A5Q=; b=JpKf5kA1OrSjASCjykVhJhnoup
        z6QHOCgOPKn+Lk/lN0dJXLk0sGxFb9ItCORf0OnLglLfM9RNFrQqBSW+FQfgvC1p43UXmJsrQBmjD
        ejXsiV47eCVyVERVxDgjni0lLqNZInRD+G9QYVsDq9KjTpU2Uq2/Wi3IkjHVMQykmevYzML6Ty3Ij
        Enrsv1XwKy+tXEK8KkJ46v8vsOeeUNWPuIxbMP6uAb1ISV9pqCQnpK5amiDJJClzPG2pikHVzfEim
        exb9hkcc5KOqT1M8koF9e4Fn7ZUWkMSaD4MKQt2k4XbYfEathUSewU3ZaKvkBeRQzz9DI/RaYqfPd
        Gj72tyQw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noT8e-004dtT-Bl; Tue, 10 May 2022 16:55:08 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 46A7598100A; Tue, 10 May 2022 18:55:06 +0200 (CEST)
Date:   Tue, 10 May 2022 18:55:06 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marco Elver <elver@google.com>
Subject: Re: [PATCH] locking/atomic/x86: Introduce try_cmpxchg64
Message-ID: <20220510165506.GP76023@worktop.programming.kicks-ass.net>
References: <20220510154217.5216-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510154217.5216-1-ubizjak@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 05:42:17PM +0200, Uros Bizjak wrote:
> This patch adds try_cmpxchg64 to improve code around cmpxchg8b.  While
> the resulting code improvements on x86_64 are minor (a compare and a move saved),
> the improvements on x86_32 are quite noticeable. The code improves from:

What user of cmpxchg64 is this?

