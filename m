Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA3D1A90F8
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 04:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405472AbgDOChd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 22:37:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:21022 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbgDOCh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 22:37:27 -0400
IronPort-SDR: 4q9rNAAYexd7d2NFzb/KI0wdbc5nWP6kJHpCqMR+mFIG6Z5DEZ7PGvNcbY8QbkZWsxlmuBl+6C
 uE820vEgPtbA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2020 19:37:26 -0700
IronPort-SDR: OqNLaOw3JF/FuoJ8wEVXwaYE4EFIrrIf7Gmgt4l2XkUrfzesJw1451rmBQIbGK+bc+BvfQ35Nc
 BoFXCSzu5L8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,385,1580803200"; 
   d="scan'208";a="298873774"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Apr 2020 19:37:26 -0700
Date:   Tue, 14 Apr 2020 19:37:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jon Cargille <jcargill@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Northup <digitaleric@gmail.com>,
        Eric Northup <digitaleric@google.com>
Subject: Re: [PATCH 1/1] KVM: pass through CPUID(0x80000006)
Message-ID: <20200415023726.GD12547@linux.intel.com>
References: <20200415012320.236065-1-jcargill@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415012320.236065-1-jcargill@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 14, 2020 at 06:23:20PM -0700, Jon Cargille wrote:
> From: Eric Northup <digitaleric@gmail.com>
> 
> Return L2 cache and TLB information to guests.
> They could have been set before, but the defaults that KVM returns will be
> necessary for usermode that doesn't supply their own CPUID tables.

I don't follow the changelog.  The code makes sense, but I don't understand
the justification.  This only affects KVM_GET_SUPPORTED_CPUID, i.e. what's
advertised to userspace, it doesn't directly change CPUID emulation in any
way.  The "They could have been set before" blurb is especially confusing.

I assume you want to say something like:

  Return the host's L2 cache and TLB information for CPUID.0x80000006
  instead of zeroing out the entry as part of KVM_GET_SUPPORTED_CPUID.
  This allows a userspace VMM to feed KVM_GET_SUPPORTED_CPUID's output
  directly into KVM_SET_CPUID2 (without breaking the guest).

> Signed-off-by: Eric Northup <digitaleric@google.com>
> Signed-off-by: Eric Northup <digitaleric@gmail.com>
> Signed-off-by: Jon Cargille <jcargill@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>

Jim's tag is unnecessary, unless he was a middleman between Eric and Jon,
in which case Jim's tag should also come between Eric's and Jon's.

Only one of Eric's signoffs is needed (the one that matches the From: tag,
i.e. is the official author).  I'm guessing Google would prefer the author
to be the @google.com address.

> ---
>  arch/x86/kvm/cpuid.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b1c469446b072..4a8d67303a42c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -734,6 +734,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  		entry->ecx &= kvm_cpuid_8000_0001_ecx_x86_features;
>  		cpuid_mask(&entry->ecx, CPUID_8000_0001_ECX);
>  		break;
> +	case 0x80000006:
> +		/* L2 cache and TLB: pass through host info. */
> +		break;
>  	case 0x80000007: /* Advanced power management */
>  		/* invariant TSC is CPUID.80000007H:EDX[8] */
>  		entry->edx &= (1 << 8);
> -- 
> 2.25.1.481.gfbce0eb801-goog
> 
