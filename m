Return-Path: <kvm+bounces-45334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86FD8AA841D
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:33:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0086617A212
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0FE3DF49;
	Sun,  4 May 2025 05:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JmCbyWj9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DF2320F
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336788; cv=none; b=aIHCgoyREuRinvoIgmCfRsd6Rfd34yMkORljn/9RWSJmCaoxu9ec6TUMA/oBaWbf0NZuHK+4hxZWm57Ts4zRXVdoJhsYVIHig1qklZjDrtZIM0jCj6twd9bbiwfQQVDwMkKI60JVAFsaaeBJCNE0KPDmCRFcjQ0xt8U1iLjmvFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336788; c=relaxed/simple;
	bh=8PmS2CChhd9vhB6Y3OFB1C2hvfJU6WZs851UPN6XnbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVzwr3qZMzjKlY/DDOEm4DWRz80yGmiJhFo6aZkqf5DIQ1O57isbPn4998atZzJLa6E+2TfBbYsJ1mkNKzVqPg1jSWJJUS85b7QDnUZ+P4tboKDe5PG97a1Iw9soL8joxRrcbTps9yFVUaOu7/7VITqrnvAxMTc3cqGqsY7WaiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JmCbyWj9; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-736c062b1f5so3422172b3a.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336785; x=1746941585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZhP0z8+DVkBnlSxtMGbkJypdQb1sgmbB67l7Zk5LpFM=;
        b=JmCbyWj9oZlg4xcK48L3RHRPdNH77mNHuhssfP2l1xh54MSk+Af/FOzvC4L/FFtkvA
         FMrfo0pYaZE3IfqE3NviuBtkM62ihVgAzpwk2ygNdBwOqarMDJa6UJmOxcdSZ325xIBF
         Z8RBZWGCj5phK3jEHGlK8H2TcjDNCOcXCvd/dY/ceyl3MaSNXkjj5hY+VtKnyD9Erio2
         VDn2yxs2i4qc7iFtIbZCC3AhLkOaGOrMrFS4o4PppHZTvPfit6OthywyXKwPTLdaj8nP
         +1cZLtBovFLdCHKs4yuYzgAngkmC/AIswy41znNzYnPpeFaaSYbcm5ciUzrBXf+586O/
         /laA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336785; x=1746941585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZhP0z8+DVkBnlSxtMGbkJypdQb1sgmbB67l7Zk5LpFM=;
        b=FKZTx2FEOTtOxhXEd5dAa2Ncu51qoguKUVg7X0BjSbdcsokfir3AbuvX8UO89fUpPb
         P3Ky6j/o3lqooA746tf2hLrkMwmfKu3UF6l7++EoBRhck/yMDRwZu64yXyW0NVA3kMip
         JscyiYa4Zne5pWi21myrK7QtcUmrmBDBMOdhHAqaJLUmaEEegUD7QamquHYigOxQaI7P
         htOftoI4+A+fgmiOnVkD+946iAnqhbfCHfPty+BodsPUcqTqGTZFlFVr8Jdst1HPqLDM
         URMr4wC1TG43IIjWwtt/ApFcRHMSc5oB+gvEdwEQArYeKuhYe7wAezlxlPEH5juEEjmE
         CB6A==
X-Forwarded-Encrypted: i=1; AJvYcCVM2Nud+cEpeffPhIvVFPsWq2U/iNX772GEq/HseEGb3mtOW6HicESUMzIAn6K3Pkn6FBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSqS6WUrpyBfB/DFFjC5CWYP9UeW+jBVHhpDE83B1SQzKn8FjF
	GqQNTSGPdAPWh0LW8MlIO8nKbElBnzOt9Y7QrGvbmk9RHB+sQg6nQ6m8SLg5xmLLQ+P98HLTBD8
	Kd88=
X-Gm-Gg: ASbGnctlcblI6BVxpZwfM52uQZ+zieQ+2CsdcAllpROGKWmfHHXGXNAL2CZDvqq4afG
	ebrxtWVUHl+sWPyX1jiioXjeucDVoMkudBnJBlAuc68zPJul6te5VZu5f9JIF+zypHO8DIa7EaW
	zMWbPR6/i316Fxg8fxedToMEsWL4NN2utKc5Bu7QIKABDzwGbOsLj+Hyrwrn9WeXjY3PTz5QAR7
	LfbbrRls9nbAzSxOmkdS6E4qBgCmBazqQp8+2xJIdZSc0gdTu6h1TGohNrO/gUZseorLw+RWect
	+s9r+HTS9BtWZFrSnsdm4oo6ajx5ATEi5RZrKNwOSlw0YgbTc74=
X-Google-Smtp-Source: AGHT+IFxzLf5brOirIah+E07icoYpHpD+eH8Rlgkwz7ETNho3CAMflgpUA/uxvEn58nCtyo036kx9g==
X-Received: by 2002:a05:6a20:9f8d:b0:1f5:8cdb:2777 with SMTP id adf61e73a8af0-20e9610a719mr4360406637.3.1746336784802;
        Sat, 03 May 2025 22:33:04 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590a1c09sm4237101b3a.168.2025.05.03.22.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:33:04 -0700 (PDT)
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
Subject: [PATCH v4 40/40] target/arm/machine: compile file once (system)
Date: Sat,  3 May 2025 22:29:14 -0700
Message-ID: <20250504052914.3525365-41-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index bb1c09676d5..b404fa54863 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -13,7 +13,6 @@ arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arm-qmp-cmds.c',
-  'machine.c',
 ))
 arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
@@ -39,6 +38,7 @@ arm_common_system_ss.add(files(
   'cortex-regs.c',
   'debug_helper.c',
   'helper.c',
+  'machine.c',
   'ptw.c',
   'vfp_fpscr.c',
 ))
-- 
2.47.2


