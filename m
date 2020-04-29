Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C491BD9DF
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 12:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgD2Kli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 06:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgD2Klh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 06:41:37 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9019C03C1AD;
        Wed, 29 Apr 2020 03:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cfotizQ8xC5IBtCKs4cl3CHlnnJmZNt4P+C0sXasjuE=; b=Tlx/gVNju8dqTTCmxLB2nDhgMv
        JkE1FRPwa+j1CImqu+peFl34S3Ug1wlNlrXajYR9TZ7vQDIqPkEMY49t3TQ5wg+qme0dIzqZdm7EV
        Jj9V6sZFJc3SQlHJO3+0/piR9wl79EZSA82FAGRf28UXIY2ZyfkFV6l8kvCI0IyEbTEf8NP1J5ZPN
        V5J49riNMPxHWaDXadak5ubnzlHLkK7o3MGu1CHL669T//ZAvIeddfJE/D+bBKOaQjdU+BEGC218J
        RRXivftAyxGtfdU8hgoxcpo38E220Aq97Jsn2kHuQZoYcOKbZ7K59fPjkcUex6srzSkA2FrVT1RRd
        u0DtzdCg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jTk9C-0002Oc-R4; Wed, 29 Apr 2020 10:40:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 41FBB3011E8;
        Wed, 29 Apr 2020 12:40:57 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2790A2038BC5C; Wed, 29 Apr 2020 12:40:57 +0200 (CEST)
Date:   Wed, 29 Apr 2020 12:40:57 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 5/6] KVM: x86: announce KVM_FEATURE_ASYNC_PF_INT
Message-ID: <20200429104057.GL13592@hirez.programming.kicks-ass.net>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-6-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429093634.1514902-6-vkuznets@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 29, 2020 at 11:36:33AM +0200, Vitaly Kuznetsov wrote:
> Introduce new capability to indicate that KVM supports interrupt based
> delivery of type 2 APF events (page ready notifications). This includes
> support for both MSR_KVM_ASYNC_PF2 and MSR_KVM_ASYNC_PF_ACK.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  Documentation/virt/kvm/cpuid.rst     | 6 ++++++
>  arch/x86/include/uapi/asm/kvm_para.h | 1 +
>  arch/x86/kvm/cpuid.c                 | 3 ++-
>  arch/x86/kvm/x86.c                   | 1 +
>  include/uapi/linux/kvm.h             | 1 +
>  5 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index 01b081f6e7ea..5383d68e3217 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -86,6 +86,12 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
>                                                before using paravirtualized
>                                                sched yield.
>  
> +KVM_FEATURE_PV_SCHED_YIELD        14          guest checks this feature bit

Copy/paste fail

> +                                              before using the second async
> +                                              pf control msr 0x4b564d06 and
> +                                              async pf acknowledgment msr
> +                                              0x4b564d07.
> +
