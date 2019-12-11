Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4AFE11BCC4
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 20:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfLKTST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 14:18:19 -0500
Received: from mga18.intel.com ([134.134.136.126]:23830 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbfLKTST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 14:18:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 11:18:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,302,1571727600"; 
   d="scan'208";a="245399141"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 11 Dec 2019 11:18:17 -0800
Date:   Wed, 11 Dec 2019 11:18:17 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86: Add build-time assertion on usage of bit()
Message-ID: <20191211191817.GJ5044@linux.intel.com>
References: <20191211175822.1925-1-sean.j.christopherson@intel.com>
 <20191211175822.1925-2-sean.j.christopherson@intel.com>
 <CALMp9eR93otezrDot23oODV1S6M9kUAF9oB5UD7+E765cHRXjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eR93otezrDot23oODV1S6M9kUAF9oB5UD7+E765cHRXjw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 10:24:36AM -0800, Jim Mattson wrote:
> On Wed, Dec 11, 2019 at 9:58 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Add build-time checks to ensure KVM isn't trying to do a reverse CPUID
> > lookup on Linux-defined feature bits, along with comments to explain
> > the gory details of X86_FEATUREs and bit().
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >
> > Note, the premature newline in the first line of the second comment is
> > intentional to reduce churn in the next patch.
> >
> >  arch/x86/kvm/x86.h | 23 +++++++++++++++++++++--
> >  1 file changed, 21 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index cab5e71f0f0f..4ee4175c66a7 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -144,9 +144,28 @@ static inline bool is_pae_paging(struct kvm_vcpu *vcpu)
> >         return !is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu);
> >  }
> >
> > -static inline u32 bit(int bitno)
> > +/*
> > + * Retrieve the bit mask from an X86_FEATURE_* definition.  Features contain
> > + * the hardware defined bit number (stored in bits 4:0) and a software defined
> > + * "word" (stored in bits 31:5).  The word is used to index into arrays of
> > + * bit masks that hold the per-cpu feature capabilities, e.g. this_cpu_has().
> > + */
> > +static __always_inline u32 bit(int feature)
> >  {
> > -       return 1 << (bitno & 31);
> > +       /*
> > +        * bit() is intended to be used only for hardware-defined
> > +        * words, i.e. words whose bits directly correspond to a CPUID leaf.
> > +        * Retrieving the bit mask from a Linux-defined word is nonsensical
> > +        * as the bit number/mask is an arbitrary software-defined value and
> > +        * can't be used by KVM to query/control guest capabilities.
> > +        */
> > +       BUILD_BUG_ON((feature >> 5) == CPUID_LNX_1);
> > +       BUILD_BUG_ON((feature >> 5) == CPUID_LNX_2);
> > +       BUILD_BUG_ON((feature >> 5) == CPUID_LNX_3);
> > +       BUILD_BUG_ON((feature >> 5) == CPUID_LNX_4);
> > +       BUILD_BUG_ON((feature >> 5) > CPUID_7_EDX);
> 
> What is magical about CPUID_7_EDX?

It's currently the last cpufeatures word.  My thought was to force this to
be updated in order to do reverse lookup on the next new word.  I didn't
want to use NCAPINTS because that gets updated when a new word is added to
cpufeatures, i.e. wouldn't catch the case where the next new word is a
Linux-defined word, which is extremely unlikely but theoretically possible.

> > +
> > +       return 1 << (feature & 31);
> 
> Why not BIT(feature & 31)?

That's a very good question.

> >  }
> >
> >  static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
> > --
> > 2.24.0
> >
