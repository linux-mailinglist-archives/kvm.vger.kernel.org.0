Return-Path: <kvm+bounces-12469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 003B888666A
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 06:50:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 946CB1F22FB0
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 05:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8170ABE65;
	Fri, 22 Mar 2024 05:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="nZ6LzF89"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9FF4436;
	Fri, 22 Mar 2024 05:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711086594; cv=none; b=jfGGap4v2l35XgD5eudPeWhAKiuzYwaHjtzKV69aOFpjV5oC4+dHgWHq9kAS5uiyZT8PvbGm21qbVLONNrxyh/3rUMpjQbXtnftLY9rZIh+btkVdNYlHDIFSecRKVsgRMUBtkmxeZ7QBaZp3Rk94TRd5QW+TOcz2wGsBQGAsOGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711086594; c=relaxed/simple;
	bh=3dxZ97h1bBewqFSrSCxZ0u2xq2+UB+rYnjeTo4PLAV8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=XcrVCqdG4PfYYUXqV4UXWRjKuAoOD8L5o3C+80jiKU+qkI3hqM1E2vV7PW/N8VMgnSaMUEFv1L0DOe5d3O+t3FsHxKUksuhUNaBcD1Nt+r294rNsIq285NMfJiKwoAuFjQDfwa8an2hCQMAZD3Cj7UDqrDrnXUCC3vfawi9qpZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=nZ6LzF89; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1711086589;
	bh=3dxZ97h1bBewqFSrSCxZ0u2xq2+UB+rYnjeTo4PLAV8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=nZ6LzF89AlrxXzDXd3QYUcFV677SbDrpe7d8wTOKSI9z4sQrwflKXJiuKHFQPldHU
	 2zc466eC0WPNUECV45Sx3Xt0p3N3asRi0s9bzaBSan6JBwr3zOhhUVUrDs1T62ksm4
	 /W+rwkWmzx4DevQBKw1AJzPA5t1pSanKbIirVQKOl1jZT0nVbCmeAEmBtTx/5gJ6ZV
	 tqX6f6KtRH8uWu+PuXX29MEoCpJrX1QM48JFOi26G9jIV+8ciPHjHOwSGf2Y6qiB9B
	 GXhmKc0DU09lOC4tOeZLYPTsZblimmwcieKRF01BNk/vB3B1f4up32uBu2biiUybfD
	 VUSx1SnXOjBrQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4V1BHF6qs1z4wcF;
	Fri, 22 Mar 2024 16:49:45 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Jason Gunthorpe <jgg@ziepe.ca>, Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: tpearson@raptorengineering.com, alex.williamson@redhat.com,
 linuxppc-dev@lists.ozlabs.org, npiggin@gmail.com,
 christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
 naveen.n.rao@linux.ibm.com, gbatra@linux.vnet.ibm.com,
 brking@linux.vnet.ibm.com, aik@ozlabs.ru, robh@kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, aik@amd.com,
 msuchanek@suse.de, jroedel@suse.de, vaibhav@linux.ibm.com,
 svaidy@linux.ibm.com
Subject: Re: [RFC PATCH 1/3] powerpc/pseries/iommu: Bring back userspace
 view for single level TCE tables
In-Reply-To: <20240319143202.GA66976@ziepe.ca>
References: <171026724548.8367.8321359354119254395.stgit@linux.ibm.com>
 <171026725393.8367.17497620074051138306.stgit@linux.ibm.com>
 <20240319143202.GA66976@ziepe.ca>
Date: Fri, 22 Mar 2024 16:49:43 +1100
Message-ID: <877chuke88.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@ziepe.ca> writes:
> On Tue, Mar 12, 2024 at 01:14:20PM -0500, Shivaprasad G Bhat wrote:
>> The commit 090bad39b237a ("powerpc/powernv: Add indirect levels to
>> it_userspace") which implemented the tce indirect levels
>> support for PowerNV ended up removing the single level support
>> which existed by default(generic tce_iommu_userspace_view_alloc/free()
>> calls). On pSeries the TCEs are single level, and the allocation
>> of userspace view is lost with the removal of generic code.
>
> :( :(
>
> If this has been broken since 2018 and nobody cared till now can we
> please go in a direction of moving this code to the new iommu APIs
> instead of doubling down on more of this old stuff that apparently
> almost nobody cares about ??

It's broken *on pseries* (Linux as a guest), but it works fine on
powernv (aka bare metal, aka Linux as Hypervisor).

What's changed is folks are now testing it on pseries with Linux as a
nested hypervisor.

cheers

