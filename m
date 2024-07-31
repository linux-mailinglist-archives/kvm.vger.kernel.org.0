Return-Path: <kvm+bounces-22743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12092942A84
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 11:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C27A3283CA3
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 09:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B74C1AAE00;
	Wed, 31 Jul 2024 09:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b/Gs3ea7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5838A18C93B
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 09:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722418298; cv=none; b=MSLwk/uffkPXUD9Tlmd8j/4RE89fVfAi9a8QFrTfuDwofmEwMR2BcLgfAgnuHLBbOvrI0dYwN9X4bz0lZlws/pTWisCO6FlP/zJC245wt3RWQgYyT0B423hvl7miROQaawSV5UfjUy70XPfObdnYYDxoUs31xj7AMYFob+4wHRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722418298; c=relaxed/simple;
	bh=mXMwe7QfWwZZX25jxlawu2AU02xw0yh685W/Xsz2Tl8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Qki1IT4U4xnno8rOtz5SDny5Y67oNBVCIeMXGPsDAIrmZqkryNmpPALXnCWFFspc59mh+hQOxOiMclAPEmmgVVdmrWOJOmqNm3GiRldOt0acwgel9kE9bBhUiBSn3pMnD2XLbqUHu7FittgagRmMLefsJZXpFxMSCNy1OyuBC00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b/Gs3ea7; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fd640a6454so41513625ad.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 02:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722418296; x=1723023096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tAPwW2R9RXiwXKmn2Hdsapf0RNjOOXrUnl+0TYu7r44=;
        b=b/Gs3ea7wY+oDmWnJkLcgv9N+HgrSq970dNYlSq1FmZEgQLRQUoGLQMMd4Mlwg4kb8
         qHBQ9JP1QT7SLF/nI9YY/R8Qgb0Mx0F4WJ8ADj1kDz1Ft0vjreIxjzi81H9X94mQqLNg
         Ax1SKcFy71fQUXN/vo2jRX3c9UB/JHqP6skcEm3+SoGGVlVOFfwGh1qXbbc4Z7vjLvCK
         pGeyxHnjpxJW7yiNpw0oZ4QNe61lVbiyYkoR8XC1BI3MQhkUNsJKUwivBrvjTvG/QiIC
         T8lMTx33+nk6jFHh1C3U0qLxFUuBK2MN/+fuk9eTK2NxyrElZkfsb2eiJlA3wzxtww1Y
         JKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722418296; x=1723023096;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tAPwW2R9RXiwXKmn2Hdsapf0RNjOOXrUnl+0TYu7r44=;
        b=Cl+r+YiW5P9m085C+zl1ZOBDZnjrKzbQ2N+QW5Ec7f/f7dLZPu2GtU00bK8cN+Dbf+
         fHODvIx5BclA1q+E0tm5ipbe64gaX0OXSjsQ13UTcrCTx999lCaTAjp17QbdxqLlmxIV
         Deys6iixlNsPii3iRvuxeIs4xzpZQb6GdNiJvgYisn0R0rV1rrDC9HtbVFDHNV2zwKuE
         Bq0YMd4pHHUtlTnnuDj/2etljqGKQ7qG/xB3PN7ed2GT5nikZEiZFYFMCFra9DdhQfO/
         191u7FI3Ye7wwMj4+1HaxNRzdse56OGZQZ/HRWBeMfTxTZTq3SDxoZYAI+i5TxPQ66/h
         lebg==
X-Gm-Message-State: AOJu0YytdC8M/YW77MuPL2BCbdkmiAJ3xjBFxiBGJ0bfhjpYepcg448U
	Uuks1ZHpRmsMYGJAVXgQRiWKEvwAbPWX29jcBiKpFf7pHVc/dIujLgSN9g==
X-Google-Smtp-Source: AGHT+IHXvBtH4B7sSDb20TgaitZ2wF7pdEwxiSWQBcRMCU6/buiBTdo4QvjmftMbWcIBzVgdRSWg1Q==
X-Received: by 2002:a17:903:32c3:b0:1ff:3b0f:d5e2 with SMTP id d9443c01a7336-1ff3b0fd8d7mr44186965ad.32.1722418296518;
        Wed, 31 Jul 2024 02:31:36 -0700 (PDT)
Received: from FLYINGPENG-MB1.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7837e40sm116570365ad.0.2024.07.31.02.31.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 31 Jul 2024 02:31:36 -0700 (PDT)
From: flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH RESEND]  KVM: X86: conditionally call the release operation of memslot rmap
Date: Wed, 31 Jul 2024 17:31:29 +0800
Message-Id: <20240731093129.46143-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peng Hao <flyingpeng@tencent.com>

memslot_rmap_alloc is called when kvm_memslot_have_rmaps is enabled,
so memslot_rmap_free in the exception process should also be called
under the same conditions.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af6c8cf6a37a..00a1d96699b8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12947,7 +12947,8 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 	return 0;
 
 out_free:
-	memslot_rmap_free(slot);
+	if (kvm_memslots_have_rmaps(kvm))
+		memslot_rmap_free(slot);
 
 	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		vfree(slot->arch.lpage_info[i - 1]);
-- 
2.27.0


