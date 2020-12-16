Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1B32DBFE8
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 12:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgLPL4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 06:56:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgLPL4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 06:56:10 -0500
Date:   Wed, 16 Dec 2020 12:55:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608119730;
        bh=1vfQ7UmDADybe4x3Gmf59U8wFRSPaKn6Q1ntgmmnLfU=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=slZMwCmA0keF2Dy7v7sIQlWudQ7nOg3OoWp3x20hG6rXXybGJE2LvceQ4Jlkj3+QV
         jkzNOBaKJUvAsSFWGgjFV9J/YQdpeGBqAgdO7UkQFpn5R2UDBccTVRS/YO2h7BghXv
         wZmAq9zptec3tFPYJm+s+sZS4zsgdkUfh8tE8GyVnn6JoADxbbsgS3iCyktQZBkG+l
         Ej3bE54JFZVeCT270s4vDZd6i0Bo007o6FWNRVsmf4XLQDVmqyYVo4YUJ7t+C+dP3B
         9KWY+EhDko75oVF/fuDyxUiY3ao7umzagAKg0oALxGnUtnahsXnn4BDiNxtjVMAbPA
         dN6ErAr6K7Z7Q==
From:   Jessica Yu <jeyu@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Dexuan Cui <decui@microsoft.com>, Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: static_branch_enable() does not work from a __init function?
Message-ID: <20201216115524.GA13751@linux-8ccs>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
 <20201216092649.GM3040@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201216092649.GM3040@hirez.programming.kicks-ass.net>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+++ Peter Zijlstra [16/12/20 10:26 +0100]:
[snip]
>> PS, I originally found: in arch/x86/kvm/vmx/vmx.c: vmx_init(), it looks
>> like the line "static_branch_enable(&enable_evmcs);" does not take effect
>> in a v5.4-based kernel, but does take effect in the v5.10 kernel in the
>> same x86-64 virtual machine on Hyper-V, so I made the above test module
>> to test static_branch_enable(), and found that static_branch_enable() in
>> the test module does not work with both v5.10 and my v5.4 kernel, if the
>> __init marker is used.

Because the jump label code currently does not allow you to update if
the entry resides in an init section. By marking the module init
section __init you place it in the .init.text section.
jump_label_add_module() detects this (by calling within_module_init())
and marks the entry by calling jump_entry_set_init(). Then you have
the following sequence of calls (roughly):

static_branch_enable
  static_key_enable
    static_key_enable_cpuslocked
      jump_label_update
        jump_label_can_update
          jump_entry_is_init returns true, so bail out

Judging from the comment in jump_label_can_update(), this seems to be
intentional behavior:

static bool jump_label_can_update(struct jump_entry *entry, bool init)
{
        /*
         * Cannot update code that was in an init text area.
         */
        if (!init && jump_entry_is_init(entry))
                return false;

By removing the __init marker you're bypassing the
within_module_init() check and that's why it works.
