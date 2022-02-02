Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3235E4A7AE7
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 23:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbiBBWRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 17:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiBBWRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 17:17:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEFEC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 14:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+pkvZnNWG+B0REGMbQAvuaYqPTm23+pLJ70W3Duo4q0=; b=kuyNLwhbYUUHghRRdKJcDKPmPI
        O0307Q0iT/z3hR4Xj6CMmMVcIRXehD7yFU/Dmqpwvqeioj+zqZp2lLTydc9kgV8y/7BmFQcyVk1mf
        xY7vVH/EJcH8bWA/+asbADSWUe1zGODslMFqWRZZfXShlSIA+SDkUH3C3FChPbPLcDIje52c1VrJd
        8rdbw1wUeQ+v951uXKgy8nu8M7l8AHwXCqyq3jQ9ZoKkZ5anrsjgouENl1CC8F99CrRb768vO9pHY
        xkLNWnofHZsPzsp6Za8A3T1Zx5ZU+YvUUD+3B0GjTZGDgl1dP2TRdE/XWNnfKRA7dtMToXhyybulM
        /MVN+xhQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nFNw2-00GOUK-5L; Wed, 02 Feb 2022 22:17:06 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 36AA498623E; Wed,  2 Feb 2022 23:17:03 +0100 (CET)
Date:   Wed, 2 Feb 2022 23:17:03 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, bp@alien8.de, x86@kernel.org,
        kvm@vger.kernel.org, joro@8bytes.org
Subject: Re: [PATCH][v3] KVM: x86: refine kvm_vcpu_is_preempted
Message-ID: <20220202221703.GE20638@worktop.programming.kicks-ass.net>
References: <1642397842-46318-1-git-send-email-lirongqing@baidu.com>
 <20220202145414.GD20638@worktop.programming.kicks-ass.net>
 <Yfq19FSnASMfd0BH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yfq19FSnASMfd0BH@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022 at 04:48:52PM +0000, Sean Christopherson wrote:

> > > +"movb	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax), %al;"
> > > +"andl	$" __stringify(KVM_VCPU_PREEMPTED) ", %eax;"
> > > +"setnz	%al;"
> > 
> > Isn't the below the simpler way of writing that same?
> 
> The AND is needed to clear RAX[63:8], e.g. to avoid breakage if the return value
> is changed from a bool to something larger, or the compiler uses more than a byte
> for _Bool.

While C doesn't specify _Bool the arch ABI most certainly does, and
x86_64 ABI guarantees a byte there, changing the return type is the only
possible option here.

Anyway, I don't mind the patch and the proposed Changelog does clarify
that this is an exercise in paranoia.
