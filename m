Return-Path: <kvm+bounces-46228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EDD1AB425F
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:22:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDA243B31D8
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DFB2C030C;
	Mon, 12 May 2025 18:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xP2oIs/B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C0B2BF99E
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073138; cv=none; b=jTQ9JKLP0lGdZGyjhzNned0PCmfVA19bUlM5mcSsAMWIJF+OqcyhetKB3ZmpuuTiuyb1JwYGVmkVRhiJJL9TgwpveMCLrB3c0FXiuW3uLTjTAw3nA14FjeXeRrgXTuYlyM1rh5YP3pzYF3Y6xX5j4nT7wQymc6XaEpxR87GuhS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073138; c=relaxed/simple;
	bh=jBQ48UUiTmKfd2YtIeycQ+HfzJJ8p0Zs5JvaTTN+QW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxy7DjyKCyESXhGl0sQOl13AfhDARXyfgEVxbiJujwtrlVx4oc+GJCWAVLC5z4WgtabcSgjVplmAByTaGGzUJR4JUY2OrBQaynm1R2Y4TfHyv1L0V518QBJPwSbl9vpj86jOynnkdBnrvIU/cLXbk4eXEZdRZIAw0sBcvH9BKhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xP2oIs/B; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22e6a088e16so33993175ad.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073136; x=1747677936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SeLT1f95/cGbe62bYfKMrzmzjdSaQ72IuCLuyv7ztwQ=;
        b=xP2oIs/BwbodO6KDbplQvyV5PWpS6U12MUi4787vuR7knnIi7vd5swdZyJqY8tcAy8
         BFF5iwNihYx4PU4IF+T/6msGYyCC0e/bh0MVaRXLkP+C3QhD4RU84DQSDh1ibZTdbT2R
         buMrCiSou4Pjy6Ce3/dUn7ozoPI8txcNdEILM813pBI7QYsYnYvkxvpOuMH3/BcNpRQ9
         TCw7elpTGu9b42bnw/DvSy37sF0EN4UQ6tlZ1yZJ3PPoVrLWmNwQYaE5rngshSQ/HNeA
         0+JlGAjKEw7drKGhOsZ2mhPmgT6kauWukrzkJTbMFJRo0iOzUdGJQleB865eaApuKqRL
         Kb3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073136; x=1747677936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SeLT1f95/cGbe62bYfKMrzmzjdSaQ72IuCLuyv7ztwQ=;
        b=lKUq2RuGTrG/ggFj0kOuWyd8W4NsC930Gd0WS8pwAkkynvs2mFRjGOlMbbveF0tNVk
         l+0bpAgVP0emZ+SXuyxhqpGdnQJxLLCtR1G78Gp2tg8T4NeWonSQqkfA611rjzip/tPy
         gwAvJ1Hq0ChmSKWscRmUIqM4bZqRMD0AsUZGzByew3S5kH8GJ+rz0ISL1x8f9ypRBP4y
         9FfoY6DbtDdeFK9GmCMwg9XwQNes8TfnKXXmvex7ixq+25M4vGSMEJv79FVV27Fh3h6R
         iO4C+fP5ilaxMM1POdi5PueQot1dWPxMR9YTVMVp+bHnX5TRHjaOuWuIYcxK7g8sCFXl
         yl6g==
X-Forwarded-Encrypted: i=1; AJvYcCW/8NGbWeDsLVOb5ZWqjrZfRQZ8DzYzr6dwXRz7VyZdGXjdVKGo/OP4HpZR+nz0vJCJdT4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUFvmrtEEG5/DY4bnqZ7jU0Vy7EyCGzInuvJcLW13PlCUgmw8Y
	i6V24Xptm5vq0OuwwOpt2wpGnW7ayK8WxjR70211eCgKbiIc7Zb0QNvzcqnhJsE=
X-Gm-Gg: ASbGncsrGABNxAz4TqIq6Oqa7WmqVQN1UlDdZ7gG6rIebgvoBqwyIbIxieguo/7225z
	+SJQp/7oqVmYJrgPOm6fsa4zf/fh08gvjk+YNuDkzSkvut3REqO2Pwfg1iiHTV5F77UzmbgRMiL
	Z02IPy4dGNw0JUfgO3yRpFndCz+U1IQe50uKcR6l2kL4AE4erqdR9H94WWtZ5ZomM/xK95j1oH/
	g4wPPfi645WK1OHXejy+JZzxtQC8cl9zDGpb0hwY6Ix4sTthpRhpwBWhv0dV1785P04sS+o9vZI
	lqUIK0R+6F1ZMCDOMSXUXKUdmTLSXH58OoKNTw2f5g9u2KC7/l0=
X-Google-Smtp-Source: AGHT+IHSO/yVDZ7/NBshpsajMoSJkN06Ia8fN4xI+DuSiw4RySVI3WeZmL19cuWAva/wblsZGxHmGw==
X-Received: by 2002:a17:903:984:b0:220:e91f:4408 with SMTP id d9443c01a7336-2317cb540f0mr5666115ad.22.1747073135905;
        Mon, 12 May 2025 11:05:35 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:35 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 27/48] target/arm/arm-powerctl: compile file once (system)
Date: Mon, 12 May 2025 11:04:41 -0700
Message-ID: <20250512180502.2395029-28-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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


