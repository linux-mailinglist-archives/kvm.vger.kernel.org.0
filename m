Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B86248D50F
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 10:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiAMJeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 04:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiAMJeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 04:34:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEBCC06173F
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 01:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DHr1sVrl7IeDvej9SCgr84nfd+F52WmWfEs1KtZgQWw=; b=oYZLyJosFgXgCrOK0kLOcSbfUz
        1Dt68evhq9DHR+9Ny2C2UDj2b7WjMLOAUN6NNzQ9BoaPsnoYC/prqVp+a2Y3mrTDzNg51vZHGL4vo
        pO1Uq8EQkXPw438JqKhHTPxMiAG/7R6q86zqdloEVDoZNWsRT8ix9eP4i8P7r1wAVKNMk5oZoUPpe
        F6MOC9C4EMOzTEB8/eDXrkZFJAyXqhvlLtUG3gLUiot8l/f6g7ybvgPMbvHTBHsC8XPEYEXDnx1+v
        KHhGM0vlAYgccQ/CabdTPnDrAe1VxwU+cC/tmhSn59IOZi4HG3GeBJGx7vsoym69Se2qZd9jE6aRo
        F9ufPaZw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7wUA-004omR-Bv; Thu, 13 Jan 2022 09:33:34 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9F8593001E1;
        Thu, 13 Jan 2022 10:33:33 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7B83B264EE43F; Thu, 13 Jan 2022 10:33:33 +0100 (CET)
Date:   Thu, 13 Jan 2022 10:33:33 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Wang,Guangju" <wangguangju@baidu.com>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0g=?= =?utf-8?Q?=5D?= KVM: X86: set
 vcpu preempted only if it is preempted
Message-ID: <Yd/x7SfI7rNG1erQ@hirez.programming.kicks-ass.net>
References: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
 <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net>
 <Yd8QR2KHDfsekvNg@google.com>
 <20220112213129.GO16608@worktop.programming.kicks-ass.net>
 <bb92391dc5de46ac87ff238faf875c7b@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb92391dc5de46ac87ff238faf875c7b@baidu.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022 at 04:52:40AM +0000, Li,Rongqing wrote:

> > > > On Wed, Jan 12, 2022 at 08:02:01PM +0800, Li RongQing wrote:
> > > > > vcpu can schedule out when run halt instruction, and set itself to
> > > > > INTERRUPTIBLE and switch to idle thread, vcpu should not be set
> > > > > preempted for this condition

> Is it possible if guest has KVM_HINTS_REALTIME feature, but its HLT instruction is emulated by KVM?
> If it is possible, this condition has been performance degradation, since vcpu_is_preempted is not __kvm_vcpu_is_preempted, will return false.
> 
> Similar, guest has nopvspin, but HLT instruction is emulated;  
> 
> Should we adjust the setting of pv_ops.lock.vcpu_is_preempted as below
> And I see the performance boost when guest has nopvspin, but HLT instruction is emulated with below change

I'm a little confused; the initial patch explicitly avoided setting
preempted on HLT, while the below causes it to be set more.

That said; I don't object to this, but I'm not convinced it's right
either. If you have HINTS_REALTIME (horrible naming aside) this means
you have pinned vCPU and no overcommit, in which case setting preempted
makes no sense.

*confused*

> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 59abbda..b061d17 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -1048,6 +1048,11 @@ void __init kvm_spinlock_init(void)
>                 return;
>         }
> 
> +       if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> +               pv_ops.lock.vcpu_is_preempted =
> +                       PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
> +       }
> +
>         /*
>          * Disable PV spinlocks and use native qspinlock when dedicated pCPUs
>          * are available.
> @@ -1076,10 +1081,6 @@ void __init kvm_spinlock_init(void)
>         pv_ops.lock.wait = kvm_wait;
>         pv_ops.lock.kick = kvm_kick_cpu;
> 
> -       if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> -               pv_ops.lock.vcpu_is_preempted =
> -                       PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
> -       }
>         /*
>          * When PV spinlock is enabled which is preferred over
>          * virt_spin_lock(), virt_spin_lock_key's value is meaningless.
> 
> 
> -Li
