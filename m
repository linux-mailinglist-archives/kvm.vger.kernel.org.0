Return-Path: <kvm+bounces-24424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEA5B955152
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 21:21:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95336282076
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 19:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20AB71C3F2D;
	Fri, 16 Aug 2024 19:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1l1+JRrZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7C21A4F04
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 19:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723836082; cv=none; b=m1tx6fi6bEOhZtLX5tdO6wLXiwrZoqtAzQ9qTo6od3y/wviD/uxpxt2q8+WYj6pm3H59bIAPdBJKUdliAhestYPyKq56TUPX43olJhB62WQApoyPVVbdBMeVcNtQNW7rl/llnW0DMEXrVqGAinqb9fEBtrLFRdJ6DahI2lQR0zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723836082; c=relaxed/simple;
	bh=EEBIa6fj/Pv2HSdlYiP/qAmyl9BfYOfm6PD9687aiWo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QfRhCvEDSPqt/mH7dyVqO52Ke1M75JAtFLF/JKHAr2MYn+CFhWVxBlOyuWecuRB26/pl4XJOaQJMo2RYtWFm61+9KYnZoaCGKkAib0D/MDt5hDfFLr7B4yJwmHt1dS/ug2AjjB0KBuQkPRyWNAUp4xoqd+kp/v7nljNQxOdPXg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1l1+JRrZ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a1188b3bc2so2060938a12.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 12:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723836080; x=1724440880; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ftVQJ22uwhnVCu9sapxQkj0rYV8PxV9JBpHRmc+PMHc=;
        b=1l1+JRrZVJDtBInOWZsqpJxDVFY9aZQ15RFIMgCrLCBTzQ5F/SU3es8Rc5H3LFU/Ab
         /wft3Ze6Yz7fjFRsEhNs3aKkl3dGkeMgSug4gomMiiAra+IPZ6m43CBaYnztG/a4NzJi
         Agnh196XRaenDSyuKNXC4AuTHvZQUbv2g6sLRH+atInNMjqMhbQy8ycgLEf/03thjL0Y
         Zypc+GYCYkAJvK9AS+fdPxLV4YhYsAMCJ6OOGZg3Cv2ptmtyaesLGG86QSMHunlOcCSp
         lo24U+2p8+GNWj4B3UUuniMhC924uwtgu51b2Jkh+fncepPRt0KKSayzxsjJqepIgbF9
         TTvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723836080; x=1724440880;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ftVQJ22uwhnVCu9sapxQkj0rYV8PxV9JBpHRmc+PMHc=;
        b=R9cNyRTIuE1CoKNvcMtAsqd7Hg6B5fMwlME/LVuPJxEAGDKQybmXyNdLfpxOSdcmmE
         VECNMhfMYhjaLD07bvEfe1OOjPJ7pzvExxyLkK4xqVKDdZo/Pso343qhB+PpVCNCR62e
         YXNEs5VZZduqWCSaBmrLr0zw4BIRhrlevy8diZhZ6Ad29mgs2jcBPPhNomMf2i+4mUt9
         pEerooapNtoVOt/5Nu08WWSnhUVh/4AXk6/5SSBCMjth0BgygmkoKNyh+1LnF/bzAIAr
         Rn6fgCK4s2GRmljNB5Akls6E0WGWpTe8DnWKoXmw/97r0hNzykfUIP5HrfrYqnMVbUwY
         1tEg==
X-Forwarded-Encrypted: i=1; AJvYcCUilXRDiUgotGEKOxXkJWDHSnEvI7FjNaslG5N+hVVb8eYuNrHKpw7ZZmAKWAaZ34S+Irk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3msyME0UYPF5uOIDlyP/1RiS7gh42ycIIgWpXIWLqif/Sc3jX
	oMfxYnnImmw1chBZiMOWcu8zk2ns7ymoVHojwpr3SN/++PrBwIw1+58LtiquVAWDjmahYBH4r4T
	kOA==
X-Google-Smtp-Source: AGHT+IHf6qVj/b2zC94+HdArQXss/KprNTNzFkLYPIjrHyHGZ5yxwPLzjGqV4Tufr9LC9iVbmqgXfl1sOeQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4e60:0:b0:7c6:acc8:3eb5 with SMTP id
 41be03b00d2f7-7c978efc48fmr6574a12.1.1723836079882; Fri, 16 Aug 2024 12:21:19
 -0700 (PDT)
Date: Fri, 16 Aug 2024 12:21:18 -0700
In-Reply-To: <13-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com> <13-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
Message-ID: <Zr-mrsewGxXt1rAC@google.com>
Subject: Re: [PATCH 13/16] iommupt: Add the x86 PAE page table format
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Lu Baolu <baolu.lu@linux.intel.com>, 
	David Hildenbrand <david@redhat.com>, Christoph Hellwig <hch@lst.de>, iommu@lists.linux.dev, 
	Joao Martins <joao.m.martins@oracle.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-mm@kvack.org, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Tina Zhang <tina.zhang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 15, 2024, Jason Gunthorpe wrote:
> This is used by x86 CPUs and can be used in both x86 IOMMUs. When the x86
> IOMMU is running SVA it is using this page table format.
> 
> This implementation follows the AMD v2 io-pgtable version.
> 
> There is nothing remarkable here, the format has a variable top and
> limited support for different page sizes and no contiguous pages support.
> 
> In principle this can support the 32 bit configuration with fewer table
> levels.

What's "the 32 bit configuration"?

> FIXME: Compare the bits against the VT-D version too.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/generic_pt/Kconfig            |   6 +
>  drivers/iommu/generic_pt/fmt/Makefile       |   2 +
>  drivers/iommu/generic_pt/fmt/defs_x86pae.h  |  21 ++
>  drivers/iommu/generic_pt/fmt/iommu_x86pae.c |   8 +
>  drivers/iommu/generic_pt/fmt/x86pae.h       | 283 ++++++++++++++++++++
>  include/linux/generic_pt/common.h           |   4 +
>  include/linux/generic_pt/iommu.h            |  12 +
>  7 files changed, 336 insertions(+)
>  create mode 100644 drivers/iommu/generic_pt/fmt/defs_x86pae.h
>  create mode 100644 drivers/iommu/generic_pt/fmt/iommu_x86pae.c
>  create mode 100644 drivers/iommu/generic_pt/fmt/x86pae.h
> 
> diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
> index e34be10cf8bac2..a7c006234fc218 100644
> --- a/drivers/iommu/generic_pt/Kconfig
> +++ b/drivers/iommu/generic_pt/Kconfig
> @@ -70,6 +70,11 @@ config IOMMU_PT_ARMV8_64K
>  
>  	  If unsure, say N here.
>  
> +config IOMMU_PT_X86PAE
> +       tristate "IOMMU page table for x86 PAE"
> +#include "iommu_template.h"
> diff --git a/drivers/iommu/generic_pt/fmt/x86pae.h b/drivers/iommu/generic_pt/fmt/x86pae.h
> new file mode 100644
> index 00000000000000..9e0ee74275fcb3
> --- /dev/null
> +++ b/drivers/iommu/generic_pt/fmt/x86pae.h
> @@ -0,0 +1,283 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
> + *
> + * x86 PAE page table
> + *
> + * This is described in
> + *   Section "4.4 PAE Paging" of the Intel Software Developer's Manual Volume 3

I highly doubt what's implemented here is actually PAE paging, as the SDM (that
is referenced above) and most x86 folks describe PAE paging.  PAE paging is
specifically used when the CPU is in 32-bit mode (NOT including compatibility mode!).

  PAE paging translates 32-bit linear addresses to 52-bit physical addresses.

Presumably what's implemented here is what Intel calls 4-level and 5-level paging.
Those are _really_ similar to PAE paging, e.g. have the same encodings for bits
11:0, and even require CR4.PAE=1, but they aren't 100% identical.  E.g. true PAE
paging doesn't have software-available bits in 62:MAXPHYADDR.

Unfortuntately, I have no idea what name to use for this flavor.  x86pae is
actually kinda good, but I think it'll be confusing to people that are familiar
with the more canonical version of PAE paging.

> + *   Section "2.2.6 I/O Page Tables for Guest Translations" of the "AMD I/O
> + *   Virtualization Technology (IOMMU) Specification"
> + *
> + * It is used by x86 CPUs and The AMD and VT-D IOMMU HW.
> + *
> + * The named levels in the spec map to the pts->level as:
> + *   Table/PTE - 0
> + *   Directory/PDE - 1
> + *   Directory Ptr/PDPTE - 2
> + *   PML4/PML4E - 3
> + *   PML5/PML5E - 4

Any particularly reason not to use x86's (and KVM's) effective 1-based system?
(level '0' is essentially the 4KiB leaf entries in a page table)

Starting at '1' is kinda odd, but it aligns with thing like PML4/5, allows using
the pg_level enums from x86, and diverging from both x86 MM and KVM is likely
going to confuse people.
	
> + * FIXME: __sme_set
> + */
> +#ifndef __GENERIC_PT_FMT_X86PAE_H
> +#define __GENERIC_PT_FMT_X86PAE_H
> +
> +#include "defs_x86pae.h"
> +#include "../pt_defs.h"
> +
> +#include <linux/bitfield.h>
> +#include <linux/container_of.h>
> +#include <linux/log2.h>
> +
> +enum {
> +	PT_MAX_OUTPUT_ADDRESS_LG2 = 52,
> +	PT_MAX_VA_ADDRESS_LG2 = 57,
> +	PT_ENTRY_WORD_SIZE = sizeof(u64),
> +	PT_MAX_TOP_LEVEL = 4,
> +	PT_GRANUAL_LG2SZ = 12,
> +	PT_TABLEMEM_LG2SZ = 12,
> +};
> +
> +/* Shared descriptor bits */
> +enum {
> +	X86PAE_FMT_P = BIT(0),
> +	X86PAE_FMT_RW = BIT(1),
> +	X86PAE_FMT_U = BIT(2),
> +	X86PAE_FMT_A = BIT(5),
> +	X86PAE_FMT_D = BIT(6),
> +	X86PAE_FMT_OA = GENMASK_ULL(51, 12),
> +	X86PAE_FMT_XD = BIT_ULL(63),

Any reason not to use the #defines in arch/x86/include/asm/pgtable_types.h?

> +static inline bool x86pae_pt_install_table(struct pt_state *pts,
> +					   pt_oaddr_t table_pa,
> +					   const struct pt_write_attrs *attrs)
> +{
> +	u64 *tablep = pt_cur_table(pts, u64);
> +	u64 entry;
> +
> +	/*
> +	 * FIXME according to the SDM D is ignored by HW on table pointers?

Correct, only leaf entries have dirty bits.  

> +	 * io_pgtable_v2 sets it
> +	 */
> +	entry = X86PAE_FMT_P | X86PAE_FMT_RW | X86PAE_FMT_U | X86PAE_FMT_A |

What happens with the USER bit for I/O page tables?  Ignored, I assume?

> +		X86PAE_FMT_D |
> +		FIELD_PREP(X86PAE_FMT_OA, log2_div(table_pa, PT_GRANUAL_LG2SZ));
> +	return pt_table_install64(&tablep[pts->index], entry, pts->entry);
> +}

