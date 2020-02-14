Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CA215E9C6
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 18:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394133AbgBNRJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 12:09:16 -0500
Received: from mga06.intel.com ([134.134.136.31]:10149 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392336AbgBNRJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 12:09:16 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 09:09:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,441,1574150400"; 
   d="scan'208";a="223073823"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 14 Feb 2020 09:09:14 -0800
Date:   Fri, 14 Feb 2020 09:09:14 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/61] KVM: x86: Introduce cpuid_entry_{get,has}()
 accessors
Message-ID: <20200214170914.GC20690@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-27-sean.j.christopherson@intel.com>
 <1f918bcf-d36d-f759-5796-2acb2a514888@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f918bcf-d36d-f759-5796-2acb2a514888@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 05:44:41PM +0800, Xiaoyao Li wrote:
> On 2/2/2020 2:51 AM, Sean Christopherson wrote:
> >@@ -387,7 +388,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
> >  		entry->ebx |= F(TSC_ADJUST);
> >  		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
> >-		f_la57 = entry->ecx & F(LA57);
> >+		f_la57 = cpuid_entry_get(entry, X86_FEATURE_LA57);

Note, cpuid_entry_get() is used here.

> >  		cpuid_mask(&entry->ecx, CPUID_7_ECX);
> >  		/* Set LA57 based on hardware capability. */
> >  		entry->ecx |= f_la57;
> >diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> >index 72a79bdfed6b..64e96e4086e2 100644
> >--- a/arch/x86/kvm/cpuid.h
> >+++ b/arch/x86/kvm/cpuid.h
> >@@ -95,16 +95,10 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
> >  	return reverse_cpuid[x86_leaf];
> >  }
> >-static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
> >+static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
> >+						  const struct cpuid_reg *cpuid)
> >  {
> >-	struct kvm_cpuid_entry2 *entry;
> >-	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
> >-
> >-	entry = kvm_find_cpuid_entry(vcpu, cpuid.function, cpuid.index);
> >-	if (!entry)
> >-		return NULL;
> >-
> >-	switch (cpuid.reg) {
> >+	switch (cpuid->reg) {
> >  	case CPUID_EAX:
> >  		return &entry->eax;
> >  	case CPUID_EBX:
> >@@ -119,6 +113,40 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsi
> >  	}
> >  }
> >+static __always_inline u32 *cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
> >+						unsigned x86_feature)
> >+{
> >+	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
> >+
> >+	return __cpuid_entry_get_reg(entry, &cpuid);
> >+}
> >+
> >+static __always_inline u32 cpuid_entry_get(struct kvm_cpuid_entry2 *entry,
> >+					   unsigned x86_feature)
> >+{
> >+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
> >+
> >+	return *reg & __feature_bit(x86_feature);
> >+}
> >+
> 
> This helper function is unnecessary. There is only one user throughout this
> series, i.e., cpuid_entry_has() below.

And the LA57 case above.

> And I cannot image other possible use case of it.

The LA57 case, which admittedly goes away soon, was subtle enough (OR in
the flag instead of querying yes/no) that I wanted keep the accessor around
in case a similar case popped up in the future.

> >+static __always_inline bool cpuid_entry_has(struct kvm_cpuid_entry2 *entry,
> >+					    unsigned x86_feature)
> >+{
> >+	return cpuid_entry_get(entry, x86_feature);
> >+}
> >+
> >+static __always_inline int *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
>                           ^
> Should be                 u32
> otherwise, previous patch will be unhappy. :)

Doh, thanks!
 
> >+{
> >+	struct kvm_cpuid_entry2 *entry;
> >+	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
> >+
> >+	entry = kvm_find_cpuid_entry(vcpu, cpuid.function, cpuid.index);
> >+	if (!entry)
> >+		return NULL;
> >+
> >+	return __cpuid_entry_get_reg(entry, &cpuid);
> >+}
> >+
> >  static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_feature)
> >  {
> >  	u32 *reg;
> >
> 
