Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 277A31664F0
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 18:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgBTRdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 12:33:37 -0500
Received: from mga04.intel.com ([192.55.52.120]:47644 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727979AbgBTRdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 12:33:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 09:33:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="230190404"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 20 Feb 2020 09:33:36 -0800
Date:   Thu, 20 Feb 2020 09:33:16 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] KVM: nVMX: fix apicv disablement for L1
Message-ID: <20200220173316.GC3972@linux.intel.com>
References: <20200220172205.197767-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220172205.197767-1-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 20, 2020 at 06:22:03PM +0100, Vitaly Kuznetsov wrote:
> It was found that fine-grained VMX feature enablement in QEMU is broken
> when combined with SynIC:
> 
>     qemu-system-x86_64 -machine q35,accel=kvm -cpu host,hv_vpindex,hv_synic -smp 2 -m 16384 -vnc :0
>     qemu-system-x86_64: error: failed to set MSR 0x48d to 0xff00000016
>     qemu-system-x86_64: <...>: kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
>     Aborted
> 
> QEMU thread: https://lists.gnu.org/archive/html/qemu-devel/2020-02/msg04838.html
> 
> Turns out, this is a KVM issue: when SynIC is enabled, PIN_BASED_POSTED_INTR
> gets filtered out from VMX MSRs for all newly created (but not existent!)
> vCPUS. Patch1 addresses this. Also, apicv disablement for L1 doesn't seem
> to disable it for L2 (at least on CPU0) so unless there's a good reason
> to not allow this we need to make it work. PATCH2, suggested by Paolo,
> is supposed to do the job.
> 
> RFC: I looked at the code and ran some tests and nothing suspicious popped
> out, however, I'm still not convinced this is a good idea to have apicv
> enabled for L2 when it's disabled for L1...

Eh, if it works...  IMO, enabling apicv for both L1 and L2 is far more
mindbending.

> Also, we may prefer to merge or re-order these two patches.

It does seem like patch 2 should be applied first.  

> Vitaly Kuznetsov (2):
>   KVM: nVMX: clear PIN_BASED_POSTED_INTR from nested pinbased_ctls only
>     when apicv is globally disabled
>   KVM: nVMX: handle nested posted interrupts when apicv is disabled for
>     L1
> 
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/lapic.c            |  5 +----
>  arch/x86/kvm/svm.c              |  7 ++++++-
>  arch/x86/kvm/vmx/capabilities.h |  1 +
>  arch/x86/kvm/vmx/nested.c       |  5 ++---
>  arch/x86/kvm/vmx/nested.h       |  3 +--
>  arch/x86/kvm/vmx/vmx.c          | 23 +++++++++++++----------
>  7 files changed, 25 insertions(+), 21 deletions(-)
> 
> -- 
> 2.24.1
> 
