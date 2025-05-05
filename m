Return-Path: <kvm+bounces-45498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD1AAAAAFFA
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:29:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09CAB1889016
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69FBD3EA8CD;
	Mon,  5 May 2025 23:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U+F1wi7i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A923B17D0
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487241; cv=none; b=efjpNturNMW3qx6zddX0wJg5WNoZgZovZJ3GOLfmUzRAzzBNPBtDG5rdZuO/AlkDrlYgl6IMJozg1O3Kr0hX6FlGQZE+pfBD3Vm1nnQsqMjvMvn83ynVeaywJhtlFO4hjyoS+/mLQvUX0TEmhRt4yScm5Y34qxmQrLs3tbvpyH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487241; c=relaxed/simple;
	bh=nW7ac0NUfdnDJCcYnr3MXIbzudND0FOdxl26cRuKPK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWw06M4lJHn2osG2HMv0p6bci9MFSZ95u5vZQt7UNZcEEgrJ8YKouMNNZVcXkQ7chsOcxIpVhymQPp+kqrQYg8rfCij9yoBjHRI2/8Uo0iOU5llxQ/gCsC5mYYBeIGq8dhS0AxBDc3u1LFTdTnZNXwfLOfkfsxcuWXg6auQcCqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U+F1wi7i; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b0db0b6a677so4801780a12.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487238; x=1747092038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/RowU+G9lDkd5OLEKmfnzuDeOXrVzkwWk098+SYGJQ=;
        b=U+F1wi7ioDTACj14XP4dA5Dgib7ce9YfUph6p36iTFEOLJ3YSfJKOKBlBYiOdyudyk
         laPZmUnnpJM8S0fxHOHZllwiAICAulsAFwRrPpPQEh2XEjUaiYBJU5i1FGSir1n86RAZ
         sIqvPtDa5Kt+v8ZP0MAEY/Ymc2S5JykQm6adDEWqSXBj65WfoaVVBpW7Ppolptwj6/3O
         LKgRcENSRqxA2vs/gmunFvAp/lIkX5jUdh9qaHmJ/GzEuodRUsHfrzSRUS9YhnAkTAya
         rXiIZ36XffHB/qRuCBLwagZKOX+ivft0LlOfWJdbCqDV99g3T20lB2nThBC3xxZxAG40
         P7nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487238; x=1747092038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u/RowU+G9lDkd5OLEKmfnzuDeOXrVzkwWk098+SYGJQ=;
        b=okLjhe4167mb2gfONMnMaqOOQVCM1HGlPxWWlMkz5gS4O+ooVql65s8CfEvmBS33MI
         U41TNL5s4sstzjmYB+DLIYvI6v7ex7xSBh3U93brY7tNTQfwnbGQhiiGLz7/85evKZUN
         SPTu/dwSUiR7l81/x6uBOvunQZAcwSoIL/QIBQpI3uWM+Qa09VH5BO1//l71nFR48qz9
         cX7WgbeLNpBPxuJAiKK4fOLgisGKAQTPPJ4T1e/gtADg7t6ygqOZ6uXEbwYjC0hzIkMB
         KVhQ0omikbS0PQa/weMPGmJ2tBOKU8PbTd827RtW0/Uz8580TAp75PS6O2x7xyNuZHdo
         6F5w==
X-Forwarded-Encrypted: i=1; AJvYcCXEBDHoVBRTdS+RrWmOzqF4rLYCcD/WRxQzVNs+OC7fx7BmR22ONCfxxG9fqo8RactH1Xk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgUeNhKV4g+zVIScbJNUINRAb7JKgLFN/nR5qH6BdccYXJBAWo
	PpeaH5Ssf+bijqkBpaBhh3nBnC+vapPADSaSXnXXQqew7wMpiGZI9MXB3KZv1nM=
X-Gm-Gg: ASbGncvNUhcODL5Hg4IK0dNCrimYoCOfvxmbPXeBiY2pe0NM6Jqj0hLxXbHRF0LtWdY
	7ssWMDNpE1nKbV6eHqxT2CfjmgOk68V4vLyvA82SKE7dBpU8nQgdB+9dJ7cwiRd6mAJ9jHo0skU
	sha80wpU/bj7WC2RIXsG8AWrWjt9H+jL2Hqo5v54ZPMiJgF/NtIeZLudSlESu8dItLNVhwsMTN3
	BwuJ6+DRdpxupJBPHlPFqDVFh5gj0yPwV+hjZ6xjChLBv+W1uAHNfPUc39ATlZ2aVtx1vxFowZ1
	eGtCaKaCUKAE9Lor9p2Efb8cijYv7Pp2ah9xe9TJ59nN1M/8A8g=
X-Google-Smtp-Source: AGHT+IH20d9iUdXCOHxwG6SI6Sy5JpqtCCPeA+IenO/oPeRx9XNel85Y0hwvj9DAfrOx6h8FyTp6MQ==
X-Received: by 2002:a17:90b:584b:b0:2ea:7cd5:4ad6 with SMTP id 98e67ed59e1d1-30a800a14dcmr824679a91.32.1746487238401;
        Mon, 05 May 2025 16:20:38 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:38 -0700 (PDT)
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
Subject: [PATCH v6 20/50] target/arm/debug_helper: compile file twice (user, system)
Date: Mon,  5 May 2025 16:19:45 -0700
Message-ID: <20250505232015.130990-21-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index de214fe5d56..48a6bf59353 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -1,7 +1,6 @@
 arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(files(
-  'debug_helper.c',
   'gdbstub.c',
   'helper.c',
   'vfp_fpscr.c',
@@ -29,11 +28,18 @@ arm_system_ss.add(files(
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
 arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
-  'cpu32-stubs.c'))
+  'cpu32-stubs.c',
+))
+arm_user_ss.add(files(
+  'debug_helper.c',
+))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
+arm_common_system_ss.add(files(
+  'debug_helper.c',
+))
 
 subdir('hvf')
 
-- 
2.47.2


