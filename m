Return-Path: <kvm+bounces-45485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D515EAAAD25
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:30:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E0C4164503
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64183E58BB;
	Mon,  5 May 2025 23:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k+wDqH4X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AA828B3E1
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487225; cv=none; b=SEo69NaG5mJzY+QX3AKIkTHJ2po67rMuG2QE8rFRxxGdG17xjwednydhxOJ6qgDnaf9bT8ta1recV67srIBcpNfJRvzE/qdpwXvvWN4wQr3SxqtuXfS0TyrPrxJWQQ1EJNj/CGuvI6j4KYMtBX3TSyD/jHByAkzHLTxJ0Y439Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487225; c=relaxed/simple;
	bh=GHQSRfTZut4cMFa1b0PIQYfUMpKuaypMKuod6WBId3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bC56/MMz0sZFrxQz394p4I0bwb7ssK6JXif57Sg61syXRljhPm1tuefuGvv8DTpbKxz8f/PxeMrYKro05TeTw8ln8+09YevhQQtwdiv4pL6yMhXphQ6+jc9IFrbCt6FhWXBdi9urkL3dNECxSkOT9SxOl1BBZ0vcaYJD/HYHTXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k+wDqH4X; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-30a452d3b38so4219397a91.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487221; x=1747092021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hghY4IeLObm8ysFk0eCwCGh3lWvsG0krLPTha8KLWmo=;
        b=k+wDqH4X+ZXBA0BZX3xwNirtAIgOvjNQxAWgVdiRHwTmr3KjaWAfYS8z1EbOdKSRnK
         31M82Mz/7hHjfHEvk0PcrpYxQ8x7G1TkYWJHnm59UndR5xLylxBp1JxABQCZOAUCGkSU
         ZVHvUbCq5/VpSdW0WT9e4XT/JUyHet9R7p6QeW+gPPCy48nn2hdJOB2EqYWCPHy0mKw7
         uTnZ5dFxUY7A0qaVKC8NBu/gw8WXi/LyDrqUIgA+WX1ZjciDF+ViyqLXKOuelkcKmdnA
         XJtUEnBhHByoKT1lH3YdVHnMIYU8BP8dNKq8AdjvjsBqphHBNgBHkmX4KaPpRuqxIVrD
         ucuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487221; x=1747092021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hghY4IeLObm8ysFk0eCwCGh3lWvsG0krLPTha8KLWmo=;
        b=gWJCE71EetnlbwHcx6crUV0rg8oANurdoF2SsdSJ5nx65YYRK3S6kS/H40j6GwtEwP
         l/nM/C71fTiAfFpc9ftKjfaXVCPhlzM4/lw1g7WMwbMKiNLMc7l65gXg2HJENyYpxwOD
         kS3rqiQA1uPRE96I+AW6BJUGXehgWYoqjdgKoCBzmn+oP5LUJJnoBZMu1pbXYHzYBF1y
         9xP3ah4VyHLIGjEWnUwPW7zdwSQVAJLzh206HjoTU1ph3xKTvlKvAvz2S2A+Rrzu7VFu
         MAKKOdpXQmTzAQj9QSGhRJiSSdSp5oyRje3LZ5GYH0J6rG/KbsH0C1HScXpjWzk6mSjS
         hWgg==
X-Forwarded-Encrypted: i=1; AJvYcCUXU/Kyig1jnIj+5Rytn3+pAex+HinRCBGiWsYA3MUHZEbhF1pIIVsVjWFo4p92ajHitRg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKR59JLhDe7ZlhOQcEOnT1z9rK5t5ZNdWjQhH5GkZgLgTxa58X
	y6HbNpCPmy2m6nELQM1U7MPFM9o8fR9Ss9mP3F9MJhzr5vhieveD1jPYrZHGDPM=
X-Gm-Gg: ASbGncvYyZ+tc1nmhhYw08Av35Oii1EnXUTZ8nKVO0PGToMF/bb74zFDcXzOBrmuDVr
	5WNt5wQAxtzD8Cx56UELiC53ApNCp/+dGgYbzLwmigk9kYs6W1/S/S82BEmE+CvTfrpZYSNYtds
	mb/h9QHqawajwVRmkahNeTshj9k8gDU3PKt+sOt7A7qdN8KJQbS07u/yqlCp1OGJ4mseUIpRu0j
	7g9FRxGjdwkrSzUbB8aXlHt19BdRAgHWnoMrwxKGi9IjEkBYwIDFrNs3DQGS5z1hbLX9J9CEkLA
	Ye/GIzo5xXl7Ih0aET2bEhMkBvKoqRUnfJJdrPQ5
X-Google-Smtp-Source: AGHT+IGyW/h0d+P++2N9HLg6A6FxaGbouVs5I8Cg2OUIrJYht0qMsNp9z55lD9B0AK5WzHNucV8FRQ==
X-Received: by 2002:a17:90b:5824:b0:309:eb44:2a58 with SMTP id 98e67ed59e1d1-30a4e623cb7mr18849133a91.22.1746487221594;
        Mon, 05 May 2025 16:20:21 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:21 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 01/50] target/arm: Replace target_ulong -> vaddr for HWBreakpoint
Date: Mon,  5 May 2025 16:19:26 -0700
Message-ID: <20250505232015.130990-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philippe Mathieu-Daudé <philmd@linaro.org>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/internals.h   | 6 +++---
 target/arm/hyp_gdbstub.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/target/arm/internals.h b/target/arm/internals.h
index 4d3d84ffebd..79a7449041c 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -1949,9 +1949,9 @@ extern GArray *hw_breakpoints, *hw_watchpoints;
 #define get_hw_bp(i)    (&g_array_index(hw_breakpoints, HWBreakpoint, i))
 #define get_hw_wp(i)    (&g_array_index(hw_watchpoints, HWWatchpoint, i))
 
-bool find_hw_breakpoint(CPUState *cpu, target_ulong pc);
-int insert_hw_breakpoint(target_ulong pc);
-int delete_hw_breakpoint(target_ulong pc);
+bool find_hw_breakpoint(CPUState *cpu, vaddr pc);
+int insert_hw_breakpoint(vaddr pc);
+int delete_hw_breakpoint(vaddr pc);
 
 bool check_watchpoint_in_range(int i, vaddr addr);
 CPUWatchpoint *find_hw_watchpoint(CPUState *cpu, vaddr addr);
diff --git a/target/arm/hyp_gdbstub.c b/target/arm/hyp_gdbstub.c
index 0512d67f8cf..bb5969720ce 100644
--- a/target/arm/hyp_gdbstub.c
+++ b/target/arm/hyp_gdbstub.c
@@ -54,7 +54,7 @@ GArray *hw_breakpoints, *hw_watchpoints;
  * here so future PC comparisons will work properly.
  */
 
-int insert_hw_breakpoint(target_ulong addr)
+int insert_hw_breakpoint(vaddr addr)
 {
     HWBreakpoint brk = {
         .bcr = 0x1,                             /* BCR E=1, enable */
@@ -80,7 +80,7 @@ int insert_hw_breakpoint(target_ulong addr)
  * Delete a breakpoint and shuffle any above down
  */
 
-int delete_hw_breakpoint(target_ulong pc)
+int delete_hw_breakpoint(vaddr pc)
 {
     int i;
     for (i = 0; i < hw_breakpoints->len; i++) {
@@ -226,7 +226,7 @@ int delete_hw_watchpoint(vaddr addr, vaddr len, int type)
     return -ENOENT;
 }
 
-bool find_hw_breakpoint(CPUState *cpu, target_ulong pc)
+bool find_hw_breakpoint(CPUState *cpu, vaddr pc)
 {
     int i;
 
-- 
2.47.2


