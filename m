Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1192697C4
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 23:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgINVd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 17:33:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:25021 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgINVd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 17:33:57 -0400
IronPort-SDR: yvfDdULCMdIBRs9KnitROdwEcGY1BoLY1WugX7+jU5UmMI8Kvkn2OMzlsIDg6N6KDejCbbq2DV
 6saoYPVod32A==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160099522"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="160099522"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:33:55 -0700
IronPort-SDR: nGTbaMpiU4wZHuj2i6cMB45vT3BMsCKDALY7iak+RYD4SiLbB/+G66lwRLfjIfiJbMPmw7n0kE
 YP1Ev94o0aAQ==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="507296327"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:33:55 -0700
Date:   Mon, 14 Sep 2020 14:33:53 -0700
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
Subject: Re: [RFC PATCH 09/35] KVM: SVM: Do not emulate MMIO under SEV-ES
Message-ID: <20200914213352.GB7192@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <c4ccb48b41f3996bc9000730309455e449cb1136.1600114548.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4ccb48b41f3996bc9000730309455e449cb1136.1600114548.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 03:15:23PM -0500, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> When a guest is running as an SEV-ES guest, it is not possible to emulate
> MMIO. Add support to prevent trying to perform MMIO emulation.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a5d0207e7189..2e1b8b876286 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5485,6 +5485,13 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
>  		emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
>  emulate:
> +	/*
> +	 * When the guest is an SEV-ES guest, emulation is not possible.  Allow
> +	 * the guest to handle the MMIO emulation.
> +	 */
> +	if (vcpu->arch.vmsa_encrypted)
> +		return 1;

A better approach is to refactor need_emulation_on_page_fault() (the hook
that's just out of sight in this patch) into a more generic
kvm_x86_ops.is_emulatable() so that the latter can be used to kill emulation
everywhere, and for other reasons.  E.g. TDX obviously shares very similar
logic, but SGX also adds a case where KVM can theoretically end up in an
emulator path without the ability to access the necessary guest state.

I have exactly such a prep patch (because SGX and TDX...), I'll get it posted
in the next day or two.

> +
>  	/*
>  	 * On AMD platforms, under certain conditions insn_len may be zero on #NPF.
>  	 * This can happen if a guest gets a page-fault on data access but the HW
> -- 
> 2.28.0
> 
