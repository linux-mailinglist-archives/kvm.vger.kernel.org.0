Return-Path: <kvm+bounces-67051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BFB2CF3E69
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 14:45:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 52B5A30A05DF
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 13:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B264284663;
	Mon,  5 Jan 2026 13:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="fC/8VdeQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5179AC13B
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 13:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767620482; cv=none; b=mVOHoqX1RpLrGhK6JMcmz6f+D3tAZxcFFMarIdt64QJHheM827WDH5pMyTzvN3AzxzbFK8Tg0gFU7yfafEVIUggIP8H/Clwi5w9en1wAjpRcSfM0/4ERz7cb/jzESM52YglzIrf6IVN9rNpWBZFxHlx1R/tWmHrR6F51x3GTvVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767620482; c=relaxed/simple;
	bh=4dlf2ObAfQEWY6BQkIE5bDkMPBrquSSp3LY1xtmhGI0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TVp561kFhF2M4lBSq9E0BJywzZd39UELkoKN0AF8rxpd9q35ThIGXw8dG+j9ViTA5tPBmGRY5GS+/ODO5SEQLu1jnbZRep89JBmA82wTPGzvDq8a3gePjJfbzBll2I98VUFJgilzMeO7N0+SQ1jZ04yakF9UA4HBXojUABguPJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=fC/8VdeQ; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-65d1bff2abaso7607923eaf.1
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 05:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1767620479; x=1768225279; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehREdEDiupmGqX/x3tW6pVnGzRrOhA5SGQdnPaQJkpA=;
        b=fC/8VdeQpawG7xdJ6wB1jiRv0HmZ9W/y33X4tubXMRHiKRotldZ8+pWuSrmgi/t0Uu
         5eI3vYD5gzP38kensnR57Qcr4c/lk46/ifD9geADzvvUSCKLmPOtYDGLpvvejk59K6Q1
         Eklx0MaD5x4AzX2xYjo9n6EuWFM7JAeDXN+NWz53n881FeLz6i0YkH0ErC1PyClKqVkQ
         CFb+hKZus4TkR9Ely4Gsz4Mqj1o6QW0mKteRtI9iQ48pPu+SZbXuP19RR6EUdM6FxYvE
         anqIyzbv447LehTVy1xwZ+1T33UjoJswUFmyUHirviAZr6P4+QD33JraVnhc+utajCpt
         PyGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767620479; x=1768225279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ehREdEDiupmGqX/x3tW6pVnGzRrOhA5SGQdnPaQJkpA=;
        b=NlrV/e0bygImzgYsGxXjx2+wfVbGjiL2g/4FOykCSPovIwWJWT5XyCI80VMiTuTBnK
         YCT8CcTjn4m3ASv+4Fur3B9GdGZ6yjQAkJLZf7816lyCc4R1THsVYrJmhXFLBZXHRN0v
         VnIxtOxwhlOdhcDbgaFscC69F+DT3IpvVmfaoc9tYSMOwhnPCgsI0UcZaiY2sWH/FUuY
         FMLWjFJx3vzS75+gPPthjybEI86BzHIWtD5p/Rvbeit8JG5lrf1C9Lx53N0fEOCXXkVy
         sf3+UDTO341YyNcNRHKnjl9a0cO3x1ADDPCMOBYwiM/GPDu+Z9zhmjfsoO54x6vS1uK8
         swPA==
X-Forwarded-Encrypted: i=1; AJvYcCX45P93E7bbvoDTj4BYvuTPWB1t6bOOnexWq5dTmdbwJmwnMx9Ko4bH0ByI5QUBWw8y6mE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyC1XPkJbUJ//tgo6DGCIxMipASU5Kz828F8KiVWx5Gq6bcDPJY
	hOvnb+8V2MjRxv4Rp3zKv2sx4M73HSqfV2apdHnDFP7qqcJGuwoQvrvqkw/lP+nv9+I/mMV8kqJ
	dHQU1Mo/SkCkQyNmnimBucOdlgi3q5HHtOBYJ0TmVtA==
X-Gm-Gg: AY/fxX6KfNz8Wszsr0HfYD3uhsiAz59IJWQqArEn3bCsPXjzAtoxu5UwW65ltI5tu3y
	0Ornw2tAeVxZHVbQzmV3GdvVvbnMj5doHVMjsucf7z4mTEeYxkHiHnfOu2PagcJi3o8QY5SFAoc
	VkriUyTu39c3wZHVGJ8XqrzmH9M3CwSHEnAKtdfmGlMcTanekzUBOeZaSAuRIs+KpGZjKEPMSbW
	em/zH5F2igr/i7TB+tHFUY7c5XRxINk4KFoSyQhJJjOtqhTDxvABU9DIRnageeR2TJA6O7MXOIc
	iTjBQfypq6U9oz++RZ6/tby27GUJVflkDyR0wi9QZvEkRAJGJGbjwPrRWw==
X-Google-Smtp-Source: AGHT+IGRXn0TmSzNXoWIXBbmw8JXquVN/xi5ItPbOz5PHVEVqnsO6UxkRHH9EnskDVLpbDm5pdpwpodjMPkLK8ZOTRM=
X-Received: by 2002:a4a:ba12:0:b0:65d:be3:3121 with SMTP id
 006d021491bc7-65d0ec1e5c7mr15654169eaf.80.1767620478954; Mon, 05 Jan 2026
 05:41:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251105151442.28767-1-wu.fei9@sanechips.com.cn>
In-Reply-To: <20251105151442.28767-1-wu.fei9@sanechips.com.cn>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 5 Jan 2026 19:11:07 +0530
X-Gm-Features: AQt7F2oIJMIOK1Nloru_yjQHReq1hrZ9W4woNSo-hNrJwQLhrdmQSLYRPsV88d8
Message-ID: <CAAhSdy0EFVAkhbWGdkej1FvJi_m9DmsMsaNRL0G6B4muXVYvaA@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND] KVM: riscv: selftests: Add riscv vm satp modes
To: Wu Fei <wu.fei9@sanechips.com.cn>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, Nutty Liu <nutty.liu@hotmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 5, 2025 at 8:46=E2=80=AFPM Wu Fei <wu.fei9@sanechips.com.cn> wr=
ote:
>
> Current vm modes cannot represent riscv guest modes precisely, here add
> all 9 combinations of P(56,40,41) x V(57,48,39). Also the default vm
> mode is detected on runtime instead of hardcoded one, which might not be
> supported on specific machine.
>
> Signed-off-by: Wu Fei <wu.fei9@sanechips.com.cn>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
> Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.20

Thanks,
Anup

> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 17 ++++-
>  .../selftests/kvm/include/riscv/processor.h   |  2 +
>  tools/testing/selftests/kvm/lib/guest_modes.c | 41 +++++++++---
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 33 ++++++++++
>  .../selftests/kvm/lib/riscv/processor.c       | 63 +++++++++++++++++--
>  5 files changed, 142 insertions(+), 14 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
> index d3f3e455c031..c6d0b4a5b263 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -185,6 +185,17 @@ enum vm_guest_mode {
>         VM_MODE_P36V48_64K,
>         VM_MODE_P47V47_16K,
>         VM_MODE_P36V47_16K,
> +
> +       VM_MODE_P56V57_4K,      /* For riscv64 */
> +       VM_MODE_P56V48_4K,
> +       VM_MODE_P56V39_4K,
> +       VM_MODE_P50V57_4K,
> +       VM_MODE_P50V48_4K,
> +       VM_MODE_P50V39_4K,
> +       VM_MODE_P41V57_4K,
> +       VM_MODE_P41V48_4K,
> +       VM_MODE_P41V39_4K,
> +
>         NUM_VM_MODES,
>  };
>
> @@ -209,10 +220,10 @@ kvm_static_assert(sizeof(struct vm_shape) =3D=3D si=
zeof(uint64_t));
>         shape;                                  \
>  })
>
> -#if defined(__aarch64__)
> -
>  extern enum vm_guest_mode vm_mode_default;
>
> +#if defined(__aarch64__)
> +
>  #define VM_MODE_DEFAULT                        vm_mode_default
>  #define MIN_PAGE_SHIFT                 12U
>  #define ptes_per_page(page_size)       ((page_size) / 8)
> @@ -235,7 +246,7 @@ extern enum vm_guest_mode vm_mode_default;
>  #error "RISC-V 32-bit kvm selftests not supported"
>  #endif
>
> -#define VM_MODE_DEFAULT                        VM_MODE_P40V48_4K
> +#define VM_MODE_DEFAULT                        vm_mode_default
>  #define MIN_PAGE_SHIFT                 12U
>  #define ptes_per_page(page_size)       ((page_size) / 8)
>
> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tool=
s/testing/selftests/kvm/include/riscv/processor.h
> index e58282488beb..4dade8c4d18e 100644
> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> @@ -192,4 +192,6 @@ static inline void local_irq_disable(void)
>         csr_clear(CSR_SSTATUS, SR_SIE);
>  }
>
> +unsigned long riscv64_get_satp_mode(void);
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testin=
g/selftests/kvm/lib/guest_modes.c
> index b04901e55138..ce3099630397 100644
> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -4,7 +4,7 @@
>   */
>  #include "guest_modes.h"
>
> -#ifdef __aarch64__
> +#if defined(__aarch64__) || defined(__riscv)
>  #include "processor.h"
>  enum vm_guest_mode vm_mode_default;
>  #endif
> @@ -13,9 +13,11 @@ struct guest_mode guest_modes[NUM_VM_MODES];
>
>  void guest_modes_append_default(void)
>  {
> -#ifndef __aarch64__
> +#if !defined(__aarch64__) && !defined(__riscv)
>         guest_mode_append(VM_MODE_DEFAULT, true);
> -#else
> +#endif
> +
> +#ifdef __aarch64__
>         {
>                 unsigned int limit =3D kvm_check_cap(KVM_CAP_ARM_VM_IPA_S=
IZE);
>                 uint32_t ipa4k, ipa16k, ipa64k;
> @@ -74,11 +76,36 @@ void guest_modes_append_default(void)
>  #ifdef __riscv
>         {
>                 unsigned int sz =3D kvm_check_cap(KVM_CAP_VM_GPA_BITS);
> +               unsigned long satp_mode =3D riscv64_get_satp_mode() << SA=
TP_MODE_SHIFT;
> +               int i;
>
> -               if (sz >=3D 52)
> -                       guest_mode_append(VM_MODE_P52V48_4K, true);
> -               if (sz >=3D 48)
> -                       guest_mode_append(VM_MODE_P48V48_4K, true);
> +               switch (sz) {
> +               case 59:
> +                       guest_mode_append(VM_MODE_P56V57_4K, satp_mode >=
=3D SATP_MODE_57);
> +                       guest_mode_append(VM_MODE_P56V48_4K, satp_mode >=
=3D SATP_MODE_48);
> +                       guest_mode_append(VM_MODE_P56V39_4K, satp_mode >=
=3D SATP_MODE_39);
> +                       break;
> +               case 50:
> +                       guest_mode_append(VM_MODE_P50V57_4K, satp_mode >=
=3D SATP_MODE_57);
> +                       guest_mode_append(VM_MODE_P50V48_4K, satp_mode >=
=3D SATP_MODE_48);
> +                       guest_mode_append(VM_MODE_P50V39_4K, satp_mode >=
=3D SATP_MODE_39);
> +                       break;
> +               case 41:
> +                       guest_mode_append(VM_MODE_P41V57_4K, satp_mode >=
=3D SATP_MODE_57);
> +                       guest_mode_append(VM_MODE_P41V48_4K, satp_mode >=
=3D SATP_MODE_48);
> +                       guest_mode_append(VM_MODE_P41V39_4K, satp_mode >=
=3D SATP_MODE_39);
> +                       break;
> +               default:
> +                       break;
> +               }
> +
> +               /* set the first supported mode as default */
> +               vm_mode_default =3D NUM_VM_MODES;
> +               for (i =3D 0; vm_mode_default =3D=3D NUM_VM_MODES && i < =
NUM_VM_MODES; i++) {
> +                       if (guest_modes[i].supported && guest_modes[i].en=
abled)
> +                               vm_mode_default =3D i;
> +               }
> +               TEST_ASSERT(vm_mode_default !=3D NUM_VM_MODES, "No suppor=
ted mode!");
>         }
>  #endif
>  }
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 1a93d6361671..a6a4bbc07211 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -209,6 +209,15 @@ const char *vm_guest_mode_string(uint32_t i)
>                 [VM_MODE_P36V48_64K]    =3D "PA-bits:36,  VA-bits:48, 64K=
 pages",
>                 [VM_MODE_P47V47_16K]    =3D "PA-bits:47,  VA-bits:47, 16K=
 pages",
>                 [VM_MODE_P36V47_16K]    =3D "PA-bits:36,  VA-bits:47, 16K=
 pages",
> +               [VM_MODE_P56V57_4K]     =3D "PA-bits:56,  VA-bits:57,  4K=
 pages",
> +               [VM_MODE_P56V48_4K]     =3D "PA-bits:56,  VA-bits:48,  4K=
 pages",
> +               [VM_MODE_P56V39_4K]     =3D "PA-bits:56,  VA-bits:39,  4K=
 pages",
> +               [VM_MODE_P50V57_4K]     =3D "PA-bits:50,  VA-bits:57,  4K=
 pages",
> +               [VM_MODE_P50V48_4K]     =3D "PA-bits:50,  VA-bits:48,  4K=
 pages",
> +               [VM_MODE_P50V39_4K]     =3D "PA-bits:50,  VA-bits:39,  4K=
 pages",
> +               [VM_MODE_P41V57_4K]     =3D "PA-bits:41,  VA-bits:57,  4K=
 pages",
> +               [VM_MODE_P41V48_4K]     =3D "PA-bits:41,  VA-bits:48,  4K=
 pages",
> +               [VM_MODE_P41V39_4K]     =3D "PA-bits:41,  VA-bits:39,  4K=
 pages",
>         };
>         _Static_assert(sizeof(strings)/sizeof(char *) =3D=3D NUM_VM_MODES=
,
>                        "Missing new mode strings?");
> @@ -236,6 +245,15 @@ const struct vm_guest_mode_params vm_guest_mode_para=
ms[] =3D {
>         [VM_MODE_P36V48_64K]    =3D { 36, 48, 0x10000, 16 },
>         [VM_MODE_P47V47_16K]    =3D { 47, 47,  0x4000, 14 },
>         [VM_MODE_P36V47_16K]    =3D { 36, 47,  0x4000, 14 },
> +       [VM_MODE_P56V57_4K]     =3D { 56, 57,  0x1000, 12 },
> +       [VM_MODE_P56V48_4K]     =3D { 56, 48,  0x1000, 12 },
> +       [VM_MODE_P56V39_4K]     =3D { 56, 39,  0x1000, 12 },
> +       [VM_MODE_P50V57_4K]     =3D { 50, 57,  0x1000, 12 },
> +       [VM_MODE_P50V48_4K]     =3D { 50, 48,  0x1000, 12 },
> +       [VM_MODE_P50V39_4K]     =3D { 50, 39,  0x1000, 12 },
> +       [VM_MODE_P41V57_4K]     =3D { 41, 57,  0x1000, 12 },
> +       [VM_MODE_P41V48_4K]     =3D { 41, 48,  0x1000, 12 },
> +       [VM_MODE_P41V39_4K]     =3D { 41, 39,  0x1000, 12 },
>  };
>  _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_=
params) =3D=3D NUM_VM_MODES,
>                "Missing new mode params?");
> @@ -336,6 +354,21 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
>         case VM_MODE_P44V64_4K:
>                 vm->pgtable_levels =3D 5;
>                 break;
> +       case VM_MODE_P56V57_4K:
> +       case VM_MODE_P50V57_4K:
> +       case VM_MODE_P41V57_4K:
> +               vm->pgtable_levels =3D 5;
> +               break;
> +       case VM_MODE_P56V48_4K:
> +       case VM_MODE_P50V48_4K:
> +       case VM_MODE_P41V48_4K:
> +               vm->pgtable_levels =3D 4;
> +               break;
> +       case VM_MODE_P56V39_4K:
> +       case VM_MODE_P50V39_4K:
> +       case VM_MODE_P41V39_4K:
> +               vm->pgtable_levels =3D 3;
> +               break;
>         default:
>                 TEST_FAIL("Unknown guest mode: 0x%x", vm->mode);
>         }
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/te=
sting/selftests/kvm/lib/riscv/processor.c
> index 2eac7d4b59e9..003693576225 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -8,6 +8,7 @@
>  #include <linux/compiler.h>
>  #include <assert.h>
>
> +#include "guest_modes.h"
>  #include "kvm_util.h"
>  #include "processor.h"
>  #include "ucall_common.h"
> @@ -197,22 +198,41 @@ void riscv_vcpu_mmu_setup(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_vm *vm =3D vcpu->vm;
>         unsigned long satp;
> +       unsigned long satp_mode;
> +       unsigned long max_satp_mode;
>
>         /*
>          * The RISC-V Sv48 MMU mode supports 56-bit physical address
>          * for 48-bit virtual address with 4KB last level page size.
>          */
>         switch (vm->mode) {
> -       case VM_MODE_P52V48_4K:
> -       case VM_MODE_P48V48_4K:
> -       case VM_MODE_P40V48_4K:
> +       case VM_MODE_P56V57_4K:
> +       case VM_MODE_P50V57_4K:
> +       case VM_MODE_P41V57_4K:
> +               satp_mode =3D SATP_MODE_57;
> +               break;
> +       case VM_MODE_P56V48_4K:
> +       case VM_MODE_P50V48_4K:
> +       case VM_MODE_P41V48_4K:
> +               satp_mode =3D SATP_MODE_48;
> +               break;
> +       case VM_MODE_P56V39_4K:
> +       case VM_MODE_P50V39_4K:
> +       case VM_MODE_P41V39_4K:
> +               satp_mode =3D SATP_MODE_39;
>                 break;
>         default:
>                 TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
>         }
>
> +       max_satp_mode =3D vcpu_get_reg(vcpu, RISCV_CONFIG_REG(satp_mode))=
;
> +
> +       if ((satp_mode >> SATP_MODE_SHIFT) > max_satp_mode)
> +               TEST_FAIL("Unable to set satp mode 0x%lx, max mode 0x%lx\=
n",
> +                         satp_mode >> SATP_MODE_SHIFT, max_satp_mode);
> +
>         satp =3D (vm->pgd >> PGTBL_PAGE_SIZE_SHIFT) & SATP_PPN;
> -       satp |=3D SATP_MODE_48;
> +       satp |=3D satp_mode;
>
>         vcpu_set_reg(vcpu, RISCV_GENERAL_CSR_REG(satp), satp);
>  }
> @@ -515,3 +535,38 @@ unsigned long get_host_sbi_spec_version(void)
>
>         return ret.value;
>  }
> +
> +void kvm_selftest_arch_init(void)
> +{
> +       /*
> +        * riscv64 doesn't have a true default mode, so start by detectin=
g the
> +        * supported vm mode.
> +        */
> +       guest_modes_append_default();
> +}
> +
> +unsigned long riscv64_get_satp_mode(void)
> +{
> +       int kvm_fd, vm_fd, vcpu_fd, err;
> +       uint64_t val;
> +       struct kvm_one_reg reg =3D {
> +               .id     =3D RISCV_CONFIG_REG(satp_mode),
> +               .addr   =3D (uint64_t)&val,
> +       };
> +
> +       kvm_fd =3D open_kvm_dev_path_or_exit();
> +       vm_fd =3D __kvm_ioctl(kvm_fd, KVM_CREATE_VM, NULL);
> +       TEST_ASSERT(vm_fd >=3D 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm_fd));
> +
> +       vcpu_fd =3D ioctl(vm_fd, KVM_CREATE_VCPU, 0);
> +       TEST_ASSERT(vcpu_fd >=3D 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu=
_fd));
> +
> +       err =3D ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
> +       TEST_ASSERT(err =3D=3D 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_f=
d));
> +
> +       close(vcpu_fd);
> +       close(vm_fd);
> +       close(kvm_fd);
> +
> +       return val;
> +}
> --
> 2.51.0
>

