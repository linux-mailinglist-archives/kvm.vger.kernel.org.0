Return-Path: <kvm+bounces-27239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DCC397DCCD
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 12:08:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FD4D1C20E75
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 10:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9548216F8E9;
	Sat, 21 Sep 2024 10:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X9dMSUCs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7970716F27F
	for <kvm@vger.kernel.org>; Sat, 21 Sep 2024 10:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726913322; cv=none; b=fpyAxRj2S8M+n0DAUkR7CdZ5Mno04CUvkmJFDIXhwZZONHwds6gEgiHUhrk9DmJXAG4Rqi/TNxs69FD25IEOjwV8JiQ7XTJKWM2Stq1UsixJarTLVglDSHmf2sMaLx7v2kwH7ejo9sR2wyOSqOW9aUdmKJY70/nm/9QrxGS6MLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726913322; c=relaxed/simple;
	bh=CAOcGGebaRx1S04DKIJFc1oHsk9PnK/vZ5M7iYx42Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLWVwLNBlmoh2NK8pKrieuNRh5tYtjDrEXVVxGfuNs79iswcVDpbZJ4WkLmyCQS/XhiaVtdqFyDp6V7oZgca+5y1tKuFZGKwMbGaVJwS/74rAxS41PvdYDF5ZZ8BYIwNbvnslWWebwcNjSrzBI/Xy7QeiTqTcMLr6OhKenXKS3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X9dMSUCs; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-71971d20ad9so1955694b3a.3
        for <kvm@vger.kernel.org>; Sat, 21 Sep 2024 03:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726913320; x=1727518120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=od5yEkBBSMRl70l2ICtIaZs6wNRd82e2Lcyy8jXXe5k=;
        b=X9dMSUCsUW/8ErHNNrOUcGwcZV7QN3aqz2euUf10d4PQznUsMWZCJF6P8znjMmGV0g
         v1n8tkV6BhyMdIao8zu+zqoKqX4pxeuLa7tHs0HDx1YXFZW0KPoS1DgY9JzLybvZuMSd
         WlZnayP5SOS/nLyIwOMP6FrhAu81Ec/TBCXAxDNxpGguHzZKCpmh2pUP+qOtqJl58tRw
         STX3IlBazE51LeKx3X5SM31cp4WgHH2TDY4DGJeODxx+U9nsCjzcpv+is3qR7/ypWMpQ
         xPtP+ZVEkYzJ9qTvRbtGm91IiYcZiT2gDlgGg3WP7/mY65vLc8pQeNYLUt5SeX1fFGpE
         ih7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726913320; x=1727518120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=od5yEkBBSMRl70l2ICtIaZs6wNRd82e2Lcyy8jXXe5k=;
        b=GRGf2hV+Z0XymjIz0NJEpw2+uXpT5Xp8ZjHPxiZZLu1/wkNcK0ngFDeEt5W4Lfs8xg
         facFbL9T3RMrLmKa/tbEfhdSq2hsi/YwUCb9UNW78HOBMARBGmGSPzQ4VVzbVDf72pH9
         vmxXq1GYKTArK3xCXTVW57HrNzNRwUuQilRbOyAWmY3p5x6L1YtCWtTAUI9zb+eoPS14
         ckHzNvPQQaPeu1l0QPHfyxn0H1uU9qO7fgQn+1e2GOR4wh7PRr1gv23/4gI2QJqy0+53
         URSyhfyoOk4/0oWqN409ImHl5hAlTW9An51bLQiWBQXgIm75GreZltA9WERrJC7Y8zbZ
         OYug==
X-Gm-Message-State: AOJu0YxWEKXpr1AHV7mgeYEeRs2COy1lbPWYphEoqdN2XbnmJdbZYVNB
	HDccyqEVxG+sjB5U/4o41qYp2MeMGsLCGm0r7VwMLm7IwgGczD5MlmcieiH/rt0=
X-Google-Smtp-Source: AGHT+IGKS/E2gA+YQYbl1PX33pehG2KROtr1xdO2y1XDw/0CD4KQ3nWvvjMzor0huCIvufYAmqbyyg==
X-Received: by 2002:a17:90b:3c83:b0:2cb:4c32:a7e4 with SMTP id 98e67ed59e1d1-2dd7f4270ccmr7201493a91.15.1726913320042;
        Sat, 21 Sep 2024 03:08:40 -0700 (PDT)
Received: from JRT-PC.. ([203.116.176.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ee7c03fsm5680024a91.11.2024.09.21.03.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 03:08:39 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v5 3/5] lib/on-cpus: Add helper method to clear the function from on_cpu_info
Date: Sat, 21 Sep 2024 18:08:21 +0800
Message-ID: <20240921100824.151761-4-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240921100824.151761-1-jamestiotio@gmail.com>
References: <20240921100824.151761-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a CPU abruptly stops during some test, the CPU will not have the
chance to go back to the do_idle() loop and set the
on_cpu_info[cpu].func variable to NULL. Add a helper method for some
test manager CPU to clear this function. This would re-enable
on_cpu_async and allow future tests to use the on-cpus API again.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/on-cpus.h |  1 +
 lib/on-cpus.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/lib/on-cpus.h b/lib/on-cpus.h
index 4bc6236d..497ff9d1 100644
--- a/lib/on-cpus.h
+++ b/lib/on-cpus.h
@@ -13,5 +13,6 @@ void on_cpu(int cpu, void (*func)(void *data), void *data);
 void on_cpus(void (*func)(void *data), void *data);
 void on_cpumask_async(const cpumask_t *mask, void (*func)(void *data), void *data);
 void on_cpumask(const cpumask_t *mask, void (*func)(void *data), void *data);
+void on_cpu_clear_func(int cpu);
 
 #endif /* _ON_CPUS_H_ */
diff --git a/lib/on-cpus.c b/lib/on-cpus.c
index 89214933..cc73690a 100644
--- a/lib/on-cpus.c
+++ b/lib/on-cpus.c
@@ -171,3 +171,14 @@ void on_cpus(void (*func)(void *data), void *data)
 {
 	on_cpumask(&cpu_present_mask, func, data);
 }
+
+void on_cpu_clear_func(int cpu)
+{
+	for (;;) {
+		if (get_on_cpu_info(cpu))
+			break;
+	}
+
+	on_cpu_info[cpu].func = NULL;
+	put_on_cpu_info(cpu);
+}
-- 
2.43.0


