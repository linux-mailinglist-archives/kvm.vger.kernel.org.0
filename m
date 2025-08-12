Return-Path: <kvm+bounces-54529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D83C3B22F0A
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:28:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC7BA168F51
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 17:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF4E92FD1D7;
	Tue, 12 Aug 2025 17:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oOHUWXms"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A4F21D596
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 17:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755019709; cv=none; b=rFzjelH9aDPgmYy+BUDIpql2aGRd2UYQA4aoXLawkvQULBsHhcwA9Ugbpwbz4UrAHCcyrVCQK9ZPL4VKrEcITRkUE+a8NUVJnXR0YYBW9OVeKLmubSuZ6kcW3wtJq1xbB12tcz+67ed/td3pgRRl13cQy8GH+dyUw5YQrq4384I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755019709; c=relaxed/simple;
	bh=OcLvyg+3RSNtah5xg/l/OBdNBgNKb+5/Qs0rP4PqlGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lCLBKbIfNGZEMLwFOKYJ1TF6NoEKaOaWP7jW7/+f6lALjC00koeUvBCdk5woe2j4jFQYvm/3zujMH8/D73Dmz/4JxGCzovyb1JkLdZDfdUiKBX4U/jP8LeLwzDMxSzSZmuyjr8MneG112fqZebVjEjciN30+tscPsfaOF5rnR0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oOHUWXms; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-458aee6e86aso38349265e9.3
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 10:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755019705; x=1755624505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XFVNnbRTiRKENsM+2C3XPaOJ9QN/hot7cxFumXFNznY=;
        b=oOHUWXms7Elfptx4jMH8/feJi7Pa6ZiTOiwOqvq0igrH1Zz9LeFwCeGtewLVq9ypT2
         eV/+6oGBCH/SCVU+Tn9zxd9Q0tIsQVk5aV4w9p46DNPdJUwRz7gOUNZCa4nU5aVHOZHg
         lpsHReOkRqKQBpyQOHOACDp0l56cbvGShUjX7qKW0PdHnpqmVxuYA2CvvB4ax863fSu8
         2xp1STXlZpjEXDaXphKNhuU4zbAtXlO1kbhhCLIt15ZcAVyGDeaSATULkstYRVWrbZEf
         L1X7HPPy58k4r1x3T7ySKwIZUuGxnALqxxqW3MPVmN4uG/3Zx0yQLJLn+VXXk9nrMTN5
         lA4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755019705; x=1755624505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XFVNnbRTiRKENsM+2C3XPaOJ9QN/hot7cxFumXFNznY=;
        b=cQIex9jms32DlNdcxpKo905ikxBVArQUe3rqEcJyYPigIAXnOr/6VhdCvVtaaMNs1I
         SS0gcgmh7r6QgwK/pBHhrS7O0A8+aCEoLSKULHcRf+Rs69Ja8DaM9G2zF9+g0SRM7MXC
         lssjwpbXQ12XpytdgSDsDsEG3hThUuUk3u3mWpYyGoS/6uR8XufAPnND41gDyT8267hp
         MPpNeT78t455bjn4/U1xdBrEuZquW9je/BxcBsH+19cgFC/4h4Qf9vUT4vh48a5wCP2c
         m9Uyok4KOJ9KV9edx8xrAl/fInglxIxB+JnEJqE17VjVSnNVYTRtY7a44/gc3SQWMISM
         xaDw==
X-Forwarded-Encrypted: i=1; AJvYcCW6x8akSNWbtmXGGd8XBqqX1PKInblTfDwVVwZGYpusTcXObwX3j4ZA0mqSXVc9vkCV1yA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6JowdjbHxbzoJolFX0sLs9SfxBGJN9xDNJhUlgM9CPxlyeI0y
	gbyNphSGJR8Kpw9ods+4WgUsiCxe/NpA/QHCqSRP8QuVIRjA6jhLoaJ8CUl7tFipLxY=
X-Gm-Gg: ASbGncu/H2pBbCPJdq8dnthzdd61FR9dOkfmUfUsPu6JSyUC1axYPfNuWltyVHeqcvN
	L6lwAlxl3IsfstZhhKDI5GMj667AD6/UcLMZce6E0w3F+NCmRnNJnx5pGtfR6LIkdfmwruHWLjx
	MlIbG8Fe6qFc4QBwbuzcS3zwAyiLKz0gPOLzA3IGqinlV5Pd+J7eX6SsauDFntxWIAYXBzVIPwV
	fPrHyJE6oT7UIrNL+d/teiX2BlM5F7wNtGyI7Nl+pJl1E+TfdbVKHPTSEUJ0anqHLrGW1Vq2PEI
	SVneF4fCDZ3wkJaHzveardzDWFjg0UCOmPhq/f/crRu8Lm89nPqJbzUvWhFV4kiF6o39EwDMmo3
	D8xSUlVbs/pWpXMIBj1h2vpCTs2U2COQD0VAeU5EdNKjMfFKYpSELIzP3/MaQutkeE3WH38Fv
X-Google-Smtp-Source: AGHT+IHI5EUxCSAWZav2b9OslDPFbrZnQR5htR3M/42qqK2THZHZuDHrsCp7cbtbdmGtB2r63VUeXg==
X-Received: by 2002:a05:600c:310d:b0:456:475b:7af6 with SMTP id 5b1f17b1804b1-45a16596597mr231935e9.7.1755019705430;
        Tue, 12 Aug 2025 10:28:25 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e586eef8sm301292465e9.21.2025.08.12.10.28.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Aug 2025 10:28:24 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Claudio Fontana <cfontana@suse.de>,
	Cameron Esfahani <dirty@apple.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Alexander Graf <agraf@csgraf.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	qemu-arm@nongnu.org,
	Mads Ynddal <mads@ynddal.dk>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Miguel Luis <miguel.luis@oracle.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [RFC PATCH v2 00/10] target/arm: Introduce host_cpu_feature_supported() API
Date: Tue, 12 Aug 2025 19:28:12 +0200
Message-ID: <20250812172823.86329-1-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Since v1:
- Addressed Richard's review comments removing 'can_emulate' arg

Hi,

Mohamed and myself are working on adding nested virtualization
support to HVF Aarch64. Mohamed approach leverages the latest
hardware features of the Apple M3+ Silicon chips [1], while mine
falls back to emulation [2] when features are not available, as
it happens with the M1 and M2 chipsets.

We want to support both methods long term, as they solve different
use cases. Therefore I'm looking for a common API for methods
added in both series.

In this series we propose the host_cpu_feature_supported() method
to check if a feature is supported by the host, allowing fall back
to TCG. KVM uses are converted, and an example -- while not really
usable without other patch applied -- is provided for HVF.

Does this look reasonable enough to pursue in that direction?

Thanks,

Phil.

[1] https://lore.kernel.org/qemu-devel/20250808070137.48716-1-mohamed@unpredictable.fr/
[2] https://lore.kernel.org/qemu-devel/20250620172751.94231-1-philmd@linaro.org/

Mohamed Mediouni (2):
  target/arm: Factor hvf_psci_get_target_el() out
  target/arm/hvf: Sync registers used at EL2

Philippe Mathieu-Daudé (8):
  accel/system: Introduce hwaccel_enabled() helper
  target/arm: Use generic hwaccel_enabled() to check 'host' cpu type
  target/arm: Restrict PMU to system mode
  target/arm: Introduce host_cpu_feature_supported()
  target/arm: Replace kvm_arm_pmu_supported by
    host_cpu_feature_supported
  target/arm: Replace kvm_arm_el2_supported by
    host_cpu_feature_supported
  target/arm/hvf: Consider EL2 acceleration for Silicon M3+ chipsets
  target/arm/hvf: Allow EL2/EL3 emulation on Silicon M1 / M2

 include/system/hw_accel.h | 13 ++++++++
 target/arm/internals.h    |  8 +++++
 target/arm/kvm_arm.h      | 24 --------------
 hw/arm/virt.c             |  8 +----
 target/arm/arm-qmp-cmds.c |  5 +--
 target/arm/cpu.c          | 16 +++++----
 target/arm/cpu64.c        | 11 ++++---
 target/arm/hvf/hvf.c      | 69 +++++++++++++++++++++++++++++++++++++--
 target/arm/kvm-stub.c     | 10 ------
 target/arm/kvm.c          | 33 ++++++++++++++-----
 10 files changed, 133 insertions(+), 64 deletions(-)

-- 
2.49.0


