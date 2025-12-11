Return-Path: <kvm+bounces-65756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D63FDCB5951
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 12:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9F803302BA92
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 10:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8EE2DAFB5;
	Thu, 11 Dec 2025 10:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=josie.lol header.i=@josie.lol header.b="XCUQAbdw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-108-mta93.mxroute.com (mail-108-mta93.mxroute.com [136.175.108.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD08306B09
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 10:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765450777; cv=none; b=TRqS7zK/V4Rde1HH3xjer1c3LNEDsf7ZpFkarvOIDV3ld4K+kXaUOLnOOo8zEjVH6DUFZ59ep3pTzkDeq4tT+BTkVKASwayYnTmZVDBqGu7meoUA9Hf/aqxCPda9Eek+ZSFfTAdOsK0UWqolq1kGsw0ppyhs4u4y1yYHevqoZ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765450777; c=relaxed/simple;
	bh=dN8E80CdySwxsmhwuXZgg5f6wG9/5RIPBVfpk10OCZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwsyqF+Uly9TJuVIWcDjgTTm8uGaKUfPpt+kIhixlKR1c2pFeBlMvcAisB9sYe16ROuoqffbU9SPHFkNw9B2MbiLAqL1yvusR+sbcC3Tm/3lwwR8ItatdBa5wC7q2MKwwBfhcXMUk4VLS4nDl35E+5o/dt3ycQrjJ9IMU+EvqG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=josie.lol; spf=pass smtp.mailfrom=josie.lol; dkim=pass (2048-bit key) header.d=josie.lol header.i=@josie.lol header.b=XCUQAbdw; arc=none smtp.client-ip=136.175.108.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=josie.lol
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=josie.lol
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta93.mxroute.com (ZoneMTA) with ESMTPSA id 19b0d0c2b8b0004eea.009
 for <kvm@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Thu, 11 Dec 2025 10:54:20 +0000
X-Zone-Loop: d6fa21e5994d94388415b23781e25041617713ae896e
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=josie.lol;
	s=x; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Date:
	Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=ha5pCxRKxayQ8qBstOBlp614/GriMM6unQD08kdlSYk=; b=XCUQAb
	dwArKb76gxz2P8fNcZwW7oihkwH7CNrr3in5qiE8O2OFiMgewFhw7cRHnMdVbIWjeaUDhcpgihbc8
	lADyNPKG5hx2aJfoZZRAMJfKQ388QJA8lYeIdH4iID7v7loQ1YPbvricSskGG6xZfvU6cxYCncuP0
	40HyphE4bx676NzpiaYAu+3+QNYITEjreOGxzG9PIeg20Nn10KnQDBkx4WR9uQppR+L8kC6S3HT0h
	BG0MlmE27Re8o62iuaY4B897tMGoO8XL/Z7gzXF3/cvWABHWTyLntlvePYRHt/PY8c77WacLYPQJg
	z3AdPjf6n0CyYA+tCxH6AQWITkUA==;
From: Josephine Pfeiffer <hi@josie.lol>
To: frankja@linux.ibm.com
Cc: agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	david@kernel.org,
	gor@linux.ibm.com,
	hca@linux.ibm.com,
	imbrenda@linux.ibm.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org,
	svens@linux.ibm.com
Subject: Re: [PATCH] KVM: s390: Implement CHECK_STOP support and fix GET_MP_STATE
Date: Thu, 11 Dec 2025 11:54:12 +0100
Message-ID: <20251211105412.207458-1-hi@josie.lol>
In-Reply-To: <fd5ad2be-f15f-425f-b8ef-087dc639024d@linux.ibm.com>
References: <fd5ad2be-f15f-425f-b8ef-087dc639024d@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Id: hi@josie.lol

On Tue, 25 Nov 2025 19:10:43 +0100, Janosch Frank wrote:
> On 11/20/25 19:28, Josephine Pfeiffer wrote:
> > The use cases I see are:
> >
> > 1. API completeness: The state was added to the UAPI 11 years ago but never
> >     implemented. Userspace cannot use a documented API feature.
>
> I'd rather have stubs which properly fence than code that's never tested
> since we don't use it.
>
> Since this never worked it might make sense to remove it since future
> users will need to check for this "feature" anyway before using it.

That's a fair point. If you think there's no real use case, removing the dead 
API is cleaner than implementing unused code.

> > 2. Fault injection testing: Administrators testing failover/monitoring for
> >     hardware failures could programmatically put a CPU into CHECK_STOP to
> >     verify their procedures work.
>
> How would that work?
> What can we gain from putting a CPU into checkstop?
> How would QEMU would use this?
>
> Checkstop is not an error communication medium, that's the machine check
> interrupt. If you want to inject faults then use the machine check
> interface.
>
> If you want to crash the guest, then panic it or just stop cpus.

You're right - machine check interrupts are the correct mechanism for fault
injection. I was conflating the error state with error signaling.

I'll withdraw this patch and can send a cleanup patch instead to remove
KVM_MP_STATE_CHECK_STOP from the documentation. Would that be useful?

If so, should I also remove KVM_MP_STATE_LOAD from the docs while I'm at it? It has
the same "not supported yet" comment from the original 2014 commit [1].

Thanks,
Josephine

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6352e4d2dd9a

