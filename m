Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79C79176E39
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 05:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgCCE6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 23:58:40 -0500
Received: from mga03.intel.com ([134.134.136.65]:34653 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgCCE6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 23:58:39 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 20:58:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,510,1574150400"; 
   d="scan'208";a="232146450"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 02 Mar 2020 20:58:38 -0800
Date:   Mon, 2 Mar 2020 20:58:38 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 2/6] KVM: x86: Fix CPUID range check for Centaur and
 Hypervisor ranges
Message-ID: <20200303045838.GF27842@linux.intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-3-sean.j.christopherson@intel.com>
 <CALMp9eThBnN3ktAfwhNs7L-O031JDFqjb67OMPooGvmkcdhK4A@mail.gmail.com>
 <CALMp9eR0Mw8iPv_Z43gfCEbErHQ6EXX8oghJJb5Xge+47ZU9yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eR0Mw8iPv_Z43gfCEbErHQ6EXX8oghJJb5Xge+47ZU9yQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 02, 2020 at 08:25:31PM -0800, Jim Mattson wrote:
> On Mon, Mar 2, 2020 at 7:25 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Mon, Mar 2, 2020 at 11:57 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> >
> > > The bad behavior can be visually confirmed by dumping CPUID output in
> > > the guest when running Qemu with a stable TSC, as Qemu extends the limit
> > > of range 0x40000000 to 0x40000010 to advertise VMware's cpuid_freq,
> > > without defining zeroed entries for 0x40000002 - 0x4000000f.
> >
> > I think it could be reasonably argued that this is a userspace bug.
> > Clearly, when userspace explicitly supplies the results for a leaf,
> > those results override the default CPUID values for that leaf. But I
> > haven't seen it documented anywhere that leaves *not* explicitly
> > supplied by userspace will override the default CPUID values, just
> > because they happen to appear in some magic range.
> 
> In fact, the more I think about it, the original change is correct, at
> least in this regard. Your "fix" introduces undocumented and
> unfathomable behavior.

Heh, the takeaway from this is that whatever we decide on needs to be
documented somewhere :-)

I wouldn't say it's unfathomable, conceptually it seems like the intent
of the hypervisor range was to mimic the basic and extended ranges.  The
whole thing is arbitrary behavior.  Of course if Intel CPUs would just
return 0s on undefined leafs it would be a lot less arbitrary :-)
 
Anyways, I don't have a strong opinion on whether this patch stays or goes.
