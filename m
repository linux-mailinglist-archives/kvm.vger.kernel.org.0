Return-Path: <kvm+bounces-6445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FD1A832030
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A51DC1F23795
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 071B132193;
	Thu, 18 Jan 2024 20:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IBIezyXp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9A431A98
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608489; cv=none; b=fvyRUXhweX0uGyk8iAC27ZmM397TgysRWDRC9QMu1HLgqef4Au3f0g21M0KHhSmL+amrvxdokaPcFIPeAH/Uof6Sy6rjzPqWq//pTcMstTEyMp25j+Pi6IjpfcURpVq6C3QujKJ3k8AbauspVsMazZKg8B2D3GrbqgeCgJKXTBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608489; c=relaxed/simple;
	bh=MhCutPUJXazK8GtOfSH+kdYhMiaTMKVYNEVzzLFwaEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejnsLQwmFQ0UJ/bFk/xfmpTGgxRMhXIzMuBKNQokebWMF5mGzrGPuTv7hQTgYTapr3rB6Y3MCmFtcoV8P9ivj0GRhV50D5B6bStJ/JbZWzMJLczG8052Hv0ZFUZla0P+3I3s3rlV7HGrimgM/SAg0h2RbacO9MyCGAjJqMTPgkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IBIezyXp; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40e90163be1so339755e9.1
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608486; x=1706213286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FzWbQBIfEs6OJQ0hzr//F/cyUEfiuvwBN1uqJ0c1PMQ=;
        b=IBIezyXpRoa1zvTu9+NSRMqtde/e2nmh6UJFmlGIrGEY+YOyNnYw7Mbj+bh2rShNaq
         FZOD9DasETrA7wDC5oTNV+JI3q8oJ3d2l120a2TlWycl5foiNwwu3Y6Hp3IXPkCIE9YP
         acBu7Ml2q56UOwWhFM6mlcFzodVpKW2ieFJ6T1oOoDJrl18pvRXHB1sJWa4XAXvF/DGU
         xCetsIqMQ9FeAkC9/jw/4V/mHJluu9VTS5vfEitEPobEk0/HT8DdKsWEkePwjyuZNmA7
         Z4vanMsh3GAyg9iJY1dM7AhpVhdXb8BjO9tZ0QbU99cMseFl62LE3e//vpbEsbgE8m6s
         LWcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608486; x=1706213286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FzWbQBIfEs6OJQ0hzr//F/cyUEfiuvwBN1uqJ0c1PMQ=;
        b=YpFQ1pzPXQVoKzqSFbhQ99hJ5/Nk3RRK99anppA6b0rVMCYEjH6xpoghyIkdmEFnuD
         SskUfMVNE3q3bHlekcY9E/eJ/AvynW6p1/ZZY1SR3HWwRVtTzIQumurdy2tvV0SFUGAe
         9+b4iFttrSvgF0PvnzFrZBuXYpDmfQe50p7pBRvf535docOjkkuN7c72T/7zTzNQl+xQ
         o6N0yivuryJE68GFGPlpFIjITr5D5hWngsuPdDyKWiJ4jKQslYJ/gcee/YgOahesQWDS
         PTxoknGcljJ3x3dUKVvTY6lrml8rwfmkHZW6nxSlxI9yBCPSzdyYgFIYwQoM4irQtAr3
         uuvQ==
X-Gm-Message-State: AOJu0YyGcd2ffACKdjU9aDnOlmnl53A/KHYYyn6psb08lNACPADgh4CV
	Wv4WP1rhUAhNcDvRUmcQSwFRryU/IxTEWHXoAb/5BSBxXRYmnyWP77WtfmNoR+o=
X-Google-Smtp-Source: AGHT+IFci8bumHGc8yO/eXI47NN1r9/9twGUNYvsiqm8vje6N+VVmUV/t0FaeNfUmyQwqGi/uZixhA==
X-Received: by 2002:a05:600c:2047:b0:40e:53a0:c140 with SMTP id p7-20020a05600c204700b0040e53a0c140mr471729wmg.229.1705608486072;
        Thu, 18 Jan 2024 12:08:06 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id z10-20020a05600c0a0a00b0040e4bcfd826sm27279780wmp.47.2024.01.18.12.08.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:08:05 -0800 (PST)
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
Subject: [PATCH 14/20] hw/misc/xlnx-versal-crl: Build it only once
Date: Thu, 18 Jan 2024 21:06:35 +0100
Message-ID: <20240118200643.29037-15-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240118200643.29037-1-philmd@linaro.org>
References: <20240118200643.29037-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

hw/misc/xlnx-versal-crl.c doesn't require "cpu.h"
anymore.  By removing it, the unit become target
agnostic: we can build it once. Update meson.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/misc/xlnx-versal-crl.c | 1 -
 hw/misc/meson.build       | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/hw/misc/xlnx-versal-crl.c b/hw/misc/xlnx-versal-crl.c
index 1a596f1cf5..1f1762ef16 100644
--- a/hw/misc/xlnx-versal-crl.c
+++ b/hw/misc/xlnx-versal-crl.c
@@ -18,7 +18,6 @@
 #include "hw/register.h"
 #include "hw/resettable.h"
 
-#include "target/arm/cpu.h"
 #include "target/arm/arm-powerctl.h"
 #include "target/arm/multiprocessing.h"
 #include "hw/misc/xlnx-versal-crl.h"
diff --git a/hw/misc/meson.build b/hw/misc/meson.build
index 36c20d5637..66820acac3 100644
--- a/hw/misc/meson.build
+++ b/hw/misc/meson.build
@@ -96,8 +96,8 @@ system_ss.add(when: 'CONFIG_SLAVIO', if_true: files('slavio_misc.c'))
 system_ss.add(when: 'CONFIG_ZYNQ', if_true: files('zynq_slcr.c'))
 system_ss.add(when: 'CONFIG_XLNX_ZYNQMP_ARM', if_true: files('xlnx-zynqmp-crf.c'))
 system_ss.add(when: 'CONFIG_XLNX_ZYNQMP_ARM', if_true: files('xlnx-zynqmp-apu-ctrl.c'))
-specific_ss.add(when: 'CONFIG_XLNX_VERSAL', if_true: files('xlnx-versal-crl.c'))
 system_ss.add(when: 'CONFIG_XLNX_VERSAL', if_true: files(
+  'xlnx-versal-crl.c',
   'xlnx-versal-xramc.c',
   'xlnx-versal-pmc-iou-slcr.c',
   'xlnx-versal-cfu.c',
-- 
2.41.0


