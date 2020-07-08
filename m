Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD0A218944
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 15:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbgGHNgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 09:36:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:28566 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729136AbgGHNgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 09:36:47 -0400
IronPort-SDR: vDi9TIsAiLgs3ZjvNWcK/INI6BYBW05cSV5551oSWgDgvtPRqq5NWRUOxP//gdSHnAc5tk3enY
 rirNfaHMclVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="149303332"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="149303332"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 06:36:46 -0700
IronPort-SDR: sBjCS0bDzDZEStrVmswPSJTukdpM2T4Cpc8vJ1rdc5wyfQEHRCQvLOHemHrDeCSkqGdXbCtW+R
 FlnjpsDTWaXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="306048061"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by fmsmga004.fm.intel.com with ESMTP; 08 Jul 2020 06:36:46 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 2D515301B2A; Wed,  8 Jul 2020 06:36:46 -0700 (PDT)
Date:   Wed, 8 Jul 2020 06:36:46 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v12 06/11] KVM: vmx/pmu: Expose LBR to guest via
 MSR_IA32_PERF_CAPABILITIES
Message-ID: <20200708133646.GM3448022@tassilo.jf.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
 <20200613080958.132489-7-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200613080958.132489-7-like.xu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +	/*
> +	 * As a first step, a guest could only enable LBR feature if its cpu
> +	 * model is the same as the host because the LBR registers would
> +	 * be pass-through to the guest and they're model specific.
> +	 */
> +	if (boot_cpu_data.x86_model != guest_cpuid_model(vcpu))
> +		return false;

Could we relax this in a followon patch? (after this series is merged)

It's enough of the perf cap LBR version matches, don't need full model
number match. This would require a way to configure the LBR version
from qemu.

This would allow more flexibility, for example migration from
Icelake to Skylake and vice versa.

-Andi
