Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6B32DC080
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 13:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgLPMr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 07:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgLPMr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 07:47:58 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3A9C0617A7;
        Wed, 16 Dec 2020 04:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nRkl1ftL5o4b/KrhceyfWd4kfXLiLhPAekED99MnXJw=; b=fwQGBMQF6zSKMb09Y7Tj+nntNV
        6l2x04XDkAUFLqOu3QKP/NpoC8wmaSIJo6MNdzg3NOXUhVEeGOiyJAYsupv8drHiTapDvcNqj5a25
        b8NpMotmuihhYqNZF22q0VVRvI7rG7GMp9ERCl+iMXManVw+Cg2iv6Go6fE/S/a8mPirgKnOyXxwF
        aKiIqOJ7nX+ixnBUE9rz6le572Svc3+bWS4ZCGqz6H+pA6jpWuHp31kLXaMz78sYkQmvTCyV3eMZ5
        ML2yQ9tFnvYK2Y0hHg6t8nD9+tfV6StbMk18NyxCIryZXVZ1FPS0NQLsfeOxkAmxyKDKm29BFLFwU
        Ww9eopkA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kpWD3-0001aH-7u; Wed, 16 Dec 2020 12:47:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 47203304D28;
        Wed, 16 Dec 2020 13:47:09 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CBB7B203C64AC; Wed, 16 Dec 2020 13:47:08 +0100 (CET)
Date:   Wed, 16 Dec 2020 13:47:08 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Dexuan Cui <decui@microsoft.com>, Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: static_branch_enable() does not work from a __init function?
Message-ID: <20201216124708.GZ3021@hirez.programming.kicks-ass.net>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
 <20201216092649.GM3040@hirez.programming.kicks-ass.net>
 <20201216115524.GA13751@linux-8ccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216115524.GA13751@linux-8ccs>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 16, 2020 at 12:55:25PM +0100, Jessica Yu wrote:
> +++ Peter Zijlstra [16/12/20 10:26 +0100]:
> [snip]
> > > PS, I originally found: in arch/x86/kvm/vmx/vmx.c: vmx_init(), it looks
> > > like the line "static_branch_enable(&enable_evmcs);" does not take effect
> > > in a v5.4-based kernel, but does take effect in the v5.10 kernel in the
> > > same x86-64 virtual machine on Hyper-V, so I made the above test module
> > > to test static_branch_enable(), and found that static_branch_enable() in
> > > the test module does not work with both v5.10 and my v5.4 kernel, if the
> > > __init marker is used.
> 
> Because the jump label code currently does not allow you to update if
> the entry resides in an init section. By marking the module init
> section __init you place it in the .init.text section.
> jump_label_add_module() detects this (by calling within_module_init())
> and marks the entry by calling jump_entry_set_init(). Then you have
> the following sequence of calls (roughly):
> 
> static_branch_enable
>  static_key_enable
>    static_key_enable_cpuslocked
>      jump_label_update
>        jump_label_can_update
>          jump_entry_is_init returns true, so bail out
> 
> Judging from the comment in jump_label_can_update(), this seems to be
> intentional behavior:
> 
> static bool jump_label_can_update(struct jump_entry *entry, bool init)
> {
>        /*
>         * Cannot update code that was in an init text area.
>         */
>        if (!init && jump_entry_is_init(entry))
>                return false;
> 

Only because we're having .init=false, incorrectly. See the other email.
