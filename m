Return-Path: <kvm+bounces-20363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F23CE914353
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 09:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD32C284B81
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 07:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C453B47F41;
	Mon, 24 Jun 2024 07:14:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F8EE3BBF2;
	Mon, 24 Jun 2024 07:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719213268; cv=none; b=DN2b204yk2IkzFHoPIKY9O0m6pg8QFETwtnsHWsRiV5Jqo/Ja904faxnxmsHqg3ykyTcZAqh2zTmD/Z8wGkhfgaAeS9FnLlUEAeUyZRaxOnJV7koN6OaBE9zP+UznZr4+MtjksnG1O+xOCT39LTrMG5bCp/mEOHluYgczyHTTQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719213268; c=relaxed/simple;
	bh=5nNNwBKF40usngDFhlzxJZVkfQIOyHAzYjcY4WPZc4I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=edCdc8bpnGFqmQv8SM8NwXsSIKYYSDA+3qa+FKeMvlKknQ1bX33Be88k6kK9aiQCqj5F30jJHhmiopYhNz11hXyzkG+BLEwnMUNMeIoSaxM4eQv2mBkkiHPOrG2+nVS2hIU9bR66P7lZFK5WxQ7QZji8GBsbdn5YvfJ21Y9+o8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxvOrQHHlmC3EJAA--.37691S3;
	Mon, 24 Jun 2024 15:14:24 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxMMTPHHlmftsuAA--.9847S4;
	Mon, 24 Jun 2024 15:14:23 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Rui <wangrui@loongson.cn>
Subject: [PATCH v3 2/7] LoongArch: KVM: Select huge page only if secondary mmu supports it
Date: Mon, 24 Jun 2024 15:14:17 +0800
Message-Id: <20240624071422.3473789-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240624071422.3473789-1-maobibo@loongson.cn>
References: <20240624071422.3473789-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxMMTPHHlmftsuAA--.9847S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Currently page level selection about secondary mmu depends on memory
slot and page level about host mmu. There will be problem if page level
of secondary mmu is zero already. Huge page cannot be selected if there is
normal page mapped in secondary mmu already, since it is not supported to
merge normal pages into huge page now.

So page level selection should depend on the following three conditions.
 1. Memslot is aligned for huge page and vm is not migrating.
 2. Page level of host mmu is huge page also.
 3. Page level of secondary mmu is suituable for huge page.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/mmu.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 9e39d28fec35..c6351d13ca1b 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -858,10 +858,20 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 
 	/* Disable dirty logging on HugePages */
 	level = 0;
-	if (!fault_supports_huge_mapping(memslot, hva, write)) {
-		level = 0;
-	} else {
+	if (fault_supports_huge_mapping(memslot, hva, write)) {
+		/* Check page level about host mmu*/
 		level = host_pfn_mapping_level(kvm, gfn, memslot);
+		if (level == 1) {
+			/*
+			 * Check page level about secondary mmu
+			 * Disable hugepage if it is normal page on
+			 * secondary mmu already
+			 */
+			ptep = kvm_populate_gpa(kvm, NULL, gpa, 0);
+			if (ptep && !kvm_pte_huge(*ptep))
+				level = 0;
+		}
+
 		if (level == 1) {
 			gfn = gfn & ~(PTRS_PER_PTE - 1);
 			pfn = pfn & ~(PTRS_PER_PTE - 1);
-- 
2.39.3


