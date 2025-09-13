Return-Path: <kvm+bounces-57486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1BFBB55AB1
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 02:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9550D17F425
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 00:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB85135962;
	Sat, 13 Sep 2025 00:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gj71Owpt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD5A29CE1
	for <kvm@vger.kernel.org>; Sat, 13 Sep 2025 00:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757723353; cv=none; b=egVS0s4YYkz93KcjTCurQKxQYyP+d5einmfLRofsscmG3jip3rWZRIB+xNRDBVHewZlDeOW5ekuBY/sP9iF20fFlyZTK62l7s3BHPgr0OCUJVnWg5QtSMu4pxe+fmpzFDovB9J9mdPapARyQg5l3oTH4SSCFBFmyf/sAq+Ohmzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757723353; c=relaxed/simple;
	bh=o/2/1rLuGad7KFL3fjUL65woyzwOsWRQ8y/k/9zJK20=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=eiX+0JnL76T7ziRhi3hQrEF5M1N6MD9su1G7aCGe7L0Gb/mtJcT0MZ3+e6tir/OmoS5DJFxc3OUk8rtfVw9JZSaNqIDvyyM8fpG1oMS66JhK5g87SRE+ESP+tgA99iqE8tGZzNCYs3xYd9gUh5ehVLgRgnySBnixxZEin5q3p54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gj71Owpt; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e96fbf400c0so3090986276.0
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 17:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757723351; x=1758328151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=CmOJuo57ImQUiYUwmR7+IFwJm/0Fqs9h33y3GCq+M5c=;
        b=gj71OwptWQG7mCmzxuaA0ydwXBePe5CyIuUOSya9fRDbxI97LESSteSA8/rEWvv+Au
         FX8GmvUg0LxhJo9GzKnZwOcCWDu0sSYVIQU5yBCz763BPP6+T7cGp2F6+7ZWIC+c+QTZ
         kVRQBELaJ9pNyJ35FV+ut/ZNgk1pBVoUcjMUx+JPTClE/PwOquVFKdO/J96Ff1cTIeIy
         oLANtwHDwyVDp2HDQ47a8ipWeTEN++WUjJZr9PMmOuNlPQvRwD4O3UYxHl09PNvx8UBS
         Gqs+RD178sDsq+qdOvmsB7W1ZqOhZJ+X0S5ddU1ex8QMo5y4WB/JeXqwTypT4cAMRU3B
         srbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757723351; x=1758328151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CmOJuo57ImQUiYUwmR7+IFwJm/0Fqs9h33y3GCq+M5c=;
        b=A5Jri9st5rtZh3Yrz+Cetcph+pmDv6gwNYFWNLVzqL/1461TrDKYfxRYqP5jpSxHpn
         4+WxxsVUNdGtp6hrJ2CCVjZWLAVNoeJxnQqmjh97pVsLPWbCR4NXZlKmbnM+YK/Cfktt
         IYjBbaiaVCMdluyK5I3ZJmKkjtsrgZc0vkZkhi8ZNEDAiuqrmwg6vc7oqJxgt7rUbfoP
         Wf7O+z9s6WQo16+zLFO6QwLjjQIKQx/Dzun60XfgG9QGn29MOdsZk9SgWltLIOhHDbhU
         Vh8a70R/LA1kxyZ+MrPtoFj9JftIsgOigRq5Wy10kRe/pKIJ4cMLJQLCxaCWN4XIeMJt
         55Bg==
X-Forwarded-Encrypted: i=1; AJvYcCVSpMAsh1KfPFTo38nBVmBBxCRJvfNOJntyrLzrBgDLzoyjXCUmSf7T9A6NvjiOye425+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwolVL+p0pbD0VPiP6+985hSCG5OI59OU63d4xlG/ZDVNhT1XaF
	jx6+bk7e7+/WmStX9WnugSqdOAXzMwl3EBl6+SibkFrrwfodoLCU/F/+vxWgoQ==
X-Gm-Gg: ASbGncvkwqWkHY77mtXPhgNbjLWEf/PwSxzjOTIubnu/f5pUMKJszbKpN8srNLNGO+/
	iZnn0sAxoi0bqs/4zqimDl1P0UD19cZjtjJJDEI/KEhre95IflEDr/cCBu8p2mNCf4pxo9r1oQN
	/tx7hBwQWRa5GRI3dij2TFx1xD80BpTyzLLBK6lZPzP4UGMSFkktoceVNUbqOrU4BMtFWLfGvx3
	O+KVCRkw/5G+DpjaQO+dHCifMjwYt46PUccY5nu/XNKSbkPzvbyqLkPNblb71tr35+6Drn6DZcw
	InPKSJfNrO9OHwtq5QvozxZKoIEpz87GjPYBPHCQQLOglsCY40fWwKqOHguEt2M6nt+lyZu1CLJ
	v6mJejoNNY1pmSb4l1hOzjkYikQEuJ+yiiG7DfPBLMCxJVWyYSOgUcsybICxvv0hf5p80
X-Google-Smtp-Source: AGHT+IEtdwnNl1zhwm0zJTMTaAzTVGehCEQNymipUs87iXcurGE3yl/I9Hy29mFJtQZMSLEbg45DmA==
X-Received: by 2002:a53:c541:0:b0:622:6078:42bf with SMTP id 956f58d0204a3-623389c38c0mr6011595d50.5.1757723351254;
        Fri, 12 Sep 2025 17:29:11 -0700 (PDT)
Received: from localhost (c-73-224-175-84.hsd1.fl.comcast.net. [73.224.175.84])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-ea3cf211a04sm1793439276.20.2025.09.12.17.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 17:29:09 -0700 (PDT)
From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai Li <lixianglai@loongson.cn>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: rework pch_pic_update_batch_irqs()
Date: Fri, 12 Sep 2025 20:29:07 -0400
Message-ID: <20250913002907.69703-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use proper bitmap API and drop all the housekeeping code.

Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
---
 arch/loongarch/kvm/intc/pch_pic.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index 119290bcea79..57e13ae51d24 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -35,16 +35,11 @@ static void pch_pic_update_irq(struct loongarch_pch_pic *s, int irq, int level)
 /* update batch irqs, the irq_mask is a bitmap of irqs */
 static void pch_pic_update_batch_irqs(struct loongarch_pch_pic *s, u64 irq_mask, int level)
 {
-	int irq, bits;
+	DECLARE_BITMAP(irqs, 64) = { BITMAP_FROM_U64(irq_mask) };
+	unsigned int irq;
 
-	/* find each irq by irqs bitmap and update each irq */
-	bits = sizeof(irq_mask) * 8;
-	irq = find_first_bit((void *)&irq_mask, bits);
-	while (irq < bits) {
+	for_each_set_bit(irq, irqs, 64)
 		pch_pic_update_irq(s, irq, level);
-		bitmap_clear((void *)&irq_mask, irq, 1);
-		irq = find_first_bit((void *)&irq_mask, bits);
-	}
 }
 
 /* called when a irq is triggered in pch pic */
-- 
2.43.0


