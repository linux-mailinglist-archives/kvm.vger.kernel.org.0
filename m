Return-Path: <kvm+bounces-45506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96FAFAAB000
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:30:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C9901885D5F
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9A083066F7;
	Mon,  5 May 2025 23:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sHajZbL1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2727A3B28AF
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487248; cv=none; b=p/ueP6VqbfL5KR/V0iM0J04e7krPNWXlXTygxToqXqmErb1mXV+bAHKnCNja4Quo86YmQsc2f9mpKW82v/gx7sEt4VM0SJsc4K3w8EnUDa9TbQjXYfZGONGLlw3Iz4asksXfll94gL7UCMiuGcbCzjfiLZgAILK9/uKrUpdL7pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487248; c=relaxed/simple;
	bh=4VSma7tBGQnF8/QKFfrPJksO4he5ezXQE7tRteaFFz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7nsGwWjW5G1h17/tuUoS1ldW8iyhWmvPjyVNfX79GofbadwF7JC9Qsrb48e8xjqaXzgWIU5Rp9cHguw7RtqhZIEVt1aqT2Xj50H+ISyoHUrtbGB5xL0qoO9QprPpnvA5sOhOAzkWq7EUlBh/gejvBbZYyggnL3eER4VAqSWJY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sHajZbL1; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b074d908e56so3568435a12.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487245; x=1747092045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3Dpv/gYklKxQ6NcaNjklM8os0pkN4N34WBJsdRDY08=;
        b=sHajZbL1QHJDOx5ZJ/YhPvB2/jyERGZY9MU5dgzGST6UaHHXKP1Pi8lXGmM0m/d57Q
         EUr3clEcEzCyGTqtirmm7aOPikiWqESrFTURgDDQy54qPWmcyg95OymsFa9TCPcnbpfy
         XokcrvyZXWC3omqlt+zM68BfUypHF6Ac77Ch5eOXtBk2rzMm70tW2dFQgFV9VlwGWmSB
         PnNImUiCQPz8j56rQeG6qSQzL2VoPH9Z6C78PlwQw4hbyS4vhom0Vl2I7pE6bn76zMC3
         5IrmXt0nCLK2W1IDCOJjUdNyOUqUfcwo+j8iyH/X76sbUtMhQj/OavUudPOohKy7NcoR
         JtnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487245; x=1747092045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j3Dpv/gYklKxQ6NcaNjklM8os0pkN4N34WBJsdRDY08=;
        b=TrYWO30W6t53Qdgrqwbzg+NbguEWfbbpy0rBYpaeVYywgcBcEl30KTkIBRFgVxzBap
         o7ZsEHZZoTFa1tbze/Wr/XoxQ0P6Ut0NvILbswYzSP/Gi/X6NTG61xWQJRk7egIq1Twu
         3T71rMzHDBgAv47L8AKCMzLgOmMjjTYYIG6HhOTSwpB9hktqHP69uTor8OLpkWp0zizV
         dp+pgr91QpKGevvqsvh0wtJl24IGay2bi+jzgVn//0LQWVBe4EnAIxfld+nYDotHl8P0
         Zj1NlQ/tz9Q1fpeXPjMjfHc0ZA6yOjz1Bl5Ti7h7Vebo/O3JZdET7x1DCqFwyyCTMJNj
         KTrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHPGZsjC9AgDNfmhuSSecjo/ACNs3ZLWU0iZYdr870x6hUU9/U0o21dUcIlyqZ35xryb0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSSI5Fzmzr53osJMvUJ1/wcMm/8Xg4VvHpRUNC2FrBuc832gzH
	z1vI7W6rsbbotR+yN4sS/ITYOHHMxbitnZlBIRhZPLoh2/obFa3BqLFY56yU3ro=
X-Gm-Gg: ASbGncvR7w0oyKIQ7ZfVi1m7+1CpxNJh8+zOt++7wAvRcnSUBFh8vZJDJGMYbs1TcxW
	WfeSQI3H+8AacPy3yGqAoZf5g6KLeJ6gf8ZjDeIj0/o1drOPPjXPGnEWDjxmq9MT5npAydrTIQo
	dESkvBcv+1pB24MFh6N2sY5VzQfgdRgvbdq/XkJxk1rTKaHHV9bEgGz3YxTWmrcthd16SBvlhVI
	I4irwPqzIfJRD/9ruYSKHTs0A0WmuRbYhp90+WGa4Ig3eqwzXjZifXyY1SYwlTa21d8eTtT5d31
	U4sFX0z/xMWiq+yYBY0t8QdVc82Ljsb1XyQzhFgmn6Q+3QH7y+Q=
X-Google-Smtp-Source: AGHT+IFWk5AXwcjBNUYuo0qo4bKVRD9ScvDTBj0++wYSaqbR7Xj3yAofodCIxA1kzM4MSYlJ50aRUA==
X-Received: by 2002:a17:902:db0e:b0:224:1c95:451e with SMTP id d9443c01a7336-22e32eff604mr17816945ad.33.1746487245422;
        Mon, 05 May 2025 16:20:45 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:45 -0700 (PDT)
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
Subject: [PATCH v6 28/50] target/arm/arch_dump: compile file once (system)
Date: Mon,  5 May 2025 16:19:53 -0700
Message-ID: <20250505232015.130990-29-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 06d479570e2..95a2b077dd6 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,6 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
-  'arch_dump.c',
   'arm-powerctl.c',
   'arm-qmp-cmds.c',
   'cortex-regs.c',
@@ -38,6 +37,7 @@ arm_common_system_ss.add(files('cpu.c'), capstone)
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(files(
+  'arch_dump.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2


