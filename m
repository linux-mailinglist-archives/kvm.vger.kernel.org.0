Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FC627E067
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 07:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgI3Fej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 01:34:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:2584 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgI3Fej (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 01:34:39 -0400
IronPort-SDR: wEkagHFAa8W8wA1HXU9GT9+vUOSLgdd+aMI7q0OtsETUQBF3QRrTPxYF8l1iY2q/vSbrwEOvGY
 EamcmgCPfMIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="180523724"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="180523724"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 22:34:38 -0700
IronPort-SDR: i22wC5mm8U6fuprJeZLlH/5QO1kTU7toiR4BkqKW8qLBCTMQE04uGHbdZLqCYRTEg89i2Ms+BC
 6FXEhRkHqhWA==
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="312470123"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 22:34:37 -0700
Date:   Tue, 29 Sep 2020 22:34:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 03/22] kvm: mmu: Init / Uninit the TDP MMU
Message-ID: <20200930053430.GE29405@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-4-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-4-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit on all the shortlogs, can you use "KVM: x86/mmu" instead of "kvm: mmu"?

On Fri, Sep 25, 2020 at 02:22:43PM -0700, Ben Gardon wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> new file mode 100644
> index 0000000000000..8241e18c111e6
> --- /dev/null
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include "tdp_mmu.h"
> +
> +static bool __read_mostly tdp_mmu_enabled = true;
> +module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);

Do y'all actually toggle tdp_mmu_enabled while VMs are running?  I can see
having a per-VM capability, or a read-only module param, but a writable
module param is... interesting.

> +static bool is_tdp_mmu_enabled(void)
> +{
> +	if (!READ_ONCE(tdp_mmu_enabled))
> +		return false;
> +
> +	if (WARN_ONCE(!tdp_enabled,
> +		      "Creating a VM with TDP MMU enabled requires TDP."))

This should be enforced, i.e. clear tdp_mmu_enabled if !tdp_enabled.  As is,
it's a user triggerable WARN, which is not good, e.g. with PANIC_ON_WARN.

> +		return false;
> +
> +	return true;
> +}
