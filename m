Return-Path: <kvm+bounces-23396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D53C9494DE
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 876E1B25B2F
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 15:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C406F3A1CD;
	Tue,  6 Aug 2024 15:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="HHujrAov"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8271946F;
	Tue,  6 Aug 2024 15:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722959312; cv=none; b=ZGE90lAA3WDxE1anXllGRMXnqHj8GEqI2p0ketGVV2PJK0OBl+qyhG6ZYEag9WCnOmKxq1JNK9gmL3LwIsZXGadRqTZAPL5wVRtH3H/HVQN/vajkND2gVOkk+LnD2MbMtjYxcgnNmcOmibLqN6Rj5uJkKhnybUB4VUtpm0qfHAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722959312; c=relaxed/simple;
	bh=79JKVVzj13bPR9TcVJePyTMWtYc/ZcBwbG0GynFLhKE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ggnY9RtA40Cu3Dl7qwdh3yqTYSxNoI+Ah4hB1fAIJ+yOzMvHTtdvgXsg7iQAjZ+lW8PtC0rmEsLfPHpRmURLvLx+dvcExyyK5oDKO/VF5777EKErdhJbItq/RnIKCZn3afucEASrDWOgydQRIouXN1ddFG0DZpGUmrXd9rC2k7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=HHujrAov; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1722959310; x=1754495310;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yc/1mWs6SeF5HnWAzCvUQzyjIjCuiLTryEo53m/a1v4=;
  b=HHujrAovkv35QNQoE3kSDVDENlpgfrKlg04ay8Gk4LpTS7Tpnd1Ruf0Y
   kaUR6eLw+tqJ0LGySMBBpJIfEM3DmCdX8hF+iXFuj90AFAtpAnW+3UQPe
   R3kFow32R8LEWPX73IfO+bvNHa6iBBjm0OQLxCoB29PTOGnEaO/pY0Xdl
   g=;
X-IronPort-AV: E=Sophos;i="6.09,268,1716249600"; 
   d="scan'208";a="360852274"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 15:48:27 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:8908]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.94:2525] with esmtp (Farcaster)
 id 114b04b0-66ae-461d-8af3-867b0de2b6ff; Tue, 6 Aug 2024 15:48:26 +0000 (UTC)
X-Farcaster-Flow-ID: 114b04b0-66ae-461d-8af3-867b0de2b6ff
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 6 Aug 2024 15:48:25 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D022EUC002.ant.amazon.com (10.252.51.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 6 Aug 2024 15:48:25 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.252.135.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Tue, 6 Aug 2024 15:48:23 +0000
Message-ID: <6660faa6-4cea-4ddc-a378-ab9da9139ee9@amazon.co.uk>
Date: Tue, 6 Aug 2024 16:48:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 4/4] mm: guest_memfd: Add ability for mmap'ing pages
To: Elliot Berman <quic_eberman@quicinc.com>, Andrew Morton
	<akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Fuad Tabba <tabba@google.com>, "David
 Hildenbrand" <david@redhat.com>, <qperret@google.com>, Ackerley Tng
	<ackerleytng@google.com>
CC: <linux-coco@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <kvm@vger.kernel.org>,
	James Gowans <jgowans@amazon.com>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>, "Cali,
 Marco" <xmarcalx@amazon.co.uk>
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-4-e5a29a4ff5d7@quicinc.com>
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
In-Reply-To: <20240805-guest-memfd-lib-v1-4-e5a29a4ff5d7@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2024-08-05 at 19:34 +0100, Elliot Berman wrote:
> Confidential/protected guest virtual machines want to share some memory
> back with the host Linux. For example, virtqueues allow host and
> protected guest to exchange data. In MMU-only isolation of protected
> guest virtual machines, the transition between "shared" and "private"
> can be done in-place without a trusted hypervisor copying pages.
> 
> Add support for this feature and allow Linux to mmap host-accessible
> pages. When the owner provides an ->accessible() callback in the
> struct guest_memfd_operations, guest_memfd allows folios to be mapped
> when the ->accessible() callback returns 0.

Wouldn't the set of inaccessible folios always match exactly the set of
folios that have PG_private=1 set? At least guest_memfd instances that
have GUEST_MEMFD_FLAG_NO_DIRECT_MAP set, having folios without direct
map entries marked "accessible" sound like it may cause a lot of mayhem
(as those folios would essentially be secretmem folios, but this time
without the GUP checks). But even more generally, wouldn't tracking
accessibility via PG_private be enough?

> To safely make inaccessible:
> 
> ```
> folio = guest_memfd_grab_folio(inode, index, flags);
> r = guest_memfd_make_inaccessible(inode, folio);
> if (r)
>         goto err;
> 
> hypervisor_does_guest_mapping(folio);
> 
> folio_unlock(folio);
> ```
> 
> hypervisor_does_s2_mapping(folio) should make it so
> ops->accessible(...) on those folios fails.
> 
> The folio lock ensures atomicity.
> 
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> ---
>  include/linux/guest_memfd.h |  7 ++++
>  mm/guest_memfd.c            | 81 ++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 87 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
> index f9e4a27aed67..edcb4ba60cb0 100644
> --- a/include/linux/guest_memfd.h
> +++ b/include/linux/guest_memfd.h
> @@ -16,12 +16,18 @@
>   * @invalidate_end: called after invalidate_begin returns success. Optional.
>   * @prepare: called before a folio is mapped into the guest address space.
>   *           Optional.
> + * @accessible: called after prepare returns success and before it's mapped
> + *              into the guest address space. Returns 0 if the folio can be
> + *              accessed.
> + *              Optional. If not present, assumes folios are never accessible.
>   * @release: Called when releasing the guest_memfd file. Required.
>   */
>  struct guest_memfd_operations {
>         int (*invalidate_begin)(struct inode *inode, pgoff_t offset, unsigned long nr);
>         void (*invalidate_end)(struct inode *inode, pgoff_t offset, unsigned long nr);
>         int (*prepare)(struct inode *inode, pgoff_t offset, struct folio *folio);
> +       int (*accessible)(struct inode *inode, struct folio *folio,
> +                         pgoff_t offset, unsigned long nr);
>         int (*release)(struct inode *inode);
>  };
> 
> @@ -48,5 +54,6 @@ struct file *guest_memfd_alloc(const char *name,
>                                const struct guest_memfd_operations *ops,
>                                loff_t size, unsigned long flags);
>  bool is_guest_memfd(struct file *file, const struct guest_memfd_operations *ops);
> +int guest_memfd_make_inaccessible(struct file *file, struct folio *folio);
> 
>  #endif
> diff --git a/mm/guest_memfd.c b/mm/guest_memfd.c
> index e9d8cab72b28..6b5609932ca5 100644
> --- a/mm/guest_memfd.c
> +++ b/mm/guest_memfd.c
> @@ -9,6 +9,8 @@
>  #include <linux/pagemap.h>
>  #include <linux/set_memory.h>
> 
> +#include "internal.h"
> +
>  static inline int guest_memfd_folio_private(struct folio *folio)
>  {
>         unsigned long nr_pages = folio_nr_pages(folio);
> @@ -89,7 +91,7 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
>                         goto out_err;
>         }
> 
> -       if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
> +       if (!ops->accessible && (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)) {
>                 r = guest_memfd_folio_private(folio);
>                 if (r)
>                         goto out_err;
> @@ -107,6 +109,82 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
>  }
>  EXPORT_SYMBOL_GPL(guest_memfd_grab_folio);
> 
> +int guest_memfd_make_inaccessible(struct file *file, struct folio *folio)
> +{
> +       unsigned long gmem_flags = (unsigned long)file->private_data;
> +       unsigned long i;
> +       int r;
> +
> +       unmap_mapping_folio(folio);
> +
> +       /**
> +        * We can't use the refcount. It might be elevated due to
> +        * guest/vcpu trying to access same folio as another vcpu
> +        * or because userspace is trying to access folio for same reason
> +        *
> +        * folio_lock serializes the transitions between (in)accessible
> +        */
> +       if (folio_maybe_dma_pinned(folio))
> +               return -EBUSY;
> +
> +       if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
> +               r = guest_memfd_folio_private(folio);
> +               if (r)
> +                       return r;
> +       }
> +
> +       return 0;
> +}
> +
> +static vm_fault_t gmem_fault(struct vm_fault *vmf)
> +{
> +       struct file *file = vmf->vma->vm_file;
> +       struct inode *inode = file_inode(file);
> +       const struct guest_memfd_operations *ops = inode->i_private;
> +       struct folio *folio;
> +       pgoff_t off;
> +       int r;
> +
> +       folio = guest_memfd_grab_folio(file, vmf->pgoff, GUEST_MEMFD_GRAB_UPTODATE);
> +       if (!folio)
> +               return VM_FAULT_SIGBUS;
> +
> +       off = vmf->pgoff & (folio_nr_pages(folio) - 1);
> +       r = ops->accessible(inode, folio, off, 1);
> +       if (r) {

This made be stumble at first. I know you say ops->accessible returning
0 means "this is accessible", but if I only look at this if-statement it
reads as "if the folio is accessible, send a SIGBUS", which is not
what's actually happening.

> +               folio_unlock(folio);
> +               folio_put(folio);
> +               return VM_FAULT_SIGBUS;
> +       }
> +
> +       guest_memfd_folio_clear_private(folio);
> +
> +       vmf->page = folio_page(folio, off);
> +
> +       return VM_FAULT_LOCKED;
> +}
> +
> +static const struct vm_operations_struct gmem_vm_ops = {
> +       .fault = gmem_fault,
> +};
> +
> +static int gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       const struct guest_memfd_operations *ops = file_inode(file)->i_private;
> +
> +       if (!ops->accessible)
> +               return -EPERM;
> +
> +       /* No support for private mappings to avoid COW.  */
> +       if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> +           (VM_SHARED | VM_MAYSHARE))
> +               return -EINVAL;
> +
> +       file_accessed(file);
> +       vma->vm_ops = &gmem_vm_ops;
> +       return 0;
> +}
> +
>  static long gmem_punch_hole(struct file *file, loff_t offset, loff_t len)
>  {
>         struct inode *inode = file_inode(file);
> @@ -220,6 +298,7 @@ static int gmem_release(struct inode *inode, struct file *file)
>  static struct file_operations gmem_fops = {
>         .open = generic_file_open,
>         .llseek = generic_file_llseek,
> +       .mmap = gmem_mmap,
>         .release = gmem_release,
>         .fallocate = gmem_fallocate,
>         .owner = THIS_MODULE,
> 
> --
> 2.34.1
> 

