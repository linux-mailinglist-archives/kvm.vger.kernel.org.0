Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6BA2289AE
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 22:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgGUUQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 16:16:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:42433 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgGUUQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 16:16:44 -0400
IronPort-SDR: inIMy3EqkIoqUAxYDdC9NPm7YgRcANBN62H4wwKkCBnu3a44ENNQqXTbJH+DvxHFbeyXlgHHfl
 AwM4qMZ0be5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="151556232"
X-IronPort-AV: E=Sophos;i="5.75,380,1589266800"; 
   d="scan'208";a="151556232"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 13:16:44 -0700
IronPort-SDR: X+1gf0GlOj+mKt3rc02hxwCyd7F7JjgSi1r8outk3FKtXyajk2th3dfB4YrErjB7IeIajCY+VU
 NXWz8qJOdZow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,380,1589266800"; 
   d="scan'208";a="270538473"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jul 2020 13:16:43 -0700
Date:   Tue, 21 Jul 2020 13:16:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jacob Xu <jacobhxu@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: tlb_flush stat on Intel/AMD
Message-ID: <20200721201643.GI22083@linux.intel.com>
References: <CAJ5mJ6i-SoZO+F+Xz5OqK7BE7z7eLvE1hC=KX1ABwdnTw-QZuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ5mJ6i-SoZO+F+Xz5OqK7BE7z7eLvE1hC=KX1ABwdnTw-QZuA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 20, 2020 at 12:08:05PM -0700, Jacob Xu wrote:
> Hi all,
> 
> I wrote a kvm selftest to enter a 1-vcpu guest VM running a nop in one
> thread and check the VM's debugfs entry for # of tlb flushes while
> that was running. Installing the latest upstream kernel and running
> this on an intel host showed a tlb_flush count of 30, while running it
> on an amd host shows the tlb_flush count at 0.
> 
> Do we have an inconsistency between Intel and AMD in how VCPU_STAT is
> incremented?

Yes, you can even drop "between Intel and AMD" and just state "we have
inconsistencies in how VCPU_STAT is incremented".

> From browsing the code, we see that the stat only gets incremented in
> the kvm_ wrappers of the x86_ops functions tlb_flush_all,
> tlb_flush_current, and tlb_flush_guest. These wrappers are only called
> via the KVM request api (referred to as deferred flushes in some other
> threads), and there other instances of calling the x86_ops tlb_flush
> methods directly (immediate flush).
> 
> It looks like most of the tlb flush calls are deferred, but there are
> a few instances using the immediate flush where it's not counted
> (kvm_mmu_load, svm_set_cr4, vmx_set_apic_access_page,
> nested_prepare_vmcb_control). Is there a guideline on when to
> deferred/immediate tlb_flush?

The rule of thumb is to defer the flush whenever possible so that KVM
doesn't flush multiple times in a single VM-Exit.   However, of the above
three, svm_set_cr4() is the only one that can be deferred, but only
because kvm_mmu_load() and vmx_set_apic_access_page() are reachable after
KVM_REQ_TLB_FLUSH_CURRENT is processed in vcpu_enter_guest().

The VMX APIC flush could be deferred by hoisting KVM_REQ_APIC_PAGE_RELOAD
up.  I think that's safe?  But it's a very infrequent operation so I'm not
exactly chomping at the bit to get it fixed.

> Could this be a cause for the lower tlb_flush stat seen on an AMD
> host? Or perhaps there's another reason for the difference due to the
> (too) simple selftest?

Yes, but it's likely not due to any of the paths listed above.   Obviously
accounting the flush in kvm_mmu_load() will elevate the count, but it will
affect VMX and SVM identically.

Given that you see 0 on SVM and a low number on VMX, my money is on the
difference being that VMX accounts the TLB flush that occurs on vCPU
migration.  vmx_vcpu_load_vmcs() makes a KVM_REQ_TLB_FLUSH request, whereas
svm_vcpu_load() resets asid_generation but doesn't increment the stats.
 
> In the case of svm_tlb_flush, it seems like the tlb flush is deferred
> anyway since the response to setting a tlb flush control bit in the
> VMCB is not acted upon until entering the guest. So it seems we could
> count tlb flushes on svm more easily by incrementing the counter by
> checking the control bit before KVM_RUN. Though perhaps there's
> another case we'd like to count as tlb flush when the guest switches
> ASID (where would we track this?).
>
> Would switching to this alternative for incrementing tlb_flush stat in
> svm be much different than what we do right now?

I think a better option is to keep the current accounting, defer flushes
when possible to naturally fix accounting, and then fix the remaining one
off cases, e.g. kvm_mmu_load() and svm_vcpu_load().

I can prep a small series unless you want the honors?
