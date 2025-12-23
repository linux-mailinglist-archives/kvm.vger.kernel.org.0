Return-Path: <kvm+bounces-66621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B510CCDAC2E
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:31:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BE9D43020237
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 22:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43FE2E7180;
	Tue, 23 Dec 2025 22:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m/j04ROH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46051624C0
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 22:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766529102; cv=none; b=AyeJ2e2CtstLKWeS+FPf5ALYKTzG4/aAMpUgkZmVq7RNBqeaM7QjSVq3bTOZtSuQN/7Ii16XNY7939ZgcGVoH5Inje/5MlXgGvSxXDvuiZLNrj3XmIgSg2xtElRWZsrPWQt/3+b6x0kM7201QhGNfhl8pX992k66GZEvvi+xp9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766529102; c=relaxed/simple;
	bh=pNRc0KHbz74JaE/DfZecQHWIHjwdG57eh/blJw5wKWg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XbpruwN5WDl6/8OPZG0CQzfVdNtTlU7mRGa60LKoPHzG581Lq/rmBUhiWXIL8V6Np6I1Z4uTGItQoonMcuGfA6sU9W5Q9TVemFeOreaP7L6U/GZ+LxmDhSKhbzeRF1NvnQWp3yA/fS7s/7pg6NaJAqs8RZcdAYSo9b32plKjMXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m/j04ROH; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0fe4ade9eso56925405ad.0
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 14:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766529100; x=1767133900; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EUgtBe0TjnfoSeEw8Ob4sia2qgK0pnGx9ekLu2PMhhg=;
        b=m/j04ROHDe9lka8Pyy7dGnVPEdyzs5fXoPgn9hG5uZ2BSGj5bs2r3uLDj49A1WhKTq
         kcjqJM4hU/WEJZw9CIbcFynLw+jWBzeXDlK6s+D3ZiTisb9iTRvJt98Wdi9QO9rEBAXR
         a55SMUH+2GERjMmInxW7Hf8NsohNQecM/+0ZfISoXibhT/rtteXjtnMudBen8nBBJp6f
         KcQIjOuVS23xdXhl1bvm6egN4ohL6zfegpcn+0paDvdHJYHtAAFpx7mRb163fym7a3on
         2GrtDZJ8EQnQ3M3LCgOIgapwc7uXa4EG4/Bh4d3HEoKsyF634y/lBNjh3xYVj4vHYgKT
         U4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766529100; x=1767133900;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EUgtBe0TjnfoSeEw8Ob4sia2qgK0pnGx9ekLu2PMhhg=;
        b=PbvkEr+2jdFCNd1b6sBMbQOrHCGOklXOjpXbbZ4BmJ0V4wOC+jaWAp6JxgajFK2Cx+
         +fW48mpJ0+b+T/0Mct0oEkvSRBnOThdkhYSFQpHR83fPIo6FANPZ07bNB9lyPvWYNCcF
         3t5v/KBoW8WeOwoaow96iM0rOuddhFKOjdzaPdjA8qUQPTsEu4EpUS+sNG93j0CnwSEo
         i0r1amW8MmHXyEw8vH4x3zvzBb/kO9dBh5McTvD15zxBolNwBmSvhguz84bu+oj53z10
         Z8DT5Vvf5lSHqQFxgss8Tq/4TiH4Bja84vfFfD6jaM6GYIweSFFqHu9nzrqVVzqPfO51
         dt7w==
X-Forwarded-Encrypted: i=1; AJvYcCXa/jGlNzsMIqjT9Zs2W70L4jYfxrc+wiDsgQ3Zc5Alg95M5O0HxxYioHFopUow/jmhsvs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwihcFId1rry2sTCGpDKf++85sRFNhQavWM0MiXLR1jZXsnpOCT
	rNsPCEd0rFcTp5Xy1RaNjcDeUm60fephuVaWzrVJvOB9XTo6Ock6isG8U/Ewc8vGF4yo0J7leHP
	nrXzWOw==
X-Google-Smtp-Source: AGHT+IE/xzvCnKXslifaCkAvY80PculxbkJzujdBwBs4+lR/kKMvkhrZ6OQ+bRkDB+CywaiaoaaqxbRAtYc=
X-Received: from plda12.prod.google.com ([2002:a17:902:ee8c:b0:29f:2f99:afb9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32cd:b0:2a0:be7b:1c50
 with SMTP id d9443c01a7336-2a2f222b551mr148969395ad.14.1766529100045; Tue, 23
 Dec 2025 14:31:40 -0800 (PST)
Date: Tue, 23 Dec 2025 14:31:38 -0800
In-Reply-To: <20251127013440.3324671-8-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev> <20251127013440.3324671-8-yosry.ahmed@linux.dev>
Message-ID: <aUsYSvd2gBOKt9fo@google.com>
Subject: Re: [PATCH v3 07/16] KVM: selftests: Move PTE bitmasks to kvm_mmu
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> @@ -1449,11 +1439,44 @@ enum pg_level {
>  #define PG_SIZE_2M PG_LEVEL_SIZE(PG_LEVEL_2M)
>  #define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
>  
> +struct pte_masks {
> +	uint64_t present;
> +	uint64_t writable;
> +	uint64_t user;
> +	uint64_t accessed;
> +	uint64_t dirty;
> +	uint64_t huge;
> +	uint64_t nx;
> +	uint64_t c;
> +	uint64_t s;
> +};
> +
>  struct kvm_mmu {
>  	uint64_t root_gpa;
>  	int pgtable_levels;
> +	struct pte_masks pte_masks;

And then introduce kvm_mmu_arch so that x86 can shove pte_masks into the mmu.

>  };
>  
> +#define PTE_PRESENT_MASK(mmu) ((mmu)->pte_masks.present)
> +#define PTE_WRITABLE_MASK(mmu) ((mmu)->pte_masks.writable)
> +#define PTE_USER_MASK(mmu) ((mmu)->pte_masks.user)
> +#define PTE_ACCESSED_MASK(mmu) ((mmu)->pte_masks.accessed)
> +#define PTE_DIRTY_MASK(mmu) ((mmu)->pte_masks.dirty)
> +#define PTE_HUGE_MASK(mmu) ((mmu)->pte_masks.huge)
> +#define PTE_NX_MASK(mmu) ((mmu)->pte_masks.nx)
> +#define PTE_C_MASK(mmu) ((mmu)->pte_masks.c)
> +#define PTE_S_MASK(mmu) ((mmu)->pte_masks.s)
> +
> +#define pte_present(mmu, pte) (!!(*(pte) & PTE_PRESENT_MASK(mmu)))

I very, very strongly prefer is_present_pte(), is_huge_pte(), etc.

> +#define pte_writable(mmu, pte) (!!(*(pte) & PTE_WRITABLE_MASK(mmu)))
> +#define pte_user(mmu, pte) (!!(*(pte) & PTE_USER_MASK(mmu)))
> +#define pte_accessed(mmu, pte) (!!(*(pte) & PTE_ACCESSED_MASK(mmu)))
> +#define pte_dirty(mmu, pte) (!!(*(pte) & PTE_DIRTY_MASK(mmu)))
> +#define pte_huge(mmu, pte) (!!(*(pte) & PTE_HUGE_MASK(mmu)))
> +#define pte_nx(mmu, pte) (!!(*(pte) & PTE_NX_MASK(mmu)))
> +#define pte_c(mmu, pte) (!!(*(pte) & PTE_C_MASK(mmu)))
> +#define pte_s(mmu, pte) (!!(*(pte) & PTE_S_MASK(mmu)))

