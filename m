Return-Path: <kvm+bounces-25024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3592295E800
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 07:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A1D7B20BE4
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 05:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D0274C1B;
	Mon, 26 Aug 2024 05:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LCj3sRVh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3E77404B
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 05:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724650859; cv=none; b=h5iUQqj6kA0AIcd7lmahrCkvBcBkoxUjaai566aoBL2MxXGHiGKm12hzifeIxG+2HF20NjjjOemAezZQitdN0bhyCoMduL62+jTGKFiMryrgg0yXBBAGEQ3P24MOwM9AnBEdDkuoupyVo+2CY9M6bTRY/iVVjMZvtDlpwa0j3mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724650859; c=relaxed/simple;
	bh=s4QG7tYKyhdb/Dzz9tDNshx6Ns4OkO8WFvsvqXHhLM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tyF7JPBkzQ5ACKGzgDWYAcwpZzr5CgM/TjxNlqTN2NDEGRNz9O74RCC4wCv7Fy7VIZ6usrPBrEeWNe4L4M5uH1Oap6Cpc3krOr9UlyiV0SAYerkemHnYsA+OccVigJUOh+4x/OIX+KYfmFKw1q4JGI32/P3XK1q80S3cBz6159M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LCj3sRVh; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2d3badec49eso396096a91.1
        for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 22:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724650856; x=1725255656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b5cTDvXzTrF2BAOmNZXpI33rXK3/Os3EG5NCOfWTdTA=;
        b=LCj3sRVhNHZYD/AzNVXg+Ft8yTWhssYwty57lQeqXzI+C66Ho9rkOgskPxaCnccxGs
         u0u+v68WcVofhW0MgI4tj9mPhvzYRY3T/2QPqU8AHSJ7jXMI/F2vjOvtzU23DeDPIKRL
         2mfhpUfH9KQ1eA28mJQzBRPJF0t0AyQB5mappFjhTkX0q0ftuBwL1BaZCDqES+H+ID5w
         tfzwQqQbD6/N1CF4D/N7UchLtSul8ubgpBWtRv+mLbcisyy9Ngv0G35vsmTsHj8LcBPV
         xi//P5jQg+TLfgWIZRV7hEZYyMGzyzG8E00rbSidM08i0pfzhSqIL/FUD/C1KH4rnlFz
         iQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724650856; x=1725255656;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b5cTDvXzTrF2BAOmNZXpI33rXK3/Os3EG5NCOfWTdTA=;
        b=s591j7a9/SJc5mY0Dx4VhitBJWF1A908GGg3dfYNuHjWcRtAY7AE01+9p/PmLCjyAh
         D0azKPkZ1BCL49gTigtxkyeZMP4gCEKmPHOUWuiAHXpmmzHHkP/A0vyg8XzQVCmivLH+
         okb20V+inoyP+ZvjnUGCri+C06tNGXWe0rNtC6XuMfSEOItl6V5eqpwMUMo7pXKF4m9k
         qLi2Yz4+mkdMS0uID/Ap/wjoWRtTBDhxNtllcH6UeJlwc6DnqtjeIV256/Zi86BFqwo7
         YFzcSBAnu4+Otbf6WkhqdUX9szYRaf4x78V+4wj4Llws08bCYFqjRJmL3Ndwd5BZWex0
         9oig==
X-Gm-Message-State: AOJu0YxVOegEuxr1RWupSrBF+01/9Z1pWjyesRAndijxR+GnDnGPWbdz
	uM9hp9kMPqOnfgfs+Gnp9EtFaq5+/8V+5xR++LbwVZkr2+FZas/BYJ7vSy94
X-Google-Smtp-Source: AGHT+IEeBG5qw9lysmT9wcg70xc3DzOrv7ZbFD9jlHjRf0cjH4SmCtBrPprLNb3V7Ws5zsPmpdBgsQ==
X-Received: by 2002:a05:6a21:3295:b0:1c4:c402:8189 with SMTP id adf61e73a8af0-1cc89d29fa9mr6158828637.2.1724650856160;
        Sun, 25 Aug 2024 22:40:56 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-75-144.hsd1.ca.comcast.net. [73.185.75.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2038560eef3sm61341645ad.204.2024.08.25.22.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 22:40:55 -0700 (PDT)
From: Cade Richard <cade.richard@gmail.com>
X-Google-Original-From: Cade Richard <cade.richard@berkeley.edu>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH] Changed cpumask_next to wrap instead of terminating after nr_cpus.
Date: Sun, 25 Aug 2024 22:40:38 -0700
Message-ID: <20240826054038.11584-1-cade.richard@berkeley.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changed cpumask_next() to wrap instead of terminating after nr_cpus.

Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
---
 lib/cpumask.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/cpumask.h b/lib/cpumask.h
index be191923..5105c3bd 100644
--- a/lib/cpumask.h
+++ b/lib/cpumask.h
@@ -109,8 +109,10 @@ static inline void cpumask_copy(cpumask_t *dst, const cpumask_t *src)
 
 static inline int cpumask_next(int cpu, const cpumask_t *mask)
 {
-	while (++cpu < nr_cpus && !cpumask_test_cpu(cpu, mask))
-		;
+	do {
+		if (++cpu > nr_cpus)
+			cpu = 0;
+	} while (!cpumask_test_cpu(cpu, mask));
 	return cpu;
 }
 
-- 
2.43.0


