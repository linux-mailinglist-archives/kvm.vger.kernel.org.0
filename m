Return-Path: <kvm+bounces-19577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3BF09072F0
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 14:55:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 674F2B2341E
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 12:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63EFC13E3F9;
	Thu, 13 Jun 2024 12:54:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05E321DDDB;
	Thu, 13 Jun 2024 12:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718283253; cv=none; b=pDod5xyFswlSu+bg4QbZjJBWk4PSuZ3M25A6wMoNzRRCqrOYUB2pAtLPluvx4vp49SyfYiBJaIz0EhDyGsESW+MYCiiuzCTu1QodI/4CRYIRpS+ZGbc/2QoXLQtPN7I7YbPCBriabeOvYDlrcKK9s8DzD/Sxqh3L865uTrCwM/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718283253; c=relaxed/simple;
	bh=J18AC9C3HBhsFS6ts2hpGgSXZdois+TGb2T/FrA5fpU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IOhzD5+abw64kbjtrQW+tT1dOKMyDCRJ9q14hXS3kLPuI+6Uhpoji3f3/DlR2X/Kr0JWfgalDYqt31lgLk03vGEPSl5VcoT6Noj0dMGj7yvIBW8ybvMJafpFNYiefEkBHolM2tRTHxna3Q4tWVuWn9iBStXdaqqHuexdxqB0XI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx_erw62pmyYMGAA--.26243S3;
	Thu, 13 Jun 2024 20:54:08 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxDMfv62pm+70eAA--.9804S2;
	Thu, 13 Jun 2024 20:54:07 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Remove duplicated zero clear with dirty_bitmap buffer
Date: Thu, 13 Jun 2024 20:54:07 +0800
Message-Id: <20240613125407.1126587-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxDMfv62pm+70eAA--.9804S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Since dirty_bitmap pointer is allocated with function __vcalloc(),
there is __GFP_ZERO flag set in the implementation about this function
__vcalloc_noprof(). It is not necessary to clear dirty_bitmap buffer
with zero again.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 virt/kvm/kvm_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14841acb8b95..c7d4a041dcfa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1669,9 +1669,6 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 			r = kvm_alloc_dirty_bitmap(new);
 			if (r)
 				return r;
-
-			if (kvm_dirty_log_manual_protect_and_init_set(kvm))
-				bitmap_set(new->dirty_bitmap, 0, new->npages);
 		}
 	}
 

base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
-- 
2.39.3


