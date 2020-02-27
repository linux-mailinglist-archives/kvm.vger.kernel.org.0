Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4FDB1729B7
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 21:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgB0Uvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 15:51:54 -0500
Received: from mga05.intel.com ([192.55.52.43]:41482 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgB0Uvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 15:51:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 12:51:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="272366192"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 27 Feb 2020 12:51:53 -0800
Date:   Thu, 27 Feb 2020 12:51:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH] KVM: nVMX: Consult only the "basic" exit reason when
 routing nested exit
Message-ID: <20200227205153.GC17014@linux.intel.com>
References: <20200227174430.26371-1-sean.j.christopherson@intel.com>
 <ee8c5eb6-9e3d-620b-d51f-bf0534a05d43@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee8c5eb6-9e3d-620b-d51f-bf0534a05d43@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 27, 2020 at 12:08:55PM -0800, Krish Sadhukhan wrote:
> 
> On 2/27/20 9:44 AM, Sean Christopherson wrote:
> >Consult only the basic exit reason, i.e. bits 15:0 of vmcs.EXIT_REASON,
> >when determining whether a nested VM-Exit should be reflected into L1 or
> >handled by KVM in L0.
> >
> >For better or worse, the switch statement in nested_vmx_exit_reflected()
> >currently defaults to "true", i.e. reflects any nested VM-Exit without
> >dedicated logic.  Because the case statements only contain the basic
> >exit reason, any VM-Exit with modifier bits set will be reflected to L1,
> >even if KVM intended to handle it in L0.
> >
> >Practically speaking, this only affects EXIT_REASON_MCE_DURING_VMENTRY,
> >i.e. a #MC that occurs on nested VM-Enter would be incorrectly routed to
> >L1, as "failed VM-Entry" is the only modifier that KVM can currently
> >encounter.  The SMM modifiers will never be generated as KVM doesn't
> >support/employ a SMI Transfer Monitor.  Ditto for "exit from enclave",
> >as KVM doesn't yet support virtualizing SGX, i.e. it's impossible to
> >enter an enclave in a KVM guest (L1 or L2).
> 
> 
> It seems nested_vmx_exit_reflected() deals only with the basic exit reason.
> If it doesn't need anything beyond bits 15:0, may be vmx_handle_exit() can
> pass just the base exit reason ?

Argh.  I was going to simply respond with "It traces exit_reason via
trace_kvm_nested_vmexit().", but then I looked at the tracing code :-(

The tracepoints that print the names of the VM-Exit are flawed in the sense
that they'll always print the raw value for VM-Exits with modifiers.  E.g.
a consistency check VM-Exit on invalid guest state will print 0x80000021
instead of INVALID_STATE.

Stripping bits 31:16 when invoking the tracepoint would fix the immediate
issue, but I'm not sure I like that approach because doing so drops
information that could potentially be quite helpful, e.g. if nested VM-Exit
injection injected EXIT_REASON_MSR_LOAD_FAIL without also setting
VMX_EXIT_REASONS_FAILED_VMENTRY, which could break/confuse the L1 VMM.
I'm also not remotely confident that we won't screw this up again in the
future :-)

So part of me thinks the best way to resolve the printing would be to
modify VMX_EXIT_REASONS to do "| VMX_EXIT_REASONS_FAILED_VMENTRY" where
appropriate, i.e. on INVALID_STATE, MSR_LOAD_FAIL and MCE_DURING_VMENTRY.
The downside of that approach is it breaks again when new modifiers come
along, e.g. SGX's ENCLAVE_EXIT.  But again, the modifier is likely useful
information.

I think the most foolproof and informative way to handle this would be to
add a macro and/or helper function, e.g. kvm_print_vmx_exit_reason(), to
wrap __print_symbolic(__entry->exit_code, VMX_EXIT_REASONS) so that it
prints both the name of the basic exit reason as well as the names for
any modifiers.

TL;DR: I still like this patch as is, especially since it'll be easy to
backport.  I'll send a separate patch for the tracepoint issue.

