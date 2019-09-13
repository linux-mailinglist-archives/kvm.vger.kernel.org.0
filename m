Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDD9B2705
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 23:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731230AbfIMVGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 17:06:47 -0400
Received: from mga07.intel.com ([134.134.136.100]:31378 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731020AbfIMVGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 17:06:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 14:06:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="385555381"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 13 Sep 2019 14:06:45 -0700
Date:   Fri, 13 Sep 2019 14:06:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, pbonzini@redhat.com,
        jmattson@google.com
Subject: Re: [PATCH 3/4] kvm-unit-test: nVMX: __enter_guest() should not set
 "launched" state when VM-entry fails
Message-ID: <20190913210645.GA14482@linux.intel.com>
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-4-krish.sadhukhan@oracle.com>
 <20190904154231.GB24079@linux.intel.com>
 <a2268863-e554-4547-5196-3509bda3ace3@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a2268863-e554-4547-5196-3509bda3ace3@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 13, 2019 at 01:37:55PM -0700, Krish Sadhukhan wrote:
> 
> On 9/4/19 8:42 AM, Sean Christopherson wrote:
> >On Thu, Aug 29, 2019 at 04:56:34PM -0400, Krish Sadhukhan wrote:
> >>Bit# 31 in VM-exit reason is set by hardware in both cases of early VM-entry
> >>failures and VM-entry failures due to invalid guest state.
> >This is incorrect, VMCS.EXIT_REASON is not written on a VM-Fail.  If the
> >tests are passing, you're probably consuming a stale EXIT_REASON.
> 
> In vmx_vcpu_run(),
> 
>         if (vmx->fail || (vmx->exit_reason &
> VMX_EXIT_REASONS_FAILED_VMENTRY))
>                 return;
> 
>         vmx->loaded_vmcs->launched = 1;
> 
> we return without setting "launched" whenever bit# 31 is set in Exit Reason.
> If VM-entry fails due to invalid guest state or due to errors in VM-entry
> MSR-loading area, bit#31 is set.  As a result, L2 is not in "launched" state
> when we return to L1.  Tests that want to VMRESUME L2 after fixing the bad
> guest state or the bad MSR-loading area, fail with VM-Instruction Error 5,
> 
>         "Early vmresume failure: error number is 5. See Intel 30.4."

Yes, a VMCS isn't marked launched if it generates a VM-Exit due to a
failed consistency check.  But as that code shows, a failed consistency
check results in said VM-Exit *or* a VM-Fail.  Cosnsitency checks that
fail early, i.e. before loading guest state, generate VM-Fail, any check
that fails after the CPU has started loading guest state manifests as a
VM-Exit.  VMCS.EXIT_REASON isn't touched in the VM-Fail case.

E.g. in CHECKS ON VMX CONTROLS AND HOST-STATE AREA, the SDM states:

  VM entry fails if any of these checks fail.  When such failures occur,
  control is passed to the next instruction, RFLAGS.ZF is set to 1 to
  indicate the failure, and the VM-instruction error field is loaded with
  an error number that indicates whether the failure was due to the
  controls or the host-state area (see Chapter 30).
