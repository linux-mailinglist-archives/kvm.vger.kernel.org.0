Return-Path: <kvm+bounces-19532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B23FB905FBF
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 02:33:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 974DA1C21235
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 00:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400C68472;
	Thu, 13 Jun 2024 00:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fHP6Lqug"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075238BEC
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 00:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718238769; cv=none; b=J/xHQc19EMiG1/6RB+1Rbq/cXXUI/M54o1DkkAy0rfUrq0/g404Tf3I7igAyuzepso0zWmJcXrhTdBo7hnNrCQPn1+9yWPUb60oyWMwDH94JULN8ACV5cRkeqbxDrcos+vTnFMvwGeSUgzN06VAVKa6UD76BiOs7+j90ri27Rgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718238769; c=relaxed/simple;
	bh=wIdpjxSTQcJcaSC2QLNCzSZfTuBcHdMrdFb9Tzcw6jo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GGoae3a5iORfjz2piv2p/H56S3HOG6LZ2w367vmlOp+Z2JzKDdyN9HMT4aEAb6jxD7t9Z+DRUoUdRqfF6eJsxKhJQeQZFhzRqg1MuVRxawpttEDjg6829ApgsNOypfbtvZhFlHwSukbGG+sJKU3z/AZzLVb9ybd2JOq36kuzzoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fHP6Lqug; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6b06446f667so2264896d6.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 17:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718238767; x=1718843567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3mbR6XjTl+XtcpIp/RRx4D+3ymHI9xlwahgvOSA+M8I=;
        b=fHP6LqugiUmQeOvdYwn6Rh+jTvkTCyjb2QedaiKrpV1Wnc3a+d0yk/22TALkP39ftT
         nNaK1FIBRmApJo7D+rnooOl9B4X5SYrUebhyv+oN8DenjPgTOW6zJJ3kcIf0xA9v6a7H
         kIoUkfwaQa6g4T3JuVTiW/ixiSNLo02kDK7/ctSVGTDy3SF9fj0Ta3TxnHhIcJLc4ZWN
         8XVsRHmayYGBOYfrb9GcIbAarqmRAjxXr47MpG/IEgpgjTgOFz8MmlkSeI7+Hnq20nhB
         N5Tcd9edhZRVUUa1pLNdvMjKM98ws1EyUtB/+w8O8OBcLfz0ET5qjpt4YEUQfAoKFyPg
         cURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718238767; x=1718843567;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3mbR6XjTl+XtcpIp/RRx4D+3ymHI9xlwahgvOSA+M8I=;
        b=mJt+594WR2Lfyok9pUMXI9hhqnMGlHrAz4+P1HNz24zCxrlEaVAN00Bc8BFXQS4jcM
         lM2/YR1d9xQ+XD2Jni6IZwbCYKq9rve7Uhcio2ylGNDtfzsBAqO898TvNBI0z5k41qPm
         q04mEtMnuIazZcvtiQRPT17D8r6vuyZR3kTvcrR8UULi+EO1g5eDmm3U2aNsfWRpMyLD
         wum14WG6YYRr3ob1ccmLzFZW84kkmqqr6sxZO4xg8bNjuyTkfgQQmnN6ET/uKrGi11Hb
         dT1+swvL8t2PwtWWYa4R1d1jEwejINEJlHxt1QaMK73FMVt42PaDPI65G2i41KImyZ0+
         S+OA==
X-Forwarded-Encrypted: i=1; AJvYcCXyxJ68Nye6K50QgbP8UMw2X70HpI2pmXDBIgYKgsemm19ok5uqK774tkSGxeqpqQDk0RyDmSM7QGTCJ4UbotmjkNDg
X-Gm-Message-State: AOJu0Yz7CGvBZiQ+X+hKvyqqzSPC/Iqx6/vYKI1aJg1yKhEHdVDmHmSx
	25jkKDvn97aICyhGfH3CW42XSsJLn3KVQ6gsp5whP7qH0lWNLF9IPNrw3kQbNu0=
X-Google-Smtp-Source: AGHT+IHFPjnZjBLu4CJatyVfxKESSD90OLqXHRp1aUlpSK6t2DyCI0DsxgS0il+4700/wqvrt+Kc3Q==
X-Received: by 2002:a05:6214:4285:b0:6b0:78f6:8484 with SMTP id 6a1803df08f44-6b192028b32mr38503156d6.30.1718238766772;
        Wed, 12 Jun 2024 17:32:46 -0700 (PDT)
Received: from localhost.localdomain ([185.221.23.200])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b2a5f017c5sm1238316d6.137.2024.06.12.17.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 17:32:46 -0700 (PDT)
From: jiaqingtong97@gmail.com
To: zhaotianrui@loongson.cn,
	maobibo@loongson.cn,
	chenhuacai@kernel.org,
	kernel@xen0n.name
Cc: loongarch@lists.linux.dev,
	kvm@vger.kernel.org,
	Jia Qingtong <jiaqingtong97@gmail.com>
Subject: [PATCH] LoongArch: KVM: always make pte yong in page map's fast path
Date: Thu, 13 Jun 2024 08:32:17 +0800
Message-ID: <20240613003217.129303-1-jiaqingtong97@gmail.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jia Qingtong <jiaqingtong97@gmail.com>

It seems redundant to check if pte is yong before the call to
kvm_pte_mkyoung in kvm_map_page_fast.
Just remove the check.

Signed-off-by: Jia Qingtong <jiaqingtong97@gmail.com>
---
 arch/loongarch/kvm/mmu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 98883aa23ab8..a46befcf85dc 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -551,10 +551,8 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 	}
 
 	/* Track access to pages marked old */
-	new = *ptep;
-	if (!kvm_pte_young(new))
-		new = kvm_pte_mkyoung(new);
-		/* call kvm_set_pfn_accessed() after unlock */
+	new = kvm_pte_mkyoung(*ptep);
+	/* call kvm_set_pfn_accessed() after unlock */
 
 	if (write && !kvm_pte_dirty(new)) {
 		if (!kvm_pte_write(new)) {

base-commit: eb36e520f4f1b690fd776f15cbac452f82ff7bfa
-- 
2.45.1


