Return-Path: <kvm+bounces-63282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC44C5FFB1
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 05:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B53F74E4813
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 04:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B72A2253FF;
	Sat, 15 Nov 2025 04:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kdx/c78r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7574C19CCF5
	for <kvm@vger.kernel.org>; Sat, 15 Nov 2025 04:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763179723; cv=none; b=e8OzIPRlCrthfCCM6nxzll8BWT/sRQtKJpbvqRRE4Le8SRA6G/YTfyER/Ry5yWaMZIlIzoO0q2PMXN85pQhHBJYTIcrCDlN5kl2aW/cPYj9oCm9CVEvj9yKJRb4PYL2S8TtTb8NMGiOTxnar3oyitolyev2nGjyzUWZLK7eIdwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763179723; c=relaxed/simple;
	bh=KZGqL2Ezl0HG8L3ZKNB+3v2T5VnKNS3msnMQ+mBqZBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fG/OTAWZboxANoTPRszMlSLHPJCs/ubb1oyDsfLGNh/ln8eyqvlgWxReMm9pEDLeuvwuCUUS/japaLjFj0+F+cHQXEhh/KeYTrntTS6nUhN4gndtR/YnS8tFGZzz/m91g/Y6tRiMuAUnNzQvPvg4bA4Obq9E557wEllt/J8lkC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kdx/c78r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08667C4CEF7
	for <kvm@vger.kernel.org>; Sat, 15 Nov 2025 04:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763179723;
	bh=KZGqL2Ezl0HG8L3ZKNB+3v2T5VnKNS3msnMQ+mBqZBY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Kdx/c78r7wuHriNVNHW5bfwCSFqYvYcHnuJcdhAREmfpSvpc9Datzo1GQ784ItIV8
	 vWXGy3xOp2fbx5NPYsojEJkxKC2KhQ/stcmi8EMrOW+6AfGJBUD0LWIxs/x6/lw5SZ
	 qcuV3/gTi+btPR2H8v/w6iCrKGTK3tjNle1G9ez0/aZ5N4V7+e9WPmXWG5l40PmkWP
	 ZznLGCkHHQX9RYYglhsDeeCqO8LPNFPgiz3c/3WjRdalRVlclYWACOAsCETiuyPR/2
	 JIjleG0XLOY8L3GQsYbOx8P3/Y36vok/nxP4Hu2JK1fKUWvIISFxslBhyVlJbk123x
	 cqpGGej89kFMQ==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64312565c10so4073333a12.2
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:08:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVc0lcqIWta9Y7rQzXwKkWarPYxac7ui42ZQOSA0O4gixMHkc5dCS9wjmMVw+R2aOabA5s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNPMpUfk6YEDH9Sg73z0rG7H97EtAoyweoBKs3N6fyh4sLBoFF
	WkCFIHmUTdRjHn1Hm8we8B1ZYY4pK5EjUKLSekoKBkyqoF9oQfhYIsgFL3L/6hAR+PgsOOuspqN
	PN+i1DNh1YmXgcg5RwEnqnjwYqQxftp0=
X-Google-Smtp-Source: AGHT+IG9cQ3842nU2X96hW6f/gkC+5SQGjvtKdtQOMK6m2HstYAXMYIkvNvxji/TrvC80TdUeDVdiXrTNf1BUzk4eTg=
X-Received: by 2002:a17:907:9603:b0:b72:5d9c:b47b with SMTP id
 a640c23a62f3a-b73678ed0a1mr518109066b.36.1763179721512; Fri, 14 Nov 2025
 20:08:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104113700.1561752-1-maobibo@loongson.cn> <20251104113700.1561752-4-maobibo@loongson.cn>
In-Reply-To: <20251104113700.1561752-4-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 15 Nov 2025 12:08:28 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5TNk-pxVthnau=GgfB=5K9fUQsFnKKKH=VqLaLmENFtA@mail.gmail.com>
X-Gm-Features: AWmQ_bnuZb7NbZ1VUmGJms5OOq9ewjA1_-hRujqnV8OhCjjyH6ZWv0RIiUblj2g
Message-ID: <CAAhV-H5TNk-pxVthnau=GgfB=5K9fUQsFnKKKH=VqLaLmENFtA@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] KVM: LoongArch: selftests: Add basic interfaces
To: Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Tue, Nov 4, 2025 at 7:37=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrote=
:
>
> Add some basic function interfaces such as CSR register access,
> local irq enable or disable APIs.
This is "basic interfaces", so better to be before Patch-2 (or keep
the order but change the subject)?

Huacai

>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  .../kvm/include/loongarch/processor.h         | 52 +++++++++++++++++++
>  .../selftests/kvm/lib/loongarch/processor.c   |  5 ++
>  2 files changed, 57 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/loongarch/processor.h b/=
tools/testing/selftests/kvm/include/loongarch/processor.h
> index a18ac7bff303..b027f8f4dac7 100644
> --- a/tools/testing/selftests/kvm/include/loongarch/processor.h
> +++ b/tools/testing/selftests/kvm/include/loongarch/processor.h
> @@ -118,6 +118,28 @@
>  #define  CSR_TLBREHI_PS_SHIFT          0
>  #define  CSR_TLBREHI_PS                        (0x3fUL << CSR_TLBREHI_PS=
_SHIFT)
>
> +#define csr_read(csr)                          \
> +({                                             \
> +       register unsigned long __v;             \
> +       __asm__ __volatile__(                   \
> +               "csrrd %[val], %[reg]\n\t"      \
> +               : [val] "=3Dr" (__v)              \
> +               : [reg] "i" (csr)               \
> +               : "memory");                    \
> +       __v;                                    \
> +})
> +
> +#define csr_write(v, csr)                      \
> +({                                             \
> +       register unsigned long __v =3D v;         \
> +       __asm__ __volatile__ (                  \
> +               "csrwr %[val], %[reg]\n\t"      \
> +               : [val] "+r" (__v)              \
> +               : [reg] "i" (csr)               \
> +               : "memory");                    \
> +       __v;                                    \
> +})
> +
>  #define EXREGS_GPRS                    (32)
>
>  #ifndef __ASSEMBLER__
> @@ -147,6 +169,36 @@ struct handlers {
>  void vm_init_descriptor_tables(struct kvm_vm *vm);
>  void vm_install_exception_handler(struct kvm_vm *vm, int vector, handler=
_fn handler);
>
> +static inline void local_irq_enable(void)
> +{
> +       unsigned int flags =3D CSR_CRMD_IE;
> +
> +       register unsigned int mask asm("$t0") =3D CSR_CRMD_IE;
> +
> +       __asm__ __volatile__(
> +               "csrxchg %[val], %[mask], %[reg]\n\t"
> +               : [val] "+r" (flags)
> +               : [mask] "r" (mask), [reg] "i" (LOONGARCH_CSR_CRMD)
> +               : "memory");
> +}
> +
> +static inline void local_irq_disable(void)
> +{
> +       unsigned int flags =3D 0;
> +
> +       register unsigned int mask asm("$t0") =3D CSR_CRMD_IE;
> +
> +       __asm__ __volatile__(
> +               "csrxchg %[val], %[mask], %[reg]\n\t"
> +               : [val] "+r" (flags)
> +               : [mask] "r" (mask), [reg] "i" (LOONGARCH_CSR_CRMD)
> +               : "memory");
> +}
> +
> +static inline void cpu_relax(void)
> +{
> +       asm volatile("nop" ::: "memory");
> +}
>  #else
>  #define PC_OFFSET_EXREGS               ((EXREGS_GPRS + 0) * 8)
>  #define ESTAT_OFFSET_EXREGS            ((EXREGS_GPRS + 1) * 8)
> diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tool=
s/testing/selftests/kvm/lib/loongarch/processor.c
> index be537c5ff74e..20ba476ccb72 100644
> --- a/tools/testing/selftests/kvm/lib/loongarch/processor.c
> +++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
> @@ -373,3 +373,8 @@ void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu,=
 void *guest_code)
>         regs.pc =3D (uint64_t)guest_code;
>         vcpu_regs_set(vcpu, &regs);
>  }
> +
> +uint32_t guest_get_vcpuid(void)
> +{
> +       return csr_read(LOONGARCH_CSR_CPUID);
> +}
> --
> 2.39.3
>

