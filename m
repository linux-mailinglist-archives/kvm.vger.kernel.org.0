Return-Path: <kvm+bounces-40941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C80FFA5F9AF
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:23:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF4997A5000
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 15:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E85268FCF;
	Thu, 13 Mar 2025 15:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="XqnhVQ6M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DD226138E
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 15:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741879398; cv=none; b=WevTxSPOxgtn+mBD5cHpqNwY0KzOpqnCbhRDg/LsenabkE/0+D4P2SewZn201GJW71FWBD5zgwfBFj8561Ts/worGG+hsTtdAuPigziuSKi08ZEcHon/FdhbUcu+5OZBsohylez9187gWChnBfHs0HK3gEeiU9kvJeVrJz+/02s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741879398; c=relaxed/simple;
	bh=rLW6iedeE+s33Ao+cUU1qNTI6LuCtdjrzCMEj94BUv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L7LJL94ciask4B5s4tnHezPpD5PdQyfcUTWNFJVlg4QiwdlT8nXI4kCWiyNMYtC/tus7O15kdbUgmHLHF/LhAOmbx1LvoXcayvA1oKCbdb7CW4p/Ce8LLt2sGFjsoLAOuueEFw/PcJQHWr4i65jG933T5xMMqN9WPNqeIOvhGEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=XqnhVQ6M; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-390f5f48eafso651902f8f.0
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 08:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1741879395; x=1742484195; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BA/nhAf9Hl5zVgG+VDKOPaGIaEJNci5XuuYhsGZzn08=;
        b=XqnhVQ6MaCRSKMPG+VS7iI08yMEbL7HvIIGCdozSwoyr3UMG6cLA8ROMDjRKe52hjl
         0FLwz6oQ9DpP5HNjrVf5QXjA9dk6/7Ih/dPP76yybdtMvaGkPzJthmSyw6xwMQvyMuBX
         fQe2HYuwO9+MnYwaApdTMXt7Nh/fYElATxBw8rFIHN15t1IPJq0AsIqOSRzQT71UGV7f
         UleOwWlGaO0U3GK9258vwr0p66sb1yuyjBzNLD1M35sEtb9u5ybhcakryb8Dj5N3CvCj
         rQtELl8oAjCy7o4ZudAALtfrYO/dvHeFrWiZYIPTHjhWoRgOUxWALhgGoCtpj8dcgJa2
         QHlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741879395; x=1742484195;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BA/nhAf9Hl5zVgG+VDKOPaGIaEJNci5XuuYhsGZzn08=;
        b=jyerZgojtncxDjrMePE0B18L0PepzSRcitAnTKHncUE+p6HMrt54GIRL7FWKDgQpVT
         FbodzWoJAQugFrBUMTBGotRDakWmtGc4kd47rCppqjil+myoE8QNMV2puWchFOyPVzUw
         eaTEJ7YF+Ho8KLhoKeh7lsKWdrW4aCDI1WyUzrcH56pq0SsYW2uAvwXISiWswos+iQzz
         iH2JC740BsNJMsyzuNVi9RMTd3V93e1G0ddDEMnrksQ5pI3D8vX1C/kt7cVFbX6cO8Yi
         bDo/5F755lLJPfxyfyWVOI+08cxM2ya+gZQCMALDkU0o3F8Yo8V9e0X/dK2erlbBG7IF
         VPUQ==
X-Forwarded-Encrypted: i=1; AJvYcCU01vBXhCsq8OZnQnZUmyvQSelja5p4KM2YhyfBTnTuKnsKtolO790DQGQ6sz3Cv1QL0Xc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjKsfyEVSuwTeuaJpNW858JfZBDNQLoc0ag8zikbo9IDNan+In
	8A1QeKkXUlrIEa7lYD1QUDpWiozW95M/R5dhupdX+XjCbmDGMjIi2iZoqbfoTsE=
X-Gm-Gg: ASbGncu/WVgHvgFkp4rHe8k0K8B5i+yauEeN26/0E5w6CPQXGAvnLO9HFAe5g+D7Z5D
	UqpK59m7duao8BfycKJPoP+W5O6qod1DR1U3RQXkn1Mt+qBLVRBZyX8lBrOPAjDbXnRfsw6l5En
	5F/+bdF04ZUg8wvFoOabe5Pddj8aR7F0+BAA8mb0ytLmYakTY12Ppz9QrOHPajvII6HyhjsGK0u
	1kS3cfe3imvQWfDnApqhdKATJ2hz1E9yhZW4GaYsiXNyn0GnseZS42d0WRfDZp3aPhclOMy0YH/
	eAIBY/cmnxMwgM3189XlDanIuRUcN/XL
X-Google-Smtp-Source: AGHT+IH2gsIp2nMPCf9r+kFvk4CDxhChk32XJPj/AyskRIl0tzwGRJ83t63ObvUY/PTXrp9i0eaadQ==
X-Received: by 2002:a05:6000:1f82:b0:391:3fde:1da with SMTP id ffacd0b85a97d-3913fde033cmr20335888f8f.16.1741879395185;
        Thu, 13 Mar 2025 08:23:15 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::59a5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c8975b34sm2457776f8f.55.2025.03.13.08.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 08:23:14 -0700 (PDT)
Date: Thu, 13 Mar 2025 16:23:13 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>, Deepak Gupta <debug@rivosinc.com>
Subject: Re: [PATCH v3 17/17] RISC-V: KVM: add support for
 SBI_FWFT_MISALIGNED_DELEG
Message-ID: <20250313-16176e19c15b63a156cb534c@orel>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
 <20250310151229.2365992-18-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250310151229.2365992-18-cleger@rivosinc.com>

On Mon, Mar 10, 2025 at 04:12:24PM +0100, Clément Léger wrote:
> SBI_FWFT_MISALIGNED_DELEG needs hedeleg to be modified to delegate
> misaligned load/store exceptions. Save and restore it during CPU
> load/put.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> Reviewed-by: Deepak Gupta <debug@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu.c          |  3 +++
>  arch/riscv/kvm/vcpu_sbi_fwft.c | 39 ++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 542747e2c7f5..d98e379945c3 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -646,6 +646,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
>  	void *nsh;
>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
>  
>  	vcpu->cpu = -1;
>  
> @@ -671,6 +672,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  		csr->vstval = nacl_csr_read(nsh, CSR_VSTVAL);
>  		csr->hvip = nacl_csr_read(nsh, CSR_HVIP);
>  		csr->vsatp = nacl_csr_read(nsh, CSR_VSATP);
> +		cfg->hedeleg = nacl_csr_read(nsh, CSR_HEDELEG);
>  	} else {
>  		csr->vsstatus = csr_read(CSR_VSSTATUS);
>  		csr->vsie = csr_read(CSR_VSIE);
> @@ -681,6 +683,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  		csr->vstval = csr_read(CSR_VSTVAL);
>  		csr->hvip = csr_read(CSR_HVIP);
>  		csr->vsatp = csr_read(CSR_VSATP);
> +		cfg->hedeleg = csr_read(CSR_HEDELEG);
>  	}
>  }
>  
> diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
> index cce1e41d5490..756fda1cf2e7 100644
> --- a/arch/riscv/kvm/vcpu_sbi_fwft.c
> +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
> @@ -14,6 +14,8 @@
>  #include <asm/kvm_vcpu_sbi.h>
>  #include <asm/kvm_vcpu_sbi_fwft.h>
>  
> +#define MIS_DELEG (BIT_ULL(EXC_LOAD_MISALIGNED) | BIT_ULL(EXC_STORE_MISALIGNED))
> +
>  struct kvm_sbi_fwft_feature {
>  	/**
>  	 * @id: Feature ID
> @@ -64,7 +66,44 @@ static bool kvm_fwft_is_defined_feature(enum sbi_fwft_feature_t feature)
>  	return false;
>  }
>  
> +static bool kvm_sbi_fwft_misaligned_delegation_supported(struct kvm_vcpu *vcpu)
> +{
> +	if (!misaligned_traps_can_delegate())
> +		return false;
> +
> +	return true;

Just

  return misaligned_traps_can_delegate();

> +}
> +
> +static int kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
> +					struct kvm_sbi_fwft_config *conf,
> +					unsigned long value)
> +{
> +	if (value == 1)
> +		csr_set(CSR_HEDELEG, MIS_DELEG);
> +	else if (value == 0)
> +		csr_clear(CSR_HEDELEG, MIS_DELEG);
> +	else
> +		return SBI_ERR_INVALID_PARAM;
> +
> +	return SBI_SUCCESS;
> +}
> +
> +static int kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
> +					struct kvm_sbi_fwft_config *conf,
> +					unsigned long *value)
> +{
> +	*value = (csr_read(CSR_HEDELEG) & MIS_DELEG) != 0;
> +
> +	return SBI_SUCCESS;
> +}
> +
>  static const struct kvm_sbi_fwft_feature features[] = {
> +	{
> +		.id = SBI_FWFT_MISALIGNED_EXC_DELEG,
> +		.supported = kvm_sbi_fwft_misaligned_delegation_supported,
> +		.set = kvm_sbi_fwft_set_misaligned_delegation,
> +		.get = kvm_sbi_fwft_get_misaligned_delegation,
> +	},
>  };
>  
>  static struct kvm_sbi_fwft_config *
> -- 
> 2.47.2
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

