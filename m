Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551041BE225
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 17:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgD2PLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 11:11:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:34434 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbgD2PLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 11:11:10 -0400
IronPort-SDR: ElUws5vpdG3KgsCcWkiWQMsBBSgaUdJlBN1IViucBAmcpqOeMuxxhF7+M6irM7ijffaBk3Dw/Z
 zQj17VCE/N4g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 08:11:09 -0700
IronPort-SDR: djrkxjwSWyZod30Qu1TcOUeLgAzClPtfzriYb4a+RxiOOFVGRXgNirZbBx315VcBzBIryl8t/D
 PV6a0xbc0xBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="276199069"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 29 Apr 2020 08:11:08 -0700
Date:   Wed, 29 Apr 2020 08:10:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] KVM: nVMX: vmcs.SYSENTER optimization and "fix"
Message-ID: <20200429151057.GB15992@linux.intel.com>
References: <20200428231025.12766-1-sean.j.christopherson@intel.com>
 <CALMp9eQLPPAzM+vsrSMO6thOnCRpn6ab+VOh-1UKZug8==ME8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQLPPAzM+vsrSMO6thOnCRpn6ab+VOh-1UKZug8==ME8g@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 04:45:25PM -0700, Jim Mattson wrote:
> On Tue, Apr 28, 2020 at 4:10 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Patch 1 is a "fix" for handling SYSENTER_EIP/ESP in L2 on a 32-bit vCPU.
> > The primary motivation is to provide consistent behavior after patch 2.
> >
> > Patch 2 is essentially a re-submission of a nested VMX optimization to
> > avoid redundant VMREADs to the SYSENTER fields in the nested VM-Exit path.
> >
> > After patch 2 and without patch 1, KVM would end up with weird behavior
> > where L1 and L2 would only see 32-bit values for their own SYSENTER_E*P
> > MSRs, but L1 could see a 64-bit value for L2's MSRs.
> >
> > Sean Christopherson (2):
> >   KVM: nVMX: Truncate writes to vmcs.SYSENTER_EIP/ESP for 32-bit vCPU
> >   KVM: nVMX: Drop superfluous VMREAD of vmcs02.GUEST_SYSENTER_*
> >
> >  arch/x86/kvm/vmx/nested.c |  4 ----
> >  arch/x86/kvm/vmx/vmx.c    | 18 ++++++++++++++++--
> >  2 files changed, 16 insertions(+), 6 deletions(-)
> 
> It seems like this could be fixed more generally by truncating
> natural-width fields on 32-bit vCPUs in handle_vmwrite(). However,
> that also would imply that we can't shadow any natural-width fields on
> a 32-bit vCPU.

handle_vmwrite() and handle_vmread() already correctly handle truncating
writes/reads when L1 isn't in 64-bit mode.

This path is effectively out-of-band, for lack of a better phrase.  The
WRMSR is intercepted and the data is stuffed into vmcs02.  Without these
patches, the effective L2 state depends on the underlying hardware
capabilities, e.g. L2 gets 64-bit behavior if L0 is a 64-bit CPU, and
32-bit behavior if L0 is a 32-bit CPU.  It's "wrong", but consistent as the
value seen by L2 is the same value that is saved into vmcs12.  Of course in
the 64-bit CPU case, L1 can't actually see the full value via VMREAD as the
vCPU is 32-bit, but at least the underlying memory/machinery is consistent.

With just patch 2, the above would still be true for 64-bit L0, but for
32-bit L0 it would result in L2 seeing a 32-bit value while saving a 64-bit
value into vmcs12.  Again, L1 wouldn't see the 64-bit value when using
VMREAD, but the value in memory is still wrong-ish.

Truncating the value on WRMSR interception makes the behavior fully
dependent on the vCPU capabilities, i.e. what L2 sees is the same value
that's saved into vmcs12, which is the same value seen by VMREAD in L1,
irrespective of whether L0 is 64-bit or 32-bit.
