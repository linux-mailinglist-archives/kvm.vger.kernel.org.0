Return-Path: <kvm+bounces-44921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F134AA4F43
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEB2116A551
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 14:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBD519F487;
	Wed, 30 Apr 2025 14:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K07G1dfe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8038C16DC28
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025133; cv=none; b=EbKqmHGC3wda0X30fcYeFvA00p2kJjKgQofssYjg4U3aY8r7jBLGB+eGEX8z8ACC24pdyNzlXFiNsEFoMIkviP+HRTvpLbr9LY5pcfW+fqtT/WVmCZtFyKHA2B4HoM1xBUJWaKJTw+RXWspfrxkni1MCN/jRKUJCuI/G+PQEpwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025133; c=relaxed/simple;
	bh=EdiN7rb68EFq/+uU6lE7IO7qSOG8+92r2+WGe13NqTg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XAZt4rz2HGsbyVaGGRsfX2F/ixhaGmGxodzO0cX3Ctm/bULTGqguSvpAQkT8AeXzLNxu8MKYply1fCZ0169XJm8dpZicRNEA0MdtmHyvZdUHavVvs6OZbTSUp4c+ED2ccvoXunpPqU/eDuBnn25H0rReNhcPh9X/ORCs/wP5xFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=K07G1dfe; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-225df540edcso12106255ad.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746025131; x=1746629931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B2+JbLMiiUYaemZWDCUtTt3O9Oj1MSI0kp/U5wwWhSE=;
        b=K07G1dfeHFkxD+wmMQUDzu3v9zmbriktdRK3osrMfXtSnUrBnAE24xHu5o8WaTRtdl
         HcEGPpsV/zvYbsmzB+4fA60FSXtJnadXSdwTy34HlrH1nbpuW1v0L/1ZRib9bWHROgia
         KIVGeOqmDNpJSs0KafM5bqwvWs1nU5OozU3Z2vm6Y7KBE90/vVw6AmpVbwFH7aHpupEg
         pYDvzXx2TfDlUK7hF6og4eTraQLASxk/ttmKgbD3Q5cIF4KAVp2Oam+AoTqE42ggjC6+
         EB26POhJOifOcl9HmHYgFhT67+AY0Jo1Rsqvfce/HAuZnH+RPHZf5jqmoLvB1/AyjsPx
         gq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746025131; x=1746629931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B2+JbLMiiUYaemZWDCUtTt3O9Oj1MSI0kp/U5wwWhSE=;
        b=LTCgfZZre0ThGFdm6w6Y5VioZNunnMMMTUE0L7ZKARGdIasMIYBSpnqPdPFRkUOvOS
         N0g0BPV3QJo+09c9woWkqsbX8luFXqQYmP9ltHkmvUoNYU2fXnNOMLSw7FIkcCYvQFYj
         v6Fz+6vK2ehJxSoojRQGx5zlH4WSswZlV23mjOH2wcfy5tBRxTwdtVEalYlUNp26bird
         Fh39aY992YyxH2rb/qht3Xfld+WoxEWqtI8CJWgF1XK0OvQ2x+ogxAbdAUlJP11ayvUK
         CxY0ccNIyjxpYgtWF9GWwjudAlU0KOdliPmlk5yHBkX29AJGPL0sJFQRs8J6WKxkCSqG
         5MBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUERyB2Fqy/KVnsYjOWt1Ql3LqoaiEfd3Ndxtf3UvKi9HoHDWr1McljO2g7TRqSQ6vBC1E=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywrm1ID3tmJXz1GNsqdsFV+YSxYVjp/MBGeoKCgKXEx2xFnDoDV
	ZWdwp5j9DQae2sq6l3fj/FSf0sngi09vPlHT5p8aHGU+2GHxrnS8zjPZiFVw/tt+XQuaiKVD/cr
	t
X-Gm-Gg: ASbGncuJg6I+USOrG3kfi5hLtqPOO0rt8Ti3CcB3/4CnxEfFarE/2G8UH8FCrAHvv1b
	PTSW5fsd7tap/aR4QaBbujuX3fJ3v7gtgMjPG1pNV9wr+IqEiaD9tfbfDemcY/qoBlKxCqthgjl
	CsuA8ZNdfmuzBLzCgk+yiUi3kBEGwL7THRFfqNjQlH98tseKbLnX1uRjLS2kyY9c5EqDGOFIaID
	4Ngp1/9nb6DrsnpmzdeOkOFCKVoLSjEk5pKTaoLT3lnu87SH/yH+ZSmhGC7J9YuLCJ/9SXkzdkt
	uyqCLr13v/3gk/AmK3vCFOWJOnFzL8VteiLJHt5C
X-Google-Smtp-Source: AGHT+IGVJzpOY1sOKyELald78Uh/X55cVaOwtQ3xJcxUF7oIJGgGU4BQTL1AHVt8pNiGxX22IiuDXQ==
X-Received: by 2002:a17:903:2ecb:b0:215:9eac:1857 with SMTP id d9443c01a7336-22df4747f3emr44018045ad.5.1746025130724;
        Wed, 30 Apr 2025 07:58:50 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5bd78sm1705652a91.42.2025.04.30.07.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:58:50 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	richard.henderson@linaro.org,
	anjo@rev.ng,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 00/12] single-binary: compile target/arm twice
Date: Wed, 30 Apr 2025 07:58:25 -0700
Message-ID: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

More work toward single-binary.
This series convert target/arm/cpu.c.

Built on {linux, windows, macos} x {x86_64, aarch64}
Fully tested on linux-x86_64

v2
--

- Remove duplication of kvm struct and constant (Alex)
- Use target_big_endian() (Anton)

Philippe Mathieu-Daudé (1):
  target/arm: Replace target_ulong -> uint64_t for HWBreakpoint

Pierrick Bouvier (11):
  include/system/hvf: missing vaddr include
  meson: add common libs for target and target_system
  target/arm: move kvm stubs and remove CONFIG_KVM from kvm_arm.h
  target/arm/kvm-stub: add kvm_arm_reset_vcpu stub
  target/arm/cpu: move arm_cpu_kvm_set_irq to kvm.c
  accel/hvf: add hvf_enabled() for common code
  target/arm/cpu: remove TARGET_BIG_ENDIAN dependency
  target/arm/cpu: remove TARGET_AARCH64 around aarch64_cpu_dump_state
    common
  target/arm/cpu: remove TARGET_AARCH64 in arm_cpu_finalize_features
  target/arm/cpu: compile file twice (user, system) only
  target/arm/cpu32-stubs.c: compile file twice (user, system)

 meson.build              | 78 +++++++++++++++++++++++++++--------
 include/system/hvf.h     | 15 ++++---
 target/arm/internals.h   |  6 +--
 target/arm/kvm_arm.h     | 83 +-------------------------------------
 accel/hvf/hvf-stub.c     |  3 ++
 target/arm/cpu.c         | 47 +---------------------
 target/arm/cpu32-stubs.c | 24 +++++++++++
 target/arm/hyp_gdbstub.c |  6 +--
 target/arm/kvm-stub.c    | 87 ++++++++++++++++++++++++++++++++++++++++
 target/arm/kvm.c         | 29 ++++++++++++++
 accel/hvf/meson.build    |  1 +
 target/arm/meson.build   | 15 +++++--
 12 files changed, 237 insertions(+), 157 deletions(-)
 create mode 100644 accel/hvf/hvf-stub.c
 create mode 100644 target/arm/cpu32-stubs.c

-- 
2.47.2


