Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE141889FD
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 17:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCQQQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 12:16:32 -0400
Received: from mga17.intel.com ([192.55.52.151]:59753 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgCQQQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 12:16:32 -0400
IronPort-SDR: xJQ+Vmtlchge0JD+BcE/SzVeKT5EAt38iMN1Cd0KMF5ELMRam2wYTB8v4HXGgMz1C1tm3Funm8
 fg/Xh1+FAgPw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 09:16:31 -0700
IronPort-SDR: TisHc35JxXWWsW++YHglStF/q1Qs5t2M3hs6ClvW8soMNHMx7VvTmnR2igC8zIgyr7R6S+2DGj
 mx/rlfdhjiLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,565,1574150400"; 
   d="scan'208";a="247871726"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 17 Mar 2020 09:16:31 -0700
Date:   Tue, 17 Mar 2020 09:16:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 01/10] KVM: nVMX: Move reflection check into
 nested_vmx_reflect_vmexit()
Message-ID: <20200317161631.GD12526@linux.intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
 <20200312184521.24579-2-sean.j.christopherson@intel.com>
 <87k13opi6m.fsf@vitty.brq.redhat.com>
 <20200317053327.GR24267@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317053327.GR24267@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 16, 2020 at 10:33:27PM -0700, Sean Christopherson wrote:
> On Fri, Mar 13, 2020 at 01:12:33PM +0100, Vitaly Kuznetsov wrote:
> > Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > 
> > > -static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
> > > -					    u32 exit_reason)
> > > +static inline bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
> > > +					     u32 exit_reason)
> > >  {
> > > -	u32 exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
> > > +	u32 exit_intr_info;
> > > +
> > > +	if (!nested_vmx_exit_reflected(vcpu, exit_reason))
> > > +		return false;
> > 
> > (unrelated to your patch)
> > 
> > It's probably just me but 'nested_vmx_exit_reflected()' name always
> > makes me thinkg 'the vmexit WAS [already] reflected' and not 'the vmexit
> > NEEDS to be reflected'. 'nested_vmx_exit_needs_reflecting()' maybe?
> 
> Not just you.  It'd be nice if the name some how reflected (ha) that the
> logic is mostly based on whether or not L1 expects the exit, with a few
> exceptions.  E.g. something like
> 
> 	if (!l1_expects_vmexit(...) && !is_system_vmexit(...))
> 		return false;

Doh, the system VM-Exit logic is backwards, it should be

	if (!l1_expects_vmexit(...) || is_system_vmexit(...))
		return false;
> 
> The downside of that is the logic is split, which is probably a net loss?
