Return-Path: <kvm+bounces-56555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E195BB3FB2E
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 11:51:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E58401B23434
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 09:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 898172F1FE2;
	Tue,  2 Sep 2025 09:49:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B15892ED873;
	Tue,  2 Sep 2025 09:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756806597; cv=none; b=b5E5/lPth+AYxvxITQW0QdYBQkCElmawE70jE751DUgJkhQ4v/mzV2sa93vqNSQuQZINRCUK2B7rvR8a4zKHnk70OAka9OGXC5WrrGOKavURRsHWo6r2r98M9zuTnKwNJDxJTWHvviwv3HRD/XXd6biaj2/4+b0ejDc5/gz0a8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756806597; c=relaxed/simple;
	bh=jU2kKvv1bsjj7G0pE+AMVSwzWTYXe7YdVfO5VFVkDwk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T/Aa3nO4hCgO7BTswOCjCvcmaAG+Jb15O/vtpMO2ugkg2oqDA85q0E7UPSMLNZtCU+/CgqJEUELnbUsxI8ERQuHX1vhwc5gAKPik8ezTyosSgLT5BhOq09iB/gWHKmv7IScvDD8HibgqITOAdNTa+L6n1p1DcjIUweBvrNKKseI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxH9O7vbZob7wFAA--.11699S3;
	Tue, 02 Sep 2025 17:49:47 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDx_8O5vbZoyLF4AA--.52017S6;
	Tue, 02 Sep 2025 17:49:47 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] LoongArch: KVM: Avoid use copy_from_user with lock hold in kvm_pch_pic_regs_access
Date: Tue,  2 Sep 2025 17:49:45 +0800
Message-Id: <20250902094945.2957566-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250902094945.2957566-1-maobibo@loongson.cn>
References: <20250902094945.2957566-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDx_8O5vbZoyLF4AA--.52017S6
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function copy_from_user() and copy_to_user() may sleep because of page
fault, and they cannot be called in spin_lock hold context. Here move
function calling with copy_from_user() and copy_to_user() out of spinlock
context in function kvm_pch_pic_regs_access().

Fixes: d206d95148732 ("LoongArch: KVM: Add PCHPIC user mode read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/pch_pic.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index 119290bcea79..71706e24a1c5 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -352,6 +352,7 @@ static int kvm_pch_pic_regs_access(struct kvm_device *dev,
 	void __user *data;
 	void *p = NULL;
 	struct loongarch_pch_pic *s;
+	char buf[8];
 
 	s = dev->kvm->arch.pch_pic;
 	addr = attr->attr;
@@ -397,17 +398,24 @@ static int kvm_pch_pic_regs_access(struct kvm_device *dev,
 		return -EINVAL;
 	}
 
-	spin_lock(&s->lock);
-	/* write or read value according to is_write */
 	if (is_write) {
-		if (copy_from_user(p, data, len))
-			ret = -EFAULT;
-	} else {
-		if (copy_to_user(data, p, len))
-			ret = -EFAULT;
+		if (copy_from_user(buf, data, len))
+			return -EFAULT;
 	}
+
+	spin_lock(&s->lock);
+	/* write or read value according to is_write */
+	if (is_write)
+		memcpy(p, buf, len);
+	else
+		memcpy(buf, p, len);
 	spin_unlock(&s->lock);
 
+	if (!is_write) {
+		if (copy_to_user(data, buf, len))
+			return -EFAULT;
+	}
+
 	return ret;
 }
 
-- 
2.39.3


