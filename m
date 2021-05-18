Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA61387431
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 10:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347557AbhERIky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 04:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347546AbhERIkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 04:40:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB43C061756;
        Tue, 18 May 2021 01:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=oLX06SvNo3MjZQD/51KQtJ1+KOvlvX5HnF5jVxIhJ2s=; b=EJKwgrdBNoAJQBcM1a+qXcU58X
        ufdldCqyZtZg7taAcR3bY73VKd/RcTNJFJINv+Hz7D658IyYipL1mFfdDuXfOE2R5ynjs9DRHYqPJ
        apDPlxzzKnYjUoVifboA42DEF9yaIPBXnQNEHgzgx5fUitm70X2GYSD6BIc/fEXHfPDfRsNg2DCnM
        ZnY7Wc8YErU/szLvDoGrjr1AcD3juaMUWujsd75m3/dFpJr6Zl3MnOUwwKmXwqhH3NTEtWr9INEv9
        eyxNqT4Hm65/XF3QXVXvwWi150mH+gh4x1WS46aDjCAUHVDju7OsbmwNv29WxCYWJb91rzECGE4Ik
        N7BkBtIg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1livEZ-00DoCb-1W; Tue, 18 May 2021 08:37:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 99BC530022A;
        Tue, 18 May 2021 10:37:46 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8366D2BE6E843; Tue, 18 May 2021 10:37:46 +0200 (CEST)
Date:   Tue, 18 May 2021 10:37:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v6 02/16] perf/x86/intel: Handle guest PEBS overflow PMI
 for KVM guest
Message-ID: <YKN82utjfLEX9ZJh@hirez.programming.kicks-ass.net>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-3-like.xu@linux.intel.com>
 <YKImQ2/DilGIkrfe@hirez.programming.kicks-ass.net>
 <bd684011-b83d-5c83-bdfb-926d6bc4595a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd684011-b83d-5c83-bdfb-926d6bc4595a@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 18, 2021 at 03:38:52PM +0800, Xu, Like wrote:

> > I'm thinking you have your conditions in the wrong order; would it not
> > be much cheaper to first check: '!x86_pmu.pebs_active || !guest_pebs_idx'
> > than to do that horrible indirect ->is_in_guest() call?
> > 
> > After all, if the guest doesn't have PEBS enabled, who cares if we're
> > currently in a guest or not.
> 
> Yes, it makes sense. How about:
> 
> @@ -2833,6 +2867,10 @@ static int handle_pmi_common(struct pt_regs *regs,
> u64 status)
>                 u64 pebs_enabled = cpuc->pebs_enabled;
> 
>                 handled++;
> +               if (x86_pmu.pebs_vmx && x86_pmu.pebs_active &&
> +                   (cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask) &&
> +                   (static_call(x86_guest_state)() & PERF_GUEST_ACTIVE))
> +                       x86_pmu_handle_guest_pebs(regs, &data);

This is terruble, just call x86_pmu_handle_guest_pebs() unconditionally
and put all the ugly inside it.

>                 x86_pmu.drain_pebs(regs, &data);
>                 status &= intel_ctrl | GLOBAL_STATUS_TRACE_TOPAPMI;
> 
> > 
> > Also, something like the below perhaps (arm64 and xen need fixing up at
> > the very least) could make all that perf_guest_cbs stuff suck less.
> 
> How about the commit message for your below patch:
> 
> From: "Peter Zijlstra (Intel)" <peterz@infradead.org>
> 
> x86/core: Use static_call to rewrite perf_guest_info_callbacks
> 
> The two fields named "is_in_guest" and "is_user_mode" in
> perf_guest_info_callbacks are replaced with a new multiplexed member
> named "state", and the "get_guest_ip" field will be renamed to "get_ip".
> 
> The application of DEFINE_STATIC_CALL_RET0 (arm64 and xen need fixing
> up at the very least) could make all that perf_guest_cbs stuff suck less.
> For KVM, these callbacks will be updated in the kvm_arch_init().
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Well, you *do* need to fix up arm64 and xen, we can't very well break
their builds can we now.

> ----
> 
> I'm not sue if you have a strong reason to violate the check-patch rule:
> 
> ERROR: Using weak declarations can have unintended link defects
> #238: FILE: include/linux/perf_event.h:1242:
> +extern void __weak arch_perf_update_guest_cbs(void);

Copy/paste fail I think. I didn't really put much effort into the patch,
only made sure defconfig+kvm_guest.config compiled.
