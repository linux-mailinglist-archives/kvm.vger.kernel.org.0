Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F2727782D
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 20:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgIXSBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 14:01:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:10426 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728577AbgIXSBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 14:01:39 -0400
IronPort-SDR: tspAxKL38P51eu2PSgU6Ir6nbEdt8uMy8r8MvvcLvadxq6+P5PVSOp/zXzj6QT10NyH5CByIzT
 VogB/J68x3eQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="225434734"
X-IronPort-AV: E=Sophos;i="5.77,298,1596524400"; 
   d="scan'208";a="225434734"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 11:01:22 -0700
IronPort-SDR: QJkOAgUtzmtFELwpkWXY/qDcpAauQAP7A0QAuKTa8XkbMa42AaMZapy+j9q6fR8Ru9ub+NgGCo
 M2n4erRyIbzA==
X-IronPort-AV: E=Sophos;i="5.77,298,1596524400"; 
   d="scan'208";a="305920835"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 11:01:21 -0700
Date:   Thu, 24 Sep 2020 11:01:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: VMX: Replace MSR_IA32_RTIT_OUTPUT_BASE_MASK
 with helper function
Message-ID: <20200924180120.GA9649@linux.intel.com>
References: <20200923163629.20168-1-sean.j.christopherson@intel.com>
 <20200923163629.20168-3-sean.j.christopherson@intel.com>
 <0a215e25-798d-3f17-0fcb-885806f2351b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a215e25-798d-3f17-0fcb-885806f2351b@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 07:07:22PM +0200, Paolo Bonzini wrote:
> On 23/09/20 18:36, Sean Christopherson wrote:
> > +static inline bool pt_output_base_valid(struct kvm_vcpu *vcpu, u64 base)
> > +{
> > +	/* The base must be 128-byte aligned and a legal physical address. */
> > +	return !(base & (~((1UL << cpuid_maxphyaddr(vcpu)) - 1) | 0x7f));
> > +}
> 
> The fact that you deemed a comment necessary says something already. :)
> What about:
> 
>         return !kvm_mmu_is_illegal_gpa(vcpu, base) && !(base & 0x7f);
> 
> (where this new usage makes it obvious that mmu should have been vcpu).

Ya.  I think it was a sort of sunk cost fallacy.  Dammit, I spent all that
time figuring out what this code does, I'm keeping it!!!

v3 incoming...
