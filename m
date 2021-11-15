Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F097145168D
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 22:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350343AbhKOVbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 16:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243142AbhKOU4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 15:56:44 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A174C043198;
        Mon, 15 Nov 2021 12:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=glXmaer1AnnsfLnkd+NXbLGw5JwITPEc81+nOuesJi8=; b=ib+jo5QH8uDApJ7acX0QE3l17d
        8LEf3XvuGBpsmLmk1AHzbwJYsBpsUIneu/DEo4DNgGRBJPSVF+zT6G/LkaTuhjQhh6E3cJWCjxWP0
        84ywMk9ku9heTsi6z4CYZ0/0TuA0vV9Xm2QFcapJzU6ddpq+ofh13Lx6/dwxhPnfp+YYwP475vJ5A
        JDzqdgVFLsOQFHoHj6fsIXNGg9/Om8oVsQNUIrTyJOi1gv9srCtn1MiNQu41V/S70+m05w+8XPa5i
        piovS0/DMUh8ChtxdV2yzUyqftvh/7Zr3R1K0nGOA4E7A+5917Rb0LzMlvgvAIplxaTN1uP25W2Ho
        cViCzkqg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmiuY-00GCFq-5c; Mon, 15 Nov 2021 20:49:06 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id BC989986687; Mon, 15 Nov 2021 21:49:05 +0100 (CET)
Date:   Mon, 15 Nov 2021 21:49:05 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vihas Mak <makvihas@gmail.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix cocci warnings
Message-ID: <20211115204905.GQ174703@worktop.programming.kicks-ass.net>
References: <20211114164312.GA28736@makvihas>
 <YZJH0Hd/ETYWJGTX@hirez.programming.kicks-ass.net>
 <ab419d8b-3e5d-2879-274c-ee609254890c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab419d8b-3e5d-2879-274c-ee609254890c@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 06:06:08PM +0100, Paolo Bonzini wrote:
> On 11/15/21 12:43, Peter Zijlstra wrote:
> > On Sun, Nov 14, 2021 at 10:13:12PM +0530, Vihas Mak wrote:
> > > change 0 to false and 1 to true to fix following cocci warnings:
> > > 
> > >          arch/x86/kvm/mmu/mmu.c:1485:9-10: WARNING: return of 0/1 in function 'kvm_set_pte_rmapp' with return type bool
> > >          arch/x86/kvm/mmu/mmu.c:1636:10-11: WARNING: return of 0/1 in function 'kvm_test_age_rmapp' with return type bool
> > 
> > That script should be deleted, it's absolute garbage.
> > 
> 
> Only a Sith deals in absolutes.

Is that a star-wars thingy?

In C 0 is a valid way to spell false, equally, any non-0 value is a
valid way to spell true. Why would this rate a warn?

In fact, when casting _Bool to integer, you get 0 and 1. When looking at
the memory content of the _Bool variable, you'll get 0 and 1. But we're
not allowed to write 0 and 1?

