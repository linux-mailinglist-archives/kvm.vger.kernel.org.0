Return-Path: <kvm+bounces-10994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EFC01872098
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:43:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60D92B289CF
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A94385C7B;
	Tue,  5 Mar 2024 13:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L0Jjtf+9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62E95915D
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646219; cv=none; b=ARpzgaMn93TfQDAIlT8z53nm5ccZxKVfQsOptGva7H4GO6mzfMTZECtSuelG1N7Nu6++7FAHNh7N2R4j1A8TxQBeVNNN1xtpq+WJUyhltdmwejYTu78Xb4uRRqdAGGJphcyDCbXISe0gI3JI187ELofVuq3n+IKDttyH0n/omLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646219; c=relaxed/simple;
	bh=HYPbOo/3N1o8cYm6RRIsG7OHUi29Bq0eDqkzgN+ePWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BuAayJ6gVkXdRsD+DINJ5gX5pgTtEPVYCPIHg//d1TPITNMohgwjIAlOfqv/KI8KihHdJWV4GyF5wlz10sx76dhAlJNpQciDdPtG2YsmFpi6Nk97PPobzcsdYxg4qTWUTC01Hnc5UPj73AL/TqL/sOR5Cru+oxR5xuV5x0PVB6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L0Jjtf+9; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5132010e5d1so962631e87.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646216; x=1710251016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+MCTA1UltNqL+EA8gVKWQmk1jjDdIIyMkrSTBOV/KA=;
        b=L0Jjtf+9ucoNMxxQaOthomBpPC86GmlXSJd9IIHBb+vStWDmC5FaDEPc6pCBjirmrI
         03OCKVcxCFH+X/g5etOmvHir3Xv/dEviqJd7M7S6tQLIApn6ld8SHDpN0cPGMPN9I0uv
         cX5btc2Cin0zR7iL1oKPJNPLQYDtEQ9mI48LztMh4QrQ8sLKH2xlF2hy5xMIscdx3c6x
         qArz82pI4D809qYW8Jx8oGiJDPktlmOoKTrR7YbkCxPpjZEuGZubhmyI2k+8GVE8PIm4
         1KoIQrJzCBN9Q8Y8tBSAvETTBeK+xdQnz8MkAzioR0ASaIC9lo+PYkCSRZa1RSlrgeQw
         +SFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646216; x=1710251016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8+MCTA1UltNqL+EA8gVKWQmk1jjDdIIyMkrSTBOV/KA=;
        b=oCNZaYcmvk79LZI2qpGo/IkweRzPl9CI6nRlvufLYEIh+a/STEOvPhZccQqzFPLC1c
         rODnyqGD2hATH7U8Q8PyC3BhL5eXzXLSwDezT+jF9UQbXGUpxym4+Hl7dbzJUgFgMGjl
         ZPZyTZcfiZH1/LPbgJ2A1iwYwd6VxR0mZ3hmtZvsujY0/Q8oyu5UAxBVqUqAvpM7fNFx
         LWdhYMNhi/6f4IITHQWtsrNPwzVG1ndxuxf6OMy9zuDJ38VYcV8driTnXYJ8DLrJi0fn
         cUobFAYOYS6W9AYvSGmCvXHF7CZHu1L2rZCpnIZNP6wcD845Tz/AyOdrM9TTfV21nXL1
         F70w==
X-Forwarded-Encrypted: i=1; AJvYcCXXd8GQ69OHEKaNgn8AG014MNDU8EXmvI8RyB/MM0Rvm096UdsjQUDeBKXOmW87rW1gnSY6Rc66jmBs33S7xPVsUkJS
X-Gm-Message-State: AOJu0Yzf4eo2qYmr7cUHqPimAiP4+R0rchoXjFiOvAyAHdaCIhaoAzSY
	I9hwId2PGDCO6nj1EJPCZPn82uSRfDlw3E+esZOEE9YMEdEjpoU2+wTBxbFZ3Vo=
X-Google-Smtp-Source: AGHT+IHpNwIWn9dU253fZ8k5m2DWd3SEtuggzOllzPMD9VtxMkKcCh3wswwtA70e6fwn1H/OqFetiA==
X-Received: by 2002:a05:6512:2028:b0:513:177e:4254 with SMTP id s8-20020a056512202800b00513177e4254mr1162168lfs.14.1709646216124;
        Tue, 05 Mar 2024 05:43:36 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id qw28-20020a1709066a1c00b00a381ca0e589sm6032584ejc.22.2024.03.05.05.43.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:43:35 -0800 (PST)
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
	Peter Maydell <peter.maydell@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Song Gao <gaosong@loongson.cn>,
	Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	qemu-arm@nongnu.org,
	qemu-ppc@nongnu.org
Subject: [PATCH-for-9.1 10/18] hw/mem/pc-dimm: Remove legacy_align argument from pc_dimm_pre_plug()
Date: Tue,  5 Mar 2024 14:42:12 +0100
Message-ID: <20240305134221.30924-11-philmd@linaro.org>
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

'legacy_align' is always NULL, remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/mem/pc-dimm.h | 3 +--
 hw/arm/virt.c            | 2 +-
 hw/i386/pc.c             | 2 +-
 hw/loongarch/virt.c      | 2 +-
 hw/mem/pc-dimm.c         | 6 ++----
 hw/ppc/spapr.c           | 2 +-
 6 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/include/hw/mem/pc-dimm.h b/include/hw/mem/pc-dimm.h
index 322bebe555..fe0f3ea963 100644
--- a/include/hw/mem/pc-dimm.h
+++ b/include/hw/mem/pc-dimm.h
@@ -66,8 +66,7 @@ struct PCDIMMDeviceClass {
     void (*unrealize)(PCDIMMDevice *dimm);
 };
 
-void pc_dimm_pre_plug(PCDIMMDevice *dimm, MachineState *machine,
-                      const uint64_t *legacy_align, Error **errp);
+void pc_dimm_pre_plug(PCDIMMDevice *dimm, MachineState *machine, Error **errp);
 void pc_dimm_plug(PCDIMMDevice *dimm, MachineState *machine);
 void pc_dimm_unplug(PCDIMMDevice *dimm, MachineState *machine);
 #endif
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 0af1943697..9a6df69642 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2720,7 +2720,7 @@ static void virt_memory_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
         return;
     }
 
-    pc_dimm_pre_plug(PC_DIMM(dev), MACHINE(hotplug_dev), NULL, errp);
+    pc_dimm_pre_plug(PC_DIMM(dev), MACHINE(hotplug_dev), errp);
 }
 
 static void virt_memory_plug(HotplugHandler *hotplug_dev,
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 0950abcc2a..b4736822e4 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1325,7 +1325,7 @@ static void pc_memory_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
         return;
     }
 
-    pc_dimm_pre_plug(PC_DIMM(dev), MACHINE(hotplug_dev), NULL, errp);
+    pc_dimm_pre_plug(PC_DIMM(dev), MACHINE(hotplug_dev), errp);
 }
 
 static void pc_memory_plug(HotplugHandler *hotplug_dev,
diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
index 1e98d8bda5..2e8234affd 100644
--- a/hw/loongarch/virt.c
+++ b/hw/loongarch/virt.c
@@ -1024,7 +1024,7 @@ static bool memhp_type_supported(DeviceState *dev)
 static void virt_mem_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
                                  Error **errp)
 {
-    pc_dimm_pre_plug(PC_DIMM(dev), MACHINE(hotplug_dev), NULL, errp);
+    pc_dimm_pre_plug(PC_DIMM(dev), MACHINE(hotplug_dev), errp);
 }
 
 static void virt_machine_device_pre_plug(HotplugHandler *hotplug_dev,
diff --git a/hw/mem/pc-dimm.c b/hw/mem/pc-dimm.c
index 37f1f4ccfd..836384a90f 100644
--- a/hw/mem/pc-dimm.c
+++ b/hw/mem/pc-dimm.c
@@ -44,8 +44,7 @@ static MemoryRegion *pc_dimm_get_memory_region(PCDIMMDevice *dimm, Error **errp)
     return host_memory_backend_get_memory(dimm->hostmem);
 }
 
-void pc_dimm_pre_plug(PCDIMMDevice *dimm, MachineState *machine,
-                      const uint64_t *legacy_align, Error **errp)
+void pc_dimm_pre_plug(PCDIMMDevice *dimm, MachineState *machine, Error **errp)
 {
     Error *local_err = NULL;
     int slot;
@@ -70,8 +69,7 @@ void pc_dimm_pre_plug(PCDIMMDevice *dimm, MachineState *machine,
                             &error_abort);
     trace_mhp_pc_dimm_assigned_slot(slot);
 
-    memory_device_pre_plug(MEMORY_DEVICE(dimm), machine, legacy_align,
-                           errp);
+    memory_device_pre_plug(MEMORY_DEVICE(dimm), machine, NULL, errp);
 }
 
 void pc_dimm_plug(PCDIMMDevice *dimm, MachineState *machine)
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 55263f0815..32fdca2bd4 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -3639,7 +3639,7 @@ static void spapr_memory_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
         return;
     }
 
-    pc_dimm_pre_plug(dimm, MACHINE(hotplug_dev), NULL, errp);
+    pc_dimm_pre_plug(dimm, MACHINE(hotplug_dev), errp);
 }
 
 struct SpaprDimmState {
-- 
2.41.0


