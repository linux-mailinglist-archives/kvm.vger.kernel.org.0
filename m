Return-Path: <kvm+bounces-23626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 830A994BE27
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:06:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3206D28C8C7
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 13:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F82218E036;
	Thu,  8 Aug 2024 13:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="Dkt/PdFJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B12818DF6B;
	Thu,  8 Aug 2024 13:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723122366; cv=none; b=H+GKeCxGPwMbzLbhUzXD27hLlHEmvRW9GRGn9AHsAeA4f8FiSmLhulCod4fagho+dsoaYTsCJqLnp3XwJP9dlGcvORppf3GDNToJbgmR2SWN2PL10fdmdjJxa+baDQnM5XGngjVfHFUnOoKr9H4xN8Lylaplvynl5GabK0HftXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723122366; c=relaxed/simple;
	bh=Z/AFNCPiVJkrk9j7c1DJF4ygTrDpXqXaKLR9fjJprX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pF5F8JKewEMfJ+tw8sFsKjMcbVJ43gvn3mqERLBDTVD2j/vI2EoE28pWh/wXbnwVgJA1WkecWDQ9OGeTRgn99F32xk7c0zDw3lES3GEoUdcxm0LjjoNOq2cgk/M9NE/RCLmy/FYh4z3rqmox5YKugq9KEm/0/a4XbIYY6MIaW4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=Dkt/PdFJ; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1723122362; x=1754658362;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9g61wWgfXANiP3Mk9EmQM853vN4OhDo4yz4sW5Htiuc=;
  b=Dkt/PdFJfnTfq5LMOfOl35KO/kRfRGKKMhcn2iGTJ1PeRf2l4Th+urri
   GR1IXAHh4LUCDMnmHPEt2LaH3njHL7Z4n73m0o8+BQXBkwL2oUwmXt0cW
   SAO9SQw//oWwBO64mN3JPd34kkgoQ7F9YlE+MDg+Loi9eP1gZ7mr9Cyxs
   I=;
X-IronPort-AV: E=Sophos;i="6.09,273,1716249600"; 
   d="scan'208";a="224200239"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 13:05:59 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:21437]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.15.209:2525] with esmtp (Farcaster)
 id 21dfb1b8-4d13-4b1a-8914-0ab7d48b3223; Thu, 8 Aug 2024 13:05:59 +0000 (UTC)
X-Farcaster-Flow-ID: 21dfb1b8-4d13-4b1a-8914-0ab7d48b3223
Received: from EX19D014EUA003.ant.amazon.com (10.252.50.119) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 8 Aug 2024 13:05:58 +0000
Received: from EX19MTAUEA001.ant.amazon.com (10.252.134.203) by
 EX19D014EUA003.ant.amazon.com (10.252.50.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 8 Aug 2024 13:05:58 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.252.134.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Thu, 8 Aug 2024 13:05:56 +0000
Message-ID: <7166d51c-7757-44f2-a6f8-36da3e86bf90@amazon.co.uk>
Date: Thu, 8 Aug 2024 14:05:55 +0100
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
In-Reply-To: <20240807113514068-0700.eberman@hu-eberman-lv.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2024-08-07 at 20:06 +0100, Elliot Berman wrote:
>>>>>>  struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags)
>>>>>>  {
>>>>>> +       unsigned long gmem_flags = (unsigned long)file->private_data;
>>>>>>         struct inode *inode = file_inode(file);
>>>>>>         struct guest_memfd_operations *ops = inode->i_private;
>>>>>>         struct folio *folio;
>>>>>> @@ -43,6 +89,12 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
>>>>>>                         goto out_err;
>>>>>>         }
>>>>>>
>>>>>> +       if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
>>>>>> +               r = guest_memfd_folio_private(folio);
>>>>>> +               if (r)
>>>>>> +                       goto out_err;
>>>>>> +       }
>>>>>> +
>>>>>
>>>>> How does a caller of guest_memfd_grab_folio know whether a folio needs
>>>>> to be removed from the direct map? E.g. how can a caller know ahead of
>>>>> time whether guest_memfd_grab_folio will return a freshly allocated
>>>>> folio (which thus needs to be removed from the direct map), vs a folio
>>>>> that already exists and has been removed from the direct map (probably
>>>>> fine to remove from direct map again), vs a folio that already exists
>>>>> and is currently re-inserted into the direct map for whatever reason
>>>>> (must not remove these from the direct map, as other parts of
>>>>> KVM/userspace probably don't expect the direct map entries to disappear
>>>>> from underneath them). I couldn't figure this one out for my series,
>>>>> which is why I went with hooking into the PG_uptodate logic to always
>>>>> remove direct map entries on freshly allocated folios.
>>>>>
>>>>
>>>> gmem_flags come from the owner. If the caller (in non-CoCo case) wants
>>
>> Ah, oops, I got it mixed up with the new `flags` parameter.
>>
>>>> to restore the direct map right away, it'd have to be a direct
>>>> operation. As an optimization, we could add option that asks for page in
>>>> "shared" state. If allocating new page, we can return it right away
>>>> without removing from direct map. If grabbing existing folio, it would
>>>> try to do the private->shared conversion.
>>
>> My concern is more with the implicit shared->private conversion that
>> happens on every call to guest_memfd_grab_folio (and thus
>> kvm_gmem_get_pfn) when grabbing existing folios. If something else
>> marked the folio as shared, then we cannot punch it out of the direct
>> map again until that something is done using the folio (when working on
>> my RFC, kvm_gmem_get_pfn was indeed called on existing folios that were
>> temporarily marked shared, as I was seeing panics because of this). And
>> if the folio is currently private, there's nothing to do. So either way,
>> guest_memfd_grab_folio shouldn't touch the direct map entry for existing
>> folios.
>>
>
> What I did could be documented/commented better.

No worries, thanks for taking the time to walk me through understanding
it!

> If ops->accessible() is *not* provided, all guest_memfd allocations will
> immediately remove from direct map and treat them immediately like guest
> private (goal is to match what KVM does today on tip).

Ah, so if ops->accessible() is not provided, then there will never be
any shared memory inside gmem (like today, where gmem doesn't support
shared memory altogether), and thus there's no problems with just
unconditionally doing set_direct_map_invalid_noflush in
guest_memfd_grab_folio, because all existing folios already have their
direct map entry removed. Got it!

> If ops->accessible() is provided, then guest_memfd allocations start
> as "shared" and KVM/Gunyah need to do the shared->private conversion
> when they want to do the private conversion on the folio. "Shared" is
> the default because that is effectively a no-op.
> For the non-CoCo case you're interested in, we'd have the
> ops->accessible() provided and we wouldn't pull out the direct map from
> gpc.

So in pKVM/Gunyah's case, guest memory starts as shared, and at some
point the guest will issue a hypercall (or similar) to flip it to
private, at which point it'll get removed from the direct map?

That isn't really what we want for our case. We consider the folios as
private straight away, as we do not let the guest control their state at
all. Everything is always "accessible" to both KVM and userspace in the
sense that they can just flip gfns to shared as they please without the
guest having any say in it.

I think we should untangle the behavior of guest_memfd_grab_folio from
the presence of ops->accessible. E.g.  instead of direct map removal
being dependent on ops->accessible we should have some
GRAB_FOLIO_RETURN_SHARED flag for gmem_flags, which is set for y'all,
and not set for us (I don't think we should have a "call
set_direct_map_invalid_noflush unconditionally in
guest_memfd_grab_folio" mode at all, because if sharing gmem is
supported, then that is broken, and if sharing gmem is not supported
then only removing direct map entries for freshly allocated folios gets
us the same result of "all folios never in the direct map" while
avoiding some no-op direct map operations).

Because we would still use ->accessible, albeit for us that would be
more for bookkeeping along the lines of "which gfns does userspace
currently require to be in the direct map?". I haven't completely
thought it through, but what I could see working for us would be a pair
of ioctls for marking ranges accessible/inaccessible, with
"accessibility" stored in some xarray (somewhat like Fuad's patches, I
guess? [1]).

In a world where we have a "sharing refcount", the "make accessible"
ioctl reinserts into the direct map (if needed), lifts the "sharings
refcount" for each folio in the given gfn range, and marks the range as
accessible.  And the "make inaccessible" ioctl would first check that
userspace has unmapped all those gfns again, and if yes, mark them as
inaccessible, drop the "sharings refcount" by 1 for each, and removes
from the direct map again if it held the last reference (if userspace
still has some gfns mapped, the ioctl would just fail).

I guess for pKVM/Gunyah, there wouldn't be userspace ioctls, but instead
the above would happen in handlers for share/unshare hypercalls. But the
overall flow would be similar. The only difference is the default state
of guest memory (shared for you, private for us). You want a
guest_memfd_grab_folio that essentially returns folios with "sharing
refcount == 1" (and thus present in the direct map), while we want the
opposite.

So I think something like the following should work for both of us
(modulo some error handling):

static struct folio *__kvm_gmem_get_folio(struct file *file, pgoff_t index, bool prepare, bool *fresh)
{
    // as today's kvm_gmem_get_folio, except
    ...
    if (!folio_test_uptodate(folio)) {
        ...
        if (fresh)
            *fresh = true
    }
    ...
}

struct folio *kvm_gmem_get_folio(struct file *file, pgoff_t index, bool prepare)
{
    bool fresh;
    unsigned long gmem_flags = /* ... */
    struct folio *folio = __kvm_gmem_get_folio(file, index, prepare, &fresh);
    if (gmem_flag & GRAB_FOLIO_RETURN_SHARED != 0) {
        // if "sharing refcount == 0", inserts back into direct map and lifts refcount, otherwise just lifts refcount
        guest_memfd_folio_clear_private(folio);
    } else {
        if (fresh)
            guest_memfd_folio_private(folio);
    }
    return folio;
}

Now, thinking ahead, there's probably optimizations here where we defer
the direct map manipulations to gmem_fault, at which point having a
guest_memfd_grab_folio that doesn't remove direct map entries for fresh
folios would be useful in our non-CoCo usecase too. But that should also
be easily achievable by maybe having a flag to kvm_gmem_get_folio that
forces the behavior of GRAB_FOLIO_RETURN_SHARED, indendently of whether
GRAB_FOLIO_RETURN_SHARED is set in gmem_flags.

How does that sound to you?

[1]: https://lore.kernel.org/kvm/20240801090117.3841080-1-tabba@google.com/

> Thanks,
> Elliot

Best,
Patrick

