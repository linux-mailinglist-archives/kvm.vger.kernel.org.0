Return-Path: <kvm+bounces-23480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DAEB694A113
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 08:52:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AC1B1F25B22
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 06:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 020F61BC073;
	Wed,  7 Aug 2024 06:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="hSYWo2EM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D441B86D5;
	Wed,  7 Aug 2024 06:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723013334; cv=none; b=N9u26a/Ap04ClqDFBQG7OZ9MCNT2D1MD8CbDwOUz8PMb52vXhJOH+Mvqf5WlQ7fIf/Y4O5/2DA7ZG8AuiMQ5cwz9kz7FEqjT2PXTc7wNnfYiiZR7LJwYJKQGjiJKk3tQGQqmVHwCAfqwflwxs9A+wKrmoebG5tG+4Wx4JGOHmgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723013334; c=relaxed/simple;
	bh=McTJC16ImboS2GB3tQx9VdnRtfUHGiPerIbqJgRGpio=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UN2SYNikPGVk4cjoTW+Hg/NRBRnKVlk2YqbUud/Ma3EzpQtMesAaH2y2NGX6OrJQEHE11qMuamY3Of37WMK/VsEuWKlO6XC2FcnXawqJ2x4oVFQ4DSDUscC8xLIV1h/DJx8zhlRcLImwom/Ur+CLPBfEWxLYtX8syB1SID8kJ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=hSYWo2EM; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1723013332; x=1754549332;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jV7x65iO3TS+Xtz93B1NNcsREThnhf6CB1pAqiiBCL0=;
  b=hSYWo2EMTJjWMeDRfTrdKXREF3BwyJC55d6siyWapmJBZu9CH5XpvkXV
   sprv9qLjB/xo7J+h6gRSGgCGEv9qU4XsojXz3+EOBs+y9DGbYDEAReFts
   Q913+odX7pZqckm5uTy0mIpz+2+3YfzTTN5zS8yRInEle5U4Wvw1dn9vf
   o=;
X-IronPort-AV: E=Sophos;i="6.09,269,1716249600"; 
   d="scan'208";a="672481162"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2024 06:48:48 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:33616]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.27.192:2525] with esmtp (Farcaster)
 id 1baea4c4-6fee-4395-9bcf-6df811592900; Wed, 7 Aug 2024 06:48:47 +0000 (UTC)
X-Farcaster-Flow-ID: 1baea4c4-6fee-4395-9bcf-6df811592900
Received: from EX19D003UWB002.ant.amazon.com (10.13.138.11) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 7 Aug 2024 06:48:44 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D003UWB002.ant.amazon.com (10.13.138.11) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 7 Aug 2024 06:48:44 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Wed, 7 Aug 2024 06:48:40 +0000
Message-ID: <a43ae745-9907-425f-b09d-a49405d6bc2d@amazon.co.uk>
Date: Wed, 7 Aug 2024 07:48:38 +0100
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
In-Reply-To: <20240806104702482-0700.eberman@hu-eberman-lv.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit



On Tue, 2024-08-06 at 21:13 +0100, Elliot Berman wrote:
> On Tue, Aug 06, 2024 at 04:39:24PM +0100, Patrick Roy wrote:
>>
>> Hi Elliot,
>>
>> On Mon, 2024-08-05 at 19:34 +0100, Elliot Berman wrote:
>>> This patch was reworked from Patrick's patch:
>>> https://lore.kernel.org/all/20240709132041.3625501-6-roypat@amazon.co.uk/
>>
>> yaay :D
>>
>>> While guest_memfd is not available to be mapped by userspace, it is
>>> still accessible through the kernel's direct map. This means that in
>>> scenarios where guest-private memory is not hardware protected, it can
>>> be speculatively read and its contents potentially leaked through
>>> hardware side-channels. Removing guest-private memory from the direct
>>> map, thus mitigates a large class of speculative execution issues
>>> [1, Table 1].
>>>
>>> Direct map removal do not reuse the `.prepare` machinery, since
>>> `prepare` can be called multiple time, and it is the responsibility of
>>> the preparation routine to not "prepare" the same folio twice [2]. Thus,
>>> instead explicitly check if `filemap_grab_folio` allocated a new folio,
>>> and remove the returned folio from the direct map only if this was the
>>> case.
>>
>> My patch did this, but you separated the PG_uptodate logic from the
>> direct map removal, right?
>>
>>> The patch uses release_folio instead of free_folio to reinsert pages
>>> back into the direct map as by the time free_folio is called,
>>> folio->mapping can already be NULL. This means that a call to
>>> folio_inode inside free_folio might deference a NULL pointer, leaving no
>>> way to access the inode which stores the flags that allow determining
>>> whether the page was removed from the direct map in the first place.
>>
>> I thought release_folio was only called for folios with PG_private=1?
>> You choose PG_private=1 to mean "this folio is in the direct map", so it
>> gets called for exactly the wrong folios (more on that below, too).
>>
> 
> PG_private=1 should be meaning "this folio is not in the direct map".

Right. I just checked my patch and it indeed means the same there. No
idea what I was on about yesterday. I think I only had Paolo's comment
about using folio->private for refcounting sharings in mind, so I
thought "to use folio->private, you need PG_private=1, therefore
PG_private=1 means shared" (I just checked, and while
folio_attach_private causes PG_private=1 to be set, page_set_private
does not). Obviously my comments below and especially here on PG_private
were nonsense. Sorry about that!

>>> [1]: https://download.vusec.net/papers/quarantine_raid23.pdf
>>>
>>> Cc: Patrick Roy <roypat@amazon.co.uk>
>>> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
>>> ---
>>>  include/linux/guest_memfd.h |  8 ++++++
>>>  mm/guest_memfd.c            | 65 ++++++++++++++++++++++++++++++++++++++++++++-
>>>  2 files changed, 72 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
>>> index be56d9d53067..f9e4a27aed67 100644
>>> --- a/include/linux/guest_memfd.h
>>> +++ b/include/linux/guest_memfd.h
>>> @@ -25,6 +25,14 @@ struct guest_memfd_operations {
>>>         int (*release)(struct inode *inode);
>>>  };
>>>
>>> +/**
>>> + * @GUEST_MEMFD_FLAG_NO_DIRECT_MAP: When making folios inaccessible by host, also
>>> + *                                  remove them from the kernel's direct map.
>>> + */
>>> +enum {
>>> +       GUEST_MEMFD_FLAG_NO_DIRECT_MAP          = BIT(0),
>>> +};
>>> +
>>>  /**
>>>   * @GUEST_MEMFD_GRAB_UPTODATE: Ensure pages are zeroed/up to date.
>>>   *                             If trusted hyp will do it, can ommit this flag
>>> diff --git a/mm/guest_memfd.c b/mm/guest_memfd.c
>>> index 580138b0f9d4..e9d8cab72b28 100644
>>> --- a/mm/guest_memfd.c
>>> +++ b/mm/guest_memfd.c
>>> @@ -7,9 +7,55 @@
>>>  #include <linux/falloc.h>
>>>  #include <linux/guest_memfd.h>
>>>  #include <linux/pagemap.h>
>>> +#include <linux/set_memory.h>
>>> +
>>> +static inline int guest_memfd_folio_private(struct folio *folio)
>>> +{
>>> +       unsigned long nr_pages = folio_nr_pages(folio);
>>> +       unsigned long i;
>>> +       int r;
>>> +
>>> +       for (i = 0; i < nr_pages; i++) {
>>> +               struct page *page = folio_page(folio, i);
>>> +
>>> +               r = set_direct_map_invalid_noflush(page);
>>> +               if (r < 0)
>>> +                       goto out_remap;
>>> +       }
>>> +
>>> +       folio_set_private(folio);
>>
>> Mh, you've inverted the semantics of PG_private in the context of gmem
>> here, compared to my patch. For me, PG_private=1 meant "this folio is
>> back in the direct map". For you it means "this folio is removed from
>> the direct map".
>>
>> Could you elaborate on why you require these different semantics for
>> PG_private? Actually, I think in this patch series, you could just drop
>> the PG_private stuff altogether, as the only place you do
>> folio_test_private is in guest_memfd_clear_private, but iirc calling
>> set_direct_map_default_noflush on a page that's already in the direct
>> map is a NOOP anyway.
>>
>> On the other hand, as Paolo pointed out in my patches [1], just using a
>> page flag to track direct map presence for gmem is not enough. We
>> actually need to keep a refcount in folio->private to keep track of how
>> many different actors request a folio's direct map presence (in the
>> specific case in my patch series, it was different pfn_to_gfn_caches for
>> the kvm-clock structures of different vcpus, which the guest can place
>> into the same gfn). While this might not be a concern for the the
>> pKVM/Gunyah case, where the guest dictates memory state, it's required
>> for the non-CoCo case where KVM/userspace can set arbitrary guest gfns
>> to shared if it needs/wants to access them for whatever reason. So for
>> this we'd need to have PG_private=1 mean "direct map entry restored" (as
>> if PG_private=0, there is no folio->private).
>>
>> [1]: https://lore.kernel.org/kvm/20240709132041.3625501-1-roypat@amazon.co.uk/T/#m0608c4b6a069b3953d7ee97f48577d32688a3315
>>
> 
> I wonder if we can use the folio refcount itself, assuming we can rely
> on refcount == 1 means we can do shared->private conversion.
> 
> In gpc_map_gmem, we convert private->shared. There's no problem here in
> the non-CoCo case.
> 
> In gpc_unmap, we *try* to convert back from shared->private. If
> refcount>2, then the conversion would fail. The last gpc_unmap would be
> able to successfully convert back to private.
> 
> Do you see any concerns with this approach?

The gfn_to_pfn_cache does not keep an elevated refcount on the cached
page, and instead responds to MMU notifiers to detect whether the cached
translation has been invalidated, iirc. So the folio refcount will
not reflect the number of gpcs holding that folio.

>>> +       return 0;
>>> +out_remap:
>>> +       for (; i > 0; i--) {
>>> +               struct page *page = folio_page(folio, i - 1);
>>> +
>>> +               BUG_ON(set_direct_map_default_noflush(page));
>>> +       }
>>> +       return r;
>>> +}
>>> +
>>> +static inline void guest_memfd_folio_clear_private(struct folio *folio)
>>> +{
>>> +       unsigned long start = (unsigned long)folio_address(folio);
>>> +       unsigned long nr = folio_nr_pages(folio);
>>> +       unsigned long i;
>>> +
>>> +       if (!folio_test_private(folio))
>>> +               return;
>>> +
>>> +       for (i = 0; i < nr; i++) {
>>> +               struct page *page = folio_page(folio, i);
>>> +
>>> +               BUG_ON(set_direct_map_default_noflush(page));
>>> +       }
>>> +       flush_tlb_kernel_range(start, start + folio_size(folio));
>>> +
>>> +       folio_clear_private(folio);
>>> +}
>>>
>>>  struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags)
>>>  {
>>> +       unsigned long gmem_flags = (unsigned long)file->private_data;
>>>         struct inode *inode = file_inode(file);
>>>         struct guest_memfd_operations *ops = inode->i_private;
>>>         struct folio *folio;
>>> @@ -43,6 +89,12 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
>>>                         goto out_err;
>>>         }
>>>
>>> +       if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
>>> +               r = guest_memfd_folio_private(folio);
>>> +               if (r)
>>> +                       goto out_err;
>>> +       }
>>> +
>>
>> How does a caller of guest_memfd_grab_folio know whether a folio needs
>> to be removed from the direct map? E.g. how can a caller know ahead of
>> time whether guest_memfd_grab_folio will return a freshly allocated
>> folio (which thus needs to be removed from the direct map), vs a folio
>> that already exists and has been removed from the direct map (probably
>> fine to remove from direct map again), vs a folio that already exists
>> and is currently re-inserted into the direct map for whatever reason
>> (must not remove these from the direct map, as other parts of
>> KVM/userspace probably don't expect the direct map entries to disappear
>> from underneath them). I couldn't figure this one out for my series,
>> which is why I went with hooking into the PG_uptodate logic to always
>> remove direct map entries on freshly allocated folios.
>>
> 
> gmem_flags come from the owner. If the caller (in non-CoCo case) wants
> to restore the direct map right away, it'd have to be a direct
> operation. As an optimization, we could add option that asks for page in
> "shared" state. If allocating new page, we can return it right away
> without removing from direct map. If grabbing existing folio, it would
> try to do the private->shared conversion.
> 
> Thanks for the feedback, it was helpful!
> 
> - Elliot
> 
>>>         /*
>>>          * Ignore accessed, referenced, and dirty flags.  The memory is
>>>          * unevictable and there is no storage to write back to.
>>> @@ -213,14 +265,25 @@ static bool gmem_release_folio(struct folio *folio, gfp_t gfp)
>>>         if (ops->invalidate_end)
>>>                 ops->invalidate_end(inode, offset, nr);
>>>
>>> +       guest_memfd_folio_clear_private(folio);
>>> +
>>>         return true;
>>>  }
>>>
>>> +static void gmem_invalidate_folio(struct folio *folio, size_t offset, size_t len)
>>> +{
>>> +       /* not yet supported */
>>> +       BUG_ON(offset || len != folio_size(folio));
>>> +
>>> +       BUG_ON(!gmem_release_folio(folio, 0));
>>> +}
>>> +
>>>  static const struct address_space_operations gmem_aops = {
>>>         .dirty_folio = noop_dirty_folio,
>>>         .migrate_folio = gmem_migrate_folio,
>>>         .error_remove_folio = gmem_error_folio,
>>>         .release_folio = gmem_release_folio,
>>> +       .invalidate_folio = gmem_invalidate_folio,
>>>  };
>>>
>>>  static inline bool guest_memfd_check_ops(const struct guest_memfd_operations *ops)
>>> @@ -241,7 +304,7 @@ struct file *guest_memfd_alloc(const char *name,
>>>         if (!guest_memfd_check_ops(ops))
>>>                 return ERR_PTR(-EINVAL);
>>>
>>> -       if (flags)
>>> +       if (flags & ~GUEST_MEMFD_FLAG_NO_DIRECT_MAP)
>>>                 return ERR_PTR(-EINVAL);
>>>
>>>         /*
>>>
>>> --
>>> 2.34.1
>>>
>>
>> Best,
>> Patrick
>>

