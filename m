Return-Path: <kvm+bounces-50082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F6BFAE1B97
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:10:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E90F1BC59FA
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CA1295513;
	Fri, 20 Jun 2025 13:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j1K1zlOW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A45228D8F3
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424920; cv=none; b=QeRi0+p8dK8lUVIem1+XuDV0sCEt49P64ZKHiUhT5uW3q/E0pLru/rRc4jcx7NaNQNKA8+s2LWZvABxtudLKLP9rkNwB54aw4CABqf7lu3C7aDHHSXFVhH7Wx4Av6nulHJnOFK0e1TAjtOwQZJYZZPTr07bJ1FYN6WAQ4Z7GjE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424920; c=relaxed/simple;
	bh=aDy22dOEdB7EFHqB7OoQ+yrfI8SpOEtk9T+tr457Vic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f389tV+LDqYU86Y4jl9P2l42YzA+yqMtKtiLguHrIbHzx3YB4sDIKjcF3jP/9z8iVRYws1V0Dr3FA3rLhHUa3n1qN7Ote8V4HnHarLodP/ml3+spF3PKYD9vOyXjXSYtbCnbLzLX7T+/o/0M4Sg0shMy/2iTeOD+2V5OlS1AivM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=j1K1zlOW; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-450ce671a08so11780915e9.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424916; x=1751029716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fteu42QoSrS1hfDvjcW70gOANYEhePCaBpCVcvmvL2M=;
        b=j1K1zlOW0Sm18cnPfWvvtwT/Tl0RBMfkuUVezc3+V45AaLxblU5ZfhSe2b/0hiQm1m
         2xS4WNLYfhWazJRZOkNQI7YZeK22NtIvPubGZlbGbhkceVIBcrRBbbhm6hGtD2QEP8i9
         MPclqzMukk1z1oH9B4Dnf5+T3kxktP4RtfZJlVwG+D2Jz/bd4YM5Ndw3O4Z0ti92FIqC
         Qx0t991EQwB136P4P6gQBVpewH8pLSZPdD6mt+HgnAj6iDi3Dx77nnmqKOD607YFae1e
         zDddzBgV/rYfvNehaCKNXdncYt6Xz5HFcVgG5plxO0VfMkUAwGTLE9urp+pLU8d4rL3U
         2xVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424916; x=1751029716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fteu42QoSrS1hfDvjcW70gOANYEhePCaBpCVcvmvL2M=;
        b=LbqtfW3AunlvVqSnt0mbfjDt70Ee1f9AG1eXSFh9CGkARIAt2NosA1ngrfMrAtptm0
         CWvZxaaMcv/+b/solxRY/UawKSL+kdnZhv2y9dsLBP/SyQndwywwfU/Eda2Opgl8uZgd
         F0tsdgxetI3wyt9jRB7kdhI/klHhftfT2kagrVplg1vLdzY/BWwwS43YkHTkXcJ4U9ES
         BxmixHJyG+NgXQhHYY55KyDsfefjc+fhldBOTBc38zTKIi7N7B4Y3dGl2nZ+3kYJPY9Z
         MzEPoWwkIIfRtTHURFi/l05cuwymcMEQwRwLf3Kb68T3HTWAZU+cgenWUsFmRb9pie46
         cD7g==
X-Forwarded-Encrypted: i=1; AJvYcCW/ekdb2+uWTgWKhMcpzDA2ZriUHdPv322jyJQIP2oh7dHVNbxpMozW+l3RASqnPZZdKBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzklt3u+Gb7OwDItxj/gSWlA8799EGcpueO+4dNWLOPjRi4GB5G
	4HribtPXFOJ3ZGYPwA9XmwoPm+L8Yet34+PK6jn1mYeU51K7VWE08j0foHGxuSyL3xU=
X-Gm-Gg: ASbGnctgar0IuWs7mWUPLJkag9jxi02duGtLlY5Sz55WcyJWcMbMsyQrpbKBHsxfxRd
	0ciJo0tAW2dF1TM10hZZBXXdw5nLtmLnTqwOcfiH8KmTW4qscQ8lOtRQoOXsLxUH+x/lj1l49WB
	fddwK7KzIAbaO34G8BF5RiBiRjJJc3oa61Mnzx0S1K8O8RqhVLWgpnkvFEyWzwDtJ3SZabyWHw+
	VNa4rFDV/Uo18xguqt/l7SM9oRtHCWVBNBI8566fThxtqGAg5hTUmm1mbE7ZSaJmK0CCjJwsx+n
	KvHU46PEvQAAUZMy9gELRPi0sfN0lf6Nukjf9Owo9V62KK659VGn+6MJ/WIQYSmd/fW0cCcTzLf
	iHWQ269ClX5nSH6L8zH7Sdf8r8jIvTCu42CY7
X-Google-Smtp-Source: AGHT+IF+npPw/Fpnff5lnMY4tzVA5zu1lieKqW+klOIEesBk3BkWi62GERyChD7PyAo9RXNQgBmPoQ==
X-Received: by 2002:a05:600c:8b70:b0:445:1984:247d with SMTP id 5b1f17b1804b1-453653aa3afmr23498795e9.7.1750424916439;
        Fri, 20 Jun 2025 06:08:36 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d11909f4sm2016944f8f.88.2025.06.20.06.08.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:08:36 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 15/26] accel: Introduce AccelOpsClass::cpu_target_realize() hook
Date: Fri, 20 Jun 2025 15:06:58 +0200
Message-ID: <20250620130709.31073-16-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
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


