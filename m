Return-Path: <kvm+bounces-51615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E00AAF9EDB
	for <lists+kvm@lfdr.de>; Sat,  5 Jul 2025 09:42:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2731F1C82301
	for <lists+kvm@lfdr.de>; Sat,  5 Jul 2025 07:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09518274FFE;
	Sat,  5 Jul 2025 07:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BXMSXBgm"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556582E36F6
	for <kvm@vger.kernel.org>; Sat,  5 Jul 2025 07:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751701369; cv=none; b=hD4VlJvQ0YUL7zP3HYV8GxA2g8cNfp0raxmqNba0bZ9rB+uhTJsbAlsWOpacRJIeQyuT6v3Vj52ynWdApTtNsT6QKXwb5yCfzoIf/jlYLUcdJJXZmX5x2A1tRfxbj571A3AvI9wJ7rWV5cR78Qac9fwBhejt45HbW96csRFUDg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751701369; c=relaxed/simple;
	bh=+ipkLr+6AZK0g0amDETbIlhExbBk39G+qSiOg3FrR3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SmNcCKQnrZloe+oJpQ7r0QZWiOws/E7BNx0cnb4HGlj0WYYDxXV8d7FlJWchGj8DGJy0l/vmZHvzIh9x9hTvXp8LpmMfpiqenMvFzVb+2TpwWOom9rJez63TM9zLC7fN7ia5rs1gD6qjQFKa6ZIs1VuXMbGsU4ehEpQTs1+FhZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BXMSXBgm; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <88ef2551-edc2-416b-9399-b45ad880d52e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751701365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3zrE+8OXJ3cS4paNpRcoSnhgvEgZb8sAPNGad26s/CA=;
	b=BXMSXBgmotsWcSEE8zAJIr4/lj+mEKX1tv1Q64n4dn04UONxBx4QiCjKucVR1dnqyxeMwd
	dQ0r4qejgKwc855GBoSbAVxZ/wdfcVgq50pPB7xcevQIirD5vfXX5hOOcgQio/iowhikW+
	2g8yB3PsLGUEhUE2XGzNXX656fVvpw4=
Date: Sat, 5 Jul 2025 00:42:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC
 virtualization
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250704153838.6575-1-apatel@ventanamicro.com>
 <20250704153838.6575-3-apatel@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250704153838.6575-3-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 7/4/25 8:38 AM, Anup Patel wrote:
> There is one HGEI line associated with each IMSIC VS-file on a host CPU.
> The IMSIC virtualization already keeps track of the HGEI line and the
> associated IMSIC VS-file used by each VCPU.
>
> Currently, the common AIA functions kvm_riscv_vcpu_aia_has_interrupts()
> and kvm_riscv_aia_wakeon_hgei() lookup HGEI line using an array of VCPU
> pointers before accessing HGEI[E|P] CSR which is slow. Move the HGEI[E|P]
> CSR access to IMSIC virtualization so that costly HGEI line lookup and
> potential race-conditions when updating HGEI[E|P] CSR can be avoided.

The patch looks good to me. It removes the redundant hgei lookup which 
is great.
But can you elaborate the race condition and it's effect (lost interrupt 
because of hgei is disabled during context switch) in the commit text ?

> Fixes: 3385339296d1 ("RISC-V: KVM: Use IMSIC guest files when available")
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/include/asm/kvm_aia.h |  4 ++-
>   arch/riscv/kvm/aia.c             | 51 +++++---------------------------
>   arch/riscv/kvm/aia_imsic.c       | 45 ++++++++++++++++++++++++++++
>   arch/riscv/kvm/vcpu.c            |  2 --
>   4 files changed, 55 insertions(+), 47 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
> index 0a0f12496f00..b04ecdd1a860 100644
> --- a/arch/riscv/include/asm/kvm_aia.h
> +++ b/arch/riscv/include/asm/kvm_aia.h
> @@ -87,6 +87,9 @@ DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
>   
>   extern struct kvm_device_ops kvm_riscv_aia_device_ops;
>   
> +bool kvm_riscv_vcpu_aia_imsic_has_interrupt(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_aia_imsic_load(struct kvm_vcpu *vcpu, int cpu);
> +void kvm_riscv_vcpu_aia_imsic_put(struct kvm_vcpu *vcpu);
>   void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu);
>   int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu);
>   
> @@ -161,7 +164,6 @@ void kvm_riscv_aia_destroy_vm(struct kvm *kvm);
>   int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
>   			     void __iomem **hgei_va, phys_addr_t *hgei_pa);
>   void kvm_riscv_aia_free_hgei(int cpu, int hgei);
> -void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable);
>   
>   void kvm_riscv_aia_enable(void);
>   void kvm_riscv_aia_disable(void);
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index 19afd1f23537..dad318185660 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -30,28 +30,6 @@ unsigned int kvm_riscv_aia_nr_hgei;
>   unsigned int kvm_riscv_aia_max_ids;
>   DEFINE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
>   
> -static int aia_find_hgei(struct kvm_vcpu *owner)
> -{
> -	int i, hgei;
> -	unsigned long flags;
> -	struct aia_hgei_control *hgctrl = get_cpu_ptr(&aia_hgei);
> -
> -	raw_spin_lock_irqsave(&hgctrl->lock, flags);
> -
> -	hgei = -1;
> -	for (i = 1; i <= kvm_riscv_aia_nr_hgei; i++) {
> -		if (hgctrl->owners[i] == owner) {
> -			hgei = i;
> -			break;
> -		}
> -	}
> -
> -	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> -
> -	put_cpu_ptr(&aia_hgei);
> -	return hgei;
> -}
> -
>   static inline unsigned long aia_hvictl_value(bool ext_irq_pending)
>   {
>   	unsigned long hvictl;
> @@ -95,7 +73,6 @@ void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu)
>   
>   bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
>   {
> -	int hgei;
>   	unsigned long seip;
>   
>   	if (!kvm_riscv_aia_available())
> @@ -114,11 +91,7 @@ bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
>   	if (!kvm_riscv_aia_initialized(vcpu->kvm) || !seip)
>   		return false;
>   
> -	hgei = aia_find_hgei(vcpu);
> -	if (hgei > 0)
> -		return !!(ncsr_read(CSR_HGEIP) & BIT(hgei));
> -
> -	return false;
> +	return kvm_riscv_vcpu_aia_imsic_has_interrupt(vcpu);
>   }
>   
>   void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *vcpu)
> @@ -164,6 +137,9 @@ void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int cpu)
>   		csr_write(CSR_HVIPRIO2H, csr->hviprio2h);
>   #endif
>   	}
> +
> +	if (kvm_riscv_aia_initialized(vcpu->kvm))
> +		kvm_riscv_vcpu_aia_imsic_load(vcpu, cpu);
>   }
>   
>   void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
> @@ -174,6 +150,9 @@ void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
>   	if (!kvm_riscv_aia_available())
>   		return;
>   
> +	if (kvm_riscv_aia_initialized(vcpu->kvm))
> +		kvm_riscv_vcpu_aia_imsic_put(vcpu);
> +
>   	if (kvm_riscv_nacl_available()) {
>   		nsh = nacl_shmem();
>   		csr->vsiselect = nacl_csr_read(nsh, CSR_VSISELECT);
> @@ -472,22 +451,6 @@ void kvm_riscv_aia_free_hgei(int cpu, int hgei)
>   	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
>   }
>   
> -void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable)
> -{
> -	int hgei;
> -
> -	if (!kvm_riscv_aia_available())
> -		return;
> -
> -	hgei = aia_find_hgei(owner);
> -	if (hgei > 0) {
> -		if (enable)
> -			csr_set(CSR_HGEIE, BIT(hgei));
> -		else
> -			csr_clear(CSR_HGEIE, BIT(hgei));
> -	}
> -}
> -
>   static irqreturn_t hgei_interrupt(int irq, void *dev_id)
>   {
>   	int i;
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index ea1a36836d9c..fda0346f0ea1 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -677,6 +677,48 @@ static void imsic_swfile_update(struct kvm_vcpu *vcpu,
>   	imsic_swfile_extirq_update(vcpu);
>   }
>   
> +bool kvm_riscv_vcpu_aia_imsic_has_interrupt(struct kvm_vcpu *vcpu)
> +{
> +	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
> +	unsigned long flags;
> +	bool ret = false;
> +
> +	/*
> +	 * The IMSIC SW-file directly injects interrupt via hvip so
> +	 * only check for interrupt when IMSIC VS-file is being used.
> +	 */
> +
> +	read_lock_irqsave(&imsic->vsfile_lock, flags);
> +	if (imsic->vsfile_cpu > -1)
> +		ret = !!(csr_read(CSR_HGEIP) & BIT(imsic->vsfile_hgei));
> +	read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +
> +	return ret;
> +}
> +
> +void kvm_riscv_vcpu_aia_imsic_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	/*
> +	 * No need to explicitly clear HGEIE CSR bits because the
> +	 * hgei interrupt handler (aka hgei_interrupt()) will always
> +	 * clear it for us.
> +	 */
> +}
> +
> +void kvm_riscv_vcpu_aia_imsic_put(struct kvm_vcpu *vcpu)
> +{
> +	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
> +	unsigned long flags;
> +
> +	if (!kvm_vcpu_is_blocking(vcpu))
> +		return;
> +
> +	read_lock_irqsave(&imsic->vsfile_lock, flags);
> +	if (imsic->vsfile_cpu > -1)
> +		csr_set(CSR_HGEIE, BIT(imsic->vsfile_hgei));
> +	read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +}
> +
>   void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
>   {
>   	unsigned long flags;
> @@ -781,6 +823,9 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
>   	 * producers to the new IMSIC VS-file.
>   	 */
>   
> +	/* Ensure HGEIE CSR bit is zero before using the new IMSIC VS-file */
> +	csr_clear(CSR_HGEIE, BIT(new_vsfile_hgei));
> +
>   	/* Zero-out new IMSIC VS-file */
>   	imsic_vsfile_local_clear(new_vsfile_hgei, imsic->nr_hw_eix);
>   
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index fe028b4274df..b26bf35a0a19 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -211,12 +211,10 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>   
>   void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
>   {
> -	kvm_riscv_aia_wakeon_hgei(vcpu, true);
>   }
>   
>   void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>   {
> -	kvm_riscv_aia_wakeon_hgei(vcpu, false);
>   }
>   
>   int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)

Reviewed-by: Atish Patra <atishp@rivosinc.com>


