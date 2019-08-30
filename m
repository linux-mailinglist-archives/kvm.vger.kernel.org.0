Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B63A2B55
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 02:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfH3APe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 29 Aug 2019 20:15:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:36471 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfH3APe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 20:15:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 17:15:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="332693126"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga004.jf.intel.com with ESMTP; 29 Aug 2019 17:15:32 -0700
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 29 Aug 2019 17:15:32 -0700
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 FMSMSX113.amr.corp.intel.com (10.18.116.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 29 Aug 2019 17:15:32 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.112]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.163]) with mapi id 14.03.0439.000;
 Fri, 30 Aug 2019 08:15:30 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Andi Kleen <ak@linux.intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC v1 1/9] KVM: x86: Add base address parameter for
 get_fixed_pmc function
Thread-Topic: [RFC v1 1/9] KVM: x86: Add base address parameter for
 get_fixed_pmc function
Thread-Index: AQHVXiwTvN9l0Wf/9ESeUncX5js89qcSGdmAgAC25tA=
Date:   Fri, 30 Aug 2019 00:15:29 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E1737F7892@SHSMSX104.ccr.corp.intel.com>
References: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
 <1567056849-14608-2-git-send-email-luwei.kang@intel.com>
 <20190829211015.GU5447@tassilo.jf.intel.com>
In-Reply-To: <20190829211015.GU5447@tassilo.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> >  /* returns fixed PMC with the specified MSR */ -static inline struct
> > kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
> > +static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32
> msr,
> > +								int base)
> 
> Better define a __get_fixed_pmc just for this case, with the existing
> get_fixed_pmc being a wrapper.
> 
> This would avoid changing all the callers below.

Do you mean change the code like this, and call "__get_fixed_pmc" in my patch? We already have a similar function to get gp counters.
struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr, u32 base)	// get gp counters
struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)		// get fixed counters

-/* returns fixed PMC with the specified MSR */
-static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
+static inline struct kvm_pmc *__get_fixed_pmc(struct kvm_pmu *pmu, u32 msr, u32 base)
 {
-       int base = MSR_CORE_PERF_FIXED_CTR0;
-
        if (msr >= base && msr < base + pmu->nr_arch_fixed_counters)
                return &pmu->fixed_counters[msr - base];

        return NULL;
 }

+/* returns fixed PMC with the specified MSR */
+static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
+{
+       return __get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0)
+}

Thanks,
Luwei Kang

> 
> 
> -Andi
