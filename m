Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4748C177C6C
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbgCCQwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:52:05 -0500
Received: from mga12.intel.com ([192.55.52.136]:1727 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729156AbgCCQwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 11:52:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 08:52:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="228984318"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2020 08:52:04 -0800
Date:   Tue, 3 Mar 2020 08:52:04 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/13] KVM: x86: Dynamically allocate per-vCPU
 emulation context
Message-ID: <20200303165203.GM1439@linux.intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
 <20200218232953.5724-9-sean.j.christopherson@intel.com>
 <87wo89i7e3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo89i7e3.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 26, 2020 at 06:29:56PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > @@ -9409,6 +9451,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> >  
> >  	kvm_x86_ops->vcpu_free(vcpu);
> >  
> > +	if (vcpu->arch.emulate_ctxt)
> > +		kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
> 
> Checking for NULL here seems superfluous as we create the context in
> kvm_arch_vcpu_create() unconditionally. I'd suggest we move the check to 
> "[PATCH v2 12/13] KVM: x86: Add variable to control existence of
> emulator" where 'enable_emulator' global is added.

Ya, checking here is premature.

> > +
> >  	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
> >  	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
> >  	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
> 
> -- 
> Vitaly
> 
