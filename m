Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F9B2DBD81
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 10:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgLPJ1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 04:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgLPJ1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 04:27:39 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3EAC0613D6;
        Wed, 16 Dec 2020 01:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VNK0Q94OzG6UefHS8Pno57bJJDEcOK4GilOJyawPb2U=; b=SpYqwyf6Cd7HJkTZSGadOIuGsx
        coZSqaI65Eh5jOb0e32VAw6wuVu7tG+cx8fsrcvmKI9kfqC/R4jqbfSb/IjwXSlH0FaGkvZCR+lMy
        kwIjRq2OgKr4rUyU4Ij+a2KsFiwBFrDKQQYuft4ocu/1wSmAO2p6GJCpx0f2OK+CMbXf0YUd3up6X
        2fe+LFi0AaSfjBvBdHtqDgEOlD4F/DZ+p/Rz2HzGjIhgOOX0hL+b29Q5c+zqy0UsQgsDV/tGrufwq
        jXBRd4r7CUu+R2yGws+0oDMM/9wDS4CmPNR70AgWzSQZwRzQ55zMKV+KDFLmcsompocxmdi7qYVeS
        0F81reMw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kpT5C-0000cB-Ju; Wed, 16 Dec 2020 09:26:54 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7CB02304D28;
        Wed, 16 Dec 2020 10:26:49 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CC8C22CADD8D4; Wed, 16 Dec 2020 10:26:49 +0100 (CET)
Date:   Wed, 16 Dec 2020 10:26:49 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jeyu@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: static_branch_enable() does not work from a __init function?
Message-ID: <20201216092649.GM3040@hirez.programming.kicks-ass.net>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 16, 2020 at 03:54:29AM +0000, Dexuan Cui wrote:
> Hi,
> The below init_module() prints "foo: false". This is strange since
> static_branch_enable() is called before the static_branch_unlikely().
> This strange behavior happens to v5.10 and an old v5.4 kernel.
> 
> If I remove the "__init" marker from the init_module() function, then
> I get the expected output of "foo: true"! I guess here I'm missing
> something with Static Keys?

*groan*... I think this is because __init is ran with
MODULE_STATE_COMING, we only switch to MODULE_STATE_LIVE later.

Let me see if there's a sane way to untangle that.

> #include <linux/module.h>
> #include <linux/kernel.h>
> #include <linux/jump_label.h>
> 
> static DEFINE_STATIC_KEY_FALSE(enable_foo);
> 
> int __init init_module(void)
> {
>         static_branch_enable(&enable_foo);
> 
>         if (static_branch_unlikely(&enable_foo))
>                 printk("foo: true\n");
>         else
>                 printk("foo: false\n");
> 
>         return 0;
> }
> 
> void cleanup_module(void)
> {
>         static_branch_disable(&enable_foo);
> }
> 
> MODULE_LICENSE("GPL");
> 
> 
> PS, I originally found: in arch/x86/kvm/vmx/vmx.c: vmx_init(), it looks
> like the line "static_branch_enable(&enable_evmcs);" does not take effect
> in a v5.4-based kernel, but does take effect in the v5.10 kernel in the
> same x86-64 virtual machine on Hyper-V, so I made the above test module
> to test static_branch_enable(), and found that static_branch_enable() in
> the test module does not work with both v5.10 and my v5.4 kernel, if the
> __init marker is used.
> 
> Thanks,
> -- Dexuan
> 
> 
