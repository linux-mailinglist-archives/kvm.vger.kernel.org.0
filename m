Return-Path: <kvm+bounces-45034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C634FAA5AC9
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:24:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5668D1BA71DF
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0F427057E;
	Thu,  1 May 2025 06:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M7B2PCuK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9690226C38A
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080638; cv=none; b=jzqGL2N1XGXIkteGxrLVEycIGvy8o5PQCpltlqwDk1/HD8/0R46AYF4c1yEYEQutijjYC2M5KHM2gVgYo5oM4ZeSbgUpqmtnutJkHqKQd1Qjgm94iQm7VEuBw3Ldhk0nepp0tELiMathdnbrDHcHWOdXw5y1N5zHQVWi/Zjuh1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080638; c=relaxed/simple;
	bh=1hAGtngwcXI/K1ZVwOSxlRZCzxWzI2kpJ8rbj0YHGnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyLQHd71G+sE5asdULGojKoilDbu+PfKaUYzep5ZtJKbyUWHpZFGeXePlmzh7mo3vx7qel9f/UtZcgz6qJD4ZK9kbhjCgpyxBrfuGsI+ccDd6EFCweTvp+zFBSLEzq8GLSSniIJD8U7LLdTohWuzr9DNj46kSmq9cShMMf4k8zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=M7B2PCuK; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-736aaeed234so664430b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080636; x=1746685436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hckfD0sziqBh1sSWGP9c0OUCVTgvBeVKgVHtB7xMeJ4=;
        b=M7B2PCuKTqZvl3A7OswIFQnvOQkgHgpe0BTFLw3lVXUZxUNkQ9Nfs3HrTyD9ER9E93
         MRvTKkTp0TLX7vd2g93A1VbxjJrhf65gCv2TIg6qoOnkpnjnFWG9+M9kkWYBcCYlG3FU
         r20WvPtGG8Mby6vc6r4h/WItQlPNxewbw7S8dt92AyTgutQfSKyhSFAuefVp61ObGFM4
         53bq76EsZ1MCAvMHddrwCRDSZFMi2e09NeD8k7aZ5ZtfZYwjMuH/bctgpJXewY1tSTt0
         nHPc5v1bFSSj99iKSxR+08kK1kbt1KjEmj0wKP92HBuA4RBW5BVhitv7OSVvjSzh6W7U
         YKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080636; x=1746685436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hckfD0sziqBh1sSWGP9c0OUCVTgvBeVKgVHtB7xMeJ4=;
        b=I/YZ6tRfyppK3SQ6h6khLoV5upcPD61YJnZ4MJvfQujfm8BvyBMEuCRO+mPRXjGhaO
         ktutUSEqiFiNsZSkEQS2Dj+AJkW2+YTDhknIRF8WTyxpjRcqNkf72ajr8Cyr7orJZ/Ba
         s2F1vgV/lOFf6gDYR9f2jxnmStxEqhUODH/DEmWBl3u6GOsolfuO6DUH+ejxnS2QbNj0
         hjCX+k/IgPFFk76Hlk4L+9ox0IGxhbM6n5sqAlEWVDB28IYv85+9qr+M0fHgaq0ro1ZA
         tjAf0/nZwUT0mfAfplSy9kegcleG4drcK0h3jmjxhEVF904LqDynjZtd7jA0zIhqqm/V
         pesQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2b3gI3rkTFOjSSc+nXoF7kde4rS+xcowjRfx5RbuewLu0yWkjMr4AJSnaUVTYJhl31oM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgiWQS4xY1owE6m8j+xcaDx61hGfXRo0UjAF5iZTCsh6zmNPxh
	JzqWQQNMquddpwucPPVtTwi03jk3oc3Bf4IyEBZCKmC72Z5KHSJ6sQIb6rq4F4d7OWOLCd+yPvD
	1
X-Gm-Gg: ASbGncvRD8Ih8sLx1/tmAdGa9jlUGuDSBWxgBXehWNfWI57mgMlNotJx+HBuHISJ+AZ
	QBeT6oiyo+UfkPRHi1bpyRI8m42nfCVW1OYlH2x98tR0taV51syCQ8Xgilnyc6Lrbjw6VDQjelI
	RsF2M6iTGtSUG5H5g3YdNQFqjYpXSyg/rLoQUzRtzzpXoPS3MSwj2plRq6EUwCnse11NNz02Gke
	8rw5FfZBSnjpIQyh0iLpBGEkQypfQBpFzbHOaEjw4ox1d5YxlbEp4zBOKpKQCInGIP9bLGxczP1
	LHRE3haIH87wONervsSqx5gd+mlJEmjaFjl1ebk1
X-Google-Smtp-Source: AGHT+IG+S56+ZntAoiv1rm9bGFR6phj1Ukrtx0wPUeRdiOa/xEyLOl/9EMgghyX64DBYfvIhG6E49w==
X-Received: by 2002:a05:6a20:d046:b0:1f5:80a3:b003 with SMTP id adf61e73a8af0-20bd864a95cmr2230421637.37.1746080635889;
        Wed, 30 Apr 2025 23:23:55 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:23:55 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 05/33] target/arm/kvm-stub: add kvm_arm_reset_vcpu stub
Date: Wed, 30 Apr 2025 23:23:16 -0700
Message-ID: <20250501062344.2526061-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
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


