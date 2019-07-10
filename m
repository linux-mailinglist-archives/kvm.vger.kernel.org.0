Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A1B64D34
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 22:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbfGJULr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 16:11:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:48183 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfGJULr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 16:11:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 13:11:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,475,1557212400"; 
   d="scan'208";a="159863794"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga008.jf.intel.com with ESMTP; 10 Jul 2019 13:11:46 -0700
Date:   Wed, 10 Jul 2019 13:11:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, jmattson@google.com
Subject: Re: [PATCH 2/5] KVM: nVMX: Skip VM-Exit Control vmentry checks that
 are necessary only if VMCS12 is dirty
Message-ID: <20190710201146.GG4348@linux.intel.com>
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
 <20190707071147.11651-3-krish.sadhukhan@oracle.com>
 <f42d3eac-8353-3d90-a621-ca82460b66e7@redhat.com>
 <9e0b1aba-8cf6-733c-dc4d-63aa61fcddd8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9e0b1aba-8cf6-733c-dc4d-63aa61fcddd8@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 12:18:55PM -0700, Krish Sadhukhan wrote:
> 
> On 7/10/19 7:28 AM, Paolo Bonzini wrote:
> >On 07/07/19 09:11, Krish Sadhukhan wrote:
> >>  	if (!vmx_control_verify(vmcs12->vm_exit_controls,
> >>  				vmx->nested.msrs.exit_ctls_low,
> >>-				vmx->nested.msrs.exit_ctls_high) ||
> >>-	    nested_vmx_check_exit_msr_switch_controls(vcpu, vmcs12))
> >>+				vmx->nested.msrs.exit_ctls_high))
> >>+		return -EINVAL;
> >>+
> >Exit controls are not shadowed, are they?
> 
> No, they aren't.   However, I see that prepare_vmcs02_constant_state() which
> is called in the path of prepare_vmcs02_early_full() writes those Exit
> Control fields:
> 
>        vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
>         vmcs_write64(VM_EXIT_MSR_LOAD_ADDR,
> __pa(vmx->msr_autoload.host.val));
>         vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR,
> __pa(vmx->msr_autoload.guest.val));

That's writing L0's values into vmcs02 when vmcs02 is first used.  L1's
MSR load lists are processed purely in software, e.g. nested_vmx_load_msr().
The vmcs12 entries are consumed by KVM on every nested transition to
emulate the load/store functionality, but the validity of the *controls*
only needs to be checked when vmcs12 is dirty.

> 
> 
> Should we add these fields to the shadow list then ?
> 
> >
> >Paolo
