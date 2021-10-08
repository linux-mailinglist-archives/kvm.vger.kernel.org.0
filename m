Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A924265D8
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 10:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhJHIY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 04:24:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:36355 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233518AbhJHIY6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 04:24:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="213603531"
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="213603531"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 01:23:03 -0700
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="489370029"
Received: from lifanlin-mobl1.ccr.corp.intel.com (HELO localhost) ([10.255.31.40])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 01:22:59 -0700
Date:   Fri, 8 Oct 2021 16:23:02 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
Message-ID: <20211008082302.txckaasmsystigeu@linux.intel.com>
References: <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
 <YTI7K9RozNIWXTyg@google.com>
 <64aad01b6bffd70fa3170cf262fe5d7c66f6b2d4.camel@linux.intel.com>
 <YVx6Oesi7X3jfnaM@google.com>
 <CALMp9eRyhAygfh1piNEDE+WGVzK1cTWJJR1aC_zqn=c2fy+c-A@mail.gmail.com>
 <YVySdKOWTXqU4y3R@google.com>
 <CALMp9eQvRYpZg+G7vMcaCq0HYPDfZVpPtDRO9bRa0w2fyyU9Og@mail.gmail.com>
 <YVy6gj2+XsghsP3j@google.com>
 <CALMp9eT+uAvPv7LhJKrJGDN31-aVy6DYBrP+PUDiTk0zWuCX4g@mail.gmail.com>
 <YVzeJ59/yCpqgTX2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVzeJ59/yCpqgTX2@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 05, 2021 at 11:22:15PM +0000, Sean Christopherson wrote:
> On Tue, Oct 05, 2021, Jim Mattson wrote:
> > On Tue, Oct 5, 2021 at 1:50 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Oct 05, 2021, Jim Mattson wrote:
> > > > On Tue, Oct 5, 2021 at 10:59 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Tue, Oct 05, 2021, Jim Mattson wrote:
> > > > > > On Tue, Oct 5, 2021 at 9:16 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > > > >
> > > > > > > On Tue, Sep 28, 2021, Robert Hoo wrote:
> > > > > > > > On Fri, 2021-09-03 at 15:11 +0000, Sean Christopherson wrote:
> > > > > > > >       You also said, "This is quite the complicated mess for
> > > > > > > > something I'm guessing no one actually cares about.  At what point do
> > > > > > > > we chalk this up as a virtualization hole and sweep it under the rug?"
> > > > > > > > -- I couldn't agree more.
> > > > > > >
> > > > > > > ...
> > > > > > >
> > > > > > > > So, Sean, can you help converge our discussion and settle next step?
> > > > > > >
> > > > > > > Any objection to simply keeping KVM's current behavior, i.e. sweeping this under
> > > > > > > the proverbial rug?
> > > > > >
> > > > > > Adding 8 KiB per vCPU seems like no big deal to me, but, on the other
> > > > > > hand, Paolo recently argued that slightly less than 1 KiB per vCPU was
> > > > > > unreasonable for VM-exit statistics, so maybe I've got a warped
> > > > > > perspective. I'm all for pedantic adherence to the specification, but
> > > > > > I have to admit that no actual hypervisor is likely to care (or ever
> > > > > > will).
> > > > >
> > > > > It's not just the memory, it's also the complexity, e.g. to get VMCS shadowing
> > > > > working correctly, both now and in the future.
> > > >
> > > > As far as CPU feature virtualization goes, this one doesn't seem that
> > > > complex to me. It's not anywhere near as complex as virtualizing MTF,
> > > > for instance, and KVM *claims* to do that! :-)
> > >
> > > There aren't many things as complex as MTF.  But unlike MTF, this behavior doesn't
> > > have a concrete use case to justify the risk vs. reward.  IMO the odds of us breaking
> > > something in KVM for "normal" use cases are higher than the odds of an L1 VMM breaking
> > > because a VMREAD/VMWRITE didn't fail when it technically should have failed.
> > 
> > Playing devil's advocate here, because I totally agree with you...
> > 
> > Who's to say what's "normal"? It's a slippery slope when we start
> > making personal value judgments about which parts of the architectural
> > specification are important and which aren't.
> 
> I agree, but in a very similar case Intel chose to take an erratum instead of
> fixing what was in all likelihood a microcode bug, i.e. could have been patched
> in the field.  So it's not _just_ personal value judgment, though it's definitely
> that too :-)
> 
> I'm not saying I'd actively oppose support for strict VMREAD/VMWRITE adherence
> to the vCPU model, but I'm also not going to advise anyone to go spend their time
> implementing a non-trivial fix for behavior that, AFAIK, doesn't adversely affect
> any real world use cases.
> 

Thank you all for the discussion, Sean & Jim.

Could we draw a conclusion to just keep KVM as it is now? If yes, how about we
depricate the check against max index value from MSR_IA32_VMX_VMCS_ENUM in vmx.c 
of the kvm-unit-test?

After all, we have not witnessed any real system doing so.

E.g.,

diff --git a/x86/vmx.c b/x86/vmx.c
index f0b853a..63623e5 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -380,8 +380,7 @@ static void test_vmwrite_vmread(void)
        vmcs_enum_max = (rdmsr(MSR_IA32_VMX_VMCS_ENUM) & VMCS_FIELD_INDEX_MASK)
                        >> VMCS_FIELD_INDEX_SHIFT;
        max_index = find_vmcs_max_index();
-       report(vmcs_enum_max == max_index,
-              "VMX_VMCS_ENUM.MAX_INDEX expected: %x, actual: %x",
+       printf("VMX_VMCS_ENUM.MAX_INDEX expected: %x, actual: %x",
               max_index, vmcs_enum_max);

        assert(!vmcs_clear(vmcs));

B.R.
Yu
