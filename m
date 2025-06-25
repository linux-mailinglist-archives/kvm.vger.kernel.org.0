Return-Path: <kvm+bounces-50754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C42E6AE906A
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 23:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B62E14A7C42
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 21:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 517B41FDA92;
	Wed, 25 Jun 2025 21:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="el0VK2bj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0625F2147FB
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 21:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750888030; cv=none; b=jwQ6c6AcYkyJwhn3NJxz65Lo3W38y8ucJ9TCRQTnN8ftGSpxhiTKLZrYEVEgHXxOWGqs6Am6mM8YZF8GtHIdlh/ul6XS92jtyY1ka6zt4kcw9qo68YkZHFpkgMu80CEXeE+VmlXPAoJ6DyOBpHRd1XbnR1t8/YG3HzTPlTZM4cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750888030; c=relaxed/simple;
	bh=JAsyW8eZE863eaSb5j9l0uHjRmiL/MJIXmfT/tJtisw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=byH0UXQxFWyhV0zp91VuhlM+wbEC0pUxZyUkMbqT5OzxRKawOm1tO7qHTpgQF8rWfZOhCUBppDJYgWXGn/lrgavHg3YbysxNAKs2U84M7VgGwblQyTxF6qSMq37Pm+AgBXmQzeDFM3lGdqSwyzY2gcy6Ew9LyAOWZcjVrrfSvGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=el0VK2bj; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c00e965d0so158064a12.2
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 14:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750888028; x=1751492828; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JaElZIlxs13I2jfOVX0lSC6FgKZKsuNp0z88behp5kM=;
        b=el0VK2bj+ngoUg+5WGO8P95KuLjyYa6RLAz5AxRxya4CaHjcwnB6+UgKaAGXvw2Ou8
         uBLanXIouFmcfVmPRN1FhzTYy+sHkHT6bfj/ZGihXw6mBLPFgx3gSwVfxrxePuzfCLdg
         /kyUDTQ9GeNRQ7xUZGcbp43cpZh28lgJ+TpHOmct8XOL9v8LrRJr+aE5j0gWCVcbQniz
         c0xeJzF72hs/Nh2p4DnY2w+O+7U0QvvtJzPTIZ1kmxILMAE52yI5oEhgqJyIgSBWIpTQ
         C8eCBGTLQ1cL6xvJ6EWN51VwwDrqgX7kRjp5/vctD/WT1dQ106NfDe0OQAiogwX3ygCS
         MHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750888028; x=1751492828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JaElZIlxs13I2jfOVX0lSC6FgKZKsuNp0z88behp5kM=;
        b=sPTlTwwmR1pHnvmJH96kmlW83WCUUaaZ5Q8stZKnYp2/TVaEN96or/oazJEJnF89VE
         iuhjoMSSZJeadKw5q2B9h25dwndu/1l0EOpHt7/xw+BGkFKE1icQtiwShx/iSUQZ6Drr
         b2KumkiNg6LAm+M+F5y0T/bnFZiei5hDe1bFtk45N2u6PKDPb7Snx0Ni3BVUZ6VuL9SV
         LREv9GXRR6F9NG5aJRYDOsCe3x4e5aP+PnQVs8E4nRcmmIZ0Z0eTeuo6ex+kqNG+SL6E
         EiqLoLpLtekMIHdDZCxeqrSSgEtpvgp4x0xPIpbFGTX0apkJDRaixd79600p2+4nlL4j
         sA+A==
X-Forwarded-Encrypted: i=1; AJvYcCVoChY/3EscXjw+Y2+cTkTGg/w2ZlPmOBItC7xCmESxdYx6YiY8fcD3K18Yd8fCr+QrNxU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyldRSDUHufa+ODt3ChggzU9U1grPXkp8QT5iG6MenyL5FOz+z9
	15vuP67GLQ4o4GczdvS+pX4cGiCDQNvYVhWSMb4w1h/aWrwOVw7OeBXcAeCJElqSPB5xDx9gPgC
	3A+q6TTF3Zu1Sqh4EryjzbRoxBA==
X-Google-Smtp-Source: AGHT+IHaFOtDsXjNCK8tDRGRC6rpZnF1ravk4aYWxE7y5fg1ChEv8b8QXDGShjJ5f1IXZEq0lP4YBKq+9E7DssxT5w==
X-Received: from pjm6.prod.google.com ([2002:a17:90b:2fc6:b0:312:e266:f849])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5388:b0:312:e1ec:de44 with SMTP id 98e67ed59e1d1-315f268f485mr5936687a91.27.1750888028344;
 Wed, 25 Jun 2025 14:47:08 -0700 (PDT)
Date: Wed, 25 Jun 2025 14:47:06 -0700
In-Reply-To: <20250611133330.1514028-9-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-9-tabba@google.com>
Message-ID: <diqzv7ojjxyd.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> This patch enables support for shared memory in guest_memfd, including
> mapping that memory from host userspace.
>
> This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> flag at creation time.
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/kvm_host.h | 13 +++++++
>  include/uapi/linux/kvm.h |  1 +
>  virt/kvm/Kconfig         |  4 +++
>  virt/kvm/guest_memfd.c   | 73 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 91 insertions(+)
>
> [...]
>

Just want to call out here that I believe HWpoison handling (and
kvm_gmem_error_folio()) remains correct after this patch. Would still
appreciate a review of the following!

> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> +		return VM_FAULT_SIGBUS;
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		int err = PTR_ERR(folio);
> +
> +		if (err == -EAGAIN)
> +			return VM_FAULT_RETRY;
> +
> +		return vmf_error(err);
> +	}
> +
> +	if (WARN_ON_ONCE(folio_test_large(folio))) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		kvm_gmem_mark_prepared(folio);
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +
> +out_folio:
> +	if (ret != VM_FAULT_LOCKED) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	return ret;
> +}
> +
> [...]

This ->fault() callback does not explicitly check for
folio_test_hwpoison(), but up the call tree, __do_fault() checks for
HWpoison.

If the folio is clean, the folio is removed from the filemap. Fault is
eventually retried and (hopefully) another non-HWpoison folio will be
faulted in.

If the folio is dirty, userspace gets a SIGBUS.

kvm_gmem_error_folio() calls kvm_gmem_invalidate_begin(), which only
unmaps KVM_FILTER_PRIVATE, but IIUC that's okay since after mmap is
introduced,

* non-Coco VMs will always zap KVM_DIRECT_ROOTS anyway so the HWpoison
  folio is still zapped from guest page tables
    * Unmapping from host userspace page tables is handled in
      memory_failure(), so the next access will lead to a fault, which
      is handled using a SIGBUS in __do_fault()
* Coco VMs can only use guest_memfd for private pages, so there's no
  change there since private pages still get zapped.

