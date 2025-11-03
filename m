Return-Path: <kvm+bounces-61784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 25024C2A2E9
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 07:28:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B97184E5D1B
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 06:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55012951A7;
	Mon,  3 Nov 2025 06:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cxG98CUt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873C31B142D
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 06:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762151319; cv=none; b=GBL9i0n9g3PxP8vCqv0S+Sc0MCtWm1otQZKTxaRtkfd3+L69DvsTnDOUPxu09ZIApO4stJFpmP93RKA4IAddYGH7E51CpmwjRl1wtd9zYPYFS9J1L/+mpHns82k+C5sktidnRglVfPQTa2pFFB0r4LNBClq/Eyz5vtUT3yf/iug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762151319; c=relaxed/simple;
	bh=PfSsBRoB3TgmqwbvgrIlvWOlJprDh92dXfLoV/tLGlg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Yh2tVdAwHfZ4OcJDK11dw/WRwLQzg6hxhaOqM0Onsox/6bteLJvEEIqAnwuC7AEQM0KDFfh31LT6eq+R/AzZ4BHXfWzW6jdAftcEKcgJtLpLbzbQ9qFMAqphVeosM0RHF+OPOmVF8cdTQeUI6LDzV3hDiQEI7PTr4IuXLgp88vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cxG98CUt; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-28e7cd6dbc0so50621685ad.0
        for <kvm@vger.kernel.org>; Sun, 02 Nov 2025 22:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762151318; x=1762756118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HzWLA6lM7306PSkRpZwBsCJQbgLVcWr7Jb7jPn8ULYQ=;
        b=cxG98CUt30ivJIKJgt7/dzhqgSS6q6ovGTF3Sv3LpIC8CmtExCW3+I754+K4rornrB
         /t5mI+I/DVzJr5OGhUPNH4nuaaBffa9atjTPEn7Sml47rqZcUPm7yFrce0V++RYGP+kH
         F+BSveDBbzU1Ivd0R/zYc/y5OtBcqidSmrulMhWhGPkDi6xNBeEJgvjmgIAQXep6y3P5
         JYCbplnuw5tWDVNMq+J4UCNzm3OVTsRXbBfyYTJR0vyZa23b2r+2V5Q6/eHVfJc+43GV
         wK8Nx9UsAkagZrrAD0pb4jvB80wfLRPK0wg94HMl+b95JgJgO3IbCwe4YzkUocOOYR02
         Tqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762151318; x=1762756118;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HzWLA6lM7306PSkRpZwBsCJQbgLVcWr7Jb7jPn8ULYQ=;
        b=R43amdc0vVqtn2AQeiXazmd2DT2ZGoDPah6fY6y/AdRzlsGsWtYNi1GeAaIGtjHnLS
         kh0HZijCRtHx0z0uZjIQ5xHNtFZ26OSzmx/sAUxH+loJAQ4bY/OGsSIzQ6VLjIN7gEZq
         No93xH4PiPDvvNZtDH3TD1NMSxGwcFJCitqIeuhqeTeK5Y4W3HQcwS5loXopHx8GdJj8
         Zwma57zHA03RuwEJgfQOCstB2bTMskRZczjub76x2aKAt+As/0VnSMc4Y3cN8Wh8oLBz
         oR6fTm0UDa+V4D+h71YWtyFU2xSUjwfzy2PUvWVd3L1hyjjRZw3hl0neSeZSjHsWrHFL
         0Yzw==
X-Forwarded-Encrypted: i=1; AJvYcCX15iEmwpgutdnDsOqARp1f+inj33BtMAIg3chv9zCtlQxhyaDFLSg6TBFjSTWaNxveqpM=@vger.kernel.org
X-Gm-Message-State: AOJu0YymUa9J2tvTIezd7c/9hcT1xojHgFwlI4eQWG9YdwosMvz/dQaQ
	+e0YTNqtAnYqGwzNjRLtQ7QxhqtwccwqwPOBiAFsr9HDVBJ0fWgPJsCh
X-Gm-Gg: ASbGncsCuankgQPsIOao/QO5H3XibKyJHxXtnWUJmtaJUc+4xle0DAGfw2WX63QQRUI
	IFWtEYu72fNOC4QOPZQb1uaql/AhZ3q1AcW73SlkN14JHXOE7YPwo596fx6iNigNgHGBrCl0mVA
	+ahkJpKCiRRS/7J2OaxAaD402K/zvvd7rCMYdKhfC6ds8KMZ46ltSmB2t0drDPIudenAYktjJHb
	BtUtAVZnZ0dopzFboizfmksm7Ml2k4TcpdRNsXt89ey52jsjDUyZN0la8usHgalkinCWkLlFh4p
	xaQa9Ev8Q3ub/5wRPKSISmREJB24xaVcYyE96EQ7fhcMzybDhFCEDJAiCTpkJJhZKtHZdqhrtMV
	x0z47A5MwnztPl5+hsI2isUAAAw4npLCDmk+BFAvMTOQ8qQZGUYUmWK84R9wwaWyskgipPVNyN5
	/WE4wfKPymw0hNcmcgcJre
X-Google-Smtp-Source: AGHT+IGieiNu6B5gkgyoDggtQ7uHFE1tUXXst+2hCFavgg4oBRkDQVMrd9IkdCDUo5boIWBJw2G0nw==
X-Received: by 2002:a17:902:c407:b0:295:57f6:76b with SMTP id d9443c01a7336-29557f60d3bmr68472355ad.7.1762151317697;
        Sun, 02 Nov 2025 22:28:37 -0800 (PST)
Received: from days-ASUSLaptop.lan ([110.191.181.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2952699c482sm108155595ad.80.2025.11.02.22.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 22:28:37 -0800 (PST)
From: dayss1224@gmail.com
To: anup@brainfault.org,
	ajones@ventanamicro.com,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Dong Yang <dayss1224@gmail.com>,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH] KVM: riscv: Support enabling dirty log gradually in small chunks
Date: Mon,  3 Nov 2025 14:28:25 +0800
Message-Id: <20251103062825.9084-1-dayss1224@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dong Yang <dayss1224@gmail.com>

There is already support of enabling dirty log gradually in small chunks
for x86 in commit 3c9bd4006bfc ("KVM: x86: enable dirty log gradually in
small chunks") and c862626 ("KVM: arm64: Support enabling dirty log
gradually in small chunks"). This adds support for riscv.

x86 and arm64 writes protect both huge pages and normal pages now, so
riscv protect also protects both huge pages and normal pages.

On a nested virtualization setup (RISC-V KVM running inside a QEMU VM
on an [Intel® Core™ i5-12500H] host), I did some tests with a 2G Linux
VM using different backing page sizes. The time taken for
memory_global_dirty_log_start in the L2 QEMU is listed below:

Page Size      Before    After Optimization
  4K            4490.23ms         31.94ms
  2M             48.97ms          45.46ms
  1G             28.40ms          30.93ms

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
Signed-off-by: Dong Yang <dayss1224@gmail.com>
---
 Documentation/virt/kvm/api.rst    | 2 +-
 arch/riscv/include/asm/kvm_host.h | 3 +++
 arch/riscv/kvm/mmu.c              | 5 ++++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 57061fa29e6a..3b621c3ae67c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8028,7 +8028,7 @@ will be initialized to 1 when created.  This also improves performance because
 dirty logging can be enabled gradually in small chunks on the first call
 to KVM_CLEAR_DIRTY_LOG.  KVM_DIRTY_LOG_INITIALLY_SET depends on
 KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE (it is also only available on
-x86 and arm64 for now).
+x86, arm64 and riscv for now).
 
 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 was previously available under the name
 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT, but the implementation had bugs that make
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 4d794573e3db..848b63f87001 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -59,6 +59,9 @@
 					 BIT(IRQ_VS_TIMER) | \
 					 BIT(IRQ_VS_EXT))
 
+#define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
+	KVM_DIRTY_LOG_INITIALLY_SET)
+
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 };
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 525fb5a330c0..a194eee256d8 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -161,8 +161,11 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * allocated dirty_bitmap[], dirty pages will be tracked while
 	 * the memory slot is write protected.
 	 */
-	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES)
+	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			return;
 		mmu_wp_memory_region(kvm, new->id);
+	}
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-- 
2.34.1


