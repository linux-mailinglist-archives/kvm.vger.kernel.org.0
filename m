Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C42A3F16DB
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 11:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237692AbhHSJ7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 05:59:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:23366 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236149AbhHSJ7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 05:59:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="216518025"
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="216518025"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 02:58:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="505969818"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 19 Aug 2021 02:58:37 -0700
Message-ID: <3ac79d874fb32c6472151cf879edfb2f1b646abf.camel@linux.intel.com>
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        yu.c.zhang@linux.intel.com
Date:   Thu, 19 Aug 2021 17:58:36 +0800
In-Reply-To: <YR2Tf9WPNEzrE7Xg@google.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
         <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
         <YRvbvqhz6sknDEWe@google.com>
         <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
         <YR2Tf9WPNEzrE7Xg@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-08-18 at 23:10 +0000, Sean Christopherson wrote:
> On Wed, Aug 18, 2021, Robert Hoo wrote:
> > > Limiting this to VMREAD/VMWRITE means we shouldn't need a bitmap
> > > and
> > > can use a more static lookup, e.g. a switch statement.  
> > 
> > Emm, hard for me to choose:
> > 
> > Your approach sounds more efficient for CPU: Once VMX MSR's
> > updated, no
> > bother to update the bitmap. Each field's existence check will
> > directly
> > consult related VMX MSR. Well, the switch statement will be long...
> 
> How long?  Honest question, off the top of my head I don't have a
> feel for how
> many fields conditionally exist.

Per my just manual count, ~51 fields till today.
> 
> > My this implementation: once VMX MSR's updated, the update needs to
> > be
> > passed to bitmap, this is 1 extra step comparing to aforementioned
> > above. But, later, when query field existence, especially the those
> > consulting vm{entry,exit}_ctrl, they usually would have to consult
> > both
> > MSRs if otherwise no bitmap, and we cannot guarantee if in the
> > future
> > there's no more complicated dependencies. If using bitmap, this
> > consult
> > is just 1-bit reading. If no bitmap, several MSR's read and compare
> > happen.
> 
> Yes, but the bitmap is per-VM and likely may or may not be cache-hot
> for back-to-back
> VMREAD/VMWRITE to different fields, whereas the shadow controls are
> much more likely
> to reside somewhere in the caches.

Sorry I don't quite understand the "shadow controls" here. Do you mean
shadow VMCS? what does field existence to do with shadow VMCS? emm,
here you indeed remind me a questions: what if L1 VMREAD/VMWRITE a
shadow field that doesn't exist?

If your here "shadow controls" means nested_vmx.nested_vmx_msrs,
they're like bitmap, per-vCPU, I think no essential difference for
their cache hit possibilities. BTW, till current VMCS12 size, the
bitmap can be contained in a cache line.
> 
> > And, VMX MSR --> bitmap, usually happens only once when vCPU model
> > is
> > settled. But VMRead/VMWrite might happen frequently, depends on
> > guest
> > itself. I'd rather leave complicated comparison in former than in
> > later.
> 
> I'm not terribly concerned about the runtime performance, it's the
> extra per-VM
> allocation for something that's not thaaat interesting that I don't
> like.

OK, it's even further, per-vCPU/vmx ;)
> 
> And for performance, most of the frequently accessed VMCS fields will
> be shadowed
> anyways, i.e. won't VM-Exit in the first place.
> 
> And that brings up another wrinkle.  The shadow VMCS bitmaps are
> global across
> all VMs, 
OK, that's the problem. Ideally, it should be per-VM or per-vCPU, but
that means each VM/vCPU will consume 2 more pages for vm{read,write}
bitmap.

> e.g. if the preemption timer is supported in hardware but hidden from
> L1, then a misbehaving L1 can VMREAD/VMWRITE the field even with this
> patch.
> If it was just the preemption timer we could consider disabling
> shadow VMCS for
> the VM ifthe timer exists but is hidden from L1, but GUEST_PML_INDEX
> and
> GUEST_INTR_STATUS are also conditional :-(

Yes, if the vm{read,write}-bitmap is KVM global, cannot implement field
existence with shadow VMCS functioning. I don't think it's right. It
just did't cause any trouble until we consider today's field existence
implementation.

If we stringently implement this per spec, i.e. each VMCS has its own
vm{read,write}-bitmap, or at least each VM has its own, then doable.
> 
> Maybe there's a middle ground, e.g. let userspace tell KVM which
> fields it plans
> on exposing to L1, use that to build the bitmaps, and disable shadow
> VMCS if
> userspace creates VMs that don't match the specified configuration.  

Here "specific configuration" means: if KVM vm{write,read}-bitmap
enables some L1 non-exist field shadow read/write, we turn of shadow
VMCS for that VM, right? I guess user would rather abandon this field
existence check for VMCS shadowing.


> Burning
> three more pages per VM isn't very enticing...

Why 3 more? I count 2 more pages, i.e. vm{read,write}-bitmap.
And, just 2 pages (8KB) per VM isn't huge consumption, is it? ;)

> 
> This is quite the complicated mess for something I'm guessing no one
> actually
> cares about.  At what point do we chalk this up as a virtualization
> hole and
> sweep it under the rug?
Yes, too complicated, beyond my imagination of vmcs12 field existence
implementation at first. I guess perhaps the original guy who hard
coded nested_msr.vmcs_enum had tried this before ;)


