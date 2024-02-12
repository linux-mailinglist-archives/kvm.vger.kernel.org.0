Return-Path: <kvm+bounces-8575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 36F57851F3B
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 22:10:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8A081F22DCA
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 21:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29904CB22;
	Mon, 12 Feb 2024 21:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d9ei9th8"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59AD4B5CD
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 21:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707772213; cv=none; b=Row7jR60f1ISVp4oZgj5OPiyRDfM37DRPSBHRMAl9DiqDeWYsa7J8/fb2jV9IRObpKGt7Yn/e34eZSI66ZVkKcws6hsw0DG3gljzn6Nzk3NrjqyLaMgZW1i1wqFPQufyXptTPin1ehX2jZBM7uEoUQmsWOALbk0v/qbTmSP3ODA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707772213; c=relaxed/simple;
	bh=V2K3Tqa8gFu4PA1KW3ElYY3Gm+CaB0UlpxRc/Dm88V4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hKkaMtUzd8Zi3Tdgqdknew/x2KudW6Qy6jjydhfzFHD8gz/aWWYRAwSesf3erDY3xXG7R9P9AJ3bseC2DNDnhJ7czQvka59nzYqyiCv8gxoJoZFlAmbtIvqE5KgrmFdvBFMDkwUwzCVawhxLawaMO1dKb34qCzAekc8VBlezyVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d9ei9th8; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707772207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ho2ychX5rzcZXGqMft5IUPj+UTWREdBWn8Koftkvhk0=;
	b=d9ei9th8fcogKE0TDUvOgUz6IIwo3rQmVdChHOVKeZ0S1+n3rZ3FgUStc9VVsDUEbJD1R0
	QoYZvxKJJftGdkfCirawYzO+KT4wFkeMK6+LPwuPxr53YfunovI0mDgz94yL2bPbkItKAU
	SVfmES5t3kgv86WmHRXSt1oGwe5f5kY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: selftests: Print timer ctl register in ISTATUS assertion
Date: Mon, 12 Feb 2024 21:09:33 +0000
Message-ID: <20240212210932.3095265-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Zenghui noted that the test assertion for the ISTATUS bit is printing
the current timer value instead of the control register in the case of
failure. While the assertion is sound, printing CNT isn't informative.

Change things around to actually print the CTL register value instead.

Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Closes: https://lore.kernel.org/kvmarm/3188e6f1-f150-f7d0-6c2b-5b7608b0b012@huawei.com/
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

Applies to kvmarm/next.

 tools/testing/selftests/kvm/aarch64/arch_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index d5e8f365aa01..ab4b604d8ec0 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -160,7 +160,7 @@ static void guest_validate_irq(unsigned int intid,
 	__GUEST_ASSERT(xcnt >= cval,
 		       "xcnt = 0x%lx, cval = 0x%lx, xcnt_diff_us = 0x%lx",
 		       xcnt, cval, xcnt_diff_us);
-	__GUEST_ASSERT(xctl & CTL_ISTATUS, "xcnt = 0x%lx", xcnt);
+	__GUEST_ASSERT(xctl & CTL_ISTATUS, "xctl = 0x%lx", xctl);
 
 	WRITE_ONCE(shared_data->nr_iter, shared_data->nr_iter + 1);
 }

base-commit: 680f749c272378a796388a3244bab53b5a952d67
-- 
2.43.0.687.g38aa6559b0-goog


