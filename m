Return-Path: <kvm+bounces-37942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B634A31BC6
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 03:13:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 122E73A7736
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 02:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB43A1922F6;
	Wed, 12 Feb 2025 02:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AdSt1dxU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921A914A62B
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 02:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739326349; cv=none; b=j/jTUV4fXYriCF+tgzy2PO9i+rltAc8g5fGDRdoLANhujTNb2IpUbZV/quQAe8n6duRA8kEiOoYwIemXZbbHB6wbTjMUxyydSKO5TxP9a3D+F4SHUUAtlbOqVHJPtGxAZS7SxuhWcDiQdS/P0pRV2O4C4UtTurVOiXkyLlulg10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739326349; c=relaxed/simple;
	bh=TpFl7Lw89cIlAWzJ2lUWEh/odF3NtASxCZF9rw5Vknk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HnMirqVvp9lgbOJ85JkqMQxYGwvcU4CX4Hs8AWHmz95qOLYXK+GSL9DYNvntG/Y0osp8/+GwLt8a/7+isr50gtoHAni6zVMEP0V0Nj2lTDTBn5tsk4sYDZIEYb6nVGdE3trG+J63RKlV1d/um+IrmcBFLV4vqcEK+5lDvKLeoRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AdSt1dxU; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21f61a983ddso159441035ad.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 18:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739326346; x=1739931146; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+p//+Ke3YywyxqGDeDFj8EHejeodR4QKYcWQKvVpodY=;
        b=AdSt1dxUe0O5fwFE1m6awLBGWQYZDoxJxJ35XOfqx1tfrN5WDYSH7a3oqaIIMUHRFs
         I2twNBX1gur5XBaO5ECEgOyaHGxzR4gVgPvzCD1W/7R5aTHC7NUe1q07an+/JTFnzJIm
         WSWewyLBOJ0boNwnR6jph8xx9Sn2h4HHVCVStU7N0JgP4q6ifk64fFXS/7YkXvZ9EjCt
         vOZWdoCPXUTHYPAKAQWSdGY9cOfCmKMQSkeknin/IS5tuDuL2UihSlyjJ6LcN73pOO+k
         ASZoZLd0jIBfevG8DQRCm8dezSSdLWvGKYO19Is9yv2cY1fq+zHzBaiyze5E9MaoEvtO
         S++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739326346; x=1739931146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+p//+Ke3YywyxqGDeDFj8EHejeodR4QKYcWQKvVpodY=;
        b=kmH8QlAYn/xOAQn0irR1uSB2+n7xNhAGsEl5chFa4rUIlgZJDq/HFFU++VTg/GnWX6
         aBpBTihEvY4fGzUe3up2C4QcojWlTiwU9eAMraqIOp6ihHxwFIM2a2ALunHy8Fwn3V3L
         PUWahtNTIyteUI/1ybVhDQmgWHOdikhoXG+40sQ8sfKI2AHDrx5wldHdGvyH0CgGsUC1
         Ahq86MwqAoH2hhjE6UkexNj/9r3+g2qVI+sM8sKZQ057nuJiTx1BIggSUCEM4QvIW7Dq
         mwEvIJD/qvpAGmgnACalEd5v/l9WyoWHWgXhaBAT/X8PA5jU5PDodT/vc/T9qUifnewx
         TEog==
X-Forwarded-Encrypted: i=1; AJvYcCU04kGdfEXquae2ugIkGP5ikuSbjmSFJjgESU3oLeisEwywLL3AnEV5uFEO4ThOe8QDOA8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL9l2DcmJ63Xbly3GDtpij3maY+qOeuBWXXqhp8CaNQcx6FmFC
	W2wi3gF4LO+kRUdfLUp2XwuTZ1ytworttnVTEEuDiE9uzH6pEeSvCVBsghgrlhYXhi86oxS/WxX
	esw==
X-Google-Smtp-Source: AGHT+IEOguqaLTeuzE0nWBWnVdq6iXbh6cb+qBQ/IrNI0fqmcNWAQGhEjoP63UBJ/QUq7n9oW6ewroBHiM4=
X-Received: from pjbpq16.prod.google.com ([2002:a17:90b:3d90:b0:2e9:38ea:ca0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea11:b0:216:46f4:7e3d
 with SMTP id d9443c01a7336-220bbad6f94mr22294475ad.15.1739326345906; Tue, 11
 Feb 2025 18:12:25 -0800 (PST)
Date: Tue, 11 Feb 2025 18:12:24 -0800
In-Reply-To: <20250203223205.36121-7-prsampat@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250203223205.36121-1-prsampat@amd.com> <20250203223205.36121-7-prsampat@amd.com>
Message-ID: <Z6wDiOGjSElatLBd@google.com>
Subject: Re: [PATCH v6 6/9] KVM: selftests: Add library support for
 interacting with SNP
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, shuah@kernel.org, 
	pgonda@google.com, ashish.kalra@amd.com, nikunj@amd.com, pankaj.gupta@amd.com, 
	michael.roth@amd.com, sraithal@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 03, 2025, Pratik R. Sampat wrote:
> Extend the SEV library to include support for SNP ioctl() wrappers,
> which aid in launching and interacting with a SEV-SNP guest.
> 
> Tested-by: Srikanth Aithal <sraithal@amd.com>
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---
> v5..v6:
> 
> * Collected tags from Srikanth.
> ---
>  tools/testing/selftests/kvm/include/x86/sev.h | 49 ++++++++++-
>  tools/testing/selftests/kvm/lib/x86/sev.c     | 82 +++++++++++++++++--
>  2 files changed, 125 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
> index faed91435963..fd5d5261e10e 100644
> --- a/tools/testing/selftests/kvm/include/x86/sev.h
> +++ b/tools/testing/selftests/kvm/include/x86/sev.h
> @@ -22,9 +22,20 @@ enum sev_guest_state {
>  	SEV_GUEST_STATE_RUNNING,
>  };
>  
> +/* Minimum firmware version required for the SEV-SNP support */
> +#define SNP_MIN_API_MAJOR	1
> +#define SNP_MIN_API_MINOR	51

Dead code.  Selftests don't care about this.

>  #define SEV_POLICY_NO_DBG	(1UL << 0)
>  #define SEV_POLICY_ES		(1UL << 2)
>  
> +#define SNP_POLICY_SMT		(1ULL << 16)
> +#define SNP_POLICY_RSVD_MBO	(1ULL << 17)
> +#define SNP_POLICY_DBG		(1ULL << 19)
> +
> +#define SNP_FW_VER_MINOR(min)	((uint8_t)(min) << 0)
> +#define SNP_FW_VER_MAJOR(maj)	((uint8_t)(maj) << 8)

Also dead code.

>  #define GHCB_MSR_TERM_REQ	0x100
>  
>  #define VMGEXIT()		{ __asm__ __volatile__("rep; vmmcall"); }
> @@ -36,13 +47,35 @@ bool is_sev_snp_vm(struct kvm_vm *vm);
>  void sev_vm_launch(struct kvm_vm *vm, uint32_t policy);
>  void sev_vm_launch_measure(struct kvm_vm *vm, uint8_t *measurement);
>  void sev_vm_launch_finish(struct kvm_vm *vm);
> +void snp_vm_launch_start(struct kvm_vm *vm, uint64_t policy);
> +void snp_vm_launch_update(struct kvm_vm *vm);
> +void snp_vm_launch_finish(struct kvm_vm *vm);
>  
>  struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t type, void *guest_code,
>  					   struct kvm_vcpu **cpu);
> -void vm_sev_launch(struct kvm_vm *vm, uint32_t policy, uint8_t *measurement);
> +void vm_sev_launch(struct kvm_vm *vm, uint64_t policy, uint8_t *measurement);
>  
>  kvm_static_assert(SEV_RET_SUCCESS == 0);
>  
> +/*
> + * A SEV-SNP VM requires the policy reserved bit to always be set.
> + * The SMT policy bit is also required to be set based on SMT being
> + * available and active on the system.
> + */
> +static inline u64 snp_default_policy(void)
> +{
> +	bool smt_active = false;
> +	FILE *f;
> +
> +	f = fopen("/sys/devices/system/cpu/smt/active", "r");

Please add a helper to query if SMT is enabled.  I doubt there will ever be many
users of this, but it doesn't seem like something that should buried in SNP code.

Ha!  smt_possible() in tools/testing/selftests/kvm/x86/hyperv_cpuid.c is already
guilty of burying a related helper, and it looks like it's a more robust version.

> +	if (f) {
> +		smt_active = fgetc(f) - '0';
> +		fclose(f);
> +	}
> +
> +	return SNP_POLICY_RSVD_MBO | (smt_active ? SNP_POLICY_SMT : 0);
> +}
> +
>  /*
>   * The KVM_MEMORY_ENCRYPT_OP uAPI is utter garbage and takes an "unsigned long"
>   * instead of a proper struct.  The size of the parameter is embedded in the
> @@ -76,6 +109,7 @@ kvm_static_assert(SEV_RET_SUCCESS == 0);
>  
>  void sev_vm_init(struct kvm_vm *vm);
>  void sev_es_vm_init(struct kvm_vm *vm);
> +void snp_vm_init(struct kvm_vm *vm);
>  
>  static inline void sev_register_encrypted_memory(struct kvm_vm *vm,
>  						 struct userspace_mem_region *region)
> @@ -99,4 +133,17 @@ static inline void sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
>  	vm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_DATA, &update_data);
>  }
>  
> +static inline void snp_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
> +					  uint64_t hva, uint64_t size, uint8_t type)
> +{
> +	struct kvm_sev_snp_launch_update update_data = {
> +		.uaddr = hva,
> +		.gfn_start = gpa >> PAGE_SHIFT,
> +		.len = size,
> +		.type = type,
> +	};
> +
> +	vm_sev_ioctl(vm, KVM_SEV_SNP_LAUNCH_UPDATE, &update_data);
> +}
> +
>  #endif /* SELFTEST_KVM_SEV_H */
> diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
> index 280ec42e281b..17d493e9907a 100644
> --- a/tools/testing/selftests/kvm/lib/x86/sev.c
> +++ b/tools/testing/selftests/kvm/lib/x86/sev.c
> @@ -31,7 +31,8 @@ bool is_sev_vm(struct kvm_vm *vm)
>   * and find the first range, but that's correct because the condition
>   * expression would cause us to quit the loop.
>   */
> -static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *region)
> +static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *region,
> +			   uint8_t page_type)
>  {
>  	const struct sparsebit *protected_phy_pages = region->protected_phy_pages;
>  	const vm_paddr_t gpa_base = region->region.guest_phys_addr;
> @@ -41,13 +42,35 @@ static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *regio
>  	if (!sparsebit_any_set(protected_phy_pages))
>  		return;
>  
> -	sev_register_encrypted_memory(vm, region);
> +	if (!is_sev_snp_vm(vm))
> +		sev_register_encrypted_memory(vm, region);
>  
>  	sparsebit_for_each_set_range(protected_phy_pages, i, j) {
>  		const uint64_t size = (j - i + 1) * vm->page_size;
>  		const uint64_t offset = (i - lowest_page_in_region) * vm->page_size;
>  
> -		sev_launch_update_data(vm, gpa_base + offset, size);
> +		if (is_sev_snp_vm(vm)) {

Curly braces are unnecessary.

> +			snp_launch_update_data(vm, gpa_base + offset,
> +					       (uint64_t)addr_gpa2hva(vm, gpa_base + offset),
> +					       size, page_type);
> +		} else {
> +			sev_launch_update_data(vm, gpa_base + offset, size);
> +		}
> +	}
> +}
> +
> +static void privatize_region(struct kvm_vm *vm, struct userspace_mem_region *region)

Can't this just be a param to encrypt_region() that also says "make it private"?

> +{
> +	const struct sparsebit *protected_phy_pages = region->protected_phy_pages;
> +	const vm_paddr_t gpa_base = region->region.guest_phys_addr;
> +	const sparsebit_idx_t lowest_page_in_region = gpa_base >> vm->page_shift;
> +	sparsebit_idx_t i, j;
> +
> +	sparsebit_for_each_set_range(protected_phy_pages, i, j) {
> +		const uint64_t size = (j - i + 1) * vm->page_size;
> +		const uint64_t offset = (i - lowest_page_in_region) * vm->page_size;
> +
> +		vm_mem_set_private(vm, gpa_base + offset, size);
>  	}
>  }
>  
> @@ -77,6 +100,14 @@ void sev_es_vm_init(struct kvm_vm *vm)
>  	}
>  }
>  
> +void snp_vm_init(struct kvm_vm *vm)
> +{
> +	struct kvm_sev_init init = { 0 };
> +
> +	assert(vm->type == KVM_X86_SNP_VM);

Use TEST_ASSERT(), or do nothing, don't use assert().

> +	vm_sev_ioctl(vm, KVM_SEV_INIT2, &init);
> +}
> +
>  void sev_vm_launch(struct kvm_vm *vm, uint32_t policy)
>  {
>  	struct kvm_sev_launch_start launch_start = {
> @@ -93,7 +124,7 @@ void sev_vm_launch(struct kvm_vm *vm, uint32_t policy)
>  	TEST_ASSERT_EQ(status.state, SEV_GUEST_STATE_LAUNCH_UPDATE);
>  
>  	hash_for_each(vm->regions.slot_hash, ctr, region, slot_node)
> -		encrypt_region(vm, region);
> +		encrypt_region(vm, region, 0);

Please add an enum/macro instead of open coding a literal '0'.  I gotta assume
there's an appropriate name for page type '0'.

>  
>  	if (policy & SEV_POLICY_ES)
>  		vm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);

