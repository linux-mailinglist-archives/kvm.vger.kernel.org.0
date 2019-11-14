Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABD5FCDB8
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 19:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfKNSey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 13:34:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:16529 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfKNSey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 13:34:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 10:34:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="207881915"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2019 10:34:53 -0800
Date:   Thu, 14 Nov 2019 10:34:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 05/16] KVM: VMX: Drop initialization of
 IA32_FEATURE_CONTROL MSR
Message-ID: <20191114183453.GI24045@linux.intel.com>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191022000820.1854-1-sean.j.christopherson@intel.com>
 <59cbc79a-fb06-f689-aa24-0ba923783345@redhat.com>
 <20191022151622.GA2343@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022151622.GA2343@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 22, 2019 at 08:16:22AM -0700, Sean Christopherson wrote:
> On Tue, Oct 22, 2019 at 12:51:01PM +0200, Paolo Bonzini wrote:
> > On 22/10/19 02:08, Sean Christopherson wrote:
> > > Remove the code to initialize IA32_FEATURE_CONTROL MSR when KVM is
> > > loaded now that the MSR is initialized during boot on all CPUs that
> > > support VMX, i.e. can possibly load kvm_intel.
> > > 
> > > Reviewed-by: Jim Mattson <jmattson@google.com>
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c | 48 +++++++++++++++++-------------------------
> > >  1 file changed, 19 insertions(+), 29 deletions(-)
> > 
> > I am still not sure about this...  Enabling VMX is adding a possible
> > attack vector for the kernel, we should not do it unless we plan to do a
> > VMXON.
> 
> An attacker would need arbitrary cpl0 access to toggle CR4.VMXE and do
> VMXON (and VMLAUNCH), would an extra WRMSR really slow them down?
> 
> And practically speaking, how often do you encounter systems whose
> firmware leaves IA32_FEATURE_CONTROL unlocked?
> 
> > Why is it so important to operate with locked
> > IA32_FEATURE_CONTROL (so that KVM can enable VMX and the kernel can
> > still enable SGX if desired).
> 
> For simplicity.  The alternative that comes to mind is to compute the
> desired MSR value and write/lock the MSR on demand, e.g. add a sequence
> similar to KVM's hardware_enable_all() for SGX, but that's a fair amount
> of complexity for marginal benefit (IMO).
> 
> If a user really doesn't want VMX enabled, they can clear the feature bit
> via the clearcpuid kernel param. 
> 
> That being said, enabling VMX in IA32_FEATURE_CONTROL if and only if
> IS_ENABLED(CONFIG_KVM) is true would be an easy enhancement.

Paolo, any follow up thoughts on this approach?
