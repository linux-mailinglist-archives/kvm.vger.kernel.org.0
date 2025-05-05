Return-Path: <kvm+bounces-45376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C5F0AA8AD7
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:55:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BDEB3B51E8
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C0121E3DD7;
	Mon,  5 May 2025 01:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M0mAxhII"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAA61A0711
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409977; cv=none; b=GYkiYH/adpsSvVFq5o3KZX8kDW2ekiIpTNPjMqgSIz4kHGBczYmyogOAaS6JTzOHcTz8Nu2o6D1rCfPrm3zzqLyyetFOnFjbENtWWwo1GOsUmh8BJ4XIvB27yg2yHXtu7/VpSQk2c8y1Z+J7gpn25UNgspvdoMzJb1aqqdWxAFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409977; c=relaxed/simple;
	bh=jBQ48UUiTmKfd2YtIeycQ+HfzJJ8p0Zs5JvaTTN+QW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k05/zMl9yDsumNtqKVMUM8pr4GF1UJZGuB3zywzH7jX+K34VK3nNmPhohfGso2HOW0fHQ9Q5UoSNSfYHei6Vyks6x1TM+n9oSNr3JURFW+Ms6LrYNxdlb21cEsCaM3pnyqPLPqQ/EyjhTh07sfgJAVQiMRXEWXC0bWDzdPjRITg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=M0mAxhII; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso5500164b3a.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409975; x=1747014775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SeLT1f95/cGbe62bYfKMrzmzjdSaQ72IuCLuyv7ztwQ=;
        b=M0mAxhII1FsHy/dVwe1KGBYna/yT5Yhq+pN7RmMgdm58xz0B/r7PFmJpmdHv+9ndc6
         qy/lBDe/I+VPC6DFLWcFQuv9KqEIZ3IxPuZ6jm+8O2N+8CwEbfTaZjjYpNY5PQlbiHlw
         WScdvVjB2SD1gvbdwX2dnA31sN5iMFeH1ZbHiYnHQPojtYycw20yeiKzJJ+MbsZ3GE66
         +fYSjHvzq3rJl+Kglh0r2Nue8qMGKubAMENrBDZ95BdX/df08PNf80yfJGnLk4+VYcm0
         AYNpR4hfQ5AHoGcn3vGUXUm6ilzYowto32uJn9L6DSNgZl2J/iZofQgTxL5AdjB69yCa
         ORGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409975; x=1747014775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SeLT1f95/cGbe62bYfKMrzmzjdSaQ72IuCLuyv7ztwQ=;
        b=f43esrLRqUrf+ybMNNUB4WDNv4QbI36AhmkWFdG+EFDCYbo//ukb8cH6wxvz+38oRN
         LUN4IXLHhKdICi2t3gMQsvjVMPEZHKDOGxrpDhfOjfiQ8+yX6TS+BHCY1x4xW+aqNtTV
         5fZDunRAQNgCyzCfydQwDYMZKCovRswCEQgbQwpr4oKavbrCxHYn+Lmv/34lZ2a8R+AY
         dspUpjGVQ6vR7d6x+OIMehENH9eO7/yI3YXGyJ+kxuZ6ABc6d/hIsYoOYHmfVN+IVxQM
         9C666245EJnkC5Xx7rifWDo+uIdQQk2WmfXD8Y5I22w9XGFmC5137Bpk9Mb3NkAZqxWU
         8QBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdV3jNwUDLWeqa/Y84MZLWHq5nH/6iHRgUMr6m9Bd/lVlpQHIAyCkQkD1AsQ+wcds1EpU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgR7rm2zifydedh1K8oscTAxntvRGiYbUgh7cFknTwG0N3QJXZ
	QnDjVWhgLK/kVzAcV8EScp50IC8Z9m9K5GLLN50zMx+0fKcEZMCGY6S7Nv5A9DM=
X-Gm-Gg: ASbGncvbzf6dd5qgp8grHbeLfjJ1wv0t/ixh5YTwbhiZOZtF45rzIl9IYYBfPfcTFBz
	BzHq3ziUqRxFpgbTS2yTkr6q1NG1RRNH9WjBQ/qTyXoIHOd+KrDUlFsHrFBTZn2jj1iPSfodCGU
	6NznF2DGBP5nk/145qxus/i+uIHayb9+cz/LywniZh/OKPiSd89v+W2MKmH1WUhLFwmZ+cVf3YR
	+66Qeb6K/+I7w0nfDKZMnfyPGO/zcJJ8HZqC7wN0/qbTZspzRA6ITkfu+q+7lp5npYNqPMS6TKL
	MXcvRhCVdgthrxye5qm0OE+u8zpyHoTmHM1lpw39
X-Google-Smtp-Source: AGHT+IFov8TPcHO/7aZomFK+AG+jlBt3spUroyr7V1nRBJYJVIGK7covInHsA0gbZOIJ3WBHEurTkA==
X-Received: by 2002:a05:6a21:1743:b0:1f5:63f9:9eb4 with SMTP id adf61e73a8af0-20e97dafce0mr8559737637.35.1746409975059;
        Sun, 04 May 2025 18:52:55 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:54 -0700 (PDT)
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
Subject: [PATCH v5 29/48] target/arm/arm-powerctl: compile file once (system)
Date: Sun,  4 May 2025 18:52:04 -0700
Message-ID: <20250505015223.3895275-30-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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
index 95a2b077dd6..7db573f4a97 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,6 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
-  'arm-powerctl.c',
   'arm-qmp-cmds.c',
   'cortex-regs.c',
   'machine.c',
@@ -38,6 +37,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(files(
   'arch_dump.c',
+  'arm-powerctl.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2


