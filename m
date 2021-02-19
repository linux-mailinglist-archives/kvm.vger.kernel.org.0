Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9731D31FE10
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 18:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhBSRks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 12:40:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhBSRko (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 12:40:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CHXCPuc7uWQdwucv7FWJOUQ8ceg9IO3ZY73rXU3+wF0=;
        b=Q//+IvXATgpteRyAb5zA5a1N4Jbhh7Y/VARQF41rbKKoehBpCZYfXiN3A6qzJk5otpfWBT
        uw5m8qoBe1OPLYjujE3N/rS37CPpwruk1TvjrUAZsP+GZaWmypi55xt1xrlg28tmuTKSY9
        cEK7Zj28mrsA6D3UfjtmIdRRfrUfZo0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-8jm2tcdsOfO0MchGmEInWg-1; Fri, 19 Feb 2021 12:39:14 -0500
X-MC-Unique: 8jm2tcdsOfO0MchGmEInWg-1
Received: by mail-wm1-f72.google.com with SMTP id p8so2768848wmq.7
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 09:39:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CHXCPuc7uWQdwucv7FWJOUQ8ceg9IO3ZY73rXU3+wF0=;
        b=Ro4rr+fur67r4yuNTsPp/5fSIuLhbA9QdRw8ry/SciD43Wmzqy9pD3Mw6Z/edKozhd
         xO2RHdpTkWcHY/PvWwP5D0d5VdmKCRk+HZFSOeYrHuhpCDh1zBzxHO1qrL/n56qV40na
         qcCYc8oJzqMozwpQtph+zlZfQ+2HNpKECjYOrJBOzZXHGFnuWEEt6lcYYualqf5IBwdo
         NW9jXf4XV+vgUv8i7EpBfi0ENgB7G3yvy8qtcy1Ppk2NWtW13AzoqlMpqSPhcUKql7LZ
         qj3FXf/2Z67+3aeGRkaB3jr8dPfc/GqMpz8rErMvWZ1NkRaq4+JoSMJOpf37SfR1ewPd
         gJ+w==
X-Gm-Message-State: AOAM531m9bMouxHI8pLh5grMzz2wkESxoG/0o5oCR9Lyg4qD3WrbtcUL
        S5SxY4uRnmXJMVukc1GVWn0Ls95dZ0WKBbHm0l9kLLu0A5xKNP6gMT23FUV7BHDOltXxvRcYoMM
        6Vmt00kHjRnX6
X-Received: by 2002:a05:6000:188c:: with SMTP id a12mr10610942wri.105.1613756353508;
        Fri, 19 Feb 2021 09:39:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwrzSzq1o4kGieINb1Q744LtUd4TVffu+lfi/YVrFtocFVQ1Ale5KqgmXk7Upte5EwmyzFbHA==
X-Received: by 2002:a05:6000:188c:: with SMTP id a12mr10610915wri.105.1613756353383;
        Fri, 19 Feb 2021 09:39:13 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id q20sm12010000wmc.14.2021.02.19.09.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:39:12 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 04/11] hw/arm: Restrit KVM to the virt & versal machines
Date:   Fri, 19 Feb 2021 18:38:40 +0100
Message-Id: <20210219173847.2054123-5-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219173847.2054123-1-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restrit KVM to the following ARM machines:
- virt
- xlnx-versal-virt

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/arm/virt.c             | 5 +++++
 hw/arm/xlnx-versal-virt.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 371147f3ae9..8e9861b61a9 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2527,6 +2527,10 @@ static HotplugHandler *virt_machine_get_hotplug_handler(MachineState *machine,
     return NULL;
 }
 
+static const char *const valid_accels[] = {
+    "tcg", "kvm", "hvf", NULL
+};
+
 /*
  * for arm64 kvm_type [7-0] encodes the requested number of bits
  * in the IPA address space
@@ -2582,6 +2586,7 @@ static void virt_machine_class_init(ObjectClass *oc, void *data)
     mc->cpu_index_to_instance_props = virt_cpu_index_to_props;
     mc->default_cpu_type = ARM_CPU_TYPE_NAME("cortex-a15");
     mc->get_default_cpu_node_id = virt_get_default_cpu_node_id;
+    mc->valid_accelerators = valid_accels;
     mc->kvm_type = virt_kvm_type;
     assert(!mc->get_hotplug_handler);
     mc->get_hotplug_handler = virt_machine_get_hotplug_handler;
diff --git a/hw/arm/xlnx-versal-virt.c b/hw/arm/xlnx-versal-virt.c
index 8482cd61960..d424813cae1 100644
--- a/hw/arm/xlnx-versal-virt.c
+++ b/hw/arm/xlnx-versal-virt.c
@@ -610,6 +610,10 @@ static void versal_virt_machine_instance_init(Object *obj)
 {
 }
 
+static const char *const valid_accels[] = {
+    "tcg", "kvm", NULL
+};
+
 static void versal_virt_machine_class_init(ObjectClass *oc, void *data)
 {
     MachineClass *mc = MACHINE_CLASS(oc);
@@ -621,6 +625,7 @@ static void versal_virt_machine_class_init(ObjectClass *oc, void *data)
     mc->default_cpus = XLNX_VERSAL_NR_ACPUS;
     mc->no_cdrom = true;
     mc->default_ram_id = "ddr";
+    mc->valid_accelerators = valid_accels;
 }
 
 static const TypeInfo versal_virt_machine_init_typeinfo = {
-- 
2.26.2

