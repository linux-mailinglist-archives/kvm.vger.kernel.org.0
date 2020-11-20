Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88922BA9C4
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 13:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgKTMDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 07:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727678AbgKTMDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 07:03:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50FFC0613CF;
        Fri, 20 Nov 2020 04:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xeukajkb0Dh8Aj05tLhXcYnJX0ZZcEiN+jLi0pnGRWQ=; b=eEI2XdW3SS3SvnEYkgrxIgrkkZ
        QESj0xks6qaTJAnkv/SrECagNU+vSqctcrq0xLMAWIfHAZKLk9ye2uO7gskiUylP8RbcybpWeUXL2
        uK6+gWyoCZxLIYAsj/8Cr6bDQjqDWnVAJEvPDRs9mQv3WAo/KAacUwgv54o4zvTL/2MI1ffWEmq47
        iGzPS/OuVWATcJv3FdWhjqRfpijJMY2zQfXpueb6tRHat5LxD9HkJ5lF4m33YjKhMqWD/w/svRfZq
        kIH2ZsgedGxLYnMj1h8GrezPVSEXeHN6F04tocRnYrqwZsV1M6RSBowt+3mIDzez5FevIapCnyvmm
        E0VqGnQQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kg572-0006MQ-D6; Fri, 20 Nov 2020 12:02:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EAD53305C16;
        Fri, 20 Nov 2020 13:01:54 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CD10B200DF1A6; Fri, 20 Nov 2020 13:01:54 +0100 (CET)
Date:   Fri, 20 Nov 2020 13:01:54 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        luto@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [PATCH v2 06/12] x86/paravirt: switch time pvops functions to
 use static_call()
Message-ID: <20201120120154.GE3021@hirez.programming.kicks-ass.net>
References: <20201120114630.13552-1-jgross@suse.com>
 <20201120114630.13552-7-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120114630.13552-7-jgross@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 20, 2020 at 12:46:24PM +0100, Juergen Gross wrote:
> The time pvops functions are the only ones left which might be
> used in 32-bit mode and which return a 64-bit value.
> 
> Switch them to use the static_call() mechanism instead of pvops, as
> this allows quite some simplification of the pvops implementation.
> 
> Due to include hell this requires to split out the time interfaces
> into a new header file.

There's also this patch floating around; just in case that would come in
handy:

  https://lkml.kernel.org/r/20201110005609.40989-3-frederic@kernel.org
