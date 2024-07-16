Return-Path: <kvm+bounces-21704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7FDD9326DF
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 14:50:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12017B2181B
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 12:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A2919AA6D;
	Tue, 16 Jul 2024 12:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="F0uFkqUs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E041E498
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 12:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721134246; cv=none; b=sdHm1U7OILURBC8OPjHbeWie5Fc5o4MXtt4fXgKhNTLYxlupKrOPNvb8Z9cKlmogWhTQ1wfJREfTyk3T7UQOUwEGWCTnv7iYjhwh9NBIvNBQsCSfD3Gh0BHxP2kWGD1DuO5JvbYwJwhuZsQMvVg4Gqg4TUno2D2+YodYRbRoFIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721134246; c=relaxed/simple;
	bh=I9gJs05p1pI+zh4K6RpfFS6Mh1ThAI25z7g8exUW+f0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=g4s6LdC0k3tqju/soavSJWS1MfLXWwtWjoSPJJhYTX1JyJIMR95qh0KfqNdZH3CtPdbZfYHETj+fVxYAyykpsFwHB7jC3B9TOCR/VEUeTBDw1RCWbx/XGQPUz7Y8/tYtXyH/++RyQ6bjskIIZ/H9ClA4iv56UHaiWY7w8h9rATw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=F0uFkqUs; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fb3cf78fa6so33592625ad.1
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 05:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721134244; x=1721739044; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iU26PLhClMFoNq13xT+fqq7kADjl0F6rGajgxxU34LY=;
        b=F0uFkqUseLGWXKzvUEBo0PGgR9nIPi8C1BYUmJ6hvFzQCd2GoZn5a1iDbAqL60xRS7
         ZpCTmVOuGzvZXc/4o5HSTm52fFSpDZtZLo3yNF36krbNP0jtRedKu5er6Sk4C5klD70e
         bRZjHt6GLjNrZxs8YgOBwTJNLxHI0lBb6vp8HwBCzsN99Enbgf8haLhHFUArMIsy5dPv
         77sjBRQMB8K3hxwtyG6Jv8vCwHKzUC+YFMFoOseo65oyiJqkEdWIjpdJK7Q3mwklTMfs
         YoZT2Td7eZ8taDU4dOPQublPHUE5kidJlg3vS3mYavbmlZtDof15ziVDxC86U8CRlRXY
         cUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721134244; x=1721739044;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iU26PLhClMFoNq13xT+fqq7kADjl0F6rGajgxxU34LY=;
        b=KurZ37pAfvwb1esdxqC0eU4da+FRzJQrhG2VrM02mhGWgGCRj5mcMQUJa1PjCXE6f4
         BAWQa2H7SbTIBxwWKwI8dKnwUvzF0/WQeQqF52E/mz/SbfVjx8hVlEbnEHAh9SaA/9p7
         2IESNqTPvD8KoPLdCVboenQxPcHurzBR1u4+iZqYTBPmTg7/33XGGQBNK1GerNYQGV9x
         K4hwrxy4p5UQzeaKIUoUF02tH/ma3WkOQ5sQuPTaTSt9eN+2zS0XTlkTS/Wnekq83FoI
         SezL/MnjXYL2m/73XItW55RKevEckKfNnBkc+HAp7YzK7wI8yfwxuwwSGvBytGvgfxhc
         9xug==
X-Forwarded-Encrypted: i=1; AJvYcCUGExqvfUl3e91VQdQUPeVs2lr0JCM1j62p2jSsKmFTmoIIZ0DzACHneDoycZoWeeEoI0kpHtahhZgi3/HHGT+2Y8p2
X-Gm-Message-State: AOJu0Ywk+9MKCdnJcsS3ySmW9TcjpdiUrn4+7cZtDwpOosxNfiMiY9uY
	iJheGZFbWC8xoC5TfubCuWz9zk4dY1rNSx0D9WNsIu9rM5NrVuIPisE/cPDR+uM=
X-Google-Smtp-Source: AGHT+IFYDeKU2qHqSrMcO6aGbc9P8+9s/hK80dXb8ooXK6zyt38hdq2bIecIPsHq8yK58lcuRN0l7A==
X-Received: by 2002:a17:902:d4c6:b0:1fb:4fa4:d24 with SMTP id d9443c01a7336-1fc3d9c480amr13270045ad.50.1721134244195;
        Tue, 16 Jul 2024 05:50:44 -0700 (PDT)
Received: from localhost ([157.82.202.230])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-1fc0eea3cfbsm56005525ad.115.2024.07.16.05.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 05:50:43 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v3 0/5] target/arm/kvm: Report PMU unavailability
Date: Tue, 16 Jul 2024 21:50:29 +0900
Message-Id: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJVslmYC/1WMyw6DIBBFf8WwLg0MitpV/6PpAmGss/ARaInG+
 O9Fu2hcnpt7zsoCesLAbtnKPEYKNA4J1CVjtjPDCzm5xAwE5EJDzaf+w40rWl0i2MIJlp6Tx5b
 mo/J4Ju4ovEe/HNEo9/XsR8kFL0HXElRTVSa/O7MMNF/t2LM9EOEvlVL/JEhSq1Bh3oBTrjhJ2
 7Z9Aei58uDMAAAA
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>, 
 =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
X-Mailer: b4 0.14-dev-fd6e3

target/arm/kvm.c checked PMU availability but claimed PMU is
available even if it is not. In fact, Asahi Linux supports KVM but lacks
PMU support. Only advertise PMU availability only when it is really
available.

Fixes: dc40d45ebd8e ("target/arm/kvm: Move kvm_arm_get_host_cpu_features and unexport")

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
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
Akihiko Odaki (5):
      tests/arm-cpu-features: Do not assume PMU availability
      target/arm/kvm: Fix PMU feature bit early
      target/arm: Always add pmu property for Armv8
      hvf: arm: Do not advance PC when raising an exception
      hvf: arm: Properly disable PMU

 target/arm/cpu.c               |   3 +-
 target/arm/hvf/hvf.c           | 318 +++++++++++++++++++++--------------------
 target/arm/kvm.c               |   7 +-
 tests/qtest/arm-cpu-features.c |  13 +-
 4 files changed, 175 insertions(+), 166 deletions(-)
---
base-commit: f2cb4026fccfe073f84a4b440e41d3ed0c3134f6
change-id: 20240629-pmu-ad5f67e2c5d0

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


