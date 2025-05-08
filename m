Return-Path: <kvm+bounces-45887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC417AAFBE5
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFD3F16FB16
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4652236E1;
	Thu,  8 May 2025 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GJFYxXPm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE40199E89
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711950; cv=none; b=THWmdvBCwgH39BNlLmnF5NY7jRgN13Cn3RmTu37lBSjTmV1qz9tvzv5XTTemlYVO4liTTYCU0sCMx/oYBa62J0VhYh/Fm8PhGF41f4fUXIL6k1tS8SOJLvaIKnmmv+teipdVZZ7Fyimpi0hBpsrEhTCNLwwyPjjsIeWnbqRAxB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711950; c=relaxed/simple;
	bh=HcXBHa06owlgBaF3fNQf3HAJLIzHun8O3opbJHCFHE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bnlPR0VCs1EZLSvZsnlR5bwqnWLoYcgiUHcK8wXQtbEHAuXzhYdQAtOoZdwaRlM3BbdNPVlS1GXbnyhLDj6OVdxHZWKCiHJjsxhXovBEWRGomjunib8CXPZM7K/4IrovLJsgVOuK0cv+fN+TfH/JEKfgwABSmAuyjbcMWtMwtHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GJFYxXPm; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7410c18bb00so508647b3a.3
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711948; x=1747316748; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ns6abkUGaM6ukyij9Yk70LzU+Vns27nmI4rpIretkkk=;
        b=GJFYxXPmq+c7gpxxn24L8TMHgik0yZ14AlNn0lxltLticF0TU5gHsr7/P5AACc9Hf3
         8u6TzZT6n3X6RvFDyC90RYiNFXT3Y6Uy29HxpJqiwzyxNBjS7/vuPM3TDn50Guky7Cm/
         XFy1tC9dx3hLH2u5G0o6SMGw4A27YYxwo3Swzs8RnBOoExxGVfOYgT4e4uDjDtCDqy9S
         YmfvRrJYVjUoWe1OnahwP+DJi2ZCVEidOSv+9KhwtyTSZq82lVwCmJLrWC/RRyubasxp
         tSsV2ZPC+2r11kXRZVm+GFnBpaqQx1YtkGYxpBXD6qrbmsy4MtHl2IvHJC2HPl/zMpcO
         g7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711948; x=1747316748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ns6abkUGaM6ukyij9Yk70LzU+Vns27nmI4rpIretkkk=;
        b=ALziPOQW7G8A9VgBEH6GaYj6nkbRt4B9+OTN0W0aAVYKDIdc7JXsNTjn3JrwbNF95H
         KG6dlqpmKdcfCIUxfZVBTILUlHEAfz/+FMwoNM/V327XWJJo2VvVxeHYf/Q62iUC9KbZ
         pHA2/c+2wdjzTaFxdktLAEYBQXLQmAgSN2GMrLClv0bvoHeecfe8VV2XQGVIKkoMF9VV
         mhOBRnpA2nykil5yGjxCrld4Idu0UDrVp+MDXOBs6Z4vGMRsObXubzni2maSOP4E3gql
         jFnxUOxF05cuubXhG9gFl2IOJoGdiF0EBmH8WJCov2WNnukBLYOj6cnzpeQNkm1GXoLy
         X2Ww==
X-Forwarded-Encrypted: i=1; AJvYcCXugMWKY5Ds7XZuGcC+hAdffoTy5aoc5PB/n162h8Vn5Al4II+jY8CEmoB+9dd23HgHs1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOwRCNDm6VQ0t4qV7MUPetow44/VUBcwGRuRNXvgC5o1YfeGND
	mVem4pg/uJbbN5c/Gnubx8heIrud7Dc2KKzE789Rl2Ccv/1a+AksQO3qXd93dPU=
X-Gm-Gg: ASbGncuYrRUoW0BXd0Gc6MIVCfQ/7kq+/OHYX5Ns49fqHSBqzMC07oGoX0QWkIHa7mY
	7AWuXfssL2X802iKeXSTahw5Xyx9Tzzk+Z0P/IUH82Iqkiwq3luWVV8YNsDr7P0BkNnyL2jz23f
	PrHThnpBp23u9F4azUqOUmh95QI0pkQ8dJXEFlMSVM+0AOYeKXNQTf63ISs8Fv2W9W0UWVPqMct
	Xx6G1w4h231TZkWsvlN2rWgQfYs4/VFPzOMHPmHxMUwVqMaOh+9MbL7cZwtobbdLcLq2XWeG4C+
	4+kwmfNHd9lIF61sw2upXYpeEsJYxTJ4jBzpNOkBWXLsmAZiIAEh6QS+3cWprRj9o4ZtdubJseo
	LmQWDOcyyAQePPsc=
X-Google-Smtp-Source: AGHT+IEnO+sngRS5wIqF0he33Fpo8ZvEfqldkdJOaUMWkhexbxVM0HjmJCofWNDDAj5rwpOOd6Q5/A==
X-Received: by 2002:a05:6a00:1308:b0:740:a879:4f7b with SMTP id d2e1a72fcca58-740a8794fcamr6118097b3a.18.1746711948529;
        Thu, 08 May 2025 06:45:48 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7405906372fsm13690156b3a.148.2025.05.08.06.45.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:45:48 -0700 (PDT)
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
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH v4 26/27] hw/char/virtio-serial: Do not expose the 'emergency-write' property
Date: Thu,  8 May 2025 15:35:49 +0200
Message-ID: <20250508133550.81391-27-philmd@linaro.org>
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

The VIRTIO_CONSOLE_F_EMERG_WRITE feature bit was only set
in the hw_compat_2_7[] array, via the 'emergency-write=off'
property. We removed all machines using that array, lets remove
that property. All instances have this feature bit set and
it can not be disabled. VirtIOSerial::host_features mask is
now unused, remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/virtio/virtio-serial.h | 2 --
 hw/char/virtio-serial-bus.c       | 9 +++------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/hw/virtio/virtio-serial.h b/include/hw/virtio/virtio-serial.h
index d87c62eab7a..e6ceacec309 100644
--- a/include/hw/virtio/virtio-serial.h
+++ b/include/hw/virtio/virtio-serial.h
@@ -185,8 +185,6 @@ struct VirtIOSerial {
     struct VirtIOSerialPostLoad *post_load;
 
     virtio_serial_conf serial;
-
-    uint64_t host_features;
 };
 
 /* Interface to the virtio-serial bus */
diff --git a/hw/char/virtio-serial-bus.c b/hw/char/virtio-serial-bus.c
index eb79f5258b6..cfc8fa42186 100644
--- a/hw/char/virtio-serial-bus.c
+++ b/hw/char/virtio-serial-bus.c
@@ -557,7 +557,7 @@ static uint64_t get_features(VirtIODevice *vdev, uint64_t features,
 
     vser = VIRTIO_SERIAL(vdev);
 
-    features |= vser->host_features;
+    features |= BIT_ULL(VIRTIO_CONSOLE_F_EMERG_WRITE);
     if (vser->bus.max_nr_ports > 1) {
         virtio_add_feature(&features, VIRTIO_CONSOLE_F_MULTIPORT);
     }
@@ -587,8 +587,7 @@ static void set_config(VirtIODevice *vdev, const uint8_t *config_data)
     VirtIOSerialPortClass *vsc;
     uint8_t emerg_wr_lo;
 
-    if (!virtio_has_feature(vser->host_features,
-        VIRTIO_CONSOLE_F_EMERG_WRITE) || !config->emerg_wr) {
+    if (!config->emerg_wr) {
         return;
     }
 
@@ -1039,7 +1038,7 @@ static void virtio_serial_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    if (!virtio_has_feature(vser->host_features,
+    if (!virtio_has_feature(vdev->host_features,
                             VIRTIO_CONSOLE_F_EMERG_WRITE)) {
         config_size = offsetof(struct virtio_console_config, emerg_wr);
     }
@@ -1155,8 +1154,6 @@ static const VMStateDescription vmstate_virtio_console = {
 static const Property virtio_serial_properties[] = {
     DEFINE_PROP_UINT32("max_ports", VirtIOSerial, serial.max_virtserial_ports,
                                                   31),
-    DEFINE_PROP_BIT64("emergency-write", VirtIOSerial, host_features,
-                      VIRTIO_CONSOLE_F_EMERG_WRITE, true),
 };
 
 static void virtio_serial_class_init(ObjectClass *klass, const void *data)
-- 
2.47.1


