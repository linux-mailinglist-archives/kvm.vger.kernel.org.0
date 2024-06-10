Return-Path: <kvm+bounces-19188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E65719022D1
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 15:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50E1D286003
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 13:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE3512FB26;
	Mon, 10 Jun 2024 13:42:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E6184E04;
	Mon, 10 Jun 2024 13:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718026944; cv=none; b=d3+SQ+PvDeXCwSbkw+w+MLoTBpDR4Z7XUGVtaFBaoj597aPN8pkpfe3M3oAT00kx1rrQCsRzAGWU0FJHUaSrve/D0rUtn9+9A36BQYoZIqpI4eIbuwINh5FuQH4c8y/UtTjhGbqGxIBfD7Hn5MR8glLHrCWT8/6HMpFvw8LHTKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718026944; c=relaxed/simple;
	bh=SZqlvKa++YGsE9E9uqbdhq9d2K/3nSBBjlc+3fFf3Po=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZpKoRG49QHjN60XtcIUWFVae6rYivAmNDK8e3QWXfkUQijbob3TKdOraD0a8vZ3qIf3XspsE8d9HDL/X83kIFAoRZHKPfZfbPqWGePvBV0Ay9pr7gDnaMTjfzv8qAm+gQw308Q7ViczXEkJvKO99zTeJZJ4oUoyefPyE+4I3XrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6818F12FC;
	Mon, 10 Jun 2024 06:42:46 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49DE43F58B;
	Mon, 10 Jun 2024 06:42:18 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Sean Christopherson <seanjc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v3 01/43] KVM: Prepare for handling only shared mappings in mmu_notifier events
Date: Mon, 10 Jun 2024 14:41:20 +0100
Message-Id: <20240610134202.54893-2-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610134202.54893-1-steven.price@arm.com>
References: <20240610134202.54893-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Add flags to "struct kvm_gfn_range" to let notifier events target only
shared and only private mappings, and write up the existing mmu_notifier
events to be shared-only (private memory is never associated with a
userspace virtual address, i.e. can't be reached via mmu_notifiers).

Add two flags so that KVM can handle the three possibilities (shared,
private, and shared+private) without needing something like a tri-state
enum.

Link: https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 692c01e41a18..c5394c948db5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -265,6 +265,8 @@ struct kvm_gfn_range {
 	gfn_t start;
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
+	bool only_private;
+	bool only_shared;
 	bool may_block;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14841acb8b95..ff486d7d29b4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -634,6 +634,13 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 			 * the second or later invocation of the handler).
 			 */
 			gfn_range.arg = range->arg;
+
+			/*
+			 * HVA-based notifications aren't relevant to private
+			 * mappings as they don't have a userspace mapping.
+			 */
+			gfn_range.only_private = false;
+			gfn_range.only_shared = true;
 			gfn_range.may_block = range->may_block;
 
 			/*
-- 
2.34.1


