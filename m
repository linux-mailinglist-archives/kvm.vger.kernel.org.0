Return-Path: <kvm+bounces-22008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14AF2938074
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 11:31:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C51BB283A0A
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 09:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799974F20E;
	Sat, 20 Jul 2024 09:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="Po4RNyB0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6829078283
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 09:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721467884; cv=none; b=lW/lDz7KRM5gmI/IhjI+Ckiq5oIN4B1dyVYU7nkgtn7SB8s9vlv0kPVrmlf5Iel+fPzpBR5wJNiq20PncYtdSGVFYr5QUKuVtUMwf8CtG3OBKq0ZIkgJcwBZjqvNj3n1rtkSl6kMbXn9vo/pjIEgE+kPKVcLGjGjpqWUuZJTuiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721467884; c=relaxed/simple;
	bh=tbQF5BcKxA0YVcarKDrPEhr3gUEFDSjtSMkqN4q5EFs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pRGqntVkgj2dWlX6nHoW7nOOBwIJM6CHYvfl6lXWFyv3XIh3X08zbDs+03QJr/pp3vnReXtHGiX7O6XtJHCmfuVp7z54+kBK5pMgg4mfV9HvGyl2cTJ27XSPOonJczpX2Ms6p4PM5mfiwFn1Mqdqpgu26aztUHbqqtuUk9ey+H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=Po4RNyB0; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fc52394c92so23547585ad.1
        for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 02:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721467883; x=1722072683; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r7Pn/awe7YFbUwLON8GOovUdtzCktNX5WHOGmuP4ywM=;
        b=Po4RNyB0/3naYN2Fia5923QIRHDVqrqD+s2C7gFSKls9m/VkJ52e4YCD/8miGgtuVJ
         Itdk/cii/40RA7doHyDIgWUSbyaUsQsIZn7iBdsfEJOXZinYWYasN4H7WCZ0xceQmZ/S
         5LfYjOdq1Rcfc3Yg1926pqiz9Ns5TnUTjOUZog10wLkuyPls8XJSGczkUcrVLzAmxrhD
         78oR4l0wRUiuYmQLQM4aYKRCA+BkY58cHlF6H/6ylotDRIH4jJS4TnNaVZ/4nJoQDeQN
         uypk3wlPIP9sBmxmc7PpH4WR874i2/FzGZgL4DQZpGrBWmZ3bxkJVyuCeBBDX7CCJZVQ
         1yCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721467883; x=1722072683;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r7Pn/awe7YFbUwLON8GOovUdtzCktNX5WHOGmuP4ywM=;
        b=wKWCNVZlFQTfc8mhS7J/KrKyg7rJFZdPhKISjthNonJAXkkUJV78yfi6A6m8mkaSjO
         cPcUh6hghs8FsHSf9Bk9Gtb+0UDbvcV1QwKxOduKZxlcQrcpavuREXbXlwwIa2K9Y6IU
         //GePPXgjkwQzijD1Ea7YO2HGHMIymPFhz/1MchsM+rCIMFEDm5shETwPoHKgCSdL2gS
         Yo81Y5LVawiIvv7j0Z8GRshGF7pQ1x5aIzHlXT1vTDVr8DdZErx9K9MI6CF0Fq0V4b52
         Bo9+LnraPQmbdacLBfKhOI+7kjFZVO/lXlF4jzqo1beLcvKPRTN8s7EKfUocW/FGpZsz
         BSnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVccVmXXYgRkS5RO6Q/E6kzMZjCg1fOgP5DPZxsXyXIZ8VZaYLczV2+E7noLutL3Fm6wMrUWhLgyV8/gUF92wVJ0D3o
X-Gm-Message-State: AOJu0Yyi0u1kmJ/qVdqZ+7r21fPqa7kKIW5jUnbWs3wv76GFLuV6qp4e
	/XQpFCUkbWj21k05pY8wIx2gjxIcLPOGb06aV/6zF9bxfxvh+UGhglsEobCkMKo=
X-Google-Smtp-Source: AGHT+IFuUHFAzQo566bTzAMkFSDEqpnCRbmcEzn8TLq/DlebkV9YSGugyGdb6Hgs68lyvmeUqWCK3A==
X-Received: by 2002:a17:902:f682:b0:1fb:9cb0:3e2f with SMTP id d9443c01a7336-1fd74573c4bmr20335395ad.27.1721467882736;
        Sat, 20 Jul 2024 02:31:22 -0700 (PDT)
Received: from localhost ([157.82.204.122])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-1fd6f3181desm18119545ad.128.2024.07.20.02.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jul 2024 02:31:22 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 20 Jul 2024 18:30:51 +0900
Subject: [PATCH v4 3/6] target/arm: Always add pmu property for Armv7-A/R+
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240720-pmu-v4-3-2a2b28f6b08f@daynix.com>
References: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
In-Reply-To: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

kvm-steal-time and sve properties are added for KVM even if the
corresponding features are not available. Always add pmu property for
Armv8. Note that the property is added only for Armv7-A/R+ as QEMU
currently emulates PMU only for such versions, and a different
version may have a different definition of PMU or may not have one at
all.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/cpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 19191c239181..c1955a82fb3c 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1741,6 +1741,10 @@ void arm_cpu_post_init(Object *obj)
 
     if (!arm_feature(&cpu->env, ARM_FEATURE_M)) {
         qdev_property_add_static(DEVICE(obj), &arm_cpu_reset_hivecs_property);
+
+        if (arm_feature(&cpu->env, ARM_FEATURE_V7)) {
+            object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
+        }
     }
 
     if (arm_feature(&cpu->env, ARM_FEATURE_V8)) {
@@ -1770,7 +1774,6 @@ void arm_cpu_post_init(Object *obj)
 
     if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
         cpu->has_pmu = true;
-        object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
     }
 
     /*

-- 
2.45.2


