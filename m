Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBCC35549
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 04:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFECbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 22:31:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:40489 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfFECbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 22:31:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 19:31:40 -0700
X-ExtLoop1: 1
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga008.jf.intel.com with ESMTP; 04 Jun 2019 19:31:37 -0700
Date:   Wed, 5 Jun 2019 10:30:44 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yu-cheng.yu@intel.com
Subject: Re: [PATCH v5 1/8] KVM: VMX: Define CET VMCS fields and control bits
Message-ID: <20190605023044.GB28360@local-michael-cet-test>
References: <20190522070101.7636-1-weijiang.yang@intel.com>
 <20190522070101.7636-2-weijiang.yang@intel.com>
 <20190604144613.GA12246@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190604144613.GA12246@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 04, 2019 at 07:46:13AM -0700, Sean Christopherson wrote:
> On Wed, May 22, 2019 at 03:00:54PM +0800, Yang Weijiang wrote:
> > CET(Control-flow Enforcement Technology) is an upcoming Intel® processor
> > family feature that blocks return/jump-oriented programming (ROP) attacks.
> > It provides the following capabilities to defend
> > against ROP/JOP style control-flow subversion attacks:
> > 
> > - Shadow Stack (SHSTK):
> >   A second stack for the program that is used exclusively for
> >   control transfer operations.
> > 
> > - Indirect Branch Tracking (IBT):
> >   Free branch protection to defend against jump/call oriented
> >   programming.
> 
> What is "free" referring to here?  The software enabling certainly isn't
> free, and I doubt the hardware/ucode cost is completely free.
>
Thank you for pointing it out!
"free" comes from the spec., I guess the author means the major effort of
enabling IBT is in compiler and HW, free effort to SW enabling.
But as you mentioned, actually there's deficated effort to enable it,
will change it to other words.

> > Several new CET MSRs are defined in kernel to support CET:
> > MSR_IA32_{U,S}_CET - MSRs to control the CET settings for user
> > mode and suervisor mode respectively.
> > 
> > MSR_IA32_PL{0,1,2,3}_SSP - MSRs to store shadow stack pointers for
> > CPL-0,1,2,3 levels.
> > 
> > MSR_IA32_INT_SSP_TAB - MSR to store base address of shadow stack
> > pointer table.
> 
> For consistency (within the changelog), these should be list style, e.g.:
> 
> 
>   - MSR_IA32_{U,S}_CET: Control CET settings for user mode and suervisor
>                         mode respectively.
> 
>   - MSR_IA32_PL{0,1,2,3}_SSP: Store shadow stack pointers for CPL levels.
> 
>   - MSR_IA32_INT_SSP_TAB: Stores base address of shadow stack pointer
>                           table.
> 
OK, will change it in next version.
> > Two XSAVES state components are introduced for CET:
> > IA32_XSS:[bit 11] - bit for save/restor user mode CET states
> > IA32_XSS:[bit 12] - bit for save/restor supervisor mode CET states.
> 
> Likewise, use a consistent list format.
> 
> > 6 VMCS fields are introduced for CET, {HOST,GUEST}_S_CET is to store
> > CET settings in supervisor mode. {HOST,GUEST}_SSP is to store shadow
> > stack pointers in supervisor mode. {HOST,GUEST}_INTR_SSP_TABLE is to
> > store base address of shadow stack pointer table.
> 
> It'd probably be easier to use a list format for the fields, e.g.:
> 
> 6 VMCS fields are introduced for CET:
> 
>   - {HOST,GUEST}_S_CET: stores CET settings for supervisor mode.
> 
>   - {HOST,GUEST}_SSP: stores shadow stack pointers for supervisor mode.
> 
>   - {HOST,GUEST}_INTR_SSP_TABLE: stores the based address of the shadow
>                                  stack pointer table.
> 
OK, will modify it.
> > If VM_EXIT_LOAD_HOST_CET_STATE = 1, the host's CET MSRs are restored
> > from below VMCS fields at VM-Exit:
> > - HOST_S_CET
> > - HOST_SSP
> > - HOST_INTR_SSP_TABLE
> 
> Personal preference, I like indenting lists like this with a space or two
> so that the list is clearly delineated.
Good suggestion, thanks!
> 
> > If VM_ENTRY_LOAD_GUEST_CET_STATE = 1, the guest's CET MSRs are loaded
> > from below VMCS fields at VM-Entry:
> > - GUEST_S_CET
> > - GUEST_SSP
> > - GUEST_INTR_SSP_TABLE
> > 
> > Apart from VMCS auto-load fields, KVM calls kvm_load_guest_fpu() and
> > kvm_put_guest_fpu() to save/restore the guest CET MSR states at
> > VM exit/entry. XSAVES/XRSTORS are executed underneath these functions
> > if they are supported. The CET xsave area is consolidated with other
> > XSAVE components in thread_struct.fpu field.
> > 
> > When context switch happens during task switch/interrupt/exception etc.,
> > Kernel also relies on above functions to switch CET states properly.
> 
> These paragraphs about the FPU and KVM behavior don't belong in this
> patch.

OK. looks like it's redundant, will remve it.
>  
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> 
> Co-developed-by needs to be accompanied by a SOB.  And your SOB should
> be last since you sent the patch.  This comment applies to all patches.
> 
> See "12) When to use Acked-by:, Cc:, and Co-developed-by:" in
> Documentation/process/submitting-patches.rst for details (I recommend
> looking at a v5.2-rc* version, a docs update was merged for v5.2).
Got it, will change all the signatures.
