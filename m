Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7DE27DC39
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 00:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgI2Wo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 18:44:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728892AbgI2Wo2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 18:44:28 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601419466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o4HjcXP3qwr6X7IJP4D/f1xvLwTdd8bPvM5GyTvUpNE=;
        b=TarwSgt5cfNQkCdjsuAzWedt3xT71a4Vk8TLLkcdx44eARQSywMrtR+sg4jt0V6SSX5H49
        qeEoP26owe7236A3U7zQsxCTxxFrPtgsOv6EwpscYyofPw9Uy9GBkDAvcsh6hH5o1sUO68
        hOX0WMT48cMQzYfdrvpB1D0Npi/ByHE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-TMtX7qLvN0eY4UcH7ujmlA-1; Tue, 29 Sep 2020 18:44:24 -0400
X-MC-Unique: TMtX7qLvN0eY4UcH7ujmlA-1
Received: by mail-wr1-f72.google.com with SMTP id v5so2379385wrr.0
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 15:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o4HjcXP3qwr6X7IJP4D/f1xvLwTdd8bPvM5GyTvUpNE=;
        b=ZoEeGesy7NXRmVJdphGw8eMzLmFFfzSx4/EgOXyaTp7Q7PQQ65eVbrF1aJESORibpb
         Of57fbMp1jMPBkAGDib537035jubtJ5EGs8JjpXrce8QVAHmYerBUZQ205X+80YfWpIz
         axVUItTooe194i8ZmMi+QBL+KBZ+q8L86gaOFkl/ugpiGKQKvK5WRdQafQT7lfVnLj5h
         tYPJ9Dmc4sOdC5FGKuH49H6WjEl7TPkg8sC8g5Ftpej/Iv+cc8No+6z9eDB/GcokbvX7
         Vp0vqBxTHJJoFnAL2dSUMqTRzedK07S9xg189YwDA0hmVi5uOiROzVyPVKcaGvP87THe
         D8dg==
X-Gm-Message-State: AOAM531rj/DTnqAn7oskIFW5e9KleFPYnnmUgMFyqUDH6frBCEjfyXhL
        wbKPypSkeW6guRFcXgZ5+/ODYFAQ4u1oHiUaA0EUEMUqBPbl3gl/8QJTP3f6bW8WB1BVixFoyr5
        9bJP6FAOAjx++
X-Received: by 2002:adf:83c3:: with SMTP id 61mr6487534wre.287.1601419463554;
        Tue, 29 Sep 2020 15:44:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiKG03zq+uHxa3VA+7jIh3VXyDityJ8NdNAGTWh+0EeM/7OentrHFt37Qc69GgvEZbvFzI7w==
X-Received: by 2002:adf:83c3:: with SMTP id 61mr6487523wre.287.1601419463375;
        Tue, 29 Sep 2020 15:44:23 -0700 (PDT)
Received: from x1w.redhat.com (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id l4sm8483138wrc.14.2020.09.29.15.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 15:44:22 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 05/12] target/arm: Restrict ARMv5 cpus to TCG accel
Date:   Wed, 30 Sep 2020 00:43:48 +0200
Message-Id: <20200929224355.1224017-6-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929224355.1224017-1-philmd@redhat.com>
References: <20200929224355.1224017-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM requires a cpu based on (at least) the ARMv7 architecture.

Only enable the following ARMv5 CPUs when TCG is available:

  - ARM926
  - ARM946
  - ARM1026
  - XScale (PXA250/255/260/261/262/270)

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/arm/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index b546b20654..d2876b2c8b 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -2,6 +2,10 @@ config ARM_V4
     bool
     select TCG
 
+config ARM_V5
+    bool
+    select TCG
+
 config ARM_VIRT
     bool
     imply PCI_DEVICES
@@ -44,6 +48,7 @@ config CUBIEBOARD
 
 config DIGIC
     bool
+    select ARM_V5
     select PTIMER
     select PFLASH_CFI02
 
@@ -73,6 +78,7 @@ config HIGHBANK
 
 config INTEGRATOR
     bool
+    select ARM_V5
     select ARM_TIMER
     select INTEGRATOR_DEBUG
     select PL011 # UART
@@ -99,6 +105,7 @@ config MUSCA
 
 config MUSICPAL
     bool
+    select ARM_V5
     select BITBANG_I2C
     select MARVELL_88W8618
     select PTIMER
@@ -138,6 +145,7 @@ config OMAP
 
 config PXA2XX
     bool
+    select ARM_V5
     select FRAMEBUFFER
     select I2C
     select SERIAL
@@ -254,6 +262,7 @@ config SX1
 
 config VERSATILE
     bool
+    select ARM_V5
     select ARM_TIMER # sp804
     select PFLASH_CFI01
     select LSI_SCSI_PCI
@@ -373,6 +382,7 @@ config NPCM7XX
 
 config FSL_IMX25
     bool
+    select ARM_V5
     select IMX
     select IMX_FEC
     select IMX_I2C
@@ -399,6 +409,7 @@ config FSL_IMX6
 
 config ASPEED_SOC
     bool
+    select ARM_V5
     select DS1338
     select FTGMAC100
     select I2C
-- 
2.26.2

