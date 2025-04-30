Return-Path: <kvm+bounces-44933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 127D9AA4F54
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 17:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8ECC1BC6711
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 15:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2983A261388;
	Wed, 30 Apr 2025 14:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cY60+7kT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68BD261362
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025143; cv=none; b=GcPphVW3cS1gforhTarQX6Mu37402jDYkL/wrkqdK5g1tF3KMD/Fnd8d7fLPBx6Cmzz36GeefcfIeEE52ceyfAQG0A1TSN/7D/fVtYhPAu7ot7Qhcb9Ho5hFlASo3HfqUi9SjiGmX+WI2bAUkRgBg2vfv2WRDf+2GsFFAEP1zk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025143; c=relaxed/simple;
	bh=TCEawUFMpZai3gFdT9yaGvolwoPVss9ZaYCTI+QByqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hv0uHhnXVbDszv93JwLCqmedNvwSkosTpLUyQXrrhnDrkgHzEh9AoHwpeYrYFmJBa0p2BqjvKCf7iEQAqdICR1wk83SWwMwcde8v44LY9zEMdupnrVuHevSaZG0YH29MY7NxIfE02fqr+A58dQI20ZDtaVZH/AvqqkP8gM7iY0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cY60+7kT; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-af5139ad9a2so5040092a12.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746025141; x=1746629941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihSbjG4MVG/rPWJxnirZVcYWQR5uI9SkbcEMwpHCSZo=;
        b=cY60+7kTtpn+ZSqn0h0GMslG72Nph+WiJjH9Gc6EkHsjU+sqnE3ge4Yy10GtR4Bl/W
         VOUwp5n6vHKiWRNtB1fJTDcswBPggRudG9Q3oJAE3C+4PtCG42a3JRYszhGigR5xOXLv
         4H0S4mgu5KxGwTJgq3g2x14oDF7wBsrQLZH61lLouIetRmicRpA3jfRudEtfQqVBlGDd
         hQRR5Iit6Y9ocfe2/nfnb12XswlGwMLymgO487hlNNcLKrs/CCjKGRvs8M+IztovnI0M
         HOwbmX08JsSBGZT4EjOvtW+EhXWE7xo99BvWnS1wpUJ0fqFoE6dL+V5CcultgQx3p07R
         HwJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746025141; x=1746629941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ihSbjG4MVG/rPWJxnirZVcYWQR5uI9SkbcEMwpHCSZo=;
        b=fNjzuMFonftna6hLikzkouwDk4saR2q/lUyxmYW41faNMjece7cJZQpOdoqW4YA/3f
         fIU8HGUoQ0eE07N4BMO0y2I/nYNIIbc9lDK2TgxSyMbedzCLroeIeDVocAaGGxE5UII6
         27+9NGxVRT/Aatpozd4RQAfL2Qa7YcU3nbjMkv0HuN4LjlEMvpOvgaSWy3tbfUgZEtoO
         GwS7xUrGgyWh+IM4d4YKXX6l1tik452NkrFqEIo0YHsaDge+pFF6rS7R38ADOLKi8HVR
         +r/fop54lvhRmZ4nbhefNB4oPLgZtIL4aqXpkAjaShou3gCHvxVvsm8PFP+tALVH+pcI
         TzOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVc+n6/DVWWynRREv7EgRQuEbNtnISpSeMdVot5MjKV+wTO6y7D0t9m2AdStmsg2OYBONo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL40cjxgxW6dgXIZjL0z8oUO3QMdIdVJIxMQPMu4kk3h8K+PAX
	gMKLEMMnW6POZYBOuWls0dZy7CKTNXc7ZSLKqRdhzlX2TBAYfC5vg1pvVDzdkYQ=
X-Gm-Gg: ASbGncujAryLpQH/6pE/Ae74UMKlwTU2SGtsojfBBjUB8qMNT7Xi6EfVlONBWHRfMHB
	RaTC3GWbvfNrKm1oYx+ngGGPltmQ1m3sXwLYY/sr5oxTd1QIIgGAHZwH+rkRCcolq+D/4nmYIos
	inA1Z7DlZPWA+X+XLuX+rn7R1UpGzXylBs2tV32jXtiD8gGMc3HWfN7m9m2MLnwG7Q3JQolWj+9
	0C2oaxm3zgngngM2Xdht2XypyTtDq11veReQRoYbTVTAr9pWmYvBNj0Ph7MdoPox2TzEfsRUfu6
	v1I7CHMDPQdSHTsyZJRLy+/qHFYlPVYCsG8R2atH
X-Google-Smtp-Source: AGHT+IGA9pNdoHeLJn92OPL0IB6b00oQl3HQsDFWbKDFlsnsZMi2Ohq9Db4ZFbtPnsSb3wjiFMJj+w==
X-Received: by 2002:a17:90a:c2cd:b0:2f1:2fa5:1924 with SMTP id 98e67ed59e1d1-30a33351198mr4339010a91.26.1746025141034;
        Wed, 30 Apr 2025 07:59:01 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5bd78sm1705652a91.42.2025.04.30.07.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:59:00 -0700 (PDT)
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
Subject: [PATCH v2 12/12] target/arm/cpu32-stubs.c: compile file twice (user, system)
Date: Wed, 30 Apr 2025 07:58:37 -0700
Message-ID: <20250430145838.1790471-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It could be squashed with commit introducing it, but I would prefer to
introduce target/arm/cpu.c first.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 89e305eb56a..de214fe5d56 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -11,13 +11,9 @@ arm_ss.add(zlib)
 arm_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
 arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
-arm_ss.add(when: 'TARGET_AARCH64',
-  if_true: files(
-    'cpu64.c',
-    'gdbstub64.c'),
-  if_false: files(
-    'cpu32-stubs.c'),
-)
+arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
+  'cpu64.c',
+  'gdbstub64.c'))
 
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
@@ -32,8 +28,12 @@ arm_system_ss.add(files(
 
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
+arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
+  'cpu32-stubs.c'))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
+arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
+  'cpu32-stubs.c'))
 
 subdir('hvf')
 
-- 
2.47.2


