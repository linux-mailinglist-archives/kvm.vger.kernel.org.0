Return-Path: <kvm+bounces-22934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 383AB944A24
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 13:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69E221C23570
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A8E418952E;
	Thu,  1 Aug 2024 11:11:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33860189521
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 11:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722510665; cv=none; b=SE9xTVje7ibihAG6q69FfXQYmXRmOvdFR55eJEj1ZxV5oovOCqAy+QxtgTJwf/wke7HU87YWV4FPrE15Lo8aQ5faglJ8r+UmRe49Ii0Vjz5GEJ9GJ8DQhLWJ9PZPmVyPPbRKQ/0GjAcgilNtf7lwxJ0CbVK/wHCu1U9EYY/OBKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722510665; c=relaxed/simple;
	bh=RekK4lMgCZd4a2+c3wBVnBu03mBKuGFLxyUA6Jodd7o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=EWVha7klX95/yRXwdNJn69aIY6oBnFPYrIgeUvj6uaVA0ycEl1qVOSHe4AJvtmwEKvT1KxgDZJN6YL7k3ptqy3hC6EO6C1Qro3qsl/KZnxyc+iznPpaj0sj+KwT6m08rTmvD/P7dqM5bkQ52wQR2wVVKzu0X2+VNEfkIcUr7+E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 468CE15A1;
	Thu,  1 Aug 2024 04:11:29 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.32.100.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FD463F5A1;
	Thu,  1 Aug 2024 04:11:02 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: kvm@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	=?UTF-8?q?J=20=2E=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH kvmtool] remove wordsize.h inclusion (for musl compatibility)
Date: Thu,  1 Aug 2024 12:10:54 +0100
Message-Id: <20240801111054.818765-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The wordsize.h header file and the __WORDSIZE definition do not seem
to be universal, the musl libc for instance has the definition in a
different header file. This breaks compilation of kvmtool against musl.

The two leading underscores suggest a compiler-internal symbol anyway, so
let's just remove that particular macro usage entirely, and replace it
with the number we really want: the size of a "long" type.

Reported-by: J. Neuschäfer <j.neuschaefer@gmx.net>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Hi,

can someone test this on a proper/pure musl installation? I tested this
with Ubuntu's musl-gcc wrapper, but this didn't show the problem before,
so I guess there are subtle differences.

Cheers,
Andre

 include/linux/bitops.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index ae33922f5..ee8fd5609 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -1,15 +1,13 @@
 #ifndef _KVM_LINUX_BITOPS_H_
 #define _KVM_LINUX_BITOPS_H_
 
-#include <bits/wordsize.h>
-
 #include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <asm/hweight.h>
 
-#define BITS_PER_LONG __WORDSIZE
 #define BITS_PER_BYTE           8
-#define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+#define BITS_PER_LONG           (BITS_PER_BYTE * sizeof(long))
+#define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_LONG)
 
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
 
-- 
2.25.1


