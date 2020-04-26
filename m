Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCC91B9124
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 17:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgDZPV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Apr 2020 11:21:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:21919 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgDZPV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Apr 2020 11:21:59 -0400
IronPort-SDR: RmKVuRa1uw4cDWtWO87frShgmoj5CBkUMIv6TH0WDrxYFUTh17Z3p47NuzJez113sW/jcw2Ft2
 5wJeBu1UUpVg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2020 08:21:59 -0700
IronPort-SDR: qMXhH6Y5Ppw8jvrNSDZgkysrFGrNKvsu1BDnfineDYgmgqgkeGPoppM5NhhbJ6iDYO0ORtkQXQ
 Uf3vE0MNh/Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,320,1583222400"; 
   d="scan'208";a="248616221"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga008.fm.intel.com with ESMTP; 26 Apr 2020 08:21:57 -0700
Date:   Sun, 26 Apr 2020 23:23:55 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 7/9] KVM: X86: Add userspace access interface for CET
 MSRs
Message-ID: <20200426152355.GB29493@local-michael-cet-test.sh.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-8-weijiang.yang@intel.com>
 <08457f11-f0ac-ff4b-80b7-e5380624eca0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08457f11-f0ac-ff4b-80b7-e5380624eca0@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 25, 2020 at 05:31:59PM +0200, Paolo Bonzini wrote:
> On 26/03/20 09:18, Yang Weijiang wrote:
> > There're two different places storing Guest CET states, states
> > managed with XSAVES/XRSTORS, as restored/saved
> > in previous patch, can be read/write directly from/to the MSRs.
> > For those stored in VMCS fields, they're access via vmcs_read/
> > vmcs_write.
> > 
> > To correctly read/write the CET MSRs, it's necessary to check
> > whether the kernel FPU context switch happened and reload guest
> > FPU context if needed.
> 
> I have one question here, it may be just a misunderstanding.
> 
> As I understand it, the PLx_SSP MSRs are only used when the current
> privilege level changes; the processor has a hidden SSP register for the
> current privilege level, and the SSP can be accessed via VMCS only.
>
> These patches do not allow saving/restoring this hidden register.
> However, this should be necessary in order to migrate the virtual
> machine.  The simplest way to plumb this is through a KVM-specific MSR
> in arch/x86/include/uapi/asm/kvm_para.h.  This MSR should only be
> accessible to userspace, i.e. only if msr_info->host_initiated.
Thanks for raising the issue!
I checked SDM again, yes, it's neccessary to save the current SSP for
migration case, I'll follow your advice to add it as custom MSR.
 
> Testing CET in the state-test selftest is a bit hard because you have to
> set up S_CET and the shadow stack, but it would be great to have a
> separate test similar to tools/testing/selftests/x86_64/smm_test.  It's
> not an absolute requirement for merging, but if you can put it on your
> todo list it would be better.
> 
What's the purpose of the selftest? Is it just for Shadow Stack SSP
state transitions in various cases? e.g., L0 SSP<--->L3 SSP,
L0 SSP1<--->L0 SSP2? We now have the KVM unit-test for CET functionalities,
i.e., Shadow Stack and Indirect Branch Tracking for user-mode, I can put the
state test app into the todo list as current patchset is mainly for user-mode
protection, the supervisor-mode CET protection is the next step.

> Thanks,
> 
> Paolo
