Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAA7B563D
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 21:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfIQTgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 15:36:00 -0400
Received: from mga05.intel.com ([192.55.52.43]:51963 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbfIQTf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 15:35:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 12:35:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,517,1559545200"; 
   d="scan'208";a="193838534"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Sep 2019 12:35:59 -0700
Date:   Tue, 17 Sep 2019 12:35:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com
Subject: Re: [PATCH v3] kvm: nvmx: limit atomic switch MSRs
Message-ID: <20190917193559.GC8804@linux.intel.com>
References: <20190917185057.224221-1-marcorr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917185057.224221-1-marcorr@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 11:50:57AM -0700, Marc Orr wrote:
> Allowing an unlimited number of MSRs to be specified via the VMX
> load/store MSR lists (e.g., vm-entry MSR load list) is bad for two
> reasons. First, a guest can specify an unreasonable number of MSRs,
> forcing KVM to process all of them in software. Second, the SDM bounds
> the number of MSRs allowed to be packed into the atomic switch MSR lists.
> Quoting the "Miscellaneous Data" section in the "VMX Capability
> Reporting Facility" appendix:
> 
> "Bits 27:25 is used to compute the recommended maximum number of MSRs
> that should appear in the VM-exit MSR-store list, the VM-exit MSR-load
> list, or the VM-entry MSR-load list. Specifically, if the value bits
> 27:25 of IA32_VMX_MISC is N, then 512 * (N + 1) is the recommended
> maximum number of MSRs to be included in each list. If the limit is
> exceeded, undefined processor behavior may result (including a machine
> check during the VMX transition)."
> 
> Because KVM needs to protect itself and can't model "undefined processor
> behavior", arbitrarily force a VM-entry to fail due to MSR loading when
> the MSR load list is too large. Similarly, trigger an abort during a VM
> exit that encounters an MSR load list or MSR store list that is too large.
> 
> The MSR list size is intentionally not pre-checked so as to maintain
> compatibility with hardware inasmuch as possible.
> 
> Test these new checks with the kvm-unit-test "x86: nvmx: test max atomic
> switch MSRs".
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
> v2 -> v3
> * Updated commit message.
> * Removed superflous function declaration.
> * Expanded in-line comment.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
