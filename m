Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474E6357BF5
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 07:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhDHFpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 01:45:33 -0400
Received: from mga17.intel.com ([192.55.52.151]:37503 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhDHFpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 01:45:33 -0400
IronPort-SDR: nxAiNF4xLhGUKBS5/s+CD/5zJtB5EP7/tPsTlako6fUModm2eNB17RdzvtVnx1LfEPr9+bIPzL
 ImE2UnhJ5WGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="173545002"
X-IronPort-AV: E=Sophos;i="5.82,205,1613462400"; 
   d="scan'208";a="173545002"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 22:45:21 -0700
IronPort-SDR: nitbwr08JmMUN+szROU57sMuKPm3N/E/+cPdVGtI6YzmpQUu6T2Apl0kSKFcW49UHP1VjwT2TK
 iA6rNR6q2ttg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,205,1613462400"; 
   d="scan'208";a="598637892"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga005.jf.intel.com with ESMTP; 07 Apr 2021 22:45:19 -0700
Message-ID: <e7f51cb8404f9cf7cd4898e538faf723d001ba96.camel@linux.intel.com>
Subject: Re: [RFC PATCH 07/12] kvm/vmx/nested: Support new
 IA32_VMX_PROCBASED_CTLS3 vmx feature control MSR
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chang.seok.bae@intel.com,
        kvm@vger.kernel.org, robert.hu@intel.com
Date:   Thu, 08 Apr 2021 13:45:18 +0800
In-Reply-To: <YGswb1BM/58JiCZz@google.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
         <1611565580-47718-8-git-send-email-robert.hu@linux.intel.com>
         <YGswb1BM/58JiCZz@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-04-05 at 15:44 +0000, Sean Christopherson wrote:
> On Mon, Jan 25, 2021, Robert Hoo wrote:
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 89af692..9eb1c0b 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -1285,6 +1285,13 @@ static int vmx_restore_vmx_basic(struct
> > vcpu_vmx *vmx, u64 data)
> >  		lowp = &vmx->nested.msrs.secondary_ctls_low;
> >  		highp = &vmx->nested.msrs.secondary_ctls_high;
> >  		break;
> > +	/*
> > +	 * MSR_IA32_VMX_PROCBASED_CTLS3 is 64bit, all allow-1.
> > +	 * No need to check. Just return.
> 
> Uh, yes need to check.  Unsupported bits need to be '0'.

Right! Thanks Sean. Going to refactor this function.
> 
> > +	 */
> > +	case MSR_IA32_VMX_PROCBASED_CTLS3:
> > +		vmx->nested.msrs.tertiary_ctls = data;
> > +		return 0;
> >  	default:
> >  		BUG();
> >  	}
> > @@ -1421,6 +1428,7 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu,
> > u32 msr_index, u64 data)
> >  	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
> >  	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> >  	case MSR_IA32_VMX_PROCBASED_CTLS2:
> > +	case MSR_IA32_VMX_PROCBASED_CTLS3:
> >  		return vmx_restore_control_msr(vmx, msr_index, data);
> >  	case MSR_IA32_VMX_MISC:
> >  		return vmx_restore_vmx_misc(vmx, data);
> > @@ -1516,6 +1524,9 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs
> > *msrs, u32 msr_index, u64 *pdata)
> >  			msrs->secondary_ctls_low,
> >  			msrs->secondary_ctls_high);
> >  		break;
> > +	case MSR_IA32_VMX_PROCBASED_CTLS3:
> > +		*pdata = msrs->tertiary_ctls;
> > +		break;
> >  	case MSR_IA32_VMX_EPT_VPID_CAP:
> >  		*pdata = msrs->ept_caps |
> >  			((u64)msrs->vpid_caps << 32);
> > @@ -6375,7 +6386,8 @@ void nested_vmx_setup_ctls_msrs(struct
> > nested_vmx_msrs *msrs, u32 ept_caps)
> >  		CPU_BASED_USE_IO_BITMAPS | CPU_BASED_MONITOR_TRAP_FLAG
> > |
> >  		CPU_BASED_MONITOR_EXITING | CPU_BASED_RDPMC_EXITING |
> >  		CPU_BASED_RDTSC_EXITING | CPU_BASED_PAUSE_EXITING |
> > -		CPU_BASED_TPR_SHADOW |
> > CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
> > +		CPU_BASED_TPR_SHADOW |
> > CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
> > +		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
> >  	/*
> >  	 * We can allow some features even when not supported by the
> >  	 * hardware. For example, L1 can specify an MSR bitmap - and we
> > @@ -6413,6 +6425,10 @@ void nested_vmx_setup_ctls_msrs(struct
> > nested_vmx_msrs *msrs, u32 ept_caps)
> >  		SECONDARY_EXEC_RDSEED_EXITING |
> >  		SECONDARY_EXEC_XSAVES;
> >  
> > +	if (msrs->procbased_ctls_high &
> > CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
> > +		rdmsrl(MSR_IA32_VMX_PROCBASED_CTLS3,
> > +		      msrs->tertiary_ctls);
> 
> No need to split that into two lines.

OK
> 
> > +	msrs->tertiary_ctls &= ~TERTIARY_EXEC_LOADIWKEY_EXITING;
> 
> That's wrong, it should simply be "msrs->tertiary_ctls &= 0" until
> LOADIWKEY is
> supported.

OK, after pondering, yes, you're right.
Since tertiary_ctls is allow-1 semantics, it shall imitate
secondary_ctls_high.
Look at above code
	msrs->secondary_ctls_high &=
		SECONDARY_EXEC_DESC |
		SECONDARY_EXEC_ENABLE_RDTSCP |
		SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
		SECONDARY_EXEC_WBINVD_EXITING |
		SECONDARY_EXEC_APIC_REGISTER_VIRT |
		SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
		SECONDARY_EXEC_RDRAND_EXITING |
		SECONDARY_EXEC_ENABLE_INVPCID |
		SECONDARY_EXEC_RDSEED_EXITING |
		SECONDARY_EXEC_XSAVES;

secondary_ctls_high clears all native set-bits but leaves some by
purpose.

Is this what your mean?

> 
> >  	/*
> >  	 * We can emulate "VMCS shadowing," even if the hardware
> >  	 * doesn't support it.

