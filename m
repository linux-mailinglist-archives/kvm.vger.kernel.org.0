Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D5423C158
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 23:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgHDVTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 17:19:44 -0400
Received: from mga05.intel.com ([192.55.52.43]:39223 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbgHDVTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 17:19:44 -0400
IronPort-SDR: KVvYRpl5XB8uMMbJqRqZU66JFAoPpU3yj6qjWAx01Bl+hgvVzyTm7CaKd1hnWvTwRSQYN4JvCX
 Bw1inz2k406Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="237274095"
X-IronPort-AV: E=Sophos;i="5.75,435,1589266800"; 
   d="scan'208";a="237274095"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 14:19:44 -0700
IronPort-SDR: tDUOl/sJnNywErFD3cDHMInS2J2vv5wxxo9u8N+4PvmCBM17EQMONK15pK6MKePjjEGxfPx954
 XuDMR5oEY1hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,435,1589266800"; 
   d="scan'208";a="492598955"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga006.fm.intel.com with ESMTP; 04 Aug 2020 14:19:43 -0700
Date:   Tue, 4 Aug 2020 14:19:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 2/2] KVM: LAPIC: Guarantee the timer is in tsc-deadline
 mode when setting
Message-ID: <20200804211943.GC31916@linux.intel.com>
References: <1596521448-4010-1-git-send-email-wanpengli@tencent.com>
 <1596521448-4010-2-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596521448-4010-2-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 04, 2020 at 02:10:48PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Check apic_lvtt_tscdeadline() mode directly instead of apic_lvtt_oneshot()
> and apic_lvtt_period() to guarantee the timer is in tsc-deadline mode when
> wrmsr MSR_IA32_TSCDEADLINE.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index d89ab48..7b11fa8 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2193,8 +2193,8 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  
> -	if (!kvm_apic_present(vcpu) || apic_lvtt_oneshot(apic) ||
> -			apic_lvtt_period(apic))
> +	if (!kvm_apic_present(vcpu) ||
> +		!apic_lvtt_tscdeadline(apic))

Definitely prefer to fix the indentation here since both lines are touched
anyways.

>  		return;
>  
>  	hrtimer_cancel(&apic->lapic_timer.timer);
> -- 
> 2.7.4
> 
