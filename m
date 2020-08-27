Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B893255020
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 22:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgH0UkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 16:40:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:18712 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgH0UkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 16:40:22 -0400
IronPort-SDR: piM6LJS9zU7mKyQXFa6eBBcjK5UCiuIwqdvgQJ/nMUOoNeiBK8Ds8Q2ThH8pLgiKi3njjikUSc
 Dkuwh244CuCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="136109503"
X-IronPort-AV: E=Sophos;i="5.76,361,1592895600"; 
   d="scan'208";a="136109503"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2020 13:40:22 -0700
IronPort-SDR: a8Epu/Guyx6APMv+Sh/B1GyPQ9QA0SrYmmogmr/rAyd5mLaH3XRzPMl35Du5jMpJFqB/ApEObC
 juwatNfz5BzQ==
X-IronPort-AV: E=Sophos;i="5.76,361,1592895600"; 
   d="scan'208";a="475378700"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2020 13:40:22 -0700
Date:   Thu, 27 Aug 2020 13:40:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Peter Shier <pshier@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: nVMX: fix the layout of struct
 kvm_vmx_nested_state_hdr
Message-ID: <20200827204020.GE22351@sjchrist-ice>
References: <20200713162206.1930767-1-vkuznets@redhat.com>
 <CALMp9eR+DYVH0UZvbNKUNArzPdf1mvAoxakzj++szaVCD0Fcpw@mail.gmail.com>
 <CALMp9eRGStwpYbeHbxo79zF9EyQ=35wwhNt03rjMHMDD9a5G0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRGStwpYbeHbxo79zF9EyQ=35wwhNt03rjMHMDD9a5G0A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 27, 2020 at 11:25:25AM -0700, Jim Mattson wrote:
> On Mon, Jul 13, 2020 at 11:23 AM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Mon, Jul 13, 2020 at 9:22 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > >
> > > Before commit 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer
> > > migration") struct kvm_vmx_nested_state_hdr looked like:
> > >
> > > struct kvm_vmx_nested_state_hdr {
> > >         __u64 vmxon_pa;
> > >         __u64 vmcs12_pa;
> > >         struct {
> > >                 __u16 flags;
> > >         } smm;
> > > }
> > >
> > > The ABI got broken by the above mentioned commit and an attempt
> > > to fix that was made in commit 83d31e5271ac ("KVM: nVMX: fixes for
> > > preemption timer migration") which made the structure look like:
> > >
> > > struct kvm_vmx_nested_state_hdr {
> > >         __u64 vmxon_pa;
> > >         __u64 vmcs12_pa;
> > >         struct {
> > >                 __u16 flags;
> > >         } smm;
> > >         __u32 flags;
> > >         __u64 preemption_timer_deadline;
> > > };
> > >
> > > The problem with this layout is that before both changes compilers were
> > > allocating 24 bytes for this and although smm.flags is padded to 8 bytes,
> > > it is initialized as a 2 byte value. Chances are that legacy userspaces
> > > using old layout will be passing uninitialized bytes which will slip into
> > > what is now known as 'flags'.
> > >
> > > Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Fixes: 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration")
> > > Fixes: 83d31e5271ac ("KVM: nVMX: fixes for preemption timer migration")
> > > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >
> > Oops!
> >
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> 
> Whatever happened to this?

Paolo pushed an alternative solution for 5.8, commit 5e105c88ab485 ("KVM:
nVMX: check for invalid hdr.vmx.flags").  His argument was that there was
no point in adding proper padding since we already broke the ABI, i.e.
damage done.

So rather than pad the struct, which doesn't magically fix the ABI for old
userspace, just check for unsupported flags.  That gives decent odds of
failing the ioctl() for old userspace if it's passing garbage (through no
fault of its own), prevents new userspace from setting unsupported flags,
and allows KVM to grow the struct by conditioning consumption of new fields
on an associated flag.
