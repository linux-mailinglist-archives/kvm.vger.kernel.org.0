Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A59248D556
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 11:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbiAMKAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 05:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbiAMKAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 05:00:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBD0C06173F
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 02:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CMKPZ+hQcUTN2u788DZTKookXpmOOkhvSc/WwScHrzA=; b=Ww6FquB7/QDhXC8PAyKf1cU87R
        lDRY2Ipz9qqq9o3+/PP0JzXr7DNQlYza4G3H98nNq7D8uZ+CNg7Rz8KA9nrhXJSuKAl7oj7cBHPNC
        jgFlDQ7xVRnUJuMlHLQCNSrKeWkkPgyNwj8DXsbBSTP63pqb/6/WZzZia3e6OSBxEbheD7nI7AqpB
        xAU4Sv9Oi6Q+NyR7dH4UDj2rwdbokEJO/+wzrV1uU8WPHxUw+86+nP1xkt+P1zHVQlHhNpVL+uX0m
        +UmnsP+sA/AqEzbJNZ30dSoyEOmqNEBSyGRJNJ34qauSfd0L5IDE3ofnaPrGv3k7yAOTRh9JiCpzc
        HeRkLuKg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7wu1-004pjl-Vm; Thu, 13 Jan 2022 10:00:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 12E483000E6;
        Thu, 13 Jan 2022 11:00:16 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E915120D3C545; Thu, 13 Jan 2022 11:00:15 +0100 (CET)
Date:   Thu, 13 Jan 2022 11:00:15 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, rkrcmar@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org
Subject: Re: [PATCH] KVM: x86: fix kvm_vcpu_is_preempted
Message-ID: <Yd/4L38tio2qCADl@hirez.programming.kicks-ass.net>
References: <1641986380-10199-1-git-send-email-lirongqing@baidu.com>
 <Yd8FO8O9AQa79sFc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd8FO8O9AQa79sFc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 04:43:39PM +0000, Sean Christopherson wrote:
> On Wed, Jan 12, 2022, Li RongQing wrote:
> > After support paravirtualized TLB shootdowns, steal_time.preempted
> > includes not only KVM_VCPU_PREEMPTED, but also KVM_VCPU_FLUSH_TLB
> > 
> > and kvm_vcpu_is_preempted should test only with KVM_VCPU_PREEMPTED
> > 
> > Fixes: 858a43aae2367 ("KVM: X86: use paravirtualized TLB Shootdown")
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > ---
> >  arch/x86/kernel/kvm.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 59abbda..a9202d9 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -1025,8 +1025,8 @@ asm(
> >  ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
> >  "__raw_callee_save___kvm_vcpu_is_preempted:"
> >  "movq	__per_cpu_offset(,%rdi,8), %rax;"
> > -"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
> > -"setne	%al;"
> > +"movb	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax), %al;"
> > +"andb	$" __stringify(KVM_VCPU_PREEMPTED) ", %al;"
> 
> Eww, the existing code is sketchy.  It relies on the compiler to store _Bool/bool
> in a single byte since %rax may be non-zero from the __per_cpu_offset(), and
> modifying %al doesn't zero %rax[63:8].  I doubt gcc or clang use anything but a
> single byte on x86-64, but "andl" is just as cheap so I don't see any harm in
> being paranoid.

Agreed, better to clear the rest of rax just to be safe.
