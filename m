Return-Path: <kvm+bounces-23699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A03F94D2DD
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 17:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEF0C1C209E4
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 15:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA580197A93;
	Fri,  9 Aug 2024 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="WeAreKJ6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DD7193090;
	Fri,  9 Aug 2024 15:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723215748; cv=none; b=u9qL+IkyCgEbJ8cZHhSZdw+HFfNetCBoVh1CTkfBrfP7b8C26wz6lLp7Wp9LawcKMwTynsfkVkO7lOxcOUU1jYpjdWpgaQP5Br9LfJp92wdQdGwjrfSoZVVKOh1iUDahm3C1ZBk57HRaK6TD1K2R6ArswYN3Rn2KrtNquP2c5nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723215748; c=relaxed/simple;
	bh=9+HKbD4Ve5qJVTWVL3xag+QqynXjWdRArtEOR1Ie4Lc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PqGdTn5/brIwhhVuKVcLsmdbD8iVU1OKGF9E2ElkpvY+UzYbtzGFNrHMRKcLDfFGLZMnwf3Ob9i3gmQRMDsY2Upigf2oVFFlOKw2rT6aMhEGOy+CSXY13tV+DrkPOhWuK1aEwVmaaqG0hrpOA0YgxgihSUWsHPOTGBTesQmr5VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=WeAreKJ6; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1723215746; x=1754751746;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EjelYir35dkUT01oUgeBO2tMVve1XmvlOjCGOs6xT2g=;
  b=WeAreKJ6gfbSqLgbZNE/sLlQdtD6Vw8n6ppcMCYstzR/RVq9Zd1RnOl0
   CjefHlSY2mDC8tSa48j3cOW+J0iSjPEQp6fLTlOLlUaZTpkSb344bW731
   NzBDs3fWfJuda21mF0JhxeDWPK7Rjq7JX/FsV155ToAfCxfdQuJ2LjA94
   c=;
X-IronPort-AV: E=Sophos;i="6.09,276,1716249600"; 
   d="scan'208";a="651681860"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 15:02:22 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.38.20:61664]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.236:2525] with esmtp (Farcaster)
 id 2d79039a-179a-4945-9978-59e2a9c01080; Fri, 9 Aug 2024 15:02:21 +0000 (UTC)
X-Farcaster-Flow-ID: 2d79039a-179a-4945-9978-59e2a9c01080
Received: from EX19D003UWC003.ant.amazon.com (10.13.138.173) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 9 Aug 2024 15:02:21 +0000
Received: from EX19MTAUWC001.ant.amazon.com (10.250.64.145) by
 EX19D003UWC003.ant.amazon.com (10.13.138.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 9 Aug 2024 15:02:20 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Fri, 9 Aug 2024 15:02:17 +0000
Message-ID: <395cb776-34b1-4285-9275-e899900f8331@amazon.co.uk>
Date: Fri, 9 Aug 2024 16:02:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/4] mm: guest_memfd: Add option to remove guest
 private memory from direct map
To: Elliot Berman <quic_eberman@quicinc.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Fuad Tabba
	<tabba@google.com>, David Hildenbrand <david@redhat.com>,
	<qperret@google.com>, Ackerley Tng <ackerleytng@google.com>,
	<linux-coco@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <kvm@vger.kernel.org>,
	James Gowans <jgowans@amazon.com>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>, "Cali,
 Marco" <xmarcalx@amazon.co.uk>
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-3-e5a29a4ff5d7@quicinc.com>
 <3fc11402-53e1-4325-a3ee-5ebd616b5b63@amazon.co.uk>
 <20240806104702482-0700.eberman@hu-eberman-lv.qualcomm.com>
 <a43ae745-9907-425f-b09d-a49405d6bc2d@amazon.co.uk>
 <90886a03-ad62-4e98-bc05-63875faa9ccc@amazon.co.uk>
 <20240807113514068-0700.eberman@hu-eberman-lv.qualcomm.com>
 <7166d51c-7757-44f2-a6f8-36da3e86bf90@amazon.co.uk>
 <20240808145103617-0700.eberman@hu-eberman-lv.qualcomm.com>
From: Patrick Roy <roypat@amazon.co.uk>
Content-Language: en-US
Autocrypt: addr=roypat@amazon.co.uk; keydata=
 xjMEY0UgYhYJKwYBBAHaRw8BAQdA7lj+ADr5b96qBcdINFVJSOg8RGtKthL5x77F2ABMh4PN
 NVBhdHJpY2sgUm95IChHaXRodWIga2V5IGFtYXpvbikgPHJveXBhdEBhbWF6b24uY28udWs+
 wpMEExYKADsWIQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbAwULCQgHAgIiAgYVCgkI
 CwIEFgIDAQIeBwIXgAAKCRBVg4tqeAbEAmQKAQC1jMl/KT9pQHEdALF7SA1iJ9tpA5ppl1J9
 AOIP7Nr9SwD/fvIWkq0QDnq69eK7HqW14CA7AToCF6NBqZ8r7ksi+QLOOARjRSBiEgorBgEE
 AZdVAQUBAQdAqoMhGmiXJ3DMGeXrlaDA+v/aF/ah7ARbFV4ukHyz+CkDAQgHwngEGBYKACAW
 IQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbDAAKCRBVg4tqeAbEAtjHAQDkh5jZRIsZ
 7JMNkPMSCd5PuSy0/Gdx8LGgsxxPMZwePgEAn5Tnh4fVbf00esnoK588bYQgJBioXtuXhtom
 8hlxFQM=
In-Reply-To: <20240808145103617-0700.eberman@hu-eberman-lv.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2024-08-08 at 23:16 +0100, Elliot Berman wrote
> On Thu, Aug 08, 2024 at 02:05:55PM +0100, Patrick Roy wrote:
>> On Wed, 2024-08-07 at 20:06 +0100, Elliot Berman wrote:
>>>>>>>>  struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags)
>>>>>>>>  {
>>>>>>>> +       unsigned long gmem_flags = (unsigned long)file->private_data;
>>>>>>>>         struct inode *inode = file_inode(file);
>>>>>>>>         struct guest_memfd_operations *ops = inode->i_private;
>>>>>>>>         struct folio *folio;
>>>>>>>> @@ -43,6 +89,12 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
>>>>>>>>                         goto out_err;
>>>>>>>>         }
>>>>>>>>
>>>>>>>> +       if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
>>>>>>>> +               r = guest_memfd_folio_private(folio);
>>>>>>>> +               if (r)
>>>>>>>> +                       goto out_err;
>>>>>>>> +       }
>>>>>>>> +
>>>>>>>
>>>>>>> How does a caller of guest_memfd_grab_folio know whether a folio needs
>>>>>>> to be removed from the direct map? E.g. how can a caller know ahead of
>>>>>>> time whether guest_memfd_grab_folio will return a freshly allocated
>>>>>>> folio (which thus needs to be removed from the direct map), vs a folio
>>>>>>> that already exists and has been removed from the direct map (probably
>>>>>>> fine to remove from direct map again), vs a folio that already exists
>>>>>>> and is currently re-inserted into the direct map for whatever reason
>>>>>>> (must not remove these from the direct map, as other parts of
>>>>>>> KVM/userspace probably don't expect the direct map entries to disappear
>>>>>>> from underneath them). I couldn't figure this one out for my series,
>>>>>>> which is why I went with hooking into the PG_uptodate logic to always
>>>>>>> remove direct map entries on freshly allocated folios.
>>>>>>>
>>>>>>
>>>>>> gmem_flags come from the owner. If the caller (in non-CoCo case) wants
>>>>
>>>> Ah, oops, I got it mixed up with the new `flags` parameter.
>>>>
>>>>>> to restore the direct map right away, it'd have to be a direct
>>>>>> operation. As an optimization, we could add option that asks for page in
>>>>>> "shared" state. If allocating new page, we can return it right away
>>>>>> without removing from direct map. If grabbing existing folio, it would
>>>>>> try to do the private->shared conversion.
>>>>
>>>> My concern is more with the implicit shared->private conversion that
>>>> happens on every call to guest_memfd_grab_folio (and thus
>>>> kvm_gmem_get_pfn) when grabbing existing folios. If something else
>>>> marked the folio as shared, then we cannot punch it out of the direct
>>>> map again until that something is done using the folio (when working on
>>>> my RFC, kvm_gmem_get_pfn was indeed called on existing folios that were
>>>> temporarily marked shared, as I was seeing panics because of this). And
>>>> if the folio is currently private, there's nothing to do. So either way,
>>>> guest_memfd_grab_folio shouldn't touch the direct map entry for existing
>>>> folios.
>>>>
>>>
>>> What I did could be documented/commented better.
>>
>> No worries, thanks for taking the time to walk me through understanding
>> it!
>>
>>> If ops->accessible() is *not* provided, all guest_memfd allocations will
>>> immediately remove from direct map and treat them immediately like guest
>>> private (goal is to match what KVM does today on tip).
>>
>> Ah, so if ops->accessible() is not provided, then there will never be
>> any shared memory inside gmem (like today, where gmem doesn't support
>> shared memory altogether), and thus there's no problems with just
>> unconditionally doing set_direct_map_invalid_noflush in
>> guest_memfd_grab_folio, because all existing folios already have their
>> direct map entry removed. Got it!
>>
>>> If ops->accessible() is provided, then guest_memfd allocations start
>>> as "shared" and KVM/Gunyah need to do the shared->private conversion
>>> when they want to do the private conversion on the folio. "Shared" is
>>> the default because that is effectively a no-op.
>>> For the non-CoCo case you're interested in, we'd have the
>>> ops->accessible() provided and we wouldn't pull out the direct map from
>>> gpc.
>>
>> So in pKVM/Gunyah's case, guest memory starts as shared, and at some
>> point the guest will issue a hypercall (or similar) to flip it to
>> private, at which point it'll get removed from the direct map?
>>
>> That isn't really what we want for our case. We consider the folios as
>> private straight away, as we do not let the guest control their state at
>> all. Everything is always "accessible" to both KVM and userspace in the
>> sense that they can just flip gfns to shared as they please without the
>> guest having any say in it.
>>
>> I think we should untangle the behavior of guest_memfd_grab_folio from
>> the presence of ops->accessible. E.g.  instead of direct map removal
>> being dependent on ops->accessible we should have some
>> GRAB_FOLIO_RETURN_SHARED flag for gmem_flags, which is set for y'all,
>> and not set for us (I don't think we should have a "call
>> set_direct_map_invalid_noflush unconditionally in
>> guest_memfd_grab_folio" mode at all, because if sharing gmem is
>> supported, then that is broken, and if sharing gmem is not supported
>> then only removing direct map entries for freshly allocated folios gets
>> us the same result of "all folios never in the direct map" while
>> avoiding some no-op direct map operations).
>>
>> Because we would still use ->accessible, albeit for us that would be
>> more for bookkeeping along the lines of "which gfns does userspace
>> currently require to be in the direct map?". I haven't completely
>> thought it through, but what I could see working for us would be a pair
>> of ioctls for marking ranges accessible/inaccessible, with
>> "accessibility" stored in some xarray (somewhat like Fuad's patches, I
>> guess? [1]).
>>
>> In a world where we have a "sharing refcount", the "make accessible"
>> ioctl reinserts into the direct map (if needed), lifts the "sharings
>> refcount" for each folio in the given gfn range, and marks the range as
>> accessible.  And the "make inaccessible" ioctl would first check that
>> userspace has unmapped all those gfns again, and if yes, mark them as
>> inaccessible, drop the "sharings refcount" by 1 for each, and removes
>> from the direct map again if it held the last reference (if userspace
>> still has some gfns mapped, the ioctl would just fail).
>>
> 
> I am warming up to the sharing refcount idea. How does the sharing
> refcount look for kvm gpc?

I've come up with the below rough draft (written as a new commit on
top of my RFC series [1], with some bits from your patch copied in).
With this, I was able to actually boot a Firecracker VM with
multiple vCPUs (which previously didn't work because of different vCPUs
putting their kvm-clock structures into the same guest page). 

Best, 
Patrick

[1]: https://lore.kernel.org/kvm/20240709132041.3625501-1-roypat@amazon.co.uk/T/#ma44793da6bc000a2c22b1ffe37292b9615881838

---

From 2005c5a06b8a8f8568e9140b275d2c219488a71a Mon Sep 17 00:00:00 2001
From: Patrick Roy <roypat@amazon.co.uk>
Date: Fri, 9 Aug 2024 15:13:08 +0100
Subject: [RFC PATCH 009/008] kvm: gmem: Introduce "sharing refcount"

The assumption that there would never be two gfn_to_pfn_caches holding
the same gfn was wrong. The guest can put the kvm-clock structures for
different vCPUs into the same gfn. On KVM's side, one gfn_to_pfn_cache
is initialized by vCPU, meaning in multi-vCPU setups, multiple
gfn_to_pfn_caches to the same gfn exist.

For gmem, this means that multiple gfn_to_pfn_caches will want direct
map entries for the same page to be present - the direct map entry needs
to be removed when the first gpc is initialized, and can only be removed
again after the last gpc to this page is invalidated. To handle this,
introduce the concept of a "sharing refcount" to gmem: If something
inside of KVM wants to access gmem it should now do

struct folio *gmem_folio = /* ... */;
int r = kvm_gmem_folio_share(gmem_folio);
if (r)
    goto err;
/* do stuff */
kvm_gmem_folio_unshare(gmem_folio);

The first call to kvm_gmem_folio_share will increment this new "sharing
refcount" by 1 (and insert the folio back into the direct map if it
acquires the first refcount), while kvm_gmem_folio_unshare will
decrement the refcount by 1 (and remove the folio from the direct map
again if it held the last refcount).

One quirk is that we use "sharing_refcount == 1" to mean "folio is not
in the direct map" (aka not shared), as letting the refcount temporarily
drop to 0 would cause refcount_t functions to WARN.

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 virt/kvm/guest_memfd.c | 139 ++++++++++++++++++++++++++++++++++++++---
 virt/kvm/kvm_main.c    |  32 ++++------
 virt/kvm/kvm_mm.h      |   2 +
 virt/kvm/pfncache.c    |  54 ++--------------
 4 files changed, 148 insertions(+), 79 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 29abbc883c73a..05fd6149c11c2 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -55,6 +55,96 @@ static bool kvm_gmem_not_present(struct inode *inode)
 	return ((unsigned long)inode->i_private & KVM_GMEM_NO_DIRECT_MAP) != 0;
 }

+static int kvm_gmem_folio_private(struct folio* folio)
+{
+	unsigned long nr_pages = folio_nr_pages(folio);
+	unsigned long i;
+	int r;
+
+	/*
+	 * We must only remove direct map entries after the last "sharing
+	 * reference" has gone away.
+	 */
+	if(WARN_ON_ONCE(refcount_read(folio_get_private(folio)) != 1))
+		return -EPERM;
+
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page = folio_page(folio, i);
+
+		r = set_direct_map_invalid_noflush(page);
+		if (r < 0)
+			goto out_remap;
+	}
+
+	// We use the private flag to track whether the folio has been removed
+	// from the direct map. This is because inside of ->free_folio,
+	// we do not have access to the address_space anymore, meaning we
+	// cannot check folio_inode(folio)->i_private to determine whether
+	// KVM_GMEM_NO_DIRECT_MAP was set.
+	folio_set_private(folio);
+	return 0;
+out_remap:
+	for (; i > 0; i--) {
+		struct page *page = folio_page(folio, i - 1);
+
+		BUG_ON(set_direct_map_default_noflush(page));
+	}
+	return r;
+}
+
+static int kvm_gmem_folio_clear_private(struct folio *folio)
+{
+	unsigned long start = (unsigned long)folio_address(folio);
+	unsigned long nr = folio_nr_pages(folio);
+	unsigned long i;
+	int r;
+
+	/*
+	 * We must restore direct map entries on acquiring the first "sharing
+	 * reference" (although restoring it before that is fine too - we
+	 * restore direct map entries with sharing_refcount == 1 in
+	 * kvm_gmem_invalidate_folio).
+	 */
+	WARN_ON_ONCE(refcount_read(folio_get_private(folio)) > 2);
+
+	for (i = 0; i < nr; i++) {
+		struct page *page = folio_page(folio, i);
+
+		r = set_direct_map_default_noflush(page);
+		if (r)
+			goto out_remap;
+	}
+	flush_tlb_kernel_range(start, start + folio_size(folio));
+
+	folio_clear_private(folio);
+	return 0;
+out_remap:
+	for (; i > 0; i--) {
+		for (; i > 0; i--) {
+			struct page *page = folio_page(folio, i - 1);
+
+			BUG_ON(set_direct_map_invalid_noflush(page));
+		}
+	}
+	return r;
+}
+
+static int kvm_gmem_init_sharing_count(struct folio *folio)
+{
+	refcount_t *sharing_count = kmalloc(sizeof(*sharing_count), GFP_KERNEL);
+	if (!sharing_count)
+		return -ENOMEM;
+
+	/*
+	 * we need to use sharing_count == 1 to mean "no sharing", because dropping
+	 * a refcount_t to 0 and later inc-ing it again would result in a WARN
+	 */
+	refcount_set(sharing_count, 1);
+	folio_change_private(folio, (void *)sharing_count);
+
+	return 0;
+}
+
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
 {
 	struct folio *folio;
@@ -96,16 +186,12 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool
 	}

 	if (zap_direct_map) {
-		r = set_direct_map_invalid_noflush(&folio->page);
+		r = kvm_gmem_init_sharing_count(folio);
+		if (r < 0)
+			goto out_err;
+		r = kvm_gmem_folio_private(folio);
 		if (r < 0)
 			goto out_err;
-
-		// We use the private flag to track whether the folio has been removed
-		// from the direct map. This is because inside of ->free_folio,
-		// we do not have access to the address_space anymore, meaning we
-		// cannot check folio_inode(folio)->i_private to determine whether
-		// KVM_GMEM_NO_DIRECT_MAP was set.
-		folio_set_private(folio);
 	}

 	/*
@@ -413,11 +499,21 @@ static void kvm_gmem_free_folio(struct folio *folio)
 static void kvm_gmem_invalidate_folio(struct folio *folio, size_t start, size_t end)
 {
 	if (start == 0 && end == PAGE_SIZE) {
+		refcount_t *sharing_count = folio_get_private(folio);
+		/*
+		 * sharing_count != 1 means that something else forgot
+		 * to call kvm_gmem_folio_unshare after it was done with the
+		 * folio (meaning the folio has been in the direct map
+		 * this entire time, which means we haven't been getting the
+		 * spculation protection we wanted).
+		 */
+		WARN_ON_ONCE(refcount_read(sharing_count) != 1);
+
 		// We only get here if PG_private is set, which only happens if kvm_gmem_not_present
 		// returned true in kvm_gmem_get_folio. Thus no need to do that check again.
-		BUG_ON(set_direct_map_default_noflush(&folio->page));
+		kvm_gmem_folio_clear_private(folio);
+		kfree(sharing_count);

-		folio_clear_private(folio);
 	}
 }

@@ -610,6 +706,29 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	fput(file);
 }

+int kvm_gmem_folio_unshare(struct folio *folio)
+{
+	if (kvm_gmem_not_present(folio_inode(folio))) {
+		refcount_t *sharing_count = folio_get_private(folio);
+
+		refcount_dec(sharing_count);
+		if (refcount_read(sharing_count) == 1)
+			return kvm_gmem_folio_private(folio);
+	}
+	return 0;
+}
+
+int kvm_gmem_folio_share(struct folio *folio)
+{
+	if (kvm_gmem_not_present(folio_inode(folio))) {
+		refcount_inc(folio_get_private(folio));
+
+		if (folio_test_private(folio))
+			return kvm_gmem_folio_clear_private(folio);
+	}
+	return 0;
+}
+
 static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 		       gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prepare)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 762decd9f2da0..d0680564ad52f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3301,17 +3301,13 @@ static int __kvm_read_guest_private_page(struct kvm *kvm,
 	folio = pfn_folio(pfn);
 	folio_lock(folio);
 	kaddr = folio_address(folio);
-	if (folio_test_private(folio)) {
-		r = set_direct_map_default_noflush(&folio->page);
-		if (r)
-			goto out_unlock;
-	}
+	r = kvm_gmem_folio_share(folio);
+	if (r)
+		goto out_unlock;
 	memcpy(data, kaddr + offset, len);
-	if (folio_test_private(folio)) {
-		r = set_direct_map_invalid_noflush(&folio->page);
-		if (r)
-			goto out_unlock;
-	}
+	r = kvm_gmem_folio_unshare(folio);
+	if (r)
+		goto out_unlock;
 out_unlock:
 	folio_unlock(folio);
 	folio_put(folio);
@@ -3458,17 +3454,13 @@ static int __kvm_write_guest_private_page(struct kvm *kvm,
 	folio = pfn_folio(pfn);
 	folio_lock(folio);
 	kaddr = folio_address(folio);
-	if (folio_test_private(folio)) {
-		r = set_direct_map_default_noflush(&folio->page);
-		if (r)
-			goto out_unlock;
-	}
+	r = kvm_gmem_folio_share(folio);
+	if (r)
+		goto out_unlock;
 	memcpy(kaddr + offset, data, len);
-	if (folio_test_private(folio)) {
-		r = set_direct_map_invalid_noflush(&folio->page);
-		if (r)
-			goto out_unlock;
-	}
+	r = kvm_gmem_folio_unshare(folio);
+	if (r)
+		goto out_unlock;

 out_unlock:
 	folio_unlock(folio);
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 715f19669d01f..f3fb31a39a66f 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -41,6 +41,8 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
+int kvm_gmem_folio_share(struct folio *folio);
+int kvm_gmem_folio_unshare(struct folio *folio);
 #else
 static inline void kvm_gmem_init(struct module *module)
 {
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 55f39fd60f8af..9f955e07efb90 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -111,45 +111,8 @@ static int gpc_map_gmem(kvm_pfn_t pfn)
 	if (((unsigned long)inode->i_private & KVM_GMEM_NO_DIRECT_MAP) == 0)
 		goto out;

-	/* We need to avoid race conditions where set_memory_np is called for
-	 * pages that other parts of KVM still try to access.  We use the
-	 * PG_private bit for this. If it is set, then the page is removed from
-	 * the direct map. If it is cleared, the page is present in the direct
-	 * map. All changes to this bit, and all modifications of the direct
-	 * map entries for the page happen under the page lock. The _only_
-	 * place where a page will be in the direct map while the page lock is
-	 * _not_ held is if it is inside a gpc. All other parts of KVM that
-	 * temporarily re-insert gmem pages into the direct map (currently only
-	 * guest_{read,write}_page) take the page lock before the direct map
-	 * entry is restored, and hold it until it is zapped again. This means
-	 * - If we reach gpc_map while, say, guest_read_page is operating on
-	 *   this page, we block on acquiring the page lock until
-	 *   guest_read_page is done.
-	 * - If we reach gpc_map while another gpc is already caching this
-	 *   page, the page is present in the direct map and the PG_private
-	 *   flag is cleared. Int his case, we return -EINVAL below to avoid
-	 *   two gpcs caching the same page (since we do not ref-count
-	 *   insertions back into the direct map, when the first cache gets
-	 *   invalidated it would "break" the second cache that assumes the
-	 *   page is present in the direct map until the second cache itself
-	 *   gets invalidated).
-	 * - Lastly, if guest_read_page is called for a page inside of a gpc,
-	 *   it will see that the PG_private flag is cleared, and thus assume
-	 *   it is present in the direct map (and leave the direct map entry
-	 *   untouched). Since it will be holding the page lock, it cannot race
-	 *   with gpc_unmap.
-	 */
 	folio_lock(folio);
-	if (folio_test_private(folio)) {
-		r = set_direct_map_default_noflush(&folio->page);
-		if (r)
-			goto out_unlock;
-
-		folio_clear_private(folio);
-	} else {
-		r = -EINVAL;
-	}
-out_unlock:
+	r = kvm_gmem_folio_share(folio);
 	folio_unlock(folio);
 out:
 	return r;
@@ -181,17 +144,10 @@ static void gpc_unmap(kvm_pfn_t pfn, void *khva, bool private)
 	if (pfn_valid(pfn)) {
 		if (private) {
 			struct folio *folio = pfn_folio(pfn);
-			struct inode *inode = folio_inode(folio);
-
-			if ((unsigned long)inode->i_private &
-			    KVM_GMEM_NO_DIRECT_MAP) {
-				folio_lock(folio);
-				BUG_ON(folio_test_private(folio));
-				BUG_ON(set_direct_map_invalid_noflush(
-					&folio->page));
-				folio_set_private(folio);
-				folio_unlock(folio);
-			}
+
+			folio_lock(folio);
+			kvm_gmem_folio_unshare(folio);
+			folio_unlock(folio);
 		}
 		kunmap(pfn_to_page(pfn));
 		return;
--
2.46.0


