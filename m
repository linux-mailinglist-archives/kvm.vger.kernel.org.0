Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A591031F890
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 12:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhBSLqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 06:46:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230308AbhBSLqN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 06:46:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613735087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KroGD2ykh3pOVhGFDhJBF9D2GPtRIz+7OKOBV/uF+8M=;
        b=GJLQTgmi/JFLQPK/vALSqIn5FC6CL/YpjZ722xUmxF2VWzdyP6XITFq8pObi8L8xiSNawI
        gM/i4DdTHnax/bOdIbFkOR9H5HYGzBICc3mB30AE/sMw8/o5NImzHRvJkhn2W6tE1ujNSN
        NDW2GWEmqnpB86CFsFZtp9nzFFcfUZo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-sZr34-H9NKOeEzjLkYRw3w-1; Fri, 19 Feb 2021 06:44:44 -0500
X-MC-Unique: sZr34-H9NKOeEzjLkYRw3w-1
Received: by mail-wm1-f69.google.com with SMTP id i5so366422wmq.0
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 03:44:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KroGD2ykh3pOVhGFDhJBF9D2GPtRIz+7OKOBV/uF+8M=;
        b=oOHUUsFCuoL0ubNm2SB3t4Y8CFh8FV6APhdbXT0CoLFg7ysFN2mDeDDUnACTstP6ZG
         1BbfZ9U1/K2NjglXE8MO9pElEB8snpoErSuTUwOSWLtb0iE6Av2HvOjv9PdJs1jsvMp8
         st1RIbgQ07+I8VNy0J646IyrNoVbvJODXC6MxPGke5ED6ET0LfXucBhQNuSK73wNJOc9
         lcynp10L1G7S9PE67mi9HRM1gA/Kg5rXHLbf9wVDwScAMklWDKgNCARWffF4hInpoC/T
         uoM66pSgQX7aSZMeuQ002Ww7/Gy2LzfLgcRkOeR4pMwd6Ols/Sux84/oQgNy6U96kQeV
         jusg==
X-Gm-Message-State: AOAM533J6jfYr2440qVgM/u1+wgCGVyluu47BWfAiy/FINFKXGnF5Vul
        Gb8XvCnOMESJ7bjlDIf94aYG0sCS58RBD5VCxLK1Tpv36vnKaeDY8hbX7o3GkHrlw8fCMp7YuvG
        08Rpwxn6xAE3y
X-Received: by 2002:adf:b342:: with SMTP id k2mr8775456wrd.264.1613735083595;
        Fri, 19 Feb 2021 03:44:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTU+1RNp+4PgoRKirdLYmchYJdEj6kCfrIRKlfJu5y+NrUB3ZU6NxI5lqZZ59zN2qat0RgFg==
X-Received: by 2002:adf:b342:: with SMTP id k2mr8775447wrd.264.1613735083454;
        Fri, 19 Feb 2021 03:44:43 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id k15sm11528304wmj.6.2021.02.19.03.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 03:44:43 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Radoslaw Biernacki <rad@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
        Greg Kurz <groug@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-arm@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Leif Lindholm <leif@nuviainc.com>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, qemu-ppc@nongnu.org,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 2/7] hw/boards: Introduce 'kvm_supported' field to MachineClass
Date:   Fri, 19 Feb 2021 12:44:23 +0100
Message-Id: <20210219114428.1936109-3-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219114428.1936109-1-philmd@redhat.com>
References: <20210219114428.1936109-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the 'kvm_supported' field to express whether
a machine supports KVM acceleration or not.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/boards.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/hw/boards.h b/include/hw/boards.h
index 68d3d10f6b0..0959aa743ee 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -129,6 +129,8 @@ typedef struct {
  *    Return the type of KVM corresponding to the kvm-type string option or
  *    computed based on other criteria such as the host kernel capabilities
  *    (which can't be negative), or -1 on error.
+ * @kvm_supported:
+ *    true if '-enable-kvm' option is supported and false otherwise.
  * @numa_mem_supported:
  *    true if '--numa node.mem' option is supported and false otherwise
  * @smp_parse:
@@ -209,6 +211,7 @@ struct MachineClass {
     bool nvdimm_supported;
     bool numa_mem_supported;
     bool auto_enable_numa;
+    bool kvm_supported;
     const char *default_ram_id;
 
     HotplugHandler *(*get_hotplug_handler)(MachineState *machine,
-- 
2.26.2

