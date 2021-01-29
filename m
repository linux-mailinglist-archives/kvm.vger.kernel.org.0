Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558A63086FE
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 09:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhA2H5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 02:57:05 -0500
Received: from mga07.intel.com ([134.134.136.100]:56149 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232365AbhA2H4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 02:56:54 -0500
IronPort-SDR: MyXuW59Vd+yI7Le6qpDKEfbqbjA3ySusoKPA+Anu+EwDRJ+LEzEmSh37gN/fWKz7DE/W3rn0OK
 pD1HLhALnN/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244470734"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244470734"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 23:56:38 -0800
IronPort-SDR: r8+9M+Q6+eyqVnG+2+9qV6jgTxydFvAWXPrvfUvsbcxM88zLNQfOA2osBpJehVCJUS1YGXTgPw
 L5HtwIQnCgBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="389205573"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.172])
  by orsmga008.jf.intel.com with ESMTP; 28 Jan 2021 23:56:36 -0800
Date:   Fri, 29 Jan 2021 16:08:33 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v14 09/13] KVM: x86: Report CET MSRs as to-be-saved if
 CET is supported
Message-ID: <20210129080833.GB28424@local-michael-cet-test.sh.intel.com>
References: <20201106011637.14289-1-weijiang.yang@intel.com>
 <20201106011637.14289-10-weijiang.yang@intel.com>
 <732d1da2-70d7-1f8a-b41d-136e068516d7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <732d1da2-70d7-1f8a-b41d-136e068516d7@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 28, 2021 at 06:46:37PM +0100, Paolo Bonzini wrote:
> On 06/11/20 02:16, Yang Weijiang wrote:
> > Report all CET MSRs, including the synthetic GUEST_SSP MSR, as
> > to-be-saved, e.g. for migration, if CET is supported by KVM.
> > 
> > Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >   arch/x86/kvm/x86.c | 9 +++++++++
> >   1 file changed, 9 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 751b62e871e5..d573cadf5baf 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1248,6 +1248,8 @@ static const u32 msrs_to_save_all[] = {
> >   	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
> >   	MSR_IA32_XSS,
> > +	MSR_IA32_U_CET, MSR_IA32_S_CET, MSR_IA32_INT_SSP_TAB, MSR_KVM_GUEST_SSP,
> > +	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP, MSR_IA32_PL3_SSP,
> >   };
> >   static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
> > @@ -5761,6 +5763,13 @@ static void kvm_init_msr_list(void)
> >   			if (!supported_xss)
> >   				continue;
> >   			break;
> > +		case MSR_IA32_U_CET:
> > +		case MSR_IA32_S_CET:
> > +		case MSR_IA32_INT_SSP_TAB:
> > +		case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> > +			if (!kvm_cet_supported())
> > +				continue;
> > +			break;
> >   		default:
> >   			break;
> >   		}
> > 
> 
> Missing "case MSR_KVM_GUEST_SSP".
>
OK, will fix it in next version.
> Paolo
