Return-Path: <kvm+bounces-45771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A760AAEF59
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 409CB1BA7B1C
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7EF8291892;
	Wed,  7 May 2025 23:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bcHBrRfS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E86329117E
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661369; cv=none; b=Me61s4MVxJXyywq4bHAboSb2feEoQgqxemBbWXNiZql7njx4vMU+KAR9dyjAMbt21HUCWvyQAKk1hhOz8yFf0N0v6ECbfDuqsUlGU8LFG+8d9RY1XptsmZEXULWgExYQ2usBfom0XQAWISabeeNBBwW1dcqp0AkJiUZDE1BqGck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661369; c=relaxed/simple;
	bh=1hAGtngwcXI/K1ZVwOSxlRZCzxWzI2kpJ8rbj0YHGnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPXTaXLanXE0I5yy06Q6Ek7WiCu+7cfYkyrHFHj6NFXOxH8DpCpaQn+JbJaNzFAqzdjrSrRZLEPuaTWuexrKk5qs3rzwLkSZ1WA7E9nDIaSgnH5J3UduXU9Ynh3xIM/0NCACLXlSPxpuIDaUR5mGOg70ZGnOMZPF3w85QI9Goks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bcHBrRfS; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2264aefc45dso6456915ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661368; x=1747266168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hckfD0sziqBh1sSWGP9c0OUCVTgvBeVKgVHtB7xMeJ4=;
        b=bcHBrRfS4tbLsZDQA67sEwGFYtBvPN5V2UO001WUasX9z2VQZkXUCtalXiqpRu2C6L
         X1CHeryLfy3aGA8CLDZN320vfXK26UJ+DMs3XptZdLDQqDptHTMZ9T/PajXhDtcAryA6
         /lxuZ+dwcxiSSkypiwOmD0Op9zCUrYCLeKg9FPJgJff7ZcN53SzzB+Tn01H/Ie6twJ1E
         8jWOgSufr2WMs3odAXNZHQA44yZn4p5v4o/zgwLpv+0ukjhnQzWHc5m+pS7abmsniFxt
         k3QrL8Gs03ivT/SGtfP7K2bBzhXa15OYaR9U7Xief4YgJeITBxBPt8hOXGoGrzhQtg/w
         oxpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661368; x=1747266168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hckfD0sziqBh1sSWGP9c0OUCVTgvBeVKgVHtB7xMeJ4=;
        b=gocqbBonaoHWMMDUstoNdg5W7/Oi3gcML67Xf3KuRPbW/1wObW3HhsphXkrLgVOZ3w
         WXqkTn0lDrAN6eICb1RA1uWoeooNHkX3ZSmmFeTRDblaO+2DCn177873obpuQJHVS+Wu
         dd1/s54C7QqZ1Gfp1ZK8zL3Wuvgz0dOGYv/d3wQhn+E8mLOpuqHJ3g0+JORknvekqYVi
         IWizLQsCQJ2VgzCCbK8T4ZebJks39mintGXKM2NJAJsBDePvYdltJBFm3xD5zNwuxKs9
         rWndkqOhCAzmKxFZIealP8mU5UufvbOk7280bXFnHOpLWYxh6mHDs6VKNgzM0iEGIDaH
         DAOw==
X-Forwarded-Encrypted: i=1; AJvYcCUM5G/rQcjAqs3CzKOSTlLuIYXhM4Fh65FVm0knLVqUM7Tt4JgkxPsQAnfJKy9lcU4gl+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye/ud/gF6d6zjVdiRw+LqbyEwuzeP0iuOXhOzNHwX78h31jipo
	fqD+eUZeKCrCJw1S4ijGyZEZiWQgA8qtbvA4Smok9hNzb1q5+5MG0LdVVndQ6Fg=
X-Gm-Gg: ASbGncvqlbh+OZHYjXeWZdrzsWfWXrNn4YeOgaohLmdqcph/LPk6gHF8+I82eyasoRB
	ckyxT1Xdu/dGP+U7G/r/kR5Pugno1DNgLk+dJPG5Rs66dk36j+UN8sjdkuc8Bql1YCr+PVrPlhV
	2RyP5+zbv5zPmLLIH62TiUQ5Omb/KDV3MGp2ZqRCLF5PD2CCzhA7eXt4gDk30Js3KeMDJERBCxW
	mQQiMx3QdzT7CquwjzfqcvUUu1FrAKxTdE9oa70OuijJYsDr9bspG3AIbjlQQMy9meRmrKcACn7
	fAD7qVsdFAPFl5yHUPVTbUsEd8bPnFrBrnsInRAl3mDgxllj4HA=
X-Google-Smtp-Source: AGHT+IHhqOsHNXPZF4TnzOtAP6h/+c55CQlBQVlH/8L+pGzc2viJ6SxyDzkoMnBGSlSBqkYi5ON24Q==
X-Received: by 2002:a17:903:d1:b0:224:194c:6942 with SMTP id d9443c01a7336-22e8dc8f2dcmr14656095ad.34.1746661367784;
        Wed, 07 May 2025 16:42:47 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:47 -0700 (PDT)
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
Subject: [PATCH v7 05/49] target/arm/kvm-stub: add kvm_arm_reset_vcpu stub
Date: Wed,  7 May 2025 16:41:56 -0700
Message-ID: <20250507234241.957746-6-pierrick.bouvier@linaro.org>
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

Needed in target/arm/cpu.c once kvm is possible.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm-stub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 2b73d0598c1..e34d3f5e6b4 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -99,3 +99,8 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
 {
     g_assert_not_reached();
 }
+
+void kvm_arm_reset_vcpu(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
-- 
2.47.2


