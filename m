Return-Path: <kvm+bounces-10997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7BCF87209D
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:44:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBA791C25DD4
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D34DB85C6F;
	Tue,  5 Mar 2024 13:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cyzhfUnj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561B15676A
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646240; cv=none; b=ndDE/1FOhaYF+IfNVuXDbSKsxJOyKUzVGOdyMZ3ojnNf6tUkYS8VeeUQW4R6NvUXc4YX8aJcsUU4W3JExNmHpkEIqiHFDjlyOmEIBEIlGAv2YstpP+g8dqQqzoEn4MgZ9um50952RzvT7lOrvPAMCEBEzFymNHPPTmqJkb/kRJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646240; c=relaxed/simple;
	bh=sH4KuwcpzniDQwunEctpD88PSfP4NA6XfPjZmuVUqas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+l19q+uq2yBkRUhVhmgz4aEBvBepGYmbDil2j7jBmFG1mzQaiCHGwpymLVaRk56F8fI45T623eBPWAfh8NLFqRS2nngrGUxUEfcIL4POLmE+RHfcGXcw3vgwYgUOHFDmtdSXf/0PKnQn27dHz21nrlsA7zq0Q992DlYbh4gnro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cyzhfUnj; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-412e2dfa502so5769785e9.2
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646237; x=1710251037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5TGU952DKVM2tYEewPZVbKhW/aUuUpfwS5FrOa58Xf0=;
        b=cyzhfUnjgWm9vSCNnN/Fpl+XoS4jp5OhHKDptK/7Etd8cQRkrjQccyfAe1gea4z+cQ
         jFjjP78q1iJ73/EfMYZ+zHYhHRS1av4c1TJICp9pto3ztKt449ghVL8wT8xMwl7qS091
         p9por8s9Gh/yF99VR2ernU21JceO6Vsu5xCx9JtpCIQz2wgRftclPz3DBXyAzywJqtIc
         j5Oq1hwSHxYZlLFItsJKdtfJcuEN6CW8eCM2ew5+fqroJzJO2BBfp6nHkvPkJitL6u4H
         WT9bzEBxOTkXkz5e7h9cx8pntGFRhOb9dmQwTn8HNn9nrX6BbUB9NG7fPxreyOXLBGoI
         QNvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646237; x=1710251037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5TGU952DKVM2tYEewPZVbKhW/aUuUpfwS5FrOa58Xf0=;
        b=gD9KoMhcP+UkeLkjBsHs5XIV6Coidc4Wi7kR1aGDujmM2nMM1rRZHwkvzG2fFp/rhE
         yhlnViKGpdv+qbUBO8+oLQ20CAvtf8Bohbpkcta5yt1zmWjd7B4Sa3k3ZNPvxn/H8qrk
         mNNcinu2/9lClFkT8bf1ANfiSeAC0x1XOA8Ksyoe/ZZ1cQLeaEi9AevysnHuIcOAvXTB
         8ZZVZfifJ20H2Amd5MrVeobDkqXsX7Cs89UBJ9raAZX46invTGDg4BNNfBu3qLwMFhMa
         wqmrDm6fJMtkOJ5lX5BQsQymc0cX8uBvdtIUdCGBjFiAzMypeBvlVggvDgKVaQ3RK/1P
         jgew==
X-Forwarded-Encrypted: i=1; AJvYcCVX+IYZMjD2lscZCHVxKP3JL/gJ/ZG4mB6q3sE5vqYIXQagMxl0VX3SI8Ft7sCaJICnqR4MPYUSSQDznnF//s6B3vKw
X-Gm-Message-State: AOJu0YxQBvRtNRuycr6SERFNWOYh0jo/iDjBO05cK/a3hUqZ33/WjI2h
	81d0WU7G8cDVzbTN8Ws/3sxX5IIPR6hddN0cCHpfL20MEk2VPzVDW3/CvOHJyHA=
X-Google-Smtp-Source: AGHT+IGC2D2rmKYCMfxA0oHHpGajfv51gJDo/dA1KdNcDkrWRiY8zzCZcuiUCdaP0oLhW6EOx+KtAg==
X-Received: by 2002:a05:600c:1d17:b0:412:e993:d5da with SMTP id l23-20020a05600c1d1700b00412e993d5damr2100311wms.32.1709646236748;
        Tue, 05 Mar 2024 05:43:56 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id o17-20020a05600c4fd100b00412d68dbf75sm10917201wmq.35.2024.03.05.05.43.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:43:56 -0800 (PST)
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
	Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH-for-9.1 13/18] hw/i386/pc: Remove PCMachineClass::resizable_acpi_blob
Date: Tue,  5 Mar 2024 14:42:15 +0100
Message-ID: <20240305134221.30924-14-philmd@linaro.org>
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

PCMachineClass::resizable_acpi_blob was only used by the
pc-i440fx-2.2 machine, which got removed. It is now always
true. Remove it, simplifying acpi_build().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/i386/pc.h | 3 ---
 hw/i386/acpi-build.c | 9 ---------
 hw/i386/pc.c         | 1 -
 3 files changed, 13 deletions(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index f7a5f4f283..be3a58c972 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -124,9 +124,6 @@ struct PCMachineClass {
     /* create kvmclock device even when KVM PV features are not exposed */
     bool kvmclock_create_always;
 
-    /* resizable acpi blob compat */
-    bool resizable_acpi_blob;
-
     /*
      * whether the machine type implements broken 32-bit address space bound
      * check for memory.
diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index 8c7fad92e9..a56ac8dc90 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -2688,15 +2688,6 @@ void acpi_build(AcpiBuildTables *tables, MachineState *machine)
      * All this is for PIIX4, since QEMU 2.0 didn't support Q35 migration.
      */
     /* Make sure we have a buffer in case we need to resize the tables. */
-    if ((tables_blob->len > ACPI_BUILD_TABLE_SIZE / 2) &&
-        !pcmc->resizable_acpi_blob) {
-        /* As of QEMU 2.1, this fires with 160 VCPUs and 255 memory slots.  */
-        warn_report("ACPI table size %u exceeds %d bytes,"
-                    " migration may not work",
-                    tables_blob->len, ACPI_BUILD_TABLE_SIZE / 2);
-        error_printf("Try removing CPUs, NUMA nodes, memory slots"
-                     " or PCI bridges.\n");
-    }
     acpi_align_size(tables_blob, ACPI_BUILD_TABLE_SIZE);
 
     acpi_align_size(tables->linker->cmd_blob, ACPI_BUILD_ALIGN_SIZE);
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index a762df7686..8139cd4a7d 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1768,7 +1768,6 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     pcmc->acpi_data_size = 0x20000 + 0x8000;
     pcmc->pvh_enabled = true;
     pcmc->kvmclock_create_always = true;
-    pcmc->resizable_acpi_blob = true;
     x86mc->apic_xrupt_override = true;
     assert(!mc->get_hotplug_handler);
     mc->get_hotplug_handler = pc_get_hotplug_handler;
-- 
2.41.0


