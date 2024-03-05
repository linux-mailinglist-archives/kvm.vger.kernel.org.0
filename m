Return-Path: <kvm+bounces-10995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ECC987209A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:43:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B9591C25D98
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4151F85C79;
	Tue,  5 Mar 2024 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M6QZ141r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADFF5676A
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646226; cv=none; b=drHL5DSHZ9hPB0j0m03LOyWM+O+i3gCx5QtmUbzE0g9Om069LBGtk+WP+aDz0nd6KAoX+7WkCyM8ecLad2CSwQ6mOK3HviYqzwhI7Rkbm1fm13Wxkv8JrMNaeruw8VD8fSg1BZrL8vaH59BpivLS1bjq6wFMgBx5kGo778mrJQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646226; c=relaxed/simple;
	bh=6QttgOGxfK0QTwdzRRqqZhwIabBBY2piRzr6bQ2TcwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c63LzrLJ6yAG71adcfcvtUtydCaLjKH9HetOZ3nWaj7/g2NwRzUtwsrf8FhZ98aHc5h/WgA9vkBio03De7WF7OMGZqWKMYTVKUA0/u0jFg9/WsEH0tBWa06Xbl5+qpipeeq3KcbLDC3yJ4xSUCjIGZx6qRs9BpuloRF6FImfFKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=M6QZ141r; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a44d084bfe1so412364766b.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646223; x=1710251023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x8AzlbW71FoZEbM9SW64EPE4l+5scV2AZFmKYcyJfIM=;
        b=M6QZ141rgB0GtrtBkW/LYEjgFvdweipAzfVnoqhODqLhf8anyNzvQgB5gA0I7nAFpw
         L+kr74I6qFEbb00+Q1NADdtbVIzYtFTV+tmREU8pe7eDoOpmIkKj9u7/EgB0jdSfA1EC
         qvyRlChCJI0WJsqx9U7a6MwJ40SDtfuVTzUbQ0t8/jiKN361gOT+9Jy7zFgs4wFoPHz+
         u2lZ8mbKOiAJbAnDEqJAnfyrfEFHoCPpH3Y0NLJBD0rm+sVigZEY1zz6ACBxTkttczmL
         dgiHsAtl38FCF7aMf3ugnutry/EPthC7On88AMR28ZZ8P2hln7LIhVMCK3K2rkOYmBh4
         Ox0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646223; x=1710251023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x8AzlbW71FoZEbM9SW64EPE4l+5scV2AZFmKYcyJfIM=;
        b=DQ7CY2tAp3YgBQAfUx8e4uWP1Yrb1JppMuF1xaxpYQ1hYUmZu6E6BSxX2/AK+sAuDD
         1czSOvsmA14EGionDzK11fD0tTfoFa9J9YX45UWejfmUhho8lKOOc0AitMy9obrPK0Ay
         oRxc5PWJJbVJs+ala8Lr+LLDX5y3JU7C+fdV0hcGChWvMINFs6zmJNVwNXlXgS2l/n32
         JPCu1ngdoa44eGA/fubEW68g2yfhNLTJvOb9dJZrZU+ikurk3tTrTEn2oqO3SghEVVh8
         O97/XaJxVZsk4te9hNJY4lCqztTuYmS7uykiSJg3lVBSatXdHoYy3u3YKhrdnK0NCRQm
         iKEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVa+bS3KOw9/C/pluamFH8s/F0aZX3A1F+/B3HlXPJ0zRHGuc0v740u9csXo8w00kjNCu4psSJAWsStc46TfKlUoQnv
X-Gm-Message-State: AOJu0Yyu9J0K+NkZcjZLLEKpgom7x1YzF+j7tOcz06KiMjMJbPON7Zwe
	Py0WbB6j0kWr7KI/iIBiQwXcaGw5qzOw/GfZuGhu6vp91/kx06NYFNJHsW453fA=
X-Google-Smtp-Source: AGHT+IF/fc6fgxSnTTF8ZveiPTSNL1c4g7TqI8j5ZSILt7XGF8o4gWsr5K5gYzg0J7LmS56WjirHBg==
X-Received: by 2002:a17:906:4712:b0:a45:84e7:b265 with SMTP id y18-20020a170906471200b00a4584e7b265mr2910138ejq.7.1709646223113;
        Tue, 05 Mar 2024 05:43:43 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id f27-20020a170906085b00b00a44ef54b6b6sm3649227ejd.58.2024.03.05.05.43.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:43:42 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	devel@lists.libvirt.org,
	David Hildenbrand <david@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: [PATCH-for-9.1 11/18] hw/mem/memory-device: Remove legacy_align from memory_device_pre_plug()
Date: Tue,  5 Mar 2024 14:42:13 +0100
Message-ID: <20240305134221.30924-12-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240305134221.30924-1-philmd@linaro.org>
References: <20240305134221.30924-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

'legacy_align' is always NULL, remove it, simplifying
memory_device_pre_plug().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/mem/memory-device.h |  2 +-
 hw/i386/pc.c                   |  3 +--
 hw/mem/memory-device.c         | 12 ++++--------
 hw/mem/pc-dimm.c               |  2 +-
 hw/virtio/virtio-md-pci.c      |  2 +-
 5 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/include/hw/mem/memory-device.h b/include/hw/mem/memory-device.h
index e0571c8a31..c0a58087cc 100644
--- a/include/hw/mem/memory-device.h
+++ b/include/hw/mem/memory-device.h
@@ -169,7 +169,7 @@ uint64_t get_plugged_memory_size(void);
 unsigned int memory_devices_get_reserved_memslots(void);
 bool memory_devices_memslot_auto_decision_active(void);
 void memory_device_pre_plug(MemoryDeviceState *md, MachineState *ms,
-                            const uint64_t *legacy_align, Error **errp);
+                            Error **errp);
 void memory_device_plug(MemoryDeviceState *md, MachineState *ms);
 void memory_device_unplug(MemoryDeviceState *md, MachineState *ms);
 uint64_t memory_device_get_region_size(const MemoryDeviceState *md,
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index b4736822e4..ea7b05797b 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1393,8 +1393,7 @@ static void pc_hv_balloon_pre_plug(HotplugHandler *hotplug_dev,
 {
     /* The vmbus handler has no hotplug handler; we should never end up here. */
     g_assert(!dev->hotplugged);
-    memory_device_pre_plug(MEMORY_DEVICE(dev), MACHINE(hotplug_dev), NULL,
-                           errp);
+    memory_device_pre_plug(MEMORY_DEVICE(dev), MACHINE(hotplug_dev), errp);
 }
 
 static void pc_hv_balloon_plug(HotplugHandler *hotplug_dev,
diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index e098585cda..a5f279adcc 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -345,7 +345,7 @@ uint64_t get_plugged_memory_size(void)
 }
 
 void memory_device_pre_plug(MemoryDeviceState *md, MachineState *ms,
-                            const uint64_t *legacy_align, Error **errp)
+                            Error **errp)
 {
     const MemoryDeviceClass *mdc = MEMORY_DEVICE_GET_CLASS(md);
     Error *local_err = NULL;
@@ -388,14 +388,10 @@ void memory_device_pre_plug(MemoryDeviceState *md, MachineState *ms,
         return;
     }
 
-    if (legacy_align) {
-        align = *legacy_align;
-    } else {
-        if (mdc->get_min_alignment) {
-            align = mdc->get_min_alignment(md);
-        }
-        align = MAX(align, memory_region_get_alignment(mr));
+    if (mdc->get_min_alignment) {
+        align = mdc->get_min_alignment(md);
     }
+    align = MAX(align, memory_region_get_alignment(mr));
     addr = mdc->get_addr(md);
     addr = memory_device_get_free_addr(ms, !addr ? NULL : &addr, align,
                                        memory_region_size(mr), &local_err);
diff --git a/hw/mem/pc-dimm.c b/hw/mem/pc-dimm.c
index 836384a90f..27919ca45d 100644
--- a/hw/mem/pc-dimm.c
+++ b/hw/mem/pc-dimm.c
@@ -69,7 +69,7 @@ void pc_dimm_pre_plug(PCDIMMDevice *dimm, MachineState *machine, Error **errp)
                             &error_abort);
     trace_mhp_pc_dimm_assigned_slot(slot);
 
-    memory_device_pre_plug(MEMORY_DEVICE(dimm), machine, NULL, errp);
+    memory_device_pre_plug(MEMORY_DEVICE(dimm), machine, errp);
 }
 
 void pc_dimm_plug(PCDIMMDevice *dimm, MachineState *machine)
diff --git a/hw/virtio/virtio-md-pci.c b/hw/virtio/virtio-md-pci.c
index 62bfb7920b..9ec5067662 100644
--- a/hw/virtio/virtio-md-pci.c
+++ b/hw/virtio/virtio-md-pci.c
@@ -37,7 +37,7 @@ void virtio_md_pci_pre_plug(VirtIOMDPCI *vmd, MachineState *ms, Error **errp)
      * First, see if we can plug this memory device at all. If that
      * succeeds, branch of to the actual hotplug handler.
      */
-    memory_device_pre_plug(md, ms, NULL, &local_err);
+    memory_device_pre_plug(md, ms, &local_err);
     if (!local_err && bus_handler) {
         hotplug_handler_pre_plug(bus_handler, dev, &local_err);
     }
-- 
2.41.0


