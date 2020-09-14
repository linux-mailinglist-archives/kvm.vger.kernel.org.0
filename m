Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6585D2697AF
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 23:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgINV0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 17:26:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:34059 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgINV0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 17:26:40 -0400
IronPort-SDR: 9OZ0uYz76t79GP5OHxVsyEDXDDxq7o6oU06zgc61Seqn0Mp6czgidGu94NIzzpJjYjLrmDnNjX
 /tnWsOXO9iew==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="243994756"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="243994756"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:26:39 -0700
IronPort-SDR: qYfnipeeOvP60av9B8njck78J5Ni3gb3ze3t6CfQcPhBN5ybNFOaqTLPSMhSHLJR6jzA45SpiZ
 EQoRpoGgD1zg==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="330903929"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:26:38 -0700
Date:   Mon, 14 Sep 2020 14:26:01 -0700
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
Subject: Re: [RFC PATCH 08/35] KVM: SVM: Prevent debugging under SEV-ES
Message-ID: <20200914212601.GA7192@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <58093c542b5b442b88941828595fb2548706f1bf.1600114548.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58093c542b5b442b88941828595fb2548706f1bf.1600114548.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 03:15:22PM -0500, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Since the guest register state of an SEV-ES guest is encrypted, debugging
> is not supported. Update the code to prevent guest debugging when the
> guest is an SEV-ES guest. This includes adding a callable function that
> is used to determine if the guest supports being debugged.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/svm/svm.c          | 16 ++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c          |  7 +++++++
>  arch/x86/kvm/x86.c              |  3 +++
>  4 files changed, 28 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c900992701d6..3e2a3d2a8ba8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1234,6 +1234,8 @@ struct kvm_x86_ops {
>  	void (*reg_read_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
>  	void (*reg_write_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg,
>  				   unsigned long val);
> +
> +	bool (*allow_debug)(struct kvm *kvm);

Why add both allow_debug() and vmsa_encrypted?  I assume there are scenarios
where allow_debug() != vmsa_encrypted?  E.g. is there a debug mode for SEV-ES
where the VMSA is not encrypted, but KVM (ironically) can't intercept #DBs or
something?

Alternatively, have you explored using a new VM_TYPE for SEV-ES guests?  With
a genericized vmsa_encrypted, that would allow something like the following
for scenarios where the VMSA is not (yet?) encrypted for an SEV-ES guest.  I
don't love bleeding the VM type into x86.c, but for one-off quirks like this
I think it'd be preferable to adding a kvm_x86_ops hook.

int kvm_arch_vcpu_ioctl_set_guest_debug(...)
{
	if (vcpu->arch.guest_state_protected ||
	    kvm->arch.vm_type == KVM_X86_SEV_ES_VM)
		return -EINVAL;
}
