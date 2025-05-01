Return-Path: <kvm+bounces-45031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F8AEAA5AC7
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08D209A392D
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8962D26C388;
	Thu,  1 May 2025 06:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dzWvuiZZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F4525EFBC
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080635; cv=none; b=lYrWQMVehgBjxAD57HWb6rKVG0+Ut82Bc9hx9ewGa1QxeEdjduyFAg8Nxk25nMchTxtYvmVx9AZABgn4wF3EGhU6SsQmTEDlkF0140KckO6asBpXLlkpuiLGsf5li4z/Qy+8MK7T+wbKRKKW/6Vib3sQ052/04TDKMNXEPpf7nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080635; c=relaxed/simple;
	bh=EYKn7getbKo/8tVh550xVwP7v6hjfYifE0NUaw2ZmfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qG5BM1y6IgUHkVduF+XzUAmCPZFTSMONYElWf4n8rzv0Md8FBNcXESJdY1k+GGy+ygJ6WIzNV8VknDA9FxtIFMxtruAtzRHVKwBq65f+Kr40idSjG1hl/N2YRfaCvD8Kzg2XGPNRDZmrgjSZXBvD8I2Szt13tDQscwV0RpXdfy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dzWvuiZZ; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b041afe0ee1so600813a12.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080632; x=1746685432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1JmSJqnxYquNU/v4UOEtwOcqbxnEb6aDiKyyBWqJ6s=;
        b=dzWvuiZZGNieuCWrewnPSeTzmCIId/uTIDjaum4W2i91dEGT9nKDHuI+SwJxIZgcDo
         qFavsWcr/iUmJ0HtwxyueYemsmmPY61ernWGdmt1sw+F1nHDXytGXzc6ebbUcxHxf/jn
         bMVFcAC9spqZ0gZjm+LDWhrQoPYFGRFdKYnmPIw9i8rAXfNHc0KZVg1Frd7WWOZSwlkA
         L7wKV/4T9Jh0wm15bPmH6k+fns6LK25/nuMLyPhx6Iiu2Q0f8dybqbnEA7iyjCyKWIMZ
         lww6enMU3QqFUj3fmouO9GXoOvpGrxWsY1pECYNe/v//7tsAV2RWgtsrMR56a2GkIcNL
         njhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080632; x=1746685432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v1JmSJqnxYquNU/v4UOEtwOcqbxnEb6aDiKyyBWqJ6s=;
        b=IKzfjolIK+4OpQHWjLNMHME90YKU7rkJnjJ1659/ssTy9UBsVQ+ym/w1tUxkbVtHhH
         pnFp4KUUQoU6WUYkLLyVCJGidFMHcMpjQjem1KBP/3we9kj8XjGIBc21oNIHE9kDf302
         F5Be4O2jgSPEIE5kyooWOT7k73PaXkXFiOIyfv4BUbj+Xl2d9L3BAls+fOm4nWEHisvr
         EunlmBuVteCH0hBjnCvy2Lz3ae0V+dq6NSVFFu5joluXT2dS+DGVOV5hlxBWPyt+USKA
         xYZOezfZ5D1EHOig95XKnwHJKul8yD96aLH7tNGf8MQfa0xJeVB5/A5FZd5MX7I7tPz7
         peyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSwiZj9weFUFrwewfShJ9o/agXg3xK6/s/CKAePyChlrCOpM6MUvaAWItcyRzjKPK8CnE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/b/ecSVo+E3PwHST0TwKEREqnkrh1jw46IP4C5pPeihyA1/u9
	c5u71VHS1930pf3ET7xygD+ghDdWZWdsUo2+TDLXhWnhMBULLPTev3dKCufNJgQ=
X-Gm-Gg: ASbGnctEkXor+19cpyN5wObPWnHgaJnJ11idBavCc8QXlhQFGMvrZvCgjVjpce6GSXZ
	aTrPqN1PCTfnoTsIuGxwQD6XWq2yQDuQDWVqf7mUuzIjnq4kQDHloXLeTmAX5tf9l9eoglXyL1D
	xFGSDKS0lvujcBPycF4Wf6t3ofZlvw2RPb9OL6HxCWrhByDrwO5LOhc8jeIo9PiX/ehjhbXD5Eb
	kz54WIW8hhKlIJOXz2fn62IBf40h5FzZNTbn+YtN7iQRqovEl7+DnvNbLjF96ICNHJ/j4ZD3lK1
	NnnQKXw9vjDKt/k724DAaAuY2TjTSsh7iT0iLn4dqRRwuFLsc/w=
X-Google-Smtp-Source: AGHT+IFOfDiSKDNI2z7vj3bMYhWzkjC1FmgVSWCJcnFqyW6oYKX9smD6/m/Yr79c3SgHzyGvhdUaQw==
X-Received: by 2002:a05:6a20:7d9b:b0:1f5:79c4:5da6 with SMTP id adf61e73a8af0-20ba6a181acmr2684589637.5.1746080632405;
        Wed, 30 Apr 2025 23:23:52 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:23:52 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 01/33] target/arm: Replace target_ulong -> uint64_t for HWBreakpoint
Date: Wed, 30 Apr 2025 23:23:12 -0700
Message-ID: <20250501062344.2526061-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
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


