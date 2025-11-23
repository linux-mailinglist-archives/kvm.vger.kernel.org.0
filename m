Return-Path: <kvm+bounces-64299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 37807C7DC06
	for <lists+kvm@lfdr.de>; Sun, 23 Nov 2025 07:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 178734E13C5
	for <lists+kvm@lfdr.de>; Sun, 23 Nov 2025 06:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 904731E572F;
	Sun, 23 Nov 2025 06:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="ld8PtBed"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341C278C9C
	for <kvm@vger.kernel.org>; Sun, 23 Nov 2025 06:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763877882; cv=none; b=SeGk7o3nQcpra5LM4x9cjnbNs8e7ogsA15NTGUe7WVkyiS1bYp85C8YTVsPss3Cy7cpgT7RoGEbgHtsWWlK/IEYTfyQmngJN5u6vyv3orc5Yf4bcXEeS7GuamzIf3Zqr39PvgyvDOPHmDh929u5ge5clThW52LhZWjzuPh+POqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763877882; c=relaxed/simple;
	bh=uDv31hwXjDikPuggKvd2Fv4kOEf0ri43Q/3SU5X4RFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d+4KQqKNFTBBf4T/9+7uvHgs4FkskEHovaf0wKGYDWXXOffLdFGz8A1PfStW0vsiPsHrYnY7hWwzLIzzWGiv5QlWXKfLC7m+qmefbr9lktMXf01+1Uj6J3D37SHfWgZfljN5H5D7C4VHEYkAuC6sinhPi/nQIMTAjo+OU7bzsRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=ld8PtBed; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-434717509afso16083785ab.2
        for <kvm@vger.kernel.org>; Sat, 22 Nov 2025 22:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1763877880; x=1764482680; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y0Ym3e4+eljcJanj0NgQ/ieTgJgvdEQmEY7BMRWL1sM=;
        b=ld8PtBed03aqExnZh27wMeDqBNE7GfB4Oh6uDBOfUNKDJIg2b2ddhK1o5W5EIDoMk4
         nzGJAE/Ck2F7pmWvJxKdwvwXWPzqDZBj+WVN5BkPEFNy2Zd7y3bmqWajY0eTwHiBg7Sl
         Bc/ORZf8wR3wtamoxJkaqt7US1s5DELLQrs1i3mdqX8JFJEvMu3WcGpZn7QZgs53L11c
         g5ye4d7kpRRXU957pTG4AOJFYt2wv0lwf3+2EDKvctxF9zobcVGr/fommBnaOMSArBAP
         bZnETf1tl/PaLpg/doY5c3IV4ZFgVd3bH9I8winMU6ZkOJLEr4w7SVHWuKCqC4rJ4T98
         g8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763877880; x=1764482680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y0Ym3e4+eljcJanj0NgQ/ieTgJgvdEQmEY7BMRWL1sM=;
        b=GgK/x+fFfqW1C1Npylx73mT+Grs5rTAmvRb+r7xHSA7vJvbfwLyyppi2ZtsgPLt2dV
         BaB3k587484wx3cIxOB6TXSdVs0o5FpII68wLOUDaGAsySKdPAfEopYIiGXasQ51UyJj
         QH0DuAxYRiW7C8I9E5ua5AwOeiD8cmhpIzNTivPJjH+8IqH36KQh/jpLElXGc+UvHXNU
         HliPCiASG1tPX/VhzkJzX69Ky2N5MemCRFj9SOTluU4zPph9kMMjex54LZV4YAyjW1iA
         vxNdZGRVzpvVOl8/elGzadcIST5uGIUkqAYpAcemb/G+v7RieSRoq6mORyIaNtNRUEAb
         WZ2w==
X-Forwarded-Encrypted: i=1; AJvYcCUQ1+n72xcFMQPLLshVN6WhwsbH7MOBEks1DAeUEhj7oP2ImfbUgbAYYjcM8QXe/Eu04JE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKyqek1cO3Jr8c0XQHkOF3XgD+wGWo/iUz/0cxGUT0rDYmGx/T
	f53vV2La5Q2cWThhf4OCyBsGsAGtjh8+YM9dlPm3pDHpZwkJLckTdtiARzvc5ubeUsZFP/4hw4K
	mjr3rG5CxpOJWAuyUoj0ZyGOVdokIIMKYH6buJy20Hg==
X-Gm-Gg: ASbGnctYkX58igWnvSgGrKNfFVkjmpAMwJ620g+AJGOStUlJh/p66wSQMFkQ76/+T4I
	cdas2qlj4kyk2SrFDuI5IqvBrPUJjgYe89JsqNTrZJ5zV4oL1aFMGKvpH6VDyUfS1vvnXP2kkiU
	0W64DSeej7acH3ToxWnhrhm5sVkjh2ehQpNnz8Ar0b5QdlprEQhBDXkeiXjcQjL0kFz/emrAMWP
	fS5REnmtK/xVUsgpWe5X1+PMKR6991iO5b9JVISEu8CnG/iNUDBfRDWL6OvvXCsf3VlXFs=
X-Google-Smtp-Source: AGHT+IEICGt8U1dMzIatJR8sF+e5pkTbQAXoofCiolmsKFJW3OgUk7F+wVhAFpJqZBuqpSvwmp+AG6sTiLDxQF69RwQ=
X-Received: by 2002:a05:6e02:b25:b0:42d:878b:6e40 with SMTP id
 e9e14a558f8ab-435b986a6a0mr42106725ab.13.1763877880147; Sat, 22 Nov 2025
 22:04:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117084555.157642-1-minachou@andestech.com>
In-Reply-To: <20251117084555.157642-1-minachou@andestech.com>
From: Anup Patel <anup@brainfault.org>
Date: Sun, 23 Nov 2025 11:34:28 +0530
X-Gm-Features: AWmQ_bmRp_9DDhqwwT4rIHuX4mhNyPkmL0MkYJ-_5w63jKGHv0Xy2EdoowK85SY
Message-ID: <CAAhSdy0mS++Oqp6jB8vf5n5Q8EYbFUDYceYxj1R6eH67=X2RZg@mail.gmail.com>
Subject: Re: [PATCH v4] RISC-V: KVM: Flush VS-stage TLB after VCPU migration
 for split two-stage TLBs
To: Hui Min Mina Chou <minachou@andestech.com>
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, tim609@andestech.com, ben717@andestech.com, 
	az70021@gmail.com, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

A shorter patch subject can be:
"RISC-V: KVM: Flush VS-stage TLB after VCPU migration for Andes cores"

On Mon, Nov 17, 2025 at 2:19=E2=80=AFPM Hui Min Mina Chou
<minachou@andestech.com> wrote:
>
> Most implementations cache the combined result of two-stage
> translation, but some, like Andes cores, use split TLBs that
> store VS-stage and G-stage entries separately.
>
> On such systems, when a VCPU migrates to another CPU, an additional
> HFENCE.VVMA is required to avoid using stale VS-stage entries, which
> could otherwise cause guest faults.
>
> Introduce a static key to identify CPUs with split two-stage TLBs.
> When enabled, KVM issues an extra HFENCE.VVMA on VCPU migration to
> prevent stale VS-stage mappings.
>
> Signed-off-by: Hui Min Mina Chou <minachou@andestech.com>
> Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
> Reviewed-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>
> ---
> Changelog:
>
> v4:
>  - Rename the patch subject
>  - Remove the Fixes tag
>  - Add a static key so that HFENCE.VVMA is issued only on CPUs with
>    split two-stage TLBs
>  - Add kvm_riscv_setup_vendor_features() to detect mvendorid/marchid
>    and enable the key when required
>
> v3:
>  - Resolved build warning; updated header declaration and call side to
>    kvm_riscv_local_tlb_sanitize
>  - Add Radim Kr=C4=8Dm=C3=A1=C5=99's Reviewed-by tag
>  (https://lore.kernel.org/all/20251023032517.2527193-1-minachou@andestech=
.com/)
>
> v2:
>  - Updated Fixes commit to 92e450507d56
>  - Renamed function to kvm_riscv_local_tlb_sanitize
>  (https://lore.kernel.org/all/20251021083105.4029305-1-minachou@andestech=
.com/)
> ---
>  arch/riscv/include/asm/kvm_host.h |  2 ++
>  arch/riscv/include/asm/kvm_vmid.h |  2 +-
>  arch/riscv/kvm/main.c             | 14 ++++++++++++++
>  arch/riscv/kvm/vcpu.c             |  2 +-
>  arch/riscv/kvm/vmid.c             |  6 +++++-
>  5 files changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index d71d3299a335..21abac2f804e 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -323,4 +323,6 @@ bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu);
>
>  void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu);
>
> +DECLARE_STATIC_KEY_FALSE(kvm_riscv_tlb_split_mode);
> +

"kvm_riscv_vsstage_tlb_no_gpa" is a better name for the static key.

>  #endif /* __RISCV_KVM_HOST_H__ */
> diff --git a/arch/riscv/include/asm/kvm_vmid.h b/arch/riscv/include/asm/k=
vm_vmid.h
> index ab98e1434fb7..75fb6e872ccd 100644
> --- a/arch/riscv/include/asm/kvm_vmid.h
> +++ b/arch/riscv/include/asm/kvm_vmid.h
> @@ -22,6 +22,6 @@ unsigned long kvm_riscv_gstage_vmid_bits(void);
>  int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
>  bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
>  void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
> -void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu);
> +void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu);

kvm_riscv_local_tlb_sanitize() must be declared in kvm_tlb.h

>
>  #endif
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 67c876de74ef..bf0e4f1abe0f 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -15,6 +15,18 @@
>  #include <asm/kvm_nacl.h>
>  #include <asm/sbi.h>
>
> +DEFINE_STATIC_KEY_FALSE(kvm_riscv_tlb_split_mode);
> +
> +static void kvm_riscv_setup_vendor_features(void)
> +{
> +       /* Andes AX66: split two-stage TLBs */
> +       if (riscv_cached_mvendorid(0) =3D=3D ANDES_VENDOR_ID &&
> +           (riscv_cached_marchid(0) & 0xFFFF) =3D=3D 0x8A66) {
> +               static_branch_enable(&kvm_riscv_tlb_split_mode);
> +               kvm_info("using split two-stage TLBs requiring extra HFEN=
CE.VVMA\n");

I think the "VS-stage TLB does not cache guest physical addresses
and VMID" message is more clear.

> +       }
> +}
> +
>  long kvm_arch_dev_ioctl(struct file *filp,
>                         unsigned int ioctl, unsigned long arg)
>  {
> @@ -159,6 +171,8 @@ static int __init riscv_kvm_init(void)
>                 kvm_info("AIA available with %d guest external interrupts=
\n",
>                          kvm_riscv_aia_nr_hgei);
>
> +       kvm_riscv_setup_vendor_features();
> +
>         kvm_register_perf_callbacks(NULL);
>
>         rc =3D kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 3ebcfffaa978..796218e4a462 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -968,7 +968,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                  * Note: This should be done after G-stage VMID has been
>                  * updated using kvm_riscv_gstage_vmid_ver_changed()
>                  */
> -               kvm_riscv_gstage_vmid_sanitize(vcpu);
> +               kvm_riscv_local_tlb_sanitize(vcpu);
>
>                 trace_kvm_entry(vcpu);
>
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 3b426c800480..1dbd50c67a88 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -125,7 +125,7 @@ void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vc=
pu)
>                 kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
>  }
>
> -void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
> +void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
>  {
>         unsigned long vmid;
>
> @@ -146,4 +146,8 @@ void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *=
vcpu)
>
>         vmid =3D READ_ONCE(vcpu->kvm->arch.vmid.vmid);
>         kvm_riscv_local_hfence_gvma_vmid_all(vmid);
> +
> +       /* For split TLB designs, flush VS-stage entries also */
> +       if (static_branch_unlikely(&kvm_riscv_tlb_split_mode))
> +               kvm_riscv_local_hfence_vvma_all(vmid);
>  }

kvm_riscv_local_tlb_sanitize() implementation must be
moved to kvm/tlb.c

> --
> 2.34.1
>

I will take care of the above comments at the time of merging
this patch. If any further changes are required then I can squash
changes before the end of next week.

Queued this patch for Linux-6.19.

Thanks,
Anup

