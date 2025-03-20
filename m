Return-Path: <kvm+bounces-41633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2021A6B0E9
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:33:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56865189999A
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0AC822AE68;
	Thu, 20 Mar 2025 22:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LNqI96Vv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522D022AE49
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509844; cv=none; b=J25/FMFH+KySwlCNRcM3PQ+r2R+g6kQ8fHiqgVBTQP79mSxiIKkTpXOVKWn6awAWb9+gNm9Ajs9aSCzpK7unmHu6zE4+bOFMcezxcrof1ti2+k4evK0fPSiTl5JGmQ7loVaXyr8MON5hY05lyx/uHuoBqTj8s1caJpepdqyHleU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509844; c=relaxed/simple;
	bh=x+ToD/As2XrMOsCu4JuHj9NMIdqvRa61LZejFh9BH+4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hDpANM4BrHcKLJrzERQW+uOlApV0V6bghAu6HJ3vdVNUi/9PAj5F++GM9J58U5fgSbLaYJhyYp3bnNf/lnqZKuZC5AJMDIPHf49ThbHivLlBlljFJKQMfd1WfMMMwnK05PrCkEo6GeHqgzqkIgGf1PWF3w1UqFa0o8BHtPcBffo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LNqI96Vv; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-226185948ffso26879025ad.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509841; x=1743114641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yn2Xz9RB0NXRkBKqvuaaiEm9yg8jr17YbtEabY7lMZc=;
        b=LNqI96Vv0DgnyhL4rA36tb1+aSmTgqDEGw935EHlZdr4sqQWczKrHtSbFd7+RapK3C
         1A50i76Ppz1uCEmmhI2YgjnPo9+/aewacMg8vbWYKdnjIHxDFWvneZJfQf5wAmNjGznl
         YsBWV/YTkObPEAenteovYh/OpeVbzL3nD9ePQRrKYQuOxXwhtRuU771NToC/SkMHevJ0
         Sa5O5dWplRjGgJeVq3yX87Zi/8GcTKerON7zYPSGpMe3TKJp+KwnBND2RdvQ/d7fpd3o
         q5D9koE6MFdXMxmsR9zTKRoIkCP82pw25VOmN2XWdu5Qa8lUzrnIH19VzgtjMENa66D+
         WUkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509841; x=1743114641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yn2Xz9RB0NXRkBKqvuaaiEm9yg8jr17YbtEabY7lMZc=;
        b=fDD84AcFY8k2C6DQjndYv2GdnGxd1CO+9P73wTvLz6FuoUCLEZLLJtDy6D360a9skt
         NkfxH14R5Y/x/5N8iactsUvh+HYFhcwyJUQsVYTjfAh4p+MngyHWNslwCCdhZ2UhpGu0
         wY0hwgZOQ55j4IgLY9UCy/E6W3sGxqdVBMmRmIVS+J1kz23GKmuS3pMIIO4XFPF9G/fz
         +LdAiDBCg+0diWBtTuFZPWzWbUiZ/IKELchjJDN41fJnmSupwgvGX7rf5JftMjgKQ08I
         xgOVoUcLwcVVaB1ooTr9t0k8UaVxVZz+hAzqCw/94UOQNP4WHynR3s0UWw+LrZBfhBwk
         2lCw==
X-Gm-Message-State: AOJu0Yz5J97wfbDGedDcLyVfX0gChG3RGGsJIPi9rMAtngJPNf/c8F0o
	Y0hj0J5b5rsUqOmYC4OaH9cdexmwtmq2X+Qa8T9Oy2F7h/5JTe4Z7xfRR+oxVYc=
X-Gm-Gg: ASbGncuSMquk4GyQdFLkDVvu4AaD+RsZ04JXqPzm36lD5j5qkSyNW0xS+81AicaK7mj
	MILnD/BR2yn4gFjrT6LorDkY8z+7IfZbqVRLSdHANR5TXlloEAP28q9qPywc1TvfhJiaXOqbG7C
	dcIiZWCGfv1utlBNsVk+KnYFMujI9yi3fJS6e1N5YBnPRSN9Yb4PJf5uh6UZStY8AQYAnxhf9Ie
	ZUzqV6nWd9EtwoXqq3qIhnWn4GJojlUwLaQXtNRAqrb0PLwBHyKOo6fAqjAGSCMmiEoH2R3nJP4
	pmp1BGaLTbG0QIR9Ao0410Kak4gWIwfVhoOctDwpz/zU
X-Google-Smtp-Source: AGHT+IEzJbf92WCs5cdn48gdTqOAmHjHUL79CRGln7SjLlFgI+95i4LaCr+ImDqPmlnxNCrWkwC3Xw==
X-Received: by 2002:a17:902:fc4b:b0:226:38ff:1d6a with SMTP id d9443c01a7336-22780c68a1amr17471675ad.7.1742509840610;
        Thu, 20 Mar 2025 15:30:40 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:40 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 30/30] hw/arm: make most of the compilation units common
Date: Thu, 20 Mar 2025 15:30:02 -0700
Message-Id: <20250320223002.2915728-31-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/arm/meson.build | 112 ++++++++++++++++++++++-----------------------
 1 file changed, 56 insertions(+), 56 deletions(-)

diff --git a/hw/arm/meson.build b/hw/arm/meson.build
index 9e8c96059eb..09b1cfe5b57 100644
--- a/hw/arm/meson.build
+++ b/hw/arm/meson.build
@@ -2,43 +2,43 @@ arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(when: 'CONFIG_ARM_VIRT', if_true: files('virt.c'))
 arm_ss.add(when: 'CONFIG_ACPI', if_true: files('virt-acpi-build.c'))
-arm_ss.add(when: 'CONFIG_DIGIC', if_true: files('digic_boards.c'))
-arm_ss.add(when: 'CONFIG_EMCRAFT_SF2', if_true: files('msf2-som.c'))
-arm_ss.add(when: 'CONFIG_HIGHBANK', if_true: files('highbank.c'))
-arm_ss.add(when: 'CONFIG_INTEGRATOR', if_true: files('integratorcp.c'))
-arm_ss.add(when: 'CONFIG_MICROBIT', if_true: files('microbit.c'))
-arm_ss.add(when: 'CONFIG_MPS3R', if_true: files('mps3r.c'))
-arm_ss.add(when: 'CONFIG_MUSICPAL', if_true: files('musicpal.c'))
-arm_ss.add(when: 'CONFIG_NETDUINOPLUS2', if_true: files('netduinoplus2.c'))
-arm_ss.add(when: 'CONFIG_OLIMEX_STM32_H405', if_true: files('olimex-stm32-h405.c'))
-arm_ss.add(when: 'CONFIG_NPCM7XX', if_true: files('npcm7xx.c', 'npcm7xx_boards.c'))
-arm_ss.add(when: 'CONFIG_NPCM8XX', if_true: files('npcm8xx.c', 'npcm8xx_boards.c'))
-arm_ss.add(when: 'CONFIG_REALVIEW', if_true: files('realview.c'))
+arm_common_ss.add(when: 'CONFIG_DIGIC', if_true: files('digic_boards.c'))
+arm_common_ss.add(when: 'CONFIG_EMCRAFT_SF2', if_true: files('msf2-som.c'))
+arm_common_ss.add(when: 'CONFIG_HIGHBANK', if_true: files('highbank.c'))
+arm_common_ss.add(when: 'CONFIG_INTEGRATOR', if_true: files('integratorcp.c'))
+arm_common_ss.add(when: 'CONFIG_MICROBIT', if_true: files('microbit.c'))
+arm_common_ss.add(when: 'CONFIG_MPS3R', if_true: files('mps3r.c'))
+arm_common_ss.add(when: 'CONFIG_MUSICPAL', if_true: [pixman, files('musicpal.c')])
+arm_common_ss.add(when: 'CONFIG_NETDUINOPLUS2', if_true: files('netduinoplus2.c'))
+arm_common_ss.add(when: 'CONFIG_OLIMEX_STM32_H405', if_true: files('olimex-stm32-h405.c'))
+arm_common_ss.add(when: 'CONFIG_NPCM7XX', if_true: files('npcm7xx.c', 'npcm7xx_boards.c'))
+arm_common_ss.add(when: 'CONFIG_NPCM8XX', if_true: files('npcm8xx.c', 'npcm8xx_boards.c'))
+arm_common_ss.add(when: 'CONFIG_REALVIEW', if_true: files('realview.c'))
 arm_ss.add(when: 'CONFIG_SBSA_REF', if_true: files('sbsa-ref.c'))
-arm_ss.add(when: 'CONFIG_STELLARIS', if_true: files('stellaris.c'))
-arm_ss.add(when: 'CONFIG_STM32VLDISCOVERY', if_true: files('stm32vldiscovery.c'))
-arm_ss.add(when: 'CONFIG_ZYNQ', if_true: files('xilinx_zynq.c'))
-arm_ss.add(when: 'CONFIG_SABRELITE', if_true: files('sabrelite.c'))
+arm_common_ss.add(when: 'CONFIG_STELLARIS', if_true: files('stellaris.c'))
+arm_common_ss.add(when: 'CONFIG_STM32VLDISCOVERY', if_true: files('stm32vldiscovery.c'))
+arm_common_ss.add(when: 'CONFIG_ZYNQ', if_true: files('xilinx_zynq.c'))
+arm_common_ss.add(when: 'CONFIG_SABRELITE', if_true: files('sabrelite.c'))
 
-arm_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('armv7m.c'))
-arm_ss.add(when: 'CONFIG_EXYNOS4', if_true: files('exynos4210.c'))
-arm_ss.add(when: 'CONFIG_DIGIC', if_true: files('digic.c'))
-arm_ss.add(when: 'CONFIG_OMAP', if_true: files('omap1.c'))
-arm_ss.add(when: 'CONFIG_ALLWINNER_A10', if_true: files('allwinner-a10.c', 'cubieboard.c'))
-arm_ss.add(when: 'CONFIG_ALLWINNER_H3', if_true: files('allwinner-h3.c', 'orangepi.c'))
-arm_ss.add(when: 'CONFIG_ALLWINNER_R40', if_true: files('allwinner-r40.c', 'bananapi_m2u.c'))
+arm_common_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('armv7m.c'))
+arm_common_ss.add(when: 'CONFIG_EXYNOS4', if_true: files('exynos4210.c'))
+arm_common_ss.add(when: 'CONFIG_DIGIC', if_true: files('digic.c'))
+arm_common_ss.add(when: 'CONFIG_OMAP', if_true: files('omap1.c'))
+arm_common_ss.add(when: 'CONFIG_ALLWINNER_A10', if_true: files('allwinner-a10.c', 'cubieboard.c'))
+arm_common_ss.add(when: 'CONFIG_ALLWINNER_H3', if_true: files('allwinner-h3.c', 'orangepi.c'))
+arm_common_ss.add(when: 'CONFIG_ALLWINNER_R40', if_true: files('allwinner-r40.c', 'bananapi_m2u.c'))
 arm_ss.add(when: 'CONFIG_RASPI', if_true: files('bcm2836.c', 'raspi.c'))
-arm_ss.add(when: ['CONFIG_RASPI', 'TARGET_AARCH64'], if_true: files('bcm2838.c', 'raspi4b.c'))
-arm_ss.add(when: 'CONFIG_STM32F100_SOC', if_true: files('stm32f100_soc.c'))
-arm_ss.add(when: 'CONFIG_STM32F205_SOC', if_true: files('stm32f205_soc.c'))
-arm_ss.add(when: 'CONFIG_STM32F405_SOC', if_true: files('stm32f405_soc.c'))
-arm_ss.add(when: 'CONFIG_B_L475E_IOT01A', if_true: files('b-l475e-iot01a.c'))
-arm_ss.add(when: 'CONFIG_STM32L4X5_SOC', if_true: files('stm32l4x5_soc.c'))
-arm_ss.add(when: 'CONFIG_XLNX_ZYNQMP_ARM', if_true: files('xlnx-zynqmp.c', 'xlnx-zcu102.c'))
-arm_ss.add(when: 'CONFIG_XLNX_VERSAL', if_true: files('xlnx-versal.c', 'xlnx-versal-virt.c'))
-arm_ss.add(when: 'CONFIG_FSL_IMX25', if_true: files('fsl-imx25.c', 'imx25_pdk.c'))
-arm_ss.add(when: 'CONFIG_FSL_IMX31', if_true: files('fsl-imx31.c', 'kzm.c'))
-arm_ss.add(when: 'CONFIG_FSL_IMX6', if_true: files('fsl-imx6.c'))
+arm_common_ss.add(when: ['CONFIG_RASPI', 'TARGET_AARCH64'], if_true: files('bcm2838.c', 'raspi4b.c'))
+arm_common_ss.add(when: 'CONFIG_STM32F100_SOC', if_true: files('stm32f100_soc.c'))
+arm_common_ss.add(when: 'CONFIG_STM32F205_SOC', if_true: files('stm32f205_soc.c'))
+arm_common_ss.add(when: 'CONFIG_STM32F405_SOC', if_true: files('stm32f405_soc.c'))
+arm_common_ss.add(when: 'CONFIG_B_L475E_IOT01A', if_true: files('b-l475e-iot01a.c'))
+arm_common_ss.add(when: 'CONFIG_STM32L4X5_SOC', if_true: files('stm32l4x5_soc.c'))
+arm_common_ss.add(when: 'CONFIG_XLNX_ZYNQMP_ARM', if_true: files('xlnx-zynqmp.c', 'xlnx-zcu102.c'))
+arm_common_ss.add(when: 'CONFIG_XLNX_VERSAL', if_true: files('xlnx-versal.c', 'xlnx-versal-virt.c'))
+arm_common_ss.add(when: 'CONFIG_FSL_IMX25', if_true: files('fsl-imx25.c', 'imx25_pdk.c'))
+arm_common_ss.add(when: 'CONFIG_FSL_IMX31', if_true: files('fsl-imx31.c', 'kzm.c'))
+arm_common_ss.add(when: 'CONFIG_FSL_IMX6', if_true: files('fsl-imx6.c'))
 arm_ss.add(when: 'CONFIG_ASPEED_SOC', if_true: files(
   'aspeed.c',
   'aspeed_soc_common.c',
@@ -47,33 +47,33 @@ arm_ss.add(when: 'CONFIG_ASPEED_SOC', if_true: files(
   'aspeed_ast10x0.c',
   'aspeed_eeprom.c',
   'fby35.c'))
-arm_ss.add(when: ['CONFIG_ASPEED_SOC', 'TARGET_AARCH64'], if_true: files('aspeed_ast27x0.c'))
-arm_ss.add(when: 'CONFIG_MPS2', if_true: files('mps2.c'))
-arm_ss.add(when: 'CONFIG_MPS2', if_true: files('mps2-tz.c'))
-arm_ss.add(when: 'CONFIG_MSF2', if_true: files('msf2-soc.c'))
-arm_ss.add(when: 'CONFIG_MUSCA', if_true: files('musca.c'))
-arm_ss.add(when: 'CONFIG_ARMSSE', if_true: files('armsse.c'))
-arm_ss.add(when: 'CONFIG_FSL_IMX7', if_true: files('fsl-imx7.c', 'mcimx7d-sabre.c'))
-arm_ss.add(when: 'CONFIG_FSL_IMX8MP', if_true: files('fsl-imx8mp.c'))
-arm_ss.add(when: 'CONFIG_FSL_IMX8MP_EVK', if_true: files('imx8mp-evk.c'))
-arm_ss.add(when: 'CONFIG_ARM_SMMUV3', if_true: files('smmuv3.c'))
-arm_ss.add(when: 'CONFIG_FSL_IMX6UL', if_true: files('fsl-imx6ul.c', 'mcimx6ul-evk.c'))
-arm_ss.add(when: 'CONFIG_NRF51_SOC', if_true: files('nrf51_soc.c'))
+arm_common_ss.add(when: ['CONFIG_ASPEED_SOC', 'TARGET_AARCH64'], if_true: files('aspeed_ast27x0.c'))
+arm_common_ss.add(when: 'CONFIG_MPS2', if_true: files('mps2.c'))
+arm_common_ss.add(when: 'CONFIG_MPS2', if_true: files('mps2-tz.c'))
+arm_common_ss.add(when: 'CONFIG_MSF2', if_true: files('msf2-soc.c'))
+arm_common_ss.add(when: 'CONFIG_MUSCA', if_true: files('musca.c'))
+arm_common_ss.add(when: 'CONFIG_ARMSSE', if_true: files('armsse.c'))
+arm_common_ss.add(when: 'CONFIG_FSL_IMX7', if_true: files('fsl-imx7.c', 'mcimx7d-sabre.c'))
+arm_common_ss.add(when: 'CONFIG_FSL_IMX8MP', if_true: files('fsl-imx8mp.c'))
+arm_common_ss.add(when: 'CONFIG_FSL_IMX8MP_EVK', if_true: files('imx8mp-evk.c'))
+arm_common_ss.add(when: 'CONFIG_ARM_SMMUV3', if_true: files('smmuv3.c'))
+arm_common_ss.add(when: 'CONFIG_FSL_IMX6UL', if_true: files('fsl-imx6ul.c', 'mcimx6ul-evk.c'))
+arm_common_ss.add(when: 'CONFIG_NRF51_SOC', if_true: files('nrf51_soc.c'))
 arm_ss.add(when: 'CONFIG_XEN', if_true: files(
   'xen-stubs.c',
   'xen-pvh.c',
 ))
 
-system_ss.add(when: 'CONFIG_ARM_SMMUV3', if_true: files('smmu-common.c'))
-system_ss.add(when: 'CONFIG_COLLIE', if_true: files('collie.c'))
-system_ss.add(when: 'CONFIG_EXYNOS4', if_true: files('exynos4_boards.c'))
-system_ss.add(when: 'CONFIG_NETDUINO2', if_true: files('netduino2.c'))
-system_ss.add(when: 'CONFIG_RASPI', if_true: files('bcm2835_peripherals.c'))
-system_ss.add(when: 'CONFIG_RASPI', if_true: files('bcm2838_peripherals.c'))
-system_ss.add(when: 'CONFIG_STRONGARM', if_true: files('strongarm.c'))
-system_ss.add(when: 'CONFIG_SX1', if_true: files('omap_sx1.c'))
-system_ss.add(when: 'CONFIG_VERSATILE', if_true: files('versatilepb.c'))
-system_ss.add(when: 'CONFIG_VEXPRESS', if_true: files('vexpress.c'))
+arm_common_ss.add(when: 'CONFIG_ARM_SMMUV3', if_true: files('smmu-common.c'))
+arm_common_ss.add(when: 'CONFIG_COLLIE', if_true: files('collie.c'))
+arm_common_ss.add(when: 'CONFIG_EXYNOS4', if_true: files('exynos4_boards.c'))
+arm_common_ss.add(when: 'CONFIG_NETDUINO2', if_true: files('netduino2.c'))
+arm_common_ss.add(when: 'CONFIG_RASPI', if_true: files('bcm2835_peripherals.c'))
+arm_common_ss.add(when: 'CONFIG_RASPI', if_true: files('bcm2838_peripherals.c'))
+arm_common_ss.add(when: 'CONFIG_STRONGARM', if_true: files('strongarm.c'))
+arm_common_ss.add(when: 'CONFIG_SX1', if_true: files('omap_sx1.c'))
+arm_common_ss.add(when: 'CONFIG_VERSATILE', if_true: files('versatilepb.c'))
+arm_common_ss.add(when: 'CONFIG_VEXPRESS', if_true: files('vexpress.c'))
 
 arm_common_ss.add(fdt, files('boot.c'))
 
-- 
2.39.5


