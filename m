Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588EF6D7989
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbjDEKT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237438AbjDEKTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:19:19 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8138A59DE
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:19:05 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o32so20565514wms.1
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0bXZGRuYaUWuS+waIlKd8VQv2t6ejAS6CfkyaECLnt0=;
        b=LIHJIKyuI7acMvt8rBrVg6eWFKgBkrJ3/b0arkph/DUHa0BLbU93H3b1GIwH92R4Zy
         +uvzlTCyUDlYf/j4al5z+wQUHx97GbeXdG9kBiFdMAHyviECH6MqzuY0CNALDN8Ap5Kl
         ApXLzY1U62e1horWK6Vt/U+csJdBfLpJs0pQHuzAzmEZEThhQrNbsPj75PM04Up7HqEo
         3/73NqiS9NmRAA8IVw8pYFlfJUzbpOMYXpCwDL0opeM+q2GUARMOBu22yoM5Hh8oWG8N
         qONWesA/cQ68zjyXExg7MhsK0M/t5sPv8yhjX2pllIkZYpVHgJWQ2hcKuv9wWGPJXdDK
         ogxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0bXZGRuYaUWuS+waIlKd8VQv2t6ejAS6CfkyaECLnt0=;
        b=d2ouzyjWXcQLWWqgpxW+ALr9pWVm7x5CNwkeaqvNLNMPmQDzLSx2DH19tYGacZFZ/y
         5due1HZua921M1JKFqHU5N6hziWYE/Cb7qXFgqj1sA08yrEm3+Oa1OGVyHX7QmWq5BhF
         //2Gk4qaQtyTjhW84gvWPwoo1FAQMmSjalR9rhhGRG4ovT8LWlR3Nnx9KgETLZsMNB8k
         SS1QotFmi7N1FWbdnYINM5JMLNT++SpBkVK0YRmvvurwY97nyMZvt4lHFPNOUEfBnYai
         Ztt6e21IPdJY/GwOgU7lnhZkSOFRaC20/2bhTjMUbwidzBoDdRfm9xiIFrjYNo10n1qk
         Cx+g==
X-Gm-Message-State: AAQBX9clmNtryw8F959F+YmxUNAVYL9o5WmzVlTABBkfZUQcg9cDiU2t
        y/Pl6U8Iv/Nx02EUYO8feh965w==
X-Google-Smtp-Source: AKy350aOrY2Jw4wGetHTWaGkqVDR1/1hOaALytcr5CxarBrtXg4uhD0qN6hOdWeu8PVqJ7zVJHPs0g==
X-Received: by 2002:a7b:ca48:0:b0:3ee:ed5:6115 with SMTP id m8-20020a7bca48000000b003ee0ed56115mr4226349wml.19.1680689943740;
        Wed, 05 Apr 2023 03:19:03 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id f23-20020a7bcd17000000b003eb966d39desm1762763wmj.2.2023.04.05.03.19.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:19:03 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>
Subject: [PATCH 07/14] accel: Rename struct hax_vcpu_state -> struct AccelvCPUState
Date:   Wed,  5 Apr 2023 12:18:04 +0200
Message-Id: <20230405101811.76663-8-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405101811.76663-1-philmd@linaro.org>
References: <20230405101811.76663-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want all accelerators to share the same opaque pointer in
CPUState. Start with the HAX context, renaming its forward
declarated structure 'hax_vcpu_state' as 'AccelvCPUState'.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/cpu.h       | 7 +++----
 target/i386/hax/hax-i386.h  | 3 ++-
 target/i386/nvmm/nvmm-all.c | 2 +-
 target/i386/whpx/whpx-all.c | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 193494cde4..173f47d24e 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -235,8 +235,7 @@ typedef struct SavedIOTLB {
 
 struct KVMState;
 struct kvm_run;
-
-struct hax_vcpu_state;
+struct AccelvCPUState;
 struct hvf_vcpu_state;
 
 /* work queue */
@@ -305,6 +304,7 @@ struct qemu_work_item;
  * @next_cpu: Next CPU sharing TB cache.
  * @opaque: User data.
  * @mem_io_pc: Host Program Counter at which the memory was accessed.
+ * @accel: Pointer to accelerator specific state.
  * @kvm_fd: vCPU file descriptor for KVM.
  * @work_mutex: Lock to prevent multiple access to @work_list.
  * @work_list: List of pending asynchronous work.
@@ -423,6 +423,7 @@ struct CPUState {
     uint32_t can_do_io;
     int32_t exception_index;
 
+    struct AccelvCPUState *accel;
     /* shared by kvm, hax and hvf */
     bool vcpu_dirty;
 
@@ -442,8 +443,6 @@ struct CPUState {
     /* Used for user-only emulation of prctl(PR_SET_UNALIGN). */
     bool prctl_unalign_sigbus;
 
-    struct hax_vcpu_state *accel;
-
     struct hvf_vcpu_state *hvf;
 
     /* track IOMMUs whose translations we've cached in the TCG TLB */
diff --git a/target/i386/hax/hax-i386.h b/target/i386/hax/hax-i386.h
index 3cb3b9bbd0..d11d43e857 100644
--- a/target/i386/hax/hax-i386.h
+++ b/target/i386/hax/hax-i386.h
@@ -25,7 +25,8 @@ typedef HANDLE hax_fd;
 #endif
 
 extern struct hax_state hax_global;
-typedef struct hax_vcpu_state {
+
+typedef struct AccelvCPUState {
     hax_fd fd;
     int vcpu_id;
     struct hax_tunnel *tunnel;
diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index cf4f0af24b..3c7bdd560f 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -995,7 +995,7 @@ nvmm_init_vcpu(CPUState *cpu)
     }
 
     cpu->vcpu_dirty = true;
-    cpu->accel = (struct hax_vcpu_state *)qcpu;
+    cpu->accel = (struct AccelvCPUState *)qcpu;
 
     return 0;
 }
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index d1ad6f156a..70eadb7f05 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -2258,7 +2258,7 @@ int whpx_init_vcpu(CPUState *cpu)
 
     vcpu->interruptable = true;
     cpu->vcpu_dirty = true;
-    cpu->accel = (struct hax_vcpu_state *)vcpu;
+    cpu->accel = (struct AccelvCPUState *)vcpu;
     max_vcpu_index = max(max_vcpu_index, cpu->cpu_index);
     qemu_add_vm_change_state_handler(whpx_cpu_update_state, cpu->env_ptr);
 
-- 
2.38.1

