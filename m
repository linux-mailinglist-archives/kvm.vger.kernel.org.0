Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D1C21A990
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 23:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgGIVMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 17:12:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:48641 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbgGIVMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 17:12:54 -0400
IronPort-SDR: zYmXNkegbqZW8ttBVqW+Fb9OPMitK+9NJngz/+TbgxgVnoU3D8mdRsJjjFX5DF5hHeWbfAUSwC
 L4phwt6RBvPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="147200600"
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="147200600"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 14:12:53 -0700
IronPort-SDR: HL1NxPNKrlVgGsyiHBtUvZOy7JZ9ONOwA/QDyK5kyklSsh/Edk5Q8Scsc3DgwBI0El5KtpVVxg
 uqD2y2SHHsOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="358569577"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 09 Jul 2020 14:12:53 -0700
Date:   Thu, 9 Jul 2020 14:12:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Wayne Boyer <wayne.boyer@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add capability to zap only sptes for the
 affected memslot
Message-ID: <20200709211253.GW24919@linux.intel.com>
References: <20200703025047.13987-1-sean.j.christopherson@intel.com>
 <51637a13-f23b-8b76-c93a-76346b4cc982@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51637a13-f23b-8b76-c93a-76346b4cc982@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 08, 2020 at 06:08:24PM +0200, Paolo Bonzini wrote:
> On 03/07/20 04:50, Sean Christopherson wrote:
> > Introduce a new capability, KVM_CAP_MEMSLOT_ZAP_CONTROL, to allow
> > userspace to control the memslot zapping behavior on a per-VM basis.
> > x86's default behavior is to zap all SPTEs, including the root shadow
> > page, across all memslots.  While effective, the nuke and pave approach
> > isn't exactly performant, especially for large VMs and/or VMs that
> > heavily utilize RO memslots for MMIO devices, e.g. option ROMs.
> > 
> > On a vanilla VM with 6gb of RAM, the targeted zap reduces the number of
> > EPT violations during boot by ~14% with THP enabled in the host, and by
> > ~7% with THP disabled in the host.  On a much more custom VM with 32gb
> > and a significant amount of memslot zapping, this can reduce the number
> > of EPT violations by 50% during guest boot, and improve boot time by
> > as much as 25%.
> > 
> > Keep the current x86 memslot zapping behavior as the default, as there's
> > an unresolved bug that pops up when zapping only the affected memslot,
> > and the exact conditions that trigger the bug are not fully known.  See
> > https://patchwork.kernel.org/patch/10798453 for details.
> > 
> > Implement the capability as a set of flags so that other architectures
> > might be able to use the capability without having to conform to x86's
> > semantics.
> 
> It's bad that we have no clue what's causing the bad behavior, but I
> don't think it's wise to have a bug that is known to happen when you
> enable the capability. :/

I don't necessarily disagree, but at the same time it's entirely possible
it's a Qemu bug.  If the bad behavior doesn't occur with other VMMs, those
other VMMs shouldn't be penalized because we can't figure out what Qemu is
getting wrong.

Even if this is a kernel bug, I'm fairly confident at this point that it's
not a KVM bug.  Or rather, if it's a KVM "bug", then there's a fundamental
dependency in memslot management that needs to be rooted out and documented.

And we're kind of in a catch-22; it'll be extremely difficult to narrow down
exactly who is breaking what without being able to easily test the optimized
zapping with other VMMs and/or setups.
