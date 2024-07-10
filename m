Return-Path: <kvm+bounces-21294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A71E792CE8F
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 11:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26C291F25D6A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 09:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C1B18FA22;
	Wed, 10 Jul 2024 09:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="imafzhno"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E252B9C6;
	Wed, 10 Jul 2024 09:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720605034; cv=none; b=ZxJrP3O6FVeC94gsXoL1jRS+2oRIXgjWgShviDQmY07F/Qg+rCoErrQxFRxKvFdTLnMh9jRiiIJJ7IMkWOlja591qQrD5AHfY9Tpeiol0bH6LK6BILrg989dAOA3Kw67YzZNPuyv0w8xb5hJthb+3tJaYL3JzrxEb1SZbFa1cYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720605034; c=relaxed/simple;
	bh=5j3t/4h4vgQ6sDDuX+uvlZZfLBTPpEgN7FZYIN61XJs=;
	h=Subject:Message-ID:Date:MIME-Version:To:CC:References:From:
	 In-Reply-To:Content-Type; b=X9zK0N2YSPm3iOI1Rtl1W/ij4gRPgLNgV5PwVkxi1rV7Pl9e97RtSx1XyhK04Ak3wlCrBbee3fjPreFftMrYQZuaRSLD3D4JrHLI+W5rqKM+Jglr+IGQ38lGx+DmpCbxVVyKxI4zVnR+fa/alUEXvBBL24XkbMLs9TV8RjB3YPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=imafzhno; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720605032; x=1752141032;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=dYTmFcHdmGbTSncYotZh/3PZwTbMci/IhGcXFfl9zcQ=;
  b=imafzhnocrbmm3aZPrAUwB47Po9iKKLG+m0ZUBqauiLiuAF5XlRE2i47
   dgG/NklbCG/vGQkxqoXvBPKTqWGE9EPoas2uOe3G67xJOzYA5RsqR4Fr3
   Rhsz7bACeoEs7vh7pYUacR57hVUGt9+VFMp2NUf9QDkG02vZQqoioatxq
   4=;
X-IronPort-AV: E=Sophos;i="6.09,197,1716249600"; 
   d="scan'208";a="419099797"
Subject: Re: [RFC PATCH 5/8] kvm: gmem: add option to remove guest private memory
 from direct map
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 09:50:27 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.38.20:41845]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.8.122:2525] with esmtp (Farcaster)
 id 445b54b0-2c40-4a3b-b2e2-ce0338a1fa42; Wed, 10 Jul 2024 09:50:26 +0000 (UTC)
X-Farcaster-Flow-ID: 445b54b0-2c40-4a3b-b2e2-ce0338a1fa42
Received: from EX19D003UWB003.ant.amazon.com (10.13.138.116) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 09:50:21 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D003UWB003.ant.amazon.com (10.13.138.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 09:50:20 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Wed, 10 Jul 2024 09:50:16 +0000
Message-ID: <576c2316-80c3-47f0-9af4-86daa48bdc16@amazon.co.uk>
Date: Wed, 10 Jul 2024 10:50:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Mike Rapoport <rppt@kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <akpm@linux-foundation.org>,
	<dwmw@amazon.co.uk>, <david@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <willy@infradead.org>, <graf@amazon.com>,
	<derekmn@amazon.com>, <kalyazin@amazon.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <dmatlack@google.com>,
	<tabba@google.com>, <chao.p.peng@linux.intel.com>, <xmarcalx@amazon.co.uk>,
	James Gowans <jgowans@amazon.com>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
 <20240709132041.3625501-6-roypat@amazon.co.uk> <Zo441yz7Yw2JZcPs@kernel.org>
Content-Language: en-US
From: Patrick Roy <roypat@amazon.co.uk>
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
In-Reply-To: <Zo441yz7Yw2JZcPs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit



On 7/10/24 08:31, Mike Rapoport wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On Tue, Jul 09, 2024 at 02:20:33PM +0100, Patrick Roy wrote:
>> While guest_memfd is not available to be mapped by userspace, it is
>> still accessible through the kernel's direct map. This means that in
>> scenarios where guest-private memory is not hardware protected, it can
>> be speculatively read and its contents potentially leaked through
>> hardware side-channels. Removing guest-private memory from the direct
>> map, thus mitigates a large class of speculative execution issues
>> [1, Table 1].
>>
>> This patch adds a flag to the `KVM_CREATE_GUEST_MEMFD` which, if set, removes the
>> struct pages backing guest-private memory from the direct map. Should
>> `CONFIG_HAVE_KVM_GMEM_{INVALIDATE, PREPARE}` be set, pages are removed
>> after preparation and before invalidation, so that the
>> prepare/invalidate routines do not have to worry about potentially
>> absent direct map entries.
>>
>> Direct map removal do not reuse the `KVM_GMEM_PREPARE` machinery, since `prepare` can be
>> called multiple time, and it is the responsibility of the preparation
>> routine to not "prepare" the same folio twice [2]. Thus, instead
>> explicitly check if `filemap_grab_folio` allocated a new folio, and
>> remove the returned folio from the direct map only if this was the case.
>>
>> The patch uses release_folio instead of free_folio to reinsert pages
>> back into the direct map as by the time free_folio is called,
>> folio->mapping can already be NULL. This means that a call to
>> folio_inode inside free_folio might deference a NULL pointer, leaving no
>> way to access the inode which stores the flags that allow determining
>> whether the page was removed from the direct map in the first place.
>>
>> Lastly, the patch uses set_direct_map_{invalid,default}_noflush instead
>> of `set_memory_[n]p` to avoid expensive flushes of TLBs and the L*-cache
>> hierarchy. This is especially important once KVM restores direct map
>> entries on-demand in later patches, where simple FIO benchmarks of a
>> virtio-blk device have shown that TLB flushes on a Intel(R) Xeon(R)
>> Platinum 8375C CPU @ 2.90GHz resulted in 80% degradation in throughput
>> compared to a non-flushing solution.
>>
>> Not flushing the TLB means that until TLB entries for temporarily
>> restored direct map entries get naturally evicted, they can be used
>> during speculative execution, and effectively "unhide" the memory for
>> longer than intended. We consider this acceptable, as the only pages
>> that are temporarily reinserted into the direct map like this will
>> either hold PV data structures (kvm-clock, asyncpf, etc), or pages
>> containing privileged instructions inside the guest kernel image (in the
>> MMIO emulation case).
>>
>> [1]: https://download.vusec.net/papers/quarantine_raid23.pdf
>>
>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
>> ---
>>  include/uapi/linux/kvm.h |  2 ++
>>  virt/kvm/guest_memfd.c   | 52 ++++++++++++++++++++++++++++++++++------
>>  2 files changed, 47 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index e065d9fe7ab2..409116aa23c9 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1563,4 +1563,6 @@ struct kvm_create_guest_memfd {
>>       __u64 reserved[6];
>>  };
>>
>> +#define KVM_GMEM_NO_DIRECT_MAP                 (1ULL << 0)
>> +
>>  #endif /* __LINUX_KVM_H */
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 9148b9679bb1..dc9b0c2d0b0e 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -4,6 +4,7 @@
>>  #include <linux/kvm_host.h>
>>  #include <linux/pagemap.h>
>>  #include <linux/anon_inodes.h>
>> +#include <linux/set_memory.h>
>>
>>  #include "kvm_mm.h"
>>
>> @@ -49,9 +50,16 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
>>       return 0;
>>  }
>>
>> +static bool kvm_gmem_not_present(struct inode *inode)
>> +{
>> +     return ((unsigned long)inode->i_private & KVM_GMEM_NO_DIRECT_MAP) != 0;
>> +}
>> +
>>  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
>>  {
>>       struct folio *folio;
>> +     bool zap_direct_map = false;
>> +     int r;
>>
>>       /* TODO: Support huge pages. */
>>       folio = filemap_grab_folio(inode->i_mapping, index);
>> @@ -74,16 +82,30 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool
>>               for (i = 0; i < nr_pages; i++)
>>                       clear_highpage(folio_page(folio, i));
>>
>> +             // We need to clear the folio before calling kvm_gmem_prepare_folio,
>> +             // but can only remove it from the direct map _after_ preparation is done.
> 
> No C++ comments please
> 

Ack, sorry, will avoid in the future!

>> +             zap_direct_map = kvm_gmem_not_present(inode);
>> +
>>               folio_mark_uptodate(folio);
>>       }
>>
>>       if (prepare) {
>> -             int r = kvm_gmem_prepare_folio(inode, index, folio);
>> -             if (r < 0) {
>> -                     folio_unlock(folio);
>> -                     folio_put(folio);
>> -                     return ERR_PTR(r);
>> -             }
>> +             r = kvm_gmem_prepare_folio(inode, index, folio);
>> +             if (r < 0)
>> +                     goto out_err;
>> +     }
>> +
>> +     if (zap_direct_map) {
>> +             r = set_direct_map_invalid_noflush(&folio->page);
> 
> It's not future proof to presume that folio is a single page here.
> You should loop over folio pages and add a TLB flush after the loop.
>

Right, will do the folio iteration thing (and same for all other places
I call the direct_map* functions in this RFC)! 

I'll also have a look at the TLB flush. I specifically avoided using
set_memory_np here because the flushes it did (TLB + L1/2/3) had
significant performance impact (see cover letter). I'll have to rerun my
benchmark with set_direct_map_invalid_noflush + flush_tlb_kernel_range
instead, but if the result is similar, and we really need the flush here
for correctness, I might have to go back to the drawing board about this
whole on-demand mapping approach :(

>> +             if (r < 0)
>> +                     goto out_err;
>> +
>> +             // We use the private flag to track whether the folio has been removed
>> +             // from the direct map. This is because inside of ->free_folio,
>> +             // we do not have access to the address_space anymore, meaning we
>> +             // cannot check folio_inode(folio)->i_private to determine whether
>> +             // KVM_GMEM_NO_DIRECT_MAP was set.
>> +             folio_set_private(folio);
>>       }
>>
>>       /*
>> @@ -91,6 +113,10 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool
>>        * unevictable and there is no storage to write back to.
>>        */
>>       return folio;
>> +out_err:
>> +     folio_unlock(folio);
>> +     folio_put(folio);
>> +     return ERR_PTR(r);
>>  }
>>
>>  static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
>> @@ -354,10 +380,22 @@ static void kvm_gmem_free_folio(struct folio *folio)
>>  }
>>  #endif
>>
>> +static void kvm_gmem_invalidate_folio(struct folio *folio, size_t start, size_t end)
>> +{
>> +     if (start == 0 && end == PAGE_SIZE) {
>> +             // We only get here if PG_private is set, which only happens if kvm_gmem_not_present
>> +             // returned true in kvm_gmem_get_folio. Thus no need to do that check again.
>> +             BUG_ON(set_direct_map_default_noflush(&folio->page));
> 
> Ditto.
> 
>> +
>> +             folio_clear_private(folio);
>> +     }
>> +}
>> +
>>  static const struct address_space_operations kvm_gmem_aops = {
>>       .dirty_folio = noop_dirty_folio,
>>       .migrate_folio  = kvm_gmem_migrate_folio,
>>       .error_remove_folio = kvm_gmem_error_folio,
>> +     .invalidate_folio = kvm_gmem_invalidate_folio,
>>  #ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
>>       .free_folio = kvm_gmem_free_folio,
>>  #endif
>> @@ -443,7 +481,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>>  {
>>       loff_t size = args->size;
>>       u64 flags = args->flags;
>> -     u64 valid_flags = 0;
>> +     u64 valid_flags = KVM_GMEM_NO_DIRECT_MAP;
>>
>>       if (flags & ~valid_flags)
>>               return -EINVAL;
>> --
>> 2.45.2
>>
> 
> --
> Sincerely yours,
> Mike.

