Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2077C31F896
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 12:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhBSLqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 06:46:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230308AbhBSLqY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 06:46:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613735098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0vt/SIQERosIkjtlGwMC0PxcViyxR2oXSsZjlPDjv1Q=;
        b=GGDmoaS9jdLKVppjy3ZKiJqKVoTGa3BMQYPgvR4WUxgT0zhp/2bjwOPmyIdkVComj0cWYk
        Ew05+C0ezgQwifztGT6ImAVeGF6xP2DO3FXu4xLC4XPQ+prY1JA9SLqmDTTwxlM+UdWi2E
        5UBkk2GzfXL5QRFuIhg77S6dTklFZy8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-xvpwuQMZPOWuKu5-X_DqXA-1; Fri, 19 Feb 2021 06:44:56 -0500
X-MC-Unique: xvpwuQMZPOWuKu5-X_DqXA-1
Received: by mail-wr1-f70.google.com with SMTP id y6so2316834wrl.9
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 03:44:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0vt/SIQERosIkjtlGwMC0PxcViyxR2oXSsZjlPDjv1Q=;
        b=iz3KSUoYXQyFPtnvAd+kGTaCiBR8qMvC7V07i5H7vcs40vdrtT/n86960rnAGnvKgo
         uSldB5bJ+JEmz2IggCqFDTZ7Y/bPu/epSNJ31n7ivyyJ59W/k65EWVOeC4twxk9Gvux6
         YSzEo4anjNoY3Uqd0vXk2w0cAysIdLlHv8gsN5N+wWOkcY9gc/6oHSx1Fb0SI9aLcYQd
         sY74y+bslcwDyUM4yMmEbCt188X1Yayh6MhhATk74e3/M75BT9Sk+/9oE7r5vueUrdhn
         9A2C9Wucd931AwokaPXfGctZqrdVEy8yQREPUr+bvwlP+nGZ6JSAEhOGGcuqQl7/ysNM
         k04A==
X-Gm-Message-State: AOAM533+ah86hIhf+fyOyTFy4JKwq7m/181S8LiYKvVzrTjDtrOMm8t5
        VTt2cNrhDhHqKdDyjHAY1MHW6bjka+vf3rqwUV3pb8FJMoTgMEPIhRuSFU+akbVsclJRa/+kxS4
        0SBTk3TzlkBTe
X-Received: by 2002:a1c:28c1:: with SMTP id o184mr7567122wmo.183.1613735095191;
        Fri, 19 Feb 2021 03:44:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyKgapT4Wk26+iPVTffeQai1yYGvwGLxBWsJgyU3zvvSdjwgGSG7pAUOZ3XrSXF4+i1f3+P6A==
X-Received: by 2002:a1c:28c1:: with SMTP id o184mr7567079wmo.183.1613735095017;
        Fri, 19 Feb 2021 03:44:55 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id y62sm13962465wmy.9.2021.02.19.03.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 03:44:54 -0800 (PST)
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
Subject: [PATCH 4/7] hw/mips: Set kvm_supported for KVM-compatible machines
Date:   Fri, 19 Feb 2021 12:44:25 +0100
Message-Id: <20210219114428.1936109-5-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219114428.1936109-1-philmd@redhat.com>
References: <20210219114428.1936109-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following MIPS machines support KVM:
- malta
- loongson3-virt

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/mips/loongson3_virt.c | 1 +
 hw/mips/malta.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/hw/mips/loongson3_virt.c b/hw/mips/loongson3_virt.c
index d4a82fa5367..c5ef44819a7 100644
--- a/hw/mips/loongson3_virt.c
+++ b/hw/mips/loongson3_virt.c
@@ -622,6 +622,7 @@ static void loongson3v_machine_class_init(ObjectClass *oc, void *data)
     mc->max_cpus = LOONGSON_MAX_VCPUS;
     mc->default_ram_id = "loongson3.highram";
     mc->default_ram_size = 1600 * MiB;
+    mc->kvm_supported = true;
     mc->kvm_type = mips_kvm_type;
     mc->minimum_page_bits = 14;
 }
diff --git a/hw/mips/malta.c b/hw/mips/malta.c
index 9afc0b427bf..f06bd3eff25 100644
--- a/hw/mips/malta.c
+++ b/hw/mips/malta.c
@@ -1456,6 +1456,7 @@ static void mips_malta_machine_init(MachineClass *mc)
     mc->default_cpu_type = MIPS_CPU_TYPE_NAME("24Kf");
 #endif
     mc->default_ram_id = "mips_malta.ram";
+    mc->kvm_supported = true;
 }
 
 DEFINE_MACHINE("malta", mips_malta_machine_init)
-- 
2.26.2

