Return-Path: <kvm+bounces-59466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EE12CBB77E5
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 18:11:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B356E4ED9ED
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 16:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02572BE05B;
	Fri,  3 Oct 2025 16:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TJFydeTr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F18526E6FA
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 16:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507864; cv=none; b=YNnH7xuNkO4omlvzT1hj8hz8RGWwn49XJpNrQvJ5uQ2bRclfftP087I48c5CimD/DiaMIjeWen8alFoM2GJx7M6VNFkQHNrsWzANqhdb7bZkukBUqJnFoxCX8DFWjWJGdHiUDxSfZ4V7cO7zoTdiu/H6gOypa3p0pYO5PsJ2xxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507864; c=relaxed/simple;
	bh=PZQha7RBk24SP6qwyggJkFay7mNZRHmPQnH5kdOnMRw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WhGANp9ncI8owIrgbrPhxbh0IYezntWQD0zzFI7i//9KE7Rl7ICmSlwblPcmPWzO7Gu7l7cJtwhsreJ32vSy6lfAeLP5lTrscel7YM6YIWAbZqeoyqJde7NSgLisEZWtgnxrXAOp3ZauNdxySakFP8wdJRuFdEiHV6eisGaz1kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TJFydeTr; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2699ed6d43dso25079105ad.1
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 09:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759507863; x=1760112663; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lNh2mX9a3msgEQw2OsPB0rXj0BKWzfoqoJiUnuGpBLY=;
        b=TJFydeTr+mFmSPqZErGU6IftQjd3w61WHvoph4LINqFGKN+RgOsmJcLkdLBwm6DXrQ
         CicN7vqVJePkbThYz5ndDKqrhcWBQhgGJo4bDQ/ru2UDzrzF5Qca9QsTKvNHNN1fxuft
         Aiw3zoIVX5AYszvM2skCACMa4uQYaBmW5G7bHNNBNzgYYJCSjpG5dABY8azpqLc63P8I
         MRKWxxCUP9txgK5oLmtHuk1gkE9CKBsMgI4COK2m90h1HlKwJD2fYVR9EpIobydPy9Gf
         5celyMoVpgTzKr8hgn6wss1J2cs2+OeJzg0TNqXzPCqWVKN0XPFDm4bPGHpHJk/DEMzz
         0DHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759507863; x=1760112663;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lNh2mX9a3msgEQw2OsPB0rXj0BKWzfoqoJiUnuGpBLY=;
        b=PRWkhlXc3ygJcyRMUkM68p8d4FW6HjDsFe2cv02X8V/Ru0wfuPMRHljjS/2O9tqgdS
         7PN2HLnIfkxEKT+2lsugffsD/HvuAhUdKnoTRm4VhJ/L+7f6e24/uyqoR+gnul+hxVlN
         HvZ1kI5ZBkiSxQH0BfBwfOJ6g2HRBZEHjJOphJjSX1jFolZhdD0/krO2AdAvAapHi0Vz
         VC+v16pf7lmPP92Uj8ySSxlA+U5ohMm9biE8BKZQjEBkj1eWkYet+ykyFi8MEQY0Nu2Z
         W03nq16+I15jqqUiry9vSThVAjvFwl0OFKITHQKUC/B87zz4j92vh4P8/dovgJHovTJy
         NdNg==
X-Gm-Message-State: AOJu0Yz6VRoqysJUWhTObof6qJgjStY6yjwV4z/X9LbPZwf36TfIpOlN
	FIAJI6qq05v5w4DLbs1txbJUkdZq/n7oeElbG/DzrCZ6BZseLlIU7+kPijJdycGxEwRcDutxZLe
	QRIoy6g==
X-Google-Smtp-Source: AGHT+IGqNOuAruJgEcEZ8T6X7B8VeXMzqceZ1ggBpiDOEhdpqVLI6EnOOFhpmeY8C5TVlMwWJfNoQPt99zY=
X-Received: from plbjw19.prod.google.com ([2002:a17:903:2793:b0:273:c5f4:a8ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e786:b0:268:15f:8358
 with SMTP id d9443c01a7336-28e9a656d8fmr47206475ad.42.1759507862519; Fri, 03
 Oct 2025 09:11:02 -0700 (PDT)
Date: Fri, 3 Oct 2025 09:11:01 -0700
In-Reply-To: <2ae41e0d80339da2b57011622ac2288fed65cd01.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <2ae41e0d80339da2b57011622ac2288fed65cd01.1747264138.git.ackerleytng@google.com>
Message-ID: <aN_1lSZJKBKvU9gV@google.com>
Subject: Re: [RFC PATCH v2 35/51] mm: guestmem_hugetlb: Add support for
 splitting and merging pages
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, binbin.wu@linux.intel.com, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	dave.hansen@intel.com, david@redhat.com, dmatlack@google.com, 
	dwmw@amazon.co.uk, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	graf@amazon.com, haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, May 14, 2025, Ackerley Tng wrote:
>  const struct guestmem_allocator_operations guestmem_hugetlb_ops = {
>  	.inode_setup = guestmem_hugetlb_setup,
>  	.inode_teardown = guestmem_hugetlb_teardown,
>  	.alloc_folio = guestmem_hugetlb_alloc_folio,
> +	.split_folio = guestmem_hugetlb_split_folio,
> +	.merge_folio = guestmem_hugetlb_merge_folio,
> +	.free_folio = guestmem_hugetlb_free_folio,
>  	.nr_pages_in_folio = guestmem_hugetlb_nr_pages_in_folio,
>  };
>  EXPORT_SYMBOL_GPL(guestmem_hugetlb_ops);

Don't bury exports in an "ops" like this.  Be very explicit in what is exported.
_If_ KVM needs a layer of indirection to support multiple, custom guest_memfd
allocators, then KVM can wire up ops as above.  Indirectly exporting core mm/
functionality via an ops structure like this is unnecessarily sneaky.

