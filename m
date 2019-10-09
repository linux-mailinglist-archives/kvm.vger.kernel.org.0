Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E6AD06F5
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 07:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbfJIFzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 01:55:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:28095 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbfJIFzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 01:55:11 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 22:55:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="218521849"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 08 Oct 2019 22:55:09 -0700
Date:   Wed, 9 Oct 2019 13:56:46 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v7 2/7] kvm: vmx: Define CET VMCS fields and CPUID flags
Message-ID: <20191009055646.GA27851@local-michael-cet-test>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <20190927021927.23057-3-weijiang.yang@intel.com>
 <CALMp9eT8uBo0+1x1x=mZ48XqYsR_3MTShZMNEaZWEKjt7i1Sqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eT8uBo0+1x1x=mZ48XqYsR_3MTShZMNEaZWEKjt7i1Sqg@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 02, 2019 at 11:04:07AM -0700, Jim Mattson wrote:
> On Thu, Sep 26, 2019 at 7:17 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >
> > CET(Control-flow Enforcement Technology) is an upcoming Intel(R)
> > processor feature that blocks Return/Jump-Oriented Programming(ROP)
> > attacks. It provides the following capabilities to defend
> > against ROP/JOP style control-flow subversion attacks:
> >  /*
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 9d282fec0a62..1aa86b87b6ab 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -365,13 +365,13 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
> >                 F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
> >                 F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
> >                 F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> > -               F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B);
> > +               F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | F(SHSTK);
> >
> >         /* cpuid 7.0.edx*/
> >         const u32 kvm_cpuid_7_0_edx_x86_features =
> >                 F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
> >                 F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> > -               F(MD_CLEAR);
> > +               F(MD_CLEAR) | F(IBT);
> 
> Claiming that SHSTK and IBT are supported in the guest seems premature
> as of this change, since you haven't actually done anything to
> virtualize the features yet.
>
OK, will put the flags in other patch.
> >         /* cpuid 7.1.eax */
> >         const u32 kvm_cpuid_7_1_eax_x86_features =
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index fbffabad0370..a85800b23e6e 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -298,7 +298,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
> >   * Right now, no XSS states are used on x86 platform,
> >   * expand the macro for new features.
> >   */
> > -#define KVM_SUPPORTED_XSS      (0)
> > +#define KVM_SUPPORTED_XSS      (XFEATURE_MASK_CET_USER \
> > +                               | XFEATURE_MASK_CET_KERNEL)
> 
> If IA32_XSS can dynamically change within the guest, it will have to
> be enumerated by KVM_GET_MSR_INDEX_LIST.
thanks for pointing it out, need to add IA32_XSS to msrs_to_save list.

>(Note that Aaron Lewis is
> working on a series which will include that enumeration, if you'd like
> to wait.) I'm also not convinced that there is sufficient
> virtualization of these features to allow these bits to be set in the
> guest IA32_XSS at this point.
> 
It's true CET is working in guest after I added XSS/XSAVES support in
KVM and QEMU, but I'd like to look at Aaron's new patch...

> >  extern u64 host_xcr0;
> >
> > --
> > 2.17.2
> >
