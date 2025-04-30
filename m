Return-Path: <kvm+bounces-44922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAD22AA4F45
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E79FE172B74
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 14:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE27516DC28;
	Wed, 30 Apr 2025 14:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yxGEpC1f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F90D1A841A
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025134; cv=none; b=YJ7FbvLOC1i8WpZD62YeEaUKxKrI1Ez/j4Z/G0V/zwjZ+/2M3mw14ETZxqn5N3K4STxVM5heoAPG0+jKLNZztSVHEf52JbW2acvDEpEiH76Uiq28Bzne09DTLvzqm4J9hxT2OWmdYSL8TD5toGyVI9FY6wV1FWHwPP8fkRxrWLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025134; c=relaxed/simple;
	bh=EYKn7getbKo/8tVh550xVwP7v6hjfYifE0NUaw2ZmfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hCuI6MCTC8bmWW9PQjT01xkA6xCGiEi12eyJroHAcOA7/ZIl3TJfjZ/JQQ5+ZI8bXVXsSX9xEPDlio4X/Vjmn1K2Yv+wzARRsydjRqWldE0TzPzdsrUWJjKyHvBldInGtS5WXfq7on9sLWwijgNfF7DFvTkgAEYQHgXRmOFtg/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yxGEpC1f; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3012a0c8496so5948347a91.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746025131; x=1746629931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1JmSJqnxYquNU/v4UOEtwOcqbxnEb6aDiKyyBWqJ6s=;
        b=yxGEpC1fgFlUnvrIK282cx+zhLNf/SfulTq7RSOzsdQgrEhHnfcc/MEsaIYULKKeFw
         0dCIpunaqe5/plcxLUqhCdvdH8Zm9YrqCN++QUWpPcqEsPAeXiDnPBj5vnQlkD6BAblY
         g09kaaZZIWDdc1GljCeLFGcSQoFtqVWte+pOOPJCVrfr9W0TNQFtCBtFHwPdLimElwI/
         /EGviiSzg7buvfY1V0zHRGG51mNpkNJv+dPmwXC1KF+Qj1sbj/ja3j2lblD7cB0dtxQ3
         EnzVRi9TH9XurU8oXOvY5Vw/7rK9H6m6jnI2/9F7mEFPMNgu/RlEXhsDVQB4V4AWjUrV
         LJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746025131; x=1746629931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v1JmSJqnxYquNU/v4UOEtwOcqbxnEb6aDiKyyBWqJ6s=;
        b=dmKlvAAe7Yxlxksdx/nmOIH6i91GYRF5vG6w2LoVx8ki9vHwONvEFd8qh8SN1lmuqy
         cM4jQJhBOItLXS+gTkZ98SpqXySswDTOVQhIfhY4OmsxQj5lyQUD0HZWDz/pIttQ395d
         IyK81kz4zVbwRMVRS+SqFvgcpRXkY3mU8n8lR7qu1dmS2vlrYQLFh7ZZta5o2IFXqWLU
         kfxc08fsfJAdFJmxHFzqj0D6EAqOIsxVI4UzBvuqCjLZSrNf/6juB/vcoW3BH9NUmojj
         tL/4yIrESLVXGzKOq8c8I8/cWIiXki9gy91R/5W+YpHaylbhwzzpEQPlxJ71lfC0MsvB
         OO6w==
X-Forwarded-Encrypted: i=1; AJvYcCWhu3+JUvywmVO+K50069bxLDZPf3KWh2kefZ9NvKaIZJ+LPwu3qFPQ/gCJ9kM+JEhgB9E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwssSl1cnMRlpbHeLEzq6Hd4CLN86mgQkIL+2CZ9IJasmk1mX13
	D9kj42WqH2Amcyx0deRFo+XY/pW4pTDS6rfRpMvBW5h6Iq8W7GJffIpRFhAZ7gk=
X-Gm-Gg: ASbGnctzM25prQe6WyvqEE0z05DgVhDVzE/9FlIgLY5dHJa4593t+B8jBPeqqBqiGr3
	tkkg0rSLtIyrXG/YFmmsiS9dzuNKkvEjap/CIbcxUSaVr/dAGLVWhwtYYTbHEkHFipnQA49UUdc
	8LJMYrnphOkZi6TuuraQz/sd5oK3kC/Sn/n1DWbvXv8/SfNyI73uiMPgV6ri1Fh/GGu4/s5/KNH
	xGbhC14GmW6In6JWyUrk7tV/FCHvOqlj2e2y4B0pu196udVbTgzH5FEu9pEhoWu0B+I3cPZIeAQ
	PBa8T0VP5GbiDQTB3rZojCUXIL0xjNsSLhQxca15
X-Google-Smtp-Source: AGHT+IFi3zhIVBlI4fvnZXF3ndodFDug/+ZjzkjEgZ4p9GMyQhZU6U0C5qlme+C9qszLASfwf7Vv4g==
X-Received: by 2002:a17:90b:3504:b0:301:cba1:7ada with SMTP id 98e67ed59e1d1-30a343ce72cmr3932692a91.1.1746025131606;
        Wed, 30 Apr 2025 07:58:51 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5bd78sm1705652a91.42.2025.04.30.07.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:58:51 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	richard.henderson@linaro.org,
	anjo@rev.ng,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 01/12] target/arm: Replace target_ulong -> uint64_t for HWBreakpoint
Date: Wed, 30 Apr 2025 07:58:26 -0700
Message-ID: <20250430145838.1790471-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
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


