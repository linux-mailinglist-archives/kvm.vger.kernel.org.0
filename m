Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECAB63E4D3
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiK3XNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiK3XMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:12:03 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B534B99A
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:28 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l4-20020a170903244400b00188c393fff1so18981965pls.7
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3q8g1I3CG/zN/S6yfEuz3UEYEnVKGNtIkvlUCCz4wMk=;
        b=IzqZX1vpqBRD6eqp/m2lCIonVBr9d0e0dYh+rnORdsBouvRr/LJHoAVFCGYwduLpYW
         OTMMo4gprlzO/u6ojuhJyOc3wk8iW8vMqSUKMIfurZ/dESMUEks0XD0dELDo/XLaovGl
         EKo5NrbtnviyIeCdpV2+U1bLcQY9lYskXKPUNJWsxtd+ecYNZC7sEQkVg+anA/T0XgVe
         YvNoKh5i6BiC33HYuQOVTGAT9N1QTpRLVSSatOGlZCfv03s8ZzOwEte840f58eQcGUDe
         h1+xBUE24TMAZ61kNCycVQsK/JxxPJO1UMM34/IR0XeCfuqHb2uwlievzCRoo9MRdbjv
         0jwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3q8g1I3CG/zN/S6yfEuz3UEYEnVKGNtIkvlUCCz4wMk=;
        b=gfnx0BmsLUqTjUTJKCzkHG9d9LFUWarFUzqAwPKTd28Ip9p8wBITKD8uPIKDsXzb+Y
         ts6LyMXLwIwOO9gfmPi4a+7pE4e2yF5OwiL0JksxTZIfTm+/zzkulhO1A1xA4hQzMXjF
         GdL9n+6n3nK8fJRxuZFqf4FeGayAYEx9iXrbTz9pfukxBKvuWsq2aDJdlBDINKQ10PJD
         I5J8Q/xc0vNI84aM7Xw5RGNOcLYtriU0EVuvOYBPie7z2WzHcap7uv0TwG1IQToVVcBu
         6n5Ir0SiMxGMO+zE4xhCvSTkwsVjjzycApxCTocmPfFkc1DEYaEKJRHYBuzK8d0TG9bq
         yELg==
X-Gm-Message-State: ANoB5pneCnkpXk9MRVh/+xH3f7d68TvFf3spVvIrqCLMKraFtJp74ydU
        exPd9dBTOZ/RcDmGw/bPLNPN7qylIPc=
X-Google-Smtp-Source: AA0mqf4/tiOg+xYgcsoY9u5fwhXNPg1RVdsGA6s6X0UqfvBtJFvF15IrbdNSIgjSxdrgTr0k96rlZxXDdGM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8bc1:0:b0:575:bfb9:b1fa with SMTP id
 s1-20020aa78bc1000000b00575bfb9b1famr7674415pfd.62.1669849810052; Wed, 30 Nov
 2022 15:10:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:03 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-20-seanjc@google.com>
Subject: [PATCH v2 19/50] KVM: arm64: Do arm/arch initialization without
 bouncing through kvm_init()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do arm/arch specific initialization directly in arm's module_init(), now
called kvm_arm_init(), instead of bouncing through kvm_init() to reach
kvm_arch_init().  Invoking kvm_arch_init() is the very first action
performed by kvm_init(), so from a initialization perspective this is a
glorified nop.

Avoiding kvm_arch_init() also fixes a mostly benign bug as kvm_arch_exit()
doesn't properly unwind if a later stage of kvm_init() fails.  While the
soon-to-be-deleted comment about compiling as a module being unsupported
is correct, kvm_arch_exit() can still be called by kvm_init() if any step
after the call to kvm_arch_init() succeeds.

Add a FIXME to call out that pKVM initialization isn't unwound if
kvm_init() fails, which is a pre-existing problem inherited from
kvm_arch_exit().

Making kvm_arch_init() a nop will also allow dropping kvm_arch_init() and
kvm_arch_exit() entirely once all other architectures follow suit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e6f6fcfe6bcc..d3a4db1abf32 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2195,7 +2195,7 @@ void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *cons)
 /**
  * Initialize Hyp-mode and memory mappings on all CPUs.
  */
-int kvm_arch_init(void *opaque)
+int kvm_arm_init(void)
 {
 	int err;
 	bool in_hyp_mode;
@@ -2269,6 +2269,14 @@ int kvm_arch_init(void *opaque)
 		kvm_info("Hyp mode initialized successfully\n");
 	}
 
+	/*
+	 * FIXME: Do something reasonable if kvm_init() fails after pKVM
+	 * hypervisor protection is finalized.
+	 */
+	err = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+	if (err)
+		goto out_subs;
+
 	return 0;
 
 out_subs:
@@ -2281,10 +2289,15 @@ int kvm_arch_init(void *opaque)
 	return err;
 }
 
+int kvm_arch_init(void *opaque)
+{
+	return 0;
+}
+
 /* NOP: Compiling as a module not supported */
 void kvm_arch_exit(void)
 {
-	kvm_unregister_perf_callbacks();
+
 }
 
 static int __init early_kvm_mode_cfg(char *arg)
@@ -2325,10 +2338,4 @@ enum kvm_mode kvm_get_mode(void)
 	return kvm_mode;
 }
 
-static int arm_init(void)
-{
-	int rc = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
-	return rc;
-}
-
-module_init(arm_init);
+module_init(kvm_arm_init);
-- 
2.38.1.584.g0f3c55d4c2-goog

