Return-Path: <kvm+bounces-54418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BCC7B212CA
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 19:06:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 802691907F3F
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E26992C21E2;
	Mon, 11 Aug 2025 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LaT1x2oP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F5A253B42
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754931978; cv=none; b=GWCXPb61LydlEZC6/SOsf7pWsljIJwJX4qZQrwrWCFh9Kn5B2kMyFmAmI+jLsg7JsU4hXIefx8BektJ5fH0zbESSrphh9f7Bj0o37o3qa1r7mmA6/SUory0pH9k9wWbvBuKu7OgL0C9FsFDt4jj6cmSW4p+xNw5Vgg6lk+0c3H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754931978; c=relaxed/simple;
	bh=VoiUlWxDpiwkld77RbFQpFASE4Pk5D3XvIaCfGc9jtM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bu5NdDMjypWljUbfbLYXZOYVjniLGDucGTyYafwFTEQ08ua7zcte5g30kHUxgAovCfUt2SJvtt8Eo9wL6DXr5TiHpxqeiIGnU2T0GWHqfYYx5kdo3kV/rLc2yQezoaIN3R7HnnRiNVQXyQgFjF0PxAqza8Uhv+pKKnDNM48slkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LaT1x2oP; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b7961cf660so3721450f8f.1
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 10:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754931974; x=1755536774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gct7C1Y1ZRB4jTTLIlstS8WuVX5u4p3QrSuPcz6V+Qw=;
        b=LaT1x2oPOCNvuy0Q2Yx7qlRjhuvzMirGqXpfeldIuEvD3SFVK0AyFnWOAeL0OSY6Ow
         ZqetpKFhag/IMyAbgQOYM7vOQYkMvNLeX7i7zaCRjQSfmbEhbWMKJXRrSNwq7i6gIiu4
         oTRbu/9540LAlhtxUhps4MD01gwyNgmod+CJLIwxlNCk6zvaRhKzzVt/neq+WaMHuMgO
         F8ISy4fjqFdA7O3wcGcbfPPLwHsbV5SHTzignPeteT5vTDIo5pNso0+6vpOC7inIJytR
         VULcd+yyi92YjRE095VnZBgBe7iUxobtC1RC/kNq9EKc1XJ1lCeiWUfWCYPOJNw4pSUj
         jMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754931974; x=1755536774;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gct7C1Y1ZRB4jTTLIlstS8WuVX5u4p3QrSuPcz6V+Qw=;
        b=tSJf9yv8NEc/h53P2fqITl3uehxMXPbQ4lSC5/G6YBLoPpAMXGWeChy0EVHCy0Klh3
         NFqNTsJZDwuFOto7eBVeXjYDTTgcgbI1qM+k49FGnwTjMnAfTl8ngAl7m8w/vK/MpfQZ
         Wudmk9jQC5czZ2+k+qTSPcwzQcuPqDl6RK5BGFdFyp3BpGuPxpr2lzDMH0g7HVaI7u8U
         Xp7Sfwceb8FReEfXdwilaHZTrGhPK2JcIlO2IHuDvI1F5jXVMm5wSw3yK1tQI3w9AJpm
         37juZxtwF9aPXcqobPKZYMMtyOPmdocQwCEERrl39+jWbZqIscS2ZvsyroWiHfdAPGve
         HbKA==
X-Forwarded-Encrypted: i=1; AJvYcCVwIhvOiifzl7Ekir9xR6NzMQv2QS1PA+IA1Hnfcl2eRbcD9r+lhwMyuK5RW2I3gQw0g88=@vger.kernel.org
X-Gm-Message-State: AOJu0YyotncbRGnfe5bUiXQtGkF8zpRcj7FXfy/Ehm6dyVplC3iBiLtH
	Wd2LQPNVn2O9ATfu0duZeXO76O+758mYE8CkHXKtb0PI3PuEg9B2SU4+A4x3Buuqni4=
X-Gm-Gg: ASbGnctll3sIg1Oj1J9NehmezT3OPoH93NS9iISZt6R+d/yLUuGPA05xyaQADgEqRiN
	+fdsHn+g15sqFwVx5KIltIgNr44nsCDcSn2YbLuRwEVvv1WurONMGuuM3/UpjVNA/eMLqEbrerZ
	FklR+ttmhv+6EaRBHMwqTVA28x2NrqyuhgJGjc6FA9TfUi3Lk3xJcGIide7bG9gJ0JrDeYI3sqd
	dPmhTEoBkShj/d2JoLgSKM5qFC4ucwh7dYT/Uw4pLkWCxtK0PQxNF+3IG4WNSzo5BBMUo39JUm+
	pCpNayVVMuxzTfupx+3yTx0m8tKlEiKbLLRXKUCEH3oAGLOGUkRZCudN09tB1FCysDnqQYKTYLj
	uLW7Tu95ABEkSBXq4iAwXd4ZD7N18ufWzS7hnsEiAr9+oZKikdhZnZcNyRkzJgwPN/7epX/1V
X-Google-Smtp-Source: AGHT+IFxSRfqcB19VeCggmPRFwXZs8vukwQy0+SZAp+RMLZ5Gi+wPHMHtoSwlNvUFKTkhMS9MhdHQA==
X-Received: by 2002:a05:6000:2013:b0:3b7:8473:312c with SMTP id ffacd0b85a97d-3b9009068b3mr11290961f8f.0.1754931974313;
        Mon, 11 Aug 2025 10:06:14 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac574sm41205758f8f.5.2025.08.11.10.06.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:06:13 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Miguel Luis <miguel.luis@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Haibo Xu <haibo.xu@linaro.org>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Alexander Graf <agraf@csgraf.de>,
	Claudio Fontana <cfontana@suse.de>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Mads Ynddal <mads@ynddal.dk>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-arm@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [RFC PATCH 00/11] target/arm: Introduce host_cpu_feature_supported() API
Date: Mon, 11 Aug 2025 19:06:00 +0200
Message-ID: <20250811170611.37482-1-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

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

Philippe Mathieu-Daudé (9):
  accel/system: Introduce hwaccel_enabled() helper
  target/arm: Use generic hwaccel_enabled() to check 'host' cpu type
  target/arm: Restrict PMU to system mode
  target/arm: Introduce arm_hw_accel_cpu_feature_supported()
  target/arm: Introduce host_cpu_feature_supported()
  target/arm: Replace kvm_arm_pmu_supported by
    host_cpu_feature_supported
  target/arm: Replace kvm_arm_el2_supported by
    host_cpu_feature_supported
  target/arm/hvf: Consider EL2 acceleration for Silicon M3+ chipsets
  target/arm/hvf: Allow EL2/EL3 emulation on Silicon M1 / M2

 include/system/hw_accel.h | 13 +++++++
 target/arm/cpu.h          | 23 +++++++++++++
 target/arm/kvm_arm.h      | 24 -------------
 hw/arm/virt.c             |  8 +----
 target/arm/arm-qmp-cmds.c |  5 +--
 target/arm/arm_hw_accel.c | 27 +++++++++++++++
 target/arm/cpu.c          | 14 ++++----
 target/arm/cpu64.c        | 11 +++---
 target/arm/hvf/hvf.c      | 71 +++++++++++++++++++++++++++++++++++++--
 target/arm/kvm-stub.c     | 10 ------
 target/arm/kvm.c          | 33 +++++++++++++-----
 target/arm/meson.build    |  2 +-
 12 files changed, 176 insertions(+), 65 deletions(-)
 create mode 100644 target/arm/arm_hw_accel.c

-- 
2.49.0


