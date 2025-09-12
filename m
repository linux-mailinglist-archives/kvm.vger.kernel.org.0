Return-Path: <kvm+bounces-57430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF427B55640
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 20:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6729B7B2C0E
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 18:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4D1632F755;
	Fri, 12 Sep 2025 18:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ta+7Z07a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06485285C98
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 18:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757702049; cv=none; b=CC5sOkqR5MUSdLWqH3GdL7bhtRIrwBd0/eoSv8r5D30YDIYcRRYZjGdEd3+ngCWdK8fuxIPDQNPywzTtK8odUGu6En52sYTojBmy9qwZLwygQHkVNh9WhSVVKV+OonopEKsdF0v7d/LyyUuq+OJW2VAc226I/m3omYzobqvbUg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757702049; c=relaxed/simple;
	bh=v5FVcC8hgZ/p+a0lbHORb4niU4q1wCJsNavaGkYebHY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ciIxNFNlEOSTmd02Bw2l862k6XzFhDVDOHOt8uZppGj4yZy76nyNgrtdqHH0OOrwdoa5ziWKdk1PS255nSBqFiN/tgFT0BOqwgHTcMF16qYOX6OHbpR1+oRDp24JzX5ukvk7UsZIa6Dv70fMjz/7XaHLAIG31Pu/sIL671l5HyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ta+7Z07a; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-323766e64d5so2831947a91.0
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 11:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757702046; x=1758306846; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tlhPWLmUue00CiOxFvUNznMlr4ctvmMFViLBjGFh5aE=;
        b=Ta+7Z07aX/XmKlaS6kgQniPSXSSse7gK2/vyNkgTaWHah41wCHrEypIOaGH3StoYQR
         4+Dv8bw+Vdbo70b0smLqk7DIxK2b0KDi95R4TIEC1cthWlKz61nW2fj0vvbcbvAauDby
         vR8v2nj3YcNejqWmbIsu07JLa+WUtNiQIRsLo23bBAC5BUQSHfweiUFg8vHLwdo9x4sZ
         weMWSl07D1p72GoDxRi626LBielC8B52iLRp0yNemMIkOzl6/ZeOvjKhDOEH/hNkwmDf
         bJimQQst9X6jarSlcgRrDoTMwPllvsSoa21HH/6Nh3hkT4qBQAuIJI2HQsrvLCa2YGWU
         dlFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757702046; x=1758306846;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tlhPWLmUue00CiOxFvUNznMlr4ctvmMFViLBjGFh5aE=;
        b=eOmMMpVcbwub9rP9ubFIqD6+y4xe5QYhTKk1qTiBrZ91ICvgvMO0C2u0QKmCKgdYry
         CvVfQ7T6abGjuoJX5ZzzHLGTDvtlRlJS7evdxvOd+FLMZoD2U7vAG7CNLtUknvPxcUvi
         93Zii2Rhw9KSxu5gMGuhLQ+UuzPJqaKezBQdswVz4zlYrrzWuWGQFyaTEsODzgdD9sBt
         L3ZPnkyL+L9dmDnNefBa00Hr/7kjIAHHL1KcViTT4kVg7D+PSvRwbUK0FsQpmk91RLah
         xokxYFuh68wQt19jD71ZslYQDc6zRdLL8tDVMGwxbd38hQsbqDeHOHwOPI+n095gU8OC
         0iUA==
X-Forwarded-Encrypted: i=1; AJvYcCXiSGKabiDumP/xFwMzfQZtukVlTN64y/bZY4ca+epl+me9BRKrigGkTCbHBeBGVvJZUJs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzs/K0JejraK//DjKmK62FMyF8LG+Lgs2lTFb98bE7O2gntdXx
	0ClGU864i7GGjUlCHRVj3RVV9qWG2SPPlWP0M4W0cSDuUc6KJEyH4KM63I320uPKzpvzW8PS/AA
	LFiWpPg==
X-Google-Smtp-Source: AGHT+IFkjA4Yytqm3FFtm5CKt77K8SX2eP0ZGGmXPW8IcXnFSSTQ7TlT5fqN5rSSfLmzpZPc20T/4sMe+jo=
X-Received: from pjbsu16.prod.google.com ([2002:a17:90b:5350:b0:32d:f25c:6a58])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3851:b0:329:8520:cee7
 with SMTP id 98e67ed59e1d1-32de4c44ae9mr4236965a91.14.1757702046207; Fri, 12
 Sep 2025 11:34:06 -0700 (PDT)
Date: Fri, 12 Sep 2025 11:34:04 -0700
In-Reply-To: <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1757543774.git.ashish.kalra@amd.com> <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>
Message-ID: <aMRnnNVYBrasJnZF@google.com>
Subject: Re: [PATCH v4 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	pbonzini@redhat.com, thomas.lendacky@amd.com, herbert@gondor.apana.org.au, 
	nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org, 
	john.allen@amd.com, michael.roth@amd.com, Neeraj.Upadhyay@amd.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025, Ashish Kalra wrote:
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 00475b814ac4..7a1ae990b15f 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -635,10 +635,15 @@ void snp_dump_hva_rmpentry(unsigned long address);
>  int psmash(u64 pfn);
>  int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bo=
ol immutable);
>  int rmp_make_shared(u64 pfn, enum pg_level level);
> -void snp_leak_pages(u64 pfn, unsigned int npages);
> +void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp);
>  void kdump_sev_callback(void);
>  void snp_fixup_e820_tables(void);
> =20
> +static inline void snp_leak_pages(u64 pfn, unsigned int pages)
> +{
> +	__snp_leak_pages(pfn, pages, true);
> +}
> +
>  static inline void sev_evict_cache(void *va, int npages)
>  {
>  	volatile u8 val __always_unused;
> @@ -668,6 +673,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, =
enum pg_level level, u32 as
>  	return -ENODEV;
>  }
>  static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return=
 -ENODEV; }
> +static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool d=
ump_rmp) {}

This stub is unnecessary.  As pointed out elsewhere[*], I'm pretty sure all=
 these
stubs are unnecessary.

Oof.  Even worse, the stubs appear to be actively hiding bugs.  The APIs ar=
e
guarded with CONFIG_KVM_AMD_SEV=3Dy, but **KVM** doesn't call any of these =
outside
of SEV code.  I.e. if *KVM* were the only user, the stubs would just be dea=
d code.

But the below build failures show that they aren't dead code, which means t=
hat
kernels with CONFIG_KVM_AMD_SEV=3Dn will silently (until something explodes=
) do the
wrong thing, because the stubs are hiding the missing dependencies.

arch/x86/boot/startup/sev-shared.c: In function =E2=80=98pvalidate_4k_page=
=E2=80=99:
arch/x86/boot/startup/sev-shared.c:820:17: error: implicit declaration of f=
unction =E2=80=98sev_evict_cache=E2=80=99 [-Wimplicit-function-declaration]
  820 |                 sev_evict_cache((void *)vaddr, 1);
      |                 ^~~~~~~~~~~~~~~
  AR      arch/x86/realmode/built-in.a
arch/x86/coco/sev/core.c: In function =E2=80=98pvalidate_pages=E2=80=99:
arch/x86/coco/sev/core.c:386:25: error: implicit declaration of function =
=E2=80=98sev_evict_cache=E2=80=99 [-Wimplicit-function-declaration]
  386 |                         sev_evict_cache(pfn_to_kaddr(e->gfn), e->pa=
gesize ? 512 : 1);
      |                         ^~~~~~~~~~~~~~~
arch/x86/mm/mem_encrypt.c: In function =E2=80=98mem_encrypt_setup_arch=E2=
=80=99:
arch/x86/mm/mem_encrypt.c:112:17: error: implicit declaration of function =
=E2=80=98snp_fixup_e820_tables=E2=80=99 [-Wimplicit-function-declaration]
  112 |                 snp_fixup_e820_tables();
      |                 ^~~~~~~~~~~~~~~~~~~~~
arch/x86/mm/fault.c: In function =E2=80=98show_fault_oops=E2=80=99:
arch/x86/mm/fault.c:587:17: error: implicit declaration of function =E2=80=
=98snp_dump_hva_rmpentry=E2=80=99 [-Wimplicit-function-declaration]
  587 |                 snp_dump_hva_rmpentry(address);
      |                 ^~~~~~~~~~~~~~~~~~~~~
arch/x86/kernel/cpu/amd.c: In function =E2=80=98bsp_determine_snp=E2=80=99:
arch/x86/kernel/cpu/amd.c:370:21: error: implicit declaration of function =
=E2=80=98snp_probe_rmptable_info=E2=80=99 [-Wimplicit-function-declaration]
  370 |                     snp_probe_rmptable_info()) {
      |                     ^~~~~~~~~~~~~~~~~~~~~~~
  AR      drivers/iommu/amd/built-in.a
  AR      drivers/iommu/built-in.a
  AR      drivers/built-in.a

[*] https://lore.kernel.org/all/aMHP5EO-ucJGdHXz@google.com

