Return-Path: <kvm+bounces-45889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91539AAFBEB
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:46:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B43384C281D
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D370322D9F4;
	Thu,  8 May 2025 13:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EmmrF1sJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC3719309C
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711974; cv=none; b=kOEGw0Ac7aY3Ez+t95wwdiuEFVW5DQecOabc9NLRDi9srpjZKaXvkXaBHYTi5DvTtHj8Oho7WPBXjRYJRBbF4fkwyz+pEiuzzO3IWQ8DP+DT7rCnDkC04gKkTwLUqEQ8YD1VV/ctSQgwJO1TqhGcKoZ2f5Tg9kTTA1LejK+Pfjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711974; c=relaxed/simple;
	bh=Ex2GpTr6GoUbDVEbeTQuvclJK0ug9LhPdAET+OSeF9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j/b7b4m8QyLHLB5YDLNN8k1CegSbn0sxWjIvLgzZM6T+KPU2jzKj0xDnvaX8j9HNddwstMn6wYqLhWp71BESeP0zDHFnQqgW47k0RfG+E5tttQZ599kAfWlxGGEnqU/UVInAdO7V1MINXN+eEQinlGtOjjkgLMxNud4woRMR/xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EmmrF1sJ; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-736ad42dfd6so788477b3a.3
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711972; x=1747316772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dAEnpROpQK6DxM6uJJQ1bpWzbrmSzQalAkAVB3r0tgU=;
        b=EmmrF1sJ08H7xxF5OcamGdHBn3q78Doo/E+vgGa1uNZAiHQ0SfMjbqWE/q/qU+lyQN
         hiFbZGsBsEzVVCJx28+DlbnZhbt3GWzTf4fKLe6W2ELOxB682YH48NCNQwHzXmnB1L++
         u87V7MwmLS/wUlPqu4ZdTMTY1WCA6sHsX85OZE9P3DA0NRah9IM4IyAzfJB4C7m1fCXx
         X2NEacj6+fv2QsIVIkQzaxHAoVkeRSgQpH7CNxiKV1ZwK+QlSvuWj5xjXgrA+5BIpT2b
         PDB13SRVmri8w1erV8xKtfX7ICmLGnmk4FfNIxVscsWtUO99rulIwDeFlLcDCckLgDoK
         sDiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711972; x=1747316772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dAEnpROpQK6DxM6uJJQ1bpWzbrmSzQalAkAVB3r0tgU=;
        b=HjBff35Wlkxi4KFLtoiGKFwEEtG0g5vj3V0jm3bLiKQpxM7ZQyrcAAWV32XwL4TPq7
         tgHWIaogoi931EA7WIU0SKJgoKWwm6frHLDNAhnrLWxGHR4lvuGj8ChtGjZSxwqBgTpL
         ToCEVECEbl2UBWOhbzJOyLefQHtckpdjzHT7PemR6oQM+clg+YazKG1YEZ4Q5Y/M4B6g
         ELybK+CmgYk+ugRf+9S95gpmeSkVCDRWwMZSkJ946FQZ/fhot9cwBFWdI/o0E4KpjAm6
         ewURbbigVumMyXwMs7/SdptEubtfZeFAX5FEuC9PY5kWeSIlBBxtHpJdt9ju6o66Je7H
         7CmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVA0oBclScB4FXIQqFD7tGMZIBD6nwN7mazmgdHTl9DWOd8osf9JjAt28OGgSQI7Bwwji8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIJ5fUhVd7/Hj8eMdoBTfaD7ojuHmVQyo2nqHZpChOut1HFhun
	V5j2SKHC5x4A2ofTLZ5NHYmLKhyWl5KjfODNhdCHITLYHjaELTVZaOBIjNjjvLQ=
X-Gm-Gg: ASbGncvbnS0wvMjtZ07z3ORkDwHvsHCvUTKSpdoL9eo6m3lt+fxLmQmd+/fUDmqYurX
	dDZ8tvLA9LycUemNgQYptxvh7AZv6M+1fqhTWyqCnBDUBRLO8G0NUqZ5Z41ePVKYKRpXas+j1No
	W5lH/t9un0aYJIHUVovkPCgJOMuYto47sJQqZVYYxktF6GYcC74lHZsH8MuH9w7pssRCqx1njGO
	otxjGl258ZT+VO4P5pcPrRNadGngFTrnVJ65rDIVbMKlC9/ejCeHFyjpvYJIQmU82apoZzckcti
	i+aDlyJfr2Loiar150h3oAX3zSiP6wai8J8oFHAqi9/bGw7luI68YPQ5QEr/TXf9l1tahbbG+/P
	6brOfheV+WTc+VH0=
X-Google-Smtp-Source: AGHT+IG9WzoCZnHzGx/rhe5MQGTbfwj2jk9eAlMQ107yUfErvTrwEaQ0R1H/OfqPr8whvcSNPiejCQ==
X-Received: by 2002:a05:6a20:9f8f:b0:1f5:5ca4:2744 with SMTP id adf61e73a8af0-2148ba256e3mr9499152637.17.1746711972638;
        Thu, 08 May 2025 06:46:12 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058d7a397sm13221110b3a.28.2025.05.08.06.45.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:46:12 -0700 (PDT)
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
	Mark Cave-Ayland <mark.caveayland@nutanix.com>
Subject: [PATCH v4 27/27] hw/virtio/virtio-pci: Remove VIRTIO_PCI_FLAG_PAGE_PER_VQ definition
Date: Thu,  8 May 2025 15:35:50 +0200
Message-ID: <20250508133550.81391-28-philmd@linaro.org>
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

VIRTIO_PCI_FLAG_PAGE_PER_VQ was only used by the hw_compat_2_7[]
array, via the 'page-per-vq=on' property. We removed all
machines using that array, lets remove all the code around
VIRTIO_PCI_FLAG_PAGE_PER_VQ (see commit 9a4c0e220d8 for similar
VIRTIO_PCI_FLAG_* enum removal).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
---
 include/hw/virtio/virtio-pci.h |  1 -
 hw/display/virtio-vga.c        | 10 ----------
 hw/virtio/virtio-pci.c         |  7 +------
 3 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/include/hw/virtio/virtio-pci.h b/include/hw/virtio/virtio-pci.h
index 9838e8650a6..8abc5f8f20d 100644
--- a/include/hw/virtio/virtio-pci.h
+++ b/include/hw/virtio/virtio-pci.h
@@ -33,7 +33,6 @@ enum {
     VIRTIO_PCI_FLAG_BUS_MASTER_BUG_MIGRATION_BIT,
     VIRTIO_PCI_FLAG_USE_IOEVENTFD_BIT,
     VIRTIO_PCI_FLAG_MODERN_PIO_NOTIFY_BIT,
-    VIRTIO_PCI_FLAG_PAGE_PER_VQ_BIT,
     VIRTIO_PCI_FLAG_ATS_BIT,
     VIRTIO_PCI_FLAG_INIT_DEVERR_BIT,
     VIRTIO_PCI_FLAG_INIT_LNKCTL_BIT,
diff --git a/hw/display/virtio-vga.c b/hw/display/virtio-vga.c
index 40e60f70fcd..83d01f089b5 100644
--- a/hw/display/virtio-vga.c
+++ b/hw/display/virtio-vga.c
@@ -141,16 +141,6 @@ static void virtio_vga_base_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
                                VIRTIO_GPU_SHM_ID_HOST_VISIBLE);
     }
 
-    if (!(vpci_dev->flags & VIRTIO_PCI_FLAG_PAGE_PER_VQ)) {
-        /*
-         * with page-per-vq=off there is no padding space we can use
-         * for the stdvga registers.  Make the common and isr regions
-         * smaller then.
-         */
-        vpci_dev->common.size /= 2;
-        vpci_dev->isr.size /= 2;
-    }
-
     offset = memory_region_size(&vpci_dev->modern_bar);
     offset -= vpci_dev->notify.size;
     vpci_dev->notify.offset = offset;
diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index 7c965771907..4e0d4bda6ed 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -314,12 +314,9 @@ static bool virtio_pci_ioeventfd_enabled(DeviceState *d)
     return (proxy->flags & VIRTIO_PCI_FLAG_USE_IOEVENTFD) != 0;
 }
 
-#define QEMU_VIRTIO_PCI_QUEUE_MEM_MULT 0x1000
-
 static inline int virtio_pci_queue_mem_mult(struct VirtIOPCIProxy *proxy)
 {
-    return (proxy->flags & VIRTIO_PCI_FLAG_PAGE_PER_VQ) ?
-        QEMU_VIRTIO_PCI_QUEUE_MEM_MULT : 4;
+    return 4;
 }
 
 static int virtio_pci_ioeventfd_assign(DeviceState *d, EventNotifier *notifier,
@@ -2348,8 +2345,6 @@ static const Property virtio_pci_properties[] = {
                     VIRTIO_PCI_FLAG_BUS_MASTER_BUG_MIGRATION_BIT, false),
     DEFINE_PROP_BIT("modern-pio-notify", VirtIOPCIProxy, flags,
                     VIRTIO_PCI_FLAG_MODERN_PIO_NOTIFY_BIT, false),
-    DEFINE_PROP_BIT("page-per-vq", VirtIOPCIProxy, flags,
-                    VIRTIO_PCI_FLAG_PAGE_PER_VQ_BIT, false),
     DEFINE_PROP_BIT("ats", VirtIOPCIProxy, flags,
                     VIRTIO_PCI_FLAG_ATS_BIT, false),
     DEFINE_PROP_BIT("x-ats-page-aligned", VirtIOPCIProxy, flags,
-- 
2.47.1


