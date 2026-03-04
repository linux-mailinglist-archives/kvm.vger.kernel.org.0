Return-Path: <kvm+bounces-72708-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2fPgMmJpqGnYuQAAu9opvQ
	(envelope-from <kvm+bounces-72708-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:18:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C5C2050CB
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8503A3001A4F
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 17:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2949137AA76;
	Wed,  4 Mar 2026 17:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="J0WQJQPq"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715E13BB40;
	Wed,  4 Mar 2026 17:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.72.182.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772644664; cv=none; b=dh1EkDcnDymr79fu6U7C5a8jQyX4kip8jTmUb38i52YlTUHM17M2qfdjaPz1tf4wAb+xkQH8z/MCAAAIaxiwj95yKap72MfSBu2tpwiPAniIhN7PgESMvfQ1ZQC+xw+fjYDvxGCXgB/4tzG6DY4+fjj++8ftXJuaD1n/y5u6f4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772644664; c=relaxed/simple;
	bh=zS2IoNgFK8GIs84v988v1Gkqxk5O7Ci+V3bJWkZ2u/A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=CeUJxpVPfmP/h2Pfb5YOWk+oTRTX7hngWVrZMI9tZxQ3iihuXrb9MpZarbbaEek7xo35dMg+ReQtWo1lYpcY0G2zMJ/gCkZ+yRz9eqTVHS5l2T/tdgPyEaIe8sdpVcceZLHqLbDyAmfJhK73nC3ZJRpA3fkXwRc/Klkb7v6I0dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=J0WQJQPq; arc=none smtp.client-ip=3.72.182.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772644662; x=1804180662;
  h=message-id:date:mime-version:reply-to:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=CPgNxadSzjpIoq3NwpOhLARCcrCv7zz8pTRRdyXfzUA=;
  b=J0WQJQPqEl0uJjsubbOKOEHZ/x1kaN6Uq/wbj2RAGuAQifR6srWYEkvM
   rWcKhZWdBJYIFFrZTxofYos0fqKR8sjUNCmN37Ca2m1ysijEku1RNniFf
   Qwb2EprjDfiVHEAY64ez//hVNU1GiDlB8Tb+6HlaxAuON2+z7vCiDt8Y4
   23CEpTa9Q99yImA768Ad5OpSWM3oksfKlnI1NhsaeNiR+kA8QDZs9TZ3j
   aQUdnr6iRn17MvoK+khDgvkg3kHMjWgIAZQsBy+rt9zd8yoHm3iNMXnuk
   kJldyXbK6w1t2KbsWo4Q/RVIvROorb0gIcxDFeT+tfibdHbsXFzlbblC7
   g==;
X-CSE-ConnectionGUID: kCX+YtFiRNyIDKqonzWj2Q==
X-CSE-MsgGUID: rCpAbOjCT3KIJvBbO/BAqg==
X-IronPort-AV: E=Sophos;i="6.21,324,1763424000"; 
   d="scan'208";a="10324163"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 17:17:37 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.233:10769]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.50:2525] with esmtp (Farcaster)
 id 5c685bb8-c81d-4b86-ac12-2b82286bbda5; Wed, 4 Mar 2026 17:17:36 +0000 (UTC)
X-Farcaster-Flow-ID: 5c685bb8-c81d-4b86-ac12-2b82286bbda5
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 4 Mar 2026 17:17:30 +0000
Received: from [192.168.5.225] (10.106.83.18) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Wed, 4 Mar 2026
 17:17:29 +0000
Message-ID: <11b78807-00c3-4131-932c-7e32053f9531@amazon.com>
Date: Wed, 4 Mar 2026 17:17:28 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH RFC 15/17] KVM: guest_memfd: implement userfaultfd missing
 mode
From: Nikita Kalyazin <kalyazin@amazon.com>
To: Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu
	<peterx@redhat.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan
	<shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
	<vbabka@suse.cz>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, "david@kernel.org" <david@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-16-rppt@kernel.org>
 <90cf68db-2e21-4153-8eb6-2c8ffb398d0d@amazon.com>
Content-Language: en-US
In-Reply-To: <90cf68db-2e21-4153-8eb6-2c8ffb398d0d@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D013EUA004.ant.amazon.com (10.252.50.48) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: D0C5C2050CB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-9.16 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72708-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kalyazin@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	HAS_REPLYTO(0.00)[kalyazin@amazon.com];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

+ David's new email


On 04/03/2026 17:12, Nikita Kalyazin wrote:
> 
> 
> On 27/01/2026 19:29, Mike Rapoport wrote:
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
>> userfaultfd missing mode allows populating guest memory with the content
>> supplied by userspace on demand.
>>
>> Extend guest_memfd implementation of vm_uffd_ops to support MISSING
>> mode.
>>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>>   virt/kvm/guest_memfd.c | 60 +++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 59 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 087e7632bf70..14cca057fc0e 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -431,6 +431,14 @@ static vm_fault_t 
>> kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>>                          ret = VM_FAULT_UFFD_MINOR;
>>                          goto out_folio;
>>                  }
>> +
>> +               /*
>> +                * Check if userfaultfd is registered in missing mode. 
>> If so,
>> +                * check if a folio exists in the page cache. If not, 
>> return
>> +                * VM_FAULT_UFFD_MISSING to trigger the userfaultfd 
>> handler.
>> +                */
>> +               if (userfaultfd_missing(vmf->vma) && 
>> IS_ERR_OR_NULL(folio))
>> +                       return VM_FAULT_UFFD_MISSING;
>>          }
>>
>>          /* folio not in the pagecache, try to allocate */
>> @@ -507,9 +515,59 @@ static bool kvm_gmem_can_userfault(struct 
>> vm_area_struct *vma, vm_flags_t vm_fla
>>          return true;
>>   }
>>
>> +static struct folio *kvm_gmem_folio_alloc(struct vm_area_struct *vma,
>> +                                         unsigned long addr)
>> +{
>> +       struct inode *inode = file_inode(vma->vm_file);
>> +       pgoff_t pgoff = linear_page_index(vma, addr);
>> +       struct mempolicy *mpol;
>> +       struct folio *folio;
>> +       gfp_t gfp;
>> +
>> +       if (unlikely(pgoff >= (i_size_read(inode) >> PAGE_SHIFT)))
>> +               return NULL;
>> +
>> +       gfp = mapping_gfp_mask(inode->i_mapping);
>> +       mpol = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff);
>> +       mpol = mpol ?: get_task_policy(current);
>> +       folio = folio_alloc_mpol(gfp, 0, mpol, pgoff, numa_node_id());
> 
> It looks like folio_alloc_mpol_noprof() and filemap_remove_folio() are 
> not actually exported to modules.  Would it be ok to export them similar 
> to how it was done in f634f10809ec ("mm/mempolicy: Export memory policy 
> symbols")?
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 3e4579e4b8bb..041c7719e524 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -261,6 +261,7 @@ void filemap_remove_folio(struct folio *folio)
> 
>          filemap_free_folio(mapping, folio);
>   }
> +EXPORT_SYMBOL_FOR_MODULES(filemap_remove_folio, "kvm");
> 
>   /*
>    * page_cache_delete_batch - delete several folios from page cache
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 3d797d47a040..1dbbbb28a36e 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2442,6 +2442,7 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, 
> unsigned int order,
>          set_page_refcounted(page);
>          return page_rmappable_folio(page);
>   }
> +EXPORT_SYMBOL_FOR_MODULES(folio_alloc_mpol_noprof, "kvm");
> 
>   /**
>    * vma_alloc_folio - Allocate a folio for a VMA.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ 
> commit/?id=f634f10809ec3d51d9529dfb0f99bc7cec1b5eff
> 
>> +       mpol_cond_put(mpol);
>> +
>> +       return folio;
>> +}
>> +
>> +static int kvm_gmem_filemap_add(struct folio *folio,
>> +                               struct vm_area_struct *vma,
>> +                               unsigned long addr)
>> +{
>> +       struct inode *inode = file_inode(vma->vm_file);
>> +       struct address_space *mapping = inode->i_mapping;
>> +       pgoff_t pgoff = linear_page_index(vma, addr);
>> +       int err;
>> +
>> +       __folio_set_locked(folio);
>> +       err = filemap_add_folio(mapping, folio, pgoff, GFP_KERNEL);
>> +       if (err) {
>> +               folio_unlock(folio);
>> +               return err;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void kvm_gmem_filemap_remove(struct folio *folio,
>> +                                   struct vm_area_struct *vma)
>> +{
>> +       filemap_remove_folio(folio);
>> +       folio_unlock(folio);
>> +}
>> +
>>   static const struct vm_uffd_ops kvm_gmem_uffd_ops = {
>> -       .can_userfault = kvm_gmem_can_userfault,
>> +       .can_userfault     = kvm_gmem_can_userfault,
>>          .get_folio_noalloc = kvm_gmem_get_folio_noalloc,
>> +       .alloc_folio       = kvm_gmem_folio_alloc,
>> +       .filemap_add       = kvm_gmem_filemap_add,
>> +       .filemap_remove    = kvm_gmem_filemap_remove,
>>   };
>>   #endif /* CONFIG_USERFAULTFD */
>>
>> -- 
>> 2.51.0
>>
> 


