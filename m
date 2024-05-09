Return-Path: <kvm+bounces-17087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 611DE8C0A90
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 06:47:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16DDA1F22B40
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 04:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC888148FE1;
	Thu,  9 May 2024 04:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UI4iiW8+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2E92747D
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 04:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715230048; cv=none; b=fL5uOSZFRdfBjboc56hhNJqeELLBUTnfin4nNmDO3USlQNEgRkBFF8pJaETkvxxo0oifCDgH8r1K1cgk/C/ioFIacFlZCHpwe6gRqEXsek0SkO1CeXLrbW7q/whUmsWiPrEJkhVY0FViDzSi0lJ9CQ1OoDyibeHPXwnbydePtQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715230048; c=relaxed/simple;
	bh=tsXJxYYe4zrSgUBEZqu1uz23nEbhwsKxT3TTPHDoWxw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QGJCMRw3bBM8pT1KtoHDwFH3oE45hBCyBCWEHU6CSh/51tfGQRD0Gya3jgYbFw02U/0qlya2yKFjhLl1CgwF42h3I69oHk4yku1sjVEOQy6/SLhJZr+ZcJYvuhgMYR5xtLYGZnuPJyJNHo8fDg8sCrpBT7XGg8jfV+F9cvt/PTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UI4iiW8+; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1ed012c1afbso4325425ad.1
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 21:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715230047; x=1715834847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KIz5Doo1tAoHaFhSBgAwdSb/rhhRVqkgZ/Pb/okDbzM=;
        b=UI4iiW8+rNvqsVbESMmzcFQJrWOeh1JlyXMzkiugD3lo341nenVO8a01XfC/5/lPp2
         56ubpsKaGLnwjk3/pn6W/4kupKH7mnbOpxFUgfitNcxMNFaC/Q7WwynLS7ezZpan7z8o
         y62XBj4xAMoaf3CoZmy6wPMA4AnHYa35qzSg1Fa3OjjOhTgqNugu9wnzkF2Yljg6Iref
         /yJ+PrRfHKmqzWhtdYif4L3pSrcXWl+uk0iRIHzSOaipyQyPzmc2RB9iAKkLpuxVjKvR
         8+MdsK6xteMKASG5SgQXQ8oChJ+al5nKo0/d82exMZoe8s6/uVZVfS3OYYlKCbYiKN+z
         /KGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715230047; x=1715834847;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KIz5Doo1tAoHaFhSBgAwdSb/rhhRVqkgZ/Pb/okDbzM=;
        b=YDyXPMwbOlhlkcI8s2FF+lT43sY3DniPtmWtbtlWTQeSJF4XVeYLyZkqGLx3VOBe1s
         wEAt1WktrVwSyP2ZX06jEthPer73jeV3hSq7kvkD12pbBg09QLmXsbvtGf/v5twDjktM
         nl7B26gU0aX08hSNsFThON/+GGmXU1svUy7i/2C6eTGBpZPo4GBuvqWsrP9KpzdB5JGB
         Y/eaTulmB9Cs5ZWGqVDa96YaNbL9q42h6ZX90r0VlFTLHrEy4TDnXk1mFt55lOOfrNjZ
         lI0cT451dLDQKweWRz1ldJrBcuyjvYCmVPtKmlJY/Eto9Dw1RRU/Ryby0Fl8Au2gC8Cx
         euMw==
X-Gm-Message-State: AOJu0YzC+xYV0K/XbVAss5FUYsrLzm9aRnX71fv97ahHhE6QKulxtWPV
	CDcAjuZruUf8XPS18kovaGktBEpopzYiujPFivrB3BZgfDxIi/m8
X-Google-Smtp-Source: AGHT+IE6Opr/4d9Njg0x0AbbdyXbxHxEGfhzvGsNKMdY1dbvo0rTDm9SBeevH05jgz2OCmlHW8zpLg==
X-Received: by 2002:a17:903:32cf:b0:1e0:ab65:85e5 with SMTP id d9443c01a7336-1eef9f4181fmr25948175ad.1.1715230047027;
        Wed, 08 May 2024 21:47:27 -0700 (PDT)
Received: from localhost.localdomain ([108.170.33.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c138c04sm4145865ad.267.2024.05.08.21.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 21:47:26 -0700 (PDT)
From: Liang Chen <liangchen.linux@gmail.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	liangchen.linux@gmail.com
Subject: [PATCH] KVM: x86: invalid_list not used anymore in mmu_shrink_scan
Date: Thu,  9 May 2024 12:47:10 +0800
Message-Id: <20240509044710.18788-1-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'invalid_list' is now gathered in KVM_MMU_ZAP_OLDEST_MMU_PAGES.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 arch/x86/kvm/mmu/mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index db007a4dffa2..49efa6a9c739 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6880,7 +6880,6 @@ static unsigned long mmu_shrink_scan(struct shrinker *shrink,
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		int idx;
-		LIST_HEAD(invalid_list);
 
 		/*
 		 * Never scan more than sc->nr_to_scan VM instances.
-- 
2.40.1


