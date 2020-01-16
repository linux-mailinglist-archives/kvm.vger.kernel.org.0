Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060B013EE61
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 19:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395041AbgAPSIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 13:08:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:3401 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395038AbgAPSIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 13:08:42 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 10:08:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,327,1574150400"; 
   d="scan'208";a="257468475"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jan 2020 10:08:41 -0800
Date:   Thu, 16 Jan 2020 10:08:41 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Derek Yerger <derek@djy.llc>
Cc:     bugzilla-daemon@bugzilla.kernel.org, kvm@vger.kernel.org
Subject: Re: [Bug 206215] New: QEMU guest crash due to random 'general
 protection fault' since kernel 5.2.5 on i7-3517UE
Message-ID: <20200116180841.GE20561@linux.intel.com>
References: <bug-206215-28872@https.bugzilla.kernel.org/>
 <20200115215256.GE30449@linux.intel.com>
 <e6ec4418-4ac1-e619-7402-18c085bc340d@djy.llc>
 <20200116153854.GA20561@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116153854.GA20561@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 16, 2020 at 07:38:54AM -0800, Sean Christopherson wrote:
> On Wed, Jan 15, 2020 at 08:08:32PM -0500, Derek Yerger wrote:
> > On 1/15/20 4:52 PM, Sean Christopherson wrote:
> > >+cc Derek, who is hitting the same thing.
> > >
> > >On Wed, Jan 15, 2020 at 09:18:56PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> > >>https://bugzilla.kernel.org/show_bug.cgi?id=206215
> > >*snip*
> > >that's a big smoking gun pointing at commit ca7e6b286333 ("KVM: X86: Fix
> > >fpu state crash in kvm guest"), which is commit e751732486eb upstream.
> > >
> > >1. Can you verify reverting ca7e6b286333 (or e751732486eb in upstream)
> > >    solves the issue?
> > >
> > >2. Assuming the answer is yes, on a buggy kernel, can you run with the
> > >    attached patch to try get debug info?
> > I did these out of order since I had 5.3.11 built with the patch, ready to
> > go for weeks now, waiting for an opportunity to test.
> > 
> > Win10 guest immediately BSOD'ed with:
> > 
> > WARNING: CPU: 2 PID: 9296 at include/linux/thread_info.h:55
> > kernel_fpu_begin+0x6b/0xc0
> 
> Can you provide the full stack trace of the WARN?  I'm hoping that will
> provide a hint as to what's going wrong.

Aha!  I found at least two cases where TIF_NEED_FPU_LOAD could be set
without the vCPU being preempted.

The comment on fpregs_lock() states that softirq can set TIF_NEED_FPU_LOAD,
which would not be handled by the preempt notifier.
 
  /*
   * Use fpregs_lock() while editing CPU's FPU registers or fpu->state.
   * A context switch will (and softirq might) save CPU's FPU registers to
                           ^^^^^^^^^^^^^^^^^^^
   * fpu->state and set TIF_NEED_FPU_LOAD leaving CPU's FPU registers in
   * a random state.
   */
  static inline void fpregs_lock(void)

The other scenario is from a stack trace from commit f775b13eedee ("x86,kvm:
move qemu/guest FPU switching out to vcpu_run"), which clearly shows that
kernel_fpu_begin() can be invoked without KVM being preempted.

  __warn+0xcb/0xf0
  warn_slowpath_null+0x1d/0x20
  kernel_fpu_disable+0x3f/0x50
  __kernel_fpu_begin+0x49/0x100
  kernel_fpu_begin+0xe/0x10
  crc32c_pcl_intel_update+0x84/0xb0
  crypto_shash_update+0x3f/0x110
  crc32c+0x63/0x8a [libcrc32c]
  dm_bm_checksum+0x1b/0x20 [dm_persistent_data]
  node_prepare_for_write+0x44/0x70 [dm_persistent_data]
  dm_block_manager_write_callback+0x41/0x50 [dm_persistent_data]
  submit_io+0x170/0x1b0 [dm_bufio]
  __write_dirty_buffer+0x89/0x90 [dm_bufio]
  __make_buffer_clean+0x4f/0x80 [dm_bufio]
  __try_evict_buffer+0x42/0x60 [dm_bufio]
  dm_bufio_shrink_scan+0xc0/0x130 [dm_bufio]
  shrink_slab.part.40+0x1f5/0x420
  shrink_node+0x22c/0x320
  do_try_to_free_pages+0xf5/0x330
  try_to_free_pages+0xe9/0x190
  __alloc_pages_slowpath+0x40f/0xba0
  __alloc_pages_nodemask+0x209/0x260
  alloc_pages_vma+0x1f1/0x250
  do_huge_pmd_anonymous_page+0x123/0x660
  handle_mm_fault+0xfd3/0x1330
  __get_user_pages+0x113/0x640
  get_user_pages+0x4f/0x60
  __gfn_to_pfn_memslot+0x120/0x3f0 [kvm]
  try_async_pf+0x66/0x230 [kvm]
  tdp_page_fault+0x130/0x280 [kvm]
  kvm_mmu_page_fault+0x60/0x120 [kvm]
  handle_ept_violation+0x91/0x170 [kvm_intel]
  vmx_handle_exit+0x1ca/0x1400 [kvm_intel]
  
Either of the above explains why pre-e751732486eb code waited until IRQs
are disabled by vcpu_enter_guest() to do switch_fpu_return().

Properly fixing soley within KVM is going to be somewhat painful.  The
most common case, vcpu_enter_guest(), which is being hit here, is easy
to handle by restoring the switch_fpu_return() that was removed by commit
e751732486eb.  The other obvious case I see is emulator's access of guest
fpu state, which will effectively require reverting commit 6ab0b9feb82a
("x86,kvm: remove KVM emulator get_fpu / put_fpu") along with new
implementations of the hooks to handle TIF_NEED_FPU_LOAD.

> > Then stashed the patch, reverted ca7e6b286333, compile, reboot.
> > 
> > Guest is running stable now on 5.3.11. Did test my CAD under the guest, did
> > not experience the crashes that had me stuck at 5.1.
