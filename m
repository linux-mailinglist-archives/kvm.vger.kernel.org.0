Return-Path: <kvm+bounces-45767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 683D1AAEF57
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D262985C06
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B37290DB9;
	Wed,  7 May 2025 23:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cnXfzgDn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EEA2147FC
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661366; cv=none; b=SsVEPMVOE5s2NmLPo/KEssDiUxVrePHBdkIyMPIKW64M0Vyo8UrbAljwBqpk6aq6vEpkGD4CjQNUDkupdKMZamegucnLQ6YptCAaEZfJ8aZA/KiXAkpBY3SBPhKFUaPOLlM4IjED157FJaK3neKM4ZktS/8903okqasTSBS+imc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661366; c=relaxed/simple;
	bh=bPjiCjqbGho601hAYJaNiC12Xk8Ndc8umoktbQ2/CM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YL0D6sQaE9iWl6HKc/OvtuGkxsoKqi8z0NEE9lN4HnbN9FUNIqml9xq/GqnEs6wn44heoySl8nfpuldadKRhkmk3HAkvzDYFZjhm0SwwxDm6gqJ2wxWnV6WIyAhEJqkh1Sx7ZDjyQxMo6TAilp55jUGxBE49ClPlxQNYG5vlebo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cnXfzgDn; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-227d6b530d8so4592505ad.3
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661364; x=1747266164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+wT6DnXqbX5AENDmRydoGeLBXcyCT3Vy8ui4SCalzaQ=;
        b=cnXfzgDnLUY0cUCR6UHaG2i9y5+WiX4zUqE4Td8G68BWtuZ8ofrKPIrccmK02Pgg1i
         /KGWAlWnC36tydEmO6gE/IAqU3pujLtrrv9uwxf1rd51Gbp8zRMa/l0hSX2ZAzpNPQke
         thGg4UvdCVHi62dV5jN9ze/044AcLLljSNq5QLl42AWFdnpZah/3B2l6YfbtP9lXbPVb
         UQAKbIElQDStUJ0HDnJj7Rlq8jdDUXcw3rxJA1MzheAWzMiMamRsEbgtXmNO3wBGDU1C
         OHhXfPSu2bjBzaI5+e3MlrCxVEAkp5xpN4J71nV8WVniom89aONnLzHL7kiLfsmUqAfP
         XBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661364; x=1747266164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+wT6DnXqbX5AENDmRydoGeLBXcyCT3Vy8ui4SCalzaQ=;
        b=UT8l2XndrMe9JpiTyr/qWn/BFN4hT0UzssSeMme+p3pcVMrNFUI3aguyF9+DfMANyj
         FQcUArubPeMPWSpG1NWpxp5heTdsVZRU6fMno17Xi/lrJi2oKD9Vmpw+eWRd2WSrNZ6f
         CT+7EQqRxGHawpJK+hq+iheV4c6Wn0NuffaSI0yoEq1etR/32XDTdsJsd8kmiJkUb/wW
         LKWbAl12znDNhLlvq6sI22g0FwtaZGtVCzbmvBIR03MI7iuzvtkDbGO25I6aqU1P/S+d
         wurf1IYSinUkpR+ZDW6FAbX0U8YjWNZHr257XkKwJhQm+NhWq+O0/kNWEaxNgZVYitS0
         C46A==
X-Forwarded-Encrypted: i=1; AJvYcCUPzvP6Ffb1mcG8qztTTe81khsdhDXI53pwwhX9aP9ZgnpPCREnglQCiP6pe389ChHSDoc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJUFJrbbB1HzXPjJp+5gE2kjTVlzZ43X1j3kp2aONAJNr2zouE
	ucAAYQ9k4/1gKlNILGA01RLrFAQZNalPu+ltyQimSxSnVAg7KVz3AS4Sm7kOU4k=
X-Gm-Gg: ASbGncvzSQecS2GhcQnLWnAXsy2DbgEaii5Hhojw7WxP9eRp84Hax0XigMtGzYHVLLR
	qXB8SZ63+4pGQTELKlWny0nA8/AUeeLPufdkFAye+ONWXU45Atffp7gAF+vdLjSQZbkYfnD1go5
	edkZt/P0Tzl1KP1w4oLR21P86V/0HBK41t1phVfXSbN9rLcBeSkf1A5VVAItHC24YCPhBsL9Saa
	MEO//xwYaJUl4QbSYTXsjz+r+qq+RTVt1YA18el9ytlGmjMx2jCv0SKm/OIeSigY3pn+8GETUNd
	vpr5lVufjNqcsUfsbxEItAVhJ1bIz13+LG3Dwh+s
X-Google-Smtp-Source: AGHT+IH9jmSZoEfyBfxc66HFb7NLtse6xLVjOyrIpvtO2+/5/1e3pQZm95IdBBwOL7DhDe1MFZOmAA==
X-Received: by 2002:a17:902:f606:b0:224:1af1:87f4 with SMTP id d9443c01a7336-22e5ea91381mr89954445ad.22.1746661364459;
        Wed, 07 May 2025 16:42:44 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:44 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 01/49] target/arm: Replace target_ulong -> vaddr for HWBreakpoint
Date: Wed,  7 May 2025 16:41:52 -0700
Message-ID: <20250507234241.957746-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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


