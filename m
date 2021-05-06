Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8FE3754D7
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 15:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhEFNiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 09:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbhEFNh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 09:37:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A47C061761;
        Thu,  6 May 2021 06:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cZKl1g221hvgsUM4ruH5PC7LZQBfPUMAAeP8YaPjGAU=; b=iCvBIdp7CfSO/0BJGcxbWozcPf
        t5+tSFPC4ck12ybfCEVvVxo8U9LY1fxOS9JBCsesLSJjScpvyFriKQ5I121sTTU1wduIRAToqxDWQ
        GUihxZ+vvPpjjBG0m720St9/4O5srJjJswCAjDCQDB2hZTwbdav9kAZIHPV6njAwGAGhzH6xRvEqz
        Cwd2WqijKlvf7k5hA1Ys4CSZ4t3jNrVLPEMozQv6gelS2+1Bzb6NL82XwqXWmUaLKKA+giVqeDHYN
        e9oTf6PG6n/UTia4wqFcyPO9x27cCS8wnVcM6LiKUFR8vSJDzU8TZk0je2A9cZctcj2GA0skSqibN
        MTKubsqA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lee9l-001lUf-GN; Thu, 06 May 2021 13:35:26 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 031A93001DB;
        Thu,  6 May 2021 15:35:07 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D2CEC202641BA; Thu,  6 May 2021 15:35:07 +0200 (CEST)
Date:   Thu, 6 May 2021 15:35:07 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: KVM: x86: Prevent deadlock against tk_core.seq
Message-ID: <YJPwi0FSObIjOSd7@hirez.programming.kicks-ass.net>
References: <87h7jgm1zy.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7jgm1zy.ffs@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021 at 03:21:37PM +0200, Thomas Gleixner wrote:
> syzbot reported a possible deadlock in pvclock_gtod_notify():
> 
> CPU 0  		  	   	    	    CPU 1
> write_seqcount_begin(&tk_core.seq);
>   pvclock_gtod_notify()			    spin_lock(&pool->lock);
>     queue_work(..., &pvclock_gtod_work)	    ktime_get()
>      spin_lock(&pool->lock);		      do {
>      						seq = read_seqcount_begin(tk_core.seq)
> 						...
> 				              } while (read_seqcount_retry(&tk_core.seq, seq);
> 
> While this is unlikely to happen, it's possible.
> 
> Delegate queue_work() to irq_work() which postpones it until the
> tk_core.seq write held region is left and interrupts are reenabled.
> 
> Fixes: 16e8d74d2da9 ("KVM: x86: notifier for clocksource changes")
> Reported-by: syzbot+6beae4000559d41d80f8@syzkaller.appspotmail.com
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
