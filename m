Return-Path: <kvm+bounces-6867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09B1483B33C
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:49:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6B1D2838E8
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49FD41353E7;
	Wed, 24 Jan 2024 20:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u92Awrwj"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180D01350D1
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 20:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129371; cv=none; b=KuAjrqf2u7dMgvRqzwcvz+bX0dZ1O1zpwe2eD4P62hYyw8bQcaYLslNDAG3NwQp/u3unhi41l1jVpMWxY79mKQfZ4e4lhWjhWRZZ8fQ7SSKizKIeW/vFf0ZaUqACob0TLamaiAiQWmPMrc1J/Wd2g3eljjv68s0J0Q32grw6taE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129371; c=relaxed/simple;
	bh=fYdb0s8j6INILPBCiFKkTHx4drOYk1lE6+c2s0Xm/l4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L5OMEB2uoOzbiW9X/ke06ehY21aFIyo8oP0LXfacRSNADYvzAMuFhGkOp61V9e6VbZZkMKA8dXFgjNsmOJnHfLePThJYtGgoBbIDxQ+3t9V00iHFUJb4Ii5MfQt8OLZYce9mEwV0Kc0ofo3sq97UE0FdjIU7f6XTu0n+ltQyBZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u92Awrwj; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ErrYvq4woSS9wtjygaOskYgEbsL06Iyne8J3rZQvpVo=;
	b=u92AwrwjVte7I3SC/0wycLo4k7R16daGQf4o0Jm1dFAB9X+KUSR97XcVztqrg4CLnwP8j7
	t5j3l2vqrt1KdVhdjrVn5e4jAZUD10dJqlzO45chsksJLnN0r492f1YyWepuJZpkmiExhH
	SzOboi9eFyOAEE4R0gG17Awhw7GPVWg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 00/15] KVM: arm64: Improvements to GICv3 LPI injection
Date: Wed, 24 Jan 2024 20:48:54 +0000
Message-ID: <20240124204909.105952-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The unfortunate reality is there are increasingly large systems that are
shipping today without support for GICv4 vLPI injection. Serialization
in KVM's LPI routing/injection code has been a significant bottleneck
for VMs on these machines when under a high load of LPIs (e.g. a
multi-queue NIC).

Even though the long-term solution is quite clearly **direct
injection**, we really ought to do something about the LPI scaling
issues within KVM.

This series aims to improve the performance of LPI routing/injection in
KVM by moving readers of LPI configuration data away from the
lpi_list_lock in favor or using RCU.

Patches 1-5 change out the representation of LPIs in KVM from a
linked-list to an xarray. While not strictly necessary for making the
locking improvements, this seems to be an opportune time to switch to a
data structure that can actually be indexed.

Patches 6-10 transition vgic_get_lpi() and vgic_put_lpi() away from
taking the lpi_list_lock in favor of using RCU for protection. Note that
this requires some rework to the way references are taken on LPIs and
how reclaim works to be RCU safe.

Lastly, patches 11-15 rework the LRU policy on the LPI translation cache
to not require moving elements in the linked-list and take advantage of
this to make it an rculist readable outside of the lpi_list_lock.

All of this was tested on top of v6.8-rc1. Apologies if any of the
changelogs are a bit too light, I'm happy to rework those further in
subsequent revisions.

I would've liked to have benchmark data showing the improvement on top
of upstream with this series, but I'm currently having issues with our
internal infrastructure and upstream kernels. However, this series has
been found to have a near 2x performance improvement to redis-memtier [*]
benchmarks on our kernel tree.

[*] https://github.com/RedisLabs/memtier_benchmark

Oliver Upton (15):
  KVM: arm64: vgic: Store LPIs in an xarray
  KVM: arm64: vgic: Use xarray to find LPI in vgic_get_lpi()
  KVM: arm64: vgic-v3: Iterate the xarray to find pending LPIs
  KVM: arm64: vgic-its: Walk the LPI xarray in vgic_copy_lpi_list()
  KVM: arm64: vgic: Get rid of the LPI linked-list
  KVM: arm64: vgic: Use atomics to count LPIs
  KVM: arm64: vgic: Free LPI vgic_irq structs in an RCU-safe manner
  KVM: arm64: vgic: Rely on RCU protection in vgic_get_lpi()
  KVM: arm64: vgic: Ensure the irq refcount is nonzero when taking a ref
  KVM: arm64: vgic: Don't acquire the lpi_list_lock in vgic_put_irq()
  KVM: arm64: vgic-its: Lazily allocate LPI translation cache
  KVM: arm64: vgic-its: Pick cache victim based on usage count
  KVM: arm64: vgic-its: Protect cached vgic_irq pointers with RCU
  KVM: arm64: vgic-its: Treat the LPI translation cache as an rculist
  KVM: arm64: vgic-its: Rely on RCU to protect translation cache reads

 arch/arm64/kvm/vgic/vgic-debug.c |   2 +-
 arch/arm64/kvm/vgic/vgic-init.c  |   7 +-
 arch/arm64/kvm/vgic/vgic-its.c   | 190 ++++++++++++++++++-------------
 arch/arm64/kvm/vgic/vgic-v3.c    |   3 +-
 arch/arm64/kvm/vgic/vgic.c       |  56 +++------
 arch/arm64/kvm/vgic/vgic.h       |  12 +-
 include/kvm/arm_vgic.h           |   9 +-
 7 files changed, 146 insertions(+), 133 deletions(-)


base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
2.43.0.429.g432eaa2c6b-goog


