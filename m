Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E8473A5BB
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 18:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjFVQKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 12:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjFVQK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 12:10:29 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61191FE8
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:10:22 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3fa0253b9e7so8826945e9.1
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687450221; x=1690042221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=op05vfUAX1M3Sv7qs3sw3v39U7zORQkGDmdogVHbS1k=;
        b=CKQGRKk27eSiIm5F19z7Fw+0UvB8mt1EPZLenc8tuPAa4/0aAJ+SnF0zMdupIesuyt
         y+b9HW/Tb6ijXTw+tcPYovJXVtzhbfNQAHL/wbbrJCOYMGhNXzWxJNKlFdQs54AipuBV
         8cK3z0P30nCRdCrWawQrXVeu9fd8c1dzsrKCESqWXQWBZ2c8S9sJc1GYQT088AZSppGP
         tM9c3RZPpYecVoQf4egjUEs3Wad7FFK1rNqFHaM5rarNR1UBzBZNnDECVuKlhKTWdy/n
         Wxo/JJLqZglnWMDLVqm9qi+92fIiIS2+HMnITawdbUIJ6FNynUzzBpy7S6DlXLoEUOiv
         nYDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687450221; x=1690042221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=op05vfUAX1M3Sv7qs3sw3v39U7zORQkGDmdogVHbS1k=;
        b=e+/d4eLv7EhK0omS668WCoRcpVtC1WtmksHip5qf9IEZGNDaKV/ZTQAXvA0utF0aJe
         L03tKQJdrnkyIZWFQCgWuYycx7UAlxJGcVZgVQsQc3j7SNVmg6Efg0hqZqmXgTxLIUhA
         iuNp+aEfK0GfSbiq+JgW2udhgArB7qj4VhwEh1fTC5alpsJo8PepRPxOXD2qx9/BbTp+
         poFU92UMug3e8VW5/Odk5zSPKTOF4byyp9ie8GBa56aRzTx3Ld0spN0cZxzJMg5fp7ty
         q7nFL7nqLEwTfKdDMODY1G4BUPz83ztVgSxnjQCb12J8znk1QXxxQRkymBp6bOEKSj8X
         BuUw==
X-Gm-Message-State: AC+VfDxKYjMlbr3HKciCv4WH1qMyDu8duFeaR2bTwXDih15hMHk/Einv
        cNAgVqMWP9oxhJ3B1NcSJpGxBw==
X-Google-Smtp-Source: ACHHUZ4x7GzIKnUKtsG2jddWduLXgCTnpycV5f8sqghKDDH0II0u9Om2EL3+2MK2AM5jv0n4wk3OZg==
X-Received: by 2002:a05:600c:228e:b0:3f4:2158:28a0 with SMTP id 14-20020a05600c228e00b003f4215828a0mr17454713wmf.12.1687450221295;
        Thu, 22 Jun 2023 09:10:21 -0700 (PDT)
Received: from localhost.localdomain (230.red-88-28-3.dynamicip.rima-tde.net. [88.28.3.230])
        by smtp.gmail.com with ESMTPSA id b10-20020adff24a000000b0030ae901bc54sm7431007wrp.62.2023.06.22.09.10.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Jun 2023 09:10:20 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Reinoud Zandijk <reinoud@netbsd.org>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Alexander Graf <agraf@csgraf.de>,
        Richard Henderson <richard.henderson@linaro.org>,
        xen-devel@lists.xenproject.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v2 11/16] accel: Inline NVMM get_qemu_vcpu()
Date:   Thu, 22 Jun 2023 18:08:18 +0200
Message-Id: <20230622160823.71851-12-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230622160823.71851-1-philmd@linaro.org>
References: <20230622160823.71851-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No need for this helper to access the CPUState::accel field.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/nvmm/nvmm-all.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index e5ee4af084..72a3a9e3ae 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -49,12 +49,6 @@ struct qemu_machine {
 static bool nvmm_allowed;
 static struct qemu_machine qemu_mach;
 
-static AccelCPUState *
-get_qemu_vcpu(CPUState *cpu)
-{
-    return cpu->accel;
-}
-
 static struct nvmm_machine *
 get_nvmm_mach(void)
 {
@@ -86,7 +80,7 @@ nvmm_set_registers(CPUState *cpu)
 {
     CPUX86State *env = cpu->env_ptr;
     struct nvmm_machine *mach = get_nvmm_mach();
-    AccelCPUState *qcpu = get_qemu_vcpu(cpu);
+    AccelCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     struct nvmm_x64_state *state = vcpu->state;
     uint64_t bitmap;
@@ -223,7 +217,7 @@ nvmm_get_registers(CPUState *cpu)
 {
     CPUX86State *env = cpu->env_ptr;
     struct nvmm_machine *mach = get_nvmm_mach();
-    AccelCPUState *qcpu = get_qemu_vcpu(cpu);
+    AccelCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct nvmm_x64_state *state = vcpu->state;
@@ -347,7 +341,7 @@ static bool
 nvmm_can_take_int(CPUState *cpu)
 {
     CPUX86State *env = cpu->env_ptr;
-    AccelCPUState *qcpu = get_qemu_vcpu(cpu);
+    AccelCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     struct nvmm_machine *mach = get_nvmm_mach();
 
@@ -372,7 +366,7 @@ nvmm_can_take_int(CPUState *cpu)
 static bool
 nvmm_can_take_nmi(CPUState *cpu)
 {
-    AccelCPUState *qcpu = get_qemu_vcpu(cpu);
+    AccelCPUState *qcpu = cpu->accel;
 
     /*
      * Contrary to INTs, NMIs always schedule an exit when they are
@@ -395,7 +389,7 @@ nvmm_vcpu_pre_run(CPUState *cpu)
 {
     CPUX86State *env = cpu->env_ptr;
     struct nvmm_machine *mach = get_nvmm_mach();
-    AccelCPUState *qcpu = get_qemu_vcpu(cpu);
+    AccelCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct nvmm_x64_state *state = vcpu->state;
@@ -478,7 +472,7 @@ nvmm_vcpu_pre_run(CPUState *cpu)
 static void
 nvmm_vcpu_post_run(CPUState *cpu, struct nvmm_vcpu_exit *exit)
 {
-    AccelCPUState *qcpu = get_qemu_vcpu(cpu);
+    AccelCPUState *qcpu = cpu->accel;
     CPUX86State *env = cpu->env_ptr;
     X86CPU *x86_cpu = X86_CPU(cpu);
     uint64_t tpr;
@@ -565,7 +559,7 @@ static int
 nvmm_handle_rdmsr(struct nvmm_machine *mach, CPUState *cpu,
     struct nvmm_vcpu_exit *exit)
 {
-    AccelCPUState *qcpu = get_qemu_vcpu(cpu);
+    AccelCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct nvmm_x64_state *state = vcpu->state;
@@ -610,7 +604,7 @@ static int
 nvmm_handle_wrmsr(struct nvmm_machine *mach, CPUState *cpu,
     struct nvmm_vcpu_exit *exit)
 {
-    AccelCPUState *qcpu = get_qemu_vcpu(cpu);
+    AccelCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct nvmm_x64_state *state = vcpu->state;
@@ -686,7 +680,7 @@ nvmm_vcpu_loop(CPUState *cpu)
 {
     CPUX86State *env = cpu->env_ptr;
     struct nvmm_machine *mach = get_nvmm_mach();
-    AccelCPUState *qcpu = get_qemu_vcpu(cpu);
+    AccelCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct nvmm_vcpu_exit *exit = vcpu->exit;
@@ -892,7 +886,7 @@ static void
 nvmm_ipi_signal(int sigcpu)
 {
     if (current_cpu) {
-        AccelCPUState *qcpu = get_qemu_vcpu(current_cpu);
+        AccelCPUState *qcpu = current_cpu->accel;
 #if NVMM_USER_VERSION >= 2
         struct nvmm_vcpu *vcpu = &qcpu->vcpu;
         nvmm_vcpu_stop(vcpu);
@@ -1023,7 +1017,7 @@ void
 nvmm_destroy_vcpu(CPUState *cpu)
 {
     struct nvmm_machine *mach = get_nvmm_mach();
-    AccelCPUState *qcpu = get_qemu_vcpu(cpu);
+    AccelCPUState *qcpu = cpu->accel;
 
     nvmm_vcpu_destroy(mach, &qcpu->vcpu);
     g_free(cpu->accel);
-- 
2.38.1

