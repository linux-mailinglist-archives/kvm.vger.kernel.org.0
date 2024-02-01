Return-Path: <kvm+bounces-7698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F3DD8456E3
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 13:06:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FA2E1F29F29
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 12:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C2F15DBDD;
	Thu,  1 Feb 2024 12:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ae0L2Vs9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBD11649A7
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 12:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706789045; cv=none; b=LWxv+d2rZ+u584qhCIZGjEw2DPpY7xj8yvf7DkRdohUB5Ff3R3eafPj9vrExitY2T2Z83pocXs+nqxr4mdSSSPqwmePldgAE6RB3z0jwImNCyHLG1w+KwuSEp1nAVFFGALyUES507B2oOin5hiGPwF32v7aNuunqSJdzxFJRfYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706789045; c=relaxed/simple;
	bh=ciI2PT9/1741iRumVa2zaEsplRhOjMDEzoEh4DaQZnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NYFG9g/Swnw9dpf58kmeT1GtZkYr+c1+q+9zDwQ9wClQoaIb2Ryh/mAGMbXZsZp9QhORuRJkQwkWCUaxsXBbj9mMqG/gp+sSUJ28tY+VPkiBuQBuhhnpBkfGkbIZ+LxzfgQiqgYFvSPWXQBmE1zTaJ/AXXUiLIYvi0tQBE4XnEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ae0L2Vs9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706789042;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6u7HMn33dmpHG+enauIgbjXIS45b8abZ3thsisyrCnc=;
	b=Ae0L2Vs9aW4kua9RD0EdCNNfWQBNDuKQ9biZEHeSaUco5f3sQEQzb7sU0Cqk7PnjVTY1Gh
	vX59cyCU2LWNTe319afBhRaShJHw6XQKis/hF8rpo6TSppP/uBo9BcLkQZspVQ//TRVl9v
	/gft3rZkMrCLKX/Ich+/FuC6clqc4tg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-xzKDEdTdP_qYON2gD9I_dQ-1; Thu, 01 Feb 2024 07:04:00 -0500
X-MC-Unique: xzKDEdTdP_qYON2gD9I_dQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-68058b0112cso14320436d6.1
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 04:04:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706789039; x=1707393839;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6u7HMn33dmpHG+enauIgbjXIS45b8abZ3thsisyrCnc=;
        b=dQIrnWlgmeycVkSBfHcswbiO/QW/Ytt7gvkOw9YlLnjyRRUt6t5X0Bl54Z2h7d57tN
         blWGxwPinq7yIXz4+OvBe4vIK2Gljii6GdwUvNyADjJW4r5386P1V29/i9PRHMY2v5jR
         uPxWPTc8zc68TD20OFCpYGt2om6F+q76hTtJkrc4ktLF7UOe1F9K57S+qjvfBGi4yEci
         eh4VAvj4j0mByUnGEjVDUtciDAkM4VGAwLqlCrISJ+jk4Q+m40IDKWH9+VoXbgvGZygp
         qwTJJ+a9MW86bEWcBU8c7uEBMzYu9OnuXtpklggDdpveu+Zf4A37UA3W8JFDUVQr3Djg
         +xpw==
X-Gm-Message-State: AOJu0YyO7FsnC1/vBvEpApNpN+QwbmYrmOVBtuJqmjZA9vVU8efR+Izn
	sbndy3ZpoGNEA2aXhVL0ikh+KOH1vV3JKgRVxmwr0XHbygVA7+yT9dqTACULxtKlXgdxHt3KQd+
	ofCcfND8sFC4rVrVXZEY464MSNmbJb3GuJn4LgIA3UrFAixKEVvVPz6Ojiw==
X-Received: by 2002:a05:6214:2a88:b0:68c:557c:4cbb with SMTP id jr8-20020a0562142a8800b0068c557c4cbbmr5210679qvb.47.1706789039616;
        Thu, 01 Feb 2024 04:03:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFwoxvAXsBwLztQ5zwBqWGNBkYo51Ee5pvDLVGVK2At84GC23v9yUT/Ahia7frW0hWN9r3AA==
X-Received: by 2002:a05:6214:2a88:b0:68c:557c:4cbb with SMTP id jr8-20020a0562142a8800b0068c557c4cbbmr5210645qvb.47.1706789039209;
        Thu, 01 Feb 2024 04:03:59 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCU7a7gjOJg4TRLEua23JiWKZ7YraK95IgKXroblTJJym6IIo/Ua3Uiq0lpMAMGQT3cOF3PEe4fBWQutJfFni0elAUUPyY33MbnyPijqa7ninQF6hUQvT2gblLNXxGjglNVVwjh/dQHRMuQ5SZTfJQG3ObI3AKy0sL05kfcLHmjn5MsnjodrZ02SDhshY0TJHfVOsmF8wUsXdvJuENOJlpIMtI3QVl4z3Ye1keMobpPgNJZ1Jo+qXWKu+1Zrhoh2o9iTweWU8CdKl02SytECXj2RrNLFgpOqxdVH0rxngrsj/Zj0B2Q7NN0=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id pg6-20020a0562144a0600b0068c45e42bb2sm21882qvb.55.2024.02.01.04.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 04:03:58 -0800 (PST)
Message-ID: <730ca018-cb7b-4ef8-b544-7afdfce03bc8@redhat.com>
Date: Thu, 1 Feb 2024 13:03:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 16/24] arm/arm64: Share memregions
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-42-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-42-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Drew,

On 1/26/24 15:23, Andrew Jones wrote:
> arm/arm64 (and to a small extent powerpc) have memory regions which
> get built from hardware descriptions (DT/ACPI/EFI) and then used to
> build page tables. Move memregions to common code, tweaking the API
> a bit at the same time, e.g. change 'mem_region' to 'memregions'.
> The biggest change is there is now a default number of memory regions
> which, if too small, should be overridden at setup time with a new
> init function, memregions_init().
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Acked-by: Thomas Huth <thuth@redhat.com>
> ---
>  arm/Makefile.common |  1 +
>  arm/selftest.c      |  3 +-
>  lib/arm/asm/setup.h | 14 -------
>  lib/arm/mmu.c       |  1 +
>  lib/arm/setup.c     | 93 ++++++++++-----------------------------------
>  lib/memregions.c    | 82 +++++++++++++++++++++++++++++++++++++++
>  lib/memregions.h    | 29 ++++++++++++++
>  7 files changed, 136 insertions(+), 87 deletions(-)
>  create mode 100644 lib/memregions.c
>  create mode 100644 lib/memregions.h
>
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index dc92a7433350..4dfd570fa59e 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -42,6 +42,7 @@ cflatobjs += lib/alloc_page.o
>  cflatobjs += lib/vmalloc.o
>  cflatobjs += lib/alloc.o
>  cflatobjs += lib/devicetree.o
> +cflatobjs += lib/memregions.o
>  cflatobjs += lib/migrate.o
>  cflatobjs += lib/on-cpus.o
>  cflatobjs += lib/pci.o
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 9f459ed3d571..007d2309d01c 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -8,6 +8,7 @@
>  #include <libcflat.h>
>  #include <util.h>
>  #include <devicetree.h>
> +#include <memregions.h>
>  #include <vmalloc.h>
>  #include <asm/setup.h>
>  #include <asm/ptrace.h>
> @@ -90,7 +91,7 @@ static bool check_pabt_init(void)
>  			highest_end = PAGE_ALIGN(r->end);
>  	}
>  
> -	if (mem_region_get_flags(highest_end) != MR_F_UNKNOWN)
> +	if (memregions_get_flags(highest_end) != MR_F_UNKNOWN)
>  		return false;
>  
>  	vaddr = (unsigned long)vmap(highest_end, PAGE_SIZE);
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index 060691165a20..9f8ef82efb90 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -13,22 +13,8 @@
>  extern u64 cpus[NR_CPUS];	/* per-cpu IDs (MPIDRs) */
>  extern int nr_cpus;
>  
> -#define MR_F_IO			(1U << 0)
> -#define MR_F_CODE		(1U << 1)
> -#define MR_F_RESERVED		(1U << 2)
> -#define MR_F_UNKNOWN		(1U << 31)
> -
> -struct mem_region {
> -	phys_addr_t start;
> -	phys_addr_t end;
> -	unsigned int flags;
> -};
> -extern struct mem_region *mem_regions;
>  extern phys_addr_t __phys_offset, __phys_end;
>  
> -extern struct mem_region *mem_region_find(phys_addr_t paddr);
> -extern unsigned int mem_region_get_flags(phys_addr_t paddr);
> -
>  #define PHYS_OFFSET		(__phys_offset)
>  #define PHYS_END		(__phys_end)
>  
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index b16517a3200d..eb5e82a95f06 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -6,6 +6,7 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  #include <cpumask.h>
> +#include <memregions.h>
>  #include <asm/setup.h>
>  #include <asm/thread_info.h>
>  #include <asm/mmu.h>
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index b6fc453e5b31..0382cbdaf5a1 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -13,6 +13,7 @@
>  #include <libcflat.h>
>  #include <libfdt/libfdt.h>
>  #include <devicetree.h>
> +#include <memregions.h>
>  #include <alloc.h>
>  #include <alloc_phys.h>
>  #include <alloc_page.h>
> @@ -31,7 +32,7 @@
>  
>  #define MAX_DT_MEM_REGIONS	16
>  #define NR_EXTRA_MEM_REGIONS	64
> -#define NR_INITIAL_MEM_REGIONS	(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
> +#define NR_MEM_REGIONS		(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
>  
>  extern unsigned long _text, _etext, _data, _edata;
>  
> @@ -41,8 +42,7 @@ u32 initrd_size;
>  u64 cpus[NR_CPUS] = { [0 ... NR_CPUS-1] = (u64)~0 };
>  int nr_cpus;
>  
> -static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
> -struct mem_region *mem_regions = __initial_mem_regions;
> +static struct mem_region arm_mem_regions[NR_MEM_REGIONS + 1];
>  phys_addr_t __phys_offset = (phys_addr_t)-1, __phys_end = 0;
>  
>  extern void exceptions_init(void);
> @@ -114,68 +114,14 @@ static void cpu_init(void)
>  	set_cpu_online(0, true);
>  }
>  
> -static void mem_region_add(struct mem_region *r)
> +static void arm_memregions_add_assumed(void)
>  {
> -	struct mem_region *r_next = mem_regions;
> -	int i = 0;
> -
> -	for (; r_next->end; ++r_next, ++i)
> -		;
> -	assert(i < NR_INITIAL_MEM_REGIONS);
> -
> -	*r_next = *r;
> -}
> -
> -static void mem_regions_add_dt_regions(void)
> -{
> -	struct dt_pbus_reg regs[MAX_DT_MEM_REGIONS];
> -	int nr_regs, i;
> -
> -	nr_regs = dt_get_memory_params(regs, MAX_DT_MEM_REGIONS);
> -	assert(nr_regs > 0);
> -
> -	for (i = 0; i < nr_regs; ++i) {
> -		mem_region_add(&(struct mem_region){
> -			.start = regs[i].addr,
> -			.end = regs[i].addr + regs[i].size,
> -		});
> -	}
> -}
> -
> -struct mem_region *mem_region_find(phys_addr_t paddr)
> -{
> -	struct mem_region *r;
> -
> -	for (r = mem_regions; r->end; ++r)
> -		if (paddr >= r->start && paddr < r->end)
> -			return r;
> -	return NULL;
> -}
> -
> -unsigned int mem_region_get_flags(phys_addr_t paddr)
> -{
> -	struct mem_region *r = mem_region_find(paddr);
> -	return r ? r->flags : MR_F_UNKNOWN;
> -}
> -
> -static void mem_regions_add_assumed(void)
> -{
> -	phys_addr_t code_end = (phys_addr_t)(unsigned long)&_etext;
> -	struct mem_region *r;
> -
> -	r = mem_region_find(code_end - 1);
> -	assert(r);
> +	struct mem_region *code, *data;
>  
>  	/* Split the region with the code into two regions; code and data */
> -	mem_region_add(&(struct mem_region){
> -		.start = code_end,
> -		.end = r->end,
> -	});
> -	*r = (struct mem_region){
> -		.start = r->start,
> -		.end = code_end,
> -		.flags = MR_F_CODE,
> -	};
> +	memregions_split((unsigned long)&_etext, &code, &data);
> +	assert(code);
> +	code->flags |= MR_F_CODE;
I think this would deserve to be split into several patches, esp. this
change in the implementation of

mem_regions_add_assumed and the init changes. At the moment this is pretty difficult to review

Eric

>  
>  	/*
>  	 * mach-virt I/O regions:
> @@ -183,10 +129,10 @@ static void mem_regions_add_assumed(void)
>  	 *   - 512M at 256G (arm64, arm uses highmem=off)
>  	 *   - 512G at 512G (arm64, arm uses highmem=off)
>  	 */
> -	mem_region_add(&(struct mem_region){ 0, (1ul << 30), MR_F_IO });
> +	memregions_add(&(struct mem_region){ 0, (1ul << 30), MR_F_IO });
>  #ifdef __aarch64__
> -	mem_region_add(&(struct mem_region){ (1ul << 38), (1ul << 38) | (1ul << 29), MR_F_IO });
> -	mem_region_add(&(struct mem_region){ (1ul << 39), (1ul << 40), MR_F_IO });
> +	memregions_add(&(struct mem_region){ (1ul << 38), (1ul << 38) | (1ul << 29), MR_F_IO });
> +	memregions_add(&(struct mem_region){ (1ul << 39), (1ul << 40), MR_F_IO });
>  #endif
>  }
>  
> @@ -197,7 +143,7 @@ static void mem_init(phys_addr_t freemem_start)
>  		.start = (phys_addr_t)-1,
>  	};
>  
> -	freemem = mem_region_find(freemem_start);
> +	freemem = memregions_find(freemem_start);
>  	assert(freemem && !(freemem->flags & (MR_F_IO | MR_F_CODE)));
>  
>  	for (r = mem_regions; r->end; ++r) {
> @@ -212,9 +158,9 @@ static void mem_init(phys_addr_t freemem_start)
>  	mem.end &= PHYS_MASK;
>  
>  	/* Check for holes */
> -	r = mem_region_find(mem.start);
> +	r = memregions_find(mem.start);
>  	while (r && r->end != mem.end)
> -		r = mem_region_find(r->end);
> +		r = memregions_find(r->end);
>  	assert(r);
>  
>  	/* Ensure our selected freemem range is somewhere in our full range */
> @@ -263,8 +209,9 @@ void setup(const void *fdt, phys_addr_t freemem_start)
>  		freemem += initrd_size;
>  	}
>  
> -	mem_regions_add_dt_regions();
> -	mem_regions_add_assumed();
> +	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
> +	memregions_add_dt_regions(MAX_DT_MEM_REGIONS);
> +	arm_memregions_add_assumed();
>  	mem_init(PAGE_ALIGN((unsigned long)freemem));
>  
>  	psci_set_conduit();
> @@ -371,7 +318,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>  				assert(edata <= r.end);
>  				r.flags = MR_F_CODE;
>  				r.end = data;
> -				mem_region_add(&r);
> +				memregions_add(&r);
>  				r.start = data;
>  				r.end = tmp;
>  				r.flags = 0;
> @@ -393,7 +340,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>  			if (r.end > __phys_end)
>  				__phys_end = r.end;
>  		}
> -		mem_region_add(&r);
> +		memregions_add(&r);
>  	}
>  	if (fdt) {
>  		/* Move the FDT to the base of free memory */
> @@ -439,6 +386,8 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>  
>  	exceptions_init();
>  
> +	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
> +
>  	status = efi_mem_init(efi_bootinfo);
>  	if (status != EFI_SUCCESS) {
>  		printf("Failed to initialize memory: ");
> diff --git a/lib/memregions.c b/lib/memregions.c
> new file mode 100644
> index 000000000000..96de86b27333
> --- /dev/null
> +++ b/lib/memregions.c
> @@ -0,0 +1,82 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <libcflat.h>
> +#include <devicetree.h>
> +#include <memregions.h>
> +
> +static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
> +static size_t nr_regions = NR_INITIAL_MEM_REGIONS;
> +
> +struct mem_region *mem_regions = __initial_mem_regions;
> +
> +void memregions_init(struct mem_region regions[], size_t nr)
> +{
> +	mem_regions = regions;
> +	nr_regions = nr;
> +}
> +
> +struct mem_region *memregions_add(struct mem_region *r)
> +{
> +	struct mem_region *r_next = mem_regions;
> +	int i = 0;
> +
> +	for (; r_next->end; ++r_next, ++i)
> +		;
> +	assert(i < nr_regions);
> +
> +	*r_next = *r;
> +
> +	return r_next;
> +}
> +
> +struct mem_region *memregions_find(phys_addr_t paddr)
> +{
> +	struct mem_region *r;
> +
> +	for (r = mem_regions; r->end; ++r)
> +		if (paddr >= r->start && paddr < r->end)
> +			return r;
> +	return NULL;
> +}
> +
> +uint32_t memregions_get_flags(phys_addr_t paddr)
> +{
> +	struct mem_region *r = memregions_find(paddr);
> +
> +	return r ? r->flags : MR_F_UNKNOWN;
> +}
> +
> +void memregions_split(phys_addr_t addr, struct mem_region **r1, struct mem_region **r2)
> +{
> +	*r1 = memregions_find(addr);
> +	assert(*r1);
> +
> +	if ((*r1)->start == addr) {
> +		*r2 = *r1;
> +		*r1 = NULL;
> +		return;
> +	}
> +
> +	*r2 = memregions_add(&(struct mem_region){
> +		.start = addr,
> +		.end = (*r1)->end,
> +		.flags = (*r1)->flags,
> +	});
> +
> +	(*r1)->end = addr;
> +}
> +
> +void memregions_add_dt_regions(size_t max_nr)
> +{
> +	struct dt_pbus_reg regs[max_nr];
> +	int nr_regs, i;
> +
> +	nr_regs = dt_get_memory_params(regs, max_nr);
> +	assert(nr_regs > 0);
> +
> +	for (i = 0; i < nr_regs; ++i) {
> +		memregions_add(&(struct mem_region){
> +			.start = regs[i].addr,
> +			.end = regs[i].addr + regs[i].size,
> +		});
> +	}
> +}
> diff --git a/lib/memregions.h b/lib/memregions.h
> new file mode 100644
> index 000000000000..9a8e33182fe5
> --- /dev/null
> +++ b/lib/memregions.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _MEMREGIONS_H_
> +#define _MEMREGIONS_H_
> +#include <libcflat.h>
> +#include <bitops.h>
> +
> +#define NR_INITIAL_MEM_REGIONS		8
> +
> +#define MR_F_IO				BIT(0)
> +#define MR_F_CODE			BIT(1)
> +#define MR_F_RESERVED			BIT(2)
> +#define MR_F_UNKNOWN			BIT(31)
> +
> +struct mem_region {
> +	phys_addr_t start;
> +	phys_addr_t end;
> +	uint32_t flags;
> +};
> +
> +extern struct mem_region *mem_regions;
> +
> +void memregions_init(struct mem_region regions[], size_t nr);
> +struct mem_region *memregions_add(struct mem_region *r);
> +struct mem_region *memregions_find(phys_addr_t paddr);
> +uint32_t memregions_get_flags(phys_addr_t paddr);
> +void memregions_split(phys_addr_t addr, struct mem_region **r1, struct mem_region **r2);
> +void memregions_add_dt_regions(size_t max_nr);
> +
> +#endif /* _MEMREGIONS_H_ */


