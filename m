Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6E2178140
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 20:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387978AbgCCSB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 13:01:28 -0500
Received: from mga18.intel.com ([134.134.136.126]:23690 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731827AbgCCSB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 13:01:26 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 10:01:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="440678485"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 03 Mar 2020 10:01:22 -0800
Date:   Tue, 3 Mar 2020 10:01:22 -0800
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
Message-ID: <20200303180122.GO1439@linux.intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-3-sean.j.christopherson@intel.com>
 <CALMp9eThBnN3ktAfwhNs7L-O031JDFqjb67OMPooGvmkcdhK4A@mail.gmail.com>
 <CALMp9eR0Mw8iPv_Z43gfCEbErHQ6EXX8oghJJb5Xge+47ZU9yQ@mail.gmail.com>
 <20200303045838.GF27842@linux.intel.com>
 <CALMp9eSYZKUBko4ZViNbasRGJs2bAO2fREHX9maDbLrYj8yDhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSYZKUBko4ZViNbasRGJs2bAO2fREHX9maDbLrYj8yDhQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 09:42:42AM -0800, Jim Mattson wrote:
> Unfathomable was the wrong word.

I dunno, one could argue that the behavior of Intel CPUs for CPUID is
unfathomable and I was just trying to follow suit :-D

>  I can see what you're trying to do. I
> just don't think it's defensible. I suspect that Intel CPU architects
> will be surprised and disappointed to find that the maximum effective
> value of CPUID.0H:EAX is now 255, and that they have to define
> CPUID.100H:EAX as the "maximum leaf between 100H and 1FFH" if they
> want to define any leaves between 100H and 1FFH.

Hmm, ya, I agree that applying a 0xffffff00 mask to all classes of CPUID
ranges is straight up wrong.

> Furthermore, AMD has only ceded 4000_0000h through 4000_00FFh to
> hypervisors, so kvm's use of 40000100H through 400001FFH appears to be
> a land grab, akin to VIA's unilateral grab of the C0000000H leaves.
> Admittedly, one could argue that the 40000000H leaves are not AMD's to
> apportion, since AMD and Intel appear to have reached a detente by
> splitting the available space down the middle. Intel, who seems to be
> the recognized authority for this range, declares the entire range
> from 40000000H through 4FFFFFFFH to be invalid. Make of that what you
> will.
> 
> In any event, no one has ever documented what's supposed to happen if
> you leave gaps in the 4xxxxxxxH range when defining synthesized CPUID
> leaves under kvm.

Probably stating the obvious, but for me, the least suprising thing is for
such leafs to output zeros.  It also feels safer, e.g. a guest that's
querying hypervisor support is less likely to be led astray by all zeros
than by a random feature bits being set.

What about something like this?  Along with a comment and documentation...

static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
{
	struct kvm_cpuid_entry2 *max;

	if (function >= 0x40000000 && function <= 0x4fffffff)
		max = kvm_find_cpuid_entry(vcpu, function & 0xffffff00, 0);
	else
		max = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
	return max && function <= max->eax;
}

> On Mon, Mar 2, 2020 at 8:58 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Mon, Mar 02, 2020 at 08:25:31PM -0800, Jim Mattson wrote:
> > > On Mon, Mar 2, 2020 at 7:25 PM Jim Mattson <jmattson@google.com> wrote:
> > > >
> > > > On Mon, Mar 2, 2020 at 11:57 AM Sean Christopherson
> > > > <sean.j.christopherson@intel.com> wrote:
> > > >
> > > > > The bad behavior can be visually confirmed by dumping CPUID output in
> > > > > the guest when running Qemu with a stable TSC, as Qemu extends the limit
> > > > > of range 0x40000000 to 0x40000010 to advertise VMware's cpuid_freq,
> > > > > without defining zeroed entries for 0x40000002 - 0x4000000f.
> > > >
> > > > I think it could be reasonably argued that this is a userspace bug.
> > > > Clearly, when userspace explicitly supplies the results for a leaf,
> > > > those results override the default CPUID values for that leaf. But I
> > > > haven't seen it documented anywhere that leaves *not* explicitly
> > > > supplied by userspace will override the default CPUID values, just
> > > > because they happen to appear in some magic range.
> > >
> > > In fact, the more I think about it, the original change is correct, at
> > > least in this regard. Your "fix" introduces undocumented and
> > > unfathomable behavior.
> >
> > Heh, the takeaway from this is that whatever we decide on needs to be
> > documented somewhere :-)
> >
> > I wouldn't say it's unfathomable, conceptually it seems like the intent
> > of the hypervisor range was to mimic the basic and extended ranges.  The
> > whole thing is arbitrary behavior.  Of course if Intel CPUs would just
> > return 0s on undefined leafs it would be a lot less arbitrary :-)
> >
> > Anyways, I don't have a strong opinion on whether this patch stays or goes.
