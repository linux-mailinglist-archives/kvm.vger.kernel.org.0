Return-Path: <kvm+bounces-22113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C052493A1F3
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 15:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C62941C22541
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 13:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B757153575;
	Tue, 23 Jul 2024 13:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="AzEZm7Ae"
X-Original-To: kvm@vger.kernel.org
Received: from out187-20.us.a.mail.aliyun.com (out187-20.us.a.mail.aliyun.com [47.90.187.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F378F70;
	Tue, 23 Jul 2024 13:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.187.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721742678; cv=none; b=MYZvAWNqM0LWSIswx3+FUoXvX9BeGJq4gPGbvELqGt0pKv6cBtLRuhVj2qnJGb2FF5GQt1dA4rTs87Wk4d3zuHPO7+fYZhHYMmtUpZT7lA24xaL//7v2rsZKN1A9ZUrh8eWw5kbKt3MlSjadxxWDfXHEkQ/PSPwMUdvli2Gt4RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721742678; c=relaxed/simple;
	bh=Ky2Zko+wHRdleQq8zIUXC9P800ciLsF5ZoFhcO3nu2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUO+dJj04TbYgSkXhHHEqD+pYrpQ+zmR3ltS81CP3dQ5SLCq26l/yw5nS6H3OhMXQrbMuRbqVmX6vkzxpaIkVx9xTcY7aVu0QRAx1Uo1AXAxPQWnYC1qyLOGkbWkFoRBfkWAOEA6KZOpNuAYYOt8P5KaUfH0kYH7IPqx8ViVYRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=AzEZm7Ae; arc=none smtp.client-ip=47.90.187.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1721742660; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=vCE01r08TqBO/rkkhma9XyaLno6uRIgtUtNxelheW40=;
	b=AzEZm7Ae/omvA26wBxYIo08NU7bw4bomIPu2PtaaKVa4bx/umvjvaLPEvWdzRT/fr8Mn4P2Qd3Ra1QDJMhNGCVzVgzz9y276yQu7gpf6Ng7u8S4aui1YwWH6ff2VmmppScR+UtU4lch6gg04N2ddcfzVgXROjwGq0UlJTFC81aI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033070021168;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---.YXQIh60_1721740804;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.YXQIh60_1721740804)
          by smtp.aliyun-inc.com;
          Tue, 23 Jul 2024 21:20:05 +0800
Date: Tue, 23 Jul 2024 21:20:04 +0800
From: "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: nVMX: Honor userspace MSR filter lists for nested
 VM-Enter/VM-Exit
Message-ID: <20240723132004.GA67088@k08j02272.eu95sqa>
References: <20240722235922.3351122-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240722235922.3351122-1-seanjc@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jul 23, 2024 at 07:59:22AM +0800, Sean Christopherson wrote:
> Synthesize a consistency check VM-Exit (VM-Enter) or VM-Abort (VM-Exit) if
> L1 attempts to load/store an MSR via the VMCS MSR lists that userspace has
> disallowed access to via an MSR filter.  Intel already disallows including
> a handful of "special" MSRs in the VMCS lists, so denying access isn't
> completely without precedent.
> 
> More importantly, the behavior is well-defined _and_ can be communicated
> the end user, e.g. to the customer that owns a VM running as L1 on top of
> KVM.  On the other hand, ignoring userspace MSR filters is all but
> guaranteed to result in unexpected behavior as the access will hit KVM's
> internal state, which is likely not up-to-date.
> 
> Unlike KVM-internal accesses, instruction emulation, and dedicated VMCS
> fields, the MSRs in the VMCS load/store lists are 100% guest controlled,
> thus making it all but impossible to reason about the correctness of
> ignoring the MSR filter.  And if userspace *really* wants to deny access
> to MSRs via the aforementioned scenarios, userspace can hide the
> associated feature from the guest, e.g. by disabling the PMU to prevent
> accessing PERF_GLOBAL_CTRL via its VMCS field.  But for the MSR lists, KVM
> is blindly processing MSRs; the  MSR filters are the _only_ way for
> userspace to deny access.
> 
> This partially reverts commit ac8d6cad3c7b ("KVM: x86: Only do MSR
> filtering when access MSR by rdmsr/wrmsr").
> 
> Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> I found this by inspection when backporting Hou's change to an internal kernel.
> I don't love piggybacking Intel's "you can't touch these special MSRs" behavior,
> but ignoring the userspace MSR filters is far worse IMO.  E.g. if userspace is
> denying access to an MSR in order to reduce KVM's attack surface, letting L1
> sneak in reads/writes through VM-Enter/VM-Exit completely circumvents the
> filters.
> 
>  Documentation/virt/kvm/api.rst  | 19 ++++++++++++++++---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/vmx/nested.c       | 12 ++++++------
>  arch/x86/kvm/x86.c              |  6 ++++--
>  4 files changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 8e5dad80b337..e6b1e42186f3 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4226,9 +4226,22 @@ filtering. In that mode, ``KVM_MSR_FILTER_DEFAULT_DENY`` is invalid and causes
>  an error.
>  
>  .. warning::
> -   MSR accesses as part of nested VM-Enter/VM-Exit are not filtered.
> -   This includes both writes to individual VMCS fields and reads/writes
> -   through the MSR lists pointed to by the VMCS.
> +   MSR accesses that are side effects of instruction execution (emulated or
> +   native) are not filtered as hardware does not honor MSR bitmaps outside of
> +   RDMSR and WRMSR, and KVM mimics that behavior when emulating instructions
> +   to avoid pointless divergence from hardware.  E.g. RDPID reads MSR_TSC_AUX,
> +   SYSENTER reads the SYSENTER MSRs, etc.
> +
> +   MSRs that are loaded/stored via dedicated VMCS fields are not filtered as
> +   part of VM-Enter/VM-Exit emulation.
> +
> +   MSRs that are loaded/store via VMX's load/store lists _are_ filtered as part
> +   of VM-Enter/VM-Exit emulation.  If an MSR access is denied on VM-Enter, KVM
> +   synthesizes a consistency check VM-Exit(EXIT_REASON_MSR_LOAD_FAIL).  If an
> +   MSR access is denied on VM-Exit, KVM synthesizes a VM-Abort.  In short, KVM
> +   extends Intel's architectural list of MSRs that cannot be loaded/saved via
> +   the VM-Enter/VM-Exit MSR list.  It is platform owner's responsibility to
> +   to communicate any such restrictions to their end users.
>
Do we also need to modify the statement before this warning? Since
the behaviour is different from RDMSR/WRMSR emulation case.

```
if an MSR access is denied by userspace the resulting KVM behavior depends on
whether or not KVM_CAP_X86_USER_SPACE_MSR's KVM_MSR_EXIT_REASON_FILTER is
enabled.  If KVM_MSR_EXIT_REASON_FILTER is enabled, KVM will exit to userspace
on denied accesses, i.e. userspace effectively intercepts the MSR access.
```

>     x2APIC MSR accesses cannot be filtered (KVM silently ignores filters that
>     cover any x2APIC MSRs).
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 950a03e0181e..94d0bedc42ee 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2059,6 +2059,8 @@ void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
>  
>  void kvm_enable_efer_bits(u64);
>  bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
> +int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data);
> +int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data);
>  int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiated);
>  int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
>  int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2392a7ef254d..674f7089cc44 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -981,7 +981,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
>  				__func__, i, e.index, e.reserved);
>  			goto fail;
>  		}
> -		if (kvm_set_msr(vcpu, e.index, e.value)) {
> +		if (kvm_set_msr_with_filter(vcpu, e.index, e.value)) {
>  			pr_debug_ratelimited(
>  				"%s cannot write MSR (%u, 0x%x, 0x%llx)\n",
>  				__func__, i, e.index, e.value);
> @@ -1017,7 +1017,7 @@ static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
>  		}
>  	}
>  
> -	if (kvm_get_msr(vcpu, msr_index, data)) {
> +	if (kvm_get_msr_with_filter(vcpu, msr_index, data)) {
>  		pr_debug_ratelimited("%s cannot read MSR (0x%x)\n", __func__,
>  			msr_index);
>  		return false;
> @@ -1112,9 +1112,9 @@ static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
>  			/*
>  			 * Emulated VMEntry does not fail here.  Instead a less
>  			 * accurate value will be returned by
> -			 * nested_vmx_get_vmexit_msr_value() using kvm_get_msr()
> -			 * instead of reading the value from the vmcs02 VMExit
> -			 * MSR-store area.
> +			 * nested_vmx_get_vmexit_msr_value() by reading KVM's
> +			 * internal MSR state instead of reading the value from
> +			 * the vmcs02 VMExit MSR-store area.
>  			 */
>  			pr_warn_ratelimited(
>  				"Not enough msr entries in msr_autostore.  Can't add msr %x\n",
> @@ -4806,7 +4806,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
>  				goto vmabort;
>  			}
>  
> -			if (kvm_set_msr(vcpu, h.index, h.value)) {
> +			if (kvm_set_msr_with_filter(vcpu, h.index, h.value)) {
>  				pr_debug_ratelimited(
>  					"%s WRMSR failed (%u, 0x%x, 0x%llx)\n",
>  					__func__, j, h.index, h.value);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index af6c8cf6a37a..7b3659a05c27 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1942,19 +1942,21 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
>  	return ret;
>  }
>  
> -static int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data)
> +int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data)
>  {
>  	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
>  		return KVM_MSR_RET_FILTERED;
>  	return kvm_get_msr_ignored_check(vcpu, index, data, false);
>  }
> +EXPORT_SYMBOL_GPL(kvm_get_msr_with_filter);
>  
> -static int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data)
> +int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data)
>  {
>  	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE))
>  		return KVM_MSR_RET_FILTERED;
>  	return kvm_set_msr_ignored_check(vcpu, index, data, false);
>  }
> +EXPORT_SYMBOL_GPL(kvm_set_msr_with_filter);
>  
>  int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
>  {
> 
> base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
> -- 
> 2.45.2.1089.g2a221341d9-goog

