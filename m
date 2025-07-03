Return-Path: <kvm+bounces-51409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7681DAF7112
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:56:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 857A55271A6
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE632E3389;
	Thu,  3 Jul 2025 10:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bdzXpVO7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6159A2E336C
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540177; cv=none; b=VwfXq+9jA2xOTDOI9BE8e3EiOYKLlFeoQ71zeDHhkHMBJ81vNlDi8aUpwKjC3sY70cgOvTehBYjWTQMgkkX5mdfgmOGcinUG8LrT6xvH2YqpeD/omPkwDphS8kdCVRwnbOWFAQRK4YSWbafa19ueAbFJnaRM2HyMP3pIR5WElU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540177; c=relaxed/simple;
	bh=OQk9QRusfHQEt++YC0RplGJPmlYhjJLC4+HrPr+sP0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E76AzrcgSXD1hObMJwyBh+dDHAli6SlbD/RO3/i8CEIb96JqPoKNjJjyjBdxsSqOyfYeyuU3o+eCNCXsx9ilJrRqQiqJYQVBQU02KEPva+rkWi3/fwbkUNuOCnIkJYqDbBsnIYTA8y6QAByzh7FeZ101a4wvm8bZsQ4H+3mXYPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bdzXpVO7; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-453749aef9eso31026445e9.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540174; x=1752144974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/J3/dM6yL9EpwD8nNu/ZbysHMLeoDjMiAJQk/DeNw0=;
        b=bdzXpVO7rMyUYZBMr0lH+nqLDyR5SPWX9str2yDG5RlV9h9tyi9f3lGY9FT2HgHPGy
         cq/ME0Xitgz08F23vjW9oQgk3HHNl9VBQfg27s2qyNDo5l+krNyz8IE64bD+bURSraLN
         JP1A4kk1KX3pM1JBDRDlNMKoZJH/0l0/ajKd5pu8qNymcy0qcWuDCe+KXW8dQbAeWQo/
         R8ztwc0u4A9+bJPwN2Uyh1TXHwsml/IZ155e58Ce73VjE0mxS4R7lMEoXnDeb3fDWhwv
         tXNtZwfkchCiCClEjsom1JnV/E4DCLtW+HSDe6O3jMwvuirLUdYmcxkNy+Q+g0PfhO5x
         nN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540174; x=1752144974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y/J3/dM6yL9EpwD8nNu/ZbysHMLeoDjMiAJQk/DeNw0=;
        b=GisbkWW1mYDdcDwUe8RIo5Yezrorzjakvy+LD0PdMIh3rixkSskafUItnGN1qj/6iw
         eNQ1T28YO7EXcoWb+MNDczeCwfECu4nx21fROt74/jcosuQgdxocEUs6G0LZnJLsnmm3
         5I2kg1RiNRXQaIQoKu0ZT8f5DBdC6qXD2EEK8s1B69HuRnH8XYidfTvxydITIeuvnZTk
         k/u0X++qQTiQ6UeAJ+tbWgp2a96TW5ktGsY9wIhRq9sNlLYq4XDNMJ7Q5An/AJpasRIs
         ywDgiYHLlNKBpgIzOW8lYOX9C9ZChjaQoPZC3N9uo7GafTsB32uWTVIJrYJobT9lZqfP
         Ubxg==
X-Forwarded-Encrypted: i=1; AJvYcCWc86ctxMLv8pxYT9xUi5RcvrxQ07w+KG8QeXT8W5CePOGKwSZ/UbqS6YUOc3JAHCIfwCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbwvW9dsOHmIx4PdLD3ySDxKbfVplPq78khGDqyK9p54GHc+87
	/Iy+IEO9ZEB9qkGJiM6xVilkWGzxdvfaDb/qo7FczRkJmR1ccgdsCl570A9eQh4DsfE=
X-Gm-Gg: ASbGncsr5sbQUmRkgYNGlXVlr408Hw6ZXfx7gque5uRA3MfdMk7ahUju3DXrNG2FA+o
	+81eLquY/wOX7h5opxGD1yiJaka//6iCtYvROqfGqrUAfzZq7hJsvtkVzZbItsGSZGphulyReB/
	7U7CLepT/hPk1gtXieribUciAT5kQ8JRKGjNZnEXwk99mh+PTEFNiDF8ziD3kWhmpZbw/zNg6cO
	bjI6yH0A1lXmPabNxg/3aqYPOYcRcizMl5nW/qtL95UF2mbXmwx3xJYQ6L4TY75zLFMQCLT/6on
	3i3SKYbpOaxw1x2JuN/1qRydCA7//uZ3V+oLpm4b8rv19KTJyLzj6rtPzmfPgpu5ZgEFLqMg2JX
	H3ZQdSYD8LMJFvbsR2Ubt5g==
X-Google-Smtp-Source: AGHT+IE8CQFMkrSZkVN5zYcmbJcCj+w55d08ptBKiApntCikejet06VTaL7qzyce9VIEA15pyWpTmQ==
X-Received: by 2002:a05:600c:3e0c:b0:442:d9f2:c6ef with SMTP id 5b1f17b1804b1-454a9c8b12cmr36033545e9.2.1751540173782;
        Thu, 03 Jul 2025 03:56:13 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bcebd4sm23421365e9.26.2025.07.03.03.56.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:56:13 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 06/69] accel: Introduce AccelOpsClass::cpu_target_realize() hook
Date: Thu,  3 Jul 2025 12:54:32 +0200
Message-ID: <20250703105540.67664-7-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Allow accelerators to set vCPU properties before its realization.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/accel-ops.h | 1 +
 accel/accel-common.c       | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 44b37592d02..a863fe59388 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -35,6 +35,7 @@ struct AccelOpsClass {
     void (*ops_init)(AccelClass *ac);
 
     bool (*cpus_are_resettable)(void);
+    bool (*cpu_target_realize)(CPUState *cpu, Error **errp);
     void (*cpu_reset_hold)(CPUState *cpu);
 
     void (*create_vcpu_thread)(CPUState *cpu); /* MANDATORY NON-NULL */
diff --git a/accel/accel-common.c b/accel/accel-common.c
index 56d88940f92..55d21b63a48 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -105,6 +105,9 @@ bool accel_cpu_common_realize(CPUState *cpu, Error **errp)
     if (acc->cpu_common_realize && !acc->cpu_common_realize(cpu, errp)) {
         return false;
     }
+    if (acc->ops->cpu_target_realize && !acc->ops->cpu_target_realize(cpu, errp)) {
+        return false;
+    }
 
     return true;
 }
-- 
2.49.0


