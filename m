Return-Path: <kvm+bounces-45875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18F2FAAFBC0
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:42:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14AF4981BF8
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FECE22D4C9;
	Thu,  8 May 2025 13:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GmdQ+2GA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1851B6CE9
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711723; cv=none; b=iusXI7UuyfTJs3KFNykggCsRnB+Hmq4nfJMD1+SXh/2aNpVtqAosAcmIQrX1fq/mzOqo6tLCz75dx+yMt0XBRBaiLl33frNFXqb58953ZbvjACpNFaRLo14iTAfDnCViBlWglKvlXSu1Z3DU7nw6BEl3MKm9GZC8xDjEfjvFYV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711723; c=relaxed/simple;
	bh=Nzx5ll/FmB2eF2nKXtD6IU1kSCUqAW3ePFfRFLp4nqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nifAToMJkSwea7GFRA9xbwQz7Sn4hE/KDlM4mKENgIynXvX3eGUubCAbNmSxPRTCOgFSH00Qm2OuVVCwqa4AA5S3BXgn2It8mlfmGuH3HbKBsyp6Ob6G4Hl/nRCXdTo/9RB1q1MCH3JTS9PCsFZ/T7442jHKHu3b2p0fkN0j7ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GmdQ+2GA; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22fb7659866so4315895ad.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711721; x=1747316521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvLizXjiSVqZDvieXMhXwGlqnaF81TYck8XbLuFhLlo=;
        b=GmdQ+2GAw+2y4GC63lO28UP2E6+jMf17XGxOfvcn+Ls77AyQ4EmCKHsmJWrKYkWUJs
         drOaVQ1gT+jikpzA3p1B1V55kYZpCePNYfoSeOtLMRUvNH9323rGFxmJNlvKuX4bgDbx
         zCBXkDGfXjuFN/HEKq1FhM9wU+ySQ3Jj+9RAKExUGyt4XbKn3yVBGWvoR/NCmLZB47xn
         TsQtRr1eYSmBdQO8DHbQa9IqFT4rSR/QiA5o85a1IfNSciVP4qmukJwMgG/RWnpeTRRW
         hwbYsTsgUkcZTsWGzhy9D5BsIvxkytLUWKEgRXqy5gEy55S6iRqWVY+cYKGnJdaRDJAY
         ZSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711721; x=1747316521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fvLizXjiSVqZDvieXMhXwGlqnaF81TYck8XbLuFhLlo=;
        b=SopjU8+IgxaEMxcnE/rWnRDFjCjqC/GV2X3X/v1/AcUVCP7wzhmxLofkoeIeaN85eI
         C54lyJ1CJuzGhfDODcf6Bi/CORuln5W9eZeKXptvUeN2GZeWHiF1OkTYzExPpolHg6MZ
         xuxjARrPksUvvhI5HjDL3Hob7B32q83Yjncwluu+INJQPUvqO+PCHW3z8J5ctC3IIOvw
         3f9340naGuacgWiM3YVRcW2T7EVdJcCJMek5Kx4I3P2SSFUNFSh/ErlpMHMRvuzZtTEk
         V+vAKXtI7qMCI4fikJl4thQgNJgJDt9pLvMqHA2ByKzyJfSVIUByv7kDdGowVflKRbGI
         lWtg==
X-Forwarded-Encrypted: i=1; AJvYcCX9y71JradpCX1OUbHQBpO67DxiOPPc1F5RMu6WNd6VJ8302yid/Ydj3dyUw/iPz4MrsPg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx76w70j7xXX9M052nrRN4yN8KBqvX6kq9GOnelvHCZVlvpnej5
	WdP5TpzeVGRyPlimegaQU7kZbgXxrFkNHdtIguI9s1x2FlFTRNkXgztPoXJ70eY=
X-Gm-Gg: ASbGncuL+Uul8bojy8/pYbiQg6EffB1IMxNKluijLR1hu+MPEJPeJWgdlvb+vXfYNse
	lF5uh1PdfCHZPImjdP2Q2/s5MPE8UjoRVGZmbbArEgIKk4K6l8MyBre9BYDij/x2HkeF7X6p3N6
	0mBsPrGuiPHLo1key7RclLI77RBf2SAgD97wfDX+1dSXWFayFQHM/IXX842PtglYNfarY75Aqy4
	K6isnNU9/d3WisjmTsKB2CqGdkBQmx3O3amqU5oZhp5SHhYEOdR8ZoQLD1SznLy/rLceQg4QOXl
	w0MrrwQ1Q1qwMMTEkqS4pQjgo2oqb8skxRhhPJJ9mmvRRjhQF9SzGDi3xxODWfZfb3Wrz/IGFTa
	7bVeUMkRCnnvlnHo=
X-Google-Smtp-Source: AGHT+IH5BYgtEVsF3UjuNdxEmc61R/ao7c1/1iBgmrXnG9lSYRtLalmf3eGNlXKix7bxAIso/rU7wQ==
X-Received: by 2002:a17:902:e38a:b0:22e:634b:14cd with SMTP id d9443c01a7336-22e634b171emr74212065ad.39.1746711721364;
        Thu, 08 May 2025 06:42:01 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522911bsm112537925ad.191.2025.05.08.06.41.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:42:00 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v4 16/27] hw/virtio/virtio-mmio: Remove VirtIOMMIOProxy::format_transport_address field
Date: Thu,  8 May 2025 15:35:39 +0200
Message-ID: <20250508133550.81391-17-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The VirtIOMMIOProxy::format_transport_address boolean was only set
in the hw_compat_2_6[] array, via the 'format_transport_address=off'
property. We removed all machines using that array, lets remove
that property, simplifying virtio_mmio_bus_get_dev_path().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 include/hw/virtio/virtio-mmio.h |  1 -
 hw/virtio/virtio-mmio.c         | 15 ---------------
 2 files changed, 16 deletions(-)

diff --git a/include/hw/virtio/virtio-mmio.h b/include/hw/virtio/virtio-mmio.h
index aa492620228..8b19ec2291a 100644
--- a/include/hw/virtio/virtio-mmio.h
+++ b/include/hw/virtio/virtio-mmio.h
@@ -66,7 +66,6 @@ struct VirtIOMMIOProxy {
     uint32_t guest_page_shift;
     /* virtio-bus */
     VirtioBusState bus;
-    bool format_transport_address;
     /* Fields only used for non-legacy (v2) devices */
     uint32_t guest_features[2];
     VirtIOMMIOQueue vqs[VIRTIO_QUEUE_MAX];
diff --git a/hw/virtio/virtio-mmio.c b/hw/virtio/virtio-mmio.c
index 532c67107ba..b7ee115b990 100644
--- a/hw/virtio/virtio-mmio.c
+++ b/hw/virtio/virtio-mmio.c
@@ -752,8 +752,6 @@ static void virtio_mmio_pre_plugged(DeviceState *d, Error **errp)
 /* virtio-mmio device */
 
 static const Property virtio_mmio_properties[] = {
-    DEFINE_PROP_BOOL("format_transport_address", VirtIOMMIOProxy,
-                     format_transport_address, true),
     DEFINE_PROP_BOOL("force-legacy", VirtIOMMIOProxy, legacy, true),
     DEFINE_PROP_BIT("ioeventfd", VirtIOMMIOProxy, flags,
                     VIRTIO_IOMMIO_FLAG_USE_IOEVENTFD_BIT, true),
@@ -815,19 +813,6 @@ static char *virtio_mmio_bus_get_dev_path(DeviceState *dev)
     virtio_mmio_proxy = VIRTIO_MMIO(virtio_mmio_bus->parent);
     proxy_path = qdev_get_dev_path(DEVICE(virtio_mmio_proxy));
 
-    /*
-     * If @format_transport_address is false, then we just perform the same as
-     * virtio_bus_get_dev_path(): we delegate the address formatting for the
-     * device on the virtio-mmio bus to the bus that the virtio-mmio proxy
-     * (i.e., the device that implements the virtio-mmio bus) resides on. In
-     * this case the base address of the virtio-mmio transport will be
-     * invisible.
-     */
-    if (!virtio_mmio_proxy->format_transport_address) {
-        return proxy_path;
-    }
-
-    /* Otherwise, we append the base address of the transport. */
     section = memory_region_find(&virtio_mmio_proxy->iomem, 0, 0x200);
     assert(section.mr);
 
-- 
2.47.1


