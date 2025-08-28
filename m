Return-Path: <kvm+bounces-56073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D553B3991B
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 12:07:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A60D1C26C68
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 10:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8AA23081C7;
	Thu, 28 Aug 2025 10:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xDiCvMBu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A7026E140
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 10:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756375671; cv=none; b=MQyKuwvxGOIhbwcUfF5OqWyxdnSTT1iAT9vKDesfAxmJHEvTVcJ17OhcwUoWWprInA3+63CMN7IQCiYlRRZfS80ChKrEv1sN3GCyyWkefwJj1MfM0fGEqMSXYe/pAIo8euHyjVVGz4ZRPO5FZXbhGtcdVrtk0fSjoFdOXiq+BlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756375671; c=relaxed/simple;
	bh=TJWOQ9Y/D8amR26SYM4qj8T+TSWFnuMR5SCM6u632Hg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hnrTGbB7/ePdRUS81w/qSMl30Lr+Tr+JTL6kPb+uvHCPR/V6k0pQnMqa8QhwbIEY0rbVdMn5xgYLF9xDj4Hbmq/xSeUxjlYo9o4MIm50oYOoVT7pVY4dH3enK7+h2uuFtZlZHll5bfCgNwH2SdHM7J+Dwisr70VgTETBMGBWz70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xDiCvMBu; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b12b123e48so321991cf.0
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 03:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756375668; x=1756980468; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9E9CQIEDOr2UcYitZQ4gvIXZ41Noi3g2Rn0AmT7jQqk=;
        b=xDiCvMBukmDrwQWP9NfcVu92/hmzjPNT73QlcFd/GE9MoqlBdckobXLgM0ORwMD2nz
         hWS9XgjR1PB5tVLKDf/ZZ4/WKKW1P+vkbqYdqp8eI79pyEVq98Bhklkn921iVvPE7b3G
         42COmKXbQd/u+M9X1YDC5mB2YEdTTotTo5JLVyDglwNmGGZg9qknv8YmHx6kF9t5hd5X
         8/Qms1AOMABxeLj3HKtnjgI7GQuUAj+pWYpZCfChvItilsayrSLOCSqyztu6VIlvmKPY
         50ZW1OU/Xhxwr5s/qbVoN8h9M7rFWhit0/EwMepevEfOE/nNmoUVDw7X+IpWpTKscMe1
         38oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756375668; x=1756980468;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9E9CQIEDOr2UcYitZQ4gvIXZ41Noi3g2Rn0AmT7jQqk=;
        b=B7oBPrHtsPDs1vC4EjMPOwQnCfcUu4wvNU57k2ITDi9Ia7WTwTT/+8lN9qGtuhmoTT
         9Pe47qZnvZwAB1hd4cgxE1ghH/7rni1tEPMG1YhyleqVIGIN6FegFa39jni5/dahZcIy
         DqzOYKhP/e1RSLTX21uSfa+grxetay+VfnbXCsGKMiiIlOa4ovLFKaHfunvnXqA+ZSwL
         zg4/nLfoZxmsZcqPfvotUIqXNpTlgoHDzCLV8q9lZGDC/jWS3+dZykRrWnBvD3BC51oA
         p4BLfsrm5+ucjVh/TxuJOm/ACeIwSES8BSViMusSWbLmhDp9CqRV5NNdLNvkvbaJQnUE
         AkCA==
X-Forwarded-Encrypted: i=1; AJvYcCUWuQ2JXjd/f8IKIBLzj9trNCYkXv5xOvkxAy56yAmLVa1Gwkxvl87mQmK+viyyCCv9Md4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtTrROZNaL10XxNmdtG/E1cMaJXp4v7dPAnn+k+GcgzRHRkwl2
	iYwq9gE8i+Op8Iel0Iuud8kTRPke/Ly7oMdsUnZ3MpHkURM1oFqPXGBWOh+7rzUf1EZ+78MnuJk
	XYz0dqr5wWlOTL4v35tf3fy09ik5NpP+XnCqz6mQk
X-Gm-Gg: ASbGncs5MVFpGUSokV0wC17qUviBSJZznORzoBoTjkiEKClvwyM1x6/hE1rKDWaKoea
	9jpcW7MwAgLITv7idYGVjppbuzFJcC1eYOD5AO/M2p4Xnmkhsq8A4QU7VvuJFVpDLzW+n8u+FQO
	u82xEbmwcBv05UALBQkntz8HaBIsQ/ZKaPV24/bvjQ9t4Ep6aC+fK3q7O4bZsxcDkbMBDrjHpe6
	/eKVa4Iz03Obgg=
X-Google-Smtp-Source: AGHT+IFRjTT6s+Lga012dxByxsEc3lbr9K1CdoyVsw5ZK+adWd1hKzUTB9FTJRCdYTn8BAJBAZ04Flo9bNZpApNjkqk=
X-Received: by 2002:a05:622a:1816:b0:4a9:e17a:6288 with SMTP id
 d75a77b69052e-4b2e2c55f8amr18542401cf.13.1756375667872; Thu, 28 Aug 2025
 03:07:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250828093902.2719-1-roypat@amazon.co.uk> <20250828093902.2719-3-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-3-roypat@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 28 Aug 2025 11:07:11 +0100
X-Gm-Features: Ac12FXyRDhAk_TvQ6RybLCFXLNR5ZeiLskg-xMwpbNc02N3Vn5Fv4ySMEuemdfk
Message-ID: <CA+EHjTwDZ-FRV2KfC5ZG9SJYeeMRVUHQ8rVtb9dx2AQwCriPQw@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] arch: export set_direct_map_valid_noflush to KVM module
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "david@redhat.com" <david@redhat.com>, "seanjc@google.com" <seanjc@google.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Content-Type: text/plain; charset="UTF-8"

Hi Patrick,

On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
>
> Use the new per-module export functionality to allow KVM (and only KVM)
> access to set_direct_map_valid_noflush(). This allows guest_memfd to
> remove its memory from the direct map, even if KVM is built as a module.
>
> Direct map removal gives guest_memfd the same protection that
> memfd_secret enjoys, such as hardening against Spectre-like attacks
> through in-kernel gadgets.
>
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>  arch/arm64/mm/pageattr.c     | 1 +
>  arch/loongarch/mm/pageattr.c | 1 +
>  arch/riscv/mm/pageattr.c     | 1 +
>  arch/s390/mm/pageattr.c      | 1 +
>  arch/x86/mm/pat/set_memory.c | 1 +
>  5 files changed, 5 insertions(+)
>
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 04d4a8f676db..4f3cddfab9b0 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -291,6 +291,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>
>         return set_memory_valid(addr, nr, valid);
>  }
> +EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
>
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  /*
> diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
> index f5e910b68229..d076bfd3fcbf 100644
> --- a/arch/loongarch/mm/pageattr.c
> +++ b/arch/loongarch/mm/pageattr.c
> @@ -217,6 +217,7 @@ int set_direct_map_invalid_noflush(struct page *page)
>
>         return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
>  }
> +EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");

This should be after 'set_direct_map_valid_noflush', not 'invalid'.

With that fixed:

Reviewed-by: Fuad Tabba <tabba@google.com>

>  int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>  {
> diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
> index 3f76db3d2769..6db31040cd66 100644
> --- a/arch/riscv/mm/pageattr.c
> +++ b/arch/riscv/mm/pageattr.c
> @@ -400,6 +400,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>
>         return __set_memory((unsigned long)page_address(page), nr, set, clear);
>  }
> +EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
>
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void *data)
> diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
> index 348e759840e7..8ffd9ef09bc6 100644
> --- a/arch/s390/mm/pageattr.c
> +++ b/arch/s390/mm/pageattr.c
> @@ -413,6 +413,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>
>         return __set_memory((unsigned long)page_to_virt(page), nr, flags);
>  }
> +EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
>
>  bool kernel_page_present(struct page *page)
>  {
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 8834c76f91c9..87e9c7d2dcdc 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -2661,6 +2661,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>
>         return __set_pages_np(page, nr);
>  }
> +EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
>
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  void __kernel_map_pages(struct page *page, int numpages, int enable)
> --
> 2.50.1
>

