Return-Path: <kvm+bounces-37606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E106A2C92E
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 17:46:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF33B163B1B
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 16:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0817F18DB27;
	Fri,  7 Feb 2025 16:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="ScaHENaw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B22323C8AF;
	Fri,  7 Feb 2025 16:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738946760; cv=none; b=DexfibhuzS5S+bbQyfIrmuq20Yl6kqPrBLjCUpnlGZ/JjBWzAaG6fnrmqXyY0KTrg/Fmsrp6mCzI0IgBgXgifkf7CJYfxrQGkYkhZj7iZaLCtbWTtZ9nJaR4XFKHmezqWA5982wwMOuTGcijlfa29YawqMvfiESjXBrvopGVgQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738946760; c=relaxed/simple;
	bh=sD/CGPZZ7laiJ27vQakP60j57br3QZpDJMPYzD3tjPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ALYyU7rms1GxdPHCzRl+sMolPfYhGrVHwJM82Bys9T/mA49v0aEPtRKViRyxMAv+V31JIe8G5ngcMnCxDvxRfOjxrTxzQK+FJDU7bueqKJGpyH7mSeqgy3/2rTqSHjMgR/fZqPpeFb+eP9IzV5qK1A/Mdo+mhpZB61fbMq2yO4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=ScaHENaw; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1738946759; x=1770482759;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q7xTDS28+TP5gE07LEBmeY0j/rksTUzAlt42eYMiWY0=;
  b=ScaHENawKmE7nO2/FjyLaBfTHiNoyAW3v27NJN9JtIFlndawGqPnTITe
   5h/YS35y3BQZ9FtNUW7BGJlEI7MBQKp8zGwIZP77aV/GevQmBBubtUciB
   zjBylj/pqUJ+26iWcZx9dbyaMCtGvgYeOI/KaQjWkWN+0Wacepj2pVzYV
   8=;
X-IronPort-AV: E=Sophos;i="6.13,267,1732579200"; 
   d="scan'208";a="492059548"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2025 16:45:48 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.7.35:61291]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.49.27:2525] with esmtp (Farcaster)
 id 0c878457-1ded-46ff-8f23-53205f2aa13e; Fri, 7 Feb 2025 16:45:47 +0000 (UTC)
X-Farcaster-Flow-ID: 0c878457-1ded-46ff-8f23-53205f2aa13e
Received: from EX19MTAUWB002.ant.amazon.com (10.250.64.231) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Fri, 7 Feb 2025 16:45:34 +0000
Received: from email-imr-corp-prod-iad-1box-1a-6851662a.us-east-1.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.228) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Fri, 7 Feb 2025 16:45:34 +0000
Received: from [127.0.0.1] (dev-dsk-roypat-1c-dbe2a224.eu-west-1.amazon.com [172.19.88.180])
	by email-imr-corp-prod-iad-1box-1a-6851662a.us-east-1.amazon.com (Postfix) with ESMTPS id 8644C40575;
	Fri,  7 Feb 2025 16:45:27 +0000 (UTC)
Message-ID: <0b1cc981-52e8-4f8f-846a-f19507e3a630@amazon.co.uk>
Date: Fri, 7 Feb 2025 16:45:26 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 03/11] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<yu.c.zhang@linux.intel.com>, <isaku.yamahata@intel.com>, <mic@digikod.net>,
	<vbabka@suse.cz>, <vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <shuah@kernel.org>,
	<hch@infradead.org>, <jgg@nvidia.com>, <rientjes@google.com>,
	<jhubbard@nvidia.com>, <fvdl@google.com>, <hughd@google.com>,
	<jthoughton@google.com>
References: <20250129172320.950523-1-tabba@google.com>
 <20250129172320.950523-4-tabba@google.com>
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
In-Reply-To: <20250129172320.950523-4-tabba@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Fuad!

On Wed, 2025-01-29 at 17:23 +0000, Fuad Tabba wrote:
> Add support for mmap() and fault() for guest_memfd backed memory
> in the host for VMs that support in-place conversion between
> shared and private (shared memory). To that end, this patch adds
> the ability to check whether the VM type has that support, and
> only allows mapping its memory if that's the case.
> 
> Additionally, this behavior is gated with a new configuration
> option, CONFIG_KVM_GMEM_SHARED_MEM.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> 
> ---
> 
> This patch series will allow shared memory support for software
> VMs in x86. It will also introduce a similar VM type for arm64
> and allow shared memory support for that. In the future, pKVM
> will also support shared memory.
> ---
>  include/linux/kvm_host.h | 11 ++++++
>  virt/kvm/Kconfig         |  4 +++
>  virt/kvm/guest_memfd.c   | 77 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 92 insertions(+)
> 
> -snip-
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 47a9f68f7b24..86441581c9ae 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -307,7 +307,84 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>         return gfn - slot->base_gfn + slot->gmem.pgoff;
>  }
> 
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> +{
> +       struct inode *inode = file_inode(vmf->vma->vm_file);
> +       struct folio *folio;
> +       vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +       filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +       folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +       if (IS_ERR(folio)) {
> +               ret = VM_FAULT_SIGBUS;
> +               goto out_filemap;
> +       }
> +
> +       if (folio_test_hwpoison(folio)) {
> +               ret = VM_FAULT_HWPOISON;
> +               goto out_folio;
> +       }
> +
> +       if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
> +               ret = VM_FAULT_SIGBUS;
> +               goto out_folio;
> +       }
> +
> +       /* No support for huge pages. */
> +       if (WARN_ON_ONCE(folio_nr_pages(folio) > 1)) {
> +               ret = VM_FAULT_SIGBUS;
> +               goto out_folio;
> +       }
> +
> +       if (!folio_test_uptodate(folio)) {
> +               clear_highpage(folio_page(folio, 0));
> +               folio_mark_uptodate(folio);

kvm_gmem_mark_prepared() instead of direct folio_mark_uptodate() here, I
think (in preparation of things like [1])? Noticed this while rebasing
my direct map removal series on top of this and wondering why mmap'd
folios sometimes didn't get removed (since it hooks mark_prepared()).

Best,
Patrick

[1]: https://lore.kernel.org/kvm/20241108155056.332412-1-pbonzini@redhat.com/

