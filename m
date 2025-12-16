Return-Path: <kvm+bounces-66082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AF8DCC4943
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 18:11:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DBA4430C9E4F
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 17:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 090F52D47ED;
	Tue, 16 Dec 2025 17:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="APyWnQWH"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E09288D6
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765904505; cv=none; b=fhCrPIB4NdFkIeSi/+B+eM3JhBWbPOfChNsJ8MRmN3ao8ZIoSIRke6Aqq8CwBZzvkN9w0ZvudGtM3LfBmotZmV1mH3NquAeNzyuMrSL6vPQWrcL67I1ip+DCVlRfWxziSlgXc82SqRaCURW7uc10paXwgPgaWb8lYd19LaIlybs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765904505; c=relaxed/simple;
	bh=D7Zo2A0MA7LAhZzUbq+V8joK/eexLAr1npK1MjrBnEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dxft58CDmKOqHx5/pWq8RiGZCPmAX7AxdU+pMbumwiHK+HpNOkDjzv4AUHpMA8oV68WytkymY+HcZVHWLhipP9wanGz1k+nsbFVgaAoRuHVR2C+9GNDSgQDhJGxLcZdMxTk15Qgytl0flzDzVUfutjQ5kRH2sAPTTfTpXRGbEbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=APyWnQWH; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 16 Dec 2025 17:01:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765904500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EUny2jwXEBeEbYt+gddMq53infKVKVOdAtsXZfNI5n4=;
	b=APyWnQWHn2MMuTuKEEv4938iLqXGCbu0fV9vFSVQsUg0kgr7cSLv86Enp64vx1Fe9GUHFf
	zez5TUQTeO/18cFnhUgboen6O/D2RXz5MuDq2Cewn6EKRBCpnwsY3UJpIZmTBNuMP1Cq2F
	0kddb7N9DwWhz7pn1pxzgR6LRjYzQFE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nSVM: Remove a user-triggerable WARN on
 nested_svm_load_cr3() succeeding
Message-ID: <qgxsouujnruyg3toab5r4thuktx4j45ifl2ivwlq24qccackeb@rw7ve5xzhi47>
References: <20251216161755.1775409-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216161755.1775409-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 16, 2025 at 08:17:54AM -0800, Sean Christopherson wrote:
> Drop the WARN in svm_set_nested_state() on nested_svm_load_cr3() failing
> as it is trivially easy to trigger from userspace by modifying CPUID after
> loading CR3.  E.g. modifying the state restoration selftest like so:
> 
>   --- tools/testing/selftests/kvm/x86/state_test.c
>   +++ tools/testing/selftests/kvm/x86/state_test.c
>   @@ -280,7 +280,16 @@ int main(int argc, char *argv[])
> 
>                  /* Restore state in a new VM.  */
>                   vcpu = vm_recreate_with_one_vcpu(vm);
>   -               vcpu_load_state(vcpu, state);
>   +
>   +               if (stage == 4) {
>   +                       state->sregs.cr3 = BIT(44);
>   +                       vcpu_load_state(vcpu, state);
>   +
>   +                       vcpu_set_cpuid_property(vcpu, X86_PROPERTY_MAX_PHY_ADDR, 36);
>   +                       __vcpu_nested_state_set(vcpu, &state->nested);
>   +               } else {
>   +                       vcpu_load_state(vcpu, state);
>   +               }
> 
>                   /*
>                    * Restore XSAVE state in a dummy vCPU, first without doing
> 
> generates:
> 
>   WARNING: CPU: 30 PID: 938 at arch/x86/kvm/svm/nested.c:1877 svm_set_nested_state+0x34a/0x360 [kvm_amd]
>   Modules linked in: kvm_amd kvm irqbypass [last unloaded: kvm]
>   CPU: 30 UID: 1000 PID: 938 Comm: state_test Tainted: G        W           6.18.0-rc7-58e10b63777d-next-vm
>   Tainted: [W]=WARN
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:svm_set_nested_state+0x34a/0x360 [kvm_amd]
>   Call Trace:
>    <TASK>
>    kvm_arch_vcpu_ioctl+0xf33/0x1700 [kvm]
>    kvm_vcpu_ioctl+0x4e6/0x8f0 [kvm]
>    __x64_sys_ioctl+0x8f/0xd0
>    do_syscall_64+0x61/0xad0
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
> 
> Simply delete the WARN instead of trying to prevent userspace from shoving
> "illegal" state into CR3.  For better or worse, KVM's ABI allows userspace
> to set CPUID after SREGS, and vice versa, and KVM is very permissive when
> it comes to guest CPUID.  I.e. attempting to enforce the virtual CPU model
> when setting CPUID could break userspace.  Given that the WARN doesn't
> provide any meaningful protection for KVM or benefit for userspace, simply
> drop it even though the odds of breaking userspace are minuscule.
> 
> Opportunistically delete a spurious newline.
> 
> Fixes: b222b0b88162 ("KVM: nSVM: refactor the CR3 reload on migration")
> Cc: stable@vger.kernel.org
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/svm/nested.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index ba0f11c68372..9be67040e94d 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1870,10 +1870,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	 * thus MMU might not be initialized correctly.
>  	 * Set it again to fix this.
>  	 */
> -
>  	ret = nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
>  				  nested_npt_enabled(svm), false);
> -	if (WARN_ON_ONCE(ret))
> +	if (ret)
>  		goto out_free;
>  
>  	svm->nested.force_msr_bitmap_recalc = true;
> 
> base-commit: 2111f7ca0e92dec60f0a3644ff3b164342af33c1
> -- 
> 2.52.0.239.gd5f0c6e74e-goog
> 

