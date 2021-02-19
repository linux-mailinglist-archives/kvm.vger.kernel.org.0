Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDE531FE17
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 18:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhBSRl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 12:41:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229991AbhBSRlX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 12:41:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LKRfXZiJfNSqbVRL/SaOx1v+Z64xt5w41cSycQqYFFE=;
        b=GTGuLyHKA7H+YnH3Uu3iTtQ+U1LQZZw8r8pYOHnpZIL03nQP/p49zvNtTr6DDEs+FfO339
        MlUeC5k7DORyMQkrLc5Ffofic0/gm+cTparvBsgSG96kk7xy4dAxk/7soqzmcnKrFr6BRW
        FxV1xpM60TxLOKkb6qZSbqJXVYTiFtQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-nhdTZ39JP9Wyt18Uquy96w-1; Fri, 19 Feb 2021 12:39:54 -0500
X-MC-Unique: nhdTZ39JP9Wyt18Uquy96w-1
Received: by mail-wr1-f72.google.com with SMTP id x1so2728756wrg.22
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 09:39:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LKRfXZiJfNSqbVRL/SaOx1v+Z64xt5w41cSycQqYFFE=;
        b=Pxo/OR7j/DWdLzgDfTQVE7vDkehZwpKUZEWpVMQrfm667lYFZIDgpFWpUG9vZR+gf9
         Xs7jnZVyVJBzoctp06XI3kp4v3NxswWEWT0TLVjs5zwsIBLEKfu9NIB7FC8G9Jtai64M
         GyV6UTXBPolVYCmD+h9CCsghJM2N5tMdA77q/cFUn2e17DAGxTcnEPZcNYGivYCsn+kW
         9JJF47oWUPR7gdu+fuTYocgrjizdvnKNooUXbk+ARHrOX0EZ5fHp4urQxyB0tFsz/Bx1
         ZVElgDpWqe9/5DiSdFluajLr4/VNKQ+CnCwA7nG3aQU3xU+wn3g4jkoMavHGCWUKY/r5
         KEpw==
X-Gm-Message-State: AOAM530HlF7zMdm9joF31Qug7y1skiZTDQrB/+02PXHXXPrVRGvgqP9z
        309fWWt6OMaoe+V9mAWJzoLUFzcxT2qOsjBgB1cKb9PLJlZYJv+4UWC1sQ3IURvBVyBDr/kCfZP
        3DKaqYZ3oz2mx
X-Received: by 2002:a1c:4c03:: with SMTP id z3mr9342129wmf.82.1613756393456;
        Fri, 19 Feb 2021 09:39:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx2yrJUDqwa1ymG/2RErXjJWx3WIzkQzNQF90+7ijmcN7yAwa2G2hjcHhwa/T8ilbMl1bPCyw==
X-Received: by 2002:a1c:4c03:: with SMTP id z3mr9342087wmf.82.1613756393314;
        Fri, 19 Feb 2021 09:39:53 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id r7sm15304999wre.25.2021.02.19.09.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:39:52 -0800 (PST)
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
Subject: [PATCH v2 11/11] softmmu/vl: Exit gracefully when accelerator is not supported
Date:   Fri, 19 Feb 2021 18:38:47 +0100
Message-Id: <20210219173847.2054123-12-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219173847.2054123-1-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before configuring an accelerator, check it is valid for
the current machine. Doing so we can return a simple error
message instead of criptic one.

Before:

  $ qemu-system-arm -M raspi2b -enable-kvm
  qemu-system-arm: /build/qemu-ETIdrs/qemu-4.2/exec.c:865: cpu_address_space_init: Assertion `asidx == 0 || !kvm_enabled()' failed.
  Aborted

  $ qemu-system-aarch64 -M xlnx-zcu102 -enable-kvm -smp 6
  qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument

After:

  $ qemu-system-arm -M raspi2b -enable-kvm
  qemu-system-aarch64: invalid accelerator 'kvm' for machine raspi2b

  $ qemu-system-aarch64 -M xlnx-zcu102 -enable-kvm -smp 6
  qemu-system-aarch64: -accel kvm: invalid accelerator 'kvm' for machine xlnx-zcu102

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 softmmu/vl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/softmmu/vl.c b/softmmu/vl.c
index b219ce1f357..f2c4074310b 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -2133,6 +2133,7 @@ static int do_configure_accelerator(void *opaque, QemuOpts *opts, Error **errp)
     const char *acc = qemu_opt_get(opts, "accel");
     AccelClass *ac = accel_find(acc);
     AccelState *accel;
+    MachineClass *mc;
     int ret;
     bool qtest_with_kvm;
 
@@ -2145,6 +2146,12 @@ static int do_configure_accelerator(void *opaque, QemuOpts *opts, Error **errp)
         }
         return 0;
     }
+    mc = MACHINE_GET_CLASS(current_machine);
+    if (!qtest_chrdev && !machine_class_valid_for_accelerator(mc, ac->name)) {
+        *p_init_failed = true;
+        error_report("invalid accelerator '%s' for machine %s", acc, mc->name);
+        return 0;
+    }
     accel = ACCEL(object_new_with_class(OBJECT_CLASS(ac)));
     object_apply_compat_props(OBJECT(accel));
     qemu_opt_foreach(opts, accelerator_set_property,
-- 
2.26.2

