Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B99311B849
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 17:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbfLKQOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 11:14:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:20012 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729522AbfLKQOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 11:14:07 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 08:14:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="203611957"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 11 Dec 2019 08:14:05 -0800
Date:   Wed, 11 Dec 2019 08:14:05 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Kang, Luwei" <luwei.kang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Peng <chao.p.peng@linux.intel.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Add non-canonical check on writes to RTIT
 address MSRs
Message-ID: <20191211161405.GA5722@linux.intel.com>
References: <20191210232433.4071-1-sean.j.christopherson@intel.com>
 <20191210232433.4071-2-sean.j.christopherson@intel.com>
 <82D7661F83C1A047AF7DC287873BF1E17384B7F2@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E17384B7F2@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 10, 2019 at 06:16:35PM -0800, Kang, Luwei wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> > 51e3b27f90ed..9aa2006dbe04 100644 --- a/arch/x86/kvm/vmx/vmx.c +++
> > b/arch/x86/kvm/vmx/vmx.c @@ -2152,6 +2152,8 @@ static int
> > vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info) (index >= 2 *
> > intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_num_address_ranges)))
> > return 1; +		if (is_noncanonical_address(data, vcpu)) +
> > return 1;
> 
> Is this for live migrate a VM with 5 level page table to the VM with 4 level
> page table?

This is orthogonal to live migration or 5-level paging.  Unless I'm missing
something, KVM simply fails to validate the incoming address.
