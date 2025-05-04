Return-Path: <kvm+bounces-45294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E19A8AA83EA
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:29:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 262B43B393B
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B923170A26;
	Sun,  4 May 2025 05:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fgM9CihW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5253B1AB
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336563; cv=none; b=GqA9I2FeshvQPhDZkRnwoX4JYotiV+nJiabpPWqmnWsSQmtoqcvJ+ZzFsDWqI0u5q9uPBNKFYICaK8AlRYfCiYzZqJVl5MWl7cPSp5Zuya+nlKO1BO1+pvAqjF2iFSoZKURIlmnvT3KLv4OhPZIs+xPp+hrq1ztZilVOe78ncl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336563; c=relaxed/simple;
	bh=EYKn7getbKo/8tVh550xVwP7v6hjfYifE0NUaw2ZmfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SpbXrWrSIh0It8GUl738Csw51ay6htLbXaEkZz1QWCLHJfPP/CBd747MhoQOYnqZbzzl8XgMvnnvAH6YgzsTd52F8bEZ0aPv6geS3v03mP/U8TV5i+Rys2Ieaodfa1lfjhPpDis2INiDMxMXsWmNVtSafdJ8XJ1wrnPebbagYpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fgM9CihW; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2279915e06eso36887715ad.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336561; x=1746941361; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1JmSJqnxYquNU/v4UOEtwOcqbxnEb6aDiKyyBWqJ6s=;
        b=fgM9CihW5goImGSE3NTRewaChxt4F7+08fiH5+iu9iJKgq9bkZqhfmNNR0ihpKdNYN
         26qfYiPt4Fl2nfgxR5NEqmZ//+YwBIEQKz/A1CLFHKR+CBj3YWa7UNm/xi+d3Gq4W2Of
         6MS9G60UN8VqccXa6XQl/X6loPMXXClun6m+ZhArXJDViQPgGOdbv6DTJEHXkooeivuP
         m0YLwKVyxpHXWvS6hwiGI5V2swySs49RBHopohqgtmBYmE6yl8iYdXDl4d79uXVNhhTP
         eQLd5IA5re1MblcfYZ7wLYzE0I4t+oXBDqF7LPk+lTsPXabMbhErxFv4TIzb/cvztm84
         KBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336561; x=1746941361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v1JmSJqnxYquNU/v4UOEtwOcqbxnEb6aDiKyyBWqJ6s=;
        b=cI6CD3yNF69JQpmD5pTngQVnr1bfb/t6MH50Uka2Boq1N1kiG7RUHhVGYYQneKPMwx
         KfCuK6t+0bh7RjcKFmjPkDFcArvOXaAtqIVgErKjF2PBMNJYT5CdFqDgoEKMV78qy6Sl
         Qaf9I9SBK87k968XIOYd13N8W+DPuPqcLpUBASis0kCTdaPu94bjpME7sl299Hk7BgEj
         eeo2xBUjkTgWlXQ8PaKVGtT6l2yQ+NFVVbavNeWejn66TDJkG6fKbuZAZIVEIENTphOw
         PTySgQLOJbPgrVPVWy6ZIiEmm02l4GS3BWrVdZJ6Jba6dsQdxnhr+Iotct5/qs6DYZ3+
         fIWA==
X-Forwarded-Encrypted: i=1; AJvYcCV3+da7YKgyWobQvShaO/Kx2F+sXHCtSgoYQqxw3mxGImiQKsRzF+6RdicXD6Eo0nfdZiU=@vger.kernel.org
X-Gm-Message-State: AOJu0YySmXya8kphtF0Eus3iC7M7IR+xD2YOgTvQBp0gAi2Sm3VkQNJg
	ZCQa2Ef/L0WLE8+dMPI2EBy3IPNiWi4iNpR4+5vi8vgZqZSDQ8RM3PBAQJNtX6Y=
X-Gm-Gg: ASbGnctlmFk8zFvsk+jHtungLeHE+BH7a2c1lvr4FnHERvsLV3uIAkmiC6ACESIZa1f
	IVLcznaN9danWAu1rCbHFdrgyiQ/UwbFWlkUyLv9I5t/xWQo0g/EdYfxR+pEAxBTt8XcrvgDcCL
	Wo0KYVwRQp7ubt+muZk/0Y7zLhuMAf/IVaynaqlz562R8x+ZqMuYEsLSDaZ28c3BS2H6vzUUMt1
	4eqldfL1K6BzTKUwVh/fPcvbShrxl7dO3TJV7a1jF8zEneQ0Iv/NPP7w3dW7q5KUydNoZn2ZJJa
	QcCvSHfX9MadcbDq4KkW4heFAAm6YD3SF/k5Qji3
X-Google-Smtp-Source: AGHT+IHXnjnzTW6tdaUx2wqRb/N+J0DcR77Y5QyXk4o/4S99YU+4N55bxZt8UGnvoRa5cSJGoQ9fYw==
X-Received: by 2002:a17:903:1246:b0:224:e33:889b with SMTP id d9443c01a7336-22e1ea3ced2mr48331655ad.12.1746336561460;
        Sat, 03 May 2025 22:29:21 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:21 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 01/40] target/arm: Replace target_ulong -> uint64_t for HWBreakpoint
Date: Sat,  3 May 2025 22:28:35 -0700
Message-ID: <20250504052914.3525365-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
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


