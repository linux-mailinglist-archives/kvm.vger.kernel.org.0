Return-Path: <kvm+bounces-46202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E44AB429E
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:24:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E53977A7B48
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 416752BD02E;
	Mon, 12 May 2025 18:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VMbIzKAD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12692BCF6D
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073115; cv=none; b=D6rSZKseKqF/PAxIk7dmo+uBtkaYvZj0THwiFk06eSA/2oAnklTlEOqVPlZcsQtsMP2+E79TD6q9BhNPQuJPFiQNKnD8qyJLTS/wwzemixFjLH13SdlleDLN67SEB2FThSrpDuqvYtOH+Ua8Cv2pDOgoYJClyzIAFW7pVBDVXPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073115; c=relaxed/simple;
	bh=bPjiCjqbGho601hAYJaNiC12Xk8Ndc8umoktbQ2/CM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YNNd34wrPVL8JRrixPohm41eJqvxDebkruRfcIg0L1KQ34j25XAHT9anyYLOg3Yc9EhOcUF4xNHp91NSLoWJAI/7T8Lh5Z/YhTIiTGu1q7Iz+r56g55vbsPfsiAKgnE84TD9NZzMHtZeo/7kbR9Sx9Hbkx2Tr+I1qVwWLf7z4vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VMbIzKAD; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22e6880d106so33150695ad.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073113; x=1747677913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+wT6DnXqbX5AENDmRydoGeLBXcyCT3Vy8ui4SCalzaQ=;
        b=VMbIzKADCj7Z24v3SRBQhPvz25s0+ig3RracNwztHlRcdHY3eB6vVPqPh3hwLj9Ox9
         gHCC0orxVxh8yTVxA2M4hDQOgeozcw3FNA2qUsp0+95ddm168klhNkDL/vxiXedBPEct
         IchfJczjHwDscAS0Zt9O81ODs8ushOZCUVfI7R9NBqgF8vtsJ4XS1oBpJTW2h1THbTz+
         IE6ZWi78Czrq6mCNMTGRQkiTm5ET1NvVShUIHfOwgRQdSdSx3amJdRq+ppyq43UPuSxr
         FBMUv8YFfKpS19MrNHGEN9sTTmZA7ybkD1owKFvOBWEcwlofEp9CUgL57Yt2P7BW22RP
         euLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073113; x=1747677913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+wT6DnXqbX5AENDmRydoGeLBXcyCT3Vy8ui4SCalzaQ=;
        b=M1Rx/NogNIkDVpcCEP8PS6cIMlr5hvacPAJb4HwjmxPnTu5wzc4SSy7SpnTW6Gvf/3
         29dDtXiPhyXAj7IyVjjqVs+6BcpOh3Iz9qBgLm/h1d6e/6tSIr26d09wR7OD2Ta37mNj
         TfZOiU9O60L8WD5QRamLF+FQWFsbctv0+EdHQZ2WGWPOJJlzdnC/GOt3UdyPksMZ3Wc/
         GYtnOxd38S5XG/hxOGifTpfHLG6JxIAhzTGGrrBexqRM4PfUN13t2C8ajWQy3T18cJPB
         P1d9zM5fRa+m/4Uoi+17Hkp0eA8d3FCb7mAqu2xsuF2scRQV3bYI3UrDFboFVI3RPK4k
         vlKA==
X-Forwarded-Encrypted: i=1; AJvYcCW5P8uqQEgm/lABF4u7PbyhH70RSJf+fUxBfdeqhJzMKylnHOYiDH9LSmX1AhUVOJmYzz4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8QKXP9EkYMQCNZPe5L05QMsVeS7bHg6xZ296i9diIVKoLwvmx
	q5MgEwtEgqcYiz7Y/0IcOOW8dbrfVBU8SXgphGYPW4O4xdEQnRHyOBcdh7FyQgk=
X-Gm-Gg: ASbGnct3pq4JGghvQtvaEKG6RVsL9O3PXjLTdG8q3t7AAL7zZOBz+rcL6unqeh9ivjx
	kJqer9nwybowOXU/cAu6XGqHQptGpBr2yFVXaWeszbEwdU7sY2KFeRm0eiGzd+3vqyKgSEzGbtw
	C1xYXq+orXOP9Pjth+4thAWI2/3wfr3JTx6VYMHCP9gOqp76E0KrcHIdzxTdOyMUKBt6REQltPu
	nhopEQTb0NTvo3xV+8BJjpYnft4UMifA2EQx79mvHaA0PYs8QSYv1zEIHCCAnzf+WHv87mb0M7M
	h9mWCyoMerOunevEmmoLCsvn8TFwHxlsicJRhU4g6lyjKg0jg9w=
X-Google-Smtp-Source: AGHT+IHC9v0YNf7C0VB2fqmdISRjwl/2lgPQJoH5JAMzh04iqPHb+bGI5eSQIxgja1O4tGivjZuHZw==
X-Received: by 2002:a17:902:e84d:b0:22e:62cf:498f with SMTP id d9443c01a7336-22fc8e961a1mr224733145ad.38.1747073112762;
        Mon, 12 May 2025 11:05:12 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:12 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 01/48] target/arm: Replace target_ulong -> vaddr for HWBreakpoint
Date: Mon, 12 May 2025 11:04:15 -0700
Message-ID: <20250512180502.2395029-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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
index 660d3a88e07..5b421bc4ecd 100644
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


