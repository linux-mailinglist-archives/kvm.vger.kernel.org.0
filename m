Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082582DC068
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 13:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgLPMiw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 07:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgLPMiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 07:38:51 -0500
Date:   Wed, 16 Dec 2020 13:38:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608122290;
        bh=/vWZmZvghpr6F9yCtq98EC441mITAJqIEkMnbirYzEQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=sPHVFQ2C9AvSHa04+66kxuGPInU0Ju9ieUIux+tb+q0O1H7xwB3wblE8f4ias+HL5
         eX5tNXBf7vXicl2Dd5YF2rDYUU6X4MxIvzCy0NuxYAkFb3MEn2tXc4E+fJh+nQpLAq
         jtcoE9uKKS9hNDISUkK+NE81aVKraV4uVT0v49rIDGNyABIW4NyM3q0D+eFnqk9q31
         ljSkyJyd844RSjxBk+32/dDsmhzdok8hvL3wlV138/EguAuXBwA73YdvK2nLeXp6Vq
         sxJvBf0YWp+aFVJxkLzGJhfDK7oHE7gKtYA/wkgIQ/zqRrcvLM/bmO3ldSAosUjg5f
         uDXIzivWfkwpw==
From:   Jessica Yu <jeyu@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Dexuan Cui <decui@microsoft.com>, Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: static_branch_enable() does not work from a __init function?
Message-ID: <20201216123805.GB13751@linux-8ccs>
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
>On Wed, Dec 16, 2020 at 03:54:29AM +0000, Dexuan Cui wrote:
>> PS, I originally found: in arch/x86/kvm/vmx/vmx.c: vmx_init(), it looks
>> like the line "static_branch_enable(&enable_evmcs);" does not take effect
>> in a v5.4-based kernel, but does take effect in the v5.10 kernel in the
>> same x86-64 virtual machine on Hyper-V, so I made the above test module
>> to test static_branch_enable(), and found that static_branch_enable() in
>> the test module does not work with both v5.10 and my v5.4 kernel, if the
>> __init marker is used.

By the way, it probably works now because there was a workaround
merged in v5.10, that mentions this very issue:

commit 064eedf2c50f692088e1418c553084bf9c1432f8
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Wed Oct 14 16:33:46 2020 +0200

    KVM: VMX: eVMCS: make evmcs_sanitize_exec_ctrls() work again

    It was noticed that evmcs_sanitize_exec_ctrls() is not being executed
    nowadays despite the code checking 'enable_evmcs' static key looking
    correct. Turns out, static key magic doesn't work in '__init' section
    (and it is unclear when things changed) but setup_vmcs_config() is called
    only once per CPU so we don't really need it to. Switch to checking
    'enlightened_vmcs' instead, it is supposed to be in sync with
    'enable_evmcs'.

    Opportunistically make evmcs_sanitize_exec_ctrls '__init' and drop unneeded
    extra newline from it.

    Reported-by: Yang Weijiang <weijiang.yang@intel.com>
    Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
    Message-Id: <20201014143346.2430936-1-vkuznets@redhat.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

