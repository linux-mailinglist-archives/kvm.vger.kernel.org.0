Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3125721A9B3
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 23:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgGIV0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 17:26:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:52705 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgGIV0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 17:26:53 -0400
IronPort-SDR: RYwze7qMB50Fs4FNNkExE8BdVF7+jthc+fD71LUvnXM0qpK3RcHv3wHMsDtCcBhtD21xScNeir
 tUX7kjzCciXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="146185495"
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="146185495"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 14:26:52 -0700
IronPort-SDR: yVNbM2ZUsYndzEnCr5AKa3WEn4so/S8RBxgYY5QrLH0LHjz+Pg//8LlqJwEqNBe6M1xLvgr89e
 vYIn9sWFj/3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="484420002"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jul 2020 14:26:52 -0700
Date:   Thu, 9 Jul 2020 14:26:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200709212652.GX24919@linux.intel.com>
References: <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
 <20200626180732.GB175520@xz-x1>
 <20200626181820.GG6583@linux.intel.com>
 <47b90b77-cf03-6087-b25f-fcd2fd313165@redhat.com>
 <20200630154726.GD7733@linux.intel.com>
 <20200709182220.GG199122@xz-x1>
 <20200709192440.GD24919@linux.intel.com>
 <20200709210919.GI199122@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709210919.GI199122@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 09, 2020 at 05:09:19PM -0400, Peter Xu wrote:
> Again, using host_initiated or not should be a different issue?  Frankly
> speaking, I don't know whether it's an issue or not, but it's different from
> what this series wants to do, because it'll be the same before/after this
> series. Am I right?

I'm arguing that the TSX thing should be

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5eb618dbf211..e1fd5ac0df96 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1015,7 +1015,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
                *edx = entry->edx;
                if (function == 7 && index == 0) {
                        u64 data;
-                       if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
+                       if (!kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data) &&
                            (data & TSX_CTRL_CPUID_CLEAR))
                                *ebx &= ~(F(RTM) | F(HLE));
                }

At which point hoisting the ignored message up a few levels is pointless
because the only users of __kvm_*et_msr() will do the explicit ignored_check.
And I'm also arguing that KVM should never use __kvm_get_msr() for its own
actions, as host_initiated=true should only be used for host VMM accesses and
host_initiated=false actions should go through the proper checks and never
get to the ignored_msrs logic (assuming no KVM bug).

> Or, please explain what's the "overruled objection" that you're talking about..

Sean: Objection your honor.
Paolo: Overruled, you're wrong.
Sean: Phooey.

My point is that even though I still object to this series, Paolo has final
say.
