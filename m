Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13091310B18
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 13:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhBEMcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 07:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbhBEM3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 07:29:49 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797A8C06178B;
        Fri,  5 Feb 2021 04:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lxihe7+g5ZzQ+c8zVd+lEEiHfGJ0LiqT0TgJG/FT/uU=; b=BHQsyX9bmxrY1s8dN96+3jvcHN
        jN8jKHvIiPjijCXlHow152yW9qZFw8mtFS4u07GHhtnFg0V4uSJdMzFBK3NM3XfKn3lspurKdECs+
        UzhAacB4lsLVN/I62FgPYW9OsKZpkZAYZbX//QwDjJpRt/uOy5Knq6benGZcYWyk2z5wwKxbIVRW5
        rGuD0NyXLMiTuvxtznnc/ZlHFLlVVTQaU75YHPnDroYnzzAu0kDVzBB7Lclo6l1YAsxfEuQG/XCNk
        mWos7tP0bKtNHF+TSmI5n0TKIyFw1kydeW2JuoN2tTWa6o6qQlPD4i/6BU5eBqCGtNFjWfIY7U84O
        IGl7qvpg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l80EC-00043f-9L; Fri, 05 Feb 2021 12:28:48 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CB9073059DD;
        Fri,  5 Feb 2021 13:28:44 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7F5682BC43FEE; Fri,  5 Feb 2021 13:28:44 +0100 (CET)
Date:   Fri, 5 Feb 2021 13:28:44 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Zhimin Feng <fengzhimin@bytedance.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com
Subject: Re: [RFC: timer passthrough 1/9] KVM: vmx: hook set_next_event for
 getting the host tscd
Message-ID: <YB05/GIyD/UQRIGn@hirez.programming.kicks-ass.net>
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
 <20210205100317.24174-2-fengzhimin@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205100317.24174-2-fengzhimin@bytedance.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 06:03:09PM +0800, Zhimin Feng wrote:
> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index 6c9c342dd0e5..bc50f4a1a7c0 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -26,6 +26,7 @@
>   * Tick devices
>   */
>  DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
> +EXPORT_SYMBOL_GPL(tick_cpu_device);
>  /*
>   * Tick next event: keeps track of the tick time
>   */

Oh heck no. Modules have no business what so ever accessing this.
