Return-Path: <kvm+bounces-22005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5639F93806A
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 11:31:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAC291F22268
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 09:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30EC27EEE7;
	Sat, 20 Jul 2024 09:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="TIawvdCH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3851B86FD
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 09:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721467873; cv=none; b=Vy3dnl13WzNwxWftjF+9BlbCXvbJwpoUK0i0ZE+qJTbfIvXyjG53rOVTzHVd6KYkF9ww9ndwEJpKn0ZTZ3L+/uAr15fjuaLJUuSXWv7UmrhWfQiOIbsRC5yYTG60qN06ENR9npxdDW0n6ACsl3atPGE7d/7iTOZJ0YPovbkBSis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721467873; c=relaxed/simple;
	bh=cU00zTjQRw1vPrM2xogKNqTkMJa7iuaVaq5MBt0U7sU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=aJW46AnqWU66hC13rFimH4Hl1GewT09b9bs4mfWeH4pvDW1DKCT/Uq/QbkKk4jBhM9VZqq4L7yIdJV74+XLcgONZLwzviuHs3Hf+z/oTu6e2Q6ZTxDMwKffJioNC0curyU8nKLpex0ckPQ4Dd3AB9pcfnUnDaKGDKj9r9jgAe2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=TIawvdCH; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7f99d50c1a6so118809739f.0
        for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 02:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721467871; x=1722072671; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LDU2Zt8gZBQKmgVee2JKdgi66cDuvrO7hSjjib8H/lk=;
        b=TIawvdCHWH6PVP3cFn6YY9jBzgSZJqS5oBTBMuXXudKxDkXE4VdVIPnjrX/Rl6gYy8
         KqH/VgVkxI4EQDmkVwjdmTmqN5hR4zJT/hS9n7PFVPaGSuke7UT7isQoNwv1T2kp7tcH
         5mNV3hf21TRsuIeL9m936bhcsuLtpsuN0DhUHFTmNCHzWv7e0K2SiymB8t/suVOh0X2t
         5OkMA3O4xRweO3zNdw324TZFfCtqve/J6otL6HLDFksT46v1fXwTc+/KSVEbRoKMVair
         uXDa+day8JfLUqUj1lX5rVkms9Pd13IVtTOvSL745g4JbSl2tzXP4ERAk06xQaBom1UP
         5yew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721467871; x=1722072671;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LDU2Zt8gZBQKmgVee2JKdgi66cDuvrO7hSjjib8H/lk=;
        b=BwtexKCXSc7Vm4vIuVZX93Z2YOf6XX+y04DuAYASk0cK+Z1DcPFHXQlxyyBgf9ZJ+R
         cRT6Kz4CFdir7tY5mFgE3liJQrbdfhIv+/rbKtkhAN+p0AEUNR9UxK/7t2sw+X2C65Yv
         V6zdbKUIDwuSpq3WxzuNu/q5vrmmZYCSUh1Dy4Z23sRGVhIdNx/jfQJFQFBbR9JZ9Cf7
         QFh+/8B2QtV55+8OW0wx7BuEdrFRzw7frF6poBu1iqmiEjJiMrF6mdCuuWO/b83t0913
         FnvY1l3himR1iqPu28KTHxPJZbEgFlp5ldil2V0vcjGP/QZ1TkEp6s+d7F0etFV2ckFp
         qdrQ==
X-Forwarded-Encrypted: i=1; AJvYcCX30zOYrEG9v5QLA3MlxZ3i+Do3EEil54czCzFOUOhRYeYM4g3RYvaQegs2Lb3492U9hSDzJQbFUAYsKxPj2kmQcR7v
X-Gm-Message-State: AOJu0YwN3krMKG5aeNQ9/az+AVkgtomrjkPRJp7mUQav4PoKCt+j+HHZ
	JSPnbfwSPsOBZ1UlGc6qrVsHtGmLgcTMTj5jhC9ionwCQmNg4Uy6OR9kYmsjRGQ=
X-Google-Smtp-Source: AGHT+IHVPm8t/2gzpEDM1KgANQdKw0h2OLMQUsUVee8JWg0S2UQKWLWHEfSx+ctre7NQWEHi+VEghg==
X-Received: by 2002:a05:6e02:180e:b0:397:584d:9b73 with SMTP id e9e14a558f8ab-398e47ef554mr27226765ab.7.1721467870772;
        Sat, 20 Jul 2024 02:31:10 -0700 (PDT)
Received: from localhost ([157.82.204.122])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-70d0fa125acsm538989b3a.190.2024.07.20.02.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jul 2024 02:31:10 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v4 0/6] target/arm/kvm: Report PMU unavailability
Date: Sat, 20 Jul 2024 18:30:48 +0900
Message-Id: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMiDm2YC/23MSw6DIBSF4a0YxqWBizzsqPtoOkDAysBHoCUa4
 96LdtCYdnhu7vcvKLrgXUSXYkHBJR/90OdRngpkWt0/HPY2bwQESiKgwmP3wtryRkgHhluC8uc
 YXOOnvXK75936+BzCvEcT3a5HnygmWIKoKLBaKV1erZ57P53N0KEtkOCLJBUfBBk1zDFX1mCZ5
 T+I/UEsI2WkoYorDSAPaF3XNzZ7TOABAQAA
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

target/arm/kvm.c checked PMU availability but claimed PMU is
available even if it is not. In fact, Asahi Linux supports KVM but lacks
PMU support. Only advertise PMU availability only when it is really
available.

Fixes: dc40d45ebd8e ("target/arm/kvm: Move kvm_arm_get_host_cpu_features and unexport")

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
Changes in v4:
- Split patch "target/arm/kvm: Fix PMU feature bit early" into
  "target/arm/kvm: Set PMU for host only when available" and
  "target/arm/kvm: Do not silently remove PMU".
- Changed to define PMU also for Armv7.
- Changed not to define PMU for M.
- Extracted patch "hvf: arm: Raise an exception for sysreg by default"
  from "hvf: arm: Properly disable PMU".
- Rebased.
- Link to v3: https://lore.kernel.org/r/20240716-pmu-v3-0-8c7c1858a227@daynix.com

Changes in v3:
- Dropped patch "target/arm: Do not allow setting 'pmu' for hvf".
- Dropped patch "target/arm: Allow setting 'pmu' only for host and max".
- Dropped patch "target/arm/kvm: Report PMU unavailability".
- Added patch "target/arm/kvm: Fix PMU feature bit early".
- Added patch "hvf: arm: Do not advance PC when raising an exception".
- Added patch "hvf: arm: Properly disable PMU".
- Changed to check for Armv8 before adding PMU property.
- Link to v2: https://lore.kernel.org/r/20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com

Changes in v2:
- Restricted writes to 'pmu' to host and max.
- Prohibited writes to 'pmu' for hvf.
- Link to v1: https://lore.kernel.org/r/20240629-pmu-v1-0-7269123b88a4@daynix.com

---
Akihiko Odaki (6):
      target/arm/kvm: Set PMU for host only when available
      target/arm/kvm: Do not silently remove PMU
      target/arm: Always add pmu property for Armv7-A/R+
      hvf: arm: Raise an exception for sysreg by default
      hvf: arm: Properly disable PMU
      hvf: arm: Do not advance PC when raising an exception

 target/arm/cpu.c     |   5 +-
 target/arm/hvf/hvf.c | 302 ++++++++++++++++++++++++++-------------------------
 target/arm/kvm.c     |   7 +-
 3 files changed, 159 insertions(+), 155 deletions(-)
---
base-commit: a87a7c449e532130d4fa8faa391ff7e1f04ed660
change-id: 20240629-pmu-ad5f67e2c5d0

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


