Return-Path: <kvm+bounces-19939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4C7890E546
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 10:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B91F1F228BD
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 08:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB447FBB4;
	Wed, 19 Jun 2024 08:09:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA26B78C6B;
	Wed, 19 Jun 2024 08:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718784593; cv=none; b=X9fq+TytPTRiGSsy0tPOelas49r7tSufq0TRUQ23xtauHmqZl7llNXMyZrAKwuMlP0l9cBZ+YStLaSyiDRQZI+OkU8k0c6KUyPwCYERXKnArPYSjS7HS0OUdEFMoiwYj7+rRRb3B5EV/viysK0xXRrsVZE5hrzkcQkfQPMZRY80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718784593; c=relaxed/simple;
	bh=z9uXT3mjp7dVxjD9jHEieTpNwIbwtbk+ig9PZbKnsfg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UIB5RThr3JtE+AAzxvpqs4JsxRFc7WcvzBvHNoHlTBVdLTtFYAaZhFFpN92M4n+PmcDPh3TObFvgfQS2kiDo/ZgmngFuF/XzYIeNztf6Q4ngnVbnkiCq3iVkHn/CZWTbKiUWzXO+BaeXNsod9M3EgWAtEo7HEC7q9/bzNFmowAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Bx3+tHknJm9i4IAA--.17084S3;
	Wed, 19 Jun 2024 16:09:43 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxjsdEknJmFeMoAA--.32907S7;
	Wed, 19 Jun 2024 16:09:42 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] LoongArch: KVM: Add dirty bitmap initially all set support
Date: Wed, 19 Jun 2024 16:09:39 +0800
Message-Id: <20240619080940.2690756-6-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240619080940.2690756-1-maobibo@loongson.cn>
References: <20240619080940.2690756-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxjsdEknJmFeMoAA--.32907S7
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add KVM_DIRTY_LOG_INITIALLY_SET support on LoongArch system, this
feature comes from other architectures like x86 and arm64.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h | 3 +++
 arch/loongarch/kvm/mmu.c              | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 32c4948f534f..309ce329b747 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -37,6 +37,9 @@
 #define KVM_GUESTDBG_VALID_MASK		\
 	(KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP | KVM_GUESTDBG_SINGLESTEP)
 
+#define KVM_DIRTY_LOG_MANUAL_CAPS	\
+	(KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | KVM_DIRTY_LOG_INITIALLY_SET)
+
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 	u64 pages;
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 7f04edfbe428..3b862f3a72cb 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -467,6 +467,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 *		kvm_arch_flush_shadow_memslot()
 	 */
 	if (!(old_flags & KVM_MEM_LOG_DIRTY_PAGES) && log_dirty_pages) {
+		/*
+		 * Initially-all-set does not require write protecting any page
+		 * because they're all assumed to be dirty.
+		 */
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			return;
+
 		spin_lock(&kvm->mmu_lock);
 		/* Write protect GPA page table entries */
 		needs_flush = kvm_mkclean_gpa_pt(kvm, new->base_gfn,
-- 
2.39.3


