Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38A72A4A55
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 16:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgKCPth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 10:49:37 -0500
Received: from foss.arm.com ([217.140.110.172]:51050 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgKCPtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 10:49:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F39A2139F;
        Tue,  3 Nov 2020 07:49:34 -0800 (PST)
Received: from C02W217MHV2R.local (unknown [10.57.19.65])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C36F33F66E;
        Tue,  3 Nov 2020 07:49:33 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: Add support for configuring the
 translation granule
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, mark.rutland@arm.com, jade.alglave@arm.com,
        luc.maranget@inria.fr, andre.przywara@arm.com,
        alexandru.elisei@arm.com
References: <20201102113444.103536-1-nikos.nikoleris@arm.com>
 <20201102113444.103536-2-nikos.nikoleris@arm.com>
 <20201103130443.d7zt2zdzbg6hgq7c@kamzik.brq.redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <938dd93e-653b-492d-e8d9-d19fc54cb1f5@arm.com>
Date:   Tue, 3 Nov 2020 15:49:32 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103130443.d7zt2zdzbg6hgq7c@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/11/2020 13:04, Andrew Jones wrote:
> On Mon, Nov 02, 2020 at 11:34:43AM +0000, Nikos Nikoleris wrote:
>> Make the translation granule configurable for arm64. arm64 supports
>> page sizes of 4K, 16K and 64K. By default, arm64 is configured with
>> 64K pages. configure has been extended with a new argument:
>>
>>   --page-shift=(12|14|16)
> 
> --page-size=PAGE_SIZE
> 
>>
>> which allows the user to set the page shift and therefore the page
>> size for arm64.
> 
> which allows the user to set the page size for arm64.
> 
>> Using the --page-shift for any other architecture
> 
> --page-size
> 
>> results an error message.
>>
>> To allow for smaller page sizes and 42b VA, this change adds support
>> for 4-level and 3-level page tables. At compile time, we determine how
>> many levels in the page tables we needed.
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   configure                     | 26 +++++++++++++
>>   lib/arm/asm/page.h            |  4 ++
>>   lib/arm/asm/pgtable-hwdef.h   |  4 ++
>>   lib/arm/asm/pgtable.h         |  6 +++
>>   lib/arm/asm/thread_info.h     |  4 +-
>>   lib/arm64/asm/page.h          | 25 ++++++++++---
>>   lib/arm64/asm/pgtable-hwdef.h | 38 +++++++++++++------
>>   lib/arm64/asm/pgtable.h       | 69 +++++++++++++++++++++++++++++++++--
>>   lib/arm/mmu.c                 | 26 ++++++++-----
>>   arm/cstart64.S                | 10 ++++-
>>   10 files changed, 180 insertions(+), 32 deletions(-)
>>
>> diff --git a/configure b/configure
>> index 706aab5..9c6bb2c 100755
>> --- a/configure
>> +++ b/configure
>> @@ -25,6 +25,7 @@ vmm="qemu"
>>   errata_force=0
>>   erratatxt="$srcdir/errata.txt"
>>   host_key_document=
>> +page_size=
>>   
>>   usage() {
>>       cat <<-EOF
>> @@ -50,6 +51,8 @@ usage() {
>>   	    --host-key-document=HOST_KEY_DOCUMENT
>>   	                           Specify the machine-specific host-key document for creating
>>   	                           a PVM image with 'genprotimg' (s390x only)
>> +	    --page-size=PAGE_SIZE
>> +	                           Specify the page size (translation granule) (arm64 only)
>>   EOF
>>       exit 1
>>   }
>> @@ -105,6 +108,9 @@ while [[ "$1" = -* ]]; do
>>   	--host-key-document)
>>   	    host_key_document="$arg"
>>   	    ;;
>> +	--page-size)
>> +	    page_size="$arg"
>> +	    ;;
>>   	--help)
>>   	    usage
>>   	    ;;
>> @@ -123,6 +129,25 @@ arch_name=$arch
>>   [ "$arch" = "aarch64" ] && arch="arm64"
>>   [ "$arch_name" = "arm64" ] && arch_name="aarch64"
>>   
>> +if [ -z "$page_size" ]; then
>> +    [ "$arch" = "arm64" ] && page_size="65536"
>> +    [ "$arch" = "arm" ] && page_size="4096"
>> +else
>> +    if [ "$arch" != "arm64" ]; then
>> +        echo "--page-size is not supported for $arch"
>> +        usage
>> +    fi
>> +
>> +    if [ "${page_size: -1}" = "K" ] || [ "${page_size: -1}" = "k" ]; then
>> +        page_size=$[ ${page_size%?} * 1024 ]
> 
> $[...] is legacy syntax. Please use $((...))
> 
>> +    fi
>> +    if [ "$page_size" != "4096" ] && [ "$page_size" != "16384" ] &&
>> +           [ "$page_size" != "65536" ]; then
>> +        echo "arm64 doesn't support page size of $page_size"
>> +        usage
>> +    fi
>> +fi
>> +
>>   [ -z "$processor" ] && processor="$arch"
>>   
>>   if [ "$processor" = "arm64" ]; then
>> @@ -254,6 +279,7 @@ cat <<EOF >> lib/config.h
>>   
>>   #define CONFIG_UART_EARLY_BASE ${arm_uart_early_addr}
>>   #define CONFIG_ERRATA_FORCE ${errata_force}
>> +#define CONFIG_PAGE_SIZE ${page_size}
>>   
>>   EOF
>>   fi
>> diff --git a/lib/arm/asm/page.h b/lib/arm/asm/page.h
>> index 039c9f7..ae0ac2c 100644
>> --- a/lib/arm/asm/page.h
>> +++ b/lib/arm/asm/page.h
>> @@ -29,6 +29,10 @@ typedef struct { pteval_t pgprot; } pgprot_t;
>>   #define pgd_val(x)		((x).pgd)
>>   #define pgprot_val(x)		((x).pgprot)
>>   
>> +/* For compatibility with arm64 page tables */
>> +#define pud_t pgd_t
>> +#define pud_val(x) pgd_val(x)
>> +
>>   #define __pte(x)		((pte_t) { (x) } )
>>   #define __pmd(x)		((pmd_t) { (x) } )
>>   #define __pgd(x)		((pgd_t) { (x) } )
>> diff --git a/lib/arm/asm/pgtable-hwdef.h b/lib/arm/asm/pgtable-hwdef.h
>> index 4107e18..fe1d854 100644
>> --- a/lib/arm/asm/pgtable-hwdef.h
>> +++ b/lib/arm/asm/pgtable-hwdef.h
>> @@ -19,6 +19,10 @@
>>   #define PTRS_PER_PTE		512
>>   #define PTRS_PER_PMD		512
>>   
>> +/* For compatibility with arm64 page tables */
>> +#define PUD_SIZE		PGDIR_SIZE
>> +#define PUD_MASK		PGDIR_MASK
>> +
>>   #define PMD_SHIFT		21
>>   #define PMD_SIZE		(_AC(1,UL) << PMD_SHIFT)
>>   #define PMD_MASK		(~((1 << PMD_SHIFT) - 1))
>> diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
>> index 078dd16..4759d82 100644
>> --- a/lib/arm/asm/pgtable.h
>> +++ b/lib/arm/asm/pgtable.h
>> @@ -53,6 +53,12 @@ static inline pmd_t *pgd_page_vaddr(pgd_t pgd)
>>   	return pgtable_va(pgd_val(pgd) & PHYS_MASK & (s32)PAGE_MASK);
>>   }
>>   
>> +/* For compatibility with arm64 page tables */
>> +#define pud_valid(pud)		pgd_valid(pud)
>> +#define pud_offset(pgd, addr)  ((pud_t *)pgd)
>> +#define pud_free(pud)
>> +#define pud_alloc(pgd, addr)   pud_offset(pgd, addr)
> 
> Please watch the spaces vs. tabs. This comment applies to the
> whole patch. There are many places.
> 

Apologies, I will go through the patch and fix this.

>> +
>>   #define pmd_index(addr) \
>>   	(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
>>   #define pmd_offset(pgd, addr) \
>> diff --git a/lib/arm/asm/thread_info.h b/lib/arm/asm/thread_info.h
>> index 80ab395..eaa7258 100644
>> --- a/lib/arm/asm/thread_info.h
>> +++ b/lib/arm/asm/thread_info.h
>> @@ -14,10 +14,12 @@
>>   #define THREAD_SHIFT		PAGE_SHIFT
>>   #define THREAD_SIZE		PAGE_SIZE
>>   #define THREAD_MASK		PAGE_MASK
>> +#define THREAD_ALIGNMENT	PAGE_SIZE
>>   #else
>>   #define THREAD_SHIFT		MIN_THREAD_SHIFT
>>   #define THREAD_SIZE		(_AC(1,UL) << THREAD_SHIFT)
>>   #define THREAD_MASK		(~(THREAD_SIZE-1))
>> +#define THREAD_ALIGNMENT	THREAD_SIZE
>>   #endif
>>   
>>   #ifndef __ASSEMBLY__
>> @@ -38,7 +40,7 @@
>>   
>>   static inline void *thread_stack_alloc(void)
>>   {
>> -	void *sp = memalign(PAGE_SIZE, THREAD_SIZE);
>> +	void *sp = memalign(THREAD_ALIGNMENT, THREAD_SIZE);
>>   	return sp + THREAD_START_SP;
>>   }
>>   
>> diff --git a/lib/arm64/asm/page.h b/lib/arm64/asm/page.h
>> index 46af552..2a06207 100644
>> --- a/lib/arm64/asm/page.h
>> +++ b/lib/arm64/asm/page.h
>> @@ -10,38 +10,51 @@
>>    * This work is licensed under the terms of the GNU GPL, version 2.
>>    */
>>   
>> +#include <config.h>
>>   #include <linux/const.h>
>>   
>> -#define PGTABLE_LEVELS		2
>>   #define VA_BITS			42
> 
> Let's bump VA_BITS to 48 while we're at it.
> 
>>   
>> +#define PAGE_SIZE		CONFIG_PAGE_SIZE
> 
> I see now how we had '%d' in the other patch for PAGE_SIZE
> instead of %ld. To keep a UL like it is for arm and x86,
> then we can add the UL to CONFIG_PAGE_SIZE in configure.
> 

I realised the problem as soon as I reorderd the two changes. I have now 
added UL to CONFIG_PAGE_SIZE.

>> +#if PAGE_SIZE == 65536
>>   #define PAGE_SHIFT		16
>> -#define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
>> +#elif PAGE_SIZE == 16384
>> +#define PAGE_SHIFT		14
>> +#elif PAGE_SIZE == 4096
>> +#define PAGE_SHIFT		12

I've also reordered things a little in <libclat.h> so that I can use 
SZ_4K, SZ_16K and SZ_64K here too.

>> +#else
>> +#error Unsupported PAGE_SIZE
>> +#endif
>>   #define PAGE_MASK		(~(PAGE_SIZE-1))
>>   
>> +#define PGTABLE_LEVELS		(((VA_BITS) - 4) / (PAGE_SHIFT - 3))
> 
> Please replace the above define with
> 
> /*
>   * Since a page table descriptor is 8 bytes we have (PAGE_SHIFT - 3) bits
>   * of virtual address at each page table level. So, to get the number of
>   * page table levels needed, we round up the division of the number of
>   * address bits (VA_BITS - PAGE_SHIFT) by (PAGE_SHIFT - 3).
>   */
> #define PGTABLE_LEVELS \
> 	(((VA_BITS - PAGE_SHIFT) + ((PAGE_SHIFT - 3) - 1)) / (PAGE_SHIFT - 3))
> 
>> +
>>   #ifndef __ASSEMBLY__
>>   
>>   #define PAGE_ALIGN(addr)	ALIGN(addr, PAGE_SIZE)
>>   
>>   typedef u64 pteval_t;
>>   typedef u64 pmdval_t;
>> +typedef u64 pudval_t;
>>   typedef u64 pgdval_t;
>>   typedef struct { pteval_t pte; } pte_t;
>> +typedef struct { pmdval_t pmd; } pmd_t;
>> +typedef struct { pudval_t pud; } pud_t;
>>   typedef struct { pgdval_t pgd; } pgd_t;
>>   typedef struct { pteval_t pgprot; } pgprot_t;
>>   
>>   #define pte_val(x)		((x).pte)
>> +#define pmd_val(x)		((x).pmd)
>> +#define pud_val(x)		((x).pud)
>>   #define pgd_val(x)		((x).pgd)
>>   #define pgprot_val(x)		((x).pgprot)
>>   
>>   #define __pte(x)		((pte_t) { (x) } )
>> +#define __pmd(x)		((pmd_t) { (x) } )
>> +#define __pud(x)		((pud_t) { (x) } )
>>   #define __pgd(x)		((pgd_t) { (x) } )
>>   #define __pgprot(x)		((pgprot_t) { (x) } )
>>   
>> -typedef struct { pgd_t pgd; } pmd_t;
>> -#define pmd_val(x)		(pgd_val((x).pgd))
>> -#define __pmd(x)		((pmd_t) { __pgd(x) } )
>> -
>>   #define __va(x)			((void *)__phys_to_virt((phys_addr_t)(x)))
>>   #define __pa(x)			__virt_to_phys((unsigned long)(x))
>>   
>> diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
>> index 3352489..3b6b0d6 100644
>> --- a/lib/arm64/asm/pgtable-hwdef.h
>> +++ b/lib/arm64/asm/pgtable-hwdef.h
>> @@ -9,38 +9,54 @@
>>    * This work is licensed under the terms of the GNU GPL, version 2.
>>    */
>>   
>> +#include <asm/page.h>
>> +
>>   #define UL(x) _AC(x, UL)
>>   
>> +#define PGTABLE_LEVEL_SHIFT(n)	((PAGE_SHIFT - 3) * (4 - (n)) + 3)
> 
> Please replace the above define with
> 
> /*
>   * The number of bits a given page table level, n (where n=0 is the top),
>   * maps is ((max_n - n) - 1) * nr_bits_per_level + PAGE_SHIFT. Since a page
>   * table descriptor is 8 bytes we have (PAGE_SHIFT - 3) bits per level. We
>   * also have a maximum of 4 page table levels. Hence,
>   */
> #define PGTABLE_LEVEL_SHIFT(n) \
> 	(((4 - (n)) - 1) * (PAGE_SHIFT - 3) + PAGE_SHIFT)
> 
>>   #define PTRS_PER_PTE		(1 << (PAGE_SHIFT - 3))
>>   
>> +#if PGTABLE_LEVELS > 2
>> +#define PMD_SHIFT		PGTABLE_LEVEL_SHIFT(2)
>> +#define PTRS_PER_PMD		PTRS_PER_PTE
>> +#define PMD_SIZE		(UL(1) << PMD_SHIFT)
>> +#define PMD_MASK		(~(PMD_SIZE-1))
>> +#endif
>> +
>> +#if PGTABLE_LEVELS > 3
>> +#define PUD_SHIFT		PGTABLE_LEVEL_SHIFT(1)
>> +#define PTRS_PER_PUD		PTRS_PER_PTE
>> +#define PUD_SIZE		(UL(1) << PUD_SHIFT)
>> +#define PUD_MASK		(~(PUD_SIZE-1))
>> +#else
>> +#define PUD_SIZE                PGDIR_SIZE
>> +#define PUD_MASK                PGDIR_MASK
>> +#endif
>> +
>> +#define PUD_VALID		(_AT(pudval_t, 1) << 0)
>> +
>>   /*
>>    * PGDIR_SHIFT determines the size a top-level page table entry can map
>>    * (depending on the configuration, this level can be 0, 1 or 2).
>>    */
>> -#define PGDIR_SHIFT		((PAGE_SHIFT - 3) * PGTABLE_LEVELS + 3)
>> +#define PGDIR_SHIFT		PGTABLE_LEVEL_SHIFT(4 - PGTABLE_LEVELS)
>>   #define PGDIR_SIZE		(_AC(1, UL) << PGDIR_SHIFT)
>>   #define PGDIR_MASK		(~(PGDIR_SIZE-1))
>>   #define PTRS_PER_PGD		(1 << (VA_BITS - PGDIR_SHIFT))
>>   
>>   #define PGD_VALID		(_AT(pgdval_t, 1) << 0)
>>   
>> -/* From include/asm-generic/pgtable-nopmd.h */
>> -#define PMD_SHIFT		PGDIR_SHIFT
>> -#define PTRS_PER_PMD		1
>> -#define PMD_SIZE		(UL(1) << PMD_SHIFT)
>> -#define PMD_MASK		(~(PMD_SIZE-1))
>> -
>>   /*
>>    * Section address mask and size definitions.
>>    */
>> -#define SECTION_SHIFT		PMD_SHIFT
>> -#define SECTION_SIZE		(_AC(1, UL) << SECTION_SHIFT)
>> -#define SECTION_MASK		(~(SECTION_SIZE-1))
>> +#define SECTION_SHIFT          PMD_SHIFT
>> +#define SECTION_SIZE           (_AC(1, UL) << SECTION_SHIFT)
>> +#define SECTION_MASK           (~(SECTION_SIZE-1))
>>   
>>   /*
>>    * Hardware page table definitions.
>>    *
>> - * Level 1 descriptor (PMD).
>> + * Level 0,1,2 descriptor (PGD, PUD and PMD).
>>    */
>>   #define PMD_TYPE_MASK		(_AT(pmdval_t, 3) << 0)
>>   #define PMD_TYPE_FAULT		(_AT(pmdval_t, 0) << 0)
>> diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
>> index e577d9c..c7632ae 100644
>> --- a/lib/arm64/asm/pgtable.h
>> +++ b/lib/arm64/asm/pgtable.h
>> @@ -30,10 +30,12 @@
>>   #define pgtable_pa(x)		((unsigned long)(x))
>>   
>>   #define pgd_none(pgd)		(!pgd_val(pgd))
>> +#define pud_none(pud)		(!pud_val(pud))
>>   #define pmd_none(pmd)		(!pmd_val(pmd))
>>   #define pte_none(pte)		(!pte_val(pte))
>>   
>>   #define pgd_valid(pgd)		(pgd_val(pgd) & PGD_VALID)
>> +#define pud_valid(pud)		(pud_val(pud) & PUD_VALID)
>>   #define pmd_valid(pmd)		(pmd_val(pmd) & PMD_SECT_VALID)
>>   #define pte_valid(pte)		(pte_val(pte) & PTE_VALID)
>>   
>> @@ -52,15 +54,76 @@ static inline pgd_t *pgd_alloc(void)
>>   	return pgd;
>>   }
>>   
>> -#define pmd_offset(pgd, addr)	((pmd_t *)pgd)
>> -#define pmd_free(pmd)
>> -#define pmd_alloc(pgd, addr)	pmd_offset(pgd, addr)
>> +static inline pud_t *pgd_page_vaddr(pgd_t pgd)
>> +{
>> +	return pgtable_va(pgd_val(pgd) & PHYS_MASK & (s32)PAGE_MASK);
>> +}
>> +
>> +static inline pmd_t *pud_page_vaddr(pud_t pud)
>> +{
>> +	return pgtable_va(pud_val(pud) & PHYS_MASK & (s32)PAGE_MASK);
>> +}
>> +
>>   
>>   static inline pte_t *pmd_page_vaddr(pmd_t pmd)
>>   {
>>   	return pgtable_va(pmd_val(pmd) & PHYS_MASK & (s32)PAGE_MASK);
>>   }
>>   
>> +#if PGTABLE_LEVELS > 2
>> +#define pmd_index(addr)					\
>> +	(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
>> +#define pmd_offset(pud, addr)				\
>> +	(pud_page_vaddr(*(pud)) + pmd_index(addr))
>> +#define pmd_free(pmd) free_page(pmd)
>> +static inline pmd_t *pmd_alloc_one(void)
>> +{
>> +	assert(PTRS_PER_PMD * sizeof(pmd_t) == PAGE_SIZE);
>> +	pmd_t *pmd = alloc_page();
>> +	return pmd;
>> +}
>> +static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
>> +{
>> +        if (pud_none(*pud)) {
>> +		pud_t entry;
>> +		pud_val(entry) = pgtable_pa(pmd_alloc_one()) | PMD_TYPE_TABLE;
>> +		WRITE_ONCE(*pud, entry);
>> +	}
>> +	return pmd_offset(pud, addr);
>> +}
>> +#else
>> +#define pmd_offset(pud, addr)  ((pmd_t *)pud)
>> +#define pmd_free(pmd)
>> +#define pmd_alloc(pud, addr)   pmd_offset(pud, addr)
>> +#endif
>> +
>> +#if PGTABLE_LEVELS > 3
>> +#define pud_index(addr)                                 \
>> +	(((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
>> +#define pud_offset(pgd, addr)                           \
>> +	(pgd_page_vaddr(*(pgd)) + pud_index(addr))
>> +#define pud_free(pud) free_page(pud)
>> +static inline pud_t *pud_alloc_one(void)
>> +{
>> +	assert(PTRS_PER_PMD * sizeof(pud_t) == PAGE_SIZE);
> 
> PTRS_PER_PUD
> 
>> +	pud_t *pud = alloc_page();
>> +	return pud;
>> +}
>> +static inline pud_t *pud_alloc(pgd_t *pgd, unsigned long addr)
>> +{
>> +	if (pgd_none(*pgd)) {
>> +		pgd_t entry;
>> +		pgd_val(entry) = pgtable_pa(pud_alloc_one()) | PMD_TYPE_TABLE;
>> +		WRITE_ONCE(*pgd, entry);
>> +	}
>> +	return pud_offset(pgd, addr);
>> +}
>> +#else
>> +#define pud_offset(pgd, addr)  ((pud_t *)pgd)
>> +#define pud_free(pud)
>> +#define pud_alloc(pgd, addr)   pud_offset(pgd, addr)
>> +#endif
>> +
>>   #define pte_index(addr) \
>>   	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
>>   #define pte_offset(pmd, addr) \
>> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
>> index 540a1e8..6d1c75b 100644
>> --- a/lib/arm/mmu.c
>> +++ b/lib/arm/mmu.c
>> @@ -81,7 +81,8 @@ void mmu_disable(void)
>>   static pteval_t *get_pte(pgd_t *pgtable, uintptr_t vaddr)
>>   {
>>   	pgd_t *pgd = pgd_offset(pgtable, vaddr);
>> -	pmd_t *pmd = pmd_alloc(pgd, vaddr);
>> +	pud_t *pud = pud_alloc(pgd, vaddr);
>> +	pmd_t *pmd = pmd_alloc(pud, vaddr);
>>   	pte_t *pte = pte_alloc(pmd, vaddr);
>>   
>>   	return &pte_val(*pte);
>> @@ -133,18 +134,20 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>>   			phys_addr_t phys_start, phys_addr_t phys_end,
>>   			pgprot_t prot)
>>   {
>> -	phys_addr_t paddr = phys_start & PGDIR_MASK;
>> -	uintptr_t vaddr = virt_offset & PGDIR_MASK;
>> +	phys_addr_t paddr = phys_start & PUD_MASK;
>> +	uintptr_t vaddr = virt_offset & PUD_MASK;
>>   	uintptr_t virt_end = phys_end - paddr + vaddr;
>>   	pgd_t *pgd;
>> -	pgd_t entry;
>> +	pud_t *pud;
>> +	pud_t entry;
>>   
>> -	for (; vaddr < virt_end; vaddr += PGDIR_SIZE, paddr += PGDIR_SIZE) {
>> -		pgd_val(entry) = paddr;
>> -		pgd_val(entry) |= PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
>> -		pgd_val(entry) |= pgprot_val(prot);
>> +	for (; vaddr < virt_end; vaddr += PUD_SIZE, paddr += PUD_SIZE) {
>> +		pud_val(entry) = paddr;
>> +		pud_val(entry) |= PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
>> +		pud_val(entry) |= pgprot_val(prot);
>>   		pgd = pgd_offset(pgtable, vaddr);
>> -		WRITE_ONCE(*pgd, entry);
>> +		pud = pud_alloc(pgd, vaddr);
>> +		WRITE_ONCE(*pud, entry);
>>   		flush_tlb_page(vaddr);
>>   	}
>>   }
>> @@ -207,6 +210,7 @@ unsigned long __phys_to_virt(phys_addr_t addr)
>>   void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
>>   {
>>   	pgd_t *pgd;
>> +	pud_t *pud;
>>   	pmd_t *pmd;
>>   	pte_t *pte;
>>   
>> @@ -215,7 +219,9 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
>>   
>>   	pgd = pgd_offset(pgtable, vaddr);
>>   	assert(pgd_valid(*pgd));
>> -	pmd = pmd_offset(pgd, vaddr);
>> +	pud = pud_offset(pgd, vaddr);
>> +	assert(pud_valid(*pud));
>> +	pmd = pmd_offset(pud, vaddr);
>>   	assert(pmd_valid(*pmd));
>>   
>>   	if (pmd_huge(*pmd)) {
>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>> index ffdd49f..cedc678 100644
>> --- a/arm/cstart64.S
>> +++ b/arm/cstart64.S
>> @@ -157,6 +157,14 @@ halt:
>>    */
>>   #define MAIR(attr, mt) ((attr) << ((mt) * 8))
>>   
>> +#if PAGE_SIZE == 65536
>> +#define TCR_TG_FLAGS	TCR_TG0_64K | TCR_TG1_64K
>> +#elif PAGE_SIZE == 16384
>> +#define TCR_TG_FLAGS	TCR_TG0_16K | TCR_TG1_16K
>> +#elif PAGE_SIZE == 4096
>> +#define TCR_TG_FLAGS	TCR_TG0_4K | TCR_TG1_4K
>> +#endif
>> +
>>   .globl asm_mmu_enable
>>   asm_mmu_enable:
>>   	tlbi	vmalle1			// invalidate I + D TLBs
>> @@ -164,7 +172,7 @@ asm_mmu_enable:
>>   
>>   	/* TCR */
>>   	ldr	x1, =TCR_TxSZ(VA_BITS) |		\
>> -		     TCR_TG0_64K | TCR_TG1_64K |	\
>> +		     TCR_TG_FLAGS  |			\
>>   		     TCR_IRGN_WBWA | TCR_ORGN_WBWA |	\
>>   		     TCR_SHARED
>>   	mrs	x2, id_aa64mmfr0_el1
>> -- 
>> 2.17.1
>>
> 
> Testing results looked pretty good. Everywhere I tried (TCG, seattle,
> mustang, thunderx) the 4K and 64K pages worked. Most places the 16K
> pages were rejected. The thunderx allowed them, but then the tests
> hung. I checked what was going on with the QEMU monitor. While writing
> the page tables it got an exception. I have a feeling that's a host
> problem rather than a problem with this patch though.
> 

I've also tested 4K and 64K (TCG, ThunderX2, N1 SDP). When I configured 
16K pages, I hit the assertion in all 3 cases.

Thanks for the review! I will post an update soon.

Thanks,

Nikos

> Thanks,
> drew
> 
