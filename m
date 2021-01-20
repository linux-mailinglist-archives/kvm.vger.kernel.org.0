Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E61C2FD325
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 15:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732699AbhATOu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 09:50:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730706AbhATOUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 09:20:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 645F02080D;
        Wed, 20 Jan 2021 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611152364;
        bh=9TPjieyQlLFEySF60ma2VnmvODCssS7zoUtLVRHv/no=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WHm5iTa0ow9eeommwyY6Lfafy2G9VMmJEl8rlyfKbDqG7FIsYUpb/MtLmoMqeBZF3
         sxxcsjX5VugmEAJF9Mkpnm/c5myNWuzIw2LQoa+9RclATYQbhGqDK7hyJkOVs7Qdpt
         vEupWsY6n49Ze+u8JXdZfZkCl81cKqh3ISKX9RWmc9QmcgagxXMXa2KnwUW/3sFOSz
         hrveggvZVxKjPNXtB9qVlsWjDwwP/MN9QiF2I8dE8wIQkCerX9WuMdhrAR2p4fIxlS
         tF18UcemcOUVWWO3yAEhR1Rde/aBoCFYPRNEy0lt11BzAyAJMrWSfNnzbUBEiFuIzL
         UXuVm5NIBxflg==
Date:   Wed, 20 Jan 2021 16:19:18 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [RFC PATCH v2 16/26] KVM: x86: Export
 kvm_mmu_gva_to_gpa_{read,write}() for SGX (VMX)
Message-ID: <YAg75hHsWm0j/pnJ@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <347d84df280cc326ebdb097ab3a30aed2818ae8c.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <347d84df280cc326ebdb097ab3a30aed2818ae8c.1610935432.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 04:28:27PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Export the gva_to_gpa() helpers for use by SGX virtualization when
> executing ENCLS[ECREATE] and ENCLS[EINIT] on behalf of the guest.
> To execute ECREATE and EINIT, KVM must obtain the GPA of the target
> Secure Enclave Control Structure (SECS) in order to get its
> corresponding HVA.
> 
> Because the SECS must reside in the Enclave Page Cache (EPC), copying
> the SECS's data to a host-controlled buffer via existing exported
> helpers is not a viable option as the EPC is not readable or writable
> by the kernel.
> 
> SGX virtualization will also use gva_to_gpa() to obtain HVAs for
> non-EPC pages in order to pass user pointers directly to ECREATE and
> EINIT, which avoids having to copy pages worth of data into the kernel.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

> ---
>  arch/x86/kvm/x86.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9a8969a6dd06..5ca7b181a3ae 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5891,6 +5891,7 @@ gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
>  	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
>  	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
>  }
> +EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_read);
>  
>   gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
>  				struct x86_exception *exception)
> @@ -5907,6 +5908,7 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
>  	access |= PFERR_WRITE_MASK;
>  	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
>  }
> +EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_write);
>  
>  /* uses this to access any guest's mapped memory without checking CPL */
>  gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
> -- 
> 2.29.2
> 
> 
