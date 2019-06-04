Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4129347D6
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 15:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfFDNQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 09:16:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18257 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbfFDNQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 09:16:43 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B656543AA3;
        Tue,  4 Jun 2019 13:16:42 +0000 (UTC)
Received: from [10.40.205.182] (unknown [10.40.205.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 651675D9D2;
        Tue,  4 Jun 2019 13:16:19 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pbonzini@redhat.com, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com, yang.zhang.wz@gmail.com,
        riel@surriel.com, mst@redhat.com, dodgen@google.com,
        konrad.wilk@oracle.com, dhildenb@redhat.com, aarcange@redhat.com,
        alexander.duyck@gmail.com
Subject: Re: [RFC][Patch v10 1/2] mm: page_hinting: core infrastructure
References: <20190603170306.49099-1-nitesh@redhat.com>
 <20190603170306.49099-2-nitesh@redhat.com>
 <c5aa99d5-8cd0-44cf-9d61-75c8d3b019aa@redhat.com>
Organization: Red Hat Inc,
Message-ID: <ca39c36e-2646-d04c-e5ae-5fd2896f1279@redhat.com>
Date:   Tue, 4 Jun 2019 09:16:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <c5aa99d5-8cd0-44cf-9d61-75c8d3b019aa@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hun85KKfyjW7Qo3FnHVFXjLAU0BGPerX8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 04 Jun 2019 13:16:42 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hun85KKfyjW7Qo3FnHVFXjLAU0BGPerX8
Content-Type: multipart/mixed; boundary="vnK5kVg8UEY0Uit0GfVEPGNN08aRZ9XVd";
 protected-headers="v1"
From: Nitesh Narayan Lal <nitesh@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, lcapitulino@redhat.com, pagupta@redhat.com,
 wei.w.wang@intel.com, yang.zhang.wz@gmail.com, riel@surriel.com,
 mst@redhat.com, dodgen@google.com, konrad.wilk@oracle.com,
 dhildenb@redhat.com, aarcange@redhat.com, alexander.duyck@gmail.com
Message-ID: <ca39c36e-2646-d04c-e5ae-5fd2896f1279@redhat.com>
Subject: Re: [RFC][Patch v10 1/2] mm: page_hinting: core infrastructure

--vnK5kVg8UEY0Uit0GfVEPGNN08aRZ9XVd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 6/3/19 3:57 PM, David Hildenbrand wrote:
> On 03.06.19 19:03, Nitesh Narayan Lal wrote:
>> This patch introduces the core infrastructure for free page hinting in=

>> virtual environments. It enables the kernel to track the free pages wh=
ich
>> can be reported to its hypervisor so that the hypervisor could
>> free and reuse that memory as per its requirement.
>>
>> While the pages are getting processed in the hypervisor (e.g.,
>> via MADV_FREE), the guest must not use them, otherwise, data loss
>> would be possible. To avoid such a situation, these pages are
>> temporarily removed from the buddy. The amount of pages removed
>> temporarily from the buddy is governed by the backend(virtio-balloon
>> in our case).
>>
>> To efficiently identify free pages that can to be hinted to the
>> hypervisor, bitmaps in a coarse granularity are used. Only fairly big
>> chunks are reported to the hypervisor - especially, to not break up TH=
P
>> in the hypervisor - "MAX_ORDER - 2" on x86, and to save space. The bit=
s
>> in the bitmap are an indication whether a page *might* be free, not a
>> guarantee. A new hook after buddy merging sets the bits.
>>
>> Bitmaps are stored per zone, protected by the zone lock. A workqueue
>> asynchronously processes the bitmaps, trying to isolate and report pag=
es
>> that are still free. The backend (virtio-balloon) is responsible for
>> reporting these batched pages to the host synchronously. Once reportin=
g/
>> freeing is complete, isolated pages are returned back to the buddy.
>>
>> There are still various things to look into (e.g., memory hotplug, mor=
e
>> efficient locking, possible races when disabling).
>>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> ---
>>  drivers/virtio/Kconfig       |   1 +
>>  include/linux/page_hinting.h |  46 +++++++
>>  mm/Kconfig                   |   6 +
>>  mm/Makefile                  |   2 +
>>  mm/page_alloc.c              |  17 +--
>>  mm/page_hinting.c            | 236 ++++++++++++++++++++++++++++++++++=
+
>>  6 files changed, 301 insertions(+), 7 deletions(-)
>>  create mode 100644 include/linux/page_hinting.h
>>  create mode 100644 mm/page_hinting.c
>>
>> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
>> index 35897649c24f..5a96b7a2ed1e 100644
>> --- a/drivers/virtio/Kconfig
>> +++ b/drivers/virtio/Kconfig
>> @@ -46,6 +46,7 @@ config VIRTIO_BALLOON
>>  	tristate "Virtio balloon driver"
>>  	depends on VIRTIO
>>  	select MEMORY_BALLOON
>> +	select PAGE_HINTING
>>  	---help---
>>  	 This driver supports increasing and decreasing the amount
>>  	 of memory within a KVM guest.
>> diff --git a/include/linux/page_hinting.h b/include/linux/page_hinting=
=2Eh
>> new file mode 100644
>> index 000000000000..e65188fe1e6b
>> --- /dev/null
>> +++ b/include/linux/page_hinting.h
>> @@ -0,0 +1,46 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _LINUX_PAGE_HINTING_H
>> +#define _LINUX_PAGE_HINTING_H
>> +
>> +/*
>> + * Minimum page order required for a page to be hinted to the host.
>> + */
>> +#define PAGE_HINTING_MIN_ORDER		(MAX_ORDER - 2)
>> +
>> +/*
>> + * struct page_hinting_cb: holds the callbacks to store, report and c=
leanup
>> + * isolated pages.
>> + * @prepare:		Callback responsible for allocating an array to hold
>> + *			the isolated pages.
>> + * @hint_pages:		Callback which reports the isolated pages synchornou=
sly
>> + *			to the host.
>> + * @cleanup:		Callback to free the the array used for reporting the
>> + *			isolated pages.
>> + * @max_pages:		Maxmimum pages that are going to be hinted to the hos=
t
>> + *			at a time of granularity >=3D PAGE_HINTING_MIN_ORDER.
>> + */
>> +struct page_hinting_cb {
>> +	int (*prepare)(void);
>> +	void (*hint_pages)(struct list_head *list);
>> +	void (*cleanup)(void);
>> +	int max_pages;
> If we allocate the array in virtio-balloon differently (e.g. similar to=

> bulk inflation/deflation of pfn's right now), we can most probably get
> rid of prepare() and cleanup(), simplifying the code further.
Yeap, as Alexander suggested. I will go for static allocation and remove
this prepare() and cleanup().
>> +};
>> +
>> +#ifdef CONFIG_PAGE_HINTING
>> +void page_hinting_enqueue(struct page *page, int order);
>> +void page_hinting_enable(const struct page_hinting_cb *cb);
>> +void page_hinting_disable(void);
>> +#else
>> +static inline void page_hinting_enqueue(struct page *page, int order)=

>> +{
>> +}
>> +
>> +static inline void page_hinting_enable(struct page_hinting_cb *cb)
>> +{
>> +}
>> +
>> +static inline void page_hinting_disable(void)
>> +{
>> +}
>> +#endif
>> +#endif /* _LINUX_PAGE_HINTING_H */
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index ee8d1f311858..177d858de758 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -764,4 +764,10 @@ config GUP_BENCHMARK
>>  config ARCH_HAS_PTE_SPECIAL
>>  	bool
>> =20
>> +# PAGE_HINTING will allow the guest to report the free pages to the
>> +# host in regular interval of time.
>> +config PAGE_HINTING
>> +       bool
>> +       def_bool n
>> +       depends on X86_64
>>  endmenu
>> diff --git a/mm/Makefile b/mm/Makefile
>> index ac5e5ba78874..bec456dfee34 100644
>> --- a/mm/Makefile
>> +++ b/mm/Makefile
>> @@ -41,6 +41,7 @@ obj-y			:=3D filemap.o mempool.o oom_kill.o fadvise.=
o \
>>  			   interval_tree.o list_lru.o workingset.o \
>>  			   debug.o $(mmu-y)
>> =20
>> +
>>  # Give 'page_alloc' its own module-parameter namespace
>>  page-alloc-y :=3D page_alloc.o
>>  page-alloc-$(CONFIG_SHUFFLE_PAGE_ALLOCATOR) +=3D shuffle.o
>> @@ -94,6 +95,7 @@ obj-$(CONFIG_Z3FOLD)	+=3D z3fold.o
>>  obj-$(CONFIG_GENERIC_EARLY_IOREMAP) +=3D early_ioremap.o
>>  obj-$(CONFIG_CMA)	+=3D cma.o
>>  obj-$(CONFIG_MEMORY_BALLOON) +=3D balloon_compaction.o
>> +obj-$(CONFIG_PAGE_HINTING) +=3D page_hinting.o
>>  obj-$(CONFIG_PAGE_EXTENSION) +=3D page_ext.o
>>  obj-$(CONFIG_CMA_DEBUGFS) +=3D cma_debug.o
>>  obj-$(CONFIG_USERFAULTFD) +=3D userfaultfd.o
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 3b13d3914176..d12f69e0e402 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -68,6 +68,7 @@
>>  #include <linux/lockdep.h>
>>  #include <linux/nmi.h>
>>  #include <linux/psi.h>
>> +#include <linux/page_hinting.h>
>> =20
>>  #include <asm/sections.h>
>>  #include <asm/tlbflush.h>
>> @@ -873,10 +874,10 @@ compaction_capture(struct capture_control *capc,=
 struct page *page,
>>   * -- nyc
>>   */
>> =20
>> -static inline void __free_one_page(struct page *page,
>> +inline void __free_one_page(struct page *page,
>>  		unsigned long pfn,
>>  		struct zone *zone, unsigned int order,
>> -		int migratetype)
>> +		int migratetype, bool hint)
>>  {
>>  	unsigned long combined_pfn;
>>  	unsigned long uninitialized_var(buddy_pfn);
>> @@ -951,6 +952,8 @@ static inline void __free_one_page(struct page *pa=
ge,
>>  done_merging:
>>  	set_page_order(page, order);
>> =20
>> +	if (hint)
>> +		page_hinting_enqueue(page, order);
>>  	/*
>>  	 * If this is not the largest possible page, check if the buddy
>>  	 * of the next-highest order is free. If it is, it's possible
>> @@ -1262,7 +1265,7 @@ static void free_pcppages_bulk(struct zone *zone=
, int count,
>>  		if (unlikely(isolated_pageblocks))
>>  			mt =3D get_pageblock_migratetype(page);
>> =20
>> -		__free_one_page(page, page_to_pfn(page), zone, 0, mt);
>> +		__free_one_page(page, page_to_pfn(page), zone, 0, mt, true);
>>  		trace_mm_page_pcpu_drain(page, 0, mt);
>>  	}
>>  	spin_unlock(&zone->lock);
>> @@ -1271,14 +1274,14 @@ static void free_pcppages_bulk(struct zone *zo=
ne, int count,
>>  static void free_one_page(struct zone *zone,
>>  				struct page *page, unsigned long pfn,
>>  				unsigned int order,
>> -				int migratetype)
>> +				int migratetype, bool hint)
>>  {
>>  	spin_lock(&zone->lock);
>>  	if (unlikely(has_isolate_pageblock(zone) ||
>>  		is_migrate_isolate(migratetype))) {
>>  		migratetype =3D get_pfnblock_migratetype(page, pfn);
>>  	}
>> -	__free_one_page(page, pfn, zone, order, migratetype);
>> +	__free_one_page(page, pfn, zone, order, migratetype, hint);
>>  	spin_unlock(&zone->lock);
>>  }
>> =20
>> @@ -1368,7 +1371,7 @@ static void __free_pages_ok(struct page *page, u=
nsigned int order)
>>  	migratetype =3D get_pfnblock_migratetype(page, pfn);
>>  	local_irq_save(flags);
>>  	__count_vm_events(PGFREE, 1 << order);
>> -	free_one_page(page_zone(page), page, pfn, order, migratetype);
>> +	free_one_page(page_zone(page), page, pfn, order, migratetype, true);=

>>  	local_irq_restore(flags);
>>  }
>> =20
>> @@ -2968,7 +2971,7 @@ static void free_unref_page_commit(struct page *=
page, unsigned long pfn)
>>  	 */
>>  	if (migratetype >=3D MIGRATE_PCPTYPES) {
>>  		if (unlikely(is_migrate_isolate(migratetype))) {
>> -			free_one_page(zone, page, pfn, 0, migratetype);
>> +			free_one_page(zone, page, pfn, 0, migratetype, true);
>>  			return;
>>  		}
>>  		migratetype =3D MIGRATE_MOVABLE;
>> diff --git a/mm/page_hinting.c b/mm/page_hinting.c
>> new file mode 100644
>> index 000000000000..7341c6462de2
>> --- /dev/null
>> +++ b/mm/page_hinting.c
>> @@ -0,0 +1,236 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Page hinting support to enable a VM to report the freed pages back=

>> + * to the host.
>> + *
>> + * Copyright Red Hat, Inc. 2019
>> + *
>> + * Author(s): Nitesh Narayan Lal <nitesh@redhat.com>
>> + */
>> +
>> +#include <linux/mm.h>
>> +#include <linux/slab.h>
>> +#include <linux/page_hinting.h>
>> +#include <linux/kvm_host.h>
>> +
>> +/*
>> + * struct hinting_bitmap: holds the bitmap pointer which tracks the f=
reed PFNs
>> + * and other required parameters which could help in retrieving the o=
riginal
>> + * PFN value using the bitmap.
>> + * @bitmap:		Pointer to the bitmap of free PFN.
>> + * @base_pfn:		Starting PFN value for the zone whose bitmap is stored=
=2E
>> + * @free_pages:		Tracks the number of free pages of granularity
>> + *			PAGE_HINTING_MIN_ORDER.
>> + * @nbits:		Indicates the total size of the bitmap in bits allocated
>> + *			at the time of initialization.
>> + */
>> +struct hinting_bitmap {
>> +	unsigned long *bitmap;
>> +	unsigned long base_pfn;
>> +	atomic_t free_pages;
>> +	unsigned long nbits;
>> +} bm_zone[MAX_NR_ZONES];
>> +
>> +static void init_hinting_wq(struct work_struct *work);
>> +extern int __isolate_free_page(struct page *page, unsigned int order)=
;
>> +extern void __free_one_page(struct page *page, unsigned long pfn,
>> +			    struct zone *zone, unsigned int order,
>> +			    int migratetype, bool hint);
>> +const struct page_hinting_cb *hcb;
>> +struct work_struct hinting_work;
>> +
>> +static unsigned long find_bitmap_size(struct zone *zone)
>> +{
>> +	unsigned long nbits =3D ALIGN(zone->spanned_pages,
>> +			    PAGE_HINTING_MIN_ORDER);
>> +
>> +	nbits =3D nbits >> PAGE_HINTING_MIN_ORDER;
>> +	return nbits;
> I think we can simplify this to
>
> return (zone->spanned_pages >> PAGE_HINTING_MIN_ORDER) + 1;
>
I will check this.
>> +}
>> +
>> +void page_hinting_enable(const struct page_hinting_cb *callback)
>> +{
>> +	struct zone *zone;
>> +	int idx =3D 0;
>> +	unsigned long bitmap_size =3D 0;
> You should probably protect enabling via a mutex and return -EINVAL or
> similar if we already have a callback set (if we ever have different
> drivers). But this has very little priority :)
I will have to look into this.
>> +
>> +	for_each_populated_zone(zone) {
>> +		spin_lock(&zone->lock);
>> +		bitmap_size =3D find_bitmap_size(zone);
>> +		bm_zone[idx].bitmap =3D bitmap_zalloc(bitmap_size, GFP_KERNEL);
>> +		if (!bm_zone[idx].bitmap)
>> +			return;
>> +		bm_zone[idx].nbits =3D bitmap_size;
>> +		bm_zone[idx].base_pfn =3D zone->zone_start_pfn;
>> +		spin_unlock(&zone->lock);
>> +		idx++;
>> +	}
>> +	hcb =3D callback;
>> +	INIT_WORK(&hinting_work, init_hinting_wq);
> There are also possible races when enabling, you will have to take care=

> of at one point.
No page will be enqueued until hcb is not set.
I can probably move it below INIT_WORK.
>> +}
>> +EXPORT_SYMBOL_GPL(page_hinting_enable);
>> +
>> +void page_hinting_disable(void)
>> +{
>> +	struct zone *zone;
>> +	int idx =3D 0;
>> +
>> +	cancel_work_sync(&hinting_work);
>> +	hcb =3D NULL;
>> +	for_each_populated_zone(zone) {
>> +		spin_lock(&zone->lock);
>> +		bitmap_free(bm_zone[idx].bitmap);
>> +		bm_zone[idx].base_pfn =3D 0;
>> +		bm_zone[idx].nbits =3D 0;
>> +		atomic_set(&bm_zone[idx].free_pages, 0);
>> +		spin_unlock(&zone->lock);
>> +		idx++;
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(page_hinting_disable);
>> +
>> +static unsigned long pfn_to_bit(struct page *page, int zonenum)
>> +{
>> +	unsigned long bitnr;
>> +
>> +	bitnr =3D (page_to_pfn(page) - bm_zone[zonenum].base_pfn)
>> +			 >> PAGE_HINTING_MIN_ORDER;
>> +	return bitnr;
>> +}
>> +
>> +static void release_buddy_pages(struct list_head *pages)
> maybe "release_isolated_pages", not sure.
>
>> +{
>> +	int mt =3D 0, zonenum, order;
>> +	struct page *page, *next;
>> +	struct zone *zone;
>> +	unsigned long bitnr;
>> +
>> +	list_for_each_entry_safe(page, next, pages, lru) {
>> +		zonenum =3D page_zonenum(page);
>> +		zone =3D page_zone(page);
>> +		bitnr =3D pfn_to_bit(page, zonenum);
>> +		spin_lock(&zone->lock);
>> +		list_del(&page->lru);
>> +		order =3D page_private(page);
>> +		set_page_private(page, 0);
>> +		mt =3D get_pageblock_migratetype(page);
>> +		__free_one_page(page, page_to_pfn(page), zone,
>> +				order, mt, false);
>> +		spin_unlock(&zone->lock);
>> +	}
>> +}
>> +
>> +static void bm_set_pfn(struct page *page)
>> +{
>> +	unsigned long bitnr =3D 0;
>> +	int zonenum =3D page_zonenum(page);
>> +	struct zone *zone =3D page_zone(page);
>> +
>> +	lockdep_assert_held(&zone->lock);
>> +	bitnr =3D pfn_to_bit(page, zonenum);
>> +	if (bm_zone[zonenum].bitmap &&
>> +	    bitnr < bm_zone[zonenum].nbits &&
>> +	    !test_and_set_bit(bitnr, bm_zone[zonenum].bitmap))
>> +		atomic_inc(&bm_zone[zonenum].free_pages);
>> +}
>> +
>> +static void scan_hinting_bitmap(int zonenum, int free_pages)
>> +{
>> +	unsigned long set_bit, start =3D 0;
>> +	struct page *page;
>> +	struct zone *zone;
>> +	int scanned_pages =3D 0, ret =3D 0, order, isolated_cnt =3D 0;
>> +	LIST_HEAD(isolated_pages);
>> +
>> +	ret =3D hcb->prepare();
>> +	if (ret < 0)
>> +		return;
>> +	for (;;) {
>> +		ret =3D 0;
>> +		set_bit =3D find_next_bit(bm_zone[zonenum].bitmap,
>> +					bm_zone[zonenum].nbits, start);
>> +		if (set_bit >=3D bm_zone[zonenum].nbits)
>> +			break;
>> +		page =3D pfn_to_online_page((set_bit << PAGE_HINTING_MIN_ORDER) +
>> +				bm_zone[zonenum].base_pfn);
>> +		if (!page)
>> +			continue;
> You are not clearing the bit / decrementing the counter.
>
>> +		zone =3D page_zone(page);
>> +		spin_lock(&zone->lock);
>> +
>> +		if (PageBuddy(page) && page_private(page) >=3D
>> +		    PAGE_HINTING_MIN_ORDER) {
>> +			order =3D page_private(page);
>> +			ret =3D __isolate_free_page(page, order);
>> +		}
>> +		clear_bit(set_bit, bm_zone[zonenum].bitmap);
>> +		spin_unlock(&zone->lock);
>> +		if (ret) {
>> +			/*
>> +			 * restoring page order to use it while releasing
>> +			 * the pages back to the buddy.
>> +			 */
>> +			set_page_private(page, order);
>> +			list_add_tail(&page->lru, &isolated_pages);
>> +			isolated_cnt++;
>> +			if (isolated_cnt =3D=3D hcb->max_pages) {
>> +				hcb->hint_pages(&isolated_pages);
>> +				release_buddy_pages(&isolated_pages);
>> +				isolated_cnt =3D 0;
>> +			}
>> +		}
>> +		start =3D set_bit + 1;
>> +		scanned_pages++;
>> +	}
>> +	if (isolated_cnt) {
>> +		hcb->hint_pages(&isolated_pages);
>> +		release_buddy_pages(&isolated_pages);
>> +	}
>> +	hcb->cleanup();
>> +	if (scanned_pages > free_pages)
>> +		atomic_sub((scanned_pages - free_pages),
>> +			   &bm_zone[zonenum].free_pages);
> This looks overly complicated. Can't we somehow simply decrement when
> clearing a bit?
>
>> +}
>> +
>> +static bool check_hinting_threshold(void)
>> +{
>> +	int zonenum =3D 0;
>> +
>> +	for (; zonenum < MAX_NR_ZONES; zonenum++) {
>> +		if (atomic_read(&bm_zone[zonenum].free_pages) >=3D
>> +				hcb->max_pages)
>> +			return true;
>> +	}
>> +	return false;
>> +}
>> +
>> +static void init_hinting_wq(struct work_struct *work)
>> +{
>> +	int zonenum =3D 0, free_pages =3D 0;
>> +
>> +	for (; zonenum < MAX_NR_ZONES; zonenum++) {
>> +		free_pages =3D atomic_read(&bm_zone[zonenum].free_pages);
>> +		if (free_pages >=3D hcb->max_pages) {
>> +			/* Find a better way to synchronize per zone
>> +			 * free_pages.
>> +			 */
>> +			atomic_sub(free_pages,
>> +				   &bm_zone[zonenum].free_pages);
> I can't follow yet why we need that information.=20
We don't want to enqueue multiple jobs just because we are delaying the
decrementing of free_pages.
I agree, even I am not convinced with the approach which I have right now=
=2E
I will try to come up with a better way.
> Wouldn't it be enough
> to just track the number of set bits in the bitmap and start hinting
> depending on that count? (there are false positives, but do we really c=
are?)
In an attempt to minimize the false positives, I might have overly
complicated this part.
I will try to simplify this in the next posting.
>

>> +			scan_hinting_bitmap(zonenum, free_pages);
>> +		}
>> +	}
>> +}
>> +
>> +void page_hinting_enqueue(struct page *page, int order)
>> +{
>> +	if (hcb && order >=3D PAGE_HINTING_MIN_ORDER)
>> +		bm_set_pfn(page);
>> +	else
>> +		return;
>> +
>> +	if (check_hinting_threshold()) {
>> +		int cpu =3D smp_processor_id();
>> +
>> +		queue_work_on(cpu, system_wq, &hinting_work);
>> +	}
>> +}
>>
>
--=20
Regards
Nitesh


--vnK5kVg8UEY0Uit0GfVEPGNN08aRZ9XVd--

--hun85KKfyjW7Qo3FnHVFXjLAU0BGPerX8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAlz2bx8ACgkQo4ZA3AYy
ozk+5Q//UpfP9IuIrdtP35s53eyDylrQjhQhU0BYDcW2QGkdGVoTDfnLeMCMZr1y
CIiWtliyZ0EjsI1Z1C+Pib0cYsxbpKIhWaftfJXe2sCidPxE4RfmkJ2InXLxK09V
mrCqWInVNFzk7WB8HrY8iXlxKP+OrOtVBZiIjFpOwp30tPrNwkAy1vmPBgogBdQP
0UDED2iIUF2t5n1JifDTUsBemelfnYUp1JhnlhYyEzNYmZrlZbXFRfxoPpPsATfx
hhK3l4WTkRyyf4Yj2SJ2RST66Bkj7cCu+c7VT0kURaxrvYe/XbJRMKA+guFwIJW3
QLpIz2BHkV8mNfrFTM+LYTax9oeOE3gi0qFPtOlYXb/yK3jma3r53+4XfsIS9Sbo
Xosnh7K0JiZ38e9al29RzWqWRgO4UeHs78uew6dCp2gEy01WdrDAN7fkDl7nBoJP
cJgEI+TCa1fKfUY/pSShw9fxO5mxoszv2wp1TFbyb1hPiQtwaBEMWHEU5I2pGkyn
kDfphuracrSlRn66nS8OHmQkLy1sT54YK34DaPWXLvtScgPztDZuaUA2wnqT8wR9
xnQJZ2gDiEYFSur+lENHLnAaBU/2UxUsziN46szMBA5nyu1iiED9FZSOKyQow8yI
HAqqwykS6hVw910E4RjJmoRKQL93cO/3MIsajcV7SafpaYX4MRc=
=23/B
-----END PGP SIGNATURE-----

--hun85KKfyjW7Qo3FnHVFXjLAU0BGPerX8--
