Return-Path: <kvm+bounces-45348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E78EAA8AAF
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB6EC1725BC
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2724E199FAB;
	Mon,  5 May 2025 01:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eG54WDgO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3271714C6
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409950; cv=none; b=cTTCFc8FrQFQwreTBEUDdH2oMHOhFbfE6i1bvJuIJY/Z5NnI1+ps+9+igsiiVQE0tASqoMxG1m01ofwf2+o46HmjRRvkkzPS7hH3E4IVwXRbKOLbTLDDB21JUgg2ObI9pxPRp2OGbFhGJ7zFHkyPrhatYXbx3RHYCpxFiyi0oXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409950; c=relaxed/simple;
	bh=EYKn7getbKo/8tVh550xVwP7v6hjfYifE0NUaw2ZmfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ja+clKuOI51OOrlvoeN2tRf0CPDU85GAU/4WRNsY0VdVyXx21hmSh7CeNyw0SzwMPeCCxRe22sWCeWJWHD1Khb4cUjCu0TDGskkHKlYXyADCdIvdjlv/MAGHYptUnHdQw7IlNuN2Hgvj1SySD304Zep2WIlL+8kiDX9dxj6B20Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eG54WDgO; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7369ce5d323so3473554b3a.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409948; x=1747014748; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1JmSJqnxYquNU/v4UOEtwOcqbxnEb6aDiKyyBWqJ6s=;
        b=eG54WDgOloM4lbYC9K2fJn/VsCSxqaWwDNenJc4YSkrPPDyAPKACZ7pseuFOZHD2by
         4ghYUf8GERfrDUUTItbB9mPhtvH+i3TldlMYGfele39l2pWWOsPp1jUhmLFUeIlQW0Th
         VH606wiHZ4NhyTfO2bMI/IXpaw/v66RUXV4uvXIMQ+0wL+xu68J69KHDSdGttloldu6G
         1IkMr5H3EKifBLyksLwvYiP7RQ4GfLBMhvRN/kax2Tae4FfPwTqbmS8xlzBqnrVodyEW
         EtyWbllcmYBnK+5qq9fuOeX+BaKPERGmMdlqNU3mvtsOnFpjH+aPbi4LJEDBSKq4WjZb
         0/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409948; x=1747014748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v1JmSJqnxYquNU/v4UOEtwOcqbxnEb6aDiKyyBWqJ6s=;
        b=k3IR7ryh50IdjD5dvw+fyGlw26jeew8xhYtfh++wTQraDqvxTTyJQhTdN12rqA8u5I
         cvXTVLAsWS1zuZGd4i+i/qREBidLj0y3JON/tkXBZhhre3tkeHGNuVVWobVHTsL+tQPi
         4zfuln322Q1Cn/hSwvzbS2N1SF7SljMir1Mq0KEBH2Q5Fr7Xu7t3tXn/77Ky4yqepDo5
         V2tzuwHILbtYLSaokyp2Cv0AgztR5ZluRiae4OPShZV2MUumc0hiW+fsg8W9+rqFO5Bo
         /V5TfKRk7kl0Ia8F6+o+sfQj6HaN+gr2A5P5q5oVxMkv4+kr8fyTmUBk85VxcDO2Halu
         Q7gA==
X-Forwarded-Encrypted: i=1; AJvYcCWiMZIylNtoa4frsA066JnBdAA7MLmQpKazlB6U8aVPB9nwZ4DMtTMdWBjG/+SwdbCYyaM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbcFDNlrljPj0UGN5Ewv4RfuATS5ftvihiYeBEPkzQDTSn9VuB
	LzkW1WxRzzuw2k6tl4sPZSncFOmv7y8S5lUbleDjLf+mpFHyxdTk5t3AlQXCz5g=
X-Gm-Gg: ASbGnctzupbQ+oM2PGvUqo8y59DMf5Q9yAGxAZJpWgFj90YA55T2t8R2B22xalRWnEx
	pdqJpOjWMN+vTDiAU9iNhgArtxj3OLqUDfCq3L3D8nOVVxNrAeXg+rUI4PmnH+v+5kuXHzjiMjj
	MjbK9ETuIrkKsQ0e0x4B4xCW+FCalhhZL5YiMWSKjkGjSiB0t7za3LvSxGDNTmnjHAmRBfC8xbP
	lZNVcXx3rGfC8zlnqc4Pn1AIZ4a1MkBSNzc6lwDdN0y2qdLHk8pGtfP3gtMZf4yaSOv0Y1gmIgE
	t+AU3kT6rJy059U1nH1XUS0+SwXu/BN7IBX3HgjD
X-Google-Smtp-Source: AGHT+IEDP5xBT51rFDO+YlfBvJJOZbgRutYKb7K1dO6mttF7lFJCwcmKCu2Cndsi3ubcw0yBzewrTg==
X-Received: by 2002:a05:6a21:8dca:b0:1fb:e271:82e2 with SMTP id adf61e73a8af0-20e96605502mr7410585637.11.1746409947932;
        Sun, 04 May 2025 18:52:27 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:27 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 01/48] target/arm: Replace target_ulong -> uint64_t for HWBreakpoint
Date: Sun,  4 May 2025 18:51:36 -0700
Message-ID: <20250505015223.3895275-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philippe Mathieu-Daudé <philmd@linaro.org>

CPUARMState::pc is of type uint64_t.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/internals.h   | 6 +++---
 target/arm/hyp_gdbstub.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/target/arm/internals.h b/target/arm/internals.h
index 4d3d84ffebd..c30689c9fcd 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -1949,9 +1949,9 @@ extern GArray *hw_breakpoints, *hw_watchpoints;
 #define get_hw_bp(i)    (&g_array_index(hw_breakpoints, HWBreakpoint, i))
 #define get_hw_wp(i)    (&g_array_index(hw_watchpoints, HWWatchpoint, i))
 
-bool find_hw_breakpoint(CPUState *cpu, target_ulong pc);
-int insert_hw_breakpoint(target_ulong pc);
-int delete_hw_breakpoint(target_ulong pc);
+bool find_hw_breakpoint(CPUState *cpu, uint64_t pc);
+int insert_hw_breakpoint(uint64_t pc);
+int delete_hw_breakpoint(uint64_t pc);
 
 bool check_watchpoint_in_range(int i, vaddr addr);
 CPUWatchpoint *find_hw_watchpoint(CPUState *cpu, vaddr addr);
diff --git a/target/arm/hyp_gdbstub.c b/target/arm/hyp_gdbstub.c
index 0512d67f8cf..4d8fd933868 100644
--- a/target/arm/hyp_gdbstub.c
+++ b/target/arm/hyp_gdbstub.c
@@ -54,7 +54,7 @@ GArray *hw_breakpoints, *hw_watchpoints;
  * here so future PC comparisons will work properly.
  */
 
-int insert_hw_breakpoint(target_ulong addr)
+int insert_hw_breakpoint(uint64_t addr)
 {
     HWBreakpoint brk = {
         .bcr = 0x1,                             /* BCR E=1, enable */
@@ -80,7 +80,7 @@ int insert_hw_breakpoint(target_ulong addr)
  * Delete a breakpoint and shuffle any above down
  */
 
-int delete_hw_breakpoint(target_ulong pc)
+int delete_hw_breakpoint(uint64_t pc)
 {
     int i;
     for (i = 0; i < hw_breakpoints->len; i++) {
@@ -226,7 +226,7 @@ int delete_hw_watchpoint(vaddr addr, vaddr len, int type)
     return -ENOENT;
 }
 
-bool find_hw_breakpoint(CPUState *cpu, target_ulong pc)
+bool find_hw_breakpoint(CPUState *cpu, uint64_t pc)
 {
     int i;
 
-- 
2.47.2


