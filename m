Return-Path: <kvm+bounces-45793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB3BEAAEF7A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3110C462381
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E0B293731;
	Wed,  7 May 2025 23:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bPQUg0pl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D48329291B
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661388; cv=none; b=MRDadm+1UrcUNDBrNVLyNBmJ9ghUntIEhM8n+A9B9FZW4+cmzXtqDDf3t5cuBhg/9rfKlP+NmxM1egiv5+w4dXMhdjSWWfz+o/BiZwAa14Tfs4Y2c8VkrIKNDffgNvyKbiCOP++eEOPsbg6qSc15B5YN0IzpdgPqfciTM422I0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661388; c=relaxed/simple;
	bh=4VSma7tBGQnF8/QKFfrPJksO4he5ezXQE7tRteaFFz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2IH7lkYb36BwDNCVLIjNow3KNS2c7jUdaTKnklAk2cTPJVJ/wfCvyCBk7Y1IJNk4cpoMnZ9yJJKANgt8vXgnUSudPkexT7bXbK6aIm5b6MCo2t/erCY7asYnCNHAhHOfzbOXPmzXZ6kzdPV6W8n0rT6CHGHiaPetO3xjcG0s7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bPQUg0pl; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22e70a9c6bdso7571815ad.3
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661386; x=1747266186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3Dpv/gYklKxQ6NcaNjklM8os0pkN4N34WBJsdRDY08=;
        b=bPQUg0plmlr7UoCWgJWFBCOHXUh08T59ogHUW5spo/j7ApBl/pns39A2ohDswgh2ef
         K7TuBQ8BXvYYgDWr7TFDfSwb4hR4YCGmHT3jFkx+yywuo/qBrx6XQEp3fmVtMcsezN5L
         bRv/Aizm+3D8lDhidtmqsZDCN7M3Zq0tdGvnQBlwyQ3Wt3BcdoAKel1ub7riGEFaYohE
         8iT8m/gTWWb3zehn1qXEWNBpn8W8PAUq4ZTsAOT0C0Cn5bUGEyiZP+2oMqc6Wbq3/yV5
         ch+dxVOaNRWQQZeegyc1FUzg1ynrsp6ZdOkudsUnqM/U3/4vKutzjCEGq2S2taFQcA8v
         UTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661386; x=1747266186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j3Dpv/gYklKxQ6NcaNjklM8os0pkN4N34WBJsdRDY08=;
        b=RsoJQyEtbBvsgvaKxlhqTHgWsMOl7VB7CZXkyToVT+CCMHGPinwk44XtO8Lf4a1Zgf
         TRKV7dLKWFRH3ZKFr/GbkogTbQfyKKBJNkfLImYA6Jh91LDB0pi60GZe9FnlTymOz9o9
         Q6HAqioPo3K89RhBaTVM3WRIueZO0Pl0qFfS+9Ojp8J4Bngykz/gSW4UjnlcrqbZ27DW
         gBZiDP/598cAHTqTaLXLLOSm9v8Bx0fJxUbTYphoZsGqnPi/T9C8m/Stqp790eJUsoOw
         9AzKoTWV8StRJC8lbyDfJr9R4dg9sqNL2t0nb8AygkS/YLZaP7Rj4ztkYIQPGzcjyDWz
         +vpg==
X-Forwarded-Encrypted: i=1; AJvYcCUapE5i1OcOxc3Ptq3WRcZmEVzjTQ5OIO/8XY1F1xkrixQUUHsNuMN7ILc/cPVCPPjvFPE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDl7N3mV06NWg9Z0DxtbkKcdr0aeHJjvaQlBoj2k7qu7cxkZ65
	ysVTqAyxiqJTwxwpXCprMQFFlzWAWGLHbNjb4VR3HAf9dpz4HeS3DN4GV0J5rdY=
X-Gm-Gg: ASbGncurXrFIHjz5fzDy2CejXyO5eTpy5QE8WC9JETjwI4fmW8mRZXgCD6wX9FwvmKt
	dggdp3E/SxD5tszx7r9S5QvYCgOP636ok7306FbSyPAfPb6n2RyC9ICVDri4GoxDu8pqTHSwPfl
	LIMl2MUxHM4GT20OomM1PB+sDwolKoX/J/OgVjpHT+bmxUYD4U/rS+Qi+Ntf7UoYNPJFSZvnhcw
	FEp/o0Cv9c/Hprdcyf0TaYmQvCrBQkuM/MuIPXN4velh9v13CCNHREpkDXqr3XEbPYcfuqha0Zs
	ZTWcpPPXAeLpuHdLA+5MIdvuG0hAh0rvFjbHBHCTIC3ti8H2U0I=
X-Google-Smtp-Source: AGHT+IHt4tu+CujvY9eN9hIbp06QoRW/RBo9JhAAnZCE/TrHnO1sU7+xOK/Ll3Pyp9Y/rNdj63LYCw==
X-Received: by 2002:a17:903:3bb0:b0:224:1ec0:8a1a with SMTP id d9443c01a7336-22e5ee0f11bmr68096735ad.51.1746661386730;
        Wed, 07 May 2025 16:43:06 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:06 -0700 (PDT)
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
Subject: [PATCH v7 27/49] target/arm/arch_dump: compile file once (system)
Date: Wed,  7 May 2025 16:42:18 -0700
Message-ID: <20250507234241.957746-28-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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


