Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4302725B844
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 03:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgICBZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 21:25:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:30095 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbgICBZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 21:25:08 -0400
IronPort-SDR: MfJD0QIoKhJFb8mhUFnLuTGYfT9U0TMYeaSNJzBv5Fm31VrCwuVeQ1Izxb7vo4CXNx7lIB6Jsh
 iK2/36tQ72Xw==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="158490058"
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="158490058"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 18:25:08 -0700
IronPort-SDR: 9OlQOLNTCVBaZ9smIxIy+2Xy0DizbfRWbdftxIkIbKSB/aWKDLcLTv6QEI0MLsXDUxULRXx6fY
 rtAbdqpu0zVA==
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="326015912"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 18:25:08 -0700
Date:   Wed, 2 Sep 2020 18:25:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC v2 2/2] KVM: VMX: Enable bus lock VM exit
Message-ID: <20200903012506.GM11695@sjchrist-ice>
References: <20200817014459.28782-1-chenyi.qiang@intel.com>
 <20200817014459.28782-3-chenyi.qiang@intel.com>
 <87sgc1x4yn.fsf@vitty.brq.redhat.com>
 <20200902224405.GK11695@sjchrist-ice>
 <2e12df9d-4d56-d6c2-3470-9c990ab722c5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e12df9d-4d56-d6c2-3470-9c990ab722c5@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 03, 2020 at 08:52:41AM +0800, Xiaoyao Li wrote:
> On 9/3/2020 6:44 AM, Sean Christopherson wrote:
> > On Tue, Sep 01, 2020 at 10:43:12AM +0200, Vitaly Kuznetsov wrote:
> > > > +			vcpu->arch.bus_lock_detected = true;
> > > > +		} else {
> > > > +			vcpu->arch.bus_lock_detected = false;
> > > 
> > > This is a fast path so I'm wondering if we can move bus_lock_detected
> > > clearing somewhere else.
> > 
> > Why even snapshot vmx->exit_reason.bus_lock_detected?  I don't see any
> > reason why vcpu_enter_guest() needs to handle the exit to userspace, e.g.
> > it's just as easily handled in VMX code.
> 
> Because we want to handle the exit to userspace only in one place, i.e.,
> after kvm_x86_ops.handle_exit(vcpu, exit_fastpath). Otherwise, we would have
> to check vmx->exit_reason.bus_lock_detected in every other handler, at least
> in those can preempt the bus lock VM-exit theoretically.

That's not hard to do in vmx.c, e.g.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0316b86bad43a..ea2fed7f21565 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5677,7 +5677,7 @@ void dump_vmcs(void)
  * The guest has exited.  See if we can fix it or if we need userspace
  * assistance.
  */
-static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
        struct vcpu_vmx *vmx = to_vmx(vcpu);
        u32 exit_reason = vmx->exit_reason;
@@ -5822,6 +5822,22 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
        return 0;
 }

+static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+{
+       int ret = __vmx_handle_exit(vcpu, exit_fastpath);
+
+       if (vmx->exit_reason.bus_lock_detected) {
+               if (ret)
+                       vcpu->run->exit_reason = KVM_EXIT_BUS_LOCK;
+               else
+                       vcpu->run->flags |= KVM_RUN_BUS_LOCK;
+               return 0;
+       }
+
+       vcpu->run->flags &= ~KVM_RUN_BUS_LOCK;
+       return ret;
+}
+
 /*
  * Software based L1D cache flush which is used when microcode providing
  * the cache control MSR is not loaded.

