Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84062698B6
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 00:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgINWTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 18:19:07 -0400
Received: from mga05.intel.com ([192.55.52.43]:38202 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbgINWTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 18:19:06 -0400
IronPort-SDR: l2Zbp1jx2gSfNPRG0MI+K/t53d4/Lw5PFyMvvKsPw2/d8+zw4qaTJGnn/mr9XaG30HpUd20kSI
 grrk733aAAvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="243999771"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="243999771"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 15:19:06 -0700
IronPort-SDR: kFY+wrO5tWrXv8mvUaRuZC/yYt2BeSIDtkeT0mBjuzGtdKcdN0GYsPYSw4qPq9D/LFflkLJVOp
 o849L8j0Dfrw==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="345589599"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 15:19:06 -0700
Date:   Mon, 14 Sep 2020 15:19:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH 24/35] KVM: SVM: Add support for CR8 write traps for
 an SEV-ES guest
Message-ID: <20200914221904.GL7192@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <e3438655021a0ca0c7ef5903b9250c4b4c285d82.1600114548.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3438655021a0ca0c7ef5903b9250c4b4c285d82.1600114548.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 03:15:38PM -0500, Tom Lendacky wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5e5f1e8fed3a..6e445a76b691 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1109,6 +1109,12 @@ unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_get_cr8);
>  
> +int kvm_track_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
> +{
> +	return kvm_set_cr8(vcpu, cr8);

I'm guessing this was added to achieve consistency at the SVM call sites.
With the previously suggested changes, kvm_track_cr8() can simply be
dropped.

> +}
> +EXPORT_SYMBOL_GPL(kvm_track_cr8);
> +
>  static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
>  {
>  	int i;
> -- 
> 2.28.0
> 
