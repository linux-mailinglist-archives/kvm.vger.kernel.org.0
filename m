Return-Path: <kvm+bounces-20724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EEEE91CCCA
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 14:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8FA2282F81
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 12:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1635A7BAE7;
	Sat, 29 Jun 2024 12:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="pQkvQ//N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0312B9BE
	for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 12:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719665459; cv=none; b=SZhcVw4sWxPwWO59xZpSrdbibIDYd6eSzbCrMr8rqeF2rb729JfzKyvonWcne3Z01IQCejDJFPB9aVDIbsI8TX+IIptU7RKQZqVgraQTSWf2zLTQamzv03yNmjHefhhcguXP71f4om3nhZJLZCjAKj+6OoVbMaJue3uKCCS25bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719665459; c=relaxed/simple;
	bh=0JftJwynNXoE7cxj1nzGwhaqltsjHy8QApYB9XdHZSQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=L/6MAO8SGHUurqEAhDxTY0HqBmrllgFGCCNfy8DCSoEKX8F/16s499JSz60giz48Pk1l2o0xHI5WPPIPdOskCv139EPS1p1RRClqSPvTK1dY0+OvmMh0w34GzSAd3bjPHMMPN+MhzfMSnRa18WBFdL3x4wu2tELAcjphBCTlQxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=pQkvQ//N; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1f480624d0fso9680095ad.1
        for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 05:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1719665457; x=1720270257; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NEVh6tc/8MCebyDPaGT8PrbTdB4/CVWgELlCvYthHz8=;
        b=pQkvQ//NBfKN/Op1CDBndvm+RQ6CnC+tNbU5+BkBc72cDbCJllhIaPJ115CLsbkvoz
         lg8V3u/rTE3lrfG+Z/qRH8klbqn8sKp4aVxc/9Ns3dKlJP9DHF08j0dEW2a1YJ4kPImZ
         kFYtC290ELt6VKIOSaz7U+z0RVyPtR1hgaionsM9nsW+QHQFUg0nDOxnc7y82LpVthwv
         +zBpD9v0q8Cp1zIk9IfiVtZkT6w0VSmONEA5xWm94iFNgVRc8hbMRrfabwLDLPQDfDTf
         qTPj2joX0/emXnPqFchUL1OjRQdVwrR1FgIF+q+3OPzWqvTEzKqsG1EEeAROAUrJWgas
         DCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719665457; x=1720270257;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NEVh6tc/8MCebyDPaGT8PrbTdB4/CVWgELlCvYthHz8=;
        b=YcZPt/wkz79eqz/oZdaGC1fHz3wzhpw80qRNRiZhiei/Unfsf39Sd5am4yxp8ggHdp
         b+Ep1oG71Ai1GL74fSXQKlB36M97bd+AUVWzqvJWO9ytcV5vlfH/UdXGkh16Jko+3W8w
         LsHn8Nzs1HPCrHYmdDhk6EFEBhfqWfeZpMxc01ahshAJXsh0ULOXrv59l4REYI4xdcaP
         OYipE66JuYJU5NcqukrNohHwLVWyWf2pYMKIZZ4TwkZ+3j3vRx/fLmplMdUM1Vy9RDAj
         hymNDg/gcU9R/pn3z/zaiL37vEMxJ7hqnNReApXpFYNFv8fyooUaEzWyMbLBfYafof4V
         Q7tw==
X-Forwarded-Encrypted: i=1; AJvYcCXJg+eFsZBwN9KWfSfgr1MoV94Xyk7nWLeGImOfviq9wPaBTn9IHSEgRoC1aCF1wMKFBt5+fJ5fuehuV9c2n4rATRNi
X-Gm-Message-State: AOJu0YxBsiImGhqX/pjkUFuXxlc+rEzg3m7eu1qVHnzdRYQL2EdqsZBa
	XBb8QhrZAJsVxPsl8U41MSZZ7U4Rf9MukdcwBLgZbmnvSyihp27a3Q/CqoqA8Xc=
X-Google-Smtp-Source: AGHT+IHQCZeDATDIOxBT4heocgBU3MrJ8hkbe6u7b9bRsRm1CsujJG4vYA8jGjTcTXl88JuldNLyXg==
X-Received: by 2002:a17:903:1104:b0:1f7:3fd5:9267 with SMTP id d9443c01a7336-1fadbc7503fmr5271805ad.19.1719665456855;
        Sat, 29 Jun 2024 05:50:56 -0700 (PDT)
Received: from localhost ([157.82.204.135])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-1fac1599c23sm31376085ad.280.2024.06.29.05.50.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Jun 2024 05:50:56 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH 0/3] target/arm/kvm: Report PMU unavailability
Date: Sat, 29 Jun 2024 21:50:31 +0900
Message-Id: <20240629-pmu-v1-0-7269123b88a4@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABcDgGYC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDMyNL3YLcUt3EFNM0M/NUo2TTFAMloMqCotS0zAqwKdGxtbUA5VjPjFU
 AAAA=
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
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
Akihiko Odaki (3):
      tests/arm-cpu-features: Do not assume PMU availability
      target/arm: Always add pmu property
      target/arm/kvm: Report PMU unavailability

 target/arm/cpu.c               |  3 ++-
 target/arm/kvm.c               |  2 +-
 tests/qtest/arm-cpu-features.c | 13 ++++++++-----
 3 files changed, 11 insertions(+), 7 deletions(-)
---
base-commit: 046a64b9801343e2e89eef10c7a48eec8d8c0d4f
change-id: 20240629-pmu-ad5f67e2c5d0

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


