Return-Path: <kvm+bounces-6431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FFDF832022
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:07:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2037B25C23
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35BE22E638;
	Thu, 18 Jan 2024 20:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vtP6J7TB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890202E62A
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608409; cv=none; b=LwX46wJBIoJbi/hguD7uMuXNwzazPwBlCSuqvvrj65Vp5dVvHh2DUQSyNlzSFzql5Yu2Nxr8rRLLf7Uhxh/3xQK3D840mLbdDrJmpk+3bBv3DWgS7S3NohYswxBWygdJoNwkrwsiauDsOpM2+HntFpTD3ZBl1mZ9SgydK0a9HCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608409; c=relaxed/simple;
	bh=WvSP7v2YJclQg5RMQsOdcgT2wXVbeeNFQV0UWIqnP4o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rUCit7QP03cazu1WDYV5C8QQzGLIkGmfcEaKP4j0lF3XwHo6dHsnxa/lrCYq4hzJkcbQ5S2PFpLnWVepKiIGRfXw7LbUzRTke1I4tIapyriWzWlAmGz3z7sttWk59CHuwZ97NiBaZtIFqyonz0Zl29UTaVur9N2nyMjckHoEkl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vtP6J7TB; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-337d05b8942so866918f8f.3
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608406; x=1706213206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MnxwcG9x8U6GyBQH17lIVMOVUV+dD9v6DloaKxqOUuQ=;
        b=vtP6J7TBdDFovrqv20+7oOSPz7FDVhCYzo+OIj2YsqJbdiDmcK1f6A1sBQ1WKZkD5x
         gqLn7xiZUM20fdxZLvs3Khzm37pCw8gwlNGH3v+FDEh1wJJakaLmc9hzxayP2At0UryM
         jY6+rjBgoNieMlYgXwiNDZP9owCNzXelGhYcj0jbBstaWmHl6EPdG9vQFkdpVuLJ4bIj
         xiYzGeGFr9x2xJ39FgKx5tnkxr3guCfc8VzX9l1Sl+nJy50yFXOGn077cBEtPFigpNj3
         ZK0Ky8r7rcJbtMCAJKppu9h7VY7Iy77G7VX+aUtIjhT+Zw65ItIYl8rzJ4dAa8C8KsOJ
         SH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608406; x=1706213206;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MnxwcG9x8U6GyBQH17lIVMOVUV+dD9v6DloaKxqOUuQ=;
        b=Ob7W5Ex8Z4DNlF7xX97/JQ94DX5CNlLSrqfjsazvpQEtDGVHQ9GN88Xazhld81HOMW
         xvFFZgQeKrv29GimLoXE0+yJPnBHnkr1O57Pqeuml6fE0QdNJ7DMsSbXRUUFntIbDw9X
         vPFv7YrtugEQ5CYhUv0k9FRXoV0QVHDhXeoMyC9r03yHyCfsdtix2DfygAqfhre3uaAW
         cPlczPljg/0gfhd20En6pjzxMkJUMhIKjyL5qyug8Y9OXluOoH/C97Xy5lsJPxmBxi8I
         Pl/Kr5Ey19su9yZ6peC9M114+wNotJhtsxzIgUdk/0auisd0XGrUdvThPmfBZjndKddq
         B8gQ==
X-Gm-Message-State: AOJu0Yx34Q+oIZN+z7JDtoqa6XznJb/tdii9231gDthaIYJDVXYBm2n8
	eHKcPstL5V0wJoJK9wPmZRNkWItu4RnpfAdSPVrIdamNHrTU6kDJkRE90M8y5+w=
X-Google-Smtp-Source: AGHT+IFIHxxDoaumKRcg6P/3bJAWZtBjZ9XR5976CC7aYAWayW2rGZ5ty+9P35o60gnyESbKKBWgvA==
X-Received: by 2002:adf:e2c6:0:b0:337:c54d:c3ca with SMTP id d6-20020adfe2c6000000b00337c54dc3camr987049wrj.132.1705608405815;
        Thu, 18 Jan 2024 12:06:45 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id f11-20020adff98b000000b00337d5cd0d8asm1667439wrr.90.2024.01.18.12.06.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:06:45 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Igor Mitsyanko <i.mitsyanko@gmail.com>,
	qemu-arm@nongnu.org,
	Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Eric Auger <eric.auger@redhat.com>,
	Niek Linnenbank <nieklinnenbank@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jan Kiszka <jan.kiszka@web.de>,
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Alistair Francis <alistair@alistair23.me>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Tyrone Ting <kfting@nuvoton.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	Alexander Graf <agraf@csgraf.de>,
	Leif Lindholm <quic_llindhol@quicinc.com>,
	Ani Sinha <anisinha@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Joel Stanley <joel@jms.id.au>,
	Hao Wu <wuhaotsh@google.com>,
	kvm@vger.kernel.org
Subject: [PATCH 00/20] arm: Rework target/ headers to build various hw/ files once
Date: Thu, 18 Jan 2024 21:06:21 +0100
Message-ID: <20240118200643.29037-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hi,

In order to fix a bug noticed [*] by Cédric and Fabiano in my
"Remove one use of qemu_get_cpu() in A7/A15 MPCore priv" series,
I ended reusing commits from other branches and it grew quite
a lot. This is the first "cleanup" part, unrelated on MPCorePriv.

Please review,

Phil.

Philippe Mathieu-Daudé (18):
  hw/arm/exynos4210: Include missing 'exec/tswap.h' header
  hw/arm/xilinx_zynq: Include missing 'exec/tswap.h' header
  hw/arm/smmuv3: Include missing 'hw/registerfields.h' header
  hw/arm/xlnx-versal: Include missing 'cpu.h' header
  target/arm/cpu-features: Include missing 'hw/registerfields.h' header
  target/arm/cpregs: Include missing 'hw/registerfields.h' header
  target/arm/cpregs: Include missing 'kvm-consts.h' header
  target/arm: Expose arm_cpu_mp_affinity() in 'multiprocessing.h' header
  target/arm: Declare ARM_CPU_TYPE_NAME/SUFFIX in 'cpu-qom.h'
  hw/cpu/a9mpcore: Build it only once
  hw/misc/xlnx-versal-crl: Include generic 'cpu-qom.h' instead of
    'cpu.h'
  hw/misc/xlnx-versal-crl: Build it only once
  target/arm: Expose M-profile register bank index definitions
  hw/arm/armv7m: Make 'hw/intc/armv7m_nvic.h' a target agnostic header
  target/arm: Move ARM_CPU_IRQ/FIQ definitions to 'cpu-qom.h' header
  target/arm: Move e2h_access() helper around
  target/arm: Move GTimer definitions to new 'gtimer.h' header
  hw/arm: Build various units only once

Richard Henderson (2):
  target/arm: Rename arm_cpu_mp_affinity
  target/arm: Create arm_cpu_mp_affinity

 hw/arm/smmuv3-internal.h          |  1 +
 include/hw/arm/xlnx-versal.h      |  1 +
 include/hw/intc/armv7m_nvic.h     |  2 +-
 include/hw/misc/xlnx-versal-crl.h |  2 +-
 target/arm/cpregs.h               |  3 +++
 target/arm/cpu-features.h         |  2 ++
 target/arm/cpu-qom.h              | 24 ++++++++++++++++++++++
 target/arm/cpu.h                  | 34 +++----------------------------
 target/arm/gtimer.h               | 21 +++++++++++++++++++
 target/arm/multiprocessing.h      | 16 +++++++++++++++
 hw/arm/allwinner-a10.c            |  1 +
 hw/arm/allwinner-h3.c             |  2 ++
 hw/arm/allwinner-r40.c            |  2 ++
 hw/arm/armv7m.c                   |  2 ++
 hw/arm/aspeed_ast2400.c           |  1 +
 hw/arm/aspeed_ast2600.c           |  1 +
 hw/arm/bcm2836.c                  |  2 ++
 hw/arm/collie.c                   |  1 -
 hw/arm/exynos4210.c               |  2 ++
 hw/arm/fsl-imx25.c                |  1 +
 hw/arm/fsl-imx31.c                |  1 +
 hw/arm/fsl-imx6.c                 |  1 +
 hw/arm/fsl-imx6ul.c               |  1 +
 hw/arm/fsl-imx7.c                 |  1 +
 hw/arm/gumstix.c                  |  1 -
 hw/arm/highbank.c                 |  1 +
 hw/arm/integratorcp.c             |  2 +-
 hw/arm/mainstone.c                |  1 -
 hw/arm/musicpal.c                 |  2 +-
 hw/arm/npcm7xx.c                  |  3 ++-
 hw/arm/omap1.c                    |  1 +
 hw/arm/omap2.c                    |  2 +-
 hw/arm/omap_sx1.c                 |  1 -
 hw/arm/palm.c                     |  1 -
 hw/arm/realview.c                 |  1 +
 hw/arm/sbsa-ref.c                 |  4 +++-
 hw/arm/spitz.c                    |  1 -
 hw/arm/strongarm.c                |  2 +-
 hw/arm/versatilepb.c              |  2 +-
 hw/arm/vexpress.c                 |  2 +-
 hw/arm/virt-acpi-build.c          |  4 ++--
 hw/arm/virt.c                     | 11 ++++++----
 hw/arm/xilinx_zynq.c              |  3 ++-
 hw/arm/xlnx-versal-virt.c         |  5 +++--
 hw/arm/xlnx-versal.c              |  2 ++
 hw/arm/xlnx-zynqmp.c              |  2 ++
 hw/arm/z2.c                       |  1 -
 hw/cpu/a15mpcore.c                |  1 +
 hw/cpu/a9mpcore.c                 |  2 +-
 hw/misc/xlnx-versal-crl.c         |  5 +++--
 target/arm/arm-powerctl.c         |  3 ++-
 target/arm/cpu.c                  | 13 +++++++++---
 target/arm/helper.c               | 30 ++++++++++++++-------------
 target/arm/hvf/hvf.c              |  6 ++++--
 target/arm/kvm.c                  |  1 +
 target/arm/machine.c              |  1 +
 target/arm/tcg/psci.c             |  3 ++-
 hw/arm/meson.build                | 23 +++++++++++----------
 hw/cpu/meson.build                |  2 +-
 hw/misc/meson.build               |  2 +-
 60 files changed, 178 insertions(+), 94 deletions(-)
 create mode 100644 target/arm/gtimer.h
 create mode 100644 target/arm/multiprocessing.h

-- 
2.41.0


