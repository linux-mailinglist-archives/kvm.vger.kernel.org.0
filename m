Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA6E529290
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 23:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiEPVKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 17:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349266AbiEPVJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 17:09:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4598443ED3
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652734416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jj+1GdC5ed9RjG2w4YTgAyI/dqT/LcafZe1Q5l3sISU=;
        b=aOk/sl2mjhIhgAroI5m7xmaJJNgxyx8nnpNUu+mP9aWHsRAkz69n1QcLIBJVqvmvmUatLx
        4Vt+g8lRtrTAuQD/P8v46Ya6YOxFjk8WWA1HXjqwnZqP5mqe9a5lLdfKR91IHVlbELd1lH
        BpYPgaDoXJZH1ba+/w80RpsiM0ANOf0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-rLlTUfQWPZybssLda8uPbQ-1; Mon, 16 May 2022 16:53:35 -0400
X-MC-Unique: rLlTUfQWPZybssLda8uPbQ-1
Received: by mail-ej1-f69.google.com with SMTP id gn26-20020a1709070d1a00b006f453043956so6339785ejc.15
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:53:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jj+1GdC5ed9RjG2w4YTgAyI/dqT/LcafZe1Q5l3sISU=;
        b=XXNdFj4uR3y7Cp7Sz3eI7LPx8cl1Ba1hyISKPwDEWLds1Q2+YD7oNlZcM5bGuUWre6
         sBrTi+3FZ1Txlc7wDQJrOQ+r9bt9rxZPJYzWu2KrNOZMhqGjhwnjO2/x94SWZPMCYZBJ
         CmFZUU/8UxFo3gTdzGxbLBKiR1j9H63MI67jpWiAYWoyTIeTVUH79abIynCaBiMC7RZ/
         vSXAhDEi7uOHS/69Sh/d+OiNrkSiL4Yy3eo+C29H1a7d+PyAzP+Fnjl4Qx1519rQm7yP
         8Pb/VlpbN6adjTz9iAbPdgxwIfNtiIuSGGPOXGa0qc4Iye85Sd/X9fk8yXry2qtZz/bX
         kpxw==
X-Gm-Message-State: AOAM531OA/qYuAZXWZUjm+SG6dWUibn72YoeknWAd88mMPi1eMn7DZDn
        PNYSdnkODOY6OlQQ1tpQV8Txpq/NW6pmelVyIlLNlzYD4YnC4RK4VPKkGOif/3+rp0cJm0yi1Sn
        pE2WqWvFTCKgH
X-Received: by 2002:a50:ea8b:0:b0:428:7d05:eb7e with SMTP id d11-20020a50ea8b000000b004287d05eb7emr14878210edo.185.1652734413854;
        Mon, 16 May 2022 13:53:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2KCqWfRikajj4wIQWOtpCghzr69gRHuvpcIhTWpWoTu9HLy2ox3hPwr0mjBMz5Umcz1ed7Q==
X-Received: by 2002:a50:ea8b:0:b0:428:7d05:eb7e with SMTP id d11-20020a50ea8b000000b004287d05eb7emr14878187edo.185.1652734413670;
        Mon, 16 May 2022 13:53:33 -0700 (PDT)
Received: from redhat.com ([2.55.131.38])
        by smtp.gmail.com with ESMTPSA id g26-20020a056402181a00b0042617ba638esm5627992edy.24.2022.05.16.13.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 13:53:33 -0700 (PDT)
Date:   Mon, 16 May 2022 16:53:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Claudio Fontana <cfontana@suse.de>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PULL v2 49/86] target/i386: Fix sanity check on max APIC ID /
 X2APIC enablement
Message-ID: <20220516204913.542894-50-mst@redhat.com>
References: <20220516204913.542894-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516204913.542894-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>

The check on x86ms->apic_id_limit in pc_machine_done() had two problems.

Firstly, we need KVM to support the X2APIC API in order to allow IRQ
delivery to APICs >= 255. So we need to call/check kvm_enable_x2apic(),
which was done elsewhere in *some* cases but not all.

Secondly, microvm needs the same check. So move it from pc_machine_done()
to x86_cpus_init() where it will work for both.

The check in kvm_cpu_instance_init() is now redundant and can be dropped.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Claudio Fontana <cfontana@suse.de>
Message-Id: <20220314142544.150555-1-dwmw2@infradead.org>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 hw/i386/pc.c              |  8 --------
 hw/i386/x86.c             | 16 ++++++++++++++++
 target/i386/kvm/kvm-cpu.c |  2 +-
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 312eb9e400..15f37d8dc6 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -744,14 +744,6 @@ void pc_machine_done(Notifier *notifier, void *data)
         /* update FW_CFG_NB_CPUS to account for -device added CPUs */
         fw_cfg_modify_i16(x86ms->fw_cfg, FW_CFG_NB_CPUS, x86ms->boot_cpus);
     }
-
-
-    if (x86ms->apic_id_limit > 255 && !xen_enabled() &&
-        !kvm_irqchip_in_kernel()) {
-        error_report("current -smp configuration requires kernel "
-                     "irqchip support.");
-        exit(EXIT_FAILURE);
-    }
 }
 
 void pc_guest_info_init(PCMachineState *pcms)
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 79ebdface6..f79e720cc2 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -38,6 +38,7 @@
 #include "sysemu/replay.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/cpu-timers.h"
+#include "sysemu/xen.h"
 #include "trace.h"
 
 #include "hw/i386/x86.h"
@@ -122,6 +123,21 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
      */
     x86ms->apic_id_limit = x86_cpu_apic_id_from_index(x86ms,
                                                       ms->smp.max_cpus - 1) + 1;
+
+    /*
+     * Can we support APIC ID 255 or higher?
+     *
+     * Under Xen: yes.
+     * With userspace emulated lapic: no
+     * With KVM's in-kernel lapic: only if X2APIC API is enabled.
+     */
+    if (x86ms->apic_id_limit > 255 && !xen_enabled() &&
+        (!kvm_irqchip_in_kernel() || !kvm_enable_x2apic())) {
+        error_report("current -smp configuration requires kernel "
+                     "irqchip and X2APIC API support.");
+        exit(EXIT_FAILURE);
+    }
+
     possible_cpus = mc->possible_cpu_arch_ids(ms);
     for (i = 0; i < ms->smp.cpus; i++) {
         x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 5eb955ce9a..7237378a7d 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -171,7 +171,7 @@ static void kvm_cpu_instance_init(CPUState *cs)
         /* only applies to builtin_x86_defs cpus */
         if (!kvm_irqchip_in_kernel()) {
             x86_cpu_change_kvm_default("x2apic", "off");
-        } else if (kvm_irqchip_is_split() && kvm_enable_x2apic()) {
+        } else if (kvm_irqchip_is_split()) {
             x86_cpu_change_kvm_default("kvm-msi-ext-dest-id", "on");
         }
 
-- 
MST

