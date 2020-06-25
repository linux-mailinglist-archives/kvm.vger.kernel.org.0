Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DB82099BE
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 08:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389967AbgFYGPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 02:15:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:1295 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728725AbgFYGPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 02:15:45 -0400
IronPort-SDR: gZv1sbJmZSchx6x77BqXPZCdAwycyxqp7b+qB1LFFSyOeJJgVZJiTbN6+kfPhxUMfwo5ww181T
 Gt47GwNpkXvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="143004693"
X-IronPort-AV: E=Sophos;i="5.75,278,1589266800"; 
   d="scan'208";a="143004693"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 23:15:44 -0700
IronPort-SDR: pmYSq/Xyxye5COV5SEv9efeTmQPcYF6VHtReRl4K52GVZdA1XSH1go1Db5lE44HXVVW2MzenKD
 howU8o3Q+vAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,278,1589266800"; 
   d="scan'208";a="479529959"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 24 Jun 2020 23:15:44 -0700
Date:   Wed, 24 Jun 2020 23:15:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200625061544.GC2141@linux.intel.com>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622220442.21998-2-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 06:04:41PM -0400, Peter Xu wrote:
> MSR accesses can be one of:
> 
>   (1) KVM internal access,
>   (2) userspace access (e.g., via KVM_SET_MSRS ioctl),
>   (3) guest access.
> 
> The ignore_msrs was previously handled by kvm_get_msr_common() and
> kvm_set_msr_common(), which is the bottom of the msr access stack.  It's
> working in most cases, however it could dump unwanted warning messages to dmesg
> even if kvm get/set the msrs internally when calling __kvm_set_msr() or
> __kvm_get_msr() (e.g. kvm_cpuid()).  Ideally we only want to trap cases (2)
> or (3), but not (1) above.
> 
> To achieve this, move the ignore_msrs handling upper until the callers of
> __kvm_get_msr() and __kvm_set_msr().  To identify the "msr missing" event, a
> new return value (KVM_MSR_RET_INVALID==2) is used for that.

IMO, kvm_cpuid() is simply buggy.  If KVM attempts to access a non-existent
MSR then it darn well should warn.

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8a294f9747aa..7ef7283011d6 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1013,7 +1013,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
                *ebx = entry->ebx;
                *ecx = entry->ecx;
                *edx = entry->edx;
-               if (function == 7 && index == 0) {
+               if (function == 7 && index == 0 && (*ebx | (F(RTM) | F(HLE))) &&
+                   (vcpu->arch.arch_capabilities & ARCH_CAP_TSX_CTRL_MSR)) {
                        u64 data;
                        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
                            (data & TSX_CTRL_CPUID_CLEAR))

