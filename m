Return-Path: <kvm+bounces-25493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D194965EEE
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:24:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 603AE1C24860
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5DC3190671;
	Fri, 30 Aug 2024 10:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dW9FSb6Y"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514B818FC81
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 10:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725013219; cv=none; b=WXxecvpH1nrTjTRIwzk+Won/AcHkGeqaDWFC7BfCWBvzsIBdsp0JaQYFR5cVFe2FdP8WYGcS12prF3kXd/aqeJvEjh+Wz7rRczFWaOgA1g15xQUmepIOuvKDkaSDYeBU8y5O17llp79i8gxzSdhgn1S8AgonYdVpgrQTd7TO+Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725013219; c=relaxed/simple;
	bh=l4yxlQ0Zu/kNhdeaJsST/22tDf082lQye3M6o1Vd09c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m8jS+K7GKhdfaF5IeNJ78i5d9uNcM+/Sh2Jks3kNSud2nZMHUD/+sgMDdT0EeXrDCs8S37Ea6w2h48vNPhLI/bkxYmphG3g/wogeoC+1fxarnkOY/N632sfBm5yFg3Ul8B2GvLZQrqFE7BWZE2jTzALGDzQNe36Do/yospiCte0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dW9FSb6Y; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725013215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VNlTMG8ioFiMVQlBQ0UifO06mEmD/pnexSO9HRcQeyg=;
	b=dW9FSb6YxtLvmnGVUuXvF0btInw1rhr5odcTNKz2FUOp7pJUTJckQ6AMHR4BUdMSuEv/rr
	3hL6R8CedsBl0FnbeCCg+kfofSx3l7L9Fjgm6NUfkHwIM4M+KTBdbMiLP/t7V2PJooS1xG
	lAYv7kXQ6eYfQcjOHcQjphpn0MKsjW4=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH] riscv: Fix argc
Date: Fri, 30 Aug 2024 12:20:08 +0200
Message-ID: <20240830102007.2206384-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

__argc is 32 bits so even rv64 should load it with lw, not just rv32.
This fixes odd behavior such as getting false when testing argc < 2
even though we know argc should be 1. argc < 2 being false comes from
the register comparison using the full register width and the upper
32 bits being loaded with junk.

Fixes: bd744d465910 ("riscv: Initial port, hello world")
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/cstart.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/riscv/cstart.S b/riscv/cstart.S
index d5d8ad253748..a9ac72df4dd2 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -93,7 +93,7 @@ start:
 
 	/* run the test */
 	la	a0, __argc
-	REG_L	a0, 0(a0)
+	lw	a0, 0(a0)
 	la	a1, __argv
 	la	a2, __environ
 	call	main
-- 
2.45.2


