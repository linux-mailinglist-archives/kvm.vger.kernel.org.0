Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81F6011A0FB
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 03:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfLKCCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 21:02:02 -0500
Received: from mga03.intel.com ([134.134.136.65]:23328 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbfLKCCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 21:02:01 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 18:02:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="203394713"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 10 Dec 2019 18:01:59 -0800
Date:   Wed, 11 Dec 2019 10:03:21 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 6/7] KVM: X86: Load guest fpu state when accessing
 MSRs managed by XSAVES
Message-ID: <20191211020321.GD12845@local-michael-cet-test>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
 <20191101085222.27997-7-weijiang.yang@intel.com>
 <20191210212748.GN15758@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210212748.GN15758@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 10, 2019 at 01:27:48PM -0800, Sean Christopherson wrote:
> On Fri, Nov 01, 2019 at 04:52:21PM +0800, Yang Weijiang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
 
> > -	for (i = 0; i < msrs->nmsrs; ++i)
> > +	for (i = 0; i < msrs->nmsrs; ++i) {
> > +		if (!fpu_loaded && cet_xss &&
> > +		    is_xsaves_msr(entries[i].index)) {
> > +			kvm_load_guest_fpu(vcpu);
> 
> This needs to also check for a non-NULL @vcpu.  KVM_GET_MSR can be called
> on the VM to invoke do_get_msr_feature().
>
Yeah, I need to add the check, thanks!

> > +			fpu_loaded = true;
> > +		}
> >  		if (do_msr(vcpu, entries[i].index, &entries[i].data))
> >  			break;
> > +	}
> > +	if (fpu_loaded)
> > +		kvm_put_guest_fpu(vcpu);
> >  
> >  	return i;
> >  }
> > -- 
> > 2.17.2
> > 
