Return-Path: <kvm+bounces-14866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A628A7416
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A156D1F21989
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F72113775A;
	Tue, 16 Apr 2024 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ix6gwnsB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E1F13473F
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 19:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294098; cv=none; b=XGb7CpHh3e9hyTAPNmDnGm17z/5z1nIMW3ZWQ7GK/3fQb+XLZOYyE0fHe/FN5QMMzMkp7KqxYJS+AD9QzRl1dQrI7yamKLO3+jWMmVs8LD6juR3jvoe5caZQaVk5RA2Phs66Kb7ie3Dz2c9rNSOJKr7LVpxTZOagCCHV3TqqeQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294098; c=relaxed/simple;
	bh=7UFCfQJMpB3YA4x83RQSpoEZnFCCD4h/KVcFlC4CFOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jD3YZA3YKxXfVgep8EdFhKlITIN1TUvJkz5Xs0B/OBD3ifloXpfLPFX4+4a727xvTuNDKu8DU/lSc7pQgP3xkLKSPB0q5pQCybmLujFXbt1/YWlfgmovMNT9pBP6nPQLRLLI9H8NsDBJRM1AWB4gkM5TufgJk7HqFi6ss6nApbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ix6gwnsB; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-518e2283bd3so4239777e87.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713294095; x=1713898895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zBppzEDS51MDAVFf+oWkcwnoJzt4m+loPuqdwyia2Jo=;
        b=Ix6gwnsBp17GI9XWqJEGaCmE0IbJ1Dk8kBB2XOdm12+dP0ZoM5fv4sqbWb2SFa/sQb
         FqTuQAD7yZrekpEGdkPFGykrAFUcW7JVlXfUeteYSzcOg3kt5ZG87qN7YNeaGctKK8Ri
         peU419r6q9ibdXkH2KFHqf6zKM7+qXgF1KFOp+JcbjtRFZsFxYWyqS5qpGrJRoe/pezD
         weNT3FbynBhzbtxFzQvgFIfzLOD1Q4DVEf5Dmyz4pU3ITTHIjC5XtaPp3QsDA9gd9Xy4
         ZNQE2NYPDoLmUsR73ZhKUewVTGcAHZxKlyRn9Weze5xbnjXh57yQE0OPZF+KsyKFNNfH
         V1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713294095; x=1713898895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zBppzEDS51MDAVFf+oWkcwnoJzt4m+loPuqdwyia2Jo=;
        b=O8xVknRtWOWiJZTytCuA/SUlT82S61WbKUDAO96b9ok3xMlifz2mkFjoTNRPfs/cc6
         NhdFiIrRg/Jjx06ZExWdwj/qXaKCCvUlRDW5/lxbi8KdjAfLaMY8pktzFq4pxG+1E0CO
         XrZ2ZhE78ePMaAVfTU1XZx6mZ0QfPrz47WjFnKOhYxo3RV3v9jD8UpZtCpRn7dlQur8u
         mSCeT4bTZaXK6U+4Je7s3LNdRmOcNddvtHSV4MPWQd5B2sgX2Lcbsy5smsCOeus/Kq1y
         uEHrytsN4QsGC/dHs0eO9axvqQvdRplYE0n38qaNiXAgdR1i7PZ2JtDfMmZqy7q9GHdN
         zsAw==
X-Forwarded-Encrypted: i=1; AJvYcCWkmJDZKxuVL4vHN1OFvbkr0NOf5BsMQ1LbBDXDxV9+L7FhzDVjmRs78QyA7kF61sLif2WI21ow7J+k4MoiyjGrY0Q1
X-Gm-Message-State: AOJu0Yw+wOFC6+CVcIglxgILhcQLLWXmIi3WjvLgCcr2e13y09gQkWTV
	nAJ9HVRyKogyamyrJYm0GJajVaWiq9YxeqQptebyR8DZegdEM1L9euDkeGkkzjM=
X-Google-Smtp-Source: AGHT+IEFR6OBlGzd1sBQXRUUWBXXmlB65DVpuvZEoyWE4Twkpri2X1zpfnKaaW9v57/rJ2UooyCk1g==
X-Received: by 2002:a05:6512:3091:b0:518:dd52:600a with SMTP id z17-20020a056512309100b00518dd52600amr7046791lfd.68.1713294095267;
        Tue, 16 Apr 2024 12:01:35 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id en15-20020a17090728cf00b00a522fb5587esm6391223ejc.144.2024.04.16.12.01.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 12:01:34 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Ani Sinha <anisinha@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH v4 17/22] hw/i386/pc: Remove PCMachineClass::resizable_acpi_blob
Date: Tue, 16 Apr 2024 20:59:33 +0200
Message-ID: <20240416185939.37984-18-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240416185939.37984-1-philmd@linaro.org>
References: <20240416185939.37984-1-philmd@linaro.org>
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
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 include/hw/i386/pc.h |  3 ---
 hw/i386/acpi-build.c | 10 ----------
 hw/i386/pc.c         |  1 -
 3 files changed, 14 deletions(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index df97df6ca7..10a8ffa0de 100644
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
index a6f8203460..ab2d4d8dcb 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -2688,16 +2688,6 @@ void acpi_build(AcpiBuildTables *tables, MachineState *machine)
      * keep the table size stable for all (max_cpus, max_memory_slots)
      * combinations.
      */
-    /* Make sure we have a buffer in case we need to resize the tables. */
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
index 18bef7c85e..c4a7885a3b 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1755,7 +1755,6 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     pcmc->acpi_data_size = 0x20000 + 0x8000;
     pcmc->pvh_enabled = true;
     pcmc->kvmclock_create_always = true;
-    pcmc->resizable_acpi_blob = true;
     x86mc->apic_xrupt_override = true;
     assert(!mc->get_hotplug_handler);
     mc->get_hotplug_handler = pc_get_hotplug_handler;
-- 
2.41.0


