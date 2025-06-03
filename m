Return-Path: <kvm+bounces-48285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F01DACC372
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 11:47:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DFB43A3E1E
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA9C7284B38;
	Tue,  3 Jun 2025 09:46:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E58CF1990C7;
	Tue,  3 Jun 2025 09:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748943986; cv=none; b=LCWjJdN0hK33fYfB5t0tUOctXKl6tJ8btLRKx2Zhut6ciBBwVEAGNU0YNLm5RjmqPX0pzctJmx35JqPU4BSjqTpxK3T8WeBjPiQ0eAlhTxEi2nbFLfwqlrx3YlrvhxQwSF/eMBb48zWJnpKW0hIY/SDgh6wGLQdneBqSOaM/97M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748943986; c=relaxed/simple;
	bh=uD27TLOkmLE97SKX+m1nAjFPEUD7oQ+EyEzUgNGPZHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KQEvBpMCBFs/jiiFM09A5iAUzLksE8MRm+JkiihGFuhOvo+uv6f9AVOfU0GSsz79O0VgZielElS4DXrYdcjs3g/QqtY6lvkUPrRoyA0s/LEzvZSPbf7BIf+Gz9lLnzszCrD5rFYOg1988X06yzHNJFOXPzNJ7HWdaeP8uiZWvgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxHHJoxD5oUgwKAQ--.32739S3;
	Tue, 03 Jun 2025 17:46:17 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDxH+VfxD5ot8gGAQ--.23188S5;
	Tue, 03 Jun 2025 17:46:15 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 3/7] LoongArch: KVM: Disable update property num_cpu and feature with eiointc
Date: Tue,  3 Jun 2025 17:46:02 +0800
Message-Id: <20250603094606.1053622-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250603094606.1053622-1-maobibo@loongson.cn>
References: <20250603094606.1053622-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxH+VfxD5ot8gGAQ--.23188S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Property num_cpu and feature is read-only once eiointc is created, which
is set with KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL attr group before device
creation.

Attr group KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS is to update register
and software state for migration and reset usage, property num_cpu and
feature can not be update again if it is created already.

Here discard write operation with property num_cpu and feature in attr
group KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL.

Cc: stable@vger.kernel.org
Fixes: 1ad7efa552fd ("LoongArch: KVM: Add EIOINTC user mode read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 0b648c56b0c3..b48511f903b5 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -910,9 +910,22 @@ static int kvm_eiointc_sw_status_access(struct kvm_device *dev,
 	data = (void __user *)attr->addr;
 	switch (addr) {
 	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_NUM_CPU:
+		/*
+		 * Property num_cpu and feature is read-only once eiointc is
+		 * created with KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL group API
+		 *
+		 * Disable writing with KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS
+		 * group API
+		 */
+		if (is_write)
+			return ret;
+
 		p = &s->num_cpu;
 		break;
 	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_FEATURE:
+		if (is_write)
+			return ret;
+
 		p = &s->features;
 		break;
 	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_STATE:
-- 
2.39.3


