Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253AD26E070
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 18:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgIQQQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 12:16:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:20561 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728345AbgIQQPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 12:15:54 -0400
IronPort-SDR: bz1/n0NOc9jNVRTjMzaQ4Novv5FUKTQCv677VGGnuHPUjEuN0P4TmfLDdH7DiQBBSO8sF6YNxE
 o3rDPqHLKrzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="147424938"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="147424938"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 09:14:52 -0700
IronPort-SDR: R5mUICFwZKuKAO9KC2ySr+6STYYqlq/nADHq/Ypxmab0Slc+5fjZSTaesVf67q3Ulvo43ovO5Q
 n0tpqXqSvZUQ==
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="320273937"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 09:14:52 -0700
Date:   Thu, 17 Sep 2020 09:14:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/1] KVM: x86: fix MSR_IA32_TSC read for nested migration
Message-ID: <20200917161450.GD13522@sjchrist-ice>
References: <20200917110723.820666-1-mlevitsk@redhat.com>
 <20200917110723.820666-2-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917110723.820666-2-mlevitsk@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 02:07:23PM +0300, Maxim Levitsky wrote:
> +		 * Intel PRM states that MSR_IA32_TSC read adds the TSC offset

One more nit, "Intel SDM" would be preferred as that's most commonly used in
KVM changelogs, and there are multiple PRM acronyms in Intel's dictionary
these days.

> +		 * even when not intercepted. AMD manual doesn't define this
> +		 * but appears to behave the same
> +		 *
> +		 * However when userspace wants to read this MSR, return its
> +		 * real L1 value so that its restore will be correct
> +		 *
> +		 */
> +		if (msr_info->host_initiated)
> +			msr_info->data = kvm_read_l1_tsc(vcpu, rdtsc());
> +		else
> +			msr_info->data = kvm_read_l2_tsc(vcpu, rdtsc());
>  		break;
>  	case MSR_MTRRcap:
>  	case 0x200 ... 0x2ff:
> -- 
> 2.26.2
> 
