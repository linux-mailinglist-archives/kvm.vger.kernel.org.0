Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B0A1B7717
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 15:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgDXNhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 09:37:35 -0400
Received: from mga18.intel.com ([134.134.136.126]:27806 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbgDXNhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 09:37:35 -0400
IronPort-SDR: smZEGsQDHNyIyfr3bTrmSbugVJZP07PpGCpQwPTrtWt0Ukvd/I8/hQXMI58h5/CddiNCs76wON
 WR1IntiUqDeQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 06:37:34 -0700
IronPort-SDR: gvhqoOaLEf6Tu1Xn++AV+1iiWh1wz2sv79iC+M3NuVZRpn4/WCzuaYkzP49lrQF+j14AldJ7fR
 yjXGiCW0M07g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="457907574"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga006.fm.intel.com with ESMTP; 24 Apr 2020 06:37:32 -0700
Date:   Fri, 24 Apr 2020 21:39:33 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 1/9] KVM: VMX: Introduce CET VMX fields and flags
Message-ID: <20200424133933.GC24039@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-2-weijiang.yang@intel.com>
 <20200423160748.GF17824@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423160748.GF17824@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 09:07:48AM -0700, Sean Christopherson wrote:
> On Thu, Mar 26, 2020 at 04:18:38PM +0800, Yang Weijiang wrote:
> > CET(Control-flow Enforcement Technology) is a CPU feature
> > used to prevent Return/Jump-Oriented Programming(ROP/JOP)
> > attacks. It provides the following sub-features to defend
> > against ROP/JOP style control-flow subversion attacks:
> 
> Changelogs should wrap at 75 characters.  Wrapping slightly earlier is ok,
> but wrapping at ~60 chars is too narrow.
>
Got it, thank you!

> > Shadow Stack (SHSTK):
> >   A second stack for program which is used exclusively for
> >   control transfer operations.
> > 

> >  /* Select x86 specific features in <linux/kvm.h> */
> >  #define __KVM_HAVE_PIT
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 40c6768942ae..830afe5038d1 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -186,6 +186,9 @@ static struct kvm_shared_msrs __percpu *shared_msrs;
> >  				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
> >  				| XFEATURE_MASK_PKRU)
> >  
> > +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
> > +				 XFEATURE_MASK_CET_KERNEL)
> 
> This belongs in a later patch, KVM obviously doesn't support XSS.
>
OK, will change it.

> > +
> >  u64 __read_mostly host_efer;
> >  EXPORT_SYMBOL_GPL(host_efer);
> >  
> > @@ -402,6 +405,7 @@ static int exception_class(int vector)
> >  	case NP_VECTOR:
> >  	case SS_VECTOR:
> >  	case GP_VECTOR:
> > +	case CP_VECTOR:
> >  		return EXCPT_CONTRIBUTORY;
> >  	default:
> >  		break;
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index c1954e216b41..8f0baa6fa72f 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -115,7 +115,7 @@ static inline bool x86_exception_has_error_code(unsigned int vector)
> >  {
> >  	static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
> >  			BIT(NP_VECTOR) | BIT(SS_VECTOR) | BIT(GP_VECTOR) |
> > -			BIT(PF_VECTOR) | BIT(AC_VECTOR);
> > +			BIT(PF_VECTOR) | BIT(AC_VECTOR) | BIT(CP_VECTOR);
> >  
> >  	return (1U << vector) & exception_has_error_code;
> 
> Maybe it's gratuitous, but I feel like the #CP logic should be in a patch
> of its own, e.g. the changelog doesn't mention anything about #CP.
> 
My fault, will find a proper place to hold it. 

> >  }
> > -- 
> > 2.17.2
> > 
