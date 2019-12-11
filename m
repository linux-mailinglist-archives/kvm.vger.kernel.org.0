Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA1611A0AA
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 02:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfLKBoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 20:44:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:22190 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbfLKBoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 20:44:16 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 17:44:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="264705584"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Dec 2019 17:44:13 -0800
Date:   Wed, 11 Dec 2019 09:45:36 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 2/7] KVM: VMX: Define CET VMCS fields and #CP flag
Message-ID: <20191211014536.GB12845@local-michael-cet-test>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
 <20191101085222.27997-3-weijiang.yang@intel.com>
 <20191210210044.GK15758@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210210044.GK15758@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 10, 2019 at 01:00:44PM -0800, Sean Christopherson wrote:
> On Fri, Nov 01, 2019 at 04:52:17PM +0800, Yang Weijiang wrote:
> > CET(Control-flow Enforcement Technology) is an upcoming Intel(R)
> > processor feature that blocks Return/Jump-Oriented Programming(ROP)
> > attacks. It provides the following capabilities to defend
> > against ROP/JOP style control-flow subversion attacks:
> > 
> >  	return (1U << vector) & exception_has_error_code;
> >  }
> > @@ -298,7 +298,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
> >   * Right now, no XSS states are used on x86 platform,
> >   * expand the macro for new features.
> 
> I assume this comment needs to be updated?
>
I'm not sure which features in upstream code are using xsaves bits,
should I go like this:
In future, other XSS state bits can be added here to make them available
to guest? 
> >   */
> > -#define KVM_SUPPORTED_XSS	0
> > +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER \
> > +				| XFEATURE_MASK_CET_KERNEL)
> >  
> >  extern u64 host_xcr0;
> >  
> > -- 
> > 2.17.2
> > 
