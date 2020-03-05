Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BFD17AEED
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 20:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgCETZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 14:25:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:59653 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgCETZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 14:25:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 11:25:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,519,1574150400"; 
   d="scan'208";a="413628452"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 05 Mar 2020 11:25:32 -0800
Date:   Thu, 5 Mar 2020 11:25:32 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pu Wen <puwen@hygon.cn>
Subject: Re: [PATCH v2 4/7] KVM: x86: Fix CPUID range checks for Hypervisor
 and Centaur classes
Message-ID: <20200305192532.GN11500@linux.intel.com>
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
 <20200305013437.8578-5-sean.j.christopherson@intel.com>
 <CALMp9eRRWZ54kzMXdTqRCy2KmaUAq+HVVVzbxJNVdgktg65XCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRRWZ54kzMXdTqRCy2KmaUAq+HVVVzbxJNVdgktg65XCA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 05, 2020 at 10:43:51AM -0800, Jim Mattson wrote:
> On Wed, Mar 4, 2020 at 5:34 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Rework the masking in the out-of-range CPUID logic to handle the
> > Hypervisor sub-classes, as well as the Centaur class if the guest
> > virtual CPU vendor is Centaur.
> >
> > Masking against 0x80000000 only handles basic and extended leafs, which
> > results in Hypervisor range checks being performed against the basic
> > CPUID class, and Centuar range checks being performed against the
> > Extended class.  E.g. if CPUID.0x40000000.EAX returns 0x4000000A and
> > there is no entry for CPUID.0x40000006, then function 0x40000006 would
> > be incorrectly reported as out of bounds.
> >
> > While there is no official definition of what constitutes a class, the
> > convention established for Hypervisor classes effectively uses bits 31:8
> > as the mask by virtue of checking for different bases in increments of
> > 0x100, e.g. KVM advertises its CPUID functions starting at 0x40000100
> > when HyperV features are advertised at the default base of 0x40000000.
> >
> > The bad range check doesn't cause functional problems for any known VMM
> > because out-of-range semantics only come into play if the exact entry
> > isn't found, and VMMs either support a very limited Hypervisor range,
> > e.g. the official KVM range is 0x40000000-0x40000001 (effectively no
> > room for undefined leafs) or explicitly defines gaps to be zero, e.g.
> > Qemu explicitly creates zeroed entries up to the Cenatur and Hypervisor
> > limits (the latter comes into play when providing HyperV features).
> >
> > The bad behavior can be visually confirmed by dumping CPUID output in
> > the guest when running Qemu with a stable TSC, as Qemu extends the limit
> > of range 0x40000000 to 0x40000010 to advertise VMware's cpuid_freq,
> > without defining zeroed entries for 0x40000002 - 0x4000000f.
> >
> > Note, documentation of Centaur/VIA CPUs is hard to come by.  Designating
> > 0xc0000000 - 0xcfffffff as the Centaur class is a best guess as to the
> > behavior of a real Centaur/VIA CPU.
> 
> Don't forget Transmeta's CPUID range at 0x80860000 through 0x8086FFFF!

Hmm, is it actually needed here?  KVM doesn't advertise support for that
range in KVM_GET_SUPPORTED_CPUID.  That's also why I limited the Centaur
range to vendor==CENTAUR, as KVM_GET_SUPPORTED_CPUID enumerates the
Centaur range if and only if the host CPU is Centaur.
