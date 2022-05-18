Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F415852BFEF
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240605AbiERRB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240578AbiERRBZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:01:25 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284CE3151F;
        Wed, 18 May 2022 10:01:24 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id v11so2705586pff.6;
        Wed, 18 May 2022 10:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H6B54qfKCxnxSHyEfUNX3YrSNC1uK+oUERUpX17h73k=;
        b=PKnYJIwTCogXke3WtxPoGPZGLj9YYbN0qFiRuMIC0YahXtBUy/XGcy9hTDkKgwYvir
         WbtRdZhB35Tx8CbMYgTxE9UTwlej9AURpMNOfBgiRKTGbgjafX/frnR2wGKu96kzkop0
         qAyTmuKyQWM0hOJcuQf5f7MRRULJYs+wYBZD4TnTahRaK/PwvfT1sfuxmNrcLE/JXj4n
         qJWHF2bOPkZhTVUSII1vH8FCmCOFqQa0uFGHnPJ7GWgAY2GWFPg+8vFCjqJhXktTrSr0
         pkPTpPQWz3DOfuIlZOnOgt1FZu60kgGXEKNliMk8BPtpzRTyyhXzlk8QGBerLdUITlmC
         4qbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H6B54qfKCxnxSHyEfUNX3YrSNC1uK+oUERUpX17h73k=;
        b=WYJgVMPhFI5xG72iGpxB1xxUpGK6XSYtIElVBv4bmFkcYlhvJ1An/MxwArVZqZGuRp
         iKympo+faXPx86SdJ/g2qvcArLJbLVgizQEMGg2R/9jGOROuroUJga/k96HoXZ9KruGd
         X3zd66RPejw/5MCbDJDmG3FjAvEJ+tByGivODp9OvfhkgQwgEvdscCLCrrAHkV+2BOmu
         OSEmZuozWfxZ4mwn7nuvxwembmQhPExDb9i8SNU2NFesLA0GeFuouCpM06RvQUTlSTmD
         J8jR2PhU3cjutUF9eY/E7nC6i8ApVd8tWjM2XFc5GsO5I/l9aWdMYZzvz6hlp0qHvOZT
         P64g==
X-Gm-Message-State: AOAM533hHR8BN3jPgCO3HmtFmKKXI8+WmAZHky5N/8zeuXl6QEoqKrp4
        mGzpSYH/kI3u/2TZctOoGco=
X-Google-Smtp-Source: ABdhPJxuCvanawtwr+FNXTDXWGpcC9yYYw57LRkbaVIQBC8sFwXm27u7kfda4Tw4uzBQj7EPfF7Bvg==
X-Received: by 2002:a63:f1e:0:b0:3c1:d54f:fc47 with SMTP id e30-20020a630f1e000000b003c1d54ffc47mr343979pgl.51.1652893283621;
        Wed, 18 May 2022 10:01:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id p42-20020a056a0026ea00b0050dc762818dsm2283240pfw.103.2022.05.18.10.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 10:01:23 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86/pmu: Move the vmx_icl_pebs_cpu[] definition out of the header file
Date:   Thu, 19 May 2022 01:01:16 +0800
Message-Id: <20220518170118.66263-1-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Defining a static const array in a header file would introduce redundant
definitions to the point of confusing semantics, and such a use case would
only bring complaints from the compiler:

arch/x86/kvm/pmu.h:20:32: warning: ‘vmx_icl_pebs_cpu’ defined but not used [-Wunused-const-variable=]
   20 | static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
      |                                ^~~~~~~~~~~~~~~~

Fixes: a095df2c5f48 ("KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 7 +++++++
 arch/x86/kvm/pmu.h | 8 --------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b5d0c36b869b..a2eaae85d97b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -16,6 +16,7 @@
 #include <linux/bsearch.h>
 #include <linux/sort.h>
 #include <asm/perf_event.h>
+#include <asm/cpu_device_id.h>
 #include "x86.h"
 #include "cpuid.h"
 #include "lapic.h"
@@ -27,6 +28,12 @@
 struct x86_pmu_capability __read_mostly kvm_pmu_cap;
 EXPORT_SYMBOL_GPL(kvm_pmu_cap);
 
+static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+	{}
+};
+
 /* NOTE:
  * - Each perf counter is defined as "struct kvm_pmc";
  * - There are two types of perf counters: general purpose (gp) and fixed.
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index dbf4c83519a4..ecf2962510e4 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -4,8 +4,6 @@
 
 #include <linux/nospec.h>
 
-#include <asm/cpu_device_id.h>
-
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
@@ -17,12 +15,6 @@
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
-static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
-	{}
-};
-
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
 	u8 unit_mask;
-- 
2.36.1

