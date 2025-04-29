Return-Path: <kvm+bounces-44666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8AA2AA017F
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:00:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97ABC1B61633
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C402741C1;
	Tue, 29 Apr 2025 05:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e004Tce4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D98925D1FE
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902819; cv=none; b=r55MR4Ap6eF8iSJTfA6rAe0sZaMiPQjELAeuFdZwzsK38M53l4zGaFFs0b3KXw4wHVR7LHIRhK1fdHNwKqPBI1tk8ZFwVLXVmGzLihjudJs9m9X/b8Z/rRMoYZ657bEod1Od0jOtOKsRAktHS/SE9UP3IACBlw/lr/Jve4f0YMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902819; c=relaxed/simple;
	bh=BXpBrBkVo3qviu1Ww5JOzmSa3ei4X2fz5dUFJdJLxzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hb7Yevh8C6H1tFwBOzFMFT2gmnL87rtNeBTQFhMbS2wBVlJ83D5UR/3JPCepdey7K43bTVVSJklNXChqdwkSeb1LhrBNLykGZSgOdV3G32FrdvpzC6srZcllNDdvMb3LVpDrWOq9QPVDobIgsiiyeMbWmMUhcgN7VZvBWXitlvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e004Tce4; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-227b828de00so55706285ad.1
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902817; x=1746507617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qd9JoYIvLQe/drBoM2Bi9/5cgLzZGHsmbjtG6PaToKY=;
        b=e004Tce4h6Sz9d0L0XG2NrJgCUM1RdB2s/kyhbizAYvJScwxGy9pSnW2V1qZdjZbeL
         6yR9y8qc+/rWEdAW0H46bs4OrSFfLJhJnmurngH0y93+QljiPBACcttDH9ccA2y7f7I1
         JVrjN9Njf6HddlcvTHm6fE3I2llOo0kQifEdorbfdgEECzZBp0Z0p1ZUhhDGNcWshDv8
         FoXQP5CigF23d+/eiackXS502FbN9Hhe0sWLNmcb2A9LiYEohFFzPkl7wl6iIDXIzb3z
         IWO3uyj7l0tEBfnqMypn+xcnVlaPQKf2h5Mn50DBeU8LkX2jLPTYadYmuYTVrjddMtBx
         XmTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902817; x=1746507617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qd9JoYIvLQe/drBoM2Bi9/5cgLzZGHsmbjtG6PaToKY=;
        b=LmTU/EmGOINble8AOM9qxbIMoV7thrL6WE+jABhpisf81fbDH/YIBhVTkemOzcUVD8
         pSzAxVMniCFucQ/AZlMq8lM2QhRsA57M5nxqCJkyr2XYxhaLdux7vj9bDrduLpEiCB3g
         qX/TzyR9m1Xp1rMnQqU0MDuEMYaN2+mpHnDjjr2gHYv4RP7+cVwmfTTsI3+tZhuQ2qgn
         myMb96p00N89I9T3RlxwiZTForgH8XxiBxJrWBNpAVCRJztoNeTS4RU2iYRCnFEO2UMR
         5a7uVUCA3zamuSM/U1rj+2I8GHUgjKWnwUf8dpHp64r6PBTamVvvxmGOrsWuZr69/VN+
         2WMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwgMVqy/dL00YY9qTKHs8yzvymIUEcMqzoQGPFCKNpN2FqkhMSOcwh0X3S2Wp1VTjbemY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaEexv1vEP/eGpApCrx88EMwhvXJJcnZfxKrVbOw5Sk4YMrP/Z
	I0tYxzPoBicYslC6v26ob9NNqPeR6c5+Xb7eWVoozKOra9wXlkcHaoAO6gGINNA=
X-Gm-Gg: ASbGncuVapzHtflwn+MUnN+SPSKdZF4CR6KiMrtxRGZj+cRoLNaZ72FggjmaB7kfqlA
	rxSZozBAHjXRe2QqKMzUnxbA0gIy8q4emOcQ+ak6e1dYAUN3CzEQOKFyqOuY6Wf0GYh7GkVTlGn
	EHGMeWbqwxkWIoH//y69kHW0g76qDKvrtxQvC9fuUBM3ub0yg+I7RwDV22zt8MrGED1kQHmA2Aq
	PC3xCVsqDiCTBfcJCfKhDPpQY7K/cKyDQx6qC41VJEG7mHmn/eJzMCzgU5oEyxQJ5AeS9SY4joh
	McongCSBtNYyE6femZTKFtMNMTpie91axYpSpSGo
X-Google-Smtp-Source: AGHT+IEym+4DaHg2WVCA9P5QZCnFC4FKkvs0up3xAn46PptfaIMRSezZKhGFkfqVu0U7+N2+PKpNSQ==
X-Received: by 2002:a17:903:28d:b0:223:f408:c3cf with SMTP id d9443c01a7336-22de70276d4mr26404235ad.21.1745902817405;
        Mon, 28 Apr 2025 22:00:17 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:16 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	richard.henderson@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 01/13] target/arm: Replace target_ulong -> uint64_t for HWBreakpoint
Date: Mon, 28 Apr 2025 21:59:58 -0700
Message-ID: <20250429050010.971128-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
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


