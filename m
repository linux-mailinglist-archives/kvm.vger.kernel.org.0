Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7692F75FD
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 10:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbhAOJzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 04:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbhAOJzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 04:55:36 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171D5C0613C1;
        Fri, 15 Jan 2021 01:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+qwvdXSYgyEgRau9DmchwE0hXYTfWp9M4Nhh0Zzmg14=; b=uxPgEfQTkCbUJaxvMEGGxbso3B
        /94EZ2jymszYzZKI4cVZdAYLzWYdSvul69hngM7JSgZl5rfErciPYks19aNv90ML6TJW/6bwx3P3f
        iQ2Qcq4qsvE1BGgOQSXKWOABcLs2xWkdMV6JhVT9VyhoKfT869i/+VrIpE+zjdUDL281saU52Ho5L
        JA3EvW1Z48s1ECMzkFYuYdNGthkW9lfUxsmAew+xcyRfDJ3XVooTa5IuWHkNjxLNZ/KAd/rEwpYaW
        04/H02g69aheYnemQjGrZYMkxJx+edF3xzxFV9fzdVFNXT4cmX3dWjq7kRNGAn6oFGp4X9vIgICp5
        7uJTLnVA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l0Log-0007UG-4p; Fri, 15 Jan 2021 09:54:50 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CB7D730377D;
        Fri, 15 Jan 2021 10:54:48 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BC3DD2C01E6E3; Fri, 15 Jan 2021 10:54:48 +0100 (CET)
Date:   Fri, 15 Jan 2021 10:54:48 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jason Baron <jbaron@akamai.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 3/3] KVM: x86: use static calls to reduce kvm_x86_ops
 overhead
Message-ID: <YAFmaMhROa9obFQv@hirez.programming.kicks-ass.net>
References: <cover.1610680941.git.jbaron@akamai.com>
 <e057bf1b8a7ad15652df6eeba3f907ae758d3399.1610680941.git.jbaron@akamai.com>
 <YAFkTSnSut1h/jWt@hirez.programming.kicks-ass.net>
 <YAFmLzVnVzzUit4T@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAFmLzVnVzzUit4T@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021 at 10:53:51AM +0100, Peter Zijlstra wrote:
> @@ -190,6 +191,7 @@ extern int static_call_text_reserved(voi
>  #elif defined(CONFIG_HAVE_STATIC_CALL)
>  
>  static inline long __static_call_return0(void) { return 0; }
> +static inline long __static_call_return0(void) { return 1; }
>  
>  static inline int static_call_init(void) { return 0; }
>  
> @@ -239,6 +241,7 @@ static inline int static_call_text_reser
>  #else /* Generic implementation */
>  
>  static inline long __static_call_return0(void) { return 0; }
> +static inline long __static_call_return0(void) { return 1; }

Too much copy-fail... Lemme go make more tea :-)
