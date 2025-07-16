Return-Path: <kvm+bounces-52653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9299B07BB2
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 19:02:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD17E1C4054C
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 17:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E201D2F7CEB;
	Wed, 16 Jul 2025 16:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P4XiHd9s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961B52F6F9C;
	Wed, 16 Jul 2025 16:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752685182; cv=none; b=XRVrQidUosNsh3fYZLTlgBNJNuStLz5EoOzfhO56YU8bzkIxMJPyqhDeVHFHjj+zolLZdej2y4yoF4L7JuYmW/azSVgrxr6fXln62d2xSrsUotbV31KCcf/07lRXzA6RdbsMQG9BtX6c4gVnaGxQHcCCnggZqsExrc7lEE00o/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752685182; c=relaxed/simple;
	bh=deNZy0gqTMsn1Sk/pOG5xml3B2QMrUmUO+2dpO3ZPv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPnXOg25bmpRgAE8VMPibKwo8qfgeY2MSBtRPP5ide85Vbzh4sFjkGqXyXrxktjmY2VrutyLGyyZaDcqH8oigryPr4QD4C8R8YbiEDZokT8NUUnlc4aUgTC0oHgc8884BNc2yvyFV/gwnq1m1jSXlkUupXWmH1BvTjGtajzDUcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P4XiHd9s; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-235f9ea8d08so353045ad.1;
        Wed, 16 Jul 2025 09:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752685179; x=1753289979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x9i9Yeqsjy/MBvGhDry9fFhgb0aml5g6UAa/VUCvHos=;
        b=P4XiHd9s+H5w5oCF2tZpAzXEr8eJetgj2mCdaefcJ8qNttPF0NXLvKV76uCgrQh86z
         VEmFymE+JChvhn6wMYv9BaLIzR//kJq6TNG3o1m8DNjcZx4HrEoXw4rfTeWQhixynTHs
         tce3EmhAWbEmA7K5v08cBPLXidbfxJo8ZtWKPHMxIX0E+PnJYw0nUwzf6cLTjymvcKn+
         FLwuN+kVNkZCFMitoQGvq+HDVEe2ei8nOSVRD+P7yRyGMrG1P60TkqP5/l0u4PJ8jYqN
         oOowsW/LVTP46g5gTrlxQShZvHVxhz2gVAmlP4Z3mh2DaeAZRyTD0RhMI3pZO/3DHT2e
         Iq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752685179; x=1753289979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x9i9Yeqsjy/MBvGhDry9fFhgb0aml5g6UAa/VUCvHos=;
        b=HijqA7ueFR2XS8r3jxntsbAuBSD/jnF9nHq3iq9qjMs8T5NZrLA2kY9Xle8+k252rD
         nd5g1h1C9FcDpLHd8PsN6sDHxUccFgOkoK9JCqaQO7jxybX352gQwBJkYf/F7zPm6EMe
         FltpaP9/tbdkxcKS6lY+PHDD24phLjMdnANR52vjQyad0wVlBULNIhkI3Fz+ln2i3lZh
         qs5fjL99emIeBOi3DObEbGt4M1zcNSi1sCI3CZnhYP9b9rENsL3NZvHy2tQs9pvnQs5e
         UafKNQUy7Pbap8PACHNvddt5jc/0YVGrlht8DMSjEiN5JApDjhq8j7YyXDH8eL+lTwV9
         NdCw==
X-Forwarded-Encrypted: i=1; AJvYcCW4GkwPIpRjNiLVV8l1v60isCkj/xqEbGfxdUlGTMeRJYCxOFIQ/+D3PZKnd1CPs7GJtqM=@vger.kernel.org, AJvYcCXGU/Vjs6pv9VLqHPtuRXTwtoy2LCfz58GuX/w/TbpdzjVHI+2ZAH42fuAfWTsajQ+DYpan7a8UfNBv+Goh@vger.kernel.org
X-Gm-Message-State: AOJu0YwxLHc50GFXq942OtTm7ejbP+FoMjWgaNF4b9Kpr89dQuPKsuTg
	UuOQ7F5nib6KOVJSJg0fopCyr84hLtS2g4tCL7gSv/bOcnBBLv7gisS5
X-Gm-Gg: ASbGncvHuZYBTO7XIkfxovJK0b21KSl7/tIyF7J+YdWjLpxKb+HPRzAkZF2VprcAcp+
	nyeSqvuKkA1ySC9r2IZFRbnwY6rySu4V2okWG7m9F3yxwq+ZK0dWdqck/w/DcGWuJDpPBhh9gF3
	DsN4UGC7xcjoz9tnW8rH8oVttEzor2TqqQcqsEX/ikg6Igc1zIjxoIiUpq/0vYfNdhQUN2qE7WG
	XJuPfFpwv6xsTW79pCb0EArbyt/QWHKcnTkiMP8wMrXOvByVPnGBriRO4Jm733NCGF+qBYiXCqj
	Er3GShw5Xz9ZJwmCTRqmd7MW7FrPI7jZtN51BudycgX+VZzD3Z9pv4QYxJz+9JU8fIrocRWTCqb
	QNX4eiKDtENFzN9Y7/8FHt8NyNumGzHEE
X-Google-Smtp-Source: AGHT+IFDKpvzgv7uLs+wBQtKXYWTaK3q+F2DNaQGyC1M1O4xIioma5k1pZH/BBkL+8lpjDhwWdQUPQ==
X-Received: by 2002:a17:902:ccc3:b0:220:c4e8:3b9f with SMTP id d9443c01a7336-23e24e129d1mr60238965ad.0.1752685178720;
        Wed, 16 Jul 2025 09:59:38 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de4359ddcsm126901705ad.207.2025.07.16.09.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 09:59:38 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 2/2] LoongArch: KVM:: simplify kvm_deliver_intr()
Date: Wed, 16 Jul 2025 12:59:27 -0400
Message-ID: <20250716165929.22386-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250716165929.22386-1-yury.norov@gmail.com>
References: <20250716165929.22386-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>

The function opencodes for_each_set_bit() macro, which makes it bulky.
Using the proper API makes all the housekeeping code going away.

Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
---
 arch/loongarch/kvm/interrupt.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
index 4c3f22de4b40..8462083f0301 100644
--- a/arch/loongarch/kvm/interrupt.c
+++ b/arch/loongarch/kvm/interrupt.c
@@ -83,28 +83,11 @@ void kvm_deliver_intr(struct kvm_vcpu *vcpu)
 	unsigned long *pending = &vcpu->arch.irq_pending;
 	unsigned long *pending_clr = &vcpu->arch.irq_clear;
 
-	if (!(*pending) && !(*pending_clr))
-		return;
-
-	if (*pending_clr) {
-		priority = __ffs(*pending_clr);
-		while (priority <= INT_IPI) {
-			kvm_irq_clear(vcpu, priority);
-			priority = find_next_bit(pending_clr,
-					BITS_PER_BYTE * sizeof(*pending_clr),
-					priority + 1);
-		}
-	}
+	for_each_set_bit(priority, pending_clr, INT_IPI + 1)
+		kvm_irq_clear(vcpu, priority);
 
-	if (*pending) {
-		priority = __ffs(*pending);
-		while (priority <= INT_IPI) {
-			kvm_irq_deliver(vcpu, priority);
-			priority = find_next_bit(pending,
-					BITS_PER_BYTE * sizeof(*pending),
-					priority + 1);
-		}
-	}
+	for_each_set_bit(priority, pending, INT_IPI + 1)
+		kvm_irq_deliver(vcpu, priority);
 }
 
 int kvm_pending_timer(struct kvm_vcpu *vcpu)
-- 
2.43.0


