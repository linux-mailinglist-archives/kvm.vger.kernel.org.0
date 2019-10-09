Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B169D07B0
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 08:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfJIGzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 02:55:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:65443 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfJIGy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 02:54:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 23:54:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="200042363"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Oct 2019 23:54:54 -0700
Date:   Wed, 9 Oct 2019 14:56:51 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v7 7/7] KVM: x86: Add user-space access interface for CET
 MSRs
Message-ID: <20191009065651.GE27851@local-michael-cet-test>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <20190927021927.23057-8-weijiang.yang@intel.com>
 <CALMp9eQNDNmmCr8DM-2fMVYvQ-eTEpeE=bW8+BLbfxmBsTmQvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQNDNmmCr8DM-2fMVYvQ-eTEpeE=bW8+BLbfxmBsTmQvg@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 02, 2019 at 01:57:50PM -0700, Jim Mattson wrote:
> On Thu, Sep 26, 2019 at 7:17 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >
> > There're two different places storing Guest CET states, the states
> > managed with XSAVES/XRSTORS, as restored/saved
> > in previous patch, can be read/write directly from/to the MSRs.
> > For those stored in VMCS fields, they're access via vmcs_read/
> > vmcs_write.
> >
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 83 ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 83 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 44913e4ab558..5265db7cd2af 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1671,6 +1671,49 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
> >         return 0;
> >  }
> >
> > +static int check_cet_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 
> I'd suggest changing return type to bool, since you are essentially
> returning true or false.
>
Sure, will change it.

> > +{
> > +       u64 kvm_xss = kvm_supported_xss();
> > +
> > +       switch (msr_info->index) {
> > +       case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
> > +               if (!(kvm_xss | XFEATURE_MASK_CET_KERNEL))
> '|' should be '&'
Oops, thanks for the capture!

> > +                       return 1;
> > +               if (!msr_info->host_initiated &&
> > +                   !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> > +                       return 1;
> > +               break;
> > +       case MSR_IA32_PL3_SSP:
> > +               if (!(kvm_xss | XFEATURE_MASK_CET_USER))
> '|' should be '&'
> > +                       return 1;
> > +               if (!msr_info->host_initiated &&
> > +                   !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> > +                       return 1;
> > +               break;
> > +       case MSR_IA32_U_CET:
> > +               if (!(kvm_xss | XFEATURE_MASK_CET_USER))
> '|' should be '&'
> > +                       return 1;
> > +               if (!msr_info->host_initiated &&
> > +                   !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
> > +                   !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> > +                       return 1;
> > +               break;
> > +       case MSR_IA32_S_CET:
> > +               if (!msr_info->host_initiated &&
> > +                   !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
> > +                   !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> > +                       return 1;
> > +               break;
> > +       case MSR_IA32_INT_SSP_TAB:
> > +               if (!msr_info->host_initiated &&
> > +                   !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> > +                       return 1;
> > +               break;
> > +       default:
> > +               return 1;
> > +       }
> > +       return 0;
> > +}
> >  /*
> >   * Reads an msr value (of 'msr_index') into 'pdata'.
> >   * Returns 0 on success, non-0 otherwise.
> > @@ -1788,6 +1831,26 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >                 else
> >                         msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
> >                 break;
> > +       case MSR_IA32_S_CET:
> > +               if (check_cet_msr(vcpu, msr_info))
> > +                       return 1;
> > +               msr_info->data = vmcs_readl(GUEST_S_CET);
> Have we ensured that this VMCS field exists?
> > +               break;
> > +       case MSR_IA32_INT_SSP_TAB:
> > +               if (check_cet_msr(vcpu, msr_info))
> > +                       return 1;
> > +               msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
> Have we ensured that this VMCS field exists?
If host kernel sets correct info, we can make sure here.

> > +               break;
> > +       case MSR_IA32_U_CET:
> Can this be lumped together with MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP, below?
Unfortunately, this MSR is not adjacent to below MSRs.

> > +               if (check_cet_msr(vcpu, msr_info))
> > +                       return 1;
> > +               rdmsrl(MSR_IA32_U_CET, msr_info->data);
> > +               break;
> > +       case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> > +               if (check_cet_msr(vcpu, msr_info))
> > +                       return 1;
> > +               rdmsrl(msr_info->index, msr_info->data);
> > +               break;
> >         case MSR_TSC_AUX:
> >                 if (!msr_info->host_initiated &&
> >                     !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> > @@ -2039,6 +2102,26 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >                 else
> >                         vmx->pt_desc.guest.addr_a[index / 2] = data;
> >                 break;
> > +       case MSR_IA32_S_CET:
> > +               if (check_cet_msr(vcpu, msr_info))
> > +                       return 1;
> Bits 9:6 must be zero.
> > +               vmcs_writel(GUEST_S_CET, data);
> Have we ensured that this VMCS field exists?
> > +               break;
> > +       case MSR_IA32_INT_SSP_TAB:
> > +               if (check_cet_msr(vcpu, msr_info))
> > +                       return 1;
> Must be canonical. vCPU must support longmode.
> > +               vmcs_writel(GUEST_INTR_SSP_TABLE, data);
> Have we ensured that this VMCS field exists?
> > +               break;
> > +       case MSR_IA32_U_CET:
> > +               if (check_cet_msr(vcpu, msr_info))
> > +                       return 1;
> Bits 9:6 must be zero.
> > +               wrmsrl(MSR_IA32_U_CET, data);
> > +               break;
> > +       case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> > +               if (check_cet_msr(vcpu, msr_info))
> > +                       return 1;
> 'Data' must be canonical and 4-byte aligned. High dword must be zero
> on vCPUs that don't support longmode.

Thanks a lot for all above captures, will add sanity checks in next
version.

> > +               wrmsrl(msr_info->index, data);
> > +               break;
> >         case MSR_TSC_AUX:
> >                 if (!msr_info->host_initiated &&
> >                     !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> > --
> > 2.17.2
> >
