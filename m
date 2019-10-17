Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B67DB7F8
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 21:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440463AbfJQTqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 15:46:23 -0400
Received: from mga04.intel.com ([192.55.52.120]:15832 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387813AbfJQTqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 15:46:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 12:46:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,308,1566889200"; 
   d="scan'208";a="199471795"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 17 Oct 2019 12:46:22 -0700
Date:   Thu, 17 Oct 2019 12:46:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v7 1/7] KVM: CPUID: Fix IA32_XSS support in CPUID(0xd,i)
 enumeration
Message-ID: <20191017194622.GI20903@linux.intel.com>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <20190927021927.23057-2-weijiang.yang@intel.com>
 <CALMp9eRXoyoX6GHQgVTXemJjm69MwqN+VDN47X=5BN36rvrAgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRXoyoX6GHQgVTXemJjm69MwqN+VDN47X=5BN36rvrAgA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 02, 2019 at 10:26:10AM -0700, Jim Mattson wrote:
> On Thu, Sep 26, 2019 at 7:17 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > @@ -414,6 +419,50 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
> >         }
> >  }
> >
> > +static inline void do_cpuid_0xd_mask(struct kvm_cpuid_entry2 *entry, int index)
> > +{
> > +       unsigned int f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
> 
> Does Intel have CPUs that support XSAVES but don't support the "enable
> XSAVES/XRSTORS" VM-execution control?

I doubt it.

> If so, what is the behavior of XSAVESXRSTORS on those CPUs in VMX
> non-root mode?

#UD.  If not, the CPU would be in violation of the SDM:

  If the "enable XSAVES/XRSTORS" VM-execution control is 0, XRSTORS causes
  an invalid-opcode exception (#UD).

> If not, why is this conditional F(XSAVES) here?

Because it's technically legal for the control to not be supported even
if the host doesn't have support.

> > +       /* cpuid 0xD.1.eax */
> > +       const u32 kvm_cpuid_D_1_eax_x86_features =
> > +               F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
> > +       u64 u_supported = kvm_supported_xcr0();
> > +       u64 s_supported = kvm_supported_xss();
> > +       u64 supported;
> > +
> > +       switch (index) {
> > +       case 0:
> > +               entry->eax &= u_supported;
> > +               entry->ebx = xstate_required_size(u_supported, false);
> 
> EBX could actually be zero, couldn't it? Since this output is
> context-dependent, I'm not sure how to interpret it when returned from
> KVM_GET_SUPPORTED_CPUID.

*sigh*.  It took me something like ten read throughs to understand what
you're saying.

Yes, it could be zero, though that ship may have sailed since the previous
code reported a non-zero value.  Whatever is done, KVM should be consistent
for all indices, i.e. either report zero or the max size.

> > +               entry->ecx = entry->ebx;
> > +               entry->edx = 0;
> 
> Shouldn't this be: entry->edx &= u_supported >> 32?

Probably.  The confusion likely stems from this wording in the SDM, where
it states the per-bit behavior and then also says all bits are reserved.
I think it makes sense to do as Jim suggested, and defer the reserved bit
handling to kvm_supported_{xcr0,xss}().

  Bit 31 - 00: Reports the supported bits of the upper 32 bits of XCR0.
  XCR0[n+32] can be set to 1 only if EDX[n] is 1.
  Bits 31 - 00: Reserved
 
> > +               break;
> > +       case 1:
> > +               supported = u_supported | s_supported;
> > +               entry->eax &= kvm_cpuid_D_1_eax_x86_features;
> > +               cpuid_mask(&entry->eax, CPUID_D_1_EAX);
> > +               entry->ebx = 0;
> > +               entry->edx = 0;
> 
> Shouldn't this be: entry->edx &= s_supported >> 32?

Same as above.
 
> > +               entry->ecx &= s_supported;
> > +               if (entry->eax & (F(XSAVES) | F(XSAVEC)))
> > +                       entry->ebx = xstate_required_size(supported, true);
> 
> As above, can't EBX just be zero, since it's context-dependent? What
> is the context when processing KVM_GET_SUPPORTED_CPUID? And why do we
> only fill this in when XSAVES or XSAVEC is supported?
> 
> > +               break;
> > +       default:
> > +               supported = (entry->ecx & 1) ? s_supported : u_supported;
> > +               if (!(supported & ((u64)1 << index))) {
> 
> Nit: 1ULL << index.

Even better:  BIT_ULL(index)

> > +                       entry->eax = 0;
> > +                       entry->ebx = 0;
> > +                       entry->ecx = 0;
> > +                       entry->edx = 0;
> > +                       return;
> > +               }
> > +               if (entry->ecx)
> > +                       entry->ebx = 0;
> 
> This seems to back up my claims above regarding the EBX output for
> cases 0 and 1, but aside from those subleaves, is this correct? For
> subleaves > 1, ECX bit 1 can be set for extended state components that
> need to be cache-line aligned. Such components could map to a valid
> bit in XCR0 and have a non-zero offset from the beginning of the
> non-compacted XSAVE area.
> 
> > +               entry->edx = 0;
> 
> This seems too aggressive. See my comments above regarding EDX outputs
> for cases 0 and 1.
> 
> > +               break;
> > +       }
> > +}
