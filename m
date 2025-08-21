Return-Path: <kvm+bounces-55227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BE64B2EBCF
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 05:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 205835E20B6
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 03:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEDF22DA77A;
	Thu, 21 Aug 2025 03:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gERcbd2E"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4FC18C933;
	Thu, 21 Aug 2025 03:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755746259; cv=none; b=E9UDxhXRPkUP4vNvbD0kqsp/B2QaAVegzLFFhNuhI/aSui7chHNGvZVzKKt5PxcxYIVJsKl8eOmcqXf6wfuqaLMH5Sn+U7VzR/QLZW+2v7mFow6pkYEebIJdfew7zAz2RyQLEgEYXgWDphVgiTbTrgUl5ayOAQovGhqUosV4qAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755746259; c=relaxed/simple;
	bh=CBOysjUe33h5qBQdWPGsKZycqcns/K6/wD6KCp8bJ4M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EV2Yj6OaqN9HZPi7ZzHutKgAo7TjPSpyqVDdAPF01fre+pXKGwGVzY2eVPqrLNKpaPI0IoMuIXo8GNbKzgueKylb+NCisS7YmVJsxw9WvM+Cec5zkikXTMq1PxcE0OvKjfH6ozdR0xkaeYjPgkah7P6lQKWkQepR5zSXOxyifKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gERcbd2E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18E6C4CEF4;
	Thu, 21 Aug 2025 03:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755746259;
	bh=CBOysjUe33h5qBQdWPGsKZycqcns/K6/wD6KCp8bJ4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gERcbd2EuZ5hjCz6I/jeym8J3EtLtekmyIuMroYF7gM9WQFIylCeQu1vHpKDbNN50
	 qgig2GOUoHsHwrZ0eVUJYRrb8qMifxNkRh8yODx146yCCz+OKihkkgeVt27nCbmo2x
	 wTrWU6rOpl/D+IYNyT4TetLt/dI9AlUKioCA3A5cEu6twe14BdqjQf3vL57aL1lK6X
	 1Gi9UpplCQ/mQ/beqxvv3tnOlkXCAKWHRpmdbycU+b7T3OBsILddI14pJd97bDoi9K
	 m10+ihe31cgcBljRdtYo2avcMJXS4P9/Ben6ge0TNGq/pMWTMzQvaNFz8lX++E8bKM
	 EJlnV/NyP6/MQ==
From: guoren@kernel.org
To: guoren@kernel.org,
	troy.mitchell@linux.dev
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com,
	guoren@linux.alibaba.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com
Subject: [PATCH V4 0/3] Fixup & optimize hgatp mode & vmid detect functions
Date: Wed, 20 Aug 2025 23:17:15 -0400
Message-Id: <20250821031719.2366017-1-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <CAJF2gTQFWJzHhRoQ-oASO9nn1kC0dv+NuK-DD=JgfeHE90RWqw@mail.gmail.com>
References: <CAJF2gTQFWJzHhRoQ-oASO9nn1kC0dv+NuK-DD=JgfeHE90RWqw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>

Here are serval fixup & optmizitions for hgatp detect according to the RISC-V Privileged Architecture Spec.

---
Changes in v4:
 - Involve ("RISC-V: KVM: Prevent HGATP_MODE_BARE passed"), which
   explain why gstage_mode_detect needs reset HGATP to zero.
 
Changes in v3:
 - Add "Fixes" tag.
 - Involve("RISC-V: KVM: Remove unnecessary HGATP csr_read"), which
   depends on patch 1.

Changes in v2:
 - Fixed build error since kvm_riscv_gstage_mode() has been modified.
---

Fangyu Yu (1):
  RISC-V: KVM: Write hgatp register with valid mode bits

Guo Ren (Alibaba DAMO Academy) (2):
  RISC-V: KVM: Remove unnecessary HGATP csr_read
  RISC-V: KVM: Prevent HGATP_MODE_BARE passed

 arch/riscv/kvm/gstage.c | 27 ++++++++++++++++++++++++---
 arch/riscv/kvm/main.c   | 35 +++++++++++++++++------------------
 arch/riscv/kvm/vmid.c   |  8 +++-----
 3 files changed, 44 insertions(+), 26 deletions(-)

-- 
2.40.1


