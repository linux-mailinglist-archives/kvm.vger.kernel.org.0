Return-Path: <kvm+bounces-19438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD23190512A
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 13:12:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F21F71C2153D
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 11:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DCE216F0D1;
	Wed, 12 Jun 2024 11:12:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from njjs-sys-mailin01.njjs.baidu.com (mx311.baidu.com [180.101.52.76])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 860103D388
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 11:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718190735; cv=none; b=cVSflCNiedWS6Dj9h095Wdt74yQfb/e6Z4Y2Pfamgn2m5YXMxo1yHz/UsI6Ll6y6w1a8XTJscNa+9BhbAS2LWsPxeXtKl0IfdCR13hc5eqOgdlzAqhrax9T4BrhUNdTY2yFAOA6/nLlgbk3xFmQlscLRx9wZA0DdzheB4yAHH2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718190735; c=relaxed/simple;
	bh=YQwgEUtsefX4di3nvwQxGdV373+fZcCIXxWpKEcr2wc=;
	h=From:To:Cc:Subject:Date:Message-Id; b=dGeGzrUbSBpsXwJrWHfkNq2YCw/967vbt/oHh942mFsYiF3l7I4oJR23QC0SPO/hOP9NZqQmIDpojOJ5AmWx0xaqX7ggg6JTarrJy51ZcvTpLyOGHIqoscwALvXUeleF3+DH0hf5OPA3p/5NLNzQLhNWmAd28QzKB4ucJpEko7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 0DE0E7F00047;
	Wed, 12 Jun 2024 19:12:04 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: kvm@vger.kernel.org
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH][v1] x86/kvm: Fix the decrypted pages free in kvmclock
Date: Wed, 12 Jun 2024 19:12:01 +0800
Message-Id: <20240612111201.18012-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

When set_memory_decrypted() fails, pages may be left fully or partially
decrypted. before free the pages to return pool, it should be encrypted
via set_memory_encrypted(), or else this could lead to functional or
security issues, if encrypting the pages fails, leak the pages

Fixes: 6a1cac56f41f ("x86/kvm: Use __bss_decrypted attribute in shared variables")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kernel/kvmclock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5b2c152..5e9f9d2 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -228,7 +228,8 @@ static void __init kvmclock_init_mem(void)
 		r = set_memory_decrypted((unsigned long) hvclock_mem,
 					 1UL << order);
 		if (r) {
-			__free_pages(p, order);
+			if (!set_memory_encrypted((unsigned long)hvclock_mem, 1UL << order))
+				__free_pages(p, order);
 			hvclock_mem = NULL;
 			pr_warn("kvmclock: set_memory_decrypted() failed. Disabling\n");
 			return;
-- 
2.9.4


