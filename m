Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7A23086C3
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 08:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhA2Hyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 02:54:40 -0500
Received: from mga18.intel.com ([134.134.136.126]:39363 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232019AbhA2Hyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 02:54:38 -0500
IronPort-SDR: qCWRw9OgBVWmsNVTS14m1KST7EKe3t9kQBmrGu8COT+btnM432wpW0KtX//aQRkTk2kasEACJj
 weQbhIJx2w4A==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="168051066"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="168051066"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 23:55:23 -0800
IronPort-SDR: m5LIJzseWRcoACVo4HL7r0wDfos8wc750dt3JEew5Pgea1MR3NKDnLzPo3sNd5SQs1MFrILp+p
 5FQWFgCTohAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="430898012"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.172])
  by orsmga001.jf.intel.com with ESMTP; 28 Jan 2021 23:55:21 -0800
Date:   Fri, 29 Jan 2021 16:07:19 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v14 07/13] KVM: VMX: Emulate reads and writes to CET MSRs
Message-ID: <20210129080719.GA28424@local-michael-cet-test.sh.intel.com>
References: <20201106011637.14289-1-weijiang.yang@intel.com>
 <20201106011637.14289-8-weijiang.yang@intel.com>
 <a73b590d-4cd3-f1b3-bea2-e674846595b3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a73b590d-4cd3-f1b3-bea2-e674846595b3@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 28, 2021 at 06:45:08PM +0100, Paolo Bonzini wrote:
> On 06/11/20 02:16, Yang Weijiang wrote:
> > 
> > +static bool cet_is_ssp_msr_accessible(struct kvm_vcpu *vcpu,
> > +				      struct msr_data *msr)
> > +{
> > +	u64 mask;
> > +
> > +	if (!kvm_cet_supported())
> > +		return false;
> > +
> > +	if (msr->host_initiated)
> > +		return true;
> > +
> > +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> > +		return false;
> > +
> > +	if (msr->index == MSR_IA32_INT_SSP_TAB)
> > +		return false;
> 
> Shouldn't this return true?
>
Hi, Paolo,
Thanks for the feedback!
Yes, it should be true, will fix it in next release.
> Paolo
> 
> > +	mask = (msr->index == MSR_IA32_PL3_SSP) ? XFEATURE_MASK_CET_USER :
> > +						  XFEATURE_MASK_CET_KERNEL;
> > +	return !!(vcpu->arch.guest_supported_xss & mask);
> > +}
