Return-Path: <kvm+bounces-19574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADFF9907088
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 14:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 595E6285FD6
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 12:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03EDF143C63;
	Thu, 13 Jun 2024 12:28:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAEFC8614D;
	Thu, 13 Jun 2024 12:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281689; cv=none; b=eUtz9rEsPmSM0YjF/IpAIYWItvOyscnEs+7ZBTrauiIo2GJWxHGE0BoJwzucYuOyvsolP2Tud/U7Q5wNVk/88kJghrtcrVT8Uwj90HzRmeeWEiK7kYlrxBHhnq3p/tsbe+GaogTYSDe3WtnIBTceqBC0pbCbz6qhTtkDa0TQIxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281689; c=relaxed/simple;
	bh=t+YxrqktIQ1UgUE74tLuPrJjYqGy3UZK/hCvf3JLA5c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ijsgbmzA/QKahcMJ7pcKUa/82i2/+Yl84P15WICGJebTDcXr8cnYxMHqTatL/dQOKsHqTp1i0GRB8qq0C5QfZr1tVi9cIk5WM09BQMRL6GW6wZH4fFZG3AeYsfXNN534CEv4bTUcGgWNskDLZeDgf3QlxL/YM6OcjaIGJQquRaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxrOrU5Wpm1oEGAA--.26381S3;
	Thu, 13 Jun 2024 20:28:04 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxacbU5WpmB7UeAA--.9477S2;
	Thu, 13 Jun 2024 20:28:04 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Discard zero mask with function kvm_dirty_ring_reset
Date: Thu, 13 Jun 2024 20:28:03 +0800
Message-Id: <20240613122803.1031511-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxacbU5WpmB7UeAA--.9477S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function kvm_reset_dirty_gfn may be called with parameters cur_slot /
cur_offset / mask are all zero, it does not represent real dirty page.
It is not necessary to clear dirty page in this condition. Also return
value of macro __fls() is undefined if mask is zero which is called in
funciton kvm_reset_dirty_gfn(). Here just discard it.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 virt/kvm/dirty_ring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 86d267db87bb..05f4c1c40cc7 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -147,14 +147,16 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
 				continue;
 			}
 		}
-		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
+		if (mask)
+			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
 		cur_slot = next_slot;
 		cur_offset = next_offset;
 		mask = 1;
 		first_round = false;
 	}
 
-	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
+	if (mask)
+		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
 
 	/*
 	 * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared

base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
-- 
2.39.3


