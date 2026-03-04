Return-Path: <kvm+bounces-72706-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eM8RJDlpqGl3uQAAu9opvQ
	(envelope-from <kvm+bounces-72706-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:17:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A492205090
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:17:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9F074302E426
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 17:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 300D537AA7F;
	Wed,  4 Mar 2026 17:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="IG832i3R"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C0037A4BD;
	Wed,  4 Mar 2026 17:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.158.153.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772644393; cv=none; b=TY3zffo0edkgBsQbc6B5BCzU6VBPBB2uXJS0h4JbUMms/Ykt1FONHtqE+05edFUVuOckShoXpty2xBpVyxBB8Ijb7C0rCrIlgZ1RGvNBXs8mM4qoyGN8Qaqc93GKkzqbI9oLJ2Cy4ZS6uiWAFO02s7Rc2L8OBs2z39EH8wZXqwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772644393; c=relaxed/simple;
	bh=5/bQ/twgJ+hQHANZmy/rMEaa+DObPC4rHILqYL/5CBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UZ7XxA6ruUC6UXzLhjGWg72PaCKJ/Al+MwL4ldXGjQB8DlCT/ScF/CK8cPQOBreyU0p5zqG6w1Uca/kG5htfkfe5WLabXWGAsCF0azN9fcYJhS9xDe1WXekviy8s+zEwfKhtmAIHmdfTbfA87dfQeOk9ZCPymH+q8cjZzLzaQwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=IG832i3R; arc=none smtp.client-ip=18.158.153.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772644391; x=1804180391;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=GOyFbmGrjwCzzxO3kPvRp3gPk09ea9B/RkcYvfV3U7w=;
  b=IG832i3R7y/mIuqdkP0/6zptYMPPBs+Mx7RXVD/G9E9nSx3KEAAkDpr+
   +ffiUX0v88Frbj+JPngjOmuteksVFrnj2aClQsi3LYhkSocB9yO4sRHYW
   e1M/Eo2S2q7FwG9Ph2Vos1GnLSmdnmgfd48wCT3kaHzdiS+yKZtdOogys
   iKs2Tapoa+yAuxwo93B0Zl6GIi6KgXL1fjHH7NFYkWJoTAbthVf5PT/Fv
   dIj5TJdV7gkdiwJjcyOIHCYlo/bVSyCXqdlN8TZ0138byZL2JsdW7gnAU
   xHvhcMBERVdIOv/zrg08ThRX94hLFYcA8irbZk1+E5FOfysq+Ui5GtYip
   w==;
X-CSE-ConnectionGUID: UYsfpQ/XTKGj1mLFxoxIhw==
X-CSE-MsgGUID: vkl+gh6YQl+E7Yf9zukrFQ==
X-IronPort-AV: E=Sophos;i="6.21,324,1763424000"; 
   d="scan'208";a="10202501"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 17:13:06 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:21320]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.16.189:2525] with esmtp (Farcaster)
 id 9f0d1b18-a341-4a05-a845-dd316410b6b5; Wed, 4 Mar 2026 17:13:06 +0000 (UTC)
X-Farcaster-Flow-ID: 9f0d1b18-a341-4a05-a845-dd316410b6b5
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 4 Mar 2026 17:13:06 +0000
Received: from [192.168.5.225] (10.106.83.18) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Wed, 4 Mar 2026
 17:13:05 +0000
Message-ID: <90cf68db-2e21-4153-8eb6-2c8ffb398d0d@amazon.com>
Date: Wed, 4 Mar 2026 17:12:59 +0000
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
To: Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand
	<david@redhat.com>, Hugh Dickins <hughd@google.com>, James Houghton
	<jthoughton@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, Michal Hocko
	<mhocko@suse.com>, "Muchun Song" <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, "Paolo Bonzini" <pbonzini@redhat.com>, Peter Xu
	<peterx@redhat.com>, "Sean Christopherson" <seanjc@google.com>, Shuah Khan
	<shuah@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, Vlastimil Babka
	<vbabka@suse.cz>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-16-rppt@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
In-Reply-To: <20260127192936.1250096-16-rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D011EUB003.ant.amazon.com (10.252.51.108) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: 3A492205090
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-9.16 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	TAGGED_FROM(0.00)[bounces-72706-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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



On 27/01/2026 19:29, Mike Rapoport wrote:
> From: Nikita Kalyazin <kalyazin@amazon.com>
> 
> userfaultfd missing mode allows populating guest memory with the content
> supplied by userspace on demand.
> 
> Extend guest_memfd implementation of vm_uffd_ops to support MISSING
> mode.
> 
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   virt/kvm/guest_memfd.c | 60 +++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 59 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 087e7632bf70..14cca057fc0e 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -431,6 +431,14 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>                          ret = VM_FAULT_UFFD_MINOR;
>                          goto out_folio;
>                  }
> +
> +               /*
> +                * Check if userfaultfd is registered in missing mode. If so,
> +                * check if a folio exists in the page cache. If not, return
> +                * VM_FAULT_UFFD_MISSING to trigger the userfaultfd handler.
> +                */
> +               if (userfaultfd_missing(vmf->vma) && IS_ERR_OR_NULL(folio))
> +                       return VM_FAULT_UFFD_MISSING;
>          }
> 
>          /* folio not in the pagecache, try to allocate */
> @@ -507,9 +515,59 @@ static bool kvm_gmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_fla
>          return true;
>   }
> 
> +static struct folio *kvm_gmem_folio_alloc(struct vm_area_struct *vma,
> +                                         unsigned long addr)
> +{
> +       struct inode *inode = file_inode(vma->vm_file);
> +       pgoff_t pgoff = linear_page_index(vma, addr);
> +       struct mempolicy *mpol;
> +       struct folio *folio;
> +       gfp_t gfp;
> +
> +       if (unlikely(pgoff >= (i_size_read(inode) >> PAGE_SHIFT)))
> +               return NULL;
> +
> +       gfp = mapping_gfp_mask(inode->i_mapping);
> +       mpol = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff);
> +       mpol = mpol ?: get_task_policy(current);
> +       folio = folio_alloc_mpol(gfp, 0, mpol, pgoff, numa_node_id());

It looks like folio_alloc_mpol_noprof() and filemap_remove_folio() are 
not actually exported to modules.  Would it be ok to export them similar 
to how it was done in f634f10809ec ("mm/mempolicy: Export memory policy 
symbols")?

diff --git a/mm/filemap.c b/mm/filemap.c
index 3e4579e4b8bb..041c7719e524 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -261,6 +261,7 @@ void filemap_remove_folio(struct folio *folio)

         filemap_free_folio(mapping, folio);
  }
+EXPORT_SYMBOL_FOR_MODULES(filemap_remove_folio, "kvm");

  /*
   * page_cache_delete_batch - delete several folios from page cache
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3d797d47a040..1dbbbb28a36e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2442,6 +2442,7 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, 
unsigned int order,
         set_page_refcounted(page);
         return page_rmappable_folio(page);
  }
+EXPORT_SYMBOL_FOR_MODULES(folio_alloc_mpol_noprof, "kvm");

  /**
   * vma_alloc_folio - Allocate a folio for a VMA.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f634f10809ec3d51d9529dfb0f99bc7cec1b5eff

> +       mpol_cond_put(mpol);
> +
> +       return folio;
> +}
> +
> +static int kvm_gmem_filemap_add(struct folio *folio,
> +                               struct vm_area_struct *vma,
> +                               unsigned long addr)
> +{
> +       struct inode *inode = file_inode(vma->vm_file);
> +       struct address_space *mapping = inode->i_mapping;
> +       pgoff_t pgoff = linear_page_index(vma, addr);
> +       int err;
> +
> +       __folio_set_locked(folio);
> +       err = filemap_add_folio(mapping, folio, pgoff, GFP_KERNEL);
> +       if (err) {
> +               folio_unlock(folio);
> +               return err;
> +       }
> +
> +       return 0;
> +}
> +
> +static void kvm_gmem_filemap_remove(struct folio *folio,
> +                                   struct vm_area_struct *vma)
> +{
> +       filemap_remove_folio(folio);
> +       folio_unlock(folio);
> +}
> +
>   static const struct vm_uffd_ops kvm_gmem_uffd_ops = {
> -       .can_userfault = kvm_gmem_can_userfault,
> +       .can_userfault     = kvm_gmem_can_userfault,
>          .get_folio_noalloc = kvm_gmem_get_folio_noalloc,
> +       .alloc_folio       = kvm_gmem_folio_alloc,
> +       .filemap_add       = kvm_gmem_filemap_add,
> +       .filemap_remove    = kvm_gmem_filemap_remove,
>   };
>   #endif /* CONFIG_USERFAULTFD */
> 
> --
> 2.51.0
> 


