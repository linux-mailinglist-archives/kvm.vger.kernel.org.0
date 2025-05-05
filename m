Return-Path: <kvm+bounces-45497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59015AAAFF0
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:29:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F7307BCC62
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345CA3E987F;
	Mon,  5 May 2025 23:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sz13RwnL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0643B11CD
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487234; cv=none; b=grtCnv4FOcH+C+VCDZdDn4Y543g9VKGzcaECsOBppFfJ/v1n1qACA0dZUqmkZjtTCA6J4nbt6DwNLmd2PPnn6xCJYezuoJoRm09coi7fseRDqdZrcqmvbg9xs4c5sMbGi8ZN323JbeLT4ZqxsO9Ql+Ilh/L5z+rSiZ6SlYicHpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487234; c=relaxed/simple;
	bh=30HYw1I8aFdjg6SHuQTxQCRNvR/7AoVCDPUJgGhi7zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XE3IJldi+I8mMA4dUlFJqzWEZVzBGkwto4qQvsM31IXGEvXp8JXVeD5IaoQVM/CbbOYCGNlPpSsU3qIdSVYpGvIioUlMpvBpdtOJufFjAc7EovOw1Gpiy4W6vKuRUvxDSzIwyGimFYrwSWxjd1Zr46JRdCmPupPkHv7P/qxkl8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sz13RwnL; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-227d6b530d8so46804795ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487231; x=1747092031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mduWzGcqrbCCMCYuVdtTD2ZBid0+LWN3eUl0cLQ5HO8=;
        b=sz13RwnLTky5UnMBPDehp9QUB+/DGSEgauIP/t9RYnWQ+RF+h9K9L68npL399TqmL1
         1Xg0bXlaTrwjZZ1WNpaNsaTyM46g8EQoziMc3YjwupAqE6XAQ5wO1aXh3T/fFm5UhsQs
         FLKZUdfpVt0JwiG7tGOEqgZ/QysWlXOxahEHBNMBCcN5hN6MHi8iVabnw4F/S12O/i+w
         iBa+BEDOlUukgf8ENVMc6frrm7GIE8t6RHsmReM9Dc7oR+t1T3fDxTlVxRAJV6PQXTpy
         BE400URGA/9aw2LYIXUeQNQTYBlTFvA4gI6Bk7c2bcOBMiKZnRi6n+3+KNPIwlWDLRnN
         Q4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487231; x=1747092031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mduWzGcqrbCCMCYuVdtTD2ZBid0+LWN3eUl0cLQ5HO8=;
        b=DqV6O4K74b6YeKAwjhWZ0wgzNetvyvxU+NMeo6pQK84HJNmYeEVn/GDJC7NpjTagm5
         ZoCuws9favcVpvZim/A/eWkdnDIyHwTY6GeKMMGgLfCWyuTuPD0YY1rD0frVknTx4nAJ
         tMAQ0jI5VJaCnEgnNvRb4/lBkA0HI/Gl6v3VYCgu3I4gz8IhF6Q0Zh8c7bAmsFBQmj8O
         d7So1MtCD9OwNR1KMHY8gPwvjwId+jy0SBY9Y8BERE1v7P+JZsjxo+Cwog3hbGAeIZED
         SFxY6sWk6oyVxt1d5c/NkhUC7ytCg+cDdB2khJNMZ5sxvNmX7LMzDEQjPNVVbMGE8OLL
         XIlA==
X-Forwarded-Encrypted: i=1; AJvYcCWo8YQ3vyHDz5D05Hs/HP5r3Nj/QBSiMyGutgJVEO2y5oP7oF8LNaKQ6qHpHgZFM+C2Ugw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGmE8tW5Fr//CF2GYwfZ8B2tjKXhtt4M+pYxR606ze63idfPM8
	OS1nAqv31PLFY5X7DTROPZzk4HlHqNLcscvKRBDghZVPEdSQKElf5JRMjWhpF2w=
X-Gm-Gg: ASbGncs6EuTp1oIp+mnJJYm3NnuJtVpAxy+Z/Bf5Uaa96Vs0ORyR6W6XrQj9MCD+W0q
	ab17/6Y8ejVSJ8euLCJIaKAV+EY3TyEcEh1WOs8ZDLOG9E1enUJ5A+SGdTDqS5/+QHg2XRMJGMp
	/g9Pgg8N1poGkMtFTn4CTzT2dKFVdC8wSVkoOnP7UZxu0AOtBdre7CXP+5SzW+XbZoTw7m/l2mF
	10HREMES7A9rbRniPXoNTBI7RtYZCiNti0O86Hdok0gw1BvG/ma1NQD23MqvlhGk7WfgB+It1gP
	uz7qquYS0umpmWMhAgs0HGDPQnSpBL5tgBv+EiZn
X-Google-Smtp-Source: AGHT+IGJHQGPT70iQq1g5juc5YpCbtYrYWmQM67WZQCS90h22TJtC/LDouxcVdEq8FF9T4pmAb8ojg==
X-Received: by 2002:a17:902:cece:b0:223:4537:65b1 with SMTP id d9443c01a7336-22e103571bcmr236825665ad.36.1746487231323;
        Mon, 05 May 2025 16:20:31 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:30 -0700 (PDT)
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
Subject: [PATCH v6 12/50] target/arm/cpu: compile file twice (user, system) only
Date: Mon,  5 May 2025 16:19:37 -0700
Message-ID: <20250505232015.130990-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index c39ddc4427b..89e305eb56a 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -1,6 +1,6 @@
 arm_ss = ss.source_set()
+arm_common_ss = ss.source_set()
 arm_ss.add(files(
-  'cpu.c',
   'debug_helper.c',
   'gdbstub.c',
   'helper.c',
@@ -20,6 +20,7 @@ arm_ss.add(when: 'TARGET_AARCH64',
 )
 
 arm_system_ss = ss.source_set()
+arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
@@ -30,6 +31,9 @@ arm_system_ss.add(files(
 ))
 
 arm_user_ss = ss.source_set()
+arm_user_ss.add(files('cpu.c'))
+
+arm_common_system_ss.add(files('cpu.c'), capstone)
 
 subdir('hvf')
 
@@ -42,3 +46,5 @@ endif
 target_arch += {'arm': arm_ss}
 target_system_arch += {'arm': arm_system_ss}
 target_user_arch += {'arm': arm_user_ss}
+target_common_arch += {'arm': arm_common_ss}
+target_common_system_arch += {'arm': arm_common_system_ss}
-- 
2.47.2


