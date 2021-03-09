Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA30332009
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 08:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhCIHrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 02:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhCIHrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 02:47:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D0DC06174A;
        Mon,  8 Mar 2021 23:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RPwvJ0Jon3MBhA2x2dbU/aIzqjciZdMt7fGLLK+Bmg4=; b=X30w+6Wvc01lmwIjNzZTrvnThG
        lripCyh+tEcuH81V/Xfz5k3pAOZlnGor/U2AYHEmn1ugWPWTZZ9qbPhDmlvpoW6rxXKApgLEMUxjB
        QOj05UyBosnZD9f8HlsT3VsIYJrpT1A2F7Y2eQtXqqO1bJLZ77zD8cZMBbAACTUpCDj2fiZUdtTsU
        d0VloWCdSROPAJF5sMBjFlV+5H7/cWPppShULjG7GQ5fqX+HywxcCfLegZIEWIBpZCWICT/2VW6Jz
        BHPizM5tXbdkbcXBbgi+rC6gMY0vYPxZyF7OPR1nEhK6t54Lf6BZyKfmtNkPR4dLKetKXMxzJpUSO
        sjUwRDlA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lJX4s-000CUQ-Jk; Tue, 09 Mar 2021 07:46:52 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B7AE33010CF;
        Tue,  9 Mar 2021 08:46:49 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9BF992D3E9B35; Tue,  9 Mar 2021 08:46:49 +0100 (CET)
Date:   Tue, 9 Mar 2021 08:46:49 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Xu, Like" <like.xu@intel.com>, Dmitry Vyukov <dvyukov@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        "Thomas Gleixner
        (x86/pti/timer/core/smp/irq/perf/efi/locking/ras/objtool)
        (x86@kernel.org)" <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86/perf: Fix guest_get_msrs static call if there is no
 PMU
Message-ID: <YEcn6bGYxdgrp0Ik@hirez.programming.kicks-ass.net>
References: <20210305223331.4173565-1-seanjc@google.com>
 <053d0a22-394d-90d0-8d3b-3cd37ca3f378@intel.com>
 <YEXmILSHDNDuMk/N@hirez.programming.kicks-ass.net>
 <YEaLzKWd0wAmdqvs@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEaLzKWd0wAmdqvs@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 12:40:44PM -0800, Sean Christopherson wrote:
> On Mon, Mar 08, 2021, Peter Zijlstra wrote:

> > Given the one user in atomic_switch_perf_msrs() that should work because
> > it doesn't seem to care about nr_msrs when !msrs.
> 
> Uh, that commit quite cleary says:

D0h! I got static_call_cond() and __static_call_return0 mixed up.
Anyway, let me see if I can make something work here.
