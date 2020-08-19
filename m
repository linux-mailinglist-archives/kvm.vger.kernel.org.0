Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690BF24A376
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 17:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgHSPpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 11:45:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23760 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726632AbgHSPpG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 11:45:06 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JFWqRp146772
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 11:45:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=uPT/h6BTn2IBQQWxFRRZff/g5AcwgB+0SbW1rRlHLRY=;
 b=JfEVCtoNwhr0BU88I7mYjIsCpSAdNfgJmkmzKmwoFBhg5bt60hpyj+h5ACSHDc8kXAuY
 IJXtvqdk8KJ2i+FRIIqYg79jrM/k6fGQD5gd8/N0EOrFGHwFj/xhckQs+NMJVZuUiJto
 uvTTO/9oldOlmwO1+AjyEGJX89QO6WHqfNlq7Xf6BI763nsJTtn3WUDHusGfEFS845Ka
 je2hMzVD57wejtmpIFDTQbi+sCX5eR+fXAQxiZ6yc++SB4cf5lix5UrcRbVBMVBtP94C
 G4hjkcPI/IIqyTGM5tvMg6YjY59Ek7J/Sk+X2lLX2z/DPPPVgHkgfuMRB9qtuCZ7qhoh dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3314mvnkrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 11:45:01 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07JFYTk6153348
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 11:45:01 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3314mvnkqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 11:45:01 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07JFa7ME029920;
        Wed, 19 Aug 2020 15:44:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3304tr98g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 15:44:59 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07JFiuTW30867770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 15:44:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C166152057;
        Wed, 19 Aug 2020 15:44:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.70.234])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5F11752051;
        Wed, 19 Aug 2020 15:44:56 +0000 (GMT)
Subject: Re: [kvm-unit-tests RFC v1 2/5] lib/alloc_page: complete rewrite of
 the page allocator
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com
References: <20200814151009.55845-1-imbrenda@linux.ibm.com>
 <20200814151009.55845-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <36c26d8c-dadf-94fa-92c3-31d808558b33@linux.ibm.com>
Date:   Wed, 19 Aug 2020 17:44:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200814151009.55845-3-imbrenda@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZC9Z0BUQ716nPtxwL5CN9z7dUcMZdGlEV"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_08:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 suspectscore=2 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZC9Z0BUQ716nPtxwL5CN9z7dUcMZdGlEV
Content-Type: multipart/mixed; boundary="hXm1tC1061nleQpRkRypXmVC1qSJVQG2i"

--hXm1tC1061nleQpRkRypXmVC1qSJVQG2i
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/14/20 5:10 PM, Claudio Imbrenda wrote:
> This is a complete rewrite of the page allocator.
>=20
> This will bring a few improvements:
> * no need to specify the size when freeing
> * allocate small areas with a large alignment without wasting memory
> * ability to initialize and use multiple memory areas (e.g. DMA)
> * more sanity checks
>=20
> A few things have changed:
> * initialization cannot be done with free_pages like before,
>   page_alloc_init_area has to be used instead
>=20
> Arch-specific changes:
> * arm and x86 have been adapted to put all the memory in just one big
>   area (or two, for x86_64 with highmem).
> * s390x instead creates one area below 2GiB and one above; the area
>   below 2GiB is used for SMP lowcore initialization.
>=20
> Details:
> Each memory area has metadata at the very beginning. The metadata is a
> byte array with one entry per usable page (so, excluding the metadata
> itself). Each entry indicates if the page is special (unused for now),
> if it is allocated, and the order of the block. Both free and allocated=

> pages are part of larger blocks.
>=20
> Some more fixed size metadata is present in a fixed-size static array.
> This metadata contains start and end page frame numbers, the pointer to=

> the metadata array, and the array of freelists. The array of freelists
> has an entry for each possible order (indicated by the macro NLISTS,
> defined as BITS_PER_LONG - PAGE_SHIFT).
>=20
> On allocation, if the free list for the needed size is empty, larger
> blocks are split. When a small allocation with a large alignment is
> requested, an appropriately large block is split, to guarantee the
> alignment.
>=20
> When a block is freed, an attempt will be made to merge it into the
> neighbour, iterating the process as long as possible.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

I'm not sure if it's possible without too much work, but splitting this
would make my brain hurt less upon reading. I'll try continuing review
tomorrow being wide awake for review is preferable for this patch.

Some comments below:

> ---
>  lib/alloc_page.h |  64 ++++++-
>  lib/alloc_page.c | 451 ++++++++++++++++++++++++++++++++++++-----------=

>  lib/arm/setup.c  |   2 +-
>  lib/s390x/sclp.c |  11 +-
>  lib/s390x/smp.c  |   2 +-
>  lib/vmalloc.c    |  13 +-
>  6 files changed, 427 insertions(+), 116 deletions(-)
>=20
> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> index 88540d1..6472abd 100644
> --- a/lib/alloc_page.h
> +++ b/lib/alloc_page.h
[..]
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index 74fe726..7c91f91 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -13,165 +13,410 @@
>  #include <asm/io.h>
>  #include <asm/spinlock.h>
> =20
> +#define IS_ALIGNED_ORDER(x,order) IS_ALIGNED((x),BIT_ULL(order))
> +#define NLISTS ((BITS_PER_LONG) - (PAGE_SHIFT))
> +#define PFN(x) ((uintptr_t)(x) >> PAGE_SHIFT)

So, more or less virt_to_pfn but with uintptr_t rather than unsigned long=
?

> +
> +#define MAX_AREAS	4
> +
> +#define ORDER_MASK	0x3f
> +#define ALLOC_MASK	0x40
> +
> +struct free_list {
> +	struct free_list *prev;
> +	struct free_list *next;
> +};
> +
> +struct mem_area {
> +	/* Physical frame number of the first usable frame in the area */
> +	uintptr_t base;
> +	/* Physical frame number of the first frame outside the area */
> +	uintptr_t top;
> +	/* Combination ALLOC_MASK and order */
> +	u8 *page_states;
> +	/* One freelist for each possible block size, up to NLISTS */
> +	struct free_list freelists[NLISTS];
> +};
> +
> +static struct mem_area areas[MAX_AREAS];
> +static unsigned int areas_mask;
>  static struct spinlock lock;
> -static void *freelist =3D 0;
> =20
>  bool page_alloc_initialized(void)
>  {
> -	return freelist !=3D 0;
> +	return areas_mask !=3D 0;
>  }
> =20
> -void free_pages(void *mem, size_t size)
> +static inline bool area_overlaps(struct mem_area *a, uintptr_t pfn)
>  {
> -	void *old_freelist;
> -	void *end;
> +	return (pfn >=3D PFN(a->page_states)) && (pfn < a->top);
> +}

I have pondered over this function for quite a while now and I don't
think the naming is correct.

This is basically the contains function below, but including the page
states which are at the beginning of the area but will never be shown to
users, right?

> =20
> -	assert_msg((unsigned long) mem % PAGE_SIZE =3D=3D 0,
> -		   "mem not page aligned: %p", mem);
> +static inline bool area_contains(struct mem_area *a, uintptr_t pfn)
> +{
> +	return (pfn >=3D a->base) && (pfn < a->top);
> +}
> =20
> -	assert_msg(size % PAGE_SIZE =3D=3D 0, "size not page aligned: %#zx", =
size);
> +static inline bool is_list_empty(struct free_list *p)
> +{
> +	return !p->next || !p->prev || p =3D=3D p->next || p =3D=3D p->prev;
> +}
> =20
> -	assert_msg(size =3D=3D 0 || (uintptr_t)mem =3D=3D -size ||
> -		   (uintptr_t)mem + size > (uintptr_t)mem,
> -		   "mem + size overflow: %p + %#zx", mem, size);
> +static struct free_list *list_remove(struct free_list *l)
> +{
> +	if (is_list_empty(l))
> +		return NULL;
> =20
> -	if (size =3D=3D 0) {
> -		freelist =3D NULL;
> -		return;
> -	}
> +	l->prev->next =3D l->next;
> +	l->next->prev =3D l->prev;
> +	l->prev =3D l->next =3D NULL;
> =20
> -	spin_lock(&lock);
> -	old_freelist =3D freelist;
> -	freelist =3D mem;
> -	end =3D mem + size;
> -	while (mem + PAGE_SIZE !=3D end) {
> -		*(void **)mem =3D (mem + PAGE_SIZE);
> -		mem +=3D PAGE_SIZE;
> -	}
> +	return l;
> +}
> =20
> -	*(void **)mem =3D old_freelist;
> -	spin_unlock(&lock);
> +static void list_add(struct free_list *head, struct free_list *li)
> +{
> +	assert(li);
> +	assert(head);
> +	li->prev =3D head;
> +	li->next =3D head->next;
> +	head->next->prev =3D li;
> +	head->next =3D li;
>  }

lib/lists.(c|h) or maybe util.c

I guess it's only a matter of time until we have a fully preempt testing
kernel...

> =20
> -void free_pages_by_order(void *mem, unsigned int order)
> +/*
> + * Splits the free block starting at addr into 2 blocks of half the si=
ze.
> + *
> + * The function depends on the following assumptions:
> + * - The allocator must have been initialized
> + * - the block must be within the memory area
> + * - all pages in the block must be free and not special
> + * - the pointer must point to the start of the block
> + * - all pages in the block must have the same block size.
> + * - the block size must be greater than 0
> + * - the block size must be smaller than the maximum allowed
> + * - the block must be in a free list
> + * - the function is called with the lock held
> + */
> +static void split(struct mem_area *a, void *addr)
>  {
> -	free_pages(mem, 1ul << (order + PAGE_SHIFT));
> +	uintptr_t pfn =3D PFN(addr);
> +	struct free_list *p;
> +	uintptr_t i, idx;
> +	u8 order;
> +
> +	assert(a && area_contains(a, pfn));
> +	idx =3D pfn - a->base;
> +	order =3D a->page_states[idx];
> +	assert(!(order & ~ORDER_MASK) && order && (order < NLISTS));
> +	assert(IS_ALIGNED_ORDER(pfn, order));
> +	assert(area_contains(a, pfn + BIT(order) - 1));
> +
> +	/* Remove the block from its free list */
> +	p =3D list_remove(addr);
> +	assert(p);
> +
> +	/* update the block size for each page in the block */
> +	for (i =3D 0; i < BIT(order); i++) {
> +		assert(a->page_states[idx + i] =3D=3D order);
> +		a->page_states[idx + i] =3D order - 1;
> +	}
> +	order--;
> +	/* add the first half block to the appropriate free list */
> +	list_add(a->freelists + order, p);
> +	/* add the second half block to the appropriate free list */
> +	list_add(a->freelists + order, (void *)((pfn + BIT(order)) * PAGE_SIZ=
E));
>  }
> =20
> -void *alloc_page()
> +/*
> + * Returns a block whose alignment and size are at least the parameter=
 values.
> + * If there is not enough free memory, NULL is returned.
> + *
> + * Both parameters must be not larger than the largest allowed order
> + */
> +static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz)
>  {
> -	void *p;
> +	struct free_list *p, *res =3D NULL;
> +	u8 order;
> =20
> -	if (!freelist)
> -		return 0;
> +	assert((al < NLISTS) && (sz < NLISTS));
> +	/* we need the bigger of the two as starting point */
> +	order =3D sz > al ? sz : al;
> =20
> -	spin_lock(&lock);
> -	p =3D freelist;
> -	freelist =3D *(void **)freelist;
> -	spin_unlock(&lock);
> +	/* search all free lists for some memory */
> +	for ( ; order < NLISTS; order++) {
> +		p =3D a->freelists[order].next;
> +		if (!is_list_empty(p))
> +			break;
> +	}
> +	/* out of memory */
> +	if (order >=3D NLISTS)
> +		return NULL;
> +
> +	/*
> +	 * the block is bigger than what we need because either there were
> +	 * no smaller blocks, or the smaller blocks were not aligned to our
> +	 * needs; therefore we split the block until we reach the needed size=

> +	 */
> +	for (; order > sz; order--)
> +		split(a, p);
> =20
> -	if (p)
> -		memset(p, 0, PAGE_SIZE);
> -	return p;
> +	res =3D list_remove(p);
> +	memset(a->page_states + (PFN(res) - a->base), ALLOC_MASK | order, BIT=
(order));
> +	return res;
>  }
> =20
>  /*
> - * Allocates (1 << order) physically contiguous and naturally aligned =
pages.
> - * Returns NULL if there's no memory left.
> + * Try to merge two blocks into a bigger one.
> + * Returns true in case of a successful merge.
> + * Merging will succeed only if both blocks have the same block size a=
nd are
> + * both free.
> + *
> + * The function depends on the following assumptions:
> + * - the first parameter is strictly smaller than the second
> + * - the parameters must point each to the start of their block
> + * - the two parameters point to adjacent blocks
> + * - the two blocks are both in a free list
> + * - all of the pages of the two blocks must be free
> + * - all of the pages of the two blocks must have the same block size
> + * - the function is called with the lock held
>   */
> -void *alloc_pages(unsigned int order)
> +static bool coalesce(struct mem_area *a, u8 order, uintptr_t pfn, uint=
ptr_t pfn2)
>  {
> -	/* Generic list traversal. */
> -	void *prev;
> -	void *curr =3D NULL;
> -	void *next =3D freelist;
> +	uintptr_t first, second, i;
> +	struct free_list *li;
> =20
> -	/* Looking for a run of length (1 << order). */
> -	unsigned long run =3D 0;
> -	const unsigned long n =3D 1ul << order;
> -	const unsigned long align_mask =3D (n << PAGE_SHIFT) - 1;
> -	void *run_start =3D NULL;
> -	void *run_prev =3D NULL;
> -	unsigned long run_next_pa =3D 0;
> -	unsigned long pa;
> +	assert(IS_ALIGNED_ORDER(pfn, order) && IS_ALIGNED_ORDER(pfn2, order))=
;
> +	assert(pfn2 =3D=3D pfn + BIT(order));
> +	assert(a);
> =20
> -	assert(order < sizeof(unsigned long) * 8);
> +	if (!area_contains(a, pfn) || !area_contains(a, pfn2 + BIT(order) - 1=
))
> +		return false;
> +	first =3D pfn - a->base;
> +	second =3D pfn2 - a->base;
> +	if ((a->page_states[first] !=3D order) || (a->page_states[second] !=3D=
 order))
> +		return false;
> =20
> -	spin_lock(&lock);
> -	for (;;) {
> -		prev =3D curr;
> -		curr =3D next;
> +	li =3D list_remove((void *)(pfn2 << PAGE_SHIFT));
> +	assert(li);
> +	li =3D list_remove((void *)(pfn << PAGE_SHIFT));
> +	assert(li);
> +	for (i =3D 0; i < (2ull << order); i++) {
> +		assert(a->page_states[first + i] =3D=3D order);
> +		a->page_states[first + i] =3D order + 1;
> +	}
> +	list_add(a->freelists + order + 1, li);
> +	return true;
> +}
> =20
> -		if (!curr) {
> -			run_start =3D NULL;
> -			break;
> -		}
> +/*
> + * Free a block of memory.
> + * The parameter can be NULL, in which case nothing happens.
> + *
> + * The function depends on the following assumptions:
> + * - the parameter is page aligned
> + * - the parameter belongs to an existing memory area
> + * - the parameter points to the beginning of the block
> + * - the size of the block is less than the maximum allowed
> + * - the block is completely contained in its memory area
> + * - all pages in the block have the same block size
> + * - no pages in the memory block were already free
> + * - no pages in the memory block are special
> + */
> +static void _free_pages(void *mem)
> +{
> +	uintptr_t pfn2, pfn =3D PFN(mem);
> +	struct mem_area *a =3D NULL;
> +	uintptr_t i, p;
> +	u8 order;
> =20
> -		next =3D *((void **) curr);
> -		pa =3D virt_to_phys(curr);
> -
> -		if (run =3D=3D 0) {
> -			if (!(pa & align_mask)) {
> -				run_start =3D curr;
> -				run_prev =3D prev;
> -				run_next_pa =3D pa + PAGE_SIZE;
> -				run =3D 1;
> -			}
> -		} else if (pa =3D=3D run_next_pa) {
> -			run_next_pa +=3D PAGE_SIZE;
> -			run +=3D 1;
> -		} else {
> -			run =3D 0;
> -		}
> +	if (!mem)
> +		return;
> +	assert(IS_ALIGNED((uintptr_t)mem, PAGE_SIZE));
> +	for (i =3D 0; !a && (i < MAX_AREAS); i++) {
> +		if ((areas_mask & BIT(i)) && area_contains(areas + i, pfn))
> +			a =3D areas + i;
> +	}
> +	assert_msg(a, "memory does not belong to any area: %p", mem);
> =20
> -		if (run =3D=3D n) {
> -			if (run_prev)
> -				*((void **) run_prev) =3D next;
> -			else
> -				freelist =3D next;
> -			break;
> -		}
> +	p =3D pfn - a->base;
> +	order =3D a->page_states[p] & ORDER_MASK;
> +
> +	assert(a->page_states[p] =3D=3D (order | ALLOC_MASK));
> +	assert(order < NLISTS);
> +	assert(IS_ALIGNED_ORDER(pfn, order));
> +	assert(area_contains(a, pfn + BIT(order) - 1));
> +
> +	for (i =3D 0; i < BIT(order); i++) {
> +		assert(a->page_states[p + i] =3D=3D (ALLOC_MASK | order));
> +		a->page_states[p + i] &=3D ~ALLOC_MASK;
>  	}
> -	spin_unlock(&lock);
> -	if (run_start)
> -		memset(run_start, 0, n * PAGE_SIZE);
> -	return run_start;
> +	list_add(a->freelists + order, mem);
> +	do {
> +		order =3D a->page_states[p] & ORDER_MASK;
> +		if (!IS_ALIGNED_ORDER(pfn, order + 1))
> +			pfn =3D pfn - BIT(order);
> +		pfn2 =3D pfn + BIT(order);
> +	} while (coalesce(a, order, pfn, pfn2));
>  }
> =20
> +void free_pages(void *mem, size_t size)
> +{
> +	spin_lock(&lock);
> +	_free_pages(mem);
> +	spin_unlock(&lock);
> +}
> =20
> -void free_page(void *page)
> +static void *page_memalign_order_area(unsigned area, u8 ord, u8 al)
>  {
> +	void *res =3D NULL;
> +	int i;
> +
>  	spin_lock(&lock);
> -	*(void **)page =3D freelist;
> -	freelist =3D page;
> +	area &=3D areas_mask;
> +	for (i =3D 0; !res && (i < MAX_AREAS); i++)
> +		if (area & BIT(i))
> +			res =3D page_memalign_order(areas + i, ord, al);
>  	spin_unlock(&lock);
> +	return res;
>  }
> =20
> -static void *page_memalign(size_t alignment, size_t size)
> +/*
> + * Allocates (1 << order) physically contiguous and naturally aligned =
pages.
> + * Returns NULL if the allocation was not possible.
> + */
> +void *alloc_pages_area(unsigned int area, unsigned int order)
>  {
> -	unsigned long n =3D ALIGN(size, PAGE_SIZE) >> PAGE_SHIFT;
> -	unsigned int order;
> +	return page_memalign_order_area(area, order, order);
> +}
> =20
> -	if (!size)
> -		return NULL;
> +void *alloc_pages(unsigned int order)
> +{
> +	return alloc_pages_area(~0, order);
> +}
> =20
> -	order =3D get_order(n);
> +/*
> + * Allocates (1 << order) physically contiguous aligned pages.
> + * Returns NULL if the allocation was not possible.
> + */
> +void *memalign_pages_area(unsigned int area, size_t alignment, size_t =
size)
> +{
> +	assert(is_power_of_2(alignment));
> +	alignment =3D get_order(PAGE_ALIGN(alignment) >> PAGE_SHIFT);
> +	size =3D get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
> +	assert(alignment < NLISTS);
> +	assert(size < NLISTS);
> +	return page_memalign_order_area(area, size, alignment);
> +}
> =20
> -	return alloc_pages(order);
> +void *memalign_pages(size_t alignment, size_t size)
> +{
> +	return memalign_pages_area(~0, alignment, size);
>  }
> =20
> -static void page_free(void *mem, size_t size)
> +/*
> + * Allocates one page
> + */
> +void *alloc_page()
>  {
> -	free_pages(mem, size);
> +	return alloc_pages(0);
>  }
> =20
>  static struct alloc_ops page_alloc_ops =3D {
> -	.memalign =3D page_memalign,
> -	.free =3D page_free,
> +	.memalign =3D memalign_pages,
> +	.free =3D free_pages,
>  	.align_min =3D PAGE_SIZE,
>  };
> =20
> +/*
> + * Enables the page allocator.
> + *
> + * Prerequisites:
> + * - at least one memory area has been initialized
> + */
>  void page_alloc_ops_enable(void)
>  {
> +	spin_lock(&lock);
> +	assert(page_alloc_initialized());
>  	alloc_ops =3D &page_alloc_ops;
> +	spin_unlock(&lock);
> +}
> +
> +/*
> + * Adds a new memory area to the pool of available memory.
> + *
> + * Prerequisites:
> + * - the lock is held
> + * - start and top are page frame numbers

Calling them pfn_start and pfn_top would make that clearer.
Maybe add a list of the input parameters and their contents?

> + * - start is smaller than top
> + * - top does not fall outside of addressable memory
> + * - there is at least one more slot free for memory areas
> + * - if a specific memory area number has been indicated, it needs to =
be free
> + * - the memory area to add does not overlap with existing areas
> + * - the memory area to add has at least 5 pages available
> + */
> +static void _page_alloc_init_area(int n, uintptr_t start, uintptr_t to=
p)
> +{
> +	size_t table_size, npages, i;
> +	struct mem_area *a;
> +	u8 order =3D 0;
> +
> +	if (n =3D=3D -1) {
> +		for (n =3D 0; n < MAX_AREAS; n++) {
> +			if (!(areas_mask & BIT(n)))
> +				break;
> +		}
> +	}
> +	assert(n < MAX_AREAS);
> +	assert(!(areas_mask & BIT(n)));
> +
> +	assert(top > start);
> +	assert(top - start > 4);
> +	assert(top < BIT_ULL(sizeof(void *) * 8 - PAGE_SHIFT));
> +
> +	table_size =3D (top - start + PAGE_SIZE) / (PAGE_SIZE + 1);
> +
> +	a =3D areas + n;
> +	a->page_states =3D (void *)(start << PAGE_SHIFT);
> +	a->base =3D start + table_size;
> +	a->top =3D top;
> +	npages =3D top - a->base;
> +
> +	assert((a->base - start) * PAGE_SIZE >=3D npages);
> +	for (i =3D 0; i < MAX_AREAS; i++) {
> +		if (!(areas_mask & BIT(i)))
> +			continue;
> +		assert(!area_overlaps(areas + i, start));
> +		assert(!area_overlaps(areas + i, top - 1));
> +		assert(!area_overlaps(a, PFN(areas[i].page_states)));
> +		assert(!area_overlaps(a, areas[i].top - 1));
> +	}
> +	for (i =3D 0; i < NLISTS; i++)
> +		a->freelists[i].next =3D a->freelists[i].prev =3D a->freelists + i;
> +
> +	for (i =3D a->base; i < a->top; i +=3D 1ull << order) {
> +		while (i + BIT(order) > a->top) {
> +			assert(order);
> +			order--;
> +		}
> +		while (IS_ALIGNED_ORDER(i, order + 1) && (i + BIT(order + 1) <=3D a-=
>top))
> +			order++;
> +		assert(order < NLISTS);
> +		memset(a->page_states + (i - a->base), order, BIT(order));
> +		list_add(a->freelists + order, (void *)(i << PAGE_SHIFT));
> +	}
> +	areas_mask |=3D BIT(n);
> +}
> +
> +/*
> + * Adds a new memory area to the pool of available memory.
> + *
> + * Prerequisites:
> + * see _page_alloc_init_area
> + */
> +void page_alloc_init_area(int n, uintptr_t base_pfn, uintptr_t top_pfn=
)
> +{
> +	spin_lock(&lock);
> +	_page_alloc_init_area(n, base_pfn, top_pfn);
> +	spin_unlock(&lock);
>  }
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 78562e4..a3c573f 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -155,7 +155,7 @@ static void mem_init(phys_addr_t freemem_start)
>  	assert(sizeof(long) =3D=3D 8 || !(base >> 32));
>  	if (sizeof(long) !=3D 8 && (top >> 32) !=3D 0)
>  		top =3D ((uint64_t)1 << 32);
> -	free_pages((void *)(unsigned long)base, top - base);
> +	page_alloc_init_area(-1, base, top);
>  	page_alloc_ops_enable();
>  }
> =20
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 4054d0e..c25d442 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -37,11 +37,16 @@ static void mem_init(phys_addr_t mem_end)
> =20
>  	phys_alloc_init(freemem_start, mem_end - freemem_start);
>  	phys_alloc_get_unused(&base, &top);
> -	base =3D (base + PAGE_SIZE - 1) & -PAGE_SIZE;
> -	top =3D top & -PAGE_SIZE;
> +	base =3D PAGE_ALIGN(base) >> PAGE_SHIFT;
> +	top =3D top >> PAGE_SHIFT;
> =20
>  	/* Make the pages available to the physical allocator */
> -	free_pages((void *)(unsigned long)base, top - base);
> +	if (top > (2ull * SZ_1G >> PAGE_SHIFT)) {
> +		page_alloc_init_area(0, 2ull * SZ_1G >> PAGE_SHIFT, top);
> +		page_alloc_init_area(1, base, 2ull * SZ_1G >> PAGE_SHIFT);
> +	} else {
> +		page_alloc_init_area(1, base, top);
> +	}
>  	page_alloc_ops_enable();
>  }
> =20
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 2860e9c..d954094 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -190,7 +190,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
> =20
>  	sigp_retry(cpu->addr, SIGP_INITIAL_CPU_RESET, 0, NULL);
> =20
> -	lc =3D alloc_pages(1);
> +	lc =3D alloc_pages_area(_AREA(1), 1);
>  	cpu->lowcore =3D lc;
>  	memset(lc, 0, PAGE_SIZE * 2);
>  	sigp_retry(cpu->addr, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
> diff --git a/lib/vmalloc.c b/lib/vmalloc.c
> index aca0876..f72c5b3 100644
> --- a/lib/vmalloc.c
> +++ b/lib/vmalloc.c
> @@ -217,18 +217,19 @@ void setup_vm()
>  	 * so that it can be used to allocate page tables.
>  	 */
>  	if (!page_alloc_initialized()) {
> -		base =3D PAGE_ALIGN(base);
> -		top =3D top & -PAGE_SIZE;
> -		free_pages(phys_to_virt(base), top - base);
> +		base =3D PAGE_ALIGN(base) >> PAGE_SHIFT;
> +		top =3D top >> PAGE_SHIFT;
> +		page_alloc_init_area(1, base, top);
> +		page_alloc_ops_enable();
>  	}
> =20
>  	find_highmem();
>  	phys_alloc_get_unused(&base, &top);
>  	page_root =3D setup_mmu(top);
>  	if (base !=3D top) {
> -		base =3D PAGE_ALIGN(base);
> -		top =3D top & -PAGE_SIZE;
> -		free_pages(phys_to_virt(base), top - base);
> +		base =3D PAGE_ALIGN(base) >> PAGE_SHIFT;
> +		top =3D top >> PAGE_SHIFT;
> +		page_alloc_init_area(0, base, top);
>  	}
> =20
>  	spin_lock(&lock);
>=20



--hXm1tC1061nleQpRkRypXmVC1qSJVQG2i--

--ZC9Z0BUQ716nPtxwL5CN9z7dUcMZdGlEV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl89SPcACgkQ41TmuOI4
ufh7mQ//eLr6AZa+Uq5dW8rNyvu4zM4Z6Q3EwE2zjqwdxGh7OnjvQysrwY6yytkv
hX5K3fK6md6YNTKWFVGHf3sqMfAD/zeOEK9RwFnsfxIYf9aoXx/1zycnV7Mz+Q9L
q7ZRziQFykjfzxjxfCuhAx7Vg76Fvxr0s+tYWXHIANEIsuRKpA5gq3YEMwSAhRdZ
Ra7cXuliEi9RQF3FgeMMr10SKRuXunN3xT/hDCQeukG0wK5gr2HX2BtYMwR04GRt
3xhUfxnCVntJDh7FQIJc/MCZnaOL8agjUTUbvFR+Tm+Oh85Bt/9n0waIJ1g2jdHo
meccm4pdHWz1VjgteOcBNvj9WPOonZuqGAQi3K3uz3uW8YPVKdLk7Wf+raxAt+kY
y2ysK6wUnSsdX/cFjTVbk8a0yDuILtqJBPmJocW1KgazEMAPCP1wigwNXVk3iVjj
3yb8me4cH1UTciNbsUnzhIFkYeDwCBalljZWxJvmjRUw7o7WUxs+6s8ITenNGC7D
Vzi6VSjY27MSq8wTmnh6nTWpz0pGOj1zpwQ+39nFNxnwPuJFGfByLOlPeqzP1S9M
J7aTY/mEJoK6dzddnrPeaGBlK7QgxDRxhuAFoS2Vc7fvQS4DOUNXW6rbpMQr/lkF
VxfUPBT0RXqEL1dBmJOuAICPeEZZjkOuLZNA+8PtfXZpFpiEZrE=
=V5/t
-----END PGP SIGNATURE-----

--ZC9Z0BUQ716nPtxwL5CN9z7dUcMZdGlEV--

