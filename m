Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6252F139CA7
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 23:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgAMWfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 17:35:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:3294 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgAMWfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 17:35:05 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 14:35:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,430,1571727600"; 
   d="scan'208";a="422952285"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jan 2020 14:35:04 -0800
Date:   Mon, 13 Jan 2020 14:35:04 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] Handle monitor trap flag during instruction emulation
Message-ID: <20200113223504.GA14928@linux.intel.com>
References: <20200113221053.22053-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113221053.22053-1-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 13, 2020 at 02:10:50PM -0800, Oliver Upton wrote:
> KVM already provides guests the ability to use the 'monitor trap flag'
> VM-execution control. Support for this flag is provided by the fact that
> KVM unconditionally forwards MTF VM-exits to the guest (if requested),
> as KVM doesn't utilize MTF. While this provides support during hardware
> instruction execution, it is insufficient for instruction emulation.
> 
> Should L0 emulate an instruction on the behalf of L2, L0 should also
> synthesize an MTF VM-exit into L1, should control be set.
> 
> The first patch fixes the handling of #DB payloads for both Intel and
> AMD. To support MTF, KVM must also populate the 'pending debug
> exceptions' field, rather than directly manipulating the debug register
> state. Additionally, the exception payload associated with #DB is said
> to be compatible with the 'pending debug exceptions' field in VMX. This
> does not map cleanly into an AMD DR6 register, requiring bit 12 (enabled
> breakpoint on Intel, reserved MBZ on AMD) to be masked off.
> 
> The second patch implements MTF under instruction emulation by adding
> vendor-specific hooks to kvm_skip_emulated_instruction(). Should any
> non-debug exception be pending before this call, MTF will follow event
> delivery. Otherwise, an MTF VM-exit may be synthesized directly into L1.
> 
> Third patch introduces tests to kvm-unit-tests. These tests path both
> under virtualization and on bare-metal.
> 
> Oliver Upton (2):
>   KVM: x86: Add vendor-specific #DB payload delivery
>   KVM: x86: Emulate MTF when performing instruction emulation
> 
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/svm.c              | 25 +++++++++++++++++++++
>  arch/x86/kvm/vmx/nested.c       |  2 +-
>  arch/x86/kvm/vmx/nested.h       |  5 +++++
>  arch/x86/kvm/vmx/vmx.c          | 39 ++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/x86.c              | 27 ++++++-----------------
>  6 files changed, 78 insertions(+), 22 deletions(-)
> 
> -- 

What commit is this series based on?  It doesn't apply cleanly on the
current kvm/master or kvm/queue.
